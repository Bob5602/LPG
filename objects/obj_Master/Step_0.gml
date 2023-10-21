/// @description Insert description here
// You can write your code in this editor

/*
if(ValidateWholeBoard() && ValidateWholeBoardComplete()){
	readyToGenerate = true;	
}else{
	readyToGenerate = false;	
}
*/

/*
//This will be useful later, i suppose
if(typing){
	text = keyboard_string;
	if(keyboard_check_pressed(vk_enter)){
		typing = false;	
		var _t = ParseRuleText(text);
		var _temp = new Rule(_t);
		ds_list_add(rules,_temp);
		text = "<blank - Click here!>";
		//ApplyRules();
	}
	exit;
}



if(point_in_rectangle(mouse_x,mouse_y,room_width-500,30,room_width-30,60) && mouse_check_button_pressed(mb_left)){
	keyboard_string = "";
	typing = true;
	//GenerateRules();
}
*/
if(!inProgress && typing){
	puzzleNum = keyboard_string;
	
	puzzleNum = string(string_digits(puzzleNum));
	if(string_length(puzzleNum)> 6){
		puzzleNum = string_copy(puzzleNum,1,6);
	}
	if(keyboard_check_pressed(vk_enter)){
		typing = false;	
	}
	exit;
}


if(playerReady){
	for(var i=0; i < ds_list_size(subGroups); i++){
		if(subGroups[| i].CheckMouseOver(mouse_x,mouse_y)){
			//show_debug_message("Over group: " + subGroups[| i].name);
			var loc = subGroups[| i].GetMouseOverCell(mouse_x,mouse_y);
			if(loc[0] != -4 && loc[1] != -4){
				//show_debug_message("Over cell : " + loc[0] + " x " + loc[1]);
				if(mouse_check_button_released(mb_left)){
					CycleCell(loc[0],loc[1]);	
				}
				if(mouse_check_button_released(mb_right)){
					ClearCell(loc[0],loc[1]);	
				}
			}
		}
	}
}

var _sh = string_height(puzzleNum);
var _sw = string_width(puzzleNum);
//	draw_rectangle(room_width/2-_sw/2,575,room_width/2+_sw/2,575+_sh,1);

if(!inProgress && point_in_rectangle(mouse_x,mouse_y,room_width/2-_sw/2,725,room_width/2+_sw/2,725+_sh) && mouse_check_button_pressed(mb_left)){
	keyboard_string = "";
	typing = true;
	//GenerateRules();
	
}

if(!playerReady && puzzleGrid == -4 && start_easy_button == -4 && !inProgress){
	CreateStartButtons();
}

if(playerReady && check_button == -4 && abandon_button == -4 && clear_button == -4){
	CreateGameButtons();
}



/*

if(keyboard_check_released(ord("G")) && !instance_exists(obj_PuzzleMaker)){
	instance_create_layer(0,0,"Instances",obj_PuzzleMaker);	
}

if(keyboard_check_released(ord("R"))){
	repeat(10){
		random_set_seed(100);
		var _t = ds_list_create();
		ds_list_add(_t,irandom(100),irandom(100),irandom(100),irandom(100),irandom(100),irandom(100));
		ds_list_shuffle(_t);
		show_debug_message(string(_t[|0]) + " " + string(_t[|1]) + " " + string(_t[|2]) + " " + string(_t[|3]) + " " + string(_t[|4]) + " " + string(_t[|5]));
		ds_list_destroy(_t);
	}
}
if(keyboard_check_released(ord("S"))){
	ApplyRules();
}
*/

