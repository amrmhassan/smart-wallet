// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_app/constants/db_constants.dart';
import 'package:wallet_app/constants/shared_pref_constants.dart';
import 'package:wallet_app/helpers/custom_error.dart';
import 'package:wallet_app/helpers/shared_pref.dart';
import 'package:wallet_app/models/profile_model.dart';

import '../constants/profiles.dart';
import '../helpers/db_helper.dart';

class ProfilesProvider extends ChangeNotifier {
  List<ProfileModel> _profiles = [];
  String _activatedProfileId = '';

  //* for getting the activated profile id
  String get activatedProfileId {
    return _activatedProfileId;
  }

  //* for getting the profiles
  List<ProfileModel> get profiles {
    return [..._profiles.reversed.toList()];
  }

  //* for getting the current active profile
  ProfileModel get getActiveProfile {
    //* fixed by setting the currentActiveId when fetching profile and there is no profiles
    //* and by adding the loading to the holder screen to prevent showing the home screen that will ask for the current active id
    //* before loading them from the database
    // fix that error , this will create an error first time the app loads cause
    // i think this is called before the profiles loads
    return _profiles.firstWhere((element) => element.id == activatedProfileId);
  }

  //* for fetching and update the activated profile id from shared preferences
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

  //* for getting and updating the profiles from database
  Future<void> fetchAndUpdateProfiles() async {
    try {
      List<Map<String, dynamic>> data =
          await DBHelper.getData(profilesTableName);
      //* if there is no profile yet just create the default one and add it to the _profiles
      if (data.isEmpty) {
        String id = await addProfile(defaultProfile.name);
        return setActivatedProfile(id);
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

  //* for adding a profile to database and to the _profiles
  Future<String> addProfile(String name) async {
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
    return id;
  }

  //* for editing a profile
  Future<void> editProfile({
    required String id,
    String? name,
    double? income,
    double? outcome,
  }) async {
    //* rejecting edit if no argument is provided
    if (name == null && income == null && outcome == null) {
      throw CustomError(
          'You must enter one argument at least to edit the profile');
    }
    //* setting the active profile to the current active profile
    ProfileModel editedProfile =
        _profiles.firstWhere((element) => element.id == id);
    String newName = name ?? editedProfile.name;
    double newIncome = income ?? editedProfile.income;
    double newOutcome = outcome ?? editedProfile.outcome;
    DateTime createdAt = editedProfile.createdAt;
    bool activated = editedProfile.activated;
    //* edit the profile in database first
    try {
      await DBHelper.insert(profilesTableName, {
        'id': id,
        'name': newName,
        'income': newIncome,
        'outcome': newOutcome,
        'createdAt': createdAt.toIso8601String(),
        'activated': activated ? 'true' : 'false',
      });

      //* edit it on the _profiles
      int index = _profiles.indexOf(editedProfile);
      _profiles.removeAt(index);
      ProfileModel newProfile = ProfileModel(
        id: id,
        name: newName,
        income: newIncome,
        outcome: newOutcome,
        createdAt: createdAt,
        activated: activated,
      );
      _profiles.insert(index, newProfile);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error editting the profile new money profile');
      }
      rethrow;
    }
  }

  Future<void> editActiveProfile(
      {String? name, double? income, double? outcome}) async {
    //* setting the active profile to the current active profile
    ProfileModel activeProfile = getActiveProfile;
    String id = activeProfile.id;
    return editProfile(id: id, name: name, income: income, outcome: outcome);
  }

  //* for setting the active profile id in the shared preferences
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
