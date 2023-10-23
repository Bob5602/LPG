/// @description Insert description here
// You can write your code in this editor

switch(obj_Master.difficulty){
	case "Easy":
		random_set_seed(real(obj_Master.puzzleNum) * 1);
	break;
	case "Medium":
		random_set_seed(real(obj_Master.puzzleNum) * 2);
	break;
	case "Hard":
		random_set_seed(real(obj_Master.puzzleNum) * 3);
	break;
}


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

startTime = current_time;

function TempToReal(){
	for(var i = 0; i < ds_list_size(allClues); i++){
		ds_list_add(allCluesClean,allClues[| i]);	
	}
	ds_list_clear(allClues);
}