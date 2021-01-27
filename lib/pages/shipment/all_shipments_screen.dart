import 'package:bosta_clone_app/model/shipment/shipment_model.dart';
import 'package:bosta_clone_app/pages/drawer.dart';
import 'package:bosta_clone_app/pages/notification/notifications_screen.dart';
import 'package:bosta_clone_app/pages/samilier_widget/screen_handle_widget.dart';
import 'package:bosta_clone_app/pages/shipment/create_single_shipment_screen.dart';
import 'package:bosta_clone_app/pages/shipment/single_shipment_screen.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/services/cities_provider.dart';
import 'package:bosta_clone_app/services/shipment_provider.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ShipmentsPage extends StatefulWidget {
  @override
  _ShipmentsPageState createState() => _ShipmentsPageState();
}

final GlobalKey<ScaffoldState> shipmentScaffoldKey =
    new GlobalKey<ScaffoldState>();

class _ShipmentsPageState extends State<ShipmentsPage> {
  ScrollController allShipmentScrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var provShipment = Provider.of<ShipmentsProvider>(context, listen: false);
      allShipmentScrollController.addListener(() async {
        if (allShipmentScrollController.position.pixels ==
            allShipmentScrollController.position.maxScrollExtent) {
          provShipment.increaseCounter();
          await provShipment.getAllShipment();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provShipment = Provider.of<ShipmentsProvider>(context);
    var provAddress = Provider.of<CitiesProvider>(context);

    return Scaffold(
        key: shipmentScaffoldKey,
        appBar: AppBar(
          title: Text(
            AppLocale.of(context).getTranslated("all_shipment"),
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
              shipmentScaffoldKey.currentState.openDrawer();
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
            provShipment.resetCounter();

            if (!await provShipment.getAllShipment()) {
              return drawErrorSnackBar(
                scaffoldKey: shipmentScaffoldKey,
                errorMassage: provShipment.error,
              );
            }
          },
          child: _drawBody(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            provAddress.getAllCities();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateShipment(),
              ),
            );
          },
          heroTag: "camera",
          backgroundColor: CustomColors.primary,
          child: FaIcon(FontAwesomeIcons.box),
        ));
  }

  Widget _drawBody() {
    var allShipmentProvider = Provider.of<ShipmentsProvider>(context);
    if (allShipmentProvider.allShipment.length < 1) {
      switch (allShipmentProvider.state) {
        case AllStates.Init:
          return drawImageBackground("assets/images/image.png");
          break;
        case AllStates.Loading:
          return drawLoadingIndicator(context);
          break;
        case AllStates.Done:
          if (allShipmentProvider.responseCodeOfShipments == 200) {
            return _drawShipment(
              context: context,
              allShipment: allShipmentProvider.allShipment,
            );
          } else if (allShipmentProvider.responseCodeOfShipments == 401) {
            return drawBlockedShipment(
              onTapToDo: () async {
                await Future.delayed(
                  Duration(milliseconds: 1000),
                );
                allShipmentProvider.resetCounter();
                if (!await allShipmentProvider.getAllShipment()) {
                  return drawErrorSnackBar(
                    scaffoldKey: shipmentScaffoldKey,
                    errorMassage: allShipmentProvider.error,
                  );
                }
              },
            );
          } else if (allShipmentProvider.responseCodeOfShipments == 404) {
            return drawImageBackground("assets/images/image.png");
          } else if (allShipmentProvider.responseCodeOfShipments == 500) {
            return drawImageBackground("assets/images/Not_connected.png");
          }
          break;
      }
    } else {
      return _drawShipment(
          context: context,
          allShipment: allShipmentProvider.allShipment,
          responseCode: allShipmentProvider.responseCodeOfShipments);
    }

    return Container();
  }

  Widget _drawShipment({context, allShipment, responseCode}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        controller: allShipmentScrollController,
        itemBuilder: (context, index) {
          if (index == allShipment.length) {
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
            child: _shipmentCard(allShipment[index]),
          );
        },
        itemCount: allShipment.length + 1,
      ),
    );
  }

  Widget _shipmentCard(ShipmentModel data) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: ExactAssetImage("assets/images/fatima.jpg"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
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
                    _drawShipmentIdVal(data),
                    SizedBox(
                      height: 16,
                    ),
                    _drawReceiver(),
                    SizedBox(
                      height: 10,
                    ),
                    _drawReceiverVal(data.receiverName),
                    SizedBox(
                      height: 16,
                    ),
                    _drawRowOfStateAndLocation(
                      state: data.status,
                      city: data.receiverCity,
                      area: data.receiverArea,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    _drawDetailsRow(data.packageType, data.packagePrice),
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

  Widget _drawShipmentIdVal(shipment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SelectableText(
          shipment.id.toString(),
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
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

  Widget _drawReceiver() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocale.of(context).getTranslated("receiver"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _drawReceiverVal(receiverName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          receiverName,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _drawRowOfStateAndLocation({
    city,
    area,
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
            _drawShipmentLocationVal(city, area),
          ],
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

  Widget _drawShipmentLocationVal(city, area) {
    return Row(
      children: [
        Text(
          '$city, $area',
          style: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _drawDetailsRow(type, cost) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _drawShipmentType(),
              SizedBox(
                height: 10,
              ),
              _drawShipmentTypeVal(type),
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
              _drawShipmentCost(),
              SizedBox(
                height: 10,
              ),
              _drawShipmentCostVal(cost),
            ],
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          AppLocale.of(context).getTranslated("shipment_type"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentTypeVal(type) {
    return Row(
      children: <Widget>[
        Text(
          type,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentCost() {
    return Row(
      children: <Widget>[
        Text(
          AppLocale.of(context).getTranslated("shipment_cost"),
          style: TextStyle(fontSize: 14, color: CustomColors.grayBackground),
        ),
      ],
    );
  }

  Widget _drawShipmentCostVal(cost) {
    return Row(
      children: <Widget>[
        Text(cost.toString(),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[100])),
      ],
    );
  }

  @override
  void dispose() {
    allShipmentScrollController.dispose();
    super.dispose();
  }
}
