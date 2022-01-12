import 'dart:typed_data';
import 'package:fhws_innovations/1_model/innovations_object.dart';
import 'package:fhws_innovations/1_model/innovation.dart';
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/2_view/show_innovation.dart';
import 'package:fhws_innovations/2_view/user_innovations.dart';
import 'package:fhws_innovations/constants/text_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/rounded_alert.dart';
import 'login.dart';

class InnovationsOverview extends StatefulWidget {
  final Student student;
  final String studentFirstName;
  final List<Innovation> innovations;
  final bool isInnovationsProcessFinished;
  final bool isSmartContractOwner;

  int voteCount = 0;
  bool isVoted = false;
  bool studentHasVoted = false;

  InnovationsOverview(
      {Key? key,
      required this.student,
      required this.studentFirstName,
      required this.innovations,
      required this.isInnovationsProcessFinished,
      required this.isSmartContractOwner})
      : super(key: key);

  @override
  _InnovationsOverviewState createState() => _InnovationsOverviewState();
}

class _InnovationsOverviewState extends State<InnovationsOverview> {
  @override
  void initState() {
    widget.studentHasVoted = widget.student.voted;
    widget.innovations.forEach((innovation) {
      if ((listEquals(widget.student.votedInnovationHash,
          innovation.uniqueInnovationHash))) {
        innovation.isVoted = true;
      }
    });
    super.initState();
  }

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
            child: Row(
              children: [
                Text(
                  'Übersicht',
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7), fontSize: 18.0),
                ),
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
                      var innovationsFromStudent =
                          await ib.getInnovationsOfStudent();
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Login(
                              fromStudentCheck: false,
                            )));
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
          widget.isInnovationsProcessFinished
              ? const SizedBox()
              : TextButton(
                  onPressed: () async {
                    ib.endInnovationProcess();
                    bool isFinished = await ib.innovationProcessFinished();
                    //TODO get bool from etherscan
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                          return const RoundedAlert("Erfolgreich",
                              "Die Abstimmung wurde erfolgreich beendet!");
                      },
                    );
                  },
                  child: Container(
                      height: 50,
                      width: size.width * 0.9,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        color: fhwsGreen,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Center(
                          child: Text(
                            'Abstimmung beenden',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      )),
                ),
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
                      widget.studentHasVoted
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
                    return _buildFeaturedItem(
                      title: widget.innovations.elementAt(index).title,
                      description: widget.innovations
                          .elementAt(index)
                          .description
                          .toString(),
                      innovation: widget.innovations.elementAt(index),
                      voteCount: widget.innovations
                          .elementAt(index)
                          .votingCount
                          .toString(),
                      innovationHash: Uint8List.fromList(widget.innovations
                          .elementAt(index)
                          .uniqueInnovationHash),
                      ib: ib,
                      student: widget.student,
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
      required Student student,
      required Uint8List innovationHash,
      required Innovation innovation,
      required InnovationsObject ib}) {
    if ((listEquals(
        student.votedInnovationHash, innovation.uniqueInnovationHash))) {
      innovation.isVoted = true;
    }
    return Container(
      padding:
          const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
      child: TextButton(
        onPressed: () {
          Future.delayed(Duration.zero, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ShowInnovation(innovation: innovation)));
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          color: Colors.black.withOpacity(0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Center(
                    child: Text(title,
                        style: const TextStyle(
                          color: fhwsGreen,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  IconButton(
                      onPressed: () async {
                        Student student = await ib.getStudentFromSC();
                        if (student.voted == false) {
                          ib.vote(Uint8List.fromList(innovationHash));
                          widget.studentHasVoted = true;
                        } else if (student.voted == true &&
                            !(listEquals(student.votedInnovationHash,
                                innovation.uniqueInnovationHash))) {
                          Student student = await ib.getStudentFromSC();
                          ib.unvote(student.votedInnovationHash);
                          ib.vote(innovationHash);
                        } else {
                          ib.unvote(Uint8List.fromList(innovationHash));
                          widget.studentHasVoted = false;
                        }
                        setState(() {});
                      },
                      icon: innovation.isVoted
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
      ),
    );
  }

  Future<List<Innovation>> getAllInnovations() async {
    InnovationsObject object = InnovationsObject();
    var stud = await object.getAllInnovations();
    return stud;
  }
}
