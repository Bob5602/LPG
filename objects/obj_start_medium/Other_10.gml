/// @description Insert description here
// You can write your code in this editor

/// @description Insert description here
// You can write your code in this editor

obj_Master.inProgress = true;
obj_Master.typing = false;

if(obj_Master.puzzleNum = ""){
	obj_Master.puzzleNum = GenerateSeed();
}
obj_Master.difficulty = "Easy";

instance_create_layer(0,0,"Instances",obj_PuzzleMaker);
obj_Master.DestroyStartButtons();