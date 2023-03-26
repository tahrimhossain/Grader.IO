class UserInfo {
  String? email;
  String? name;

  UserInfo({this.email, this.name});

  UserInfo.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
  }

}