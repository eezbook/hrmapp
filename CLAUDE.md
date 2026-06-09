# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Run (development)
```
flutter run -d <device_id> --flavor dev -t lib/main_dev.dart
flutter run -d <device_id> --flavor staging -t lib/main_staging.dart
flutter run -d <device_id> --flavor prod -t lib/main_production.dart
```
List available devices: `flutter devices`

### Build APK
```
flutter build apk --flavor dev -t lib/main_dev.dart
flutter build apk --flavor prod -t lib/main_production.dart
```

### Code generation (required after editing models, datasources, or freezed classes)
```
flutter pub run build_runner build --delete-conflicting-outputs
```
Generated files have `.freezed.dart` and `.g.dart` suffixes — never edit them manually.

### Tests
```
flutter test                              # all tests
flutter test test/path/to/test_file.dart  # single file
```

### Lint
```
flutter analyze
```

## Architecture

The app uses **Clean Architecture** per feature with strict layer separation:

```
lib/
  features/<feature>/
    data/
      datasources/   # Retrofit-generated API clients (*_remote_datasource.dart)
      models/        # Freezed + JSON-serializable API models (*_model.dart)
      repositories/  # Implements domain repository interface
    domain/
      entities/      # Plain Dart classes (no JSON/Retrofit dependency)
      repositories/  # Abstract interface
      usecases/      # Single-responsibility use cases (auth only; other features call repos directly)
    presentation/
      bloc/ or cubit/  # State management
      pages/           # Full-screen widgets
      widgets/         # Feature-scoped widgets
  core/
    api/           # DioClient, interceptors (auth, refresh, error)
    config/        # AppConfig (flavor/env values), RouteNames
    di/            # GetIt wiring — all singletons/factories registered in injection.dart
    router/        # AppRouter (GoRouter) + bottom nav shell
    services/      # NotificationService, BiometricService
    storage/       # HiveStorage (cache), SecureStorage (tokens)
    permissions/   # HrmPermissions — role-based access, loaded from server on login
    theme/         # AppColors, AppTextStyles, AppSpacing, AppTheme
    widgets/       # Shared widgets (AppButton, AppScaffold, StatusPill, ShimmerLoader, etc.)
```

## Features

Nine features currently exist under `lib/features/`:

| Feature | State mgmt | Notes |
|---|---|---|
| `auth` | Bloc | Login, token refresh, biometric lock |
| `dashboard` | Cubit | Summary cards + module grid |
| `leave` | Bloc + Cubits | Apply, balance, requests list, approvals, team calendar |
| `attendance` | Cubit | Check-in/out with geo-fence |
| `travel` | Bloc | Travel requests + approvals |
| `overtime` | Cubit | OT requests list |
| `training` | Bloc | Course list, video player with position resume |
| `notifications` | Cubit | Push notification inbox |
| `profile` | Cubit | View/edit personal profile |

## Key Design Decisions

**Flavors & env config**: Each entry point (`main_dev.dart`, `main_staging.dart`, `main_production.dart`) loads the corresponding `.env.*` file and calls `AppConfig.initialize()` before `runHrmApp()`. `AppConfig` is a static singleton — always read config from it, never from dotenv directly after startup.

**Dependency injection**: Everything is wired in `lib/core/di/injection.dart` using GetIt. BLoCs/Cubits are registered as `registerFactory` (new instance per use), core services as `registerSingleton`. `AppRouter` is a singleton because it holds navigation state. BLoC instances are provided at the route level in `AppRouter`, not at the widget level.

**Navigation**: GoRouter with a redirect guard that reacts to `AuthBloc` stream. The shell route wraps all authenticated routes in `BiometricLockObserver` + bottom nav. Bottom nav items are filtered by `HrmPermissions` at render time; route-level `redirect` guards also check permissions.

**Permissions**: `HrmPermissions` is a static class loaded from the server on login and cached in Hive. It controls both which bottom nav tabs appear and which routes are accessible. Call `HrmPermissions.load()` after login, `HrmPermissions.loadFromHive()` on app resume.

**API layer**: `DioClient` attaches `AuthInterceptor` (injects Bearer token + device-id header), `RefreshInterceptor` (retries on 401 with token refresh), and `ErrorInterceptor` (maps HTTP errors to `Failure` types). `LogInterceptor` is only added when `AppConfig.isDev` is true. All API clients are Retrofit-generated; after adding/changing a `@RestApi` method, run build_runner.

