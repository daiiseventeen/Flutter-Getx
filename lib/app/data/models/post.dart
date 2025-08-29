// lib/app/data/models/post_model.dart
import 'dart:convert';

// To parse this JSON data, do
//     final postResponse = postResponseFromJson(jsonString);
PostResponse postResponseFromJson(String str) => PostResponse.fromJson(json.decode(str));
String postResponseToJson(PostResponse data) => json.encode(data.toJson());

class PostResponse {
    List<PostModel>? data;
    String? message;
    bool? success;

    PostResponse({
        this.data,
        this.message,
        this.success,
    });

    factory PostResponse.fromJson(Map<String, dynamic> json) => PostResponse(
        data: json["data"] == null ? [] : List<PostModel>.from(json["data"]!.map((x) => PostModel.fromJson(x))),
        message: json["message"],
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "success": success,
    };
}

class PostModel {
    int? id;
    String? title;
    String? content;
    String? slug;
    int? status;
    String? foto;
    DateTime? createdAt;
    DateTime? updatedAt;

    PostModel({
        this.id,
        this.title,
        this.content,
        this.slug,
        this.status,
        this.foto,
        this.createdAt,
        this.updatedAt,
    });

    factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        slug: json["slug"],
        status: json["status"],
        foto: json["foto"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "slug": slug,
        "status": status,
        "foto": foto,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}