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

## Known Setup Issue

`android/app/google-services.json` contains placeholder values — Firebase Messaging will throw an unhandled exception on startup. Replace it with a real Firebase project config before running. The crash originates in `NotificationService._setupFcm` at `FirebaseMessaging.instance.getToken()`.
