class User {
  int idUser;
  String name;
  String email;
  String password;

  User(this.idUser, this.name, this.email, this.password);

  factory User.fromJson(Map<String, dynamic> json) => User(
        int.parse(json['id_user']),
        json['name'],
        json['email'],
        json['password'],
      );

  Map<String, dynamic> toJson() => {
        'id_user': this.idUser.toString(),
        'name': this.name,
        'email': this.email,
        'password': this.password,
      };
}
