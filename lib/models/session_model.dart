import 'package:walletconnect_dart/walletconnect_dart.dart';

class SessionModel {
  static final SessionModel _instance = SessionModel._internal();

  dynamic session, uri, signature, connector;

  SessionModel._internal() {
    connector = WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: const PeerMeta(
            name: 'Mobile Crowd Sensing App',
            description: 'An app for collect data with crowds',
            url: 'https://walletconnect.org',
            icons: [
              'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
            ]));
  }

  factory SessionModel() {
    return _instance;
  }
}