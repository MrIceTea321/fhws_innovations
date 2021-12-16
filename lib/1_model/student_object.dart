import 'package:http/http.dart' as http;

import '../constants/text_constants.dart';

class Student {
  String kNumber;
  String emailAddress;
  String firstName;
  String lastName;

  Student(
      {required this.kNumber,
      required this.emailAddress,
      required this.firstName,
      required this.lastName});

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        kNumber: json['cn'],
        emailAddress: json['emailAddress'],
        firstName: json['firstName'],
        lastName: json['lastName'],
      );

  @override
  String toString() {
    return 'Student{kNumber: $kNumber, emailAddress: $emailAddress, firstName: $firstName, lastName: $lastName}';
  }

  Map<String, dynamic> toJson() => {
        'cn': kNumber,
        'emailAddress': emailAddress,
        'firstName': firstName,
        'lastName': lastName,
      };

  static Future<Student> getStudent() async {
    final response = await http.get(Uri.parse(fhwsApi));
    return Student.fromJson(response.headers);
  }
}