/*
if(keyboard_check_released(ord("T"))){
//	instance_create_layer(0,0,"instances",obj_test_runner);
	
	show_debug_message("Consistency Check:")
	
	var _str = "";
	for(var o = 0; o < ds_list_size(obj_Master.keywords); o++){
		_str += obj_Master.keywords[| o] + ", ";
	}
	show_debug_message(_str);
	
	repeat(10){
		var _rand1 = irandom(14);
		var _rand2 = irandom(14);
		var _a = keywords[| _rand1];
		var _b = keywords[| _rand2];
		
		var _c = GetState(_a,_b);
		
		var _d = _rand1;//ds_list_find_index(keywords,_a);
		var _e = _rand2;//ds_list_find_index(keywords,_b);
		
		if(_rand1 != _d){
			show_debug_message("Not the same?");	
		}
		if(_rand2 != _e){
			show_debug_message("Not the same?");	
		}
		var _f = truthGrid[# _d,_e];
		
		if(_c == _f){
			show_debug_message("Passed " + string(_c) + " = " + string(_f));	
		}else{
			show_debug_message("Failed " + string(_c) + " = " + string(_f));	
		}
	}
		
}

*/

/*
if(keyboard_check_released(ord("B"))){
	randomize();
	ClearRules();
	var _usedRules = ds_list_create();
	var _usedKeywords = []
	
	//Lets shuffle em up.
	ds_list_shuffle(testRules);
	
	//THis is where I am going to test some stuff.  This will only work if rules have been generated though, sadly.
	if(ds_list_empty(testRules)){
		show_debug_message("No rules generated");
		exit;
	}
	//First, lets do a value rule.
	for(var i = 0; i < ds_list_size(testRules); i++){
		var _rule = testRules[| i];
		if(_rule.ruleType == "before" || _rule.ruleType == "after"){
			//Add this rule to the list
			ds_list_add(_usedRules,_rule);
			show_debug_message("Added rule " + _rule.ToString());
			//ADd this rule's keywords to the list.
			for(var j = 0; j < ds_list_size(_rule.ruleKeywords); j++){
				array_push(_usedKeywords, _rule.ruleKeywords[| j]);	
			}
			break;
		}
	}
	show_debug_message("Current Keywords are: " + string(_usedKeywords));
	
	//Then lets do a multi rule.
	//This should bring our total total to 7 keywords
	
	for(var i = 0; i < ds_list_size(testRules); i++){
		var _rule = testRules[| i];
		if(_rule.ruleType == "multi"){
			//Add this rule to the list
			if(!array_contains(_usedKeywords,_rule.ruleKeywords[| 0]) &&
			!array_contains(_usedKeywords,_rule.ruleKeywords[| 1]) &&
			!array_contains(_usedKeywords,_rule.ruleKeywords[| 2]) &&
			!array_contains(_usedKeywords,_rule.ruleKeywords[| 3]) &&
			!array_contains(_usedKeywords,_rule.ruleKeywords[| 4])){
				//If none of these are there, add this urle
				ds_list_add(_usedRules,_rule);
				show_debug_message("Added rule " + _rule.ToString());
				//ADd this rule's keywords to the list.
				for(var j = 0; j < ds_list_size(_rule.ruleKeywords); j++){
					array_push(_usedKeywords, _rule.ruleKeywords[| j]);	
				}
				break;	
			}
			
		}
	}
	//Show current rules
	show_debug_message("Current Keywords are: " + string(_usedKeywords));
	
	//Lets do it for either an either or or a neither nor
	for(var i = 0; i < ds_list_size(testRules); i++){
		var _rule = testRules[| i];
		if(_rule.ruleType == "either" || _rule.ruleType == "neither"){
			//Add this rule to the list
			if(!array_contains(_usedKeywords,_rule.ruleKeywords[| 0]) &&
			!array_contains(_usedKeywords,_rule.ruleKeywords[| 1]) &&
			!array_contains(_usedKeywords,_rule.ruleKeywords[| 2])){
				//If none of these are there, add this urle
				ds_list_add(_usedRules,_rule);
				show_debug_message("Added rule " + _rule.ToString());
				//ADd this rule's keywords to the list.
				for(var j = 0; j < ds_list_size(_rule.ruleKeywords); j++){
					array_push(_usedKeywords, _rule.ruleKeywords[| j]);	
				}
				break;	
			}
			
		}
	}
	//Show current rules
	show_debug_message("Current Keywords are: " + string(_usedKeywords));
	
	for(var i = 0; i < ds_list_size(testRules); i++){
		var _rule = testRules[| i];
		if(_rule.ruleType == "true"){
			//Add this rule to the list
			if(!array_contains(_usedKeywords,_rule.ruleKeywords[| 0]) &&
			!array_contains(_usedKeywords,_rule.ruleKeywords[| 1])){
				//If none of these are there, add this urle
				ds_list_add(_usedRules,_rule);
				show_debug_message("Added rule " + _rule.ToString());
				//ADd this rule's keywords to the list.
				for(var j = 0; j < ds_list_size(_rule.ruleKeywords); j++){
					array_push(_usedKeywords, _rule.ruleKeywords[| j]);	
				}
				break;	
			}
			
		}
	}
	//Show current rules
	show_debug_message("Current Keywords are: " + string(_usedKeywords));
	
	//Add a second true or false clue
	for(var i = 0; i < ds_list_size(testRules); i++){
		var _rule = testRules[| i];
		if(_rule.ruleType == "false"){
			//Add this rule to the list
			if(!array_contains(_usedKeywords,_rule.ruleKeywords[| 0]) &&
			!array_contains(_usedKeywords,_rule.ruleKeywords[| 1])){
				//If none of these are there, add this urle
				ds_list_add(_usedRules,_rule);
				show_debug_message("Added rule " + _rule.ToString());
				//ADd this rule's keywords to the list.
				for(var j = 0; j < ds_list_size(_rule.ruleKeywords); j++){
					array_push(_usedKeywords, _rule.ruleKeywords[| j]);	
				}
				break;	
			}
			
		}
	}
	//Show current rules
	show_debug_message("Current Keywords are: " + string(_usedKeywords));
	
	//Add a single pair clue
	for(var i = 0; i < ds_list_size(testRules); i++){
		var _rule = testRules[| i];
		if(_rule.ruleType == "pair"){
			//Add this rule to the list
			
			//If none of these are there, add this urle
			ds_list_add(_usedRules,_rule);
			show_debug_message("Added rule " + _rule.ToString());
			//ADd this rule's keywords to the list.
			for(var j = 0; j < ds_list_size(_rule.ruleKeywords); j++){
				array_push(_usedKeywords, _rule.ruleKeywords[| j]);	
			}
			break;	
			
		}
	}
	//Show current rules
	show_debug_message("Current Keywords are: " + string(_usedKeywords));
	
	ds_list_shuffle(testRules);
	//Add a single pair clue
	for(var i = 0; i < ds_list_size(testRules); i++){
		var _rule = testRules[| i];
		if(_rule.ruleType == "pair"){
			//Add this rule to the list
			
			//If none of these are there, add this urle
			ds_list_add(_usedRules,_rule);
			show_debug_message("Added rule " + _rule.ToString());
			//ADd this rule's keywords to the list.
			for(var j = 0; j < ds_list_size(_rule.ruleKeywords); j++){
				array_push(_usedKeywords, _rule.ruleKeywords[| j]);	
			}
			break;	
			
		}
	}
	//Show current rules
	show_debug_message("Current Keywords are: " + string(_usedKeywords));
	
	for(var i = 0; i < ds_list_size(_usedRules); i++){
		AddRuleSafe(rules,_usedRules[| i]);	
	}
	ds_list_destroy(_usedRules);
	ApplyRules();
}
*/

