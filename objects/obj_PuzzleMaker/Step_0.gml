/// @description Insert description here
// You can write your code in this editor



if(!groupsSetup){
	//Determine if we need a name group
	var _nameGroup = irandom(1);
	
	//Make my variable
	var _t = ds_list_create();
	
	if(_nameGroup){
		//Copy name groups
		ds_list_copy(_t,obj_Master.nameGroups);
		ds_list_shuffle(_t);
		//Pick one
		var _ng = _t[|0];
		//Add the keywords
		_ng.AddKeywords();
		//Add the group to the list
		ds_list_add(obj_Master.groups,_ng);
		_nameGroup = true;
	}
	
	
	//Pick a stuff group(s)
	
	//Clear _t
	
	ds_list_clear(_t);
	//Shuffle the list
	ds_list_copy(_t,obj_Master.stuffGroups);
	ds_list_shuffle(_t);
	
	//How many stuff groups we have to pick
	//Start with 1 for sure
	var _numToPick = 1;
	//If no name group, 1 more.
	if(!_nameGroup){
		_numToPick++;	
	}
	
	//Here is the logic for if we have a medium puzzle or a hard puzzle
	//We add 1 for medium (4 groups) or 2 for hard (5 groups)
	
	
	//Iterate through this
	for(var i = 0; i < _numToPick; i++){
		var _sg = _t[| i];
		_sg.AddKeywords();
		ds_list_add(obj_Master.groups,_sg);
	}
	//Clear the variable
	ds_list_clear(_t);
	
	
	//Pick a single value group
	
	ds_list_copy(_t,obj_Master.valueGroups);
	
	ds_list_shuffle(_t);
	//Pick one
	var _vg = _t[|0];
	//Add the keywords
	_vg.AddKeywords();
	//Add the group to the list
	ds_list_add(obj_Master.groups,_vg);
	
	//Got to the end, we destroy it
	ds_list_destroy(_t);
	//Now we setup the grid for the obj_Master
	obj_Master.puzzleGrid = CreatePuzzleGrid();
	groupsSetup = true;
	array_push(displayText,"Choosing Random Variables - Complete");
	exit;
}

//First we generate a puzzle solution;

if(!puzzleGenerated){
		
	solution = GeneratePuzzleSolution();
	puzzleGenerated = true;	
	array_push(displayText,"Generating Puzzle Solution - Complete");
	exit;
}


