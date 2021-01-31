import 'package:bosta_clone_app/pages/samilier_widget/form_widget.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utilities/lang/applocate.dart';
import '../../utilities/theme/custom_colors.dart';
import '../shipment/all_shipments_screen.dart';
import 'sign_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var loginKey = GlobalKey<ScaffoldState>();
  TextEditingController _email;

  TextEditingController _password;
  IconData _icon = Icons.visibility_off;

  bool _isVisible = true;
  bool _isHash = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authenticationProvider = Provider.of<AuthProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        key: loginKey,
        backgroundColor: CustomColors.background,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              giveHeightSpace(
                height: 50,
              ),
              drawLogo(
                height: 0.22,
                currentContext: context,
              ),
              drawTitleAndHeaderTextRow(
                currentContext: context,
                text: AppLocale.of(context).getTranslated("login_welcome"),
                textColor: CustomColors.dark,
                textSize: 16,
                horizontalPaddingSize: 16.0,
                verticalPaddingSize: 2.0,
              ),
              drawTitleAndHeaderTextRow(
                currentContext: context,
                text: AppLocale.of(context).getTranslated("login_message"),
                textColor: CustomColors.secondPrimary,
                textSize: 28,
                horizontalPaddingSize: 16.0,
                verticalPaddingSize: 8.0,
              ),
              drawTitleAndHeaderTextRow(
                currentContext: context,
                text: AppLocale.of(context).getTranslated("email"),
                textColor: CustomColors.dark,
                textSize: 18,
                horizontalPaddingSize: 16.0,
                verticalPaddingSize: 16.0,
              ),
              _drawEmailTextField(),
              drawTitleAndHeaderTextRow(
                currentContext: context,
                text: AppLocale.of(context).getTranslated("pass"),
                textColor: CustomColors.dark,
                textSize: 18,
                horizontalPaddingSize: 16.0,
                verticalPaddingSize: 16.0,
              ),
              _drawPasswordTextField(),
              giveHeightSpace(
                height: 20,
              ),
              drawButton(
                  text:
                      authenticationProvider.state == AuthStates.authenticating
                          ? CircularProgressIndicator(
                              backgroundColor: CustomColors.primary,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.thirdPrimary),
                            )
                          : Text(
                              AppLocale.of(context).getTranslated("login"),
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
                    if (!await authenticationProvider.singIn(
                        _email.text, _password.text)) {
                      loginKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: CustomColors.primary,
                        content: Text(
                          authenticationProvider.error,
                          style: TextStyle(
                            color: CustomColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ));
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShipmentsPage()));
                    }
                  }),
              giveHeightSpace(
                height: 60,
              ),
              drawButton(
                  text: Text(
                    AppLocale.of(context).getTranslated("register"),
                    style: TextStyle(
                      color: CustomColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backGroundColor: CustomColors.secondPrimary,
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 40.0,

                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SingUpPage()));
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawEmailTextField() {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      child: TextFormField(
        controller: _email,
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
        ),
      ),
    );
  }

  Widget _drawPasswordTextField() {
    return Container(
      width: MediaQuery.of(context).size.width * .9,
      child: TextFormField(
        controller: _password,
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
        ),
      ),
    );
  }
}
