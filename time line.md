[DONE]
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
DONE - for the profiles
DONE - -- in the fetchTransactions make it request only the transactions with the account profile id
DONE - -- and make the _transactions only has the transactions of the activated profile
DONE - add the update profile method in the profileProvider then use it to update when adding, deleting, editing a transaction
DONE - update the current active profile when editting a transaction 
DONE - update the current active profile when deleting a transaction
DONE - create a utils file for operation_on_transactions and put the add transaction method in there and the 
DONE - delete, edit then use them in the add transaction screen
DONE -- do the last step for the quick actions as well
DONE - add a constant to check if it the first time to run the app or not it will save a shared preference variable
DONE - implement the statistics page (this will have the current profile statistics and the debts , income, outcome)
DONE - with time amounts and predictions and other stuff
DONE - implement editing a profile name with the same adding profile modal
DONE - implement deleting a profile from the profile details screen which
DONE - deleting the current active profile isn't allowed( may be changed)
DONE - fix the dialaogs of deleteing a teransaction or a quick action and fix the title stylized text field to have elipces if overflowed
DONE - in the profile details page i will show a statistics page of that only profile
DONE - the user can go to the statistcs page by clicking the profile card itself or the details button
DONE - make a profile statisctics widget which will show the statistics about a profile with it's id
DONE -- that will be added to the statistics page that in the holder page
DONE - the user can't add a transaction that is higher than his totalMoney
DONE - to add a debt the user will find that option in the sideBar 
DONE - convert the transaction card to dismissible
DONE - you might change the total Mony indication to the Savings indeication
DONE - the savings worked different 
DONE - the saving of today isn't equal to the income of that day minus the outcome in the same day 
DONE - it equals to the savings of the pervious days + income of that day - outcome of that day= totalIncome-totalOutcome
DONE - after chaning the theme restart the app programatically(Fixied with other solution)
DONE - so the savings always equal to the total (income from the first day to the current day ) - (total outcome from the first day to the current day) it will make difference in the chart of the savings-- cause the savings of each day will equal to the income of the previous days - the outcome of the previous days
DONE - when logging in for the first time (not switching users) the transactions are deleted so ask the user if he want to delete the existing daat or not
DONE - fix the change in the syncing flag on the quick actions and transactions when editing them
DONE - through the favoriting or, actual editing
DONE - if they are still new (add keep it add)
DONE - else if it is (none keep it none)
DONE - else make it (edit)
DONE - in the from json (transactions, profiles, quick actions) dates just make sure if it is a timestamp or just a date
DONE - cause this will convert the data from the firestore and the local database as well
DONE - trimming the title name of transactions, profiles
DONE - make the profile name textField focus when it appears and show the keyboard




[Pending]
add a lastActivatedDate to each profile 
--then use it to arrange the profiles in the profiles screen by their lastActivatedDate from the recent to the latest(recent at top)






[Soon]
when editing a profile the new profile is pushed to the start of the profiles
--(fix that by sorting them according to the lastActivated time and the createdAt time)
the dept will have a seperate screen that can be accessed from the sideBar (Debts)
to fullfil a debt the can take it's amount from any current moey profile and it will be substracted from that profile
the ability to a debt also will be implemented in the add transaction screen after showing the add a debt instead dialog the debt will be added to the debts screen which will be accissible from the sidebar debts
make the transactions page (pageview so that the user can scroll between income, outcome, all) 
make the quick action page (pageview so that the user can scroll between income, outcome, all)
and change the title(all, income, outcome ) after scrolling finishes
add a property to profiles, transactions, quick actions called index
-- this property will be used to arrange them later 
-- for the quick actions it will  be used to arrange them in the favourite status( home screen )
-- for the profiles it will be used to arrange them after activating them 
-- when activating a profile it's index property will be greater than the whole profiles in the list
-- when fetching them arrange them according to the index 
-- control this ability from the settings to let the user decide how to arrange them 
-- for the quick actions allow the user to drag and rearrange them in the favorites(home screen) with the recordable list
allow the user to open a profile even if it is still empty 
-- or show a dialog to delete empty profile when clicking  it's card if it is empty instead of opening it 
----------------------------------
for syncing data
in each data provider(profile, transactions, quick actions)
make a variable that will return an array of data needing to be synced wit ha flag of what you need to do
for example this will return an array of ProfileSync(flag:SyncFlags.add, profile:ProfileModel)
and the same for transactions and quick actions
add a method for each model to convert it to json or from json
-- i will use this methods to save the model to the database or fetch it from the data base




[Bad]
if there is another user logged in don't ask him just delete after showing the dialog to delete 
in the current implementation i will ask the user to delete or not
because the user will log out first before logging in with a different account
after fixing the login with another email button implement the deleting without asking the user if there is another email logged in and all the data synced






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



