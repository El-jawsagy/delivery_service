import 'package:bosta_clone_app/utilities/lang/applocate.dart';
import 'package:bosta_clone_app/utilities/theme/custom_colors.dart';
import 'package:flutter/material.dart';

Widget drawTextField({
  TextEditingController controller,
  hintInputToUser,
  BuildContext context,
  int lines,
  TextInputType inputType,
}) {
  return Container(
    width: MediaQuery.of(context).size.width * .9,
    child: TextFormField(
      controller: controller,
      maxLines: lines,
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
          hintText: hintInputToUser),
      keyboardType: inputType,
    ),
  );
}

Widget drawTextFormField(
    {formKey,
    hintInputToUser,
    TextEditingController controller,
    BuildContext context,
    int lines,
    TextInputType inputType}) {
  return Container(
    width: MediaQuery.of(context).size.width * .9,
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

Widget drawTitleAndHeaderTextRow({
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
          ),
        )
      ],
    ),
  );
}

Widget drawLogo({
  height,
  BuildContext currentContext,
}) {
  return Image.asset(
    "assets/images/bosta_logo.png",
    height: MediaQuery.of(currentContext).size.height * height,
  );
}

Widget giveHeightSpace({double height}) {
  return SizedBox(
    height: height,
  );
}

Widget giveWidthSpace({double width}) {
  return SizedBox(
    width: width,
  );
}

Widget drawButton({
  Color backGroundColor,
  double width,
  Widget text,
  Function onPress,
}) {
  return FlatButton(
    color: backGroundColor,
    height: 40,
    minWidth: width,
    onPressed: onPress,
    child: text,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7.0),
      side: BorderSide(
        color: backGroundColor,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
  );
}

Widget drawSingleRadio({
  BuildContext context,
  int index,
  String title,
  subTitle,
  Function onPressed,
  int valueOfRadioGroup,
}) {
  print(index);
  return Container(
    margin: const EdgeInsets.all(15.0),
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    width: MediaQuery.of(context).size.width * 0.9,
    decoration: BoxDecoration(
        border: Border.all(color: CustomColors.gray, width: 0.25),
        borderRadius: BorderRadius.circular(8)),
    child: Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: index,
              groupValue: valueOfRadioGroup,
              onChanged: onPressed,
              activeColor: CustomColors.secondPrimary,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: CustomColors.dark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            (subTitle != null)
                ? Text(
                    subTitle,
                    style: TextStyle(
                      color: CustomColors.gray,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Container(),
          ],
        ),
      ],
    ),
  );
}

Widget drawCheckBox({BuildContext context, Function onPressed, checkboxValue,checkboxText}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: checkboxValue.value
                  ? Icon(
                      Icons.check,
                      size: 30.0,
                      color: CustomColors.primary,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      size: 30.0,
                      color: CustomColors.secondPrimary,
                    ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text( checkboxText,
            style: TextStyle(
              color: CustomColors.gray,
              fontSize: 12,
            ),
          ),
        )
      ],
    ),
  );
}
