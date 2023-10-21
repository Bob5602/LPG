/// @description Insert description here
// You can write your code in this editor

randomize();


keywords = ds_list_create();
subGroups = ds_list_create();
groups = ds_list_create();
rules = ds_list_create();
KeywordsToGroups = ds_map_create();
solution = -4;
truthGrid = -4;
errorCount = 0;


gridStartX = 100;
gridStartY = 100;
subGroupSize = 32 * 5;
difficulty = "Easy";
statustext = "";


puzzleGrid = -4;
playerReady = false;
puzzleNum = GenerateSeed();
prevPuz = "";
typing = false;
draw_set_font(font_title);

start_easy_button = -4;
start_medium_button = -4;
start_hard_button = -4;
abandon_button = -4;
check_button = -4;
clear_button = -4;
clear_errors_button = -4;
show_solution_button = -4;


inProgress = false;
_timing = 0;
notSolved = false;
solution_showed = false;

//drug = new Group("Color", "Blue","Green", "Yellow", "Red", "Paisley",false,,"the person with a ", " shirt");
//month = new Group("years", "17", "18", "19", "20", "21",true,["year","younger","older","is"],"the ","-year-old");
//month = new Group("years", "6:00", "7:00", "8:00", "9:00", "10:00",true,["hour","earlier","later","wakes up"],"the person who wakes up at ");
//month = new Group("years", "8:00", "9:00", "10:00", "11:00", "12:00",true,["hour","earlier","later","goes to bed"],"the person who goes to bed at ");
//condition = new Group("Owners", "Alfred", "Bruce", "Eduardo", "Horace", "Virgil",false);
//month2 = new Group("Cars","Toyota","Mercedes","BMW","Honda","Fiat",false,"the "," driver");
//month3 = new Group("Shoes","slipper","flip-flop","loafer","boot","pump",false,,"the "," wearer");

nameGroups = ds_list_create();
ds_list_add(nameGroups, new Group("Names0", "Alfred", "Bruce", "Eduardo", "Horace", "Virgil",false));
ds_list_add(nameGroups, new Group("Names1", "Lyla", "Everett", "Joy", "Patricia", "Derick",false));
ds_list_add(nameGroups, new Group("Names2", "Tabitha", "George", "Chelsea", "Stevie", "Donald",false));
ds_list_add(nameGroups, new Group("Names3", "Tristen", "Kobe", "Maleah", "Genesis", "Kameron",false));
ds_list_add(nameGroups, new Group("Names4", "Brian", "Jazmine", "Zane", "Rebecca", "Prince",false));
ds_list_add(nameGroups, new Group("Names5", "Barton", "Isaac", "Ross", "Malakai", "Elvis",false));
stuffGroups = ds_list_create();
ds_list_add(stuffGroups, new Group("Stuff0","slipper","flip-flop","loafer","boot","pump",false,,"the "," wearer"));
ds_list_add(stuffGroups, new Group("Stuff1","Toyota","Mercedes","BMW","Honda","Fiat",false,,"the "," driver"));
ds_list_add(stuffGroups, new Group("Stuff2","blue","green", "yellow", "red", "paisley",false,,"the person with a ", " shirt"));
ds_list_add(stuffGroups, new Group("Stuff3","cat","dog","turtle","horse","pig",false,,"the "," owner"));
ds_list_add(stuffGroups, new Group("Stuff4","officer","firefigher","hobo","nurse","foreman",false,,"the "));
ds_list_add(stuffGroups, new Group("Stuff5","beer","wine","whiskey","water","soda",false,,"the "," drinker"));
ds_list_add(stuffGroups, new Group("Stuff6","Fulham","Tottenham","Arsenal","Liverpool","Newcastle",false,,"the "," fan"));
valueGroups = ds_list_create();
ds_list_add(valueGroups, new Group("ValueA", "8:00", "9:00", "10:00", "11:00", "12:00",true,["hour","earlier","later","goes to bed"],"the person who goes to bed at "));
ds_list_add(valueGroups, new Group("ValueB", "6:00", "7:00", "8:00", "9:00", "10:00",true,["hour","earlier","later","wakes up"],"the person who wakes up at "));
ds_list_add(valueGroups, new Group("ValueC", "17", "18", "19", "20", "21",true,["year","younger","older","is"],"the ","-year-old"));
ds_list_add(valueGroups, new Group("ValueD", "26", "27", "28", "29", "30",true,["year","younger","older","is"],"the ","-year-old"));
ds_list_add(valueGroups, new Group("ValueE", "6", "7", "8", "9", "10",true,["finger","fewer","more","has"],"the "," fingered person"));

//ds_list_add(subGroups,test,test2,test3);



//ds_list_add(groups, month3,condition,month);

