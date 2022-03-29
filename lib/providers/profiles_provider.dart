// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_app/constants/db_constants.dart';
import 'package:wallet_app/constants/shared_pref_constants.dart';
import 'package:wallet_app/helpers/shared_pref.dart';
import 'package:wallet_app/models/profile_model.dart';

import '../constants/profiles.dart';
import '../helpers/db_helper.dart';

class ProfilesProvider extends ChangeNotifier {
  List<ProfileModel> _profiles = [];
  String _activatedProfileId = '';

  String get activatedProfileId {
    return _activatedProfileId;
  }

  List<ProfileModel> get profiles {
    return [..._profiles.reversed.toList()];
  }

  Future<void> fetchAndUpdateActivatedProfileId() async {
    String activatedId;

    try {
      String? savedActivatedId =
          await SharedPrefHelper.getString(kActivatedProfileIdKey);
      if (savedActivatedId == null) {
        activatedId = profiles[0].id;
        setActivatedProfile(activatedId);
      } else {
        activatedId = savedActivatedId;
      }
      _activatedProfileId = activatedId;
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching activated profile id');
      }
    }
  }

  Future<void> fetchAndUpdateProfiles() async {
    try {
      List<Map<String, dynamic>> data =
          await DBHelper.getData(profilesTableName);
      //* if there is no profile yet just create the default one and add it to the _profiles
      if (data.isEmpty) {
        return await addProfile(defaultProfile.name);
      }

      List<ProfileModel> fetchedProfiles = data
          .map((profile) => ProfileModel(
                id: profile['id'],
                name: profile['name'],
                income: double.parse(profile['income']),
                outcome: double.parse(profile['outcome']),
                createdAt: DateTime.parse(profile['createdAt']),
                activated: profile['activated'] == 'false' ? false : true,
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
        'activated': 'false',
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

  Future<void> setActivatedProfile(String id) async {
    try {
      await SharedPrefHelper.setString(kActivatedProfileIdKey, id);
      _activatedProfileId = id;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error setting the active profile');
      }
      rethrow;
    }
  }
}
