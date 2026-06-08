import 'company_location_model.dart';

class AttendanceLocationsModel {
  final CompanyLocationModel? office;
  final CompanyLocationModel? home;

  const AttendanceLocationsModel({this.office, this.home});

  factory AttendanceLocationsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceLocationsModel(
      office: json['office'] != null
          ? CompanyLocationModel.fromJson(json['office'] as Map<String, dynamic>)
          : null,
      home: json['home'] != null
          ? CompanyLocationModel.fromJson(json['home'] as Map<String, dynamic>)
          : null,
    );
  }
}