//Then we generate all available clues
if(!cluesGenerated){
	
	var _T = current_time;
	var _TimeTaken = 0;
	if(!subStepInProgress){
		//Reset iterators
		_i = 0;
		_j = 0;
		_iterationCount = 0;
	}
	switch(subStep){
		case 0:
		//Format will be along the lines of :
		//Name1 is Name2
		//var _tempRuleList = ds_list_create();
		//Can actually probably utilize some of the helper functions already created.
		//Lets do this simply, and then, more difficulty.
		
		//Set this substep in progress
		if(subStepInProgress = false){
			subStepInProgress = true;
			debugText = "Generating all True clues";
			array_push(displayText,"Generating True Clues...");
		}
		//Go through all the keywords
		while(_i < ds_list_size(obj_Master.keywords) && _TimeTaken <= 5){
		//for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
			//Get the keyword
			var _kw = obj_Master.keywords[| _i];
		
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
				ds_list_add(allClues,_rule);
			}
			//Finished with this KW, destroy the list
			ds_list_destroy(_posRel);
			_TimeTaken = current_time - _T;
			_i++;
		}
		if(_i >= ds_list_size(obj_Master.keywords)){
			//show_debug_message("Completed True Clue gen in " + string(_iterationCount+1) + " iterations");
			displayText[array_length(displayText)-1] = "Generating True Clues - Complete";
			subStep += 1;
			subStepInProgress = false;
			//show_debug_message(string(_TimeTaken));
		}else{
			_iterationCount++;
			//show_debug_message(string(_TimeTaken));
		}
		//GenerateTrueRules(allClues);
		exit;
		break;
		case 1:
		//Format will be along the lines of :
		//Name1 is not Name2
		//var _tempRuleList = ds_list_create();
		//Can actually probably utilize some of the helper functions already created.
		//Lets do this simply, and then, more difficulty.
		
		//Set our stuff
		if(subStepInProgress = false){
			subStepInProgress = true;
			debugText = "Generating all False clues";
			array_push(displayText,"Generating False Clues...");
		}
	
		//Go through all the keywords
		while(_i < ds_list_size(obj_Master.keywords) && _TimeTaken <= 5){
		//for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
			//Get the keyword
			var _kw = obj_Master.keywords[| _i];
		
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
				ds_list_add(allClues,_rule);
			}
			//Finished with this KW, destroy the list
			ds_list_destroy(_negRel);
			_TimeTaken = current_time - _T;
			_i++;
		}
		if(_i >= ds_list_size(obj_Master.keywords)){
			//show_debug_message("Completed false Clue gen in " + string(_iterationCount+1) + " iterations");
			displayText[array_length(displayText)-1] = "Generating False Clues - Complete";
			subStep += 1;
			subStepInProgress = false;
			//show_debug_message(string(_TimeTaken));
		}else{
			_iterationCount++;
			//show_debug_message(string(_TimeTaken));
		}
		//GenerateFalseRules(allClues);
		exit;
		break;
		case 2:
		//Either or clues show up in this format:
		//Name1 was either A or B
		//One of em is a true relationship
		//The other is a false relationship
	
		//The trick here, the A cannot be equal to B.  I think this is implicit already?
	
		//So, we take a Key word, find all the true relationships, find all the negative relationships.
	
		
		//Set our stuff
		if(!subStepInProgress){
			subStepInProgress = true;
			debugText = "Generating all Either Or clues";
			array_push(displayText,"Generating Either / Or Clues...");
		}
		//Go through all the keywords
		while(_i < ds_list_size(obj_Master.keywords) && _TimeTaken <= 5){
		//for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
			//Get the keyword
			var _kw = obj_Master.keywords[| _i];
		
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
					ds_list_add(allClues,_rule);
					//Destroy this list
					ds_list_destroy(_boo);
				}
			}
			//Finished with this KW, destroy the lists
			ds_list_destroy(_posRel);
			ds_list_destroy(_negRel);
			
			_TimeTaken = current_time - _T;
			_i++;
		}
		//GenerateEitherOrRules(allClues);
		if(_i >= ds_list_size(obj_Master.keywords)){
			//show_debug_message("Completed Either Or Clue gen in " + string(_iterationCount+1) + " iterations");
			displayText[array_length(displayText)-1] = "Generating Either / Or Clues - Complete";
			subStep += 1;
			subStepInProgress = false;
			//show_debug_message(string(_TimeTaken));
		}else{
			_iterationCount++;
			//show_debug_message(string(_TimeTaken));
		}
		exit;
		break;
		case 3:
		//Either or clues show up in this format:
		//Name1 neither A nor B
		//They are both negative relationships (name1 != A, and name1 != B)
		//And importantly, A != B
	
		//So, we take a Key word, find all the true relationships, find all the negative relationships.
	
		//Set our stuff
		if(!subStepInProgress){
			
			subStepInProgress = true;
			debugText = "Generating all Neither Nor clues";
			array_push(displayText,"Generating Neither / Nor Clues...");
		}
		//Go through all the keywords
		while(_i < ds_list_size(obj_Master.keywords) && _TimeTaken <= 5){
		//for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
			//Get the keyword
			var _kw = obj_Master.keywords[| _i];
		
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
					ds_list_add(allClues,_rule);
					//Destroy this list
					ds_list_destroy(_boo);
				}
			
			}
			//Finished with this KW, destroy the list
			ds_list_destroy(_negRel);
			
			_TimeTaken = current_time - _T;
			_i++;
		}
		
		//GenerateNeitherNorRules(allClues);
		if(_i >= ds_list_size(obj_Master.keywords)){
			//show_debug_message("Completed Neither Nor Clue gen in " + string(_iterationCount+1) + " iterations");
			displayText[array_length(displayText)-1] = "Generating Neither / Nor Clues - Complete";
			subStep += 1;
			subStepInProgress = false;
			//show_debug_message(string(_TimeTaken));
		}else{
			_iterationCount++;
			//show_debug_message(string(_TimeTaken));
		}
		exit;
		break;
		
		/*
		case 4:
		//This is gonna be a tough one, multi rules
		
		if(!subStepInProgress){
			//var _solution = obj_PuzzleMaker.solution;
			array_push(displayText,"Generating Multi Clues...");
			_gA = [0,0,0,0,0];
			_gAGroup = FindGroup(solution[0][0]);
			_gB = [0,0,0,0,0];
			_gBGroup = FindGroup(solution[0][1]);
			_gC = [0,0,0,0,0];
			_gCGroup = FindGroup(solution[0][2]);
	
			for(var i = 0; i < array_length(solution);i++){
				_gA[i] = _gAGroup.getNum(solution[i][0]);	
				_gB[i] = _gBGroup.getNum(solution[i][1]);
				_gC[i] = _gCGroup.getNum(solution[i][2]);
			}
	
			_names = [
				_gAGroup.getName(0),_gAGroup.getName(1),_gAGroup.getName(2),_gAGroup.getName(3),_gAGroup.getName(4),
				_gBGroup.getName(0),_gBGroup.getName(1),_gBGroup.getName(2),_gBGroup.getName(3),_gBGroup.getName(4),
				_gCGroup.getName(0),_gCGroup.getName(1),_gCGroup.getName(2),_gCGroup.getName(3),_gCGroup.getName(4),
	
			]
	
			_truth = [
					0,
					0,
					0,
					0,
					0
					];
	
			for (var n=0; n<5; n++) {
				_truth[n] = 0;
				_truth[n] |= (1 << _gC[n]) << 10;
				_truth[n] |= (1 << _gB[n]) << 5;
				_truth[n] |= (1 << _gA[n]);	
			}
	
			_tempList = ds_list_create();

			_n = bin_to_dec("00000_00000_11111");
			_stop = bin_to_dec("1_00000_00000_00000"); // overflow
			
			//Setup our stuff
			subStepInProgress = true;
			debugText = "Generating all Multi Clues";
		}
		
		// Permute every posible 15-bit number with five bits set
		
		while (_n < _stop && _TimeTaken <= 5) {
			// Validate there are bits set within each of the three groups
			if (bitcount(_n & 31744) > 0) { // 0b11111_00000_00000
				if (bitcount(_n & 992) > 0) { // 0b00000_11111_00000
					if (bitcount(_n & 31) > 0) { // 0b00000_00000_11111
						// Compare clue to each true statement and reject it
						// if two (or more) correlated factors are present
						var ok = true;
						for (var i=0; i<array_length(_truth); i++) {
							if (bitcount(_n & _truth[i]) > 1) {
								ok = false;
							}
						}
						if (ok) {
							ds_list_add(_tempList, _n);
						}
					}
				}
			}
			_n = next(_n);
			_TimeTaken = current_time - _T;
		}
		if(_n < _stop){
			_iterationCount++;
			//show_debug_message("Huzzah!");
			exit;
		}
		
		
		while(_i < ds_list_size(_tempList) && _TimeTaken <= 5){
		//for(var i = 0; i < ds_list_size(_test); i++){
			//show_debug_message(string(_test[| i]));	
			//Somehow convert this to names?
			//for (var i=0; i<array_length(truth); i++) {
			
			var _entityList = ds_list_create();
			var n = _tempList[| _i];
			var j = 0;
			while (n > 0) {
				if (n & 1) {
					ds_list_add(_entityList,_names[j]);
				}
				n = n >> 1;
				j++;
			}
			//show_debug_message(msg);
			
			//Shuffle the lsit
			ds_list_shuffle(_entityList);
			
			//Make my string
			var _string = "five are " + _entityList[| 0] + " "+ _entityList[| 1] + " "+ _entityList[| 2] + " "+ _entityList[| 3] + " "+ _entityList[| 4];
			
			//Parse it
			var _parsed = ParseRuleText(_string);
			//Generate the rule
			var _rule = new Rule(_parsed);
			//Add it to the list
			//ds_list_add(obj_Master.rules,_rule);
			ds_list_add(allClues,_rule);
			//Destroy this list
			ds_list_destroy(_entityList);
			//}
		_i++;
		_TimeTaken = current_time - _T;
		}
		
		if(_i >= ds_list_size(_tempList)){
			//show_debug_message("Completed Multi Clue gen in " + string(_iterationCount+1) + " iterations");
			displayText[array_length(displayText)-1] = "Generating Multi Clues - Complete";
			subStep += 1;
			subStepInProgress = false;
			ds_list_destroy(_tempList);
			//show_debug_message(string(_TimeTaken));
		}else{
			_iterationCount++;
			//show_debug_message(string(_TimeTaken));
		}
		
		//GenerateMultiRuleAlt(allClues);
		
		exit;
		break;
		
		*/
		
		case 4:
		//This is gonna be a tough one, multi rules
		
		if(!subStepInProgress) {
			//var _solution = obj_PuzzleMaker.solution;
			array_push(displayText,"Generating Multi Clues...");
            
            
			////_gA = [0,0,0,0,0];
			////_gAGroup = FindGroup(solution[0][0]);
			////_gB = [0,0,0,0,0];
			////_gBGroup = FindGroup(solution[0][1]);
			////_gC = [0,0,0,0,0];
			////_gCGroup = FindGroup(solution[0][2]);
            
			////for(var i = 0; i < array_length(solution);i++){
			////	_gA[i] = _gAGroup.getNum(solution[i][0]);	
			////	_gB[i] = _gBGroup.getNum(solution[i][1]);
			////	_gC[i] = _gCGroup.getNum(solution[i][2]);
			////}
	        
            _lengthOfGroup = array_length(solution);
            _numberOfGroups = 3;
            _gNumber = array_create(_numberOfGroups);
            _gGroups = array_create(_numberOfGroups);
            for (var i=0; i<_numberOfGroups; i++) {
                _gNumber[i] = array_create(_lengthOfGroup);
                _gGroups[i] = FindGroup(solution[0][i]);
            }
            
            for (var i=0; i<_numberOfGroups; i++) {
                for (var j=0; j<_lengthOfGroup; j++) {
                    _gNumber[i][j] = _gGroups[i].getNum(solution[j][i]);
                }
            }
	
            
			////_names = [
			////	_gAGroup.getName(0),_gAGroup.getName(1),_gAGroup.getName(2),_gAGroup.getName(3),_gAGroup.getName(4),
			////	_gBGroup.getName(0),_gBGroup.getName(1),_gBGroup.getName(2),_gBGroup.getName(3),_gBGroup.getName(4),
			////	_gCGroup.getName(0),_gCGroup.getName(1),_gCGroup.getName(2),_gCGroup.getName(3),_gCGroup.getName(4),
			////]
            
            _names = array_create(_numberOfGroups * _lengthOfGroup);
            for (var i=0; i<_numberOfGroups; i++) {
                for (var j=0; j<_lengthOfGroup; j++) {
                    _names[5*i+j] = _gGroups[i].getName(j);
                }
            }
	
			////_truth = [
			////		0,
			////		0,
			////		0,
			////		0,
			////		0
			////		];
	
			////for (var n=0; n<5; n++) {
			////	_truth[n] = 0;
			////	_truth[n] |= (1 << _gC[n]) << 10;
			////	_truth[n] |= (1 << _gB[n]) << 5;
			////	_truth[n] |= (1 << _gA[n]);	
			////}
            
            _truth = array_create(_lengthOfGroup);
            for (var n=0; n<_lengthOfGroup; n++) {
                _truth[n] = 0;
                for (var i=0; i<_numberOfGroups; i++) {
                    _truth[n] |= (1 << _gNumber[i][n]) << (_lengthOfGroup * i);
                }
            }
            
            
			_tempList = ds_list_create();

			////_n = bin_to_dec("00000_00000_11111");
			////_stop = bin_to_dec("1_00000_00000_00000"); // overflow
			
            _start = (1 << _lengthOfGroup) - 1;
            _stop = 1 << (_lengthOfGroup * _numberOfGroups); // overflow
            _n = _start;
            
			//Setup our stuff
			subStepInProgress = true;
			debugText = "Generating all Multi Clues";
		}
		
		//// Permute every posible 15-bit number with five bits set
		// Permute every possible N-bit number with _lengthOfGroup bits set
		// where N = _numberOfGroups * _lengthOfGroup
		
		while (_n < _stop && _TimeTaken <= 5) {
            
            
			////// Validate there are bits set within each of the three groups
			////if (bitcount(_n & 31744) > 0) { // 0b11111_00000_00000
			////	if (bitcount(_n & 992) > 0) { // 0b00000_11111_00000
			////		if (bitcount(_n & 31) > 0) { // 0b00000_00000_11111
			////			// Compare clue to each true statement and reject it
			////			// if two (or more) correlated factors are present
			////			var ok = true;
			////			for (var i=0; i<array_length(_truth); i++) {
			////				if (bitcount(_n & _truth[i]) > 1) {
			////					ok = false;
			////				}
			////			}
			////			if (ok) {
			////				ds_list_add(_tempList, _n);
			////			}
			////		}
			////	}
			////}
            
            // Validate there are bits set within each of the groups
            var _count = 0;
            for (var i=0; i<_numberOfGroups; i++) {
                if (bitcount(_n & (_start << (_lengthOfGroup * i)))) {
                    _count++;
                }
            }
            if (_count == _numberOfGroups) {
    			// Compare clue to each true statement and reject it
    			// if two (or more) correlated factors are present
    			var ok = true;
    			for (var i=0; i<array_length(_truth); i++) {
    				if (bitcount(_n & _truth[i]) > 1) {
    					ok = false;
    				}
    			}
    			if (ok) {
    				ds_list_add(_tempList, _n);
				}
            }
            
            
            
			_n = next(_n);
			_TimeTaken = current_time - _T;
		}
		if(_n < _stop){
			_iterationCount++;
			//show_debug_message("Huzzah!");
			exit;
		}
		
		
		while(_i < ds_list_size(_tempList) && _TimeTaken <= 5){
		//for(var i = 0; i < ds_list_size(_test); i++){
			//show_debug_message(string(_test[| i]));	
			//Somehow convert this to names?
			//for (var i=0; i<array_length(truth); i++) {
			
			var _entityList = ds_list_create();
			var n = _tempList[| _i];
			var j = 0;
			while (n > 0) {
				if (n & 1) {
					ds_list_add(_entityList,_names[j]);
				}
				n = n >> 1;
				j++;
			}
			//show_debug_message(msg);
			
			//Shuffle the lsit
			ds_list_shuffle(_entityList);
			
            
            
			//////Make my string
			////var _string = "five are " + _entityList[| 0] + " "+ _entityList[| 1] + " "+ _entityList[| 2] + " "+ _entityList[| 3] + " "+ _entityList[| 4];

            //Make my string
            var _entityLength = ds_list_size(_entityList);
            var _numberNames = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
            var _string = _numberNames[_entityLength];
            _string += " are ";
            for (var i=0; i<_entityLength; i++) {
                if (i > 0) _string += " ";
                _string += _entityList[| i];
            }
            
            
            
			//Parse it
			var _parsed = ParseRuleText(_string);
			//Generate the rule
			var _rule = new Rule(_parsed);
			//Add it to the list
			//ds_list_add(obj_Master.rules,_rule);
			ds_list_add(allClues,_rule);
			//Destroy this list
			ds_list_destroy(_entityList);
			//}
		_i++;
		_TimeTaken = current_time - _T;
		}
		
		if(_i >= ds_list_size(_tempList)){
			//show_debug_message("Completed Multi Clue gen in " + string(_iterationCount+1) + " iterations");
			displayText[array_length(displayText)-1] = "Generating Multi Clues - Complete";
			subStep += 1;
			subStepInProgress = false;
			ds_list_destroy(_tempList);
			//show_debug_message(string(_TimeTaken));
		}else{
			_iterationCount++;
			//show_debug_message(string(_TimeTaken));
		}
		
		//GenerateMultiRuleAlt(allClues);
		
		exit;
		break;

		
		
		case 5:
			//This is the one that creates pairs
			//Pairs area done in this formati:
			//Of A and B, one is C and the other is D
			//A == C(or D) and B == D(or C).
	
			//Gameplan is to get A, B by iterating all keywords.  If they're not the same, they are valid.
			//Then, we get Positive mathes for A, and Positive matches for B.
			//We put em together, in every combination.
	
			//First we get our A, B variables.
			if(!subStepInProgress){			
				subStepInProgress = true;
				debugText = "Generating all Pair clues";
				array_push(displayText,"Generating Pair Clues...");
			}
			//Go through all the keywords
			while(_i < ds_list_size(obj_Master.keywords) && _TimeTaken <= 5){
			//for(var a = 0; a < ds_list_size(obj_Master.keywords); a++){
				for(var b = 0; b < ds_list_size(obj_Master.keywords); b++){
					//Set our variables.
					var _a = obj_Master.keywords[| _i];
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
							ds_list_add(allClues,_rule);
							//Destroy this list
							ds_list_destroy(_left);
							ds_list_destroy(_right);
						}
					}
		
					ds_list_destroy(_aPos);
					ds_list_destroy(_bPos);
				}
			_i++;
			_TimeTaken = current_time - _T;
			
			}
		
		if(_i >= ds_list_size(obj_Master.keywords)){
			//show_debug_message("Completed Pair Clue gen in " + string(_iterationCount+1) + " iterations");
			displayText[array_length(displayText)-1] = "Generating Pair Clues - Complete";
			subStep += 1;
			subStepInProgress = false;
			//show_debug_message(string(_TimeTaken));
		}else{
			_iterationCount++;
			//show_debug_message(string(_TimeTaken));
		}
		//GeneratePairRules(allClues);
		exit;
		break;
		case 6:
			
		
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
			//var _vGroups = ds_list_create();
			if(!subStepInProgress){
				debugText = "Generating Value Clues";
				array_push(displayText,"Generating Value Clues...");
				_valueGroup = -4;
				for(var i = 0; i < ds_list_size(obj_Master.groups); i ++){
					var _a = obj_Master.groups[| i];
					if(_a.value){
						_valueGroup = _a;
					}
				}
			subStepInProgress = true;
			}
	
			//Now that we have our value groups, we can iterate on them.
			//for(var i = 0; i < ds_list_size(_vGroups); i++){
				//And now we're kkinda back to the old method.
				var _vGroup = _valueGroup;
		
				//We know, this group has 5 items.  For any given one, there are x before and y after where x+y == 4;
		
				if(_i < 5){
				//for(var j = 0; j < 5; j++){
					//Wwe do another round
					var _curName = _vGroup.getName(_i);
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
							if(k < _i){
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
									var _string = _relName + " " + string(_i-k) + " " +  _vGroup.named+ " before " + _yPosRelName;
									//Parse it
									var _parsed = ParseRuleText(_string)
									//Generate the rule?
									var _rule = new Rule(_parsed);
									//Add it to the list
									//ds_list_add(obj_Master.rules,_rule);
									ds_list_add(allClues,_rule);
								}
								ds_list_destroy(_pRel);					
							}else if(k == _i){
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
									var _string = _relName + " " + string(k-_i)+ " " + _vGroup.named+ " after " + _yPosRelName;
									//Parse it
									var _parsed = ParseRuleText(_string)
									//Generate the rule?
									var _rule = new Rule(_parsed);
									//Add it to the list
									//ds_list_add(obj_Master.rules,_rule);
									ds_list_add(allClues,_rule);
								}
								ds_list_destroy(_pRel);
							}	
						}
						ds_list_destroy(_yPosRel);
					}
				
				_i++;
				//_TimeTaken = current_time - _T;
				}
			//}
			//Delete this list at the end.
		//GenerateValueRules(allClues);
		if(_i >= 5){
			//show_debug_message("Completed Value Clue gen in " + string(_iterationCount+1) + " iterations");
			displayText[array_length(displayText)-1] = "Generating Value Clues - Complete";
			subStep += 1;
			subStepInProgress = false;
			//show_debug_message(string(_TimeTaken));
		}else{
			_iterationCount++;
			//show_debug_message(string(_TimeTaken));
		}
		exit;
		break;
		case 7:
		
		if(!subStepInProgress){
			subStepInProgress = true;
			debugText = "Cleaning up Clues";
			array_push(displayText,"Cleaning up Clues...");
		}
		//Go through all the keywords
		while(_i < ds_list_size(allClues) && _TimeTaken <= 10){
			AddRuleSafe(allCluesClean,allClues[| _i]);
			_i++;
			_TimeTaken = current_time - _T;
			
		}
		if(_i >= ds_list_size(allClues)){
			//show_debug_message("Completed Clue clean up in " + string(_iterationCount+1) + " iterations");
			displayText[array_length(displayText)-1] = "Cleaning up Clues - Complete";
			subStep = 0;
			subStepInProgress = false;
			//show_debug_message(string(_TimeTaken));
			cluesGenerated = true;
		}else{
			_iterationCount++;
			//show_debug_message(string(_TimeTaken));
		}
		//cluesGenerated = true;
		//subStep = 0;
		//debugText = "All Clues Generated";	
		exit;
		break;
	}
}

