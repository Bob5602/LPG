// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function ApplyRules(){
	ClearAll();
	repeat(3){
		for(var i = 0; i < ds_list_size(obj_Master.rules); i++){
			ApplyRule(obj_Master.rules[| i]);
			CheckOtherMatches();
		}
	}
}

function ClearRules(){
	ClearAll()
	for(var i = 0; i < ds_list_size(obj_Master.rules); i++){
		var _rule = obj_Master.rules[| i];
		_rule.Destroy();
	}
	ds_list_clear(obj_Master.rules);
}

function ClearSubGroups(){
	
	for(var i = 0; i < ds_list_size(obj_Master.subGroups); i++){
		var _subgroup = obj_Master.subGroups[| i];
		_subgroup.Destroy();
	}
	ds_list_clear(obj_Master.subGroups);
}

function ApplyRule(_rule){
	switch _rule.ruleType{
		case "true":
		var _a = "";
		var _b = "";
		
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(_a == "" && CheckKeyword(_rule.ruleText[| j])){
				_a = _rule.ruleText[| j];
			}else if(_b == "" && CheckKeyword(_rule.ruleText[| j])){
				_b = _rule.ruleText[| j];
			}
		}
		
		if(_a != "" && _b != ""){
			MarkTrue(_a,_b);	
		}
		
		break;
		case "false":
		var _a = "";
		var _b = "";
		
		//Find the two items in the clue
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(_a == "" && CheckKeyword(_rule.ruleText[| j])){
				_a = _rule.ruleText[| j];
			}else if(_b == "" && CheckKeyword(_rule.ruleText[| j])){
				_b = _rule.ruleText[| j];
			}
		}
		//Mark em false
		if(_a != "" && _b != ""){
			MarkFalse(_a,_b);	
		}
		break;
		case "multi":
		case "neither":
		var _clues = ds_list_create();
		//Go through an add the "clues" to the list
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(CheckKeyword(_rule.ruleText[| j])){
				ds_list_add(_clues,_rule.ruleText[| j]);
			}
		}
		//Mark all the relationships false
		for(var o = 0; o < ds_list_size(_clues)-1; o++){
			for(var p = o+1; p < ds_list_size(_clues); p++){
				MarkFalse(_clues[| o], _clues[| p]);
			}
		}
		
		ds_list_destroy(_clues);
		break;
		case "either":
		//GEt my 3 variables..
		var _a = "";
		var _b = "";
		var _c = "";
		
		//Set em up
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(_a == "" && CheckKeyword(_rule.ruleText[| j])){
				_a = _rule.ruleText[| j];
			}else if(_b == "" && CheckKeyword(_rule.ruleText[| j])){
				_b = _rule.ruleText[| j];
			}else if(_c == "" && CheckKeyword(_rule.ruleText[| j])){
				_c = _rule.ruleText[| j];
			}
		}
		

		//If the last 2 are in differnet groups mark em false, otherwise mark all the others in the group
		if(FindGroup(_b) != FindGroup(_c)){
			MarkFalse(_b,_c);
		}else if(GetState(_a,_b) == 0 && GetState(_a,_c) == 0){
			MarkEitherOr(_a,_b,_c);
		}
		
		//If A == B
		if(GetState(_a,_b) == 2 && GetState(_a,_c) != 1){
			MarkFalse(_a,_c);
		}
		//If A != B
		if(GetState(_a,_b) == 1 && GetState(_a,_c) != 2){
			MarkTrue(_a,_c);
		}
		
		//If A == C
		if(GetState(_a,_c) == 2 && GetState(_a,_b) != 1){
			MarkFalse(_a,_b);
		}
		//If A != C
		if(GetState(_a,_c) == 1 && GetState(_a,_b) != 2){
			MarkTrue(_a,_b);	
		}
				
		break;
		
		case "pair":
		//GEt my 2 pairs of variables..
		var _a1 = "";
		var _a2 = "";
		var _b1 = "";
		var _b2 = "";
		
		//Set em up
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(_a1 == "" && CheckKeyword(_rule.ruleText[| j])){
				_a1 = _rule.ruleText[| j];
			}else if(_a2 == "" && CheckKeyword(_rule.ruleText[| j])){
				_a2 = _rule.ruleText[| j];
			}else if(_b1 == "" && CheckKeyword(_rule.ruleText[| j])){
				_b1 = _rule.ruleText[| j];
			}else if(_b2 == "" && CheckKeyword(_rule.ruleText[| j])){
				_b2 = _rule.ruleText[| j];
			}
		}
		
		//Immediate falses
		MarkFalse(_a1,_a2);
		MarkFalse(_b1,_b2);
		
		//Fix the trues
		
		if(GetState(_a1,_b1) == 2){
			MarkTrue(_a2, _b2);
			MarkFalse(_a1,_b2);
			MarkFalse(_a2,_b1);
		}
		if(GetState(_a1,_b2) == 2){
			MarkTrue(_a2, _b1);	
			MarkFalse(_a1,_b1);
			MarkFalse(_a2,_b2);
		}
		if(GetState(_a2,_b1) == 2){
			MarkTrue(_a1, _b2);
			MarkFalse(_a1,_b1);
			MarkFalse(_a2,_b2);
		}
		if(GetState(_a2,_b2) == 2){
			MarkTrue(_a1, _b1);	
			MarkFalse(_a1,_b2);
			MarkFalse(_a2,_b1);
		}
		
		if(GetState(_a1,_b1) == 1){
			MarkFalse(_a2, _b2);
			MarkTrue(_a1,_b2);
			MarkTrue(_a2,_b1);
		}
		if(GetState(_a1,_b2) == 1){
			MarkFalse(_a2, _b1);	
			MarkTrue(_a2,_b2);
			MarkTrue(_a1,_b1);
		}
		if(GetState(_a2,_b1) == 1){
			MarkFalse(_a1, _b2);
			MarkTrue(_a1,_b1);
			MarkTrue(_a2,_b2);
		}
		if(GetState(_a2,_b2) == 1){
			MarkFalse(_a1, _b1);	
			MarkTrue(_a1,_b2);
			MarkTrue(_a2,_b1);
		}

		break;
		
		case "before":
		case "after":
		
		var _first = "";
		var _second = "";
		
		var numGroup = "";
		
		switch(_rule.ruleType){
			case "before":
			for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
				if(_first == "" && CheckKeyword(_rule.ruleText[| j])){
					_first = _rule.ruleText[| j];
				}else if(_second == "" && CheckKeyword(_rule.ruleText[| j])){
					_second = _rule.ruleText[| j];
				}
			}	
			break;
			case "after":
			for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
				if(_second == "" && CheckKeyword(_rule.ruleText[| j])){
					_second = _rule.ruleText[| j];
				}else if(_first == "" && CheckKeyword(_rule.ruleText[| j])){
					_first = _rule.ruleText[| j];
				}
			}
			break;
		}
		
		//If they're not in the same group, they can't be equal!
		if(FindGroup(_first) != FindGroup(_second)){
			MarkFalse(_first,_second);
		}
		
		var _steps = _rule.steps;
		var _numGroup = _rule.numGroup;
		
		//We now know which was "first", which was "second" and "how far apart they are"
		
		//First cannot anything besides steps from the end.
		var i = 4;
		repeat (_steps){
			var _t =_numGroup.getName(i);
			MarkFalse(_first,_t);
			i--;
		}
		//Second cannot be anything steps from the start.
		var i = 0;
		repeat (_steps){
			var _t =_numGroup.getName(i);
			MarkFalse(_second,_t);
			i++;
		}
		
		//Brute force way

		//Do it for _first
		for(var i = 0; i < 5; i++){
			var _t = GetState(_numGroup.getName(i),_first);
			if(_t == 1){
				if((i + _steps) <= 4){
					MarkFalse(_second,_numGroup.getName(i + _steps));	
				}
			}
			if(_t == 2){
				if((i + _steps) <= 4){
					MarkTrue(_second,_numGroup.getName(i + _steps));	
				}
			}
		}

		for(var i = 0; i < 5; i++){
			var _t = GetState(_numGroup.getName(i),_second);
			if(_t == 1){
				if((i - _steps) >= 0){
					MarkFalse(_first,_numGroup.getName(i - _steps));	
				}
			}
			if(_t == 2){
				if((i - _steps) >= 0){
					MarkTrue(_first,_numGroup.getName(i - _steps));	
				}
			}
		}
		
		break;
		case "invalid":
		
		break;
		default:
		
		break;
	}
}

