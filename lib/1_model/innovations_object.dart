import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:fhws_innovations/3_controller/smart_contract.dart';

class InnovationsObject {
  SmartContract smartContract = SmartContract();

  var ethClient = Web3Client(
      "https://rinkeby.infura.io/v3/dbd61902b58949348a3045a157d038ca",
      Client());

  Future<List> getAllInnovations() async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getAllInnovations", [], ethClient);
    List<dynamic> innovationsList = result[0];
    return innovationsList;
  }

  Future<String> createStudentOnTheBlockchain() async {
    var response = await submit("createStudentOnTheBlockchain", ["k45766"]);
    print(response);
    return response;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(
        "9a5dc351dc38c057be0d8a8d4776358fffd1f7ade232e6bbaf14e6e821aaf340");
    DeployedContract contract = await smartContract.loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        chainId: null,
        fetchChainIdFromNetworkId: true);
    return result;
  }
}
