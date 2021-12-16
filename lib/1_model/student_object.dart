import 'dart:html';

import 'package:http/http.dart' as http;

import '../constants/text_constants.dart';
import 'innovation.dart';

class Student {
  late String _kNumber;
  late String _emailAddress;
  late String _firstName;
  late String _lastName;
  List<Innovation> innovations = [];
  bool _hasLiked = false;

  bool createdMaxInnovations = false;

  Student(this._kNumber, this._emailAddress, this._firstName, this._lastName);

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        json['cn'],
        json['emailAddress'],
        json['firstName'],
        json['lastName'],
      );

  Map<String, dynamic> toJson() => {
        'cn': _kNumber,
        'emailAddress': _emailAddress,
        'firstName': _firstName,
        'lastName': _lastName,
      };

  static Future<Student> getStudent() async {
    final response = await http.get(Uri.parse(fhwsApi));
    return Student.fromJson(response.headers);
  }

  void setLikeToInnovation(Innovation innovation) {
    hasLiked = true;
    innovation.setVote(true);
  }

  Innovation createInnovation(
      Student creator, String title, String description, String hash) {
    //TODO get unique hash
    Innovation innovation = Innovation(creator, title, description,'' );
    innovations.add(innovation);
    return innovation;
  }

  set hasLiked(bool value) {
    _hasLiked = value;
  }

  bool get hasLiked => _hasLiked;

  String get firstName => _firstName;

  String get kNumber => _kNumber;

  String get lastName => _lastName;

  String get emailAddress => _emailAddress;
}
