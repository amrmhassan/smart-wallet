import 'package:flutter/material.dart';
import 'package:wallet_app/constants/globals.dart';
import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/types.dart';
import '../../../utils/general_utils.dart';

class QuickActionCard extends StatelessWidget {
  final TransactionType transactionType;
  final String title;
  final String description;
  final double amount;
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
            offset: const Offset(0, 0),
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
            padding: const EdgeInsets.symmetric(
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
                      '${doubleToString(amount)} $currency',
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
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  title,
                  maxLines: 1,
                  style: const TextStyle(
                    color: kMainColor,
                    fontSize: kDefaultInfoTextSize,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  description,
                  maxLines: 3,
                  style: const TextStyle(
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
