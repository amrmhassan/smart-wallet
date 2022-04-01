import 'package:flutter/material.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final String profileId;
  const ProfileDetailsScreen({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 50),
          child: Text(
            'Info about profile with id : ${widget.profileId}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
