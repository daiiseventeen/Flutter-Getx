class Post {
  final int? id;
  final int? userId;
  final String? title;
  final String? body;
  final DateTime? createdAt;
  final bool isLiked;
  final int likeCount;

  Post({
    this.id,
    this.userId,
    this.title,
    this.body,
    this.createdAt,
    this.isLiked = false,
    this.likeCount = 0,
  });

  /// Create Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isLiked: json['isLiked'] as bool? ?? false,
      likeCount: json['likeCount'] as int? ?? 0,
    );
  }

  /// Convert Post to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'createdAt': createdAt?.toIso8601String(),
      'isLiked': isLiked,
      'likeCount': likeCount,
    };
  }

  /// Create a copy of Post with modified fields
  Post copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isLiked,
    int? likeCount,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
    );
  }

  /// Get formatted date string
  String get formattedDate {
    if (createdAt == null) return 'Unknown date';
    
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    
    if (difference.inDays > 7) {
      return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Get short preview of body (for list view)
  String get bodyPreview {
    if (body == null || body!.isEmpty) return 'No content';
    
    if (body!.length <= 100) return body!;
    
    return '${body!.substring(0, 100)}...';
  }

  /// Get estimated reading time
  String get readingTime {
    if (body == null || body!.isEmpty) return '1 min read';
    
    final wordCount = body!.split(' ').length;
    final minutes = (wordCount / 200).ceil(); // Average 200 words per minute
    
    return '${minutes} min read';
  }

  @override
  String toString() {
    return 'Post{id: $id, userId: $userId, title: $title, body: ${body?.substring(0, 50)}...}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Post &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.body == body;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        body.hashCode;
  }
}