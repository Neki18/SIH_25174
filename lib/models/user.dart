class User {
  int? id;
  String name;
  String email;
  String phone;
  String password;

  User({this.id, required this.name, required this.email, required this.phone, required this.password});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'email': email, 'phone': phone, 'password': password};

  factory User.fromMap(Map<String, dynamic> m) => User(id: m['id'], name: m['name'], email: m['email'], phone: m['phone'], password: m['password']);
}
