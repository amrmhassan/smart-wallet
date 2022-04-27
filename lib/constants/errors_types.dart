const Map<ErrorTypes, String> errorsTypes = {
  ErrorTypes.networkError: 'No Internet Connection',
  ErrorTypes.deleteActiveProfile: 'You can\'t delete the active profile',
  ErrorTypes.profileNameExists: 'Profile Name already exists'
};
enum ErrorTypes { networkError, deleteActiveProfile, profileNameExists }
