import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:fhws_innovations/3_controller/smart_contract.dart';

class InnovationsObject {

  late SmartContract smartContract = SmartContract();

  var ethClient = Web3Client(
      "https://rinkeby.infura.io/v3/dbd61902b58949348a3045a157d038ca",
      Client());

  Future<void> getInnovationsLength(int innovationsLength, bool data,) async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        'getInnovationsLength', [], ethClient);

    BigInt bigIntToInt = result[0];
    innovationsLength = bigIntToInt.toInt();
    data = true;
    //setState(() {});
  }

  Future<List> getAllInnovations(bool data) async {
    smartContract.loadContract();
    List<dynamic> result = await smartContract.querySmartContractFunction(
        "getAllInnovations", [], ethClient);

    List<dynamic> innovationsList = result[0];

    data = true;
    return innovationsList;
  }
}
