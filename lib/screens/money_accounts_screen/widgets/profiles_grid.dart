// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wallet_app/constants/colors.dart';
import 'package:wallet_app/constants/styles.dart';

import '../../../constants/profiles.dart';
import '../../../constants/sizes.dart';

class ProfilesGrid extends StatelessWidget {
  const ProfilesGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.only(
        top: kDefaultPadding / 4,
        right: kDefaultPadding * 1.5,
        left: kDefaultPadding * 1.5,
        bottom: bottomNavBarHeight + kDefaultPadding / 4,
      ),
      decoration: BoxDecoration(),
      child: GridView.builder(
        clipBehavior: Clip.none,
        //* this is so impressive for adding a different animation to the scrolling effect
        physics: BouncingScrollPhysics(),

        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: kDefaultPadding,
          mainAxisSpacing: kDefaultPadding * 1.5,
          childAspectRatio: 2 / 3,
        ),
        itemCount: profiles.length,
        itemBuilder: (ctx, index) => MoneyAccountCard(),
      ),
    );
  }
}

class MoneyAccountCard extends StatelessWidget {
  const MoneyAccountCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 4,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        color: Colors.white,
        boxShadow: [
          kCardBoxShadow,
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfileDetailsButton(),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          ProfileStatus(),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          Text(
            'Account Name',
            style: kHeadingTextStyle,
          ),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          ProfileStatusProgressBar(),
          SizedBox(
            height: kDefaultPadding / 2,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileTransactionsInfo(
                  title: 'Income',
                  amount: '600',
                  color: kIncomeColor,
                ),
                ProfileTransactionsInfo(
                  title: 'Total Money',
                  amount: '200',
                  color: kMainColor,
                ),
                ProfileTransactionsInfo(
                  title: 'Outcome',
                  amount: '400',
                  color: kOutcomeColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTransactionsInfo extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  const ProfileTransactionsInfo({
    Key? key,
    required this.amount,
    required this.color,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              amount,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              '\$',
              style: TextStyle(
                fontSize: 11,
                color: Colors.black45,
              ),
            )
          ],
        ),
        SizedBox(
          height: kDefaultPadding / 6,
        ),
        Text(
          title,
          style: kSmallInActiveParagraphTextStyle,
        ),
      ],
    );
  }
}

class ProfileStatusProgressBar extends StatelessWidget {
  const ProfileStatusProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.80,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Income',
                style: kSmallTextPrimaryColorStyle,
              ),
              Text(
                '20%',
                style: kSmallTextPrimaryColorStyle,
              ),
            ],
          ),
          SizedBox(
            height: kDefaultPadding / 6,
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: kInactiveColor.withOpacity(0.3),
            ),
            child: FractionallySizedBox(
                widthFactor: 0.2,
                child: Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    color: kOutcomeColor.withOpacity(0.8),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class ProfileStatus extends StatelessWidget {
  const ProfileStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: kOutcomeColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Text(
        'Critical',
        style: kWhiteProfileStatusTextStyle,
      ),
    );
  }
}

class ProfileDetailsButton extends StatelessWidget {
  const ProfileDetailsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding / 2,
            vertical: kDefaultPadding / 5,
          ),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: kInactiveColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Text(
                'Details',
                style: kSmallTextPrimaryColorStyle,
              ),
              Icon(
                Icons.keyboard_double_arrow_right_outlined,
                color: kMainColor,
                size: kMediumIconSize,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
