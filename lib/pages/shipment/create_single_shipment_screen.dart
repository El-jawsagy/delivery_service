import 'package:bosta_clone_app/pages/samilier_widget/form_widget.dart';
import 'package:bosta_clone_app/pages/samilier_widget/screen_handle_widget.dart';
import 'package:bosta_clone_app/pages/shipment/all_shipments_screen.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/services/cities_provider.dart';
import 'package:bosta_clone_app/services/shipment_packge_type_provider.dart';
import 'package:bosta_clone_app/services/shipment_provider.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CreateShipment extends StatefulWidget {
  @override
  _CreateShipmentState createState() => _CreateShipmentState();
}

class _CreateShipmentState extends State<CreateShipment> {
  final GlobalKey<ScaffoldState> _createShipmentScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final _createShipmentFormKey = GlobalKey<FormState>();

  TextEditingController _receiverName;
  TextEditingController _receiverFloor;
  TextEditingController _receiveraddress;
  TextEditingController _receiverBuildingNumber;
  TextEditingController _receiverApartment;
  TextEditingController _receiverPhoneNumber;
  TextEditingController _shipmentDescription;
  TextEditingController _shipmentItemCount;

  @override
  void initState() {
    _receiverName = TextEditingController();
    _receiverFloor = TextEditingController();
    _receiveraddress = TextEditingController();
    _receiverBuildingNumber = TextEditingController();
    _receiverApartment = TextEditingController();
    _receiverPhoneNumber = TextEditingController();
    _shipmentDescription = TextEditingController();
    _shipmentItemCount = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var createShipmentProvider = Provider.of<ShipmentsProvider>(context);
    var addressProv = Provider.of<CitiesProvider>(context, listen: false);
    var packageProv = Provider.of<PackageTypesProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        key: _createShipmentScaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: CustomColors.primary, //change your color here
          ),
          title: Text(
            AppLocale.of(context).getTranslated("create_shipment"),
            style: TextStyle(color: CustomColors.gray),
          ),
          backgroundColor: CustomColors.trans,
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _createShipmentFormKey,
                child: Column(
                  children: [
                    drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text: AppLocale.of(context).getTranslated("receiver"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 16.0,
                    ),
                    drawTextFormField(
                        lines: 1,
                        context: context,
                        formKey: _createShipmentFormKey,
                        hintInputToUser: AppLocale.of(context)
                            .getTranslated("your_receiver_name"),
                        controller: _receiverName,
                        inputType: TextInputType.name),
                    drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text:
                          AppLocale.of(context).getTranslated("receiver_phone"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 16.0,
                    ),
                    drawTextFormField(
                        lines: 1,
                        context: context,
                        hintInputToUser:
                            AppLocale.of(context).getTranslated("your_phone"),
                        controller: _receiverPhoneNumber,
                        inputType: TextInputType.phone),
                    drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text: AppLocale.of(context)
                          .getTranslated("your_shipment_description"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 16.0,
                    ),
                    drawTextField(
                        lines: 8,
                        context: context,
                        hintInputToUser: AppLocale.of(context)
                            .getTranslated("shipment_description"),
                        controller: _shipmentDescription,
                        inputType: TextInputType.multiline),
                    drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text: AppLocale.of(context).getTranslated("address"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 16.0,
                    ),
                    drawTextFormField(
                        lines: 3,
                        context: context,
                        formKey: _createShipmentFormKey,
                        hintInputToUser:
                            AppLocale.of(context).getTranslated("your_address"),
                        controller: _receiveraddress,
                        inputType: TextInputType.streetAddress),
                    drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text: AppLocale.of(context)
                          .getTranslated("receiver_building_number"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 16.0,
                    ),
                    drawTextFormField(
                        lines: 1,
                        context: context,
                        formKey: _createShipmentFormKey,
                        hintInputToUser: AppLocale.of(context)
                            .getTranslated("your_receiver_building_number"),
                        controller: _receiverBuildingNumber,
                        inputType: TextInputType.streetAddress),
                    drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text:
                          AppLocale.of(context).getTranslated("receiver_floor"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 16.0,
                    ),
                    drawTextFormField(
                      lines: 1,
                      context: context,
                      hintInputToUser: AppLocale.of(context)
                          .getTranslated("your_receiver_floor"),
                      controller: _receiverFloor,
                      formKey: _createShipmentFormKey,
                      inputType: TextInputType.streetAddress,
                    ),
                    drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text: AppLocale.of(context)
                          .getTranslated("receiver_apartment"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 16.0,
                    ),
                    drawTextFormField(
                        lines: 1,
                        context: context,
                        hintInputToUser: AppLocale.of(context)
                            .getTranslated("your_receiver_apartment"),
                        controller: _receiverApartment,
                        formKey: _createShipmentFormKey,
                        inputType: TextInputType.streetAddress),
                    drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text: AppLocale.of(context)
                          .getTranslated("shipment_item_count"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 16.0,
                    ),
                    drawTextFormField(
                        lines: 1,
                        context: context,
                        formKey: _createShipmentFormKey,
                        hintInputToUser: AppLocale.of(context)
                            .getTranslated("your_shipment_item_count"),
                        controller: _shipmentItemCount,
                        inputType: TextInputType.number),
                  ],
                ),
              ),
              drawTitleAndHeaderTextRow(
                currentContext: context,
                text:
                    AppLocale.of(context).getTranslated("choose_package_type"),
                textColor: CustomColors.dark,
                textSize: 18,
                horizontalPaddingSize: 16.0,
                verticalPaddingSize: 16.0,
              ),
              giveHeightSpace(height: 10),
              _drawPackageChooser(),
              giveHeightSpace(height: 10),
              drawTitleAndHeaderTextRow(
                currentContext: context,
                text: AppLocale.of(context).getTranslated("choose_city"),
                textColor: CustomColors.dark,
                textSize: 18,
                horizontalPaddingSize: 16.0,
                verticalPaddingSize: 16.0,
              ),
              giveHeightSpace(height: 10),
              _drawCityChooser(),
              giveHeightSpace(height: 10),
              drawTitleAndHeaderTextRow(
                currentContext: context,
                text: AppLocale.of(context).getTranslated("choose_area"),
                textColor: CustomColors.dark,
                textSize: 18,
                horizontalPaddingSize: 16.0,
                verticalPaddingSize: 16.0,
              ),
              _drawAreasDropButton(),
              giveHeightSpace(height: 10),
              (addressProv.selectedCity.id != 0 &&
                      addressProv.selectedArea.id != 0)
                  ? drawButton(
                      text: (createShipmentProvider.stateOfCreate ==
                              AllStates.Loading)
                          ? CircularProgressIndicator(
                              backgroundColor: CustomColors.primary,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.thirdPrimary),
                            )
                          : Text(
                              AppLocale.of(context)
                                  .getTranslated("create_shipment_button"),
                              style: TextStyle(
                                color: CustomColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      backGroundColor: CustomColors.primary,
                      height: 40.0,
                      width: MediaQuery.of(context).size.width * 0.85,
                      onPress: () async {
                        if (_createShipmentFormKey.currentState.validate()) {
                          if (!await createShipmentProvider
                              .createSingleShipment(
                            receiverName: _receiverName.text,
                            receiverPhone: _receiverPhoneNumber.text,
                            receiverAddress: _receiveraddress.text,
                            receiverCityId: addressProv.selectedCity.id,
                            receiverAreaId: addressProv.selectedArea.id,
                            receiverBuildingNumber:
                                _receiverBuildingNumber.text,
                            receiverFloor: _receiverFloor.text,
                            receiverApartment: _receiverApartment.text,
                            packageTypeId: packageProv.packageTypeId,
                            packageNumberOfItems: _shipmentItemCount.text,
                            packageDescription: _shipmentDescription.text,
                          )) {
                            //todo:you need to handle all error in this part
                            //todo: don't forget to told kero to change the shape of map that give tou in error
                            _createShipmentScaffoldKey.currentState
                                .showSnackBar(SnackBar(
                              backgroundColor: CustomColors.primary,
                              content: Text(
                                createShipmentProvider.error,
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ));
                          } else {
                            createShipmentProvider.clearAllShipments();
                            createShipmentProvider.resetCounter();
                            createShipmentProvider.getAllShipment();

                            shipmentScaffoldKey.currentState
                                .showSnackBar(SnackBar(
                              backgroundColor: CustomColors.primary,
                              content: Text(
                                createShipmentProvider.message,
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ));
                            Navigator.pop(
                              context,
                            );
                          }
                        }
                      })
                  : drawButton(
                      text: Text(
                        AppLocale.of(context)
                            .getTranslated("create_shipment_button"),
                        style: TextStyle(
                          color: CustomColors.gray,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backGroundColor: CustomColors.grayBackground,
                      height: 40.0,
                      width: MediaQuery.of(context).size.width * 0.85,
                      onPress: () {
                        _createShipmentScaffoldKey.currentState
                            .showSnackBar(SnackBar(
                          backgroundColor: CustomColors.primary,
                          content: Text(
                            AppLocale.of(context)
                                .getTranslated("create_shipment_button_fail"),
                            style: TextStyle(
                              color: CustomColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ));
                      }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawPackageChooser() {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .1,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: deciderPackageTypeWidget(),
      ),
    );
  }

  Widget deciderPackageTypeWidget() {
    var provPackageType = Provider.of<PackageTypesProvider>(context);
    switch (provPackageType.stateOfPackageType) {
      case AllStates.Init:
      case AllStates.Loading:
        return drawLoadingIndicator(context);

        break;
      case AllStates.Done:
        return DropdownButtonHideUnderline(
          child: Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: .5,
                    style: BorderStyle.solid,
                    color: CustomColors.primary),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                value: provPackageType.selectedType,
                style: TextStyle(color: CustomColors.primary),
                items: provPackageType.allPackageTypesName.map(
                  (item) {
                    return DropdownMenuItem(
                        value: item,
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    item,
                                    style: TextStyle(
                                      color: CustomColors.gray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                ).toList(),
                onChanged: (change) {
                  setState(() {
                    provPackageType.selectType(change);
                  });
                },
              ),
            ),
          ),
        );

        break;
    }

    return Container();
  }

  Widget _drawCityChooser() {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .1,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: deciderWidget(),
      ),
    );
  }

  Widget deciderWidget() {
    var provCities = Provider.of<CitiesProvider>(context);
    switch (provCities.stateOfCities) {
      case AllStates.Init:
      case AllStates.Loading:
        return drawLoadingIndicator(context);

        break;
      case AllStates.Done:
        return DropdownButtonHideUnderline(
          child: Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: .5,
                    style: BorderStyle.solid,
                    color: CustomColors.primary),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                value: provCities.selectedCity.id,
                style: TextStyle(color: CustomColors.primary),
                items: provCities.allCities.map(
                  (city) {
                    return DropdownMenuItem(
                        value: city.id,
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    city.name,
                                    style: TextStyle(
                                      color: CustomColors.gray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                ).toList(),
                onChanged: (change) {
                  setState(() {
                    provCities.selectCity(change);
                    provCities.getAllAreas(change);
                  });
                },
              ),
            ),
          ),
        );

        break;
    }

    return Container();
  }

  Widget _drawAreasDropButton() {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .1,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: _deciderAreasWidget(),
      ),
    );
  }

  Widget _deciderAreasWidget() {
    var provAreas = Provider.of<CitiesProvider>(context);
    switch (provAreas.stateOfAreas) {
      case AllStates.Init:
        return Text(
          AppLocale.of(context).getTranslated("need_to_choose"),
          style: TextStyle(
            color: CustomColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        );
        break;
      case AllStates.Loading:
        return drawLoadingIndicator(context);

        break;
      case AllStates.Done:
        return DropdownButtonHideUnderline(
          child: Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: .5,
                    style: BorderStyle.solid,
                    color: CustomColors.primary),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                value: provAreas.selectedArea.id,
                style: TextStyle(color: CustomColors.primary),
                items: provAreas.allAreas.map(
                  (area) {
                    return DropdownMenuItem(
                        value: area.id,
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    area.name,
                                    style: TextStyle(
                                      color: CustomColors.gray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                ).toList(),
                onChanged: (change) {
                  provAreas.selectArea(change);
                },
              ),
            ),
          ),
        );

        break;
    }
    return Container();
  }
}
