// ignore_for_file: unused_field

import 'dart:ui';

import 'package:flutter/material.dart';

class GlassFrostedContainer extends StatelessWidget {
  //? Widget properties
  //? all of them are optional
  //? all the default values are specified in the _Defaults private class
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Alignment? alignment;
  final List<Color>? colors;
  final Border? border;
  final BorderRadius? borderRadius;
  final double? sigmaX;
  final double? sigmaY;
  final Alignment? gradientBegin;
  final Alignment? gradientEnd;

  const GlassFrostedContainer({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.alignment,
    this.colors,
    this.border,
    this.borderRadius,
    this.sigmaX,
    this.sigmaY,
    this.gradientBegin,
    this.gradientEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //?  this is the main container of all things (effects and children)
    //? its children won't get outside of it because of clipBehavior
    return Container(
      clipBehavior: Clip.hardEdge,
      // width: width ?? _Defaults.width,
      // height: height ?? _Defaults.height,
      //? border raduis of the main container is the same as the border of the gradient container down there
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? _Defaults.borderRadius,
      ),
      //? this is the stack having effects and child property
      child: Stack(
        children: [
          //* blur effect
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: sigmaX ?? _Defaults.sigmaX,
              sigmaY: sigmaY ?? _Defaults.sigmaY,
            ),
            //? this empty container child is necessary for the filter to apply and expand it to take the whole space of its parent
            child: Container(),
          ),
          //* gradient effect
          Container(
            decoration: BoxDecoration(
              border: border ?? _Defaults.border,
              borderRadius: borderRadius ?? _Defaults.borderRadius,
              gradient: LinearGradient(
                begin: gradientBegin ?? _Defaults.gradientBegin,
                end: gradientEnd ?? _Defaults.gradientEnd,
                colors: colors ?? _Defaults.colors,
              ),
            ),
          ),
          Container(
            padding: padding,
            child: child,
            alignment: alignment,
          )
        ],
      ),
    );
  }
}

//? this private class will hold the default values of the widget class
class _Defaults {
  static double width = 200;
  static double height = 300;
  static BorderRadius borderRadius = BorderRadius.circular(10);

  static List<Color> colors = [
    Colors.white.withOpacity(0.3),
    Colors.white.withOpacity(0.2),
    Colors.pink.withOpacity(0.05),
  ];

  static double sigmaX = 5;
  static double sigmaY = 5;

  static Border border =
      Border.all(color: Colors.white.withOpacity(0.1), width: 1);

  static Alignment gradientBegin = Alignment.topLeft;
  static Alignment gradientEnd = Alignment.bottomRight;
}
