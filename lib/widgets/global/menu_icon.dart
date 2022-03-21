import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MenuIcon extends StatelessWidget {
  final VoidCallback onTap;
  const MenuIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final double width = 60;
  final double height = 60;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 3,
                  decoration: BoxDecoration(
                    color: kMainColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 15,
                  height: 3,
                  decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),
            // child: Icon(
            //   //! change this icon here to be a dash and a half
            //   Icons.menu,
            //   color: kMainColor,
            //   size: kDefaultIconSize,
            // ),
          ),
        ),
      ),
    );
  }
}
