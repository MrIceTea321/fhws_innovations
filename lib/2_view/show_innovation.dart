import 'dart:typed_data';
import 'package:fhws_innovations/1_model/innovation.dart';
import 'package:fhws_innovations/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class ShowInnovation extends StatefulWidget {
  final Innovation innovation;

  const ShowInnovation({Key? key, required this.innovation}) : super(key: key);

  @override
  _ShowInnovationOverviewState createState() => _ShowInnovationOverviewState();
}

class _ShowInnovationOverviewState extends State<ShowInnovation> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                Text('Detailansicht',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.7), fontSize: 18.0)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    icon: const Icon(Icons.home)),
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
                icon: const Icon(Icons.logout)),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.015),
          _buildFeaturedItem(
              title: widget.innovation.title,
              innovationHash: widget.innovation.uniqueInnovationHash,
              voteCount: widget.innovation.votingCount.toString(),
              description: widget.innovation.description),
          //});
        ],
      )),
    );
  }

  Container _buildFeaturedItem(
      {required String title,
      required String description,
      required String voteCount,
      required Uint8List innovationHash}) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Innovation von: ',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                Text(widget.innovation.creator.studentAddress.toString(),
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
}
