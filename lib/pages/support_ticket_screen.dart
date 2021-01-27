import 'package:bosta_clone_app/pages/drawer.dart';
import 'package:bosta_clone_app/pages/shipment/all_shipments_screen.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class SupportTicket extends StatefulWidget {
  @override
  _SupportTicketState createState() => _SupportTicketState();
}

class _SupportTicketState extends State<SupportTicket> {
  final GlobalKey<ScaffoldState> _supportTicketScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _supportTicketScaffoldKey,
        appBar: AppBar(
          title: Text(
            AppLocale.of(context).getTranslated("tickets"),
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
              _supportTicketScaffoldKey.currentState.openDrawer();
            },
          ),
        ),
        drawer: SameDrawer(),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ShipmentsPage()));
    return null;
  }
}
