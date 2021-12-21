import 'package:fhws_innovations/1_model/innovations_object.dart';
import 'package:fhws_innovations/1_model/innovation.dart';
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/constants/text_constants.dart';
import 'package:flutter/material.dart';

class InnovationsOverview extends StatefulWidget {
  final Student student;
  final String studentFirstName;
  final List<Innovation> innovations;

  const InnovationsOverview(
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: fhwsGreen,
      body: ListView(
        children: <Widget>[
          SizedBox(height: size.height * 0.025),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 15.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15.0),
                  )),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<dynamic>>(
            future: getAllInnovations(),
            builder: (context, AsyncSnapshot<List<dynamic>> snap) {
              if (snap.data == null) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: fhwsGreen,
                ));
              }
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.innovations.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => _openDestinationPage(
                            context, widget.innovations.elementAt(index)),
                        child: _buildFeaturedItem(
                          title: widget.innovations.elementAt(index).title,
                          subtitle: widget.innovations
                              .elementAt(index)
                              .creator
                              .studentAddress
                              .toString(),
                        ));
                  });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Innovation\nhinzufügen',
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: size.width * 0.03,
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
      child: Material(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Stack(
          children: <Widget>[
            Positioned(
                bottom: 20.0,
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
    return object.getAllInnovations();
  }
}
