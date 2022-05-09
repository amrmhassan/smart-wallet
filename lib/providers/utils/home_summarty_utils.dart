void calculateHomeSummaryAmounts() {
  //
}

// first (name, transactionType, amount, HomeSummary(enum))
// second (name, transactionType, amount, HomeSummary(enum))
// third (name, transactionType, amount, HomeSummary(enum))

// the user pref provider will contain the enum for the first for example (todayOutcome)

// after getting the todayOutcome from the enum HomeSummary 
// I check for it in the array of HomeSummariesTypes 
// that contains different types of HomeSummary and where to find there amounts
//! the problem is how to reference their amounts to the provider functions 