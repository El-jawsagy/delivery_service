import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget drawImageBackground(imagePath) {
  return Center(
    child: ListView(
      shrinkWrap: true,
      children: [
        Center(child: Image.asset(imagePath)),
      ],
    ),
  );
}

Widget drawBlockedShipment({
  Function onTapToDoReload,
  Function onTapToDoVerify,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(child: Image.asset("assets/images/blocked.png")),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
              heroTag: "shipmentReload",
              elevation: 2,
              backgroundColor: CustomColors.primary,
              hoverColor: CustomColors.primary,
              child: FaIcon(
                FontAwesomeIcons.retweet,
                color: CustomColors.white,
              ),
              onPressed: onTapToDoReload),
          FloatingActionButton(
              heroTag: "authVerify",
              elevation: 2,
              backgroundColor: CustomColors.primary,
              hoverColor: CustomColors.primary,
              child: FaIcon(
                FontAwesomeIcons.envelopeSquare,
                color: CustomColors.white,
              ),
              onPressed: onTapToDoVerify),
        ],
      )
    ],
  );
}

Widget drawLoadingIndicator(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Center(
      child: CircularProgressIndicator(
        backgroundColor: CustomColors.primary,
        valueColor: AlwaysStoppedAnimation<Color>(CustomColors.thirdPrimary),
      ),
    ),
  );
}

Widget drawErrorSnackBar({scaffoldKey, errorMassage}) {
  return scaffoldKey.currentState.showSnackBar(SnackBar(
    backgroundColor: CustomColors.primary,
    content: Text(
      errorMassage,
      style: TextStyle(
        color: CustomColors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ));
}
