import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';
import '../models/verifier_campaign_data_model.dart';

class VerifierCampaignDataLightController extends StatefulWidget {
  const VerifierCampaignDataLightController({Key? key}) : super(key: key);

  @override
  State<VerifierCampaignDataLightController> createState() =>
      _VerifierCampaignDataLightControllerState();
}

class _VerifierCampaignDataLightControllerState
    extends State<VerifierCampaignDataLightController> {
  Object? parameters;
  dynamic jsonParameters = {};
  dynamic jsonCounters = {};
  List<dynamic>? filesInfo;

  String fileCount = '0';
  String fileChecked = '0';
  String workersCount = '0';
  late String name,
      lat,
      lng,
      range,
      type,
      crowdsourcer,
      contractAddress,
      readebleLocation;

  @override
  void initState() {
    super.initState();
  }

  _formatData(String counters, List<dynamic>? info) {
    jsonCounters = jsonDecode(counters);
    fileCount = jsonCounters['fileCount'].toString();
    fileChecked = jsonCounters['fileChecked'].toString();
    workersCount = jsonCounters['workersCount'].toString();
    filesInfo = info;
  }

  @override
  Widget build(BuildContext context) {
    parameters = ModalRoute.of(context)!.settings.arguments;
    jsonParameters = jsonDecode(jsonEncode(parameters));
    contractAddress = jsonParameters["contractAddress"];
    name = jsonParameters['name'];
    lat = jsonParameters['lat'];
    lng = jsonParameters['lng'];
    range = jsonParameters['range'];
    type = jsonParameters['type'];
    crowdsourcer = jsonParameters['crowdsourcer'];
    contractAddress = jsonParameters['contractAddress'];
    readebleLocation = jsonParameters['readebleLocation'];

    VerifierCampaignDataModel.getData(contractAddress).then((counters) => {
          VerifierCampaignDataModel.getDataFileInfo(contractAddress)
              .then((info) => {
                    if (mounted)
                      {
                        setState(() {
                          _formatData(counters, info);
                        })
                      }
                  })
        });

    return (contractAddress != "0x0000000000000000000000000000000000000000")
        ? Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
            width: double.maxFinite,
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                    flex: 5,
                    child: Text("Crowdsourcer:\n$crowdsourcer",
                        style: CustomTextStyle.spaceMono(context))),
              ]),
              Column(children: <Widget>[
                Text(
                  "Location:\n$readebleLocation",
                  style: CustomTextStyle.spaceMono(context),
                ),
              ]),
              Row(children: <Widget>[
                Text(
                  "Range: $range",
                  style: CustomTextStyle.spaceMono(context),
                ),
              ]),
              Row(children: <Widget>[
                Text(
                  "Type: $type",
                  style: CustomTextStyle.spaceMono(context),
                )
              ]),
              Text(
                "Sourcing Status:\nuploaded $fileCount files\nchecked $fileChecked of $fileCount\nwhit the contribution of $workersCount workers",
                style: CustomTextStyle.spaceMono(context),
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: (filesInfo != null) ? filesInfo!.length : 0,
                  itemBuilder: (context, index) {
                    List current = filesInfo![index];

                    String status = current[0].toString();
                    String validity = current[1].toString();
                    String uploader = current[2].toString();
                    String ipfsHash = current[3].toString();
                    if (status == 'false') {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/validate_light_view', arguments: {
                              "name" : name,
                              "ipfsHash" : ipfsHash,
                              "uploader" : uploader
                            });
                          },
                          child: Card(
                            shadowColor: CustomColors.blue600(context),
                            color: CustomColors.customWhite(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(children: <Widget>[
                                              FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child:
                                                      Column(children:
                                                      [
                                                        Text("Uploader: ", style: CustomTextStyle.spaceMonoBold(context),),
                                                        Text(uploader, style: CustomTextStyle.spaceMono(context),)
                                                      ])
                                              ),
                                        FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child:
                                            Column(children:
                                            [
                                              Text("Ipfs hash: ", style: CustomTextStyle.spaceMonoBold(context),),
                                              Text(ipfsHash, style: CustomTextStyle.spaceMono(context),)
                                            ])
                                        ),
                                            ],
                                          ),
                                        ),
                                      ])),
                              ),
                            );
                    } else {
                      return Card(
                          shadowColor: (validity == 'true')?
                          CustomColors.green600(context) : CustomColors.red600(context),
                          color: CustomColors.customWhite(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(children: <Widget>[
                                        FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child:
                                            Column(children:
                                            [
                                              Text("Uploader: ", style: CustomTextStyle.spaceMonoBold(context),),
                                              Text(uploader, style: CustomTextStyle.spaceMono(context),)
                                            ])
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child:
                                            Column(children:
                                            [
                                              Text("Ipfs hash: ", style: CustomTextStyle.spaceMonoBold(context),),
                                              Text(ipfsHash, style: CustomTextStyle.spaceMono(context),)
                                            ])
                                        ),
                                        FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child:
                                            Column(children:
                                            [
                                              Text("validity: ", style: CustomTextStyle.spaceMonoBold(context),),
                                              Text(validity, style: CustomTextStyle.spaceMono(context),)
                                            ])
                                        ),
                                      ],
                                      ),
                                    ),
                                  ])),
                        );
                    }
                  })
            ]))
        : Center(
            child: Text(
            'No active campaign at the moment...',
            style: CustomTextStyle.spaceMono(context),
          ));
  }
}
