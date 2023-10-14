/// @description Insert description here
// You can write your code in this editor

obj_Master.inProgress = true;
obj_Master.start_button = -4;
obj_Master.typing = false;

if(obj_Master.puzzleNum = ""){
	obj_Master.puzzleNum = GenerateSeed();	
}

instance_create_layer(0,0,"Instances",obj_PuzzleMaker);
instance_destroy();