import 'package:bosta_clone_app/pages/support_ticket_screen.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/services/authentication.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/bosta_clone_app/lib/pages/samilier_widget/screen_handle_widget.dart';

import 'pickup/all_pickups_screen.dart';
import 'profile/profile_screen.dart';
import 'shipment/all_shipments_screen.dart';

class SameDrawer extends StatefulWidget {
  @override
  _SameDrawerState createState() => _SameDrawerState();
}

class _SameDrawerState extends State<SameDrawer> {
  @override
  Widget build(BuildContext context) {
    var authenticationProvider = Provider.of<AuthProvider>(context);
    return Drawer(
      child: Column(
        children: [
          _drawDetailsOfUser(),
          _drawMenuItem(
            AppLocale.of(context).getTranslated("all_shipment"),
            FontAwesomeIcons.box,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ShipmentsPage(),
                ),
              );
            },
          ),
          _drawMenuItem(
            AppLocale.of(context).getTranslated("all_pickup"),
            FontAwesomeIcons.shippingFast,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PickupsPage(),
                ),
              );
            },
          ),
          _drawMenuItem(
            AppLocale.of(context).getTranslated("tickets"),
            FontAwesomeIcons.ticketAlt,
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SupportTicket(),
                ),
              );
            },
          ),
          _drawMenuItem(
            AppLocale.of(context).getTranslated("logout"),
            FontAwesomeIcons.signOutAlt,
            () {
              authenticationProvider.logout();
              setState(() {
                Phoenix.rebirth(context);
              });
            },
          ),
          SizedBox(
            height: 40,
          ),
          Divider(
            color: CustomColors.grayBackground,
          ),
          _drawProfileText(),
          _drawMenuItem(
            AppLocale.of(context).getTranslated("my_profile"),
            FontAwesomeIcons.solidUser,
            () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          ),
          _drawMenuItem(
            AppLocale.of(context).getTranslated("help"),
            FontAwesomeIcons.info,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _drawDetailsOfUser() {
    var authenticationProvider = Provider.of<AuthProvider>(context);
    switch (authenticationProvider.state) {
      case AuthStates.unAuthenticated:
      case AuthStates.authenticating:
        return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: drawLoadingIndicator(context));
        break;
      case AuthStates.authenticated:
        return Container(
          padding: EdgeInsets.all(18),
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: ExactAssetImage("assets/images/fatima.jpg"),
                fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2, color: Colors.grey, spreadRadius: 0.5)
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage:
                        ExactAssetImage("assets/images/profile.jpg"),
                    radius: 25,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${authenticationProvider.user.firstName} ${authenticationProvider.user.lastName}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                authenticationProvider.user.email,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.white),
              ),
            ],
          ),
        );
        break;
    }
    return Container();
  }

  Widget _drawMenuItem(String title, IconData icon, Function click) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: CustomColors.dark),
      ),
      leading: FaIcon(icon),
      onTap: click,
    );
  }

  Widget _drawProfileText() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocale.of(context).getTranslated("my_profile"),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: CustomColors.grayBackground),
          ),
        ),
      ],
    );
  }
}