if(!rulesGenerated){
	//show_debug_message("Starting frame for Rules generation");
	var _T = current_time;
	var _TimeTaken = 0;
	if(!subStepInProgress){
		_iterationCount = 0;
		_i = 0;
	}
	switch(subStep){
	case 0:
	//Clear all the rules.  Shouldn't always be necessary but doesn't take long.
	ClearRules();
	_TimeTaken = current_time - _T;
	//show_debug_message("Clearing all rules took " + string(_TimeTaken) + "ms");
	subStep++;
	array_push(displayText,"Determining Initial Clues...");
	//show_message("All clean clues are: " + string(ds_list_size(allCluesClean)));
	//show_message("Solution is " + string(solution));
	exit;
	break;
	case 1:
	//
	/*
	if(!subStepInProgress){
		subStepInProgress = true;
		debugText = "Adding new rule";
	}
	
	*/
	//First, we're going to set our priorities
	
	//while(!ValidateWholeBoardComplete() && _TimeTaken < 10){
	//show_debug_message("Grabbing a rule and adding it to the list");
	var _added = false;
	do{
		//show_message("Entering add-rule do");
		var _priorities = ds_priority_create();
		var _rulePriorities = ds_priority_create();
		SetPriorities(_priorities);
		SetRulePriorities(_rulePriorities);
		//So we're going to add a rule, with, the lowest priority.
		do{
		//	show_message("Entering priority do");
			var _desKeyword = ds_priority_find_min(_priorities);
			var _desNotKeyword = ds_priority_find_max(_priorities);
			if(_desKeyword == _desNotKeyword){
				ds_priority_change_priority(_priorities,_desNotKeyword,ds_priority_find_priority(_priorities,_desNotKeyword) + 1);	
			}
		}until (_desKeyword != _desNotKeyword);
		//show_message("exiting priority do");
		var _desType = ds_priority_find_min(_rulePriorities);
		//ds_priority_change_priority(_priorities,_desNotKeyword,ds_priority_find_priority(_priorities,_desNotKeyword) + 1);	
		//ClearAll();  Don't think we need to clear this, since we're not gonna apply right now.
		if(FindGroup(_desKeyword).value){
			if(_desType == "after" || _desType == "before"){
		//		show_message("type is before or after, but the desired keyword is a value type");
				while(_desType == "before" || _desType == "after"){
					ds_priority_change_priority(_rulePriorities,_desType,ds_priority_find_priority(_rulePriorities,_desType) + 1);
					var _desType = ds_priority_find_min(_rulePriorities);
				}
			}
		}
		
		//478919
		
		//show_message("Type of "+ _desType + " and desired keyword was " + _desKeyword + " and avoiding " + _desNotKeyword);
		ds_list_shuffle(allCluesClean);
		for(var i = 0; i < ds_list_size(allCluesClean); i++){
			var _testRule = allCluesClean[| i];
			if(_testRule.ruleType == _desType && ds_list_find_index(_testRule.ruleKeywords,_desKeyword) != -1 && ds_list_find_index(_testRule.ruleKeywords,_desNotKeyword) == -1){
				//AddRuleSafe(rules,_testRule);
				ds_list_add(obj_Master.rules,_testRule);
				//show_debug_message("Type of "+ _desType + " and desired keyword was " + _desKeyword + " and avoiding " + _desNotKeyword + " So we added " + _testRule.ToString());
				_added = true;
				
				//if(_testRule.ruleType == "true" || _testRule.ruleType == "false" || _testRule.ruleType == "multi" || _testRule.ruleType == "neither" || _testRule.ruleType == "either" || _testRule.ruleType == "pair"){
				//show_message("Old : " + _testRule.ToString());
				//show_message("New : " + GeneratePrettyRuleText(_testRule));
				//}
				
				break;
			}
		}
		//show_message("Added is " + string(_added));
		//ApplyRules();
		ds_priority_destroy(_priorities);
		ds_priority_destroy(_rulePriorities);
		_TimeTaken = current_time - _T;
		//show_debug_message("Time taken to get a new rule = " + string(_TimeTaken));
	}until (_added = true);
	//show_message("exiting add-rule do");
	subStep++;
	//show_message(string(ds_list_size(obj_Master.rules)));
	exit;
	break;
	case 2:
		//show_message("entering rule check 1");
		//This will be the rules stuff;
		//show_debug_message("Applying Rules one time");
		if(!subStepInProgress){
			subStepInProgress = true;
			//Starting out, lets clear it all
			//show_debug_message("Clearing Grid");
			ClearAll();
		}
		
		//We're gonna apply 1 rule, per step
		if(_i < ds_list_size(obj_Master.rules)){
			//Get this rule
			var _r = obj_Master.rules[| _i];
			//Apply it
			ApplyRule(_r);
			CheckOtherMatches();
			_TimeTaken = current_time - _T;
			//show_debug_message("Time taken to apply rule " + string(_i) + " = " + string(_TimeTaken));
			_i++;
		}
		
		if(ValidateWholeBoardComplete()){
			//End the substep
			subStepInProgress = false;
			//Move on
			subStep = 4;
			//show_debug_message("We have solved it in one go around!");
			exit;
		}
		//Should only hit this if we're not solved it but also ran out of rules
		if(_i >= ds_list_size(obj_Master.rules)){
			subStepInProgress = false;
			subStep++;
		}
		
		
	exit;
	break;
	case 3:
		//show_message("entering rule check 2");
		//This will be the rules stuff;
		//show_debug_message("Applying Rules second time");
		if(!subStepInProgress){
			subStepInProgress = true;
			//Starting out, lets clear it all
		}
		
		//We're gonna apply 1 rule, per step
		if(_i < ds_list_size(obj_Master.rules)){
			//Get this rule
			var _r = obj_Master.rules[| _i];
			//Apply it
			ApplyRule(_r);
			CheckOtherMatches();
			_TimeTaken = current_time - _T;
			//show_debug_message("Time taken to apply rule " + string(_i) + " = " + string(_TimeTaken));
			_i++;
		}
		if(_i >= ds_list_size(obj_Master.rules)){
			//We got to the end, end this substep
			subStepInProgress = false;
			//If its still not complete, go back to add another rule
			if(!ValidateWholeBoardComplete()){
				//show_debug_message("Did not solve it, going back to add another rule");
				subStep=1;
				exit;
				
			}
		}
		//If we got here, we haven't gone through all the rules a second time, but, we may be complete!
		if(ValidateWholeBoardComplete()){
			//End the substep
			subStepInProgress = false;
			//Move on
			subStep++;
			//show_debug_message("We have solved it!");
		}
	exit;
	break;
	case 4:
	
	if(!removalStep){
		//show_debug_message("Doing initial setup for removal step");
		displayText[array_length(displayText)-1] = "Determining Initial Clues - Complete";
		array_push(displayText,"Removing Superfluous Clues - In Progress");
		//Make a new list
		_listCopy = ds_list_create();
		//Copy the rules list
		ds_list_copy(_listCopy,obj_Master.rules);
		removalStep = true;
		//Set our iteration variable;
		_j = 0;
		
	}
	if(_j < ds_list_size(_listCopy)){
	//for(var i = 0; i < ds_list_size(_listCopy); i++){
		//Make a copy of this rule
		_removedRule = _listCopy[| _j];
		//Get the index of the removed rule
		var _index = ds_list_find_index(obj_Master.rules,_removedRule);
		//Remove the rule if it is there.
		if(_index != -4){
			ds_list_delete(obj_Master.rules,_index);
		}
		
		//show_debug_message("Attempting a removal of rule " + string(_j));
		//We've now removed this rule, we go onto the next step(s)
		//Which will be to re-run the rules twice.
		subStep = 5;
		//Iterate this for next time this function is hit
		_j++;
	}else{
		//show_debug_message("Got through all the rules for removal check");	
		//Clean up lsit
		ds_list_destroy(_listCopy);
		_removedRule = -4;
		removalStep = false;
		subStep = 7;
	}
	
	exit;
	break;
	
	case 5:
		
		//This will be the rules stuff;
		//show_debug_message("Applying Rules one time");
		if(!subStepInProgress){
			subStepInProgress = true;
			//Starting out, lets clear it all
			//show_debug_message("Clearing Grid for Removal Check");
			ClearAll();
		}
		
		//We're gonna apply 1 rule, per step
		if(_i < ds_list_size(obj_Master.rules)){
			//Get this rule
			var _r = obj_Master.rules[| _i];
			//Apply it
			ApplyRule(_r);
			CheckOtherMatches();
			_TimeTaken = current_time - _T;
			//show_debug_message("Time taken to apply rule " + string(_i) + " = " + string(_TimeTaken));
			_i++;
		}
		
		if(ValidateWholeBoardComplete()){
			//End the substep
			subStepInProgress = false;
			//Move on
			
			subStep = 4;
			//show_debug_message("We can still solve it in one go around! Removal ok!");
			exit;
		}
		//Should only hit this if we're not solved it but also ran out of rules
		if(_i >= ds_list_size(obj_Master.rules)){
			subStepInProgress = false;
			subStep++;
			//We did not solve it in one go, we go onto the next one
		}
		
		
	exit;
	break;
	case 6:
	
		//This will be the rules stuff;
		//show_debug_message("Applying Rules second time");
		if(!subStepInProgress){
			subStepInProgress = true;
			//Setup again for the next one...
		}
		
		//We're gonna apply 1 rule, per step
		if(_i < ds_list_size(obj_Master.rules)){
			//Get this rule
			var _r = obj_Master.rules[| _i];
			//Apply it
			ApplyRule(_r);
			CheckOtherMatches();
			_TimeTaken = current_time - _T;
			//show_debug_message("Time taken to apply rule " + string(_i) + " = " + string(_TimeTaken));
			_i++;
		}
		if(_i >= ds_list_size(obj_Master.rules)){
			//We got to the end, end this substep
			subStepInProgress = false;
			//If its still not complete, go back to add another rule
			if(!ValidateWholeBoardComplete()){
				//show_debug_message("Did not solve it, Lets put this rule back");
				ds_list_add(obj_Master.rules,_removedRule);
				subStep=4;
				exit;
				
			}
		}
		//If we got here, we haven't gone through all the rules a second time, but, we may be complete!
		if(ValidateWholeBoardComplete()){
			//End the substep
			subStepInProgress = false;
			//Move on
			subStep = 4;
			//show_debug_message("We have solved it with the rule removed!");
		}
	exit;
	break;
	
	case 7:
		displayText[array_length(displayText)-1] = "Removing Superfluous Clues - Complete";
	//show_debug_message("Rule Gen complete!");
	array_push(displayText,"Puzzle Generation Done");
	rulesGenerated = true;
	subStep = 0;
	//ApplyRules();
	break;
	exit;
	}
}

