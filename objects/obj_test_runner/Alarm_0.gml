/// @description Insert description here
// You can write your code in this editor

if(obj_Master.playerReady){
	with(obj_Master.abandon_button){
		event_user(0)	
	}
	alarm[1] = 15;
	puzzlesTested += 1;
	show_debug_message("Puzzles Tested: " + string(puzzlesTested));
}else{
	if(attemptcount > 30){
		show_message("Puzzle Failed! # " + obj_Master.puzzleNum);
		instance_destroy();
	}
	attemptcount += 1;
	alarm[0] = 60;
}