/*
if(keyboard_check_released(ord("V"))){
	while(!ValidateWholeBoardComplete()){
		
	
		var _added = false;
		do{
		var _priorities = ds_priority_create();
		var _rulePriorities = ds_priority_create();
		SetPriorities(_priorities);
		SetRulePriorities(_rulePriorities);
		var _exit = 0;
		//So we're going to add a rule, with, the lowest priority.
		do{
			var _desKeyword = ds_priority_find_min(_priorities);
			var _desNotKeyword = ds_priority_find_max(_priorities);
			if(_desKeyword == _desNotKeyword){
				ds_priority_change_priority(_priorities,_desNotKeyword,ds_priority_find_priority(_priorities,_desNotKeyword) + 1);	
			}
		}until (_desKeyword != _desNotKeyword);
		var _desType = ds_priority_find_min(_rulePriorities);
		ClearAll();
	
		ds_list_shuffle(testRules);
		for(var i = 0; i < ds_list_size(testRules); i++){
			var _testRule = testRules[| i];
			if(_testRule.ruleType == _desType && ds_list_find_index(_testRule.ruleKeywords,_desKeyword) != -1 && ds_list_find_index(_testRule.ruleKeywords,_desNotKeyword) == -1){
				AddRuleSafe(rules,_testRule);
				show_debug_message("Type of "+ _desType + " and desired keyword was " + _desKeyword + " and avoiding " + _desNotKeyword + " So we added " + _testRule.ToString());
				_added = true;
				break;
			}
		}
		ApplyRules();
		ds_priority_destroy(_priorities);
		ds_priority_destroy(_rulePriorities);
		}until (_added = true);
	}
}
*/

