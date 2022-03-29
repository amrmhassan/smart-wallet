import 'package:flutter/material.dart';
import 'package:wallet_app/constants/db_constants.dart';
import 'package:wallet_app/helpers/db_helper.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () async => await DBHelper.deleteDatabase(dbName),
          child: const Text(
            'Delete database',
          ),
        ),
      ),
    );
  }
}
