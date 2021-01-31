import 'package:bosta_clone_app/pages/auth/verify_phone_number.dart';
import 'package:bosta_clone_app/pages/samilier_widget/form_widget.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/services/authentication.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class SingUpPage extends StatefulWidget {
  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  int _radioValue = 0;
  ValueNotifier<bool> _checkboxValue;

  IconData _icon = Icons.visibility_off;
  bool _isVisible = true;
  bool _isHash = true;

  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _firstName;
  TextEditingController _lastName;
  TextEditingController _phoneNumber;
  TextEditingController _confirmPassword;

  final GlobalKey<ScaffoldState> _signUpKey = GlobalKey<ScaffoldState>();
  final _signUpFormKey = GlobalKey<FormState>();

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _phoneNumber = TextEditingController();
    _confirmPassword = TextEditingController();
    _checkboxValue = ValueNotifier(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authenticationProvider = Provider.of<AuthProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _signUpKey,
        backgroundColor: CustomColors.background,
        body: SingleChildScrollView(
          child: Form(
            key: _signUpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                giveHeightSpace(
                  height: 50,
                ),
                drawLogo(height: .22, currentContext: context),
                drawTitleAndHeaderTextRow(
                  currentContext: context,
                  text: AppLocale.of(context).getTranslated("register_welcome"),
                  textColor: CustomColors.dark,
                  textSize: 16,
                  horizontalPaddingSize: 16.0,
                  verticalPaddingSize: 2.0,
                ),
                drawTitleAndHeaderTextRow(
                  currentContext: context,
                  text: AppLocale.of(context).getTranslated("register_message"),
                  textColor: CustomColors.secondPrimary,
                  textSize: 28,
                  horizontalPaddingSize: 16.0,
                  verticalPaddingSize: 8.0,
                ),
                drawTitleAndHeaderTextRow(
                  currentContext: context,
                  text: AppLocale.of(context).getTranslated("first_name"),
                  textColor: CustomColors.dark,
                  textSize: 18,
                  horizontalPaddingSize: 16.0,
                  verticalPaddingSize: 16.0,
                ),
                drawTextFormField(
                    lines: 1,
                    context: context,
                    formKey: _signUpFormKey,
                    hintInputToUser:
                        AppLocale.of(context).getTranslated("your_first"),
                    controller: _firstName,
                    inputType: TextInputType.name),
                drawTitleAndHeaderTextRow(
                  currentContext: context,
                  text: AppLocale.of(context).getTranslated("last_name"),
                  textColor: CustomColors.dark,
                  textSize: 18,
                  horizontalPaddingSize: 16.0,
                  verticalPaddingSize: 16.0,
                ),
                drawTextFormField(
                    lines: 1,
                    context: context,
                    formKey: _signUpFormKey,
                    hintInputToUser:
                        AppLocale.of(context).getTranslated("your_last"),
                    controller: _lastName,
                    inputType: TextInputType.name),
                drawTitleAndHeaderTextRow(
                  currentContext: context,
                  text: AppLocale.of(context).getTranslated("phone"),
                  textColor: CustomColors.dark,
                  textSize: 18,
                  horizontalPaddingSize: 16.0,
                  verticalPaddingSize: 16.0,
                ),
                drawTextFormField(
                    lines: 1,
                    context: context,
                    formKey: _signUpFormKey,
                    hintInputToUser:
                        AppLocale.of(context).getTranslated("your_phone"),
                    controller: _phoneNumber,
                    inputType: TextInputType.phone),
                drawTitleAndHeaderTextRow(
                  currentContext: context,
                  text: AppLocale.of(context).getTranslated("email"),
                  textColor: CustomColors.dark,
                  textSize: 18,
                  horizontalPaddingSize: 16.0,
                  verticalPaddingSize: 16.0,
                ),
                drawTextFormField(
                    lines: 1,
                    context: context,
                    formKey: _signUpFormKey,
                    hintInputToUser:
                        AppLocale.of(context).getTranslated("your_email"),
                    controller: _email,
                    inputType: TextInputType.emailAddress),
                drawTitleAndHeaderTextRow(
                  currentContext: context,
                  text: AppLocale.of(context).getTranslated("pass"),
                  textColor: CustomColors.dark,
                  textSize: 18,
                  horizontalPaddingSize: 16.0,
                  verticalPaddingSize: 16.0,
                ),
                _drawPasswordTextField(
                  text: AppLocale.of(context).getTranslated("your_pass"),
                  controller: _password,
                ),
                drawTitleAndHeaderTextRow(
                  currentContext: context,
                  text: AppLocale.of(context).getTranslated("conf_pass"),
                  textColor: CustomColors.dark,
                  textSize: 18,
                  horizontalPaddingSize: 16.0,
                  verticalPaddingSize: 16.0,
                ),
                _drawPasswordTextField(
                  text: AppLocale.of(context).getTranslated("your_conf"),
                  controller: _confirmPassword,
                ),
                giveHeightSpace(
                  height: 20,
                ),
                drawTitleAndHeaderTextRow(
                  currentContext: context,
                  text: AppLocale.of(context).getTranslated("shipment_val"),
                  textColor: CustomColors.dark,
                  textSize: 18,
                  horizontalPaddingSize: 16.0,
                  verticalPaddingSize: 16.0,
                ),
                _drawRadioGroupOfShipment(),
                giveHeightSpace(
                  height: 20,
                ),
                drawCheckBox(
                  context: context,
                  checkboxValue: _checkboxValue,
                  onPressed: () {
                    setState(() {
                      _checkboxValue.value = !_checkboxValue.value;
                    });
                  },
                  checkboxText:
                      AppLocale.of(context).getTranslated("check_massage"),
                ),
                giveHeightSpace(
                  height: 20,
                ),
                _drawButtonDecider(
                  text:
                      authenticationProvider.state == AuthStates.authenticating
                          ? CircularProgressIndicator(
                              backgroundColor: CustomColors.primary,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.thirdPrimary),
                            )
                          : Text(
                              AppLocale.of(context).getTranslated("register"),
                              style: TextStyle(
                                color: CustomColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  backGroundColor: CustomColors.secondPrimary,
                  width: MediaQuery.of(context).size.width * 0.85,
                  body: () async {
                    if (_signUpFormKey.currentState.validate()) {
                      if (!await authenticationProvider.singUp(
                        _firstName.text,
                        _lastName.text,
                        _phoneNumber.text,
                        _email.text,
                        _password.text,
                        _radioValue,
                      )) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyPhoneNumberPage()));
                      } else {
                        _signUpKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: CustomColors.primary,
                          content: Text(
                            authenticationProvider.error,
                            style: TextStyle(
                              color: CustomColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ));
                      }
                    }
                  },
                  type: "sign",
                ),
                giveHeightSpace(height: 40),
                _drawLoginText(),
                giveHeightSpace(height: 20),
                _drawButtonDecider(
                  text: Text(
                    AppLocale.of(context).getTranslated("login"),
                    style: TextStyle(
                      color: CustomColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backGroundColor: CustomColors.primary,
                  width: MediaQuery.of(context).size.width * 0.85,
                  body: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  type: "log",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawPasswordTextField(
      {String text, TextEditingController controller}) {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      child: TextFormField(
        controller: controller,
        obscureText: _isHash,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              if (_isVisible) {
                setState(() {
                  _icon = Icons.visibility;
                  _isHash = false;
                  _isVisible = false;
                });
              } else if (!_isVisible) {
                setState(() {
                  _icon = Icons.visibility_off;
                  _isHash = true;
                  _isVisible = true;
                });
              }
            },
            icon: Icon(
              _icon,
              color: CustomColors.dark,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: CustomColors.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(width: .2),
          ),
          hintText: text,
        ),
        validator: (val) {
          if (val.isNotEmpty) {
            if (_password.text.isNotEmpty && _confirmPassword.text.isNotEmpty) {
              print("i am here1");
              if (_password.text != _confirmPassword.text) {
                print("i am here2");

                return AppLocale.of(context).getTranslated("not_matching");
              }
            }
          } else if (val.isEmpty) {
            print("i am here3");

            return AppLocale.of(context).getTranslated("is_required");
          }
          return null;
        },
      ),
    );
  }

  Widget _drawRadioGroupOfShipment() {
    return Column(
      children: [
        drawSingleRadio(
          context: context,
          index: 0,
          title: AppLocale.of(context).getTranslated("single_shipment"),
          subTitle: AppLocale.of(context).getTranslated("single_massage"),
          onPressed: _handleRadioValueChange,
          valueOfRadioGroup: _radioValue,
        ),
        drawSingleRadio(
          context: context,
          index: 1,
          title: AppLocale.of(context).getTranslated("lite_shipment"),
          subTitle: AppLocale.of(context).getTranslated("lite_massage"),
          onPressed: _handleRadioValueChange,
          valueOfRadioGroup: _radioValue,
        ),
        drawSingleRadio(
          context: context,
          index: 2,
          title: AppLocale.of(context).getTranslated("pro_shipment"),
          subTitle: AppLocale.of(context).getTranslated("pro_massage"),
          onPressed: _handleRadioValueChange,
          valueOfRadioGroup: _radioValue,
        ),
      ],
    );
  }

  Widget _drawButtonDecider(
      {Color backGroundColor,
      double width,
      Widget text,
      Function body,
      String type}) {
    return type == "sign"
        ? ValueListenableBuilder(
            valueListenable: _checkboxValue,
            builder: (BuildContext context, bool value, Widget child) {
              return _checkboxValue.value
                  ? _drawButton(
                      backGroundColor: backGroundColor,
                      width: width,
                      text: text,
                      body: body)
                  : Container(
                      height: 40,
                      width: width,
                      child: Center(child: text),
                      decoration: BoxDecoration(
                        color: CustomColors.grayBackground,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                    );
            },
          )
        : _drawButton(
            backGroundColor: backGroundColor,
            width: width,
            text: text,
            body: body);
  }

  Widget _drawButton(
      {Color backGroundColor, double width, Widget text, Function body}) {
    return FlatButton(
      color: backGroundColor,
      height: 40,
      minWidth: width,
      onPressed: body,
      child: text,
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
        side: BorderSide(
          color: backGroundColor,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
    );
  }

  Widget _drawLoginText() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Divider(
              color: CustomColors.gray,
              height: 3,
            ),
          ),
          Container(
            child: Text(
              AppLocale.of(context).getTranslated("register_qes"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Divider(
              color: CustomColors.gray,
              height: 3,
            ),
          ),
        ],
      ),
    );
  }
}
