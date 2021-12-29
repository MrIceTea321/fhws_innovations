import 'dart:typed_data';

import 'package:fhws_innovations/1_model/innovations_object.dart';
import 'package:fhws_innovations/1_model/innovation.dart';
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/2_view/show_innovation.dart';
import 'package:fhws_innovations/2_view/user_innovations.dart';
import 'package:fhws_innovations/constants/text_constants.dart';
import 'package:flutter/material.dart';


import 'login.dart';

class InnovationsOverview extends StatefulWidget {
  final Student student;
  final String studentFirstName;
  final List<Innovation> innovations;
  int voteCount = 0;

  InnovationsOverview(
      {Key? key,
      required this.student,
      required this.studentFirstName,
      required this.innovations
      })
      : super(key: key);

  @override
  _InnovationsOverviewState createState() => _InnovationsOverviewState();
}

class _InnovationsOverviewState extends State<InnovationsOverview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isVoted = false;
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
            child: Row(
              children: [
                const Text('Übersicht'),
                IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () async {
                      var kNumber = await ib.getKNumberOfStudentAddress();
                      var innovationsFromStudent =
                          await ib.getInnovationsOfStudent(context, kNumber);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserInnovations(
                                    userInnovations: innovationsFromStudent,
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.015),
          Container(
            width: size.width - 30.0,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(
                  Radius.circular(0.0),
                )),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hallo, " + widget.studentFirstName,
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Du hast noch ',
                        style: TextStyle(color: Colors.white),
                      ),
                      widget.student.voted
                          ? const Text(
                              '0',
                              style: TextStyle(
                                  color: fhwsGreen,
                                  fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              '1',
                              style: TextStyle(
                                  color: fhwsGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                      const Text(
                        ' verbleibende Stimmen',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<Innovation>>(
            future: getAllInnovations(),
            builder: (context, AsyncSnapshot<List<Innovation>> snap) {
              if (snap.data == null) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: fhwsGreen,
                ));
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.innovations.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: _openDestinationPage(
                          context, widget.innovations.elementAt(index)),
                      child: _buildFeaturedItem(
                          title: widget.innovations.elementAt(index).title,
                          description: widget.innovations
                              .elementAt(index)
                              .description
                              .toString(),
                          voteCount: widget.innovations
                              .elementAt(index)
                              .votingCount
                              .toString(),
                          innovationHash: widget.innovations
                              .elementAt(index)
                              .uniqueInnovationHash,
                          isVoted: isVoted,
                          ib: ib),
                    );
                  });
            },
          ),
        ],
      )),
    );
  }

  Container _buildFeaturedItem(
      {required String title,
      required String description,
      required String voteCount,
      required Uint8List innovationHash,
      required bool isVoted,
      required InnovationsObject ib}) {
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
            Row(
              children: [
                Text(title,
                    style: const TextStyle(
                      color: fhwsGreen,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
                IconButton(
                    onPressed: () async {
                      var kNumber = await ib.getKNumberOfStudentAddress();
                      if (widget.student.votedInnovationHash ==
                          innovationHash) {
                        isVoted = true;
                      }
                      setState(() {
                        widget.student.voted = !widget.student.voted;
                        isVoted != isVoted;
                        // set the voting count on the BC
                        if (isVoted) {
                          ib.vote(innovationHash, kNumber, context);
                        } else {
                          ib.unvote(innovationHash, kNumber, context);
                        }
                      });
                      setState(() {});
                    },
                    icon: isVoted
                        ? const Icon(Icons.star, color: fhwsGreen)
                        : const Icon(
                            Icons.star_border,
                            color: fhwsGreen,
                          ))
              ],
            ),
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShowInnovation(innovation: innovation)));
  }

  Future<List<Innovation>> getAllInnovations() async {
    InnovationsObject object = InnovationsObject();
    var kNumber = await object.getKNumberOfStudentAddress();
    var stud = await object.getAllInnovations(context, kNumber);
    return stud;
  }
}
