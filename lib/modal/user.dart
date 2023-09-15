class User {
  final String userId;
  final String username;

  User(this.userId, this.username);
  
  factory User.fromJson(Map<String, dynamic> json){
    return User(json['userId'], json['username']);
  }
}