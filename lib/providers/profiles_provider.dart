// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_app/constants/db_constants.dart';
import 'package:wallet_app/models/profile_model.dart';

import '../helpers/db_helper.dart';

class ProfilesProvider extends ChangeNotifier {
  List<ProfileModel> _profiles = [];
  String _activatedProfileId = '';

  String get activatedProfileId {
    if (_activatedProfileId == '') {
      return _profiles[0].id;
    } else {
      return _activatedProfileId;
    }
  }

  List<ProfileModel> get profiles {
    return [..._profiles];
  }

  Future<void> fetchAndUpdateProfiles() async {
    try {
      List<Map<String, dynamic>> data =
          await DBHelper.getData(quickActionsTableName);
      //? if there is no profile yet just create the default one and add it to the _profiles
      if (data.isEmpty) {
        return await addProfile('Default Profile');
      }

      List<ProfileModel> fetchedProfiles = data
          .map((profile) => ProfileModel(
                id: profile['id'],
                name: profile['name'],
                income: double.parse(profile['income']),
                outcome: double.parse(profile['outcome']),
                createdAt: DateTime.parse(profile['createdAt']),
              ))
          .toList();
      _profiles = fetchedProfiles;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching profiles from the database');
      }
      // rethrow;
    }
  }

  Future<void> addProfile(String name) async {
    //* initializing the transaction data like (createdAt, id, ratioToTotal...)
    String id = const Uuid().v4();
    DateTime createdAt = DateTime.now();

    //* here i will add the new transaction to the database
    try {
      await DBHelper.insert(profilesTableName, {
        'id': id,
        'name': name,
        'income': 0,
        'outcome': 0,
        'createdAt': createdAt.toIso8601String(),
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error creating new money profile');
      }
      rethrow;
    }

    ProfileModel newProfile = ProfileModel(
        id: id, name: name, income: 0, outcome: 0, createdAt: createdAt);
    _profiles.add(newProfile);
    notifyListeners();
  }

  void setActivatedProfile(String id) {
    _activatedProfileId = id;
    notifyListeners();
  }
}
