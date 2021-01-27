import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class VerifyPhoneNumber extends StatefulWidget {
  @override
  _VerifyPhoneNumberState createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
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
            ),
          ),
        ),
        Scaffold(
          body: Column(
            children: [

              _drawTextFormField(),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _drawTextFormField(
    {formKey,
    hintInputToUser,
    TextEditingController controller,
    BuildContext context,
    int lines,
    TextInputType inputType}) {
  return Container(
    width: MediaQuery.of(context).size.width * .4,
    child: TextFormField(
      maxLines: lines,
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
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
