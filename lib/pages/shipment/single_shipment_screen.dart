import 'package:bosta_clone_app/model/shipment/shipment_model.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class SingleShipmentScreen extends StatefulWidget {
  final ShipmentModel shipmentModel;

  SingleShipmentScreen({this.shipmentModel});

  @override
  _SingleShipmentScreenState createState() => _SingleShipmentScreenState();
}

class _SingleShipmentScreenState extends State<SingleShipmentScreen> {
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
              AppLocale.of(context).getTranslated("shipment_info"),
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
          body: SingleChildScrollView(
            child: Column(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _drawShipmentId(),
                            SizedBox(
                              height: 10,
                            ),
                            _drawShipmentIdVal(
                              widget.shipmentModel.id,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _drawReceiver(),
                            SizedBox(
                              height: 10,
                            ),
                            _drawReceiverVal(
                              widget.shipmentModel.receiverName,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _drawReceiverPhoneNumber(),
                            SizedBox(
                              height: 10,
                            ),
                            _drawReceiverPhoneNumberVal(
                              widget.shipmentModel.receiverPhone,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _drawStates(),
                            SizedBox(
                              height: 10,
                            ),
                            _drawStatesVal(
                              widget.shipmentModel.status,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _drawShipmentLocation(),
                            SizedBox(
                              height: 10,
                            ),
                            _drawShipmentLocationVal(
                              widget.shipmentModel.receiverArea,
                              widget.shipmentModel.receiverCity,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _drawDetailsRow(
                              widget.shipmentModel.packageType,
                              widget.shipmentModel.packagePrice,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _drawDetailsLocationRow(
                              widget.shipmentModel.receiverFloor,
                              widget.shipmentModel.receiverBuildNumber,
                              widget.shipmentModel.receiverApartment,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _drawShipmentDescription(),
                            SizedBox(
                              height: 10,
                            ),
                            _drawShipmentDescriptionVal(
                              widget.shipmentModel.packageDescription,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentIdVal(shipmentId) {
    return Row(
      children: <Widget>[
        SelectableText(
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

  Widget _drawReceiver() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocale.of(context).getTranslated("receiver"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 18,
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
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _drawReceiverPhoneNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocale.of(context).getTranslated("receiver_phone"),
          style: TextStyle(
            color: CustomColors.grayBackground,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _drawReceiverPhoneNumberVal(phoneNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          phoneNumber,
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
        Text(state,
            style: TextStyle(
                fontSize: 18,
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
            fontSize: 18,
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
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _drawDetailsLocationRow(
    floor,
    buildNumber,
    apartment,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _drawReceiverFloor(),
              SizedBox(
                height: 10,
              ),
              _drawReceiverFloorVal(
                floor,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _drawReceiverBuildNumber(),
              SizedBox(
                height: 10,
              ),
              _drawReceiverBuildNumberVal(
                buildNumber,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _drawReceiverApartment(),
              SizedBox(
                height: 10,
              ),
              _drawReceiverApartmentVal(
                apartment,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _drawReceiverFloor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.22,
          child: Center(
            child: Text(
              AppLocale.of(context).getTranslated("receiver_floor"),
              style: TextStyle(
                color: CustomColors.grayBackground,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _drawReceiverFloorVal(floor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          floor,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _drawReceiverBuildNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.22,
          child: Center(
            child: Text(
              AppLocale.of(context).getTranslated("receiver_building_number"),
              style: TextStyle(
                fontSize: 16,
                color: CustomColors.grayBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _drawReceiverBuildNumberVal(
    buildNumber,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          buildNumber.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[100],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _drawReceiverApartment() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.22,
          child: Center(
            child: Text(
              AppLocale.of(context).getTranslated("receiver_apartment"),
              style: TextStyle(
                fontSize: 16,
                color: CustomColors.grayBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _drawReceiverApartmentVal(
    apartment,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          apartment.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[100],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _drawDetailsRow(
    type,
    cost,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              _drawShipmentTypeVal(
                type,
              ),
            ],
          ),
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
              _drawShipmentCostVal(
                cost,
              ),
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
            fontSize: 18,
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
            fontSize: 18,
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
          style: TextStyle(
            fontSize: 18,
            color: CustomColors.grayBackground,
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentCostVal(cost) {
    return Row(
      children: <Widget>[
        Text(
          cost.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[100],
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentDescription() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          AppLocale.of(context).getTranslated("shipment_description"),
          style: TextStyle(
            fontSize: 18,
            color: CustomColors.grayBackground,
          ),
        ),
      ],
    );
  }

  Widget _drawShipmentDescriptionVal(
    description,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          description,
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
