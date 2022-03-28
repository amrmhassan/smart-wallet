import 'package:flutter/cupertino.dart';
import 'package:wallet_app/models/profile_model.dart';

import '../constants/profiles.dart';

class ProfilesProvider extends ChangeNotifier {
  List<ProfileModel> _profiles = [];

  List<ProfileModel> get profiles {
    return [..._profiles];
  }

  void fetchAndUpdateProfiles() {
    _profiles = profilesConstant;
  }
}