function ParseRuleText(_str){
	var _words = ds_list_create();
	var _word = "";
	for(var i = 1; i <= string_length(_str); i++){
		
		if(string_char_at(_str,i) != " "){
			_word += string_char_at(_str,i);	
		}else{
			var _t = _word;
			ds_list_add(_words,_t);
			_word = "";
		}
	}
	ds_list_add(_words,_word);
	
	return _words;
}

function DetermineRuleType(_ruleText){
	if(ds_list_find_index(_ruleText,"not") != -1){
		return "false";	
	}else if(ds_list_find_index(_ruleText,"is") != -1){
		return "true";
	}else if(ds_list_find_index(_ruleText,"five") != -1){
		return "multi";
	}else if(ds_list_find_index(_ruleText,"neither") != -1 && ds_list_find_index(_ruleText,"nor") != -1){
		return "neither";
	}else if(ds_list_find_index(_ruleText,"either") != -1 && ds_list_find_index(_ruleText,"or") != -1){
		return "either";
	}else if(ds_list_find_index(_ruleText,"of") != -1 && ds_list_find_index(_ruleText,"one") != -1){
		return "pair";
	}else if(ds_list_find_index(_ruleText,"before") != -1 || ds_list_find_index(_ruleText,"less") != -1){
		return "before";
	}else if(ds_list_find_index(_ruleText,"after") != -1 || ds_list_find_index(_ruleText,"more") != -1){
		//ds_list_find_index(_ruleText,obj_Master.amount.named) != -1 && 
		return "after";
	}else{
		return "invalid";
	}
}

function GetRuleKeywords(_wordList){
	var _kWords = ds_list_create();
	for(var i = 0; i < ds_list_size(_wordList); i++){
		var _word = _wordList[| i];
		if(ds_list_find_index(_kWords,_word) == -1 && ds_list_find_index(obj_Master.keywords,_word) != -1){
			ds_list_add(_kWords,_word);
		}
	}
	ds_list_sort(_kWords,1);
	return _kWords;
}