/*
function GenSolvingRules(){
	ClearRules();
	while(!ValidateWholeBoardComplete()){
		
	
		var _added = false;
		do{
		var _priorities = ds_priority_create();
		var _rulePriorities = ds_priority_create();
		SetPriorities(_priorities);
		SetRulePriorities(_rulePriorities);
		var _exit = 0;
		//So we're going to add a rule, with, the lowest priority.
		do{
			var _desKeyword = ds_priority_find_min(_priorities);
			var _desNotKeyword = ds_priority_find_max(_priorities);
			if(_desKeyword == _desNotKeyword){
				ds_priority_change_priority(_priorities,_desNotKeyword,ds_priority_find_priority(_priorities,_desNotKeyword) + 1);	
			}
		}until (_desKeyword != _desNotKeyword);
		var _desType = ds_priority_find_min(_rulePriorities);
		ClearAll();
	
		ds_list_shuffle(testRules);
		for(var i = 0; i < ds_list_size(testRules); i++){
			var _testRule = testRules[| i];
			if(_testRule.ruleType == _desType && ds_list_find_index(_testRule.ruleKeywords,_desKeyword) != -1 && ds_list_find_index(_testRule.ruleKeywords,_desNotKeyword) == -1){
				//AddRuleSafe(rules,_testRule);
				ds_list_add(rules,_testRule);
				show_debug_message("Type of "+ _desType + " and desired keyword was " + _desKeyword + " and avoiding " + _desNotKeyword + " So we added " + _testRule.ToString());
				_added = true;
				
				//if(_testRule.ruleType == "true" || _testRule.ruleType == "false" || _testRule.ruleType == "multi" || _testRule.ruleType == "neither" || _testRule.ruleType == "either" || _testRule.ruleType == "pair"){
				//show_message("Old : " + _testRule.ToString());
				//show_message("New : " + GeneratePrettyRuleText(_testRule));
				//}
				
				break;
			}
		}
		ApplyRules();
		ds_priority_destroy(_priorities);
		ds_priority_destroy(_rulePriorities);
		}until (_added = true);
		if(ds_list_size(rules) > 19){
			show_debug_message("Failed I think");
			break;	
		}
	}
	
	//Removal check?
	var _allNeeded = false;
	//Make a new list
	var _listCopy = ds_list_create();
	//Copy the rules list
	ds_list_copy(_listCopy,rules);
	
		
	for(var i = 0; i < ds_list_size(_listCopy); i++){
		//Make a copy of this rule
		var _removedRule = _listCopy[| i];
		//Get the index of the removed rule
		var _index = ds_list_find_index(rules,_removedRule);
		//Remove the rule if it is there.
		if(_index != -4){
			ds_list_delete(rules,_index);
		}
		//Clear it
		ClearAll();
		//Apply the rules as they are now
		ApplyRules();
		//Check it out.  If it doesn't work, we add it back in
		if(!ValidateWholeBoardComplete()){
			ds_list_add(rules,_removedRule);
		}else{
			//In this case, the rule was not necessary
			//So we destroy it
			show_debug_message("We did not need this rule : " + _removedRule.ToString());
			//_removedRule.Destroy();
		}
	}
	ds_list_destroy(_listCopy);
	ds_list_add(solutions,[ds_list_size(rules)]);
}


*/