**State**: Features with complex multi-step flows use `Bloc` (leave, travel, auth, training). Simpler read-heavy screens use `Cubit` (dashboard, overtime, assessment sub-flows, video player progress). Error states carry `Failure` objects from `dartz` `Either` returns in repositories.

**Local storage**: Hive boxes are opened at startup (`HiveStorage.openBoxes()`). Use named box accessors (`HiveStorage.employee`, `HiveStorage.permissions`, etc.) rather than `Hive.box()` directly. Tokens (access + refresh) go to `SecureStorage` only. Training video positions are stored in Hive with key `video_position_{courseId}`.

## Repository Variants

Two patterns exist depending on feature complexity:

**Full Clean Architecture** (leave, travel, auth): Remote datasource returns models → repository maps models to domain entities and returns `Either<Failure, Entity>` → BLoC calls repository. Use this when the feature has approvals, pagination, or needs abstraction between API shape and UI shape.

**Simplified (no domain layer)** (training, dashboard, overtime): Remote datasource returns models → BLoC/Cubit calls datasource directly, no entity mapping layer. Use this for simpler read-heavy features. Training uses a Bloc (complex events) but skips the domain layer entirely.

## API Response Contract

All endpoints return `ApiResponse<T>` (freezed):
```dart
ApiResponse<T> { success, data, message, errors (Map), meta (PaginationMeta?) }
PaginationMeta { currentPage, lastPage, total, perPage, nextPageUrl, prevPageUrl }
```

For paginated lists, the BLoC emits a `LoadMore` event to fetch the next page and appends to the existing list. Check `meta.nextPageUrl != null` (or `hasMore`) before emitting a load-more event.

For multipart uploads (e.g., expense receipts), use `@MultiPart()` + `@Part()` annotations in the Retrofit datasource. The `DioClient` instance handles multipart automatically.

## Error Handling

`ErrorInterceptor` classifies HTTP errors into typed `Failure` subclasses: `NetworkFailure`, `AuthFailure`, `ValidationFailure`, `PermissionFailure`, `ServerFailure`, `NotFoundFailure`. Each carries a `message` and optional `hrmErrorCode`/validation error map. BLoC/Cubit states always emit the typed `Failure` — never raw exceptions. Wrap non-HTTP errors with `ErrorHandler.handle()`.

## UI Conventions

**Color palette** (used across feature headers):
- Navy primary: `0xFF1B2064`
- Purple accent: `0xFF7367F0`
- Golden CTA: `0xFFF5A623`
- Page background: `0xFFF5F7FF`

**Feature home page pattern**: Navy/purple header bar with employee name + avatar + notification bell, custom tab row below, page background is light blue-white (`0xFFF5F7FF`). The header is built per-feature (not a shared widget) but follows this structure consistently.

**Shared widgets** (all in `lib/core/widgets/`): `AppButton`, `AppScaffold`, `StatusPill` (leave/travel status badges), `ShimmerLoader` (skeleton loading), `EmptyState`.

**Forms**: `InputDecoration` is configured via `AppTheme` — do not override `border` or `fillColor` inline. Use `AppSpacing.sm/md/lg` for all vertical gaps. Error messages render in an `errorContainer` banner with an `error_outline` icon; never use `showDialog` for inline form errors.

## Leave Feature — Apply Leave Form

File: `lib/features/leave/presentation/pages/apply_leave_page.dart`

### Widget order (top → bottom)
1. Leave Type dropdown + Balance chip (inline row)
2. TableCalendar date picker (range or single-day)
3. Date summary card (date range label + total days count)
4. Day Type `SegmentedButton` — only shown when a single day is selected (`_isSingleDay == true`)
5. Reason / Narration `TextFormField` (max 2000 chars, `Validators.reason` min 10)
6. Narration suggestion chips (`ActionChip` Wrap) — 12 preset reasons, tap to populate the field
7. Send for Approval dropdown (`Save as Draft` = 0 / `Send for Approval` = 1, default 1)
8. Error banner (only when `_error != null`)
9. Submit button (`AppButton`)

### Half-day logic
- `_dayType`: 0 = Full Day, 1 = 1st Half, 2 = 2nd Half
- `_isHalfDay = _dayType != 0`
- Day Type selector is only rendered when `_isSingleDay` is true; selecting a range auto-resets `_dayType` to 0
- When `_isHalfDay`, the calendar switches to `RangeSelectionMode.disabled` + `onDaySelected` (single-day only mode)
- Submits `is_half_day: true` + `half_day_session: 'morning'|'afternoon'`

