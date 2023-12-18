class CustomerAccount {
  final String id;
  final String fname;
  final String lname;
  final String email;
  final String? phoneNumber;
  final String? address;

  CustomerAccount({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    this.phoneNumber,
    this.address,
  });

  static CustomerAccount fromJson(Map<String, dynamic> json) => CustomerAccount(
        id: json['id'],
        fname: json['fname'],
        lname: json['lname'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fname': fname,
        'lname': lname,
        'email': email,
        'phoneNumber': phoneNumber,
        'address': address,
      };
}
