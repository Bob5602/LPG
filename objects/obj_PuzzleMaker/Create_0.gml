/// @description Insert description here
// You can write your code in this editor

random_set_seed(obj_Master.puzzleNum);
overallStep = 0;
subStep = 0;

debugText = "";

groupsSetup = false;

puzzleGenerated = false;

rulesGenerated = false;

cluesGenerated = false;

cleanupComplete = false;

allClues = ds_list_create();
allCluesClean = ds_list_create();

text = "";
displayText = [];
text = "Beginning puzzle generation";
array_push(displayText,"Beginning Puzzle Generation - " + obj_Master.puzzleNum);


//Iteration stuff
subStepInProgress = false;

removalStep = false;




_removedRule = -4;
//Iteration variables
_i = 0;
_j = 0;
_n = 0;

_iterationCount = 0;

show_debug_message("Starting puzzle " + obj_Master.puzzleNum);