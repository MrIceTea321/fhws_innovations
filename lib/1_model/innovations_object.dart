import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'dart:typed_data';
import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/constants/rounded_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/browser.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:fhws_innovations/3_controller/smart_contract.dart';
import '../2_view/login.dart';
import 'innovation.dart';
import 'package:http/http.dart' as http;
import '../constants/text_constants.dart';

class InnovationsObject {
  SmartContract smartContract = SmartContract();
  List<Innovation> allInnovationsList = [];
  List<Innovation> innovationFromStudentList = [];
  List<Innovation> winningInnovationsList = [];
  var ethClient = Web3Client(
      "https://rinkeby.infura.io/v3/dbd61902b58949348a3045a157d038ca",
      Client());

  /*void getStatusOfTransaction(String transactionHash) async {
    bool transactionGetsProcessed = false;
    while (!transactionGetsProcessed) {
      final response = await http.get(Uri.parse(
          'https://api.etherscan.io/api?module=transaction&action=getstatus&txhash=' +
              transactionHash +
              '&apikey=' +
              etherscanToken));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> etherScanFetch = jsonDecode(response.body);
        if ('${etherScanFetch['result']['isError']}' == "1") {
          // Throw Exception if there was an error in the transaction
          throw Exception('Transaction failed!');
        } else if (('${etherScanFetch['result']['isError']}' == "0") &&
            ('${etherScanFetch['status']}' == "1")) {
          // Transaction gets processed fine.
          transactionGetsProcessed = true;
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Transaction failed!');
      }
    }
  }*/

