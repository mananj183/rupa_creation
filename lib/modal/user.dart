// class User {
//   final String userId;
//   final String username;
//   final String fullName;
//
//   User(this.userId, this.username, this.fullName);
//
//   factory User.fromJson(Map<String, dynamic> json){
//     return User(json['userId'], json['username'], json['fullName']);
//   }
// }


class User {
  String? userId;
  String? email;
  String? fullName;

  User({this.userId, this.email, this.fullName});

  factory User.fromJson(Map<String, dynamic> json, String userID) {
    return User(userId: userID, email: json['email'], fullName: json['fullName']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['email'] = email;
    data['fullName'] = fullName;
    return data;
  }
}