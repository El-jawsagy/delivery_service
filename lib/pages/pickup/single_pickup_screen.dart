import 'package:bosta_clone_app/model/shipment/shipment_model.dart';
import 'package:bosta_clone_app/pages/samilier_widget/screen_handle_widget.dart';
import 'package:bosta_clone_app/pages/shipment/single_shipment_screen.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/services/pickup_provider.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SinglePickupScreen extends StatefulWidget {
  @override
  _SinglePickupScreenState createState() => _SinglePickupScreenState();
}

class _SinglePickupScreenState extends State<SinglePickupScreen> {
  final GlobalKey<ScaffoldState> _singlePickupScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage("assets/images/fatima.jpg"),
                  fit: BoxFit.cover)),
        ),
        Scaffold(
          backgroundColor: CustomColors.trans,
          appBar: AppBar(
            title: Text(
              AppLocale.of(context).getTranslated("pickup_info"),
              style: TextStyle(color: CustomColors.white),
            ),
            backgroundColor: CustomColors.trans,
            elevation: 0,
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: CustomColors.white,
                  ),
                  onPressed: () {})
            ],
          ),
          body: RefreshIndicator(
            color: CustomColors.primary,
            onRefresh: refresh,
            child: _drawBody(),
          ),
        ),
      ],
    );
  }

  Future<Widget> refresh() async {
    var allPickupsProvider = Provider.of<PickUpProvider>(context, listen: false);

    if (!await allPickupsProvider.getSinglePickup(allPickupsProvider.pickupId)) {
      print(await allPickupsProvider.getSinglePickup(allPickupsProvider.pickupId));
      return drawErrorSnackBar(
        scaffoldKey: _singlePickupScaffoldKey,
        errorMassage: allPickupsProvider.error,
      );
    }
  }

  Widget _drawBody() {
    var allPickupsProvider = Provider.of<PickUpProvider>(context);
    switch (allPickupsProvider.stateOfSinglePickup) {
      case AllStates.Init:
      case AllStates.Loading:
        return drawLoadingIndicator(context);

        break;
      case AllStates.Done:
        if (allPickupsProvider.responseCodeOfPickups == 200) {
          return _drawSinglePickup();
        } else if (allPickupsProvider.responseCodeOfPickups == 401) {
          return drawBlockedShipment(onTapToDoReload: () async {
            await Future.delayed(
              Duration(milliseconds: 1000),
            );
            if (!await allPickupsProvider.getSinglePickup(allPickupsProvider.pickupId)) {
              return drawErrorSnackBar(
                scaffoldKey: _singlePickupScaffoldKey,
                errorMassage: allPickupsProvider.error,
              );
            }
          });
        } else if (allPickupsProvider.responseCodeOfPickups == 404) {
          return drawImageBackground("assets/images/image.png");
        } else if (allPickupsProvider.responseCodeOfPickups == 500) {
          return drawImageBackground("assets/images/Not_connected.png");
        }
        break;
    }
    return Container();
  }

  Widget _drawSinglePickup() {
    var allPickupsProvider = Provider.of<PickUpProvider>(context);

    return ListView(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: ExactAssetImage("assets/images/fatima.jpg"),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 28),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: CustomColors.trans),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _drawPickupId(),
                    SizedBox(
                      height: 10,
                    ),
                    _drawPickupIdVal(allPickupsProvider.pickup.id),
                    SizedBox(
                      height: 16,
                    ),
                    _drawPerson(),
                    SizedBox(
                      height: 10,
                    ),
                    _drawPersonVal(allPickupsProvider.pickup.personName),
                    SizedBox(
                      height: 16,
                    ),
                    _drawPersonPhone(),
                    SizedBox(
                      height: 16,
                    ),
                    _drawPersonPhoneVal(allPickupsProvider.pickup.personPhone),
                    SizedBox(
                      height: 16,
                    ),
                    _drawShipmentRelated(),
                    SizedBox(
                      height: 10,
                    ),
                    _drawShipmentRelatedVal(shipment: allPickupsProvider.pickup.shipment),
                    SizedBox(
                      height: 16,
                    ),
                    _drawStates(),
                    SizedBox(
                      height: 10,
                    ),
                    _drawStatesVal(allPickupsProvider.pickup.status),
                    SizedBox(
                      height: 16,
                    ),
                    _drawShipmentLocation(),
                    SizedBox(
                      height: 10,
                    ),
                    _drawShipmentLocationVal(allPickupsProvider.pickup.pickupLocation),
                    SizedBox(
                      height: 16,
                    ),
                    _drawDetailsRow(
                        allPickupsProvider.pickup.date,
                        allPickupsProvider.pickup.repeat == 1
                            ? allPickupsProvider.pickup.repeatType
                            : "N/A"),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _drawPickupId() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          AppLocale.of(context).getTranslated("pickup_id"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _drawPickupIdVal(shipmentId) {
    return Row(
      children: <Widget>[
        Text(
          shipmentId.toString(),
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _drawPerson() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocale.of(context).getTranslated("person_name"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _drawPersonVal(personName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          personName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _drawPersonPhone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocale.of(context).getTranslated("person_phone"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _drawPersonPhoneVal(personName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          personName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentRelated() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocale.of(context).getTranslated("shipment_related"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentRelatedVal({ShipmentModel shipment}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          shipment.id.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: CustomColors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleShipmentScreen(
                  shipmentModel: shipment,
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _drawShipmentLocation() {
    return Row(
      children: [
        Text(
          AppLocale.of(context).getTranslated("shipping"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentLocationVal(location) {
    return Row(
      children: [
        Text(
          location,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _drawStates() {
    return Row(
      children: <Widget>[
        Text(
          AppLocale.of(context).getTranslated("status"),
          style: TextStyle(
            fontSize: 18,
            color: CustomColors.grayBackground,
          ),
        ),
      ],
    );
  }

  Widget _drawStatesVal(state) {
    return Row(
      children: <Widget>[
        Text(
          state,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[100],
          ),
        ),
      ],
    );
  }

  Widget _drawDetailsRow(date, repeat) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _drawPickupRepeat(),
              SizedBox(
                height: 10,
              ),
              _drawPickupRepeatVal(repeat),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _drawPickupData(),
              SizedBox(
                height: 10,
              ),
              _drawPickupDataVal(date),
            ],
          ),
        ),
      ],
    );
  }

  Widget _drawPickupRepeat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          AppLocale.of(context).getTranslated("pickup_repeat"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _drawPickupRepeatVal(repeat) {
    return Row(
      children: <Widget>[
        Text(
          repeat,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _drawPickupData() {
    return Row(
      children: <Widget>[
        Text(
          AppLocale.of(context).getTranslated("pickup_date"),
          style: TextStyle(
            fontSize: 18,
            color: CustomColors.grayBackground,
          ),
        ),
      ],
    );
  }

  Widget _drawPickupDataVal(date) {
    return Row(
      children: <Widget>[
        Text(
          date,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[100],
          ),
        ),
      ],
    );
  }
}
