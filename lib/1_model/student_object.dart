import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:web3dart/credentials.dart';

import '../constants/text_constants.dart';
import 'innovation.dart';

class Student {
  late String kNumber;
  late EthereumAddress studentAddress;
  bool voted = false;
  late Uint8List votedInnovationHash;

  Student.fromSmartContract(
      this.kNumber, this.studentAddress, this.voted, this.votedInnovationHash);


  static Future<String> fetchStudentKNumber(
      String kNumber, String password) async {
    String credentials = '$kNumber:$password';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    final response = await http.get(
      Uri.parse(fhwsApi),
      // Send authorization headers to the fhws backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $encoded',
      },
    );
    Map<String, dynamic> json = jsonDecode(response.body);
    return json['cn'];
  }

  @override
  String toString() {
    return 'Student{kNumber: $kNumber, studentAddress: $studentAddress, voted: $voted, votedInnovationHash: $votedInnovationHash}';
  }
}
