the error that happens in the production only was cause by the getActiveProfile method (it was called by an anonymous thing)
i don't know what is it , and this happens before fetching the profiles from the database
I think this happens because somewhere in the app i forgot to add the await 
so the app calls the getActiveProfile before fetching the profiles from the database