  //All SmartContract Owner functions
  //call functions
  Future<bool> innovationProcessFinished() async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "innovationProcessFinished", [], ethClient);
    dynamic innovationProcessFinished = result[0];
    return innovationProcessFinished;
  }

  Future<List<Innovation>> getWinningInnovationsOfProcess() async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getWinnerOfInnovationProcess", [], ethClient);
    List<dynamic> innovationsList = result[0];
    int i = 0;
    innovationsList.forEach((innovationFromSC) {
      Innovation innovation = Innovation(
        uniqueInnovationHash: Uint8List.fromList(innovationFromSC[0]),
        votingCount: innovationFromSC[1],
        creator: Student.fromSmartContract(
            innovationFromSC[2][0],
            innovationFromSC[2][1],
            innovationFromSC[2][2],
            Uint8List.fromList(innovationFromSC[2][3])),
        title: innovationFromSC[3],
        description: innovationFromSC[4],
        isVoted: false,
      );
      winningInnovationsList.insert(i, innovation);
      i++;
    });
    await checkIfStudentUsesInitialRegisteredAddress();
    return winningInnovationsList;
  }

  Future<EthereumAddress> getContractOwner() async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getContractOwner", [], ethClient);
    dynamic contractOwner = result[0];
    return contractOwner;
  }

  //transaction functions
  void endInnovationProcess() async {
    var response =
        await smartContract.submitTransaction("endInnovationProcess", []);
    //getStatusOfTransaction(response);
    log(response);
  }

  void restartInnovationProcess() async {
    var response =
        await smartContract.submitTransaction("restartInnovationProcess", []);
    //getStatusOfTransaction(response);
    log(response);
  }

  //All call functions of SmartContract
  Future<bool> studentAlreadyRegistered(String kNumber) async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "studentAlreadyRegistred", [kNumber], ethClient);
    dynamic studentAlreadyRegistred = result[0];
    return studentAlreadyRegistred;
  }

  Future<bool> studentUsesInitialRegisteredAddress() async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "studentUsesInitialRegistredAddress", [], ethClient);
    dynamic studentUsesInitialRegistredAddress = result[0];
    return studentUsesInitialRegistredAddress;
  }

  Future<String> getKNumberOfStudentAddress() async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getKNumberOfStudentAddress", [], ethClient);
    dynamic kNumberOfStudentAddress = result[0];
    return kNumberOfStudentAddress;
  }

  Future<Student> getStudentFromSC() async {
    smartContract.loadContract();
    final eth = window.ethereum;
    final credentials = await eth?.requestAccount();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getStudent", [credentials?.address], ethClient);
    dynamic student = result[0];
    var stud = Student.fromSmartContract(
        student[0], student[1], student[2], Uint8List.fromList(student[3]));
    await checkIfStudentUsesInitialRegisteredAddress();
    return stud;
  }

  Future<List<Innovation>> getInnovationsOfStudent() async {
    smartContract.loadContract();
    final eth = window.ethereum;
    final credentials = await eth?.requestAccount();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getInnovationsOfStudent", [credentials?.address], ethClient);
    List<dynamic> innovationsOfStudent = result[0];
    int i = 0;
    innovationsOfStudent.forEach((innovationFromSC) {
      Innovation innovation = Innovation(
        uniqueInnovationHash: Uint8List.fromList(innovationFromSC[0]),
        votingCount: innovationFromSC[1],
        creator: Student.fromSmartContract(
            innovationFromSC[2][0],
            innovationFromSC[2][1],
            innovationFromSC[2][2],
            Uint8List.fromList(innovationFromSC[2][3])),
        title: innovationFromSC[3],
        description: innovationFromSC[4],
        isVoted: false,
      );
      innovationFromStudentList.insert(i, innovation);
      i++;
    });
    await checkIfStudentUsesInitialRegisteredAddress();
    return innovationFromStudentList;
  }

  Future<List<Innovation>> getAllInnovations() async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getAllInnovations", [], ethClient);
    List<dynamic> innovationsListFromSC = result[0];
    int i = 0;
    innovationsListFromSC.forEach((innovationFromSC) {
      Innovation innovation = Innovation(
          uniqueInnovationHash: Uint8List.fromList(innovationFromSC[0]),
          votingCount: innovationFromSC[1],
          creator: Student.fromSmartContract(
              innovationFromSC[2][0],
              innovationFromSC[2][1],
              innovationFromSC[2][2],
              Uint8List.fromList(innovationFromSC[2][3])),
          title: innovationFromSC[3],
          description: innovationFromSC[4],
          isVoted: false);
      allInnovationsList.insert(i, innovation);
      i++;
    });
    await checkIfStudentUsesInitialRegisteredAddress();
    return allInnovationsList;
  }

  Future<void> checkIfStudentUsesInitialRegisteredAddress() async {
    var isTrue = await studentUsesInitialRegisteredAddress();
    if (!isTrue) {
      Get.offAll(const Login(
        fromStudentCheck: true,
      ));
    }
  }

  //All transaction function of SmartContract

  Future<String> initialRegistrationOfStudent(
      BuildContext context, String kNumber) async {
    var response = await smartContract
        .submitTransaction("initialRegistrationOfStudent", [kNumber]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RoundedAlert(
            "Erfolgreich erstellt", "Student wurde auf BC erstellt ");
      },
    );
    //getStatusOfTransaction(response);
    log(response);
    return response;
  }

  void createInnovation(String title, String description) async {
    var response = await smartContract
        .submitTransaction("createInnovation", [title, description]);
    await checkIfStudentUsesInitialRegisteredAddress();
    //getStatusOfTransaction(response);
    log(response);
  }

  void deleteInnovation(Uint8List uniqueInnovationHash) async {
    var response = await smartContract
        .submitTransaction("deleteInnovation", [uniqueInnovationHash]);
    await checkIfStudentUsesInitialRegisteredAddress();
    //getStatusOfTransaction(response);
    log(response);
  }

  void editInnovation(
      Uint8List uniqueInnovationHash, String title, String description) async {
    var response = await smartContract.submitTransaction(
        "editInnovation", [uniqueInnovationHash, title, description]);
    await checkIfStudentUsesInitialRegisteredAddress();
    log(response);
  }

  void vote(
      Uint8List uniqueInnovationHash, BuildContext context, Size size) async {
    var response = await smartContract
        .submitTransaction("vote", [Uint8List.fromList(uniqueInnovationHash)]);
    await checkIfStudentUsesInitialRegisteredAddress();
    checkTransactionReceipt(response, context, size);
    log(response);
  }

  void unvote(
      Uint8List uniqueInnovationHash, BuildContext context, Size size) async {
    var response = await smartContract.submitTransaction(
        "unvote", [Uint8List.fromList(uniqueInnovationHash)]);
    await checkIfStudentUsesInitialRegisteredAddress();
    checkTransactionReceipt(response, context, size);
    log(response);
  }

  Future<void> checkTransactionReceipt(
      String response, BuildContext context, Size size) async {
    var finalTrancCall;
    var isStatus = false;
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
                          const Text('Transaktion pendet',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 20.0),
                          Container(
                              height: 40,
                              width: 70,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: const CircularProgressIndicator(
                                color: fhwsGreen,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
    await Future.delayed(const Duration(seconds: 20), () async {
      finalTrancCall = await ethClient.getTransactionReceipt(response);
      if (finalTrancCall.status == true) {
        isStatus = true;
      } else {
        isStatus = false;
      }
      Navigator.of(context, rootNavigator: true).pop();
    });
    isStatus
        ? showDialog(
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
                              const Text('Transaktion erfolgreich',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 20.0),
                              Container(
                                  height: 40,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Container(
                                        height: 40,
                                        width: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: const Text('Ok',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0))),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            })
        : showDialog(
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
                              const Text('Transaktion nicht erfolgreich',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 20.0),
                              Container(
                                  height: 40,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Container(
                                        height: 40,
                                        width: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: const Text('Ok',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0))),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
  }
}
