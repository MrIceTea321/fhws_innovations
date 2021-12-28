import 'dart:typed_data';

import 'package:fhws_innovations/1_model/innovation.dart';
import 'package:fhws_innovations/1_model/innovations_object.dart';
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/2_view/user_innovations.dart';
import 'package:fhws_innovations/constants/text_constants.dart';
import 'package:flutter/material.dart';

import '../constants/rounded_alert.dart';
import 'innovations_overview.dart';
import 'login.dart';

class CreateNewInnovation extends StatefulWidget {
  final String studentFirstName;
  int voteCount = 0;
  String title = '';
  String description = '';

  CreateNewInnovation(
      {Key? key,
      required this.studentFirstName,})
      : super(key: key);

  @override
  _CreateNewInnovationOverviewState createState() =>
      _CreateNewInnovationOverviewState();
}

class _CreateNewInnovationOverviewState extends State<CreateNewInnovation> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    InnovationsObject ib = InnovationsObject();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'FHWS Innovations',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        backgroundColor: fhwsGreen,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: IconButton(
                onPressed: () async {
                  var student = await ib.getStudentFromSC();
                  var allInnovations = await ib.getAllInnovations();
                  var studentInnovations = await ib.getInnovationsOfStudent();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InnovationsOverview(
                              student: student,
                              innovations: allInnovations,
                              studentFirstName: widget.studentFirstName,
                              studentInnovations: studentInnovations)));
                },
                icon: const Icon(Icons.home)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Row(
              children: [
                const Text('Innovationen bearbeiten'),
                IconButton(
                    onPressed: () async {
                      var userInnos = await ib.getInnovationsOfStudent();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserInnovations(
                                    userInnovations: userInnos,
                                    studentFirstName: widget.studentFirstName,
                                  )));
                    },
                    icon: const Icon(Icons.description)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: IconButton(
                onPressed: () {
                  MaterialPageRoute(builder: (context) => const Login());
                },
                icon: const Icon(Icons.logout)),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.015),
          _createNewInnovation(ib),
          //});
          TextButton(
            onPressed: () async {
              if (widget.title.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const RoundedAlert("Achtung",
                        "Bitte gib einen Titel für deine Innovation an");
                  },
                );
              } else if (widget.description.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const RoundedAlert("Achtung",
                        "Bitte gib eine Beschreibung für deine Innovation an");
                  },
                );
              } else {
                ib.createInnovation(widget.title, widget.description);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const RoundedAlert("Erfolgreich",
                        "Deine Innovation wurde erfolgreich angelegt");
                  },
                );
              }
              var student = await ib.getStudentFromSC();
              var allInnovations = await ib.getAllInnovations();
              var studInnovations = await ib.getInnovationsOfStudent();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InnovationsOverview(
                            student: student,
                            innovations: allInnovations,
                            studentFirstName: widget.studentFirstName,
                            studentInnovations: studInnovations,
                          )));
            },
            child: Container(
                height: 50,
                width: size.width * 0.9,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  color: fhwsGreen,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Center(
                    child: Text(
                      'Innovation anlegen',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                  ),
                )),
          )
        ],
      )),
    );
  }

  Container _createNewInnovation(InnovationsObject ib) {
    return Container(
      padding:
          const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: Colors.black.withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                String input = '';
                input = value;
                widget.title = input;
              },
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Titel eingeben',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: fhwsGreen, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
              ),
            ),
            TextFormField(
              onChanged: (value) {
                String input = '';
                input = value;
                widget.description = input;
              },
              minLines: 7,
              maxLines: 11,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Beschreibung eingeben',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: fhwsGreen, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
