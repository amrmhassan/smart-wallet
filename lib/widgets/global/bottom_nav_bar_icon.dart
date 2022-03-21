// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

const double _width = 45;
const double _height = 45;
const Duration _animationDuration = Duration(milliseconds: 200);

const double activeBorderRadius = 5;
const double nonActiveBorderRadius = 50;

const double activeRotationAngle = -45 * pi / 180;
const double nonActiveRotationAngle = 0;

class BottomNavBarIcon extends StatefulWidget {
  final bool active;
  final IconData iconData;
  final VoidCallback onTap;
  const BottomNavBarIcon({
    Key? key,
    this.active = false,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  State<BottomNavBarIcon> createState() => _BottomNavBarIconState();
}

class _BottomNavBarIconState extends State<BottomNavBarIcon>
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
    //* this if statement is for making the nonActive icon reverse its animation and come to the bottom without clicking it
    //* cause the user won't click it to make it nonActive
    if (widget.active) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onTap: widget.onTap,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
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
                  child: Icon(
                    widget.iconData,
                    color: widget.active
                        ? kMainColor
                        : kMainColor.withOpacity(0.5),
                    size: widget.active ? kMediumIconSize : kSmallIconSize,
                  ),
                ),
              ),
              if (widget.active)
                Positioned(
                  bottom: -25,
                  child: Transform(
                    transform: Matrix4.rotationZ((pi / 180) * 45),
                    origin: Offset(25, 25),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: kMainColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              //* positioned backup
              // Positioned(
              //   bottom: -85,
              //   child: Container(
              //     width: 10,
              //     height: 140,
              //     decoration: BoxDecoration(
              //       // color: Color.fromARGB(255, 193, 199, 253),
              //       borderRadius: BorderRadius.circular(50),
              //       boxShadow: [
              //         BoxShadow(
              //           color: kMainColor.withOpacity(0.5),
              //           blurRadius: 15,
              //           offset: Offset(0, 0),
              //           spreadRadius: 20,
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////

//? this is the backup of this widget
// import 'package:flutter/material.dart';

// import '../../constants/colors.dart';
// import '../../constants/sizes.dart';
// import '../../constants/styles.dart';

// const double _width = 45;
// const double _height = 45;
// const Duration _animationDuration = Duration(milliseconds: 200);

// const double activeBorderRadius = 5;
// const double nonActiveBorderRadius = 50;

// const double activeRotationAngle = -45 * pi / 180;
// const double nonActiveRotationAngle = 0;

// class BottomNavBarIcon extends StatefulWidget {
//   final bool active;
//   final IconData iconData;
//   final VoidCallback onTap;
//   const BottomNavBarIcon({
//     Key? key,
//     this.active = false,
//     required this.iconData,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   State<BottomNavBarIcon> createState() => _BottomNavBarIconState();
// }

// class _BottomNavBarIconState extends State<BottomNavBarIcon> {
//   @override
//   Widget build(BuildContext context) {
//     //? i did this trick to let the user click the icon or the surrounding area and still be able to change the current active screen
//     return Expanded(
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: kBottomNavBarColors,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Transform(
//                 transform: !widget.active
//                     ? Matrix4.rotationZ(nonActiveRotationAngle)
//                     : Matrix4.rotationZ(activeRotationAngle),
//                 origin: const Offset(_height / 2, _width / 2),
//                 child: AnimatedContainer(
//                   duration: _animationDuration,
//                   clipBehavior: Clip.hardEdge,
//                   alignment: Alignment.center,
//                   width: _width,
//                   height: _height,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(
//                       widget.active
//                           ? activeBorderRadius
//                           : nonActiveBorderRadius,
//                     ),
//                     boxShadow: widget.active
//                         ? [
//                             kIconBoxShadow,
//                           ]
//                         : null,
//                   ),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       onTap: widget.onTap,
//                       child: Transform(
//                         transform: !widget.active
//                             ? Matrix4.rotationZ(-nonActiveRotationAngle)
//                             : Matrix4.rotationZ(-activeRotationAngle),
//                         origin: const Offset(_width / 2, _height / 2),
//                         child: Container(
//                           width: _width,
//                           height: _height,
//                           alignment: Alignment.center,
//                           child: Icon(
//                             widget.iconData,
//                             color: kMainColor,
//                             size: widget.active
//                                 ? kMediumIconSize
//                                 : kSmallIconSize,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
