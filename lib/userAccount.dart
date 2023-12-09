class UserAccount {
  final String id;
  final String name;
  final String email;

  UserAccount({
    required this.id,
    required this.name,
    required this.email,
  });

  static UserAccount fromJson(Map<String, dynamic> json) => UserAccount(
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
