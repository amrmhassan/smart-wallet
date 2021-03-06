enum TransactionType {
  all,
  income,
  outcome,
}

enum SnackBarType {
  info,
  error,
  success,
}

enum SyncFlags {
  noSyncing,
  add,
  edit,
  delete,
}
enum ErrorTypes {
  networkError,
  deleteActiveProfile,
  profileNameExists,
  expenseIsLargeAddDebt,
  expenseLargeNoDebt,
  notLoggedInSuccessfully,
  noUserPhoto,
  noUserLoggedIn,
}

enum LogTypes {
  error,
  info,
  done,
}

enum ProfileDetailsChartTypes {
  income,
  outcome,
  savings,
}

enum CustomChartType {
  savings,
  income,
  outcome,
}
