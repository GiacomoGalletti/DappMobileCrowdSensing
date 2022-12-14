import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

class SessionModel {

  static final SessionModel _instance = SessionModel._internal();

  dynamic session, uri, signature;
  late WalletConnect  connector;

  late http.Client httpClient;
  late Web3Client ethClient;

  SessionModel._internal() {
    httpClient = http.Client();
    ethClient = Web3Client(FlutterConfig.get('ADDRESS_BLOCK_CHAIN'), http.Client());

    connector = WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: const PeerMeta(
            name: 'Mobile Crowd Sensing App',
            description: 'An app for collect data with crowds',
            url: 'https://walletconnect.org',
            icons: [
              'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
            ]
        )
    );
  }

  factory SessionModel() {
    return _instance;
  }

  EthereumWalletConnectProvider getProvider(){
   return EthereumWalletConnectProvider(connector);
  }

  dynamic getAccountAddress() {
    return session.accounts[0];
  }

  Future<void> checkConnection() async {
    SessionStorage? sessionStorage = connector.sessionStorage;
    if (sessionStorage != null) {
        session = sessionStorage.getSession();
        reconnect();
    } else {
      await sessionStorage?.store(connector.session);
    }
    connector.on('connect', (session) => {print('\x1B[31m[checkConnection]\x1B[0m:connect'),reconnect(),this.session = session});
    connector.on('session_update', (payload) =>{print('\x1B[31m[checkConnection]\x1B[0m:session_update'), session = payload});
    connector.on('disconnect', (payload) => {print('\x1B[31m[checkConnection]\x1B[0m:disconnect'),session = null, closeConnection()});
  }

  void reconnect(){
    print('\x1B[31m[Connection reconnected]\x1B[0m:connect');
    connector.reconnect();
  }
  void closeConnection() {
    print('\x1B[31m[Reconnect]\x1B[0m:connect');
    connector.close();
  }
  void killConnection(){
    print('\x1B[31m[Connection Killed]\x1B[0m:connect');
    connector.killSession();
  }
  getNetworkName(chainId) {
    switch (chainId) {
      case 1:
        return 'Ethereum Mainnet';
      case 3:
        return 'Ropsten Testnet';
      case 4:
        return 'Rinkeby Testnet';
      case 5:
        return 'Goreli Testnet';
      case 42:
        return 'Kovan Testnet';
      case 137:
        return 'Polygon Mainnet';
      case 80001:
        return 'Mumbai Testnet';
      default:
        return 'Unknown Chain';
    }
  }
}