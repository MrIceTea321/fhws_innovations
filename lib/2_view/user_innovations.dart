import 'dart:typed_data';

import 'package:fhws_innovations/1_model/innovations_object.dart';
import 'package:fhws_innovations/1_model/innovation.dart';
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/2_view/create_new_innovation.dart';
import 'package:fhws_innovations/2_view/innovations_detail_page.dart';
import 'package:fhws_innovations/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

import 'innovations_overview.dart';
import 'login.dart';

class UserInnovations extends StatefulWidget {
  final Student student;
  final String studentFirstName;
  final List<Innovation> innovations;
  final List<Innovation> userInnovations;
  List<Innovation> testInnovations = [];
  int voteCount = 0;

  UserInnovations({Key? key,
    required this.student,
    required this.studentFirstName,
    required this.innovations,
    required this.userInnovations})
      : super(key: key);

  @override
  _UserInnovationsOverviewState createState() =>
      _UserInnovationsOverviewState();
}

class _UserInnovationsOverviewState extends State<UserInnovations> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    bool isVoted = false;

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
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InnovationsOverview(
                                student: widget.student,
                                innovations: widget.innovations,
                                studentFirstName: widget.studentFirstName,
                              )));
                },
                icon: Icon(Icons.home)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Row(
              children: [
                Text('Meine Innovationen'),
                IconButton(onPressed: () {}, icon: Icon(Icons.description)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: IconButton(
                onPressed: () {
                  MaterialPageRoute(builder: (context) => const Login());
                },
                icon: Icon(Icons.logout)),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.015),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.userInnovations.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () =>
                          _openDestinationPage(
                              context, widget.userInnovations.elementAt(index)),
                      child: _buildFeaturedItem(
                          title: widget.userInnovations
                              .elementAt(index)
                              .title,
                          description: widget.userInnovations
                              .elementAt(index)
                              .description
                              .toString(),
                          voteCount: widget.userInnovations
                              .elementAt(index)
                              .votingCount
                              .toString(),
                          innovationHash: widget.userInnovations
                              .elementAt(index)
                              .uniqueInnovationHash,
                          isVoted: isVoted));
                  //});
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateNewInnovation(
                            student: widget.student,
                            innovations: widget.innovations,
                            studentFirstName: widget.studentFirstName, userInnovations: [],
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
                          'Neue Innovation anlegen',
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

  Container _buildFeaturedItem({required String title,
    required String description,
    required String voteCount,
    required String innovationHash,
    required bool isVoted}) {
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
            Text(title,
                style: const TextStyle(
                  color: fhwsGreen,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            Text(description,
                style: const TextStyle(
                  color: Colors.white,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Anzahl an Stimmen: ',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                Text(voteCount,
                    style: const TextStyle(
                      color: fhwsGreen,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _openDestinationPage(BuildContext context, Innovation innovation) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => InnovationsDetail(student: widget.student, studentFirstName: widget.studentFirstName, innovations: widget.innovations, userInnovations: widget.userInnovations, userInnovation: innovation,)));
  }

  getAllInnovations() {
    InnovationsObject object = InnovationsObject();
    return widget.testInnovations;
    //object.getAllInnovations();
  }
}
