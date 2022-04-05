import 'package:flutter/material.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';

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
          onPressed: () async {
            await DBHelper.deleteDatabase(dbName);
            await SharedPrefHelper.removeAllSavedKeys();
          },
          child: const Text(
            'Delete database',
          ),
        ),
      ),
    );
  }
}
