import 'package:fhws_innovations/1_model/innovations_object.dart';
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/3_controller/metamask.dart';
import 'package:fhws_innovations/constants/rounded_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
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
  bool showPassword = true;
  bool isMetaMaskConnected = false;

  @override
  void initState() {
    super.initState();
  }

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
                        "Willkommen zu FHWS Innovations",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      const Text(
                        "Melde dich mit deinem studentischen Account an",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
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
                              "Anmelden",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: fhwsGreen,
                                  ),
                            ),
                            const SizedBox(height: 40.0),
                            TextField(
                              onChanged: (value) {
                                kNumber = value;
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: fhwsGreen,
                                ),
                                labelText: "k-Nummer eingeben",
                              ),
                            ),
                            TextField(
                              obscureText: showPassword,
                              onChanged: (value) {
                                password = value;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: fhwsGreen,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  icon: showPassword
                                      ? const Icon(
                                          Icons.visibility_off_outlined,
                                          color: fhwsGreen,
                                        )
                                      : const Icon(Icons.visibility_outlined,
                                          color: fhwsGreen),
                                ),
                                labelText: "Passwort eingeben",
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16.0),
                                  primary: fhwsGreen, // background
                                  onPrimary: Colors.white,
                                ),
                                child: const Text("Bestätigen",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  if (kNumber == '') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const RoundedAlert("️Achtung",
                                            "Gib bitte deine k-Nummer an️");
                                      },
                                    );
                                  } else if (password == '') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const RoundedAlert("Achtung",
                                            "Gib bitte dein Passwort an");
                                      },
                                    );
                                  } else if (!isMetaMaskConnected) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const RoundedAlert("Achtung",
                                            "Stelle bitte eine Verbindung mit MetaMask her!");
                                      },
                                    );
                                  } else {
                                    var studentFromFhwsFetch =
                                        StudentFromFhwsFetch(
                                            kNumber, 'Test Name');
                                    //await getStudentFetch(context, size);
                                    var studentAlreadyRegistered = await ib
                                        .studentAlreadyRegistered(kNumber);
                                    if (studentAlreadyRegistered) {
                                      var studentSc =
                                          await ib.getStudentFromSC();
                                      var allInnovations = await ib
                                          .getAllInnovations(context, kNumber);
                                      Future.delayed(Duration.zero, () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InnovationsOverview(
                                                      student: studentSc,
                                                      studentFirstName:
                                                          studentFromFhwsFetch
                                                              .firstName,
                                                      innovations:
                                                          allInnovations,
                                                    )));
                                      });
                                    } else {
                                      await ib.initialRegistrationOfStudent(
                                          context,
                                          studentFromFhwsFetch.kNumber);
                                      var studentSc =
                                          await ib.getStudentFromSC();
                                      var allInnovations = await ib
                                          .getAllInnovations(context, kNumber);
                                      Future.delayed(Duration.zero, () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InnovationsOverview(
                                                      student: studentSc,
                                                      studentFirstName:
                                                          studentFromFhwsFetch
                                                              .firstName,
                                                      innovations:
                                                          allInnovations,
                                                    )));
                                      });
                                    }
                                  }
                                }),
                            const SizedBox(height: 50.0),
                            Center(
                              child: Consumer<MetaMaskProvider>(
                                builder: (context, provider, child) {
                                  late final String text;
                                  if (provider.isConnected &&
                                      provider.isInOperatingChain) {
                                    text = 'Verbunden';
                                    isMetaMaskConnected = true;
                                  } else if (provider.isConnected &&
                                      !provider.isInOperatingChain) {
                                    text =
                                        'Falsche chain. Bitte verbinde dich mit ${MetaMaskProvider.operatingChain}';
                                  } else if (provider.isEnabled) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Hier klicken'),
                                        const SizedBox(height: 8),
                                        CupertinoButton(
                                          onPressed: () => context
                                              .read<MetaMaskProvider>()
                                              .connect(),
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.network(
                                                'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1',
                                                width: 300,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    text =
                                        'Bitte benutze einen Browser der Web3 unterstützt.';
                                  }

                                  return ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [
                                        Colors.purple,
                                        Colors.blue,
                                        Colors.red
                                      ],
                                    ).createShader(bounds),
                                    child: Text(
                                      text,
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<StudentFromFhwsFetch> getStudentFetch(
      BuildContext context, Size size) async {
    bool isLoading = true;
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.only(right: 16.0),
                  width: size.width * 0.9,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text('Fetch wird ausgeführt',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 20.0),
                            Container(
                              height: 40,
                              width: 70,
                              decoration: BoxDecoration(
                                color:
                                    isLoading ? Colors.transparent : fhwsGreen,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: fhwsGreen,
                                    )
                                  : TextButton(
                                      child: const Text("OK",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                          )),
                                      onPressed: () {
                                        //TODO fix onPressed close dialog
                                        Navigator.pop(context);
                                      },
                                    ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
      //StudentFromFhwsFetch fetch =
      //    await Student.fetchStudentInformation(kNumber, password);
      isLoading = false;
      return StudentFromFhwsFetch(kNumber, 'Maximilian Test');
    } catch (e) {
      throw Exception(showDialog(
        context: context,
        builder: (BuildContext context) {
          return const RoundedAlert("Achtung",
              "Die Anmeldung schlug fehl! Überprüfue bitte deine Eingaben und deine Verbindung mit MetaMask");
        },
      ));
    }
  }
}