function AddRuleSafe(_list,_rule){
	
	//If this rules list is empty, just add it whatever man.
	if(ds_list_empty(_list)){
		ds_list_add(_list,_rule);
		return;
	}
	//If its a before/after rule, just add it.  No dupes in multi rules.
	/*
	if(_rule.ruleType == "before" || _rule.ruleType == "after" || _rule.ruleType == "multi"){
		ds_list_add(_list,_rule);
		return;
	}
	*/
	var _nRule = _rule.ruleKWWritten;
	//Now we go through all the existing rules to check for dupes.
	for(var i = 0; i < ds_list_size(_list); i++){
		//Get the existing rule we're checking against
		var _eRule = _list[| i];
		
		//If its not the same rule type
		/*
		if(_eRule.ruleType != _rule.ruleType){
			continue;
		}
		*/
		
		
		//Should check number of elements, but, I don't think this matters.
		
		//If we got here, we MUST be the same ruletype.
		//We're gonna assume its not new
		var _isNew = false;
		
		if(_nRule != _eRule.ruleKWWritten){
			_isNew = true;
			continue;
		}
		
		/*
		//Check the keywords
		for(var n = 0; n < ds_list_size(_rule.ruleKeywords); n++){
			//Get the new keyword
			//var _nKeyword = _rule.ruleKeywords[| n];
			if(_rule.ruleKeywords[| n] != _eRule.ruleKeywords[| n]){
				_isNew = true;
				if(!_stringCompare){
					show_debug_message("The same but string compare didn't think so");
				}
				break;
			}
		}
		*/
		
		
		
		//NOW if we made it here, if _isNew is FALSE we know its a dupe.
		//We actually can't know its new until all the loops have gone
		if(!_isNew){
					
			//We're gonna have some fun
			//If its a duplicate, we're gonna either destroy the new rule, or, destroy the old rule
			//And replace it.
			
			if(irandom(1) == 1){
				ds_list_replace(_list,i,_rule);
				_eRule.Destroy();
				return;
			}else{
				_rule.Destroy();
				return;
			}
			
		}
	}
	//There is no rules of this type already, so it must be new
	
	
	//We add it
	ds_list_add(_list,_rule);
	return;
}

function Rule(_list) constructor{
	ruleText = _list; //ds_list
	ruleType = DetermineRuleType(ruleText);
	ruleKeywords = GetRuleKeywords(_list); //ds_list
	ruleKWWritten = ds_list_write(ruleKeywords);
	
	if(ruleType == "before" || ruleType == "after"){
		for(var i = 0; i < ds_list_size(ruleText); i++){
			if(string_digits(ruleText[| i]) != ""){
				steps = string_digits(ruleText[| i]);
			}
		}
		//Go through keywords
		for(var i = 0; i < ds_list_size(obj_Master.groups);i++){
			var _group = obj_Master.groups[| i];
			if(_group.value){
				//This is a value group
				numGroup = _group;
				break;
			}
		}
	}
	//rulePrettyText = GeneratePrettyRuleText(self);
	
	static GeneratePrettyText = function(){
		rulePrettyText = GeneratePrettyRuleText(self);	
	}
	static ToString = function(){
		var _str = "";
		for(var i = 0; i < ds_list_size(ruleText); i++){
			_str += ruleText[| i];
			_str += " ";
		}
		_str = string_trim(_str);
		return _str;
	}
	
	static DrawRuleText = function(_x,_y){
		var _xoffset = 0;
		for(var i = 0; i < ds_list_size(ruleText); i++){
			var _str = ruleText[| i];
			if(CheckKeyword(_str)){
				draw_set_color(c_red);
			}else if(CheckAction(_str)){
				draw_set_color(c_yellow);
			}else{
				draw_set_color(c_white);
			}
			_str += " ";
			draw_text(_x + _xoffset,_y,_str);
			_xoffset += string_width(_str);
		}
	}
	
	static DrawPrettyRuleText = function(_x,_y){
		//draw_text(_x,_y,rulePrettyText);
		draw_text_ext(_x,_y,rulePrettyText,15,750)
	}
	
	static Destroy = function(){
		ds_list_destroy(ruleText);
		ds_list_destroy(ruleKeywords);
	}
}

