import 'package:smart_wallet/constants/types.dart';

const Map<ErrorTypes, String> errorsTypes = {
  ErrorTypes.networkError: 'No Internet Connection',
  ErrorTypes.deleteActiveProfile: 'You can\'t delete the active profile',
  ErrorTypes.profileNameExists: 'Profile Name already exists',
  ErrorTypes.expenseIsLargeAddDebt:
      'This expense is larger than your balance. You can add a debt instead.',
  ErrorTypes.expenseLargeNoDebt: 'This expense is larger than your balance.',
  ErrorTypes.notLoggedInSuccessfully: 'Not Logged In',
  ErrorTypes.noUserPhoto: 'No user Photo',
  ErrorTypes.noUserLoggedIn: 'No User Logged In'
};
