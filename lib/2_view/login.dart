import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fhws_innovations/1_model/innovations_object.dart';
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/3_controller/metamask.dart';
import 'package:fhws_innovations/constants/rounded_alert.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/text_constants.dart';
import 'innovations_overview.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String password = '';
  String kNumber = '';
  InnovationsObject ib = InnovationsObject();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MetaMaskProvider()..init(),
        builder: (context, snapshot) {
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Card(
                        color: fhwsGreen,
                        margin: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        elevation: 10,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                SafeArea(
                  child: ListView(
                    children: [
                      const SizedBox(height: 40.0),
                      Text(
                        "Welcome to FHWS Innovations",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white,
                              fontFamily: openSansFontFamily,
                            ),
                      ),
                      const Text(
                        "Login with your Student Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: openSansFontFamily,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Card(
                        margin: const EdgeInsets.all(32.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16.0),
                          children: [
                            const SizedBox(height: 20.0),
                            Text(
                              "Log In",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: fhwsGreen,
                                    fontFamily: openSansFontFamily,
                                  ),
                            ),
                            const SizedBox(height: 40.0),
                            TextField(
                              onChanged: (value) {
                                kNumber = value;
                              },
                              decoration: const InputDecoration(
                                labelText: "Enter k-Number",
                              ),
                            ),
                            TextField(
                              obscureText: true,
                              onChanged: (value) {
                                password = value;
                              },
                              decoration: const InputDecoration(
                                labelText: "Enter password",
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16.0),
                                  primary: fhwsGreen, // background
                                  onPrimary: Colors.white,
                                ),
                                child: const Text("Submit",
                                    style: TextStyle(
                                        fontFamily: openSansFontFamily,
                                        color: Colors.white)),
                                onPressed: () async {
                                  ib.innovationProcessFinished();
                                  // ib.editInnovation(
                                  //     Uint8List.fromList(), "Test", "Test");
                                  if (kNumber == '') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const RoundedAlert("❗️Achtung❗",
                                            "Gib bitte deine k-Nummer an ☺️");
                                      },
                                    );
                                  } else if (password == '') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const RoundedAlert("❗️Achtung❗",
                                            "Gib bitte dein Passwort an ☺️");
                                      },
                                    );
                                  } else {
                                    Student student =
                                        await fetchStudent(kNumber, password);
                                    //TODO insert function alreadyExist
                                    //TODO
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InnovationsOverview(student)));
                                  }
                                }),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<Student> fetchStudent(String kNumber, String password) async {
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

    final responseJson = jsonDecode(response.body);
    return Student.fromJson(responseJson);
  }
}
