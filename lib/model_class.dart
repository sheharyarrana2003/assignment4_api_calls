import 'dart:convert';

List<AlbumDetails> albumDetailsFromJson(String str) => List<AlbumDetails>.from(json.decode(str).map((x) => AlbumDetails.fromJson(x)));

String albumDetailsToJson(List<AlbumDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AlbumDetails {
  int userId;
  int id;
  String title;

  AlbumDetails({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory AlbumDetails.fromJson(Map<String, dynamic> json) => AlbumDetails(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
  };
}
