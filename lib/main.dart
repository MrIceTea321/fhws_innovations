import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'FHWS Innovations'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Client httpClient;
  late Web3Client ethClient;

  final myAddress = "0x33398a5f4372DDB334aFE22d777A351b610a930C";

  late List<dynamic> innovationsList;
  int innovationsLength = 0;
  bool data = false;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://rinkeby.infura.io/v3/dbd61902b58949348a3045a157d038ca",
        httpClient);
    getInnovationsLength();
    getAllInnovations();
  }

  Future<DeployedContract> loadContract() async {
    //Load Contract from the Abi
    String abi = await rootBundle.loadString("abi.json");
    String contractAddress = "0x53C55a784bea3AC3d973C882B10162E413758CB1";

    //Transform contract into an object
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "FhwsInnovationsContract"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  //Enter function name of smart contract method - optinal are the arguments
  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<void> getInnovationsLength() async {
    List<dynamic> result = await query("getInnovationsLength", []);

    BigInt bigIntToInt = result[0];
    innovationsLength = bigIntToInt.toInt();
    data = true;
    setState(() {});
  }

  Future<void> getAllInnovations() async {
    List<dynamic> result = await query("getAllInnovations", []);
    innovationsList = result[0];
    data = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.red100,
      body: ZStack([
        VStack([
          (context.percentHeight * 10).heightBox,
          data
              ? innovationsLength.text.xl4.black.bold.center
                  .makeCentered()
                  .py16()
              : CircularProgressIndicator().centered(),
        ]),
        VStack([
          (context.percentHeight * 30).heightBox,
          data
              ? innovationsList[0][3]
                  .toString()
                  .text
                  .xl4
                  .black
                  .bold
                  .center
                  .makeCentered()
                  .py16()
              : CircularProgressIndicator().centered(),
        ])
      ]),
    );
  }
}
