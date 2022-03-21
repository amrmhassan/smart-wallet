// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/constants/sizes.dart';
import 'package:wallet_app/constants/types.dart';

class QuickActionCard extends StatelessWidget {
  final TransactionType transactionType;
  final String title;
  final String description;
  final String amount;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const QuickActionCard({
    Key? key,
    this.transactionType = TransactionType.income,
    this.title = 'Empty Title',
    this.description = 'Empty Description',
    required this.amount,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: kMainColor.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          onLongPress: onLongPress ?? () {},
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultHorizontalPadding / 2,
              vertical: kDefaultVerticalPadding / 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 2,
                          color: transactionType == TransactionType.income
                              ? kIncomeColor
                              : kOutcomeColor,
                        ),
                      ),
                      child: Icon(
                        transactionType == TransactionType.income
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transactionType == TransactionType.income
                            ? kIncomeColor
                            : kOutcomeColor,
                      ),
                    ),
                    // Container(
                    //   alignment: Alignment.centerRight,
                    //   child:  Icon(
                    //     Icons.more_vert,
                    //     color: kMainColor,
                    //     size: kDefaultIconSize,
                    //   ),
                    // ),
                    Text(
                      '$amount \$',
                      style: TextStyle(
                        color: transactionType == TransactionType.income
                            ? kIncomeColor
                            : kOutcomeColor,
                        fontSize: kDefaultInfoTextSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  title,
                  maxLines: 2,
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: kDefaultInfoTextSize,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  description,
                  maxLines: 3,
                  style: TextStyle(
                    color: kMainColor,
                    fontSize: kDefaultParagraphTextSize,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
