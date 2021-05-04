
class User{
  String username;
  String fullName;
  String token;

  User.fromJson(Map data){
    this.username=data['uname'];
    this.token=data['user_token'];
    this.fullName=data['name'];
  }
}