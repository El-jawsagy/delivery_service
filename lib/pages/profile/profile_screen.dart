import 'package:bosta_clone_app/model/user_model.dart';
import 'package:bosta_clone_app/pages/auth/verify_phone_number.dart';
import 'package:bosta_clone_app/pages/samilier_widget/screen_handle_widget.dart';
import 'package:bosta_clone_app/services/authentication.dart';
import 'package:bosta_clone_app/utilities/data/prefrences.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';



class ProfilePage extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var AuthenticationProvider = Provider.of<AuthProvider>(context);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              CustomColors.darkerPrimary,
              CustomColors.primary,
            ],
            stops: [0.3, 1],
          )),
        ),
        Scaffold(
          backgroundColor: CustomColors.trans,
          appBar: AppBar(
            title: Text(
              AppLocale.of(context).getTranslated("profile"),
            ),
            centerTitle: true,
            backgroundColor: CustomColors.trans,
            elevation: 0,
          ),
          body:AuthenticationProvider.user!=null? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: ExactAssetImage(
                          "assets/images/profile.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _drawUserName(AuthenticationProvider.user),
                SizedBox(
                  height: 25,
                ),
                _drawEditProfileButton(AuthenticationProvider.user),
                SizedBox(
                  height: 25,
                ),
                _drawInfoContainer(AuthenticationProvider.user),
                SizedBox(
                  height: 25,
                ),
                _drawChangeLangButton(),
              ],
            ),
          ):drawLoadingIndicator(context),
        ),
      ],
    );
  }

  Widget _drawUserName(UserModel userModel) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Text(
        "${userModel.firstName} ${userModel.lastName}",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: CustomColors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _drawEditProfileButton(UserModel userModel) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .4,
      child: FlatButton(
        color: CustomColors.buttonPrimary,
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VerifyPhoneNumberPage(),),);
        },
        child: Center(
          child: Text(
            AppLocale.of(context).getTranslated("edit_profile"),
            style: TextStyle(
                fontSize: 16,
                color: CustomColors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _drawInfoContainer(UserModel userModel) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColors.secondPrimary,
            CustomColors.primary,
          ],
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _drawUserinfoItems(
                userModel.email,
                FontAwesomeIcons.solidEnvelope,
              ),
              Divider(
                color: CustomColors.gray,
              ),
              _drawUserinfoItems(
                userModel.phoneNumber.replaceFirst("+", " "),
                FontAwesomeIcons.mobile,
              ),
              Divider(
                color: CustomColors.gray,
              ),
              _drawUserinfoItems(
                "N/A",
                FontAwesomeIcons.solidCompass,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawUserinfoItems(String title, IconData iconData) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14,
            color: CustomColors.grayBackground,
            fontWeight: FontWeight.bold),
      ),
      leading: FaIcon(
        iconData,
        color: CustomColors.grayBackground,
      ),
    );
  }

  Widget _drawChangeLangButton() {
    return InkWell(
      onTap: () async {
        String lang = await Preference.getLanguage();
        if (lang == 'ar') {
          setState(() {
            setLang('en');
            Phoenix.rebirth(context);
          });
        } else {
          setState(() {
            setLang('ar');
            setLang('ar');
            Phoenix.rebirth(context);
          });
        }
      },
      child: Text(
        AppLocale.of(context).getTranslated("change_lang"),
        style: TextStyle(
          fontSize: 14,
          color: CustomColors.white,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
