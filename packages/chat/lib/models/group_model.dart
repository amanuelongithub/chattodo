class GroupModel {
  final String uid;
  final String name;
  final String image;
  final int onlineUsers;
  final String createdBy;
  final DateTime lastActive;

  const GroupModel({
    required this.uid,
    required this.name,
    required this.image,
    required this.onlineUsers,
    required this.createdBy,
    required this.lastActive,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        uid: json['uid'],
        name: json['name'],
        image: json['image'],
        onlineUsers: json['onlineUsers'],
        createdBy: json['createdBy'],
        lastActive: json['lastActive'].toDate(),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'image': image,
        'onlineUsers': onlineUsers,
        'createdBy': createdBy,
        'lastActive': lastActive,
      };
}
