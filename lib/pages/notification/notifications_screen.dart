import 'package:bosta_clone_app/pages/drawer.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/bosta_clone_app/lib/pages/samilier_widget/screen_handle_widget.dart';
import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _notificationScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _notificationScaffoldKey,
      appBar: AppBar(
        title: Text(
          AppLocale.of(context).getTranslated("notification"),
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
            _notificationScaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      drawer: SameDrawer(),
      body: drawImageBackground("assets/images/notification.png"),
    );
  }
}
