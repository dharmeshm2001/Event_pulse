class ChatUser {
  ChatUser({
    required this.profileImage,
    required this.Bio,
    required this.role,
    required this.username,
    // required this.created_at,
    // required this.isOnline,
    // required this.last_active,
    // required this.email,
    // required this.pushToken,
    required this.uid,
  });
  late final String profileImage;
  late final String Bio;
  late final String role;
  late final String username;
  // late final String created_at;
  // late final bool isOnline;

  // late final String last_active;
  // late final String email;
  // late final String pushToken;
  late final String uid;

  ChatUser.fromJson(Map<String, dynamic> json) {
    profileImage = json['profileImage'] ?? '';
    Bio = json['Bio'] ?? '';
    role = json['role'] ?? '';
    username = json['username'] ?? '';
    // created_at = json['created_at'] ?? '';
    // isOnline = json['isOnline'] ?? false;
    // last_active = json['last_active'] ?? '';
    uid = json['uid'] ?? '';
    // pushToken = json['pushToken'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['profileImage'] = profileImage;
    data['Bio'] = Bio;
    data['username'] = username;
    data['uid'] = uid;
    // data['created_at'] = created_at;
    // data['isOnline'] = isOnline;
    // data['last_active'] = last_active;
    // data['pushToken'] = pushToken;
    // data['email'] = email;
    return data;
  }
}