### Submit validations (in order)
1. `_formKey.currentState!.validate()` — catches empty/short reason
2. `_startDate == null || _endDate == null` → "Please select leave dates"
3. `_isHalfDay && !_isSingleDay` → "1st/2nd half leave must be for a single day only"
4. `_calculatedDays == 0` → "Selected date range contains no working days"

### Narration suggestions
Static list of 12 common reasons (`_narrationSuggestions`). Tapping a chip sets `_reasonCtrl.text` and moves the cursor to end. Current list:
`Feeling unwell / sick`, `Medical appointment`, `Family emergency`, `Personal work`, `Out of town / travel`, `Child care duty`, `Urgent household matter`, `Religious observance`, `Wedding / family function`, `Rest and recovery`, `Mental health day`, `Home maintenance / repair`.

### Calendar behaviour
- `enabledDayPredicate` blocks Saturday, Sunday, and any date in `_holidays` (ISO strings fetched from API)
- First tap sets `_startDate = _endDate = tapped day` and `_awaitingRangeEnd = true` (calendar stays open for second tap)
- Second tap confirms range or same-day; if multi-day `_dayType` resets to 0
- Switching to half-day mode (`_isHalfDay`) passes `rangeEndDay: null` so the calendar doesn't paint a range highlight

### Leave home page tabs
`LeaveHomePage` (`lib/features/leave/presentation/pages/leave_home_page.dart`) has two tabs driven by a `TabController`:
- **Tab 0** — `LeaveBalanceTab` (balance cards via `LeaveBalanceCubit`)
- **Tab 1** — `LeaveRequestsTab` (paginated list via `LeaveRequestsCubit`)

`HrmPermissions.canApplyLeave` gates the FAB that navigates to `ApplyLeavePage`.

## Web Companion (CloudERP) — Leave Settings

The Flutter app pairs with the **CloudERP** Laravel web application at `C:\wamp64\www\clouderp`.

### Employee HRM & Payroll settings
Route: `settings.company_master.employee.employees_detail.app-employee-hrm-payroll`
Controller: `EmployeeController::hrm_payroll()` / `update_hrm_payroll()`
Blade: `resources/views/settings/company_master/employee/employees_detail/app-employee-hrm-payroll.blade.php`
JS: `resources/assets/js/settings_js/company_master/employee/app-employee-hrm-payroll.js`

Three employee-level override cards (each stores to a column on the `employees` table):

| Card | DB column | Behaviour when null |
|---|---|---|
| **Weekends** | `weekends` (JSON int array) | Falls back to company default weekends |
| **Leave Verifiers** | `leave_verifiers` (JSON `{verifier_1, verifier_2}`) | Falls back to company default verifiers |
| **Work Location** | `work_location` (JSON lat/lng/radius) | Falls back to company office geo-fence |

**Leave Verifiers card**: V1 and V2 are ajax-select2 dropdowns (users endpoint). V2 is disabled until V1 is set. Clearing V1 also clears V2. Saving stores `{verifier_1: id, verifier_2: id|null}` or `null` (use company default) to `leave_verifiers`.

### Company HRM & Payroll settings
Route: `hrm_payroll.settings.add_update_config`
Controller: `HrmPayrollSettingsController::add_update_config()`
JS: `resources/assets/js/settings_js/system_setup/company_profiles/pages-hrm-and-payroll-settings-config.js`

When saving, the JS performs change detection before sending. Save flow (in order):

1. **No changes** → info toast, abort
2. **Verifier 1 cleared** → SweetAlert warning (clearing V1 removes V2 too)
3. **Verifiers changed** → 3-option SweetAlert:
   - *Yes, reset all employee verifiers* — saves company verifiers + sets all employees' `leave_verifiers = null`
   - *Change company only* — saves company verifiers, keeps employee overrides
   - *Cancel* — aborts
4. **Location changed** → 2-option SweetAlert: reset all employee custom locations or company only
5. **Weekends changed** → type-YES confirmation, then optionally propagates to all employees

Server-side flag `reset_employee_verifiers=1` triggers nulling out `leave_verifiers` on all company employees.

## Known Setup Issue

`android/app/google-services.json` contains placeholder values — Firebase Messaging will throw an unhandled exception on startup. Replace it with a real Firebase project config before running. The crash originates in `NotificationService._setupFcm` at `FirebaseMessaging.instance.getToken()`.
