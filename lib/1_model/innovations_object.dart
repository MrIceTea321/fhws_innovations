import 'dart:html';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fhws_innovations/constants/rounded_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/browser.dart';
import 'package:flutter_web3/ethereum.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:fhws_innovations/3_controller/smart_contract.dart';

class InnovationsObject {
  SmartContract smartContract = SmartContract();

  var ethClient = Web3Client(
      "https://rinkeby.infura.io/v3/dbd61902b58949348a3045a157d038ca",
      Client());

  //All getters of SmartContract
  Future<List> getAllInnovations() async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getAllInnovations", [], ethClient);
    List<dynamic> innovationsList = result[0];
    return innovationsList;
  }

  // All functions of SmartContract
  Future<String> createStudentOnTheBlockchain(BuildContext context, String kNumber) async {
    var response =
        await submitTransaction("createStudentOnTheBlockchain", [kNumber]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RoundedAlert(
            "❗️Achtung❗",
            "Student wurde auf BC erstellt ☺️");
      },
    );
    return response;
  }
  // Direct Conncetion with Private Key
  // Future<String> submit(String functionName, List<dynamic> args) async {
  //   EthPrivateKey credentials = EthPrivateKey.fromHex(
  //       "9a5dc351dc38c057be0d8a8d4776358fffd1f7ade232e6bbaf14e6e821aaf340");
  //   DeployedContract contract = await smartContract.loadContract();
  //   final ethFunction = contract.function(functionName);
  //   final result = await ethClient.sendTransaction(
  //       credentials,
  //       Transaction.callContract(
  //           contract: contract, function: ethFunction, parameters: args),
  //       chainId: null,
  //       fetchChainIdFromNetworkId: true);
  //   return result;
  // }

  Future<String> submitTransaction(
      String functionName, List<dynamic> args) async {
    final eth = window.ethereum;
    if (eth == null) {
      return "MetaMask is not available";
    } else {
      final credentials = await eth.requestAccount();
      final client = Web3Client.custom(eth.asRpcService());
      DeployedContract contract = await smartContract.loadContract();
      final ethFunction = contract.function(functionName);
      final result = await client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: contract, function: ethFunction, parameters: args),
          chainId: null,
          fetchChainIdFromNetworkId: true);
      return result;
    }
  }

}
