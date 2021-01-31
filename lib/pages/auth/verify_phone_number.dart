import 'package:bosta_clone_app/pages/samilier_widget/form_widget.dart';
import 'package:bosta_clone_app/pages/shipment/all_shipments_screen.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/services/authentication.dart';
import 'package:bosta_clone_app/services/shipment_provider.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  @override
  _VerifyPhoneNumberPageState createState() => _VerifyPhoneNumberPageState();
}

class _VerifyPhoneNumberPageState extends State<VerifyPhoneNumberPage> {
  final GlobalKey<ScaffoldState> _verifyKey = GlobalKey<ScaffoldState>();
  final _verifyFormKey = GlobalKey<FormState>();

  TextEditingController _verifyNumberController;

  @override
  void initState() {
    _verifyNumberController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authenticationProvider = Provider.of<AuthProvider>(context);
    var shipmentsProvider = Provider.of<ShipmentsProvider>(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _verifyKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: CustomColors.primary),
          backgroundColor: CustomColors.trans,
          elevation: 0,
          title: Text(
            AppLocale.of(context).getTranslated("verify_Page"),
            style: TextStyle(color: CustomColors.primary),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Form(
              key: _verifyFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  giveHeightSpace(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Image.asset(
                    "assets/images/chat.png",
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  giveHeightSpace(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  _drawTitleAndHeaderTextRowCustom(
                    currentContext: context,
                    text: AppLocale.of(context).getTranslated("verify_massage"),
                    textColor: CustomColors.gray,
                    textSize: 18,
                    horizontalPaddingSize: 16.0,
                    verticalPaddingSize: 16.0,
                  ),
                  giveHeightSpace(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  _drawTextFormField(
                    context: context,
                    controller: _verifyNumberController,
                    lines: 1,
                    hintInputToUser: AppLocale.of(context)
                        .getTranslated("verify_input_massage"),
                    inputType: TextInputType.number,
                  ),
                  giveHeightSpace(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  _drawResendCode(
                    onPress: () async {
                      await authenticationProvider.resendVerifyCode();
                    },
                    text: Text(
                      AppLocale.of(context).getTranslated("verify_resend"),
                      style: TextStyle(
                        color: CustomColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  giveHeightSpace(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  drawButton(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.07,
                    text: authenticationProvider.verifyCodeState ==
                            AuthStates.authenticating
                        ? CircularProgressIndicator(
                            backgroundColor: CustomColors.primary,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                CustomColors.thirdPrimary),
                          )
                        : Text(
                            AppLocale.of(context)
                                .getTranslated("verify_button"),
                            style: TextStyle(
                                color: (_verifyNumberController
                                            .text.isNotEmpty &&
                                        _verifyNumberController.text.length > 3)
                                    ? CustomColors.white
                                    : CustomColors.gray),
                          ),
                    backGroundColor: (_verifyNumberController.text.isNotEmpty &&
                            _verifyNumberController.text.length > 3)
                        ? CustomColors.primary
                        : CustomColors.gray,
                    onPress: (_verifyNumberController.text.isNotEmpty &&
                            _verifyNumberController.text.length > 3)
                        ? () async {
                            if (_verifyFormKey.currentState.validate()) {
                              if (await authenticationProvider
                                  .verifyPhoneNumber(
                                      _verifyNumberController.text)) {
                                shipmentsProvider.getAllShipment();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShipmentsPage()));
                              } else {
                                _verifyKey.currentState.showSnackBar(
                                  SnackBar(
                                    backgroundColor: CustomColors.primary,
                                    content: Text(
                                      authenticationProvider.error,
                                      style: TextStyle(
                                        color: CustomColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        : null,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawTitleAndHeaderTextRowCustom({
    BuildContext currentContext,
    String text,
    double textSize,
    double horizontalPaddingSize,
    verticalPaddingSize,
    Color textColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPaddingSize,
        vertical: verticalPaddingSize,
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(currentContext).size.width * .9,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawTextFormField(
      {hintInputToUser,
      TextEditingController controller,
      BuildContext context,
      int lines,
      TextInputType inputType}) {
    return Container(
      width: MediaQuery.of(context).size.width * .4,
      child: TextFormField(
        maxLines: lines,
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
            borderSide: BorderSide(
              color: CustomColors.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
            borderSide: BorderSide(width: .2),
          ),
          hintText: hintInputToUser,
        ),
        keyboardType: inputType,
        validator: (val) {
          if (val.isEmpty) {
            return AppLocale.of(context).getTranslated("is_required");
          }
          return null;
        },
      ),
    );
  }

  Widget _drawResendCode({Function onPress, text}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
            child: Text(
              AppLocale.of(context).getTranslated("verify_resend_question"),
              style: TextStyle(
                color: CustomColors.gray,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(onTap: onPress, child: text),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ShipmentsPage()));
    return null;
  }
}
