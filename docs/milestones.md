# Milestone 1 - skeleton
 - ✅ boilerplate
 - ✅ clean flutter project architecture
 - ✅ domain model framework
 - ✅ persistence
 - ✅ domain models + CRUD operations
 - ✅ settings + config screens for being able to create test data for following milestones 

# Milestone 2 - core screens
 - ✅ daily log/ dashboard widgets + services
 - ✅ food log widgets + services
 - workout log widgets + services
 - basic balance calculation

## TODOs from manually testing:
 - ✅ the deselect food actually doesn't remove the food from dailylog or delete the foodlog entry
 - ✅ the add_food_screen should not contain the state of the daily log => already assigned food 
 - ✅ => the food screen should only be there to add food on save
 - ✅ => removing the food from daily log, should be able in dashboard_screen where the food i also listed
 - ✅ on food save => daily log is broken => weight and bmr and profile get deleted
 - ✅ recalculation should be done outside of food add screen
 - ✅ maybe we just want a crud food screen for selected date screen
 - ✅ food screen shoud be as stupid as possible and should not have any writing concerns about the dailylog entries
 - ✅ is the date already enought to decouple daily log from food entry? => maybe the food ids are not needed on dailylog side 
 - ✅ we could simply ask for the food by date whenever we want to recalculate
 - ✅ to reduce complexity we can hard-code the unit of the food entries to 'g' for grams => the unit field can be removed from food model and food config model
 - ✅ the dashboard screen isn't refreshed when navigating back to it (e.g. from food add screen) => it should show the current daily log entry of the selected date

 ## TODOs UI improvements
 - ✅ change red color to yellow
 - ✅ change blue color accent to purple
 - ✅ change color: under goal= white, over goal= yellow
 - ✅ show amount in dash food item
 - ✅ title purple

## TODOs Features
 - ✅ in calorie dash section: add planned deficite to dailyLogConfig and show in calorie view in net calc
 - ✅ goal to profile: defizit, protein, fat, carbs
 - ✅ show macros details on screen
 - ✅ use carousel view
 - continue with workout add screen
 - workout dash section should not only have delete but als edit action button
 - workout edit mode is the same like the workout mode

# Milestone 3 - UI and Feature Enrichments

## TODOs
 - refactor: move calc logic to service layer
 - refactor: move colors to primary profile to zentralize
 - handle inline TODOs
 - remove separator line in add food screen
 - make search field in add food sceen less dominant
 - ✅ decrease font size of weight number and center align it, with dot dash round border
 - ✅ clean up macro dashboard (tabbed inner row element to keep equal intents)
 - in add food screen the favorites should be marked and on top
 - weight week avg, 30-day avg
 - show number of day logs 
 - select profile instead of take first

# Milestone 4 - Import, Export and default presets
 - export
 - import
 - default presets