/*

if we have groups A B C as above

We are creating subgroups, and have to deal with having the correct X/Y axes

so if 
Drug (color) is A
month (years) is B
condition (owners) is C

We end up with

   A     C
B A/B  C/B
c A/C


//Sample code, from XOT of course

var vars = ["A", "B", "C", "D", "E"];
var n = array_length(vars);
for (var i=0; i<n; i++) {
	for (var j=i+1; j<n; j++) {
		draw_text(x + 50 * i, y + 50 * (n-j), $"{vars[i]}:{vars[j]}");
	}
}

So in it, we go from A, B, C, D, E

then inside we go from B, C, D, E(overflow?)

Then we end up drawing

top of A  B  C  D  E
left of:
D
*/





//typing = false;

text = "Click here to add a rule";
//text = "Click here to generate rules";

//randomize();

function CleanUp(_solved = false){
	show_debug_message("Cleaning up!");
	//Clear keywords
	ds_list_clear(keywords);
	//Clear Solution
	solution = -4;
	//Clear puzzle Grid
	ds_grid_destroy(puzzleGrid);
	puzzleGrid = -4;
	//Clear existing rules
	ClearRules();
	//Clear SubGroups
	ClearSubGroups();
	//Clear regular groups i guess
	ds_list_clear(groups);
	ds_map_clear(KeywordsToGroups);
	
	playerReady = false;
	inProgress = false;
	notSolved = false;
	puzzleNum = GenerateSeed();
	
	DestroyGameButtons()
	
	
	if(_solved){
		var _timeTaken = current_time - _timing;
		if(!solution_showed){
			statustext = difficulty + " puzzle " + prevPuz + " solved in : " + ms_convert(_timeTaken);
		}else{
			statustext = difficulty + " puzzle " + prevPuz + " had a shown solution, doesn't count!";	
		}
		_timing = 0;
		
	}else{
		statustext = difficulty + " puzzle " + prevPuz + " abandoned :(";	
		_timing = 0;
	}
	solution_showed = false;
	typing = false;
}

function ms_convert(_ms){
	var _seconds = floor(_ms / 1000);
	var _minutes = 0;
	if(_seconds >= 60){
		_minutes = floor(_seconds / 60);
		_seconds = _seconds - (60*_minutes);
	}
	var _m_string = string_format(_minutes,2,0);
	var _s_string = string_format(_seconds,2,0);
	_m_string = string_replace(_m_string," ","0");
	_s_string = string_replace(_s_string," ","0");
	return _m_string + ":" + _s_string;
}

function CreateStartButtons(){
	start_easy_button = instance_create_layer(room_width/2,450,"Instances",obj_start_easy);
	start_medium_button = instance_create_layer(room_width/2,450+65,"Instances",obj_start_medium);
	start_hard_button = instance_create_layer(room_width/2,450+65+65,"Instances",obj_start_hard);
}

function DestroyStartButtons(){
	instance_destroy(start_easy_button);
	start_easy_button = -4
	instance_destroy(start_medium_button);
	start_medium_button = -4;
	instance_destroy(start_hard_button);
	start_hard_button = -4;
}

function CreateGameButtons(){
	check_button = instance_create_layer(room_width - sprite_get_width(spr_check_solution)-5,room_height-sprite_get_height(spr_abandon_puzzle)-10 - sprite_get_height(spr_check_solution),"Instances",obj_checksolution);
	abandon_button = instance_create_layer(room_width - sprite_get_width(spr_abandon_puzzle)-5,room_height-sprite_get_height(spr_abandon_puzzle)-5,"Instances",obj_abandon);
	//clear_button = instance_create_layer(25,room_height-300,"Instances",obj_clear_button);
	clear_button = instance_create_layer(room_width - sprite_get_width(spr_clearGrid)-5,room_height-sprite_get_height(spr_abandon_puzzle)-15 - sprite_get_height(spr_check_solution) - sprite_get_height(spr_clearGrid),"Instances",obj_clear_button);
	clear_errors_button = instance_create_layer(room_width - sprite_get_width(spr_clearGrid)-10 - sprite_get_width(spr_ClearErrors),room_height-sprite_get_height(spr_abandon_puzzle)-15 - sprite_get_height(spr_check_solution) - sprite_get_height(spr_clearGrid),"Instances",obj_clear_errors_button);
	//show_solution_button = instance_create_layer(25 + 270 + 25, room_height-200,"Instances",obj_show_solution);		
	show_solution_button = instance_create_layer(room_width - sprite_get_width(spr_check_solution)-10 - sprite_get_width(spr_show_solution),room_height-sprite_get_height(spr_abandon_puzzle)-10 - sprite_get_height(spr_check_solution),"Instances",obj_show_solution);
}

function DestroyGameButtons(){
	if(abandon_button != -4){
		instance_destroy(abandon_button);
		abandon_button = -4;
	}
	if(check_button != -4){
		instance_destroy(check_button);
		check_button = -4;
	}
	if(clear_button != -4){
		instance_destroy(clear_button);
		clear_button = -4;
	}
	if(show_solution_button != -4){
		instance_destroy(show_solution_button);
		show_solution_button = -4;
	}
	if(clear_errors_button != -4){
		instance_destroy(clear_errors_button);
		clear_errors_button = -4;
	}
}