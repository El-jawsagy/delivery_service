import 'package:bosta_clone_app/model/pickup/pickup_model.dart';
import 'package:bosta_clone_app/pages/drawer.dart';
import 'package:bosta_clone_app/pages/notification/notifications_screen.dart';
import 'package:bosta_clone_app/pages/pickup/create_single_pickup_screen.dart';
import 'package:bosta_clone_app/pages/pickup/single_pickup_screen.dart';
import 'package:bosta_clone_app/pages/samilier_widget/screen_handle_widget.dart';
import 'package:bosta_clone_app/pages/shipment/all_shipments_screen.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/services/pickup_location_provider.dart';
import 'package:bosta_clone_app/services/pickup_provider.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PickupsPage extends StatefulWidget {
  @override
  _PickupsPageState createState() => _PickupsPageState();
}

final GlobalKey<ScaffoldState> pickUpsScaffoldKey =
    new GlobalKey<ScaffoldState>();

class _PickupsPageState extends State<PickupsPage> {
  ScrollController allPickupsScrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var provShipment = Provider.of<PickUpProvider>(context, listen: false);
      allPickupsScrollController.addListener(() async {
        if (allPickupsScrollController.position.pixels ==
            allPickupsScrollController.position.maxScrollExtent) {
          provShipment.increaseCounter();
          await provShipment.getAllPickups();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provPickups = Provider.of<PickUpProvider>(context);
    var provPickUpLocation = Provider.of<PickUpLocationProvider>(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: pickUpsScaffoldKey,
        appBar: AppBar(
          title: Text(
            AppLocale.of(context).getTranslated("all_pickup"),
            style: TextStyle(color: CustomColors.gray),
          ),
          backgroundColor: CustomColors.trans,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.sort,
              color: CustomColors.dark,
            ),
            onPressed: () {
              pickUpsScaffoldKey.currentState.openDrawer();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: CustomColors.thirdPrimary,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()));
              },
            )
          ],
        ),
        drawer: SameDrawer(),
        body: RefreshIndicator(
          color: CustomColors.primary,
          onRefresh: () async {
            await Future.delayed(
              Duration(milliseconds: 1000),
            );
            provPickups.resetCounter();

            if (!await provPickups.getAllPickups()) {
              return drawErrorSnackBar(
                scaffoldKey: pickUpsScaffoldKey,
                errorMassage: provPickups.error,
              );
            }
          },
          child: _drawBody(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            provPickUpLocation.getAllPickupsLocation();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePickup(),
              ),
            );
          },
          backgroundColor: CustomColors.primary,
          child: FaIcon(FontAwesomeIcons.shippingFast),
        ),
      ),
    );
  }

  Widget _drawBody() {
    var allPickupsProvider = Provider.of<PickUpProvider>(context);
    if (allPickupsProvider.allPickups.length < 1) {
      switch (allPickupsProvider.stateOfPickups) {
        case AllStates.Init:
          return drawImageBackground("assets/images/image.png");
          break;
        case AllStates.Loading:
          return drawLoadingIndicator(context);
          break;
        case AllStates.Done:
          if (allPickupsProvider.responseCodeOfPickups == 200) {
            return _drawPickups(
              context: context,
              allPickups: allPickupsProvider.allPickups,
            );
          } else if (allPickupsProvider.responseCodeOfPickups == 401) {
            return drawBlockedShipment(
              onTapToDoReload: () async {
                await Future.delayed(
                  Duration(milliseconds: 1000),
                );
                if (!await allPickupsProvider.getAllPickups()) {
                  return drawErrorSnackBar(
                    scaffoldKey: pickUpsScaffoldKey,
                    errorMassage: allPickupsProvider.error,
                  );
                }
              },
            );
          } else if (allPickupsProvider.responseCodeOfPickups == 404) {
            return drawImageBackground("assets/images/image.png");
          } else if (allPickupsProvider.responseCodeOfPickups == 500) {
            return drawImageBackground("assets/images/Not_connected.png");
          }
          break;
      }
    } else {
      return _drawPickups(
          context: context,
          allPickups: allPickupsProvider.allPickups,
          responseCode: allPickupsProvider.responseCodeOfPickups);
    }
    return Container();
  }

  Widget _drawPickups({context, allPickups, responseCode}) {
    var allPickUpsProvider = Provider.of<PickUpProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        controller: allPickupsScrollController,
        itemBuilder: (context, index) {
          if (index == allPickUpsProvider.allPickups.length) {
            return responseCode == 200
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: CustomColors.primary,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.thirdPrimary),
                    ),
                  )
                : Container();
          }
          return Padding(
            padding: EdgeInsets.only(right: 15, left: 20, top: 20, bottom: 20),
            child: _pickUpCard(
                context, index, allPickUpsProvider.allPickups[index]),
          );
        },
        itemCount: allPickUpsProvider.allPickups.length + 1,
      ),
    );
  }

  Widget _pickUpCard(
    BuildContext context,
    pos,
    PickupModel data,
  ) {
    var allPickupsProvider =
        Provider.of<PickUpProvider>(context, listen: false);

    return Stack(
      children: [
        InkWell(
          onTap: () async {
            allPickupsProvider.getSinglePickup(data.id);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SinglePickupScreen()));
          },
          child: Container(
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
                      _drawShipmentId(),
                      SizedBox(
                        height: 10,
                      ),
                      _drawShipmentIdVal(data.id),
                      SizedBox(
                        height: 16,
                      ),
                      _drawPerson(),
                      SizedBox(
                        height: 10,
                      ),
                      _drawPersonVal(data.personName),
                      SizedBox(
                        height: 16,
                      ),
                      _drawPersonPhone(),
                      SizedBox(
                        height: 16,
                      ),
                      _drawPersonPhoneVal(data.personPhone),
                      SizedBox(
                        height: 16,
                      ),
                      _drawRowOfStateAndLocation(
                          state: data.status, location: data.pickupLocation),
                      SizedBox(
                        height: 16,
                      ),
                      _drawDetailsRow(data.date,
                          data.repeat == 1 ? data.repeatType : "N/A"),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentId() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          AppLocale.of(context).getTranslated("shipment_id"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentIdVal(shipmentId) {
    return Row(
      children: <Widget>[
        Text(
          shipmentId.toString(),
          style: TextStyle(
            fontSize: 14,
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
            fontSize: 14,
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
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
            fontSize: 14,
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
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _drawRowOfStateAndLocation({
    location,
    state,
  }) {
    return Row(
      children: [
        Column(
          children: [
            _drawStates(),
            SizedBox(
              height: 10,
            ),
            _drawStatesVal(state),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
        ),
        Column(
          children: [
            _drawShipmentLocation(),
            SizedBox(
              height: 10,
            ),
            _drawShipmentLocationVal(location),
          ],
        ),
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
            fontSize: 14,
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
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _drawStates() {
    return Row(
      children: <Widget>[
        Text(
          AppLocale.of(context).getTranslated("status"),
          style: TextStyle(fontSize: 14, color: CustomColors.grayBackground),
        ),
      ],
    );
  }

  Widget _drawStatesVal(state) {
    return Row(
      children: <Widget>[
        Text(state,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[100])),
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
            fontSize: 14,
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
            fontSize: 14,
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
          style: TextStyle(fontSize: 14, color: CustomColors.grayBackground),
        ),
      ],
    );
  }

  Widget _drawPickupDataVal(date) {
    return Row(
      children: <Widget>[
        Text(date,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[100])),
      ],
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ShipmentsPage()));
    return null;
  }

  @override
  void dispose() {
    allPickupsScrollController.dispose();
    super.dispose();
  }
}
