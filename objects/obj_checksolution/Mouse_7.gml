/// @description Insert description here
// You can write your code in this editor

var _solved = verifyPuzzleSolved(obj_Master.solution);

if(_solved){
	obj_Master.CleanUp(true);	
}else{
	obj_Master.notSolved = true;
	obj_Master.errorCount = GetErrorCount();
}