function GeneratePrettyRuleText(_rule){
	var _str = "";
	switch _rule.ruleType{
		case "true":
		var _a = "";
		var _b = "";
		
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(_a == "" && CheckKeyword(_rule.ruleText[| j])){
				_a = _rule.ruleText[| j];
			}else if(_b == "" && CheckKeyword(_rule.ruleText[| j])){
				_b = _rule.ruleText[| j];
			}
		}
		
		_str += FindGroup(_a).preText;
		_str += _a;
		_str += FindGroup(_a).postText;
		_str += " is ";
		_str += FindGroup(_b).preText + _b + FindGroup(_b).postText;
		
		break;
		case "false":
		var _a = "";
		var _b = "";
		
		//Find the two items in the clue
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(_a == "" && CheckKeyword(_rule.ruleText[| j])){
				_a = _rule.ruleText[| j];
			}else if(_b == "" && CheckKeyword(_rule.ruleText[| j])){
				_b = _rule.ruleText[| j];
			}
		}
		
		_str += FindGroup(_a).preText;
		_str += _a;
		_str += FindGroup(_a).postText;
		_str += " is not ";
		_str += FindGroup(_b).preText + _b + FindGroup(_b).postText;
		
		break;
		case "multi":
		
		_str += "Five different people are ";
		var _clues = ds_list_create();
		//Go through an add the "clues" to the list
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(CheckKeyword(_rule.ruleText[| j])){
				ds_list_add(_clues,_rule.ruleText[| j]);
			}
		}
		
		for(var o = 0; o < ds_list_size(_clues); o++){
			var _p = _clues[| o];
			if(o == ds_list_size(_clues)-1){
				_str += "and ";
			}
			_str += FindGroup(_p).preText + _p + FindGroup(_p).postText;
			if(o != ds_list_size(_clues)-1){
				_str += ", ";
			}
		}
		
		ds_list_destroy(_clues);
		
		break;
		case "neither":
		var _clues = ds_list_create();
		//Go through an add the "clues" to the list
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(CheckKeyword(_rule.ruleText[| j])){
				ds_list_add(_clues,_rule.ruleText[| j]);
			}
		}
		//Mark all the relationships false
		var _a = _clues[| 0];
		var _b = _clues[| 1];
		var _c = _clues[| 2];
		
		_str += FindGroup(_a).preText + _a + FindGroup(_a).postText;
		_str += " is neither "
		
		_str += FindGroup(_b).preText + _b + FindGroup(_b).postText;
		
		_str += " nor "
		_str += FindGroup(_c).preText + _c + FindGroup(_c).postText;
		
		ds_list_destroy(_clues);
		break;
		case "either":
		//GEt my 3 variables..
		var _a = "";
		var _b = "";
		var _c = "";
		
		//Set em up
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(_a == "" && CheckKeyword(_rule.ruleText[| j])){
				_a = _rule.ruleText[| j];
			}else if(_b == "" && CheckKeyword(_rule.ruleText[| j])){
				_b = _rule.ruleText[| j];
			}else if(_c == "" && CheckKeyword(_rule.ruleText[| j])){
				_c = _rule.ruleText[| j];
			}
		}
					
		_str += FindGroup(_a).preText + _a + FindGroup(_a).postText;
		_str += " is either "
		
		_str += FindGroup(_b).preText + _b + FindGroup(_b).postText;
		
		_str += " or "
		_str += FindGroup(_c).preText + _c + FindGroup(_c).postText;
				
		break;
		
		case "pair":
		//GEt my 2 pairs of variables..
		var _a1 = "";
		var _a2 = "";
		var _b1 = "";
		var _b2 = "";
		
		//Set em up
		for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
			if(_a1 == "" && CheckKeyword(_rule.ruleText[| j])){
				_a1 = _rule.ruleText[| j];
			}else if(_a2 == "" && CheckKeyword(_rule.ruleText[| j])){
				_a2 = _rule.ruleText[| j];
			}else if(_b1 == "" && CheckKeyword(_rule.ruleText[| j])){
				_b1 = _rule.ruleText[| j];
			}else if(_b2 == "" && CheckKeyword(_rule.ruleText[| j])){
				_b2 = _rule.ruleText[| j];
			}
		}
		
		_str += "Between "
		
		_str += FindGroup(_a1).preText + _a1 + FindGroup(_a1).postText;
		_str += " and "
		
		_str += FindGroup(_a2).preText + _a2 + FindGroup(_a2).postText;
		
		_str += ", one of them is "
		_str += FindGroup(_b1).preText + _b1 + FindGroup(_b1).postText;
		_str += " and the other is "
		_str += FindGroup(_b2).preText + _b2 + FindGroup(_b2).postText;

		break;
		
		case "before":
		case "after":
		
		var _first = "";
		var _second = "";
		
		switch(_rule.ruleType){
			case "before":
			for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
				if(_first == "" && CheckKeyword(_rule.ruleText[| j])){
					_first = _rule.ruleText[| j];
				}else if(_second == "" && CheckKeyword(_rule.ruleText[| j])){
					_second = _rule.ruleText[| j];
				}
			}	
			break;
			case "after":
			for(var j = 0; j < ds_list_size(_rule.ruleText); j++){
				if(_second == "" && CheckKeyword(_rule.ruleText[| j])){
					_second = _rule.ruleText[| j];
				}else if(_first == "" && CheckKeyword(_rule.ruleText[| j])){
					_first = _rule.ruleText[| j];
				}
			}
			break;
		}
		
		
		var _steps = _rule.steps;
		var _amt = _rule.numGroup.amtType;
		
		
		switch(_rule.ruleType){
			case "before":
			_str += FindGroup(_first).preText + _first + FindGroup(_first).postText;
			_str += " " + _amt[3] + " " + string(_steps) + " " + _amt[0];
			if(_steps > 1){
				_str +="s";	
			}
			_str += " " + _amt[1] + " than ";
			_str += FindGroup(_second).preText + _second + FindGroup(_second).postText;
			break;
			case "after":
			
			_str += FindGroup(_second).preText + _second + FindGroup(_second).postText;
			_str += " " + _amt[3] + " " + string(_steps) + " " + _amt[0];
			if(_steps > 1){
				_str +="s";	
			}
			_str += " " + _amt[2] + " than ";
			_str += FindGroup(_first).preText + _first + FindGroup(_first).postText;
			break;
		}
		
			
		
		
		break;
		case "invalid":
		
		break;
		default:
		
		break;
	}
	
	
	//Capitalize first letter.
	var _firstChar = string_char_at(_str,1);
	_firstChar = string_upper(_firstChar);
	_str = string_delete(_str,1,1);
	_str = _firstChar + _str + ".";
	
	return _str;
}

