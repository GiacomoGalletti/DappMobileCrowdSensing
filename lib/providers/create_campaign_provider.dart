import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_crowd_sensing/view_models/session_view_model.dart';
import 'package:mobile_crowd_sensing/providers/smart_contract_provider.dart';

import '../views/dialog_view.dart';

class CampaignCreator extends StatefulWidget {
  const CampaignCreator({super.key});
  @override
  _CampaignCreatorState createState() => _CampaignCreatorState();
}

class _CampaignCreatorState extends State<CampaignCreator> {
  final createCampaignProvider = GlobalKey<ScaffoldState>();

  late SessionViewModel sessionData;
  Object? parameters;
  dynamic jsonParameters = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sessionData = SessionViewModel();
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));
    createCampaign(
        jsonParameters['title'],
        BigInt.from(jsonParameters['lat']),
        BigInt.from(jsonParameters['lng']),
        BigInt.from(jsonParameters['range']),
        jsonParameters['type'],
        BigInt.from(jsonParameters['payment']),
    );
    return Scaffold(
        key: createCampaignProvider,
        backgroundColor: Colors.blue[900],
        body: const Center(
            child: SpinKitFadingCube(
              color: Colors.green,
              size: 50.0,
            )));
  }

  Future<void> createCampaign(String name, BigInt lat, BigInt lng, BigInt range,String type, BigInt value) async {
    try {
      SmartContractProvider smartContractViewModel = SmartContractProvider(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'), 'MCSfactory', 'assets/abi.json', provider: sessionData.getProvider());
      List args = [name, lat, lng, range,type];
      await smartContractViewModel.queryTransaction('createCampaign', args,value).then((value) async => {
        print('\x1B[31m [DEBUG]:::::::::::::::::::::::::: $value\x1B[0m'),
        if (value!=null && value!='0x0000000000000000000000000000000000000000') {
          Navigator.popAndPushNamed(context, '/worker')
        }
      });
    } catch (error) {
      print('\x1B[31m$error\x1B[0m');
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => DialogView(message: '[uploadLight]: $error')
            )
        );
      });
    }
  }
}
