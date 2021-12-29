import 'dart:developer';
import 'dart:html';
import 'dart:typed_data';

import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:fhws_innovations/constants/rounded_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/browser.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:fhws_innovations/3_controller/smart_contract.dart';

import '../2_view/login.dart';
import 'innovation.dart';

class InnovationsObject {
  SmartContract smartContract = SmartContract();
  List<Innovation> allInnovationsList = [];
  List<Innovation> innovationFromStudentList = [];

  var ethClient = Web3Client(
      "https://rinkeby.infura.io/v3/dbd61902b58949348a3045a157d038ca",
      Client());

  //All SmartContract Owner functions
  //call functions
  Future<bool> innovationProcessFinished() async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "innovationProcessFinished", [], ethClient);
    dynamic innovationProcessFinished = result[0];
    return innovationProcessFinished;
  }

  Future<List> getWinnerOfInnovationProcess() async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getWinnerOfInnovationProcess", [], ethClient);
    List<dynamic> getWinnerOfInnovationProcess = result[0];
    return getWinnerOfInnovationProcess;
  }

  //transaction functions
  void endInnovationProcess() async {
    var response =
        await smartContract.submitTransaction("endInnovationProcess", []);
    log(response);
  }

  void restartInnovationProcess() async {
    var response =
        await smartContract.submitTransaction("restartInnovationProcess", []);
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

  Future<Student> getStudentFromSC(BuildContext context) async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getStudent", [], ethClient);
    dynamic student = result[0];
    var stud = Student.fromSmartContract(
        student[0], student[1], student[2], student[3]);
    await checkIfStudentAlreadyRegistered(stud.kNumber, context);
    return stud;
  }

  Future<List<Innovation>> getInnovationsOfStudent(
      BuildContext context, String kNumber) async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getInnovationsOfStudent", [], ethClient);
    List<dynamic> innovationsOfStudent = result[0];
    int i = 0;
    innovationsOfStudent.forEach((innovationFromSC) {
      Innovation innovation = Innovation(
        uniqueInnovationHash: innovationFromSC[0],
        votingCount: innovationFromSC[1],
        creator: Student.fromSmartContract(
            innovationFromSC[2][0],
            innovationFromSC[2][1],
            innovationFromSC[2][2],
            innovationFromSC[2][3]),
        title: innovationFromSC[3],
        description: innovationFromSC[4],
      );
      print('innovationFromStudent: $innovation');
      innovationFromStudentList.insert(i, innovation);
      i++;
    });
    await checkIfStudentAlreadyRegistered(kNumber, context);
    return innovationFromStudentList;
  }

  Future<List<Innovation>> getAllInnovations(
      BuildContext context, String kNumber) async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getAllInnovations", [], ethClient);
    List<dynamic> innovationsListFromSC = result[0];
    int i = 0;
    innovationsListFromSC.forEach((innovationFromSC) {
      Innovation innovation = Innovation(
        uniqueInnovationHash: innovationFromSC[0],
        votingCount: innovationFromSC[1],
        creator: Student.fromSmartContract(
            innovationFromSC[2][0],
            innovationFromSC[2][1],
            innovationFromSC[2][2],
            innovationFromSC[2][3]),
        title: innovationFromSC[3],
        description: innovationFromSC[4],
      );
      allInnovationsList.insert(i, innovation);
      i++;
    });
    await checkIfStudentAlreadyRegistered(kNumber, context);
    return allInnovationsList;
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
    log(response);
    return response;
  }

  void createInnovation(String title, String description, String kNumber,
      BuildContext context) async {
    var response = await smartContract
        .submitTransaction("createInnovation", [title, description]);
    await checkIfStudentAlreadyRegistered(kNumber, context);
    log(response);
  }

  void deleteInnovation(Uint8List uniqueInnovationHash, String kNumber,
      BuildContext context) async {
    var response = await smartContract
        .submitTransaction("deleteInnovation", [uniqueInnovationHash]);
    await checkIfStudentAlreadyRegistered(kNumber, context);
    log(response);
  }

  void editInnovation(Uint8List uniqueInnovationHash, String title,
      String description, String kNumber, BuildContext context) async {
    var response = await smartContract.submitTransaction(
        "editInnovation", [uniqueInnovationHash, title, description]);
    await checkIfStudentAlreadyRegistered(kNumber, context);
    log(response);
  }

  Future<void> checkIfStudentAlreadyRegistered(
      String kNumber, BuildContext context) async {
    var isTrue = await studentAlreadyRegistered(kNumber);
    if (isTrue) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const RoundedAlert("️Achtung",
              "Benutze bitte den selben MetaMask Account wie bei deinem ersten Log In️");
        },
      );
    }
  }

  void vote(Uint8List uniqueInnovationHash, String kNumber,
      BuildContext context) async {
    var response =
        await smartContract.submitTransaction("vote", [uniqueInnovationHash]);
    await checkIfStudentAlreadyRegistered(kNumber, context);
    log(response);
  }

  void unvote(Uint8List uniqueInnovationHash, String kNumber,
      BuildContext context) async {
    var response =
        await smartContract.submitTransaction("unvote", [uniqueInnovationHash]);
    await checkIfStudentAlreadyRegistered(kNumber, context);
    log(response);
  }
}
