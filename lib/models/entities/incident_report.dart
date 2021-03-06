import 'package:intl/intl.dart';

class IncidentReportImage {
  String id;
  String filePath;

  IncidentReportImage({required this.id, required this.filePath});

  factory IncidentReportImage.fromJson(Map<String, dynamic> json) =>
      IncidentReportImage(
        id: json["id"],
        filePath: json["file"],
      );
}

class IncidentReport {
  String id;
  Map<String, dynamic>? data;
  String description;
  String reportTypeName;
  DateTime incidentDate;
  DateTime createdAt;
  DateTime updatedAt;
  String? gpsLocation;
  List<IncidentReportImage>? images;

  IncidentReport({
    required this.id,
    this.data,
    required this.description,
    required this.reportTypeName,
    required this.incidentDate,
    required this.createdAt,
    required this.updatedAt,
    this.gpsLocation,
    this.images,
  });

  factory IncidentReport.fromJson(Map<String, dynamic> json) {
    return IncidentReport(
      id: json["id"],
      description: json["rendererData"],
      reportTypeName: (json["reportType"] as Map)["name"],
      incidentDate: DateFormat("yyyy-MM-dd").parse(json["incidentDate"]),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      gpsLocation: json["gpsLocation"],
      data: json["data"],
      images: json["images"] != null
          ? (json["images"] as List)
              .map((image) => IncidentReportImage.fromJson(image))
              .toList()
          : [],
    );
  }
}