function CheckKeyword(_text){
	//_text = string_lower(_text);
	if(ds_list_find_index(obj_Master.keywords,_text) != -1){
		return true;	
	}else{			
		return false;	
	}
}

function CheckAction(_text){
	var _temp = ds_list_create();
	ds_list_add(_temp,"is","not","five","neither","nor","either", "or","of","one","more","less","before","after");
	if(ds_list_find_index(_temp,_text) != -1){
		ds_list_destroy(_temp);
		return true;
	}else {
		ds_list_destroy(_temp);
		return false;	
	}
}


//Rule Generation

function GenerateTrueRules(_rulesList){
	//Format will be along the lines of :
	//Name1 is Name2
	//var _tempRuleList = ds_list_create();
	//Can actually probably utilize some of the helper functions already created.
	//Lets do this simply, and then, more difficulty.
	
	//Go through all the keywords
	for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
		//Get the keyword
		var _kw = obj_Master.keywords[| i];
		
		//Get all the positive relations
		var _posRel = FindPositiveRelations(_kw);
		
		//Go through all the positive relations
		for(var j = 0; j < ds_list_size(_posRel); j++){
			//Get the positive relation name
			var _relativeName = _posRel[| j];
			//Generate the striing
			var _string = _kw + " is " + _relativeName;
			//Parse it
			var _parsed = ParseRuleText(_string)
			//Generate the rule?
			var _rule = new Rule(_parsed);
			//Add it to the list
			
			//ds_list_add(obj_Master.rules,_rule);
			AddRuleSafe(_rulesList,_rule);
		}
		//Finished with this KW, destroy the list
		ds_list_destroy(_posRel);
	}
}

function GenerateFalseRules(_rulesList){
	//Format will be along the lines of :
	//Name1 is not Name2
	//var _tempRuleList = ds_list_create();
	//Can actually probably utilize some of the helper functions already created.
	//Lets do this simply, and then, more difficulty.
	
	//Go through all the keywords
	for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
		//Get the keyword
		var _kw = obj_Master.keywords[| i];
		
		//Get all the neg relations
		var _negRel = FindNegativeRelations(_kw);
		
		//Go through all the negative relations
		for(var j = 0; j < ds_list_size(_negRel); j++){
			//Get the negative relation name
			var _relativeName = _negRel[| j];
			//Generate the striing
			var _string = _kw + " not " + _relativeName;
			//Parse it
			var _parsed = ParseRuleText(_string)
			//Generate the rule?
			var _rule = new Rule(_parsed);
			//Add it to the list
			//ds_list_add(obj_Master.rules,_rule);
			AddRuleSafe(_rulesList,_rule);
		}
		//Finished with this KW, destroy the list
		ds_list_destroy(_negRel);
	}
}

function GenerateEitherOrRules(_rulesList){
	//Either or clues show up in this format:
	//Name1 was either A or B
	//One of em is a true relationship
	//The other is a false relationship
	
	//The trick here, the A cannot be equal to B.  I think this is implicit already?
	
	//So, we take a Key word, find all the true relationships, find all the negative relationships.
	
	//Go through all the keywords
	for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
		//Get the keyword
		var _kw = obj_Master.keywords[| i];
		
		//Get all the positive relations
		var _posRel = FindPositiveRelations(_kw);
		//GEt all the negative relations
		var _negRel = FindNegativeRelations(_kw);
		
		
		//Go through all the positive relations
		for(var j = 0; j < ds_list_size(_posRel); j++){
			//And go through all the negative relationships
			for(var u = 0; u < ds_list_size(_negRel); u++){
				//Get positive and negative relations
				var _pRelative = _posRel[| j];
				var _nRelative = _negRel[| u];
				
				//Shuffle it up
				var _boo = ds_list_create();
				ds_list_add(_boo,_pRelative,_nRelative);
				ds_list_shuffle(_boo);
				
				//Create the string!
				var _string = _kw + " either " + _boo[| 0] + " or " + _boo[| 1];
				//Parse it
				var _parsed = ParseRuleText(_string);
				//Generate the rule
				var _rule = new Rule(_parsed);
				//Add it to the list
				//ds_list_add(obj_Master.rules,_rule);
				AddRuleSafe(_rulesList,_rule);
				//Destroy this list
				ds_list_destroy(_boo);
			}
			
		}
		//Finished with this KW, destroy the lists
		ds_list_destroy(_posRel);
		ds_list_destroy(_negRel);
	}
}

function GenerateNeitherNorRules(_rulesList){
	//Either or clues show up in this format:
	//Name1 neither A nor B
	//They are both negative relationships (name1 != A, and name1 != B)
	//And importantly, A != B
	
	//So, we take a Key word, find all the true relationships, find all the negative relationships.
	
	//Go through all the keywords
	for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
		//Get the keyword
		var _kw = obj_Master.keywords[| i];
		
		//Get all the negative relations
		var _negRel = FindNegativeRelations(_kw);
		
		
		//Go through all the negative relations
		for(var j = 0; j < ds_list_size(_negRel); j++){
			//And go through all the negative relationships a second time
			for(var u = 0; u < ds_list_size(_negRel); u++){
				//Get positive and negative relations
				var _nRelative1 = _negRel[| j];
				var _nRelative2 = _negRel[| u];
				
				//Exit out of here, if they are the same thing
				if(_nRelative1 == _nRelative2){
					continue;	
				}
				//Exit out of here, if they are positive
				if(GetState(_nRelative1,_nRelative2) == 2){
					continue;
				}
				
				//Shuffle it up
				var _boo = ds_list_create();
				ds_list_add(_boo,_nRelative1,_nRelative2);
				ds_list_shuffle(_boo);
				
				//Create the string!
				var _string = _kw + " neither " + _boo[| 0] + " nor " + _boo[| 1];
				//Parse it
				var _parsed = ParseRuleText(_string);
				//Generate the rule
				var _rule = new Rule(_parsed);
				//Add it to the list
				//ds_list_add(obj_Master.rules,_rule);
				AddRuleSafe(_rulesList,_rule);
				//Destroy this list
				ds_list_destroy(_boo);
			}
			
		}
		//Finished with this KW, destroy the list
		ds_list_destroy(_negRel);
	}
	
}