if(!cleanupComplete){
	var _T = current_time;
	var _TimeTaken = 0;
	if(!subStepInProgress){
		_i = 0;
		_iterationCount = 0;
	}
	switch(subStep){
	case 0:
	
	if(!subStepInProgress){
		subStepInProgress = true;
		array_push(displayText,"Cleaning up all generated clues...");
	}
	
	while(_i < ds_list_size(allClues) && _TimeTaken < 10){
		var _rtd = allClues[| _i];
		if(ds_list_find_index(obj_Master.rules,_rtd) == -1){
			//show_debug_message("Not in official rules, can clean it up");
			_rtd.Destroy();
		}
		_i++;
		_TimeTaken = current_time - _T;
	}
	if(_i >= ds_list_size(allClues)){
		displayText[array_length(displayText)-1] = "Cleaning up all generated clues - Complete";
		subStep++;
		//show_debug_message("Took itrations : " + string(_iterationCount));
		subStepInProgress = false;
	}else{
			_iterationCount++;
			//show_debug_message(string(_TimeTaken));
		}
	exit;
	break;
	
	case 1:
	ds_list_destroy(allClues);
	ds_list_destroy(allCluesClean);
	cleanupComplete = true;
	exit;
	break;
	
	
	case 2:
	
	break;
	}
}

//If we got here, we must be done?
if(!obj_Master.playerReady){
	//Set player ready
	obj_Master.playerReady = true;
	obj_Master.solution = solution;
	obj_Master._timing = current_time;
	//Clear the grid
	ClearAll();
	instance_destroy();
}