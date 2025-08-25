class WidgetModel {
  final String? id;
  final String? title;
  final String? description;
  final String? content;
  final String? assetClass;
  final String? authorId;
  final String? authorName;
  final String? authorUsername;
  final String? authorProfileImage;
  final int? likesCount;
  final int? viewsCount;
  final int? commentsCount;
  final int? sharesCount;
  final bool? isLiked;
  final bool? isSaved;
  final bool? isFollowing;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? visibility;
  final List<String>? tags;
  final Map<String, dynamic>? metadata;
  
  WidgetModel({
    this.id,
    this.title,
    this.description,
    this.content,
    this.assetClass,
    this.authorId,
    this.authorName,
    this.authorUsername,
    this.authorProfileImage,
    this.likesCount,
    this.viewsCount,
    this.commentsCount,
    this.sharesCount,
    this.isLiked,
    this.isSaved,
    this.isFollowing,
    this.createdAt,
    this.updatedAt,
    this.visibility,
    this.tags,
    this.metadata,
  });
  
  factory WidgetModel.fromJson(Map<String, dynamic> json) {
    return WidgetModel(
      id: json['id'] ?? json['_id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      assetClass: json['assetClass'] ?? json['asset_class'],
      authorId: json['authorId'] ?? json['author_id'] ?? json['userId'],
      authorName: json['authorName'] ?? json['author_name'] ?? json['user']?['name'],
      authorUsername: json['authorUsername'] ?? json['author_username'] ?? json['user']?['username'],
      authorProfileImage: json['authorProfileImage'] ?? json['author_profile_image'] ?? json['user']?['profileImage'],
      likesCount: json['likesCount'] ?? json['likes_count'] ?? json['likes'] ?? 0,
      viewsCount: json['viewsCount'] ?? json['views_count'] ?? json['views'] ?? 0,
      commentsCount: json['commentsCount'] ?? json['comments_count'] ?? json['comments'] ?? 0,
      sharesCount: json['sharesCount'] ?? json['shares_count'] ?? json['shares'] ?? 0,
      isLiked: json['isLiked'] ?? json['is_liked'] ?? false,
      isSaved: json['isSaved'] ?? json['is_saved'] ?? false,
      isFollowing: json['isFollowing'] ?? json['is_following'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      visibility: json['visibility'] ?? 'public',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      metadata: json['metadata'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'assetClass': assetClass,
      'authorId': authorId,
      'authorName': authorName,
      'authorUsername': authorUsername,
      'authorProfileImage': authorProfileImage,
      'likesCount': likesCount,
      'viewsCount': viewsCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'isLiked': isLiked,
      'isSaved': isSaved,
      'isFollowing': isFollowing,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'visibility': visibility,
      'tags': tags,
      'metadata': metadata,
    };
  }
  
  WidgetModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? assetClass,
    String? authorId,
    String? authorName,
    String? authorUsername,
    String? authorProfileImage,
    int? likesCount,
    int? viewsCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    bool? isSaved,
    bool? isFollowing,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? visibility,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return WidgetModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      assetClass: assetClass ?? this.assetClass,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorUsername: authorUsername ?? this.authorUsername,
      authorProfileImage: authorProfileImage ?? this.authorProfileImage,
      likesCount: likesCount ?? this.likesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      isFollowing: isFollowing ?? this.isFollowing,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      visibility: visibility ?? this.visibility,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }
}