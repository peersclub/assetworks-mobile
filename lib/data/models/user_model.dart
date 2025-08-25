class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? username;
  final String? bio;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  UserModel({
    this.id,
    this.email,
    this.name,
    this.username,
    this.bio,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'],
      email: json['email'],
      name: json['name'],
      username: json['username'],
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'] ?? json['profileImage'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? bio,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}