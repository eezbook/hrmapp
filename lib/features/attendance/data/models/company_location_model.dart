class CompanyLocationModel {
  final double latitude;
  final double longitude;
  final double radius; // metres
  final String locationName;

  const CompanyLocationModel({
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.locationName,
  });

  factory CompanyLocationModel.fromJson(Map<String, dynamic> json) {
    return CompanyLocationModel(
      latitude: (json['latitude'] ?? json['lat'] as num).toDouble(),
      longitude: (json['longitude'] ?? json['lng'] as num).toDouble(),
      radius: ((json['radius'] as num?) ?? 100).toDouble(),
      locationName: (json['location_name'] ?? json['name'] ?? '') as String,
    );
  }
}