function GenerateMultiRuleAlt(_rulesList){
	
	var _solution = obj_PuzzleMaker.solution;
	
	var _gA = [0,0,0,0,0];
	var _gAGroup = FindGroup(_solution[0][0]);
	var _gB = [0,0,0,0,0];
	var _gBGroup = FindGroup(_solution[0][1]);
	var _gC = [0,0,0,0,0];
	var _gCGroup = FindGroup(_solution[0][2]);
	
	for(var i = 0; i < array_length(_solution);i++){
		_gA[i] = _gAGroup.getNum(_solution[i][0]);	
		_gB[i] = _gBGroup.getNum(_solution[i][1]);
		_gC[i] = _gCGroup.getNum(_solution[i][2]);
	}
	
	var names = [
		_gAGroup.getName(0),_gAGroup.getName(1),_gAGroup.getName(2),_gAGroup.getName(3),_gAGroup.getName(4),
		_gBGroup.getName(0),_gBGroup.getName(1),_gBGroup.getName(2),_gBGroup.getName(3),_gBGroup.getName(4),
		_gCGroup.getName(0),_gCGroup.getName(1),_gCGroup.getName(2),_gCGroup.getName(3),_gCGroup.getName(4),
	
	]
	
	var truth = [
			0,
			0,
			0,
			0,
			0
			];
	
	for (var n=0; n<5; n++) {
		truth[n] = 0;
		truth[n] |= (1 << _gC[n]) << 10;
		truth[n] |= (1 << _gB[n]) << 5;
		truth[n] |= (1 << _gA[n]);	
	}
	
	var _test = ds_list_create();
	
		ds_list_clear(_list);

	var start = bin_to_dec("00000_00000_11111");
	var stop = bin_to_dec("1_00000_00000_00000"); // overflow

	// Permute every posible 15-bit number with five bits set
	var n = start;
	while (n < stop) {
		// Validate there are bits set within each of the three groups
		if (bitcount(n & 31744) > 0) { // 0b11111_00000_00000
			if (bitcount(n & 992) > 0) { // 0b00000_11111_00000
				if (bitcount(n & 31) > 0) { // 0b00000_00000_11111
					// Compare clue to each true statement and reject it
					// if two (or more) correlated factors are present
					var ok = true;
					for (var i=0; i<array_length(_truth); i++) {
						if (bitcount(n & _truth[i]) > 1) {
							ok = false;
						}
					}
					if (ok) {
						ds_list_add(_list, n);
					}
				}
			}
		}
		n = next(n);
	}
	
	for(var i = 0; i < ds_list_size(_test); i++){
		//show_debug_message(string(_test[| i]));	
		//Somehow convert this to names?
		//for (var i=0; i<array_length(truth); i++) {
		var msg = "five are ";
			var n = _test[| i];
			var j = 0;
			while (n > 0) {
				if (n & 1) {
					msg += names[j] + " ";
				}
				n = n >> 1;
				j++;
			}
			//show_debug_message(msg);
			//Parse it
			var _parsed = ParseRuleText(msg);
			//Generate the rule
			var _rule = new Rule(_parsed);
			//Add it to the list
			//ds_list_add(obj_Master.rules,_rule);
			AddRuleSafe(_rulesList,_rule);
			//Destroy this list
				
		//}
	}
	ds_list_destroy(_test);
}

