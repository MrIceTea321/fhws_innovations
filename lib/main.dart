
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/2_view/innovations_overview.dart';
import 'package:fhws_innovations/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '2_view/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  InnovationsOverview(student: Student(), studentFirstName: 'Maxi', innovations: []),
    );
  }
}
