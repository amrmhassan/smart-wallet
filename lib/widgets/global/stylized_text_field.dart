// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ErrorMsgPriority {
  error,
  info,
}

class StylizedTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Color? fillColor;
  final Function onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final bool password;
  final String errorMsg;
  final ErrorMsgPriority? errorMsgPriority;
  final bool enableErrorBorder;
  final TextEditingController? controller;
  final bool showPasswordController;
  final int? maxLines;

  const StylizedTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.focusedBorder,
    this.enabledBorder,
    this.hintStyle,
    this.labelStyle,
    this.fillColor,
    required this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.textStyle,
    this.keyboardType,
    this.password = false,
    this.errorMsg = '',
    this.errorMsgPriority,
    this.enableErrorBorder = true,
    this.controller,
    this.showPasswordController = true,
    this.maxLines,
  }) : super(key: key);

  @override
  State<StylizedTextField> createState() => _StylizedTextFieldState();
}

class _StylizedTextFieldState extends State<StylizedTextField> {
  Widget? suffixIcon() {
    if (widget.showPasswordController && widget.password) {
      return IconButton(
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          icon: Icon(
            isPasswordVisible
                ? FontAwesomeIcons.eyeSlash
                : FontAwesomeIcons.eye,
          ));
    } else {
      return widget.suffixIcon;
    }
  }

  InputBorder? enabledBorderDynamic() {
    return widget.enableErrorBorder && widget.errorMsg.isNotEmpty
        ? _Defaults.errorBorder
        : widget.enabledBorder ?? _Defaults.enabledBorder;
  }

  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.red),
          child: TextField(
            maxLines: widget.maxLines,
            controller: widget.controller,
            style: widget.textStyle ?? _Defaults.textStyle,
            onChanged: (value) => widget.onChanged(value),
            keyboardType: widget.keyboardType,
            obscureText: widget.password && !isPasswordVisible,
            autocorrect: !widget.password,
            enableSuggestions: !widget.password,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon: suffixIcon(),
              labelText: widget.labelText,
              contentPadding: widget.contentPadding,
              hintText: widget.hintText ?? _Defaults.hintText,
              hintStyle: widget.hintStyle ?? _Defaults.hintStyle,
              labelStyle: widget.labelStyle ?? _Defaults.labelStyle,
              focusedBorder: widget.focusedBorder ?? _Defaults.focusedBorder,
              enabledBorder: enabledBorderDynamic(),
              fillColor: widget.fillColor ?? _Defaults.fillColor,
              focusColor: Colors.red,
              filled: true,
            ),
          ),
        ),

        //! i removed this only in this project to remove the extra space under the textfield
        // SizedBox(
        //   height: 5,
        // ),
        // Container(
        //   padding: EdgeInsets.only(left: 25),
        //   child: Text(
        //     widget.errorMsg,
        //     style: _Defaults.errorMessageStyle(widget),
        //   ),
        // ),
      ],
    );
  }
}

class _Defaults {
  static String hintText = 'Hint Text';

  //? text styles
  static TextStyle hintStyle = TextStyle(
      color: Colors.black.withOpacity(0.4),
      fontSize: 15,
      fontWeight: FontWeight.bold);
  static TextStyle labelStyle = TextStyle(color: Colors.black.withOpacity(0.8));
  static TextStyle textStyle = TextStyle(
      color: Colors.black.withOpacity(0.8),
      fontSize: 16,
      fontWeight: FontWeight.w400);

  //? borders
  static InputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.3),
        width: 1,
      ));
  static InputBorder enabledBorder = focusedBorder;
  static InputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1,
      ));

  //? colors
  static Color fillColor = Colors.white.withOpacity(0.5);

  //? error message
  static TextStyle errorMessageStyle(StylizedTextField widget) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: widget.errorMsgPriority == ErrorMsgPriority.info
            ? Colors.blue
            : Colors.red,
      );
}