function GenerateMultiRule(_rulesList){
	//THis is the big one.  We have 5 entities
	//Each entity must be unique
	//Each entity is negative to each other entity
	var _entiityList = ds_list_create();
	//var _badGroups = 0;
	//var _badCombos = 0;
	//var _rulesGen = 0;
	//var _rulesDupes = 0;
//	var _time = current_time;
	
	//var _tempRules = ds_list_create();
	
	for(var a = 0; a < ds_list_size(obj_Master.keywords) ;a++){
		var _a = obj_Master.keywords[| a];
		
		for(var b = 0; b < ds_list_size(obj_Master.keywords) ;b++){
			var _b = obj_Master.keywords[| b];
			if(_b == _a || GetState(_b,_a) == 2){
//				_badCombos +=1;
				continue;	
			}
			
			
			for(var c = 0; c < ds_list_size(obj_Master.keywords) ;c++){
				var _c = obj_Master.keywords[| c];
				if(_c == _a || GetState(_c,_a) == 2){
//					_badCombos +=1;
					continue;	
				}
				if(_c == _b || GetState(_c,_b) == 2){
//					_badCombos +=1;
					continue;	
				}
				
				
				
				for(var d = 0; d < ds_list_size(obj_Master.keywords) ;d++){
					var _d = obj_Master.keywords[| d];
					if(_d == _a || GetState(_d,_a) == 2){
//						_badCombos +=1;
					continue;	
					}
					if(_d == _b || GetState(_d,_b) == 2){
//						_badCombos +=1;
						continue;	
					}
					if(_d == _c || GetState(_d,_c) == 2){
//						_badCombos +=1;
						continue;	
					}
					
					
					
					for(var e = 0; e < ds_list_size(obj_Master.keywords) ;e++){
						var _e = obj_Master.keywords[| e];
						if(_e == _a || GetState(_e,_a) == 2){
//							_badCombos +=1;
						continue;	
						}
						if(_e == _b || GetState(_e,_b) == 2){
//							_badCombos +=1;
							continue;	
						}
						if(_e == _c || GetState(_e,_c) == 2){
//							_badCombos +=1;
							continue;	
						}
						if(_e == _d || GetState(_e,_d) == 2){
//							_badCombos +=1;
							continue;	
						}
												
						//We made it this far and everything is not fucking broken.
						ds_list_add(_entiityList,_a,_b,_c,_d,_e)
						
						
						
						
						//Shuffle this shit up
						ds_list_shuffle(_entiityList);
						
						//Create the string!
						var _string = "five are " + _entiityList[| 0] + " "+ _entiityList[| 1] + " "+ _entiityList[| 2] + " "+ _entiityList[| 3] + " "+ _entiityList[| 4];
						
						//Groups check
						var _groups = ds_list_create()
						
						for(var p = 0; p < ds_list_size(_entiityList); p++){
							var _g = FindGroup(_entiityList[| p]);
							if(ds_list_find_index(_groups,_g) == -1){
								ds_list_add(_groups,_g);	
							}
						}
						if(ds_list_size(_groups) != 3){
							//show_debug_message("Not enough groups represented in " + _string);
							ds_list_destroy(_groups);
							ds_list_clear(_entiityList);
//							_badGroups += 1;
							continue;
						}
						ds_list_destroy(_groups);
						
						
						//Parse it
						
						var _parsed = ParseRuleText(_string);
						//Generate the rule
						var _rule = new Rule(_parsed);
						//Add it to the list
						//ds_list_add(obj_Master.rules,_rule);
						//var new_rule = true;
						//for(var t = 0; t < ds_list_size(_tempRules); t++){
						//	var _eRule = _tempRules[| t];
							
							
						//	if(ds_list_find_index(_eRule.ruleText,_entiityList[| 0]) != -1 &&
						//	ds_list_find_index(_eRule.ruleText,_entiityList[| 1]) != -1 &&
						//	ds_list_find_index(_eRule.ruleText,_entiityList[| 2]) != -1 &&
						//	ds_list_find_index(_eRule.ruleText,_entiityList[| 3]) != -1 &&
						//	ds_list_find_index(_eRule.ruleText,_entiityList[| 4]) != -1){
								
						//		new_rule = false;
						//		break;
						//		}
							
						//}
						//if(new_rule){
						//ds_list_add(obj_Master.rules,_rule);
						AddRuleSafe(_rulesList,_rule);
//						_rulesGen += 1;
						//}else{
						//	_rulesDupes += 1;	
						//}
						//Clear the list for the next loop...
						ds_list_clear(_entiityList);
						
					}
				}
			}
		}
	}
	//Before we're done lets destroy the list
	ds_list_destroy(_entiityList);
//	var _timeTaken = string(current_time - _time) + "ms"
//	show_debug_message("Time Taken " + _timeTaken + " Rules Generated = " + string(_rulesGen) + " Bad Combos = " + string(_badCombos) + " Bad Groups = " + string(_badGroups)+ " Dupe Rules = " + string(_rulesDupes));
}

function GeneratePairRules(_rulesList){
	//This is the one that creates pairs
	//Pairs area done in this formati:
	//Of A and B, one is C and the other is D
	//A == C(or D) and B == D(or C).
	
	//Gameplan is to get A, B by iterating all keywords.  If they're not the same, they are valid.
	//Then, we get Positive mathes for A, and Positive matches for B.
	//We put em together, in every combination.
	
	//First we get our A, B variables.
	for(var a = 0; a < ds_list_size(obj_Master.keywords); a++){
		for(var b = 0; b < ds_list_size(obj_Master.keywords); b++){
			//Set our variables.
			var _a = obj_Master.keywords[| a];
			var _b = obj_Master.keywords[| b];
			
			//Get out if they're the same thing, thatas useless to me.
			if(_a == _b){
				continue;	
			}
			
			//Get positive relationships for A & B
			var _aPos = FindPositiveRelations(_a);
			var _bPos = FindPositiveRelations(_b);
			
			//Now we make every possible combination...
			for(var c = 0; c < ds_list_size(_aPos); c++){
					var _c = _aPos[| c];
					if(_a == _c){
						continue;	
					}
					if(_b == _c){
						continue;	
					}
					
					if(FindGroup(_a) == FindGroup(_c)){
						continue;	
					}
					if(FindGroup(_b) == FindGroup(_c)){
						continue;	
					}
				for(var d = 0; d < ds_list_size(_bPos); d++){
					//Get my variables...
					
					var _d = _bPos[| d];
					
					//If they're the same? I guess possible
					if(_c == _d){
						continue;	
					}
					if(_a == _d){
						continue;	
					}
					if(_b == _d){
						continue;	
					}
					
					if(FindGroup(_a) == FindGroup(_d)){
						continue;	
					}
					if(FindGroup(_b) == FindGroup(_d)){
						continue;
					}
					//This weirdo one...
					
					
					//Make some lists
					var _left = ds_list_create();
					var _right = ds_list_create();
					
					ds_list_add(_left, _a,_b);
					ds_list_add(_right, _c,_d);
					
					//Shuffle some stuff.
					ds_list_shuffle(_left);
					ds_list_shuffle(_right);
					
					//Then our favorite part...
					
					//Create the string!
					var _string = "of " + _left[| 0] + " and " + _left[| 1] + " , one " + _right[| 0] + " and the other " + _right[| 1];
					//Parse it
					var _parsed = ParseRuleText(_string);
					//Generate the rule
					var _rule = new Rule(_parsed);
					//Add it to the list
					//ds_list_add(obj_Master.rules,_rule);
					AddRuleSafe(_rulesList,_rule);
					//Destroy this list
					ds_list_destroy(_left);
					ds_list_destroy(_right);
				}
			}
		
			ds_list_destroy(_aPos);
			ds_list_destroy(_bPos);
		}
		
	}
}

