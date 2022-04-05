DONE - tommorrow the wednesday(23/3/2022) i will start implementing the code for the quick actions
DONE - if there any time left in the day i will start adding the logic for local database(sqlite)
DONE - make the database different for debug mode and release mode to allow you to use the app in your real life other than developing it
DONE - add the ability to delete a transaction from the database

DONE - fix the app bar and make it clean code
DONE - make the quick actions screen design
DONE - make the quick action cards
DONE - make the quick action operations possible through the quick actions screen 
DONE - make to calculator to handle the float values with the period (.)
DONE - test the calculator by many probabilities then integrate it with the add transaction screen


----------------
DONE - for the profiles
DONE - -- in the fetchTransactions make it request only the transactions with the account profile id
DONE - -- and make the _transactions only has the transactions of the activated profile

DONE - add the update profile method in the profileProvider then use it to update the current profile states of the profile when adding new transaction 

DONE - update the current active profile when editting a transaction 
DONE - update the current active profile when deleting a transaction

DONE - create a utils file for operation_on_transactions and put the add transaction method in there and the DONE - delete, edit then use them in the add transaction screen
DONE -- do the last step for the quick actions as well


DONE - add a lastActivatedDate to each profile 
then use it to arrange the profiles in the profiles screen by their lastActivatedDate from the recent to the latest(recent at top)


DONE - add a constant to check if it the first time to run the app or not it will save a shared preference variable and check that depending on that

DONE - fix the dialaogs of deleteing a teransaction or a quick action and fix the title stylized text field to have elipces if overflowed

convert the transaction card to dismissible





DONE - implement the statistics page (this will have the current profile statistics and the debts , income, outcome)
DONE -- with time amounts and predictions and other stuff

DONE - implement editing a profile name with the same adding profile modal
implement deleting a profile from the profile details screen which
-- deleting the last profile is'nt allowed 
-- deleting the current active profile isn't allowed( may be changed)
in the profile details page i will show a statistics page of that only profile
the user can go to the statistcs page by clicking the profile card itself or the details button
make the profile name textField focus when it appears and show the keyboard
when editing a profile the new profile is pushed to the start of the profiles(fix that by sorting them according to the lastActivated time and the createdAt time)

make a profile statisctics widget which will show the statistics about a profile with it's id
-- that will be added to the statistics page that in the holder page

# the user can't add a transaction that is higher than his totalMoney
# to add a debt the user will find that option in the sideBar 
# the dept will have a seperate screen that can be accessed from the sideBar (Debts)
# to fullfil a debt the can take it's amount from any current moey profile and it will be substracted from that profile
# the ability to a debt also will be implemented in the add transaction screen after showing the add a debt instead dialog the debt will be added to the debts screen which will be accissible from the sidebar debts

# ------------[Start] critical changes in the app 
[HomeScreen] remove periods [D, W, M, Y]
remove the income
only show the outcome for the current day only and yesterday, the current money in the wallet
you can also remove the yesterday outcome and only show the today outcome 
[StatisticsScreen]
show all the details their
simple first like income, outcome with periods (D, W, M, Y , and All)and other custom periods 
this will apply for all the statistics in the page
-first card will show the (income, outcome, total current money in the wallet) for that period
-second card will show the (current money in the wallet or income, or outcome charts) 
# for small periods like only one day show the details of that day with each transaction happend
the default period will be one day and when setting a new period that period will be saved for the next time opening the statistics page

# ------------[End] critical changes in the app 


# you might change the total Mony indication to the Savings indeication

# the savings workd different 
the saving of today isn't equal to the income of that day minus the outcome in the same day 
it equals to the savings of the pervious days + income of that day - outcome of that day= totalIncome-totalOutcome
# so the savings always equal to the total (income from the first day to the current day ) - (total outcome from the first day to the current day) it will make difference in the chart of the savings-- cause the savings of each day will equal to the income of the previous days - the outcome of the previous days