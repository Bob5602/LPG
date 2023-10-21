// Kernighan bitcount algorithm
// The C Programming Language, Chapter 2
function bitcount(n) {
	var bits = 0;
	while (n > 0) {
		n &= (n - 1);
		bits++;
	}
	return bits
}

// Compute the lexicographically next bit permutation
// https://graphics.stanford.edu/%7Eseander/bithacks.html#NextBitPermutation
function next(v) {
	var t = (v | (v - 1)) + 1;
	var w = t | ((((t & -t) div (v & -v)) >> 1) - 1); // NB: integer division
	return w
}


/// @func   bin_to_dec(bin)
///
/// @desc   Returns an integer converted from a binary string.
///
/// @param  {string}    bin         binary digits
///
/// @return {real}      positive integer
///
/// GMLscripts.com/license

function bin_to_dec(bin) 
{
    var dec = 0;
	
	bin = string_replace_all(bin, "_", "");
    var len = string_length(bin);
    for (var pos = 1; pos <= len; pos += 1) {
        dec = dec << 1;
        if (string_char_at(bin, pos) == "1") dec |= 1;
    }

    return dec;
}

function array_contains(_array,_item){
	for(var i = 0; i < array_length(_array); i++){
		if(_array[i] == _item){
			return true;	
		}
	}
	return false;
}

function SetPriorities(_p){
	ds_priority_clear(_p)
	//ds_list_shuffle(obj_Master.keywords);
	for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
		var _keyword = obj_Master.keywords[| i];
		var _posRel = FindPositiveRelations(_keyword);
		var _negRel = FindNegativeRelations(_keyword);
		var _priority = ds_list_size(_posRel) + ds_list_size(_negRel);
		ds_priority_add(_p,_keyword,_priority);
		ds_list_destroy(_posRel);
		ds_list_destroy(_negRel);
	}	
}

function SetRulePriorities(_p){
	ds_priority_add(_p,"true",irandom(1));
	ds_priority_add(_p,"false",irandom(1));
	ds_priority_add(_p,"either",irandom(1));
	ds_priority_add(_p,"neither",irandom(1));
	ds_priority_add(_p,"multi",irandom(1));
	ds_priority_add(_p,"before",irandom(1));
	ds_priority_add(_p,"after",irandom(1));
	ds_priority_add(_p,"pair",irandom(1));
	
	for(var i = 0; i < ds_list_size(obj_Master.rules); i++){
		var _ruleType = obj_Master.rules[| i].ruleType;
		if(_ruleType == "multi"){
		//	continue;	
		}
		var _oldPriority = ds_priority_find_priority(_p,_ruleType);
		ds_priority_change_priority(_p,_ruleType,_oldPriority+1);	
	}
}

function CreatePuzzleGrid(){
	testingGrid = ds_grid_create(ds_list_size(obj_Master.groups),ds_list_size(obj_Master.groups));
	ds_grid_clear(testingGrid,0);

	var n = ds_list_size(obj_Master.groups);
	for(var i = 0; i < n; i++){
		for(var j = i + 1; j < n; j++){
			ds_grid_set(testingGrid,i,n-j-1,[obj_Master.groups[| i],obj_Master.groups[|j]])	
		}
	}

	for(var i = 0; i < ds_grid_width(testingGrid); i++){
		for (var j = 0; j < ds_grid_height(testingGrid); j++){
				//Don't do anything if its a 0;
			if(testingGrid[# i,j] != 0){
				var _test = new SubGroup(testingGrid[# i,j][0],testingGrid[# i,j][1]);
				_test.SetX(obj_Master.gridStartX + obj_Master.subGroupSize * i);
				_test.SetY(obj_Master.gridStartY + obj_Master.subGroupSize * j);
				_test.SetSize(obj_Master.subGroupSize);
				ds_list_add(obj_Master.subGroups,_test);
				testingGrid[# i,j] = _test;
			}
		}
	}
	
	return testingGrid;
}

function GenerateSeed(){
	var _str = "";
	repeat(6){
		_str += string(irandom(9));	
	}
	return _str;
}

//list = ds_list_create();

// This idea is there are 15 total factors in three 5-factor groups.
// Any combination of these can be represented as a 15-bit number.
// A true statement is also a 15-bit number, with one bit set in each group.

/*
names = [
	"A", "B", "C", "D", "E",
	"1983", "1984", "1985", "1986", "1987",
	"Alfred", "Bruce", "Eduardo", "Horace", "Virgil",
	];
*/	

/*
truth = [
    //          grpC  grpB  grpA
	//          43210 43210 43210
	bin_to_dec("10000_00001_00001"),
	bin_to_dec("01000_00010_00010"),
	bin_to_dec("00100_00100_00100"),
	bin_to_dec("00010_01000_01000"),
	bin_to_dec("00001_10000_10000"),
	];


groupA = [0, 1, 2, 3, 4];
groupB = [0, 1, 2, 3, 4];
groupC = [4, 3, 2, 1, 0];

for (var n=0; n<5; n++) {
	truth[n] = 0;
	truth[n] |= (1 << groupC[n]) << 10;
	truth[n] |= (1 << groupB[n]) << 5;
	truth[n] |= (1 << groupA[n]);
}

names = [
	// Least Significant Bit
	"A", "B", "C", "D", "E", // Group A
	"1983", "1984", "1985", "1986", "1987", // Group B
	"Alfred", "Bruce", "Eduardo", "Horace", "Virgil", // Group C
	// Most Significant Bit
	];
*/


/*
function doit(_truth,_list) {

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
}
*/

#macro ds_list_shuffle ds_list_shuffle_alt

//ds_list_shuffle_alt = function (list) {
function ds_list_shuffle_alt(list){
    var currentIndex = ds_list_size(list), temporaryValue, randomIndex;
    
    // While there remain elements to shuffle...
    while (0 != currentIndex) {
        
        // Pick a remaining element...
        randomIndex = floor(random(currentIndex));
        currentIndex -= 1;
    
        // And swap it with the current element.
        temporaryValue = list[| currentIndex];
        list[| currentIndex] = list[| randomIndex];
        list[| randomIndex] = temporaryValue;
    }
}

function Clear_Errors(){
	for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
		for(var j = 0; j < ds_list_size(obj_Master.keywords); j++){
			var _i = obj_Master.keywords[| i];
			var _j = obj_Master.keywords[| j];
			var _curResult = GetState(_i,_j);
			if(_curResult == 0 || _curResult == 3){
				continue;	
			}
			var _ii = i;
			var _ij = j;
			var _trueState = obj_Master.truthGrid[# _ii,_ij];
			
			if(_curResult != _trueState){
				MarkClearSingle(_i,_j);	
			}
		}
	}
}


function ds_list_to_array(_list){
	var _s = ds_list_size(_list);
	var _array = array_create(_s);
	for(var i = 0; i < _s; i++){
		_array[i] = _list[| i];	
	}
	return _array;
}
	
function GetErrorCount(){
	var _errorCount = 0;
	for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
		for(var j = i+1; j < ds_list_size(obj_Master.keywords); j++){
			var _i = obj_Master.keywords[| i];
			var _j = obj_Master.keywords[| j];
			var _curResult = GetState(_i,_j);
			if(_curResult == 0 || _curResult == 3){
				continue;	
			}
			var _ii = i;
			var _ij = j;
			var _trueState = obj_Master.truthGrid[# _ii,_ij];
			
			if(_curResult != _trueState){
				_errorCount += 1;
			}
		}
	}
	return _errorCount;
}