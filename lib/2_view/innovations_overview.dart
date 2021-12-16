import 'package:fhws_innovations/1_model/innovations_data_object.dart';
import 'package:fhws_innovations/1_model/innovations_object.dart';
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/constants/text_constants.dart';
import 'package:flutter/material.dart';

class InnovationsOverview extends StatefulWidget {
  final Student student;

  const InnovationsOverview(this.student);

  @override
  _InnovationsOverviewState createState() => _InnovationsOverviewState();
}

class _InnovationsOverviewState extends State<InnovationsOverview> {
  List<Innovation> innovationsDataObjectList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: fhwsGreen,
      body: ListView(
        children: <Widget>[
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
                              "Hallo, " + widget.student.firstName,
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: openSansFontFamily),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "Welche Innovation möchtest du unterstützen?",
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontFamily: openSansFontFamily),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextField(
                      onChanged: (value) {
                        //TODO insert filtered value
                      },
                      showCursor: true,
                      decoration: InputDecoration(
                        hintText: "Nach Innovationen suchen",
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.black54),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      )),
                ],
              ),
            ),
          ),
          FutureBuilder<List<Innovation>>(
            future: getInnovations(),
            builder: (context, AsyncSnapshot<List<Innovation>> snap) {
              if (snap.data == null) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: fhwsGreen,
                ));
              }
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: innovationsDataObjectList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => _openDestinationPage(context,
                            innovationsDataObjectList.elementAt(index)),
                        child: _buildFeaturedItem(
                          title:
                              innovationsDataObjectList.elementAt(index).title,
                          subtitle: innovationsDataObjectList
                              .elementAt(index)
                              .creator
                              .emailAddress,
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
          size: size.width * 0.1,
          color: fhwsGreen,
        ),
        onPressed: () async {
        //  Navigator.push(context,
        //      MaterialPageRoute(builder: (context) => CreateNewInnovation()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                              fontFamily: openSansFontFamily)),
                      Text('Creator: ' + subtitle,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: openSansFontFamily)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _openDestinationPage(BuildContext context, Innovation innovation) {
    //Navigator.push(
    //    context, MaterialPageRoute(builder: (_) => InnovationDetails(innovatoin: innovatoin)));
  }

  getInnovations() {
    InnovationsObject object = InnovationsObject();
    return object.getAllInnovations(true);
  }
}
