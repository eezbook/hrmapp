import 'company_location_model.dart';

class AttendanceLocationsModel {
  final CompanyLocationModel? office;
  final CompanyLocationModel? home;
  final bool allowLocationUpdate;

  const AttendanceLocationsModel({
    this.office,
    this.home,
    this.allowLocationUpdate = false,
  });

  factory AttendanceLocationsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceLocationsModel(
      office: json['office'] != null
          ? CompanyLocationModel.fromJson(json['office'] as Map<String, dynamic>)
          : null,
      home: json['home'] != null
          ? CompanyLocationModel.fromJson(json['home'] as Map<String, dynamic>)
          : null,
      allowLocationUpdate: (json['allowLocationUpdate'] as bool?) ?? false,
    );
  }
}
