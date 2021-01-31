import 'package:bosta_clone_app/pages/pickup/all_pickups_screen.dart';
import 'package:bosta_clone_app/pages/samilier_widget/form_widget.dart';
import 'package:bosta_clone_app/pages/samilier_widget/screen_handle_widget.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/services/authentication.dart';
import 'package:bosta_clone_app/services/pickup_location_provider.dart';
import 'package:bosta_clone_app/services/pickup_provider.dart';
import 'package:bosta_clone_app/services/preson_pickup_location_provider.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreatePickup extends StatefulWidget {
  @override
  _CreatePickupState createState() => _CreatePickupState();
}

class _CreatePickupState extends State<CreatePickup> {
  final GlobalKey<ScaffoldState> _createPickUpScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final _createPickupFormKey = GlobalKey<FormState>();
  int _radioValue = 0;
  String dateTime;
  DateTime selectedDate;
  DateTime selectedRepeatStartDate;
  DateTime selectedRepeatEndDate;
  TextEditingController _shipmentId;
  TextEditingController _pickupNote;
  TextEditingController _dateController;
  TextEditingController _dateRepeatStartController;
  TextEditingController _dateRepeatEndController;
  TextEditingController _repeatTypeController;
  ValueNotifier<bool> _checkboxValue;

  @override
  void initState() {
    selectedDate = DateTime.now().add(Duration(days: 1));
    selectedRepeatStartDate = DateTime.now().add(Duration(days: 2));
    selectedRepeatEndDate = DateTime.now().add(Duration(days: 4));
    _shipmentId = TextEditingController();
    _dateRepeatStartController = TextEditingController();
    _dateRepeatEndController = TextEditingController();
    _pickupNote = TextEditingController();
    _dateController = TextEditingController();
    _repeatTypeController = TextEditingController();
    _repeatTypeController.text = "daily";
    _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    _dateRepeatStartController.text =
        DateFormat('yyyy-MM-dd').format(selectedRepeatStartDate);
    _dateRepeatEndController.text =
        DateFormat('yyyy-MM-dd').format(selectedRepeatEndDate);
    _checkboxValue = ValueNotifier(false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var createPickUpProvider = Provider.of<PickUpProvider>(context);
    var userProvider = Provider.of<AuthProvider>(context);
    var locationProvider =
        Provider.of<PickUpLocationProvider>(context, listen: false);
    var personProvider =
        Provider.of<PersonPickUpLocationProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        key: _createPickUpScaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: CustomColors.primary, //change your color here
          ),
          title: Text(
            AppLocale.of(context).getTranslated("create_pickup"),
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
                key: _createPickupFormKey,
                child: Column(children: [
                  drawTitleAndHeaderTextRow(
                    currentContext: context,
                    text: AppLocale.of(context).getTranslated("shipment_id"),
                    textColor: CustomColors.dark,
                    textSize: 18,
                    horizontalPaddingSize: 16.0,
                    verticalPaddingSize: 16.0,
                  ),
                  drawTextFormField(
                      lines: 1,
                      context: context,
                      formKey: _createPickupFormKey,
                      hintInputToUser: AppLocale.of(context)
                          .getTranslated("your_shipment_id"),
                      controller: _shipmentId,
                      inputType: TextInputType.name),
                  drawTitleAndHeaderTextRow(
                    currentContext: context,
                    text:
                        AppLocale.of(context).getTranslated("pickup_date_send"),
                    textColor: CustomColors.dark,
                    textSize: 18,
                    horizontalPaddingSize: 16.0,
                    verticalPaddingSize: 12.0,
                  ),
                  _drawDataPiker(
                      dateSelected: selectedDate,
                      dateController: _dateController,
                      initSelected: DateTime.now().add(Duration(days: 1))),
                  drawTitleAndHeaderTextRow(
                    currentContext: context,
                    text: AppLocale.of(context).getTranslated("pickup_notes"),
                    textColor: CustomColors.dark,
                    textSize: 18,
                    horizontalPaddingSize: 16.0,
                    verticalPaddingSize: 16.0,
                  ),
                  drawTextFormField(
                      lines: 8,
                      context: context,
                      formKey: _createPickupFormKey,
                      hintInputToUser: AppLocale.of(context)
                          .getTranslated("your_pickup_notes"),
                      controller: _pickupNote,
                      inputType: TextInputType.multiline),
                ]),
              ),
              drawTitleAndHeaderTextRow(
                currentContext: context,
                text: AppLocale.of(context).getTranslated("address_location"),
                textColor: CustomColors.dark,
                textSize: 18,
                horizontalPaddingSize: 16.0,
                verticalPaddingSize: 16.0,
              ),
              giveHeightSpace(height: 10),
              _drawPickUpLocationsChooser(),
              giveHeightSpace(height: 10),
              drawTitleAndHeaderTextRow(
                currentContext: context,
                text: AppLocale.of(context).getTranslated("choose_person"),
                textColor: CustomColors.dark,
                textSize: 18,
                horizontalPaddingSize: 16.0,
                verticalPaddingSize: 16.0,
              ),
              giveHeightSpace(height: 10),
              _drawPersonsChooser(),
              giveHeightSpace(height: 10),
              userProvider.user.subscripitionType != "single"
                  ? drawCheckBox(
                      context: context,
                      checkboxValue: _checkboxValue,
                      onPressed: () {
                        setState(() {
                          _checkboxValue.value = !_checkboxValue.value;
                        });
                      },
                      checkboxText: AppLocale.of(context)
                          .getTranslated("pickup_repeat_ques"),
                    )
                  : Container(),
              _checkboxValue.value
                  ? drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text: AppLocale.of(context)
                          .getTranslated("pickup_repeat_type"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 16.0,
                    )
                  : Container(),
              _checkboxValue.value ? giveHeightSpace(height: 10) : Container(),
              _checkboxValue.value ? _drawRadioGroupOfShipment() : Container(),
              _checkboxValue.value
                  ? drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text: AppLocale.of(context)
                          .getTranslated("pickup_date_send_repeat_first"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 12.0,
                    )
                  : Container(),
              _checkboxValue.value
                  ? _drawDataPiker(
                      dateSelected: selectedRepeatStartDate,
                      dateController: _dateRepeatStartController,
                      initSelected: selectedDate,
                    )
                  : Container(),
              _checkboxValue.value
                  ? drawTitleAndHeaderTextRow(
                      currentContext: context,
                      text: AppLocale.of(context)
                          .getTranslated("pickup_date_send_repeat_end"),
                      textColor: CustomColors.dark,
                      textSize: 18,
                      horizontalPaddingSize: 16.0,
                      verticalPaddingSize: 12.0,
                    )
                  : Container(),
              _checkboxValue.value
                  ? _drawDataPiker(
                      dateSelected: selectedRepeatEndDate,
                      dateController: _dateRepeatEndController,
                      initSelected: selectedRepeatStartDate,
                    )
                  : Container(),
              giveHeightSpace(height: 10),
              (locationProvider.selectedLocation.id != 0 &&
                      personProvider.selectedPersonInLocation.id != 0)
                  ? drawButton(
                      text: (createPickUpProvider.stateOfCreatePickup ==
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
                      width: MediaQuery.of(context).size.width * 0.85,
                  height: 40.0,

                  onPress: () async {
                        if (_createPickupFormKey.currentState.validate()) {
                          if (!await createPickUpProvider.createSinglePickup(
                            shipmentId: _shipmentId.text,
                            pickupLocationId:
                                locationProvider.selectedLocation.id,
                            personId:
                                personProvider.selectedPersonInLocation.id,
                            repeat: _checkboxValue.value ? 1 : 0,
                            repeatType: _repeatTypeController.text,
                            repeatStartDate: _dateRepeatStartController.text,
                            repeatEndDate: _dateRepeatEndController.text,
                            date: _dateController.text,
                            notes: _pickupNote,
                          )) {
                            //todo:you need to handle all error in this part
                            //todo: don't forget to told kero to change the shape of map that give tou in error
                            _createPickUpScaffoldKey.currentState
                                .showSnackBar(SnackBar(
                              backgroundColor: CustomColors.primary,
                              content: Text(
                                createPickUpProvider.error,
                                style: TextStyle(
                                  color: CustomColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ));
                          } else {
                            createPickUpProvider.clearAllPickups();

                            createPickUpProvider.resetCounter();
                            createPickUpProvider.getAllPickups();

                            pickUpsScaffoldKey.currentState
                                .showSnackBar(SnackBar(
                              duration: Duration(seconds: 1, milliseconds: 500),
                              backgroundColor: CustomColors.primary,
                              content: Text(
                                createPickUpProvider.messageCreate,
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
                      width: MediaQuery.of(context).size.width * 0.85,
                  height: 40.0,

                  onPress: () {
                        _createPickUpScaffoldKey.currentState
                            .showSnackBar(SnackBar(
                          duration: Duration(seconds: 1, milliseconds: 500),
                          backgroundColor: CustomColors.primary,
                          content: Text(
                            AppLocale.of(context)
                                .getTranslated("create_pickup_button_fail"),
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

  Widget _drawRadioGroupOfShipment() {
    return Column(
      children: [
        drawSingleRadio(
          context: context,
          index: 0,
          title: AppLocale.of(context).getTranslated("pickup_repeat_daily"),
          onPressed: _handleRadioValueChange,
          valueOfRadioGroup: _radioValue,
        ),
        drawSingleRadio(
          context: context,
          index: 1,
          title: AppLocale.of(context).getTranslated("pickup_repeat_monthly"),
          onPressed: _handleRadioValueChange,
          valueOfRadioGroup: _radioValue,
        ),
      ],
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _repeatTypeController.text = "daily";
          break;
        case 1:
          _repeatTypeController.text = "monthly";

          break;
      }
    });
  }

  Widget _drawDataPiker({
    DateTime dateSelected,
    TextEditingController dateController,
    DateTime initSelected,
  }) {
    return InkWell(
      onTap: () {
        _selectDate(
            context: context,
            selected: dateSelected,
            controller: dateController,
            initSelected: initSelected);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.height / 10,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: CustomColors.fourPrimary,
          borderRadius: BorderRadius.circular(7),
        ),
        child: TextFormField(
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
          enabled: false,
          keyboardType: TextInputType.text,
          controller: dateController,
          decoration: InputDecoration(
              disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.only(top: 0.0)),
        ),
      ),
    );
  }

  Future<Null> _selectDate({
    BuildContext context,
    DateTime selected,
    DateTime initSelected,
    TextEditingController controller,
  }) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selected,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: initSelected,
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null)
      setState(() {
        selected = picked;
        controller.text = DateFormat.yMd().format(selected);
      });
  }

  Widget _drawPickUpLocationsChooser() {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .1,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: deciderPickUpLocationsWidget(),
      ),
    );
  }

  Widget deciderPickUpLocationsWidget() {
    var provPickupLocation = Provider.of<PickUpLocationProvider>(context);
    var provPickupPersonLocation =
        Provider.of<PersonPickUpLocationProvider>(context);
    switch (provPickupLocation.stateOfPickupLocation) {
      case AllStates.Init:
      case AllStates.Loading:
        return drawLoadingIndicator(context);

        break;
      case AllStates.Done:
        print(provPickupLocation.allPickupsLocation);
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
                value: provPickupLocation.selectedLocation.id,
                style: TextStyle(color: CustomColors.primary),
                items: provPickupLocation.allPickupsLocation.map(
                  (item) {
                    return DropdownMenuItem(
                        value: item.id,
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    item.name,
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
                    provPickupLocation.selectPickUpLocation(change);
                    provPickupPersonLocation
                        .getAllPersonInPickupsLocation(change);
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

  Widget _drawPersonsChooser() {
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
    var provPersonPickupLocation =
        Provider.of<PersonPickUpLocationProvider>(context);
    switch (provPersonPickupLocation.stateOfPersonPickupLocation) {
      case AllStates.Init:
        return Text(
          AppLocale.of(context).getTranslated("need_to_choose_location"),
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
                value: provPersonPickupLocation.selectedPersonInLocation.id,
                style: TextStyle(color: CustomColors.primary),
                items: provPersonPickupLocation.allPersonPickupsLocation.map(
                  (person) {
                    return DropdownMenuItem(
                        value: person.id,
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    person.firstName + "" + person.lastName,
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
                    provPersonPickupLocation.selectPickUpLocation(change);
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
}
