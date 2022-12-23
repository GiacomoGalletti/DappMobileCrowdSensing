import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mobile_crowd_sensing/models/smart_contract_model.dart';
import 'package:web3dart/credentials.dart';
import 'session_model.dart';
import '../views/dialog_view.dart';

class MyCampaignModel {

  static Future<List?> getMyCampaign(BuildContext context) async {
    try {
      SessionModel sessionData = SessionModel();
      String sourcerAddress = sessionData.getAccountAddress();
      SmartContractModel smartContractViewModel = SmartContractModel(FlutterConfig.get('MCSfactory_CONTRACT_ADDRESS'),'MCSfactory','assets/abi.json', provider: sessionData.getProvider());
      EthereumAddress address = EthereumAddress.fromHex(sourcerAddress);
      return await smartContractViewModel.queryCall('activeCampaigns',[address],null);
    } catch (error) {
      if (kDebugMode) {
        print('\x1B[31m$error\x1B[0m');
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DialogView(message: error.toString())));
    }
    return null;
  }
}