function GenerateValueRules(_rulesList){
	//These are the ones, that work on the concept of before or after.  Less or more.
	//A is before B.
	//In the group that is a value, A is going to be before B.
	//And we also know, that if possible, A cannot equal B.
	//In this case, or the criteria of our current parsing solution, we also have to include the group name for some reason.
	
	//We can likely do this, with the current setup, to get the value of the numbered category
	//Actually, forget it, we can find it using other methods, to future proof
	
	//New note.  I realized after this that I am only parsing when I know ow many STEPS there are
	//Betewwen A and B.  So I added the value of the number of steps.
	//However, I should probably in the future make sure the parsing can deal with NOT having a value
	//And then also update this so that I don't include the steps
	//And keep it more vague.
	
	
	
	//First, we find the groups that are the "value" groups.
	//This is the old method:
	//var _vGroup =_numGroup;
	//New method that allows for multiple value groups:
	var _vGroups = ds_list_create();
	for(var i = 0; i < ds_list_size(obj_Master.groups); i ++){
		var _a = obj_Master.groups[| i];
		if(_a.value){
			ds_list_add(_vGroups,_a);
		}
	}
	
	//Now that we have our value groups, we can iterate on them.
	for(var i = 0; i < ds_list_size(_vGroups); i++){
		//And now we're kkinda back to the old method.
		var _vGroup = _vGroups[| i];
		
		//We know, this group has 5 items.  For any given one, there are x before and y after where x+y == 4;
		
		for(var j = 0; j < 5; j++){
			//Wwe do another round
			var _curName = _vGroup.getName(j);
			for(var k = 0; k < 5; k++){
				//OK I gotta fix this fuck up
				
				//We gotta find all the positive relations for this year
				var _yPosRel = FindPositiveRelations(_curName);
				
				//Then we iterate on those positive relations
				for(var ii = 0; ii < ds_list_size(_yPosRel); ii++){
					//Get the NAME of the POSITIVE relation of the Item in the group
					var _yPosRelName = _yPosRel[| ii];
					
					//Now that we're here, and we have to check how far it is before, or after, the value
					//Then the CLUE has to give the relation to the positive relation of the value
					//And not the fuking actual value WTF was I thinking.
					if(k < j){
						//Before
						//Get the name of the before item
						var _bName = _vGroup.getName(k)
						//Get all the positive relations
						var _pRel = FindPositiveRelations(_bName);
						//Iteratate on the positive relations
						//There should really only be 2, but could be more in bigger grids
						for(var l = 0; l < ds_list_size(_pRel); l++){
							//Get the positive relation name
							var _relName = _pRel[| l];				
							//Now we make our string for parsing...
							var _string = _relName + " " + string(j-k) + " " +  _vGroup.named+ " before " + _yPosRelName;
							//Parse it
							var _parsed = ParseRuleText(_string)
							//Generate the rule?
							var _rule = new Rule(_parsed);
							//Add it to the list
							//ds_list_add(obj_Master.rules,_rule);
							AddRuleSafe(_rulesList,_rule);
						}
						ds_list_destroy(_pRel);					
					}else if(k == j){
						//Same, we continue;
						continue;	
					}else{
						//All thats left is after!
						//Get the name of the after item
						var _aName = _vGroup.getName(k)
						//Get all the positive relations
						var _pRel = FindPositiveRelations(_aName);
						//Iteratate on the positive relations
						//There should really only be 2, but could be more in bigger grids
						for(var l = 0; l < ds_list_size(_pRel); l++){
							//Get the positive relation name
							var _relName = _pRel[| l];						
							//Now we make our string for parsing...
							var _string = _relName + " " + string(k-j)+ " " + _vGroup.named+ " after " + _yPosRelName;
							//Parse it
							var _parsed = ParseRuleText(_string)
							//Generate the rule?
							var _rule = new Rule(_parsed);
							//Add it to the list
							//ds_list_add(obj_Master.rules,_rule);
							AddRuleSafe(_rulesList,_rule);
						}
						ds_list_destroy(_pRel);
					}	
				}
				ds_list_destroy(_yPosRel);
			}
		}
	}
	//Delete this list at the end.
	ds_list_destroy(_vGroups);
}


