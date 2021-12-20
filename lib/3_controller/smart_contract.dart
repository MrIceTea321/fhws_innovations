import 'package:fhws_innovations/constants/text_constants.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

class SmartContract{

  Future<DeployedContract> loadContract() async {
    // Load Contract from the Abi
    String abi = await rootBundle.loadString("abi.json");

    // Transform contract into an object
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, contractName),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  // Enter function name of smart contract method - optional are the arguments
  Future<List<dynamic>> querySmartContractFunction(String functionName, List<dynamic> args, Web3Client ethClient) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    return result;
  }


}