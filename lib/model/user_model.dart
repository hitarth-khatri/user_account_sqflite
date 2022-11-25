class User{
  String? username;
  int? number;
  String? email;
  String? birthDate;
  String? password;
  String? gender;

  User(this.username, this.number, this.email, this.birthDate, this.password, this.gender);

  User.fromJson(Map<String, dynamic> json) {
    username =json['username'];
    number = json['number'];
    password = json['password'];
    email = json['email'];
    gender = json['gender'];
    birthDate = json['birthDate'];
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "number": number,
      "password": password,
      "email" : email,
      "gender" : gender,
      "birthDate" : birthDate,
    };
  }

}