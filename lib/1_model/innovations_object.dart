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

class InnovationsObject {
  SmartContract smartContract = SmartContract();
  List<Innovation> allInnovationsList = [];
  List<Innovation> innovationFromStudentList = [];
  List<Innovation> winningInnovationsList = [];

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
    //TODO use transactionhash (response) for Etherscan fetch
    log(response);
  }

  void restartInnovationProcess() async {
    var response =
        await smartContract.submitTransaction("restartInnovationProcess", []);
    //TODO use transactionhash (response) for Etherscan fetch
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
    //TODO use transactionhash (response) for Etherscan fetch
    log(response);
    return response;
  }

  void createInnovation(String title, String description) async {
    var response = await smartContract
        .submitTransaction("createInnovation", [title, description]);
    await checkIfStudentUsesInitialRegisteredAddress();
    //TODO use transactionhash (response) for Etherscan fetch

    log(response);
  }

  void deleteInnovation(Uint8List uniqueInnovationHash) async {
    var response = await smartContract
        .submitTransaction("deleteInnovation", [uniqueInnovationHash]);
    await checkIfStudentUsesInitialRegisteredAddress();
    //TODO use transactionhash (response) for Etherscan fetch

    log(response);
  }

  void editInnovation(
      Uint8List uniqueInnovationHash, String title, String description) async {
    var response = await smartContract.submitTransaction(
        "editInnovation", [uniqueInnovationHash, title, description]);
    await checkIfStudentUsesInitialRegisteredAddress();
    //TODO use transactionhash (response) for Etherscan fetch

    log(response);
  }

  void vote(Uint8List uniqueInnovationHash) async {
    var response = await smartContract
        .submitTransaction("vote", [Uint8List.fromList(uniqueInnovationHash)]);
    await checkIfStudentUsesInitialRegisteredAddress();
    //TODO use transactionhash (response) for Etherscan fetch
    print('Response $response');
    log(response);
  }

  void unvote(Uint8List uniqueInnovationHash) async {
    var response = await smartContract.submitTransaction(
        "unvote", [Uint8List.fromList(uniqueInnovationHash)]);
    await checkIfStudentUsesInitialRegisteredAddress();
    //TODO use transactionhash (response) for Etherscan fetch

    log(response);
  }
}
