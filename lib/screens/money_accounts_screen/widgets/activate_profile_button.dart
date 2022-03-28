import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/providers/profiles_provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

class ActivateProfileButton extends StatelessWidget {
  final VoidCallback onTap;
  final String profileId;

  const ActivateProfileButton({
    Key? key,
    required this.onTap,
    required this.profileId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var activatedProfileId =
        Provider.of<ProfilesProvider>(context).activatedProfileId;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: activatedProfileId == profileId
              ? kInactiveColor.withOpacity(0.3)
              : kMainColor,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius / 4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: activatedProfileId == profileId ? null : onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: kDefaultPadding / 3),
              alignment: Alignment.center,
              child: Text(
                activatedProfileId == profileId ? 'Activated' : 'Activate',
                style: activatedProfileId == profileId
                    ? kActivatedProfileTextStyle
                    : kActivateProfileTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
