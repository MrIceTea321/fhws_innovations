import 'dart:typed_data';

import 'package:fhws_innovations/1_model/innovations_object.dart';
import 'package:fhws_innovations/1_model/innovation.dart';
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/constants/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

class InnovationsOverview extends StatefulWidget {
  final Student student;
  final String studentFirstName;
  final List<Innovation> innovations;
  List<Innovation> testInnovations = [];

  InnovationsOverview(
      {Key? key,
      required this.student,
      required this.studentFirstName,
      required this.innovations})
      : super(key: key);

  @override
  _InnovationsOverviewState createState() => _InnovationsOverviewState();
}

class _InnovationsOverviewState extends State<InnovationsOverview> {
  @override
  void initState() {
    var ino0 = Innovation(
        uniqueInnovationHash: 'testHash',
        description: 'test description lore ipsum lore ipsum',
        title: 'Test Title Lore Ipsum',
        creator: Student.fromSmartContract(
            'k45447',
            EthereumAddress.fromHex(
                '0x0000000000000000000000000000000000000000'),
            true,
            Uint8List.fromList([0])),
        votingCount: BigInt.one);
    var ino1 = Innovation(
        uniqueInnovationHash: 'testHash 1',
        description: 'test description lore ipsum lore ipsum 1',
        title: 'Test Title Lore Ipsum 1',
        creator: Student.fromSmartContract(
            'k15447',
            EthereumAddress.fromHex(
                '0x1000000000000000000000000000000000000000'),
            true,
            Uint8List.fromList([1])),
        votingCount: BigInt.one);
    var ino2 = Innovation(
        uniqueInnovationHash: 'testHash 2',
        description: 'test description lore ipsum lore ipsum 2',
        title: 'Test Title Lore Ipsum 2',
        creator: Student.fromSmartContract(
            'k25447',
            EthereumAddress.fromHex(
                '0x2000000000000000000000000000000000000000'),
            true,
            Uint8List.fromList([2])),
        votingCount: BigInt.two);
    widget.testInnovations.add(ino0);
    widget.testInnovations.add(ino1);
    widget.testInnovations.add(ino2);
    print('widget.testInnovations');
    print(widget.testInnovations.length);
    print(widget.testInnovations);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: fhwsGreen,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: size.height * 0.025),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Hallo, " + widget.studentFirstName,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  "Welche Innovation möchtest du unterstützen?",
                  style: TextStyle(color: Colors.grey.shade700),
                )
              ],
            ),
          ),
          /*FutureBuilder<List<Innovation>>(
           future: getAllInnovations(),
            builder: (context, AsyncSnapshot<List<Innovation>> snap) {
              if (snap.data == null) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: fhwsGreen,
                ));
              }
              return*/ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.testInnovations.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => _openDestinationPage(
                            context, widget.testInnovations.elementAt(index)),
                        child: _buildFeaturedItem(
                          title: widget.testInnovations.elementAt(index).title,
                          subtitle: widget.testInnovations
                              .elementAt(index)
                              .creator
                              .studentAddress
                              .toString(),
                        ));
                  //});
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Innovation\nhinzufügen',
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: size.width * 0.05,
          color: fhwsGreen,
        ),
        onPressed: () async {
          //Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => CreateNewInnovation()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Container _buildFeaturedItem(
      {required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.only(
          left: 16.0, top: 8.0, right: 16.0, bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 8.0),
        color: Colors.black.withOpacity(0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            Text('Verfasser: ' + subtitle,
                style: const TextStyle(
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }

  _openDestinationPage(BuildContext context, Innovation innovation) {
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (_) => InnovationDetails(innovatoin: innovatoin)));
  }

  getAllInnovations() {
    InnovationsObject object = InnovationsObject();
    return widget.testInnovations;
    //object.getAllInnovations();
  }
}
