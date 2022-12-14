import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import '../models/search_places_model.dart';
import '../utils/spalsh_screens.dart';


class SearchPlacesView extends StatefulWidget {
  const SearchPlacesView({Key? key}) : super(key: key);

  @override
  State<SearchPlacesView> createState() => _SearchPlacesViewState();
}

class _SearchPlacesViewState extends State<SearchPlacesView> {
  final searchPlacesViewScaffoldKey = GlobalKey<ScaffoldState>();
  SearchPlacesModel searchPlacesData = SearchPlacesModel();

  Widget _buildPage() {
    return Stack(children: [
      OpenStreetMapSearchAndPick(
          center: LatLong(searchPlacesData.lat, searchPlacesData.lng),
          buttonColor: CustomColors.blue900(context),
          buttonText: 'Set Current Location',
          onPicked: (pickedData) {
            if (kDebugMode) {
              print(pickedData.latLong.latitude);
              print(pickedData.latLong.longitude);
              print(pickedData.address);
            }
          })
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, searchPlacesData);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Data position taken',
          style: CustomTextStyle.spaceMonoWhite(context),
        )));
        return false;
      },
      child: Scaffold(
          key: searchPlacesViewScaffoldKey,
          appBar: AppBar(
              backgroundColor: CustomColors.blue900(context),
              title: const Text("Where is located your Campaign?")),
          body: FutureBuilder(
            future: searchPlacesData.updateLocalPosition(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(child: Text('Sorry something goes wrong...'));
                case ConnectionState.waiting:
                  return CustomSplashScreen.fadingCubeBlueBg(context);
                default:
                  return _buildPage();
              }
            },
          )),
    );
  }
}
