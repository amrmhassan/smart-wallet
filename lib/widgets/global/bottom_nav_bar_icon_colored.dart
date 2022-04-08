// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';

const double _width = 45;
const double _height = 45;
const Duration _animationDuration = Duration(milliseconds: 200);

const double activeBorderRadius = 5;
const double nonActiveBorderRadius = 50;

const double activeRotationAngle = -45 * pi / 180;
const double nonActiveRotationAngle = 0;

class BottomNavBarIconColord extends StatefulWidget {
  final bool active;
  final String iconPath;
  final VoidCallback onTap;

  const BottomNavBarIconColord({
    Key? key,
    this.active = false,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BottomNavBarIconColord> createState() => _BottomNavBarIconColordState();
}

class _BottomNavBarIconColordState extends State<BottomNavBarIconColord>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconTranslateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _iconTranslateAnimation = Tween<double>(
      begin: 0,
      end: -10,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    //* this if statement is for making the nonActive icon reverse its animation and come to the bottom without clicking it
    //* cause the user won't click it to make it nonActive
    if (widget.active) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: _width,
              height: _height,
              alignment: Alignment.center,
              child: Transform(
                transform: widget.active
                    ? Matrix4.translationValues(
                        0, _iconTranslateAnimation.value, 0)
                    : Matrix4.translationValues(
                        0,
                        _iconTranslateAnimation.value,
                        0,
                      ),
                child: Image.asset(
                  widget.iconPath,
                  width: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (widget.active)
              FractionallySizedBox(
                widthFactor: 0.6,
                child: Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                      color: themeProvider
                          .getThemeColor(ThemeColors.kSavingsColor),
                      borderRadius: BorderRadius.circular(1000),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          color: themeProvider.getThemeColor(
                            ThemeColors.kSavingsColor,
                          ),
                          blurRadius: 10,
                        )
                      ]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
