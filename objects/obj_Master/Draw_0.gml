/// @description Insert description here
// You can write your code in this editor

//var testText = test.name + " : " + string(ValidateSubGroup(test)) + "Complete? " + string(ValidateSubGroupComplete(test));
//var test2Text = test2.name + " : " + string(ValidateSubGroup(test2)) + "Complete? " + string(ValidateSubGroupComplete(test2));
//var test3Text = test3.name + " : " + string(ValidateSubGroup(test3)) + "Complete? " + string(ValidateSubGroupComplete(test3));

//var testyText = "Whole Board Validation : " + string(ValidateWholeBoard()) + "Complete? " + string(ValidateWholeBoardComplete());

//draw_text(50,50,testText);
//draw_text(50,75,test2Text);
//draw_text(50,100,test3Text);
//draw_text(50,125,testyText);

if(!playerReady && puzzleGrid == -4){
	draw_set_font(font_title);
	//draw_text(25,25,"Logic Puzzle Generator");
	draw_sprite(spr_header,0,room_width/2,250);
	if(statustext != ""){
		draw_set_halign(fa_middle);
		draw_set_valign(fa_top);
		draw_text(room_width/2,350,statustext);	
	}
	draw_set_halign(fa_middle);
	draw_set_valign(fa_top);
	draw_set_font(font_standard);
	draw_text(room_width/2,700,"Puzzle # (Click to enter a specific puzzle)");
	var _sh = string_height(puzzleNum);
	_sh = max(string_height("0"),_sh);
	var _sw = string_width(puzzleNum);
	_sw = max(string_width("0"),_sw);
	draw_rectangle(room_width/2-_sw/2,725,room_width/2+_sw/2,725+_sh,1);
	draw_text(room_width/2,725,puzzleNum);
}

//Only draw if there is actually a puzzle grid.
if(puzzleGrid != -4 && playerReady){
	for(var i = 0; i < ds_grid_width(puzzleGrid); i++){
		for (var j = 0; j < ds_grid_height(puzzleGrid); j++){
				//Don't do anything if its a 0;
			if(puzzleGrid[# i,j] != 0){
				var _test = puzzleGrid[# i,j];
				var _dx = false;
				var _dy = false;
				if(i ==0){
					_dy = true;
				}
				if(j == 0){
					_dx = true;
				}
				_test.Draw(0,0,_dx,_dy);
			}
		}
	}
}
/*
test.Draw(0,0,true,true);
test2.Draw(0,0,false,true);
test3.Draw(0,0,true,false);
*/

/*
var n = ds_list_size(groups)
for (var i=0; i<n; i++) {
	for (var j=i+1; j<n; j++) {
		//draw_text(x + 50 * i, y + 50 * (n-j), $"{vars[i]}:{vars[j]}");
		draw_text(x + 100 * i, y + 100 * (n-j), (groups[|i].named + ":" + groups[|j].named));
	}
}
*/

/*
draw_rectangle(room_width-500,30,room_width-30,60,1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(room_width-500,30,text);
*/

if(playerReady){
	var _aStr = "";
	draw_set_halign(fa_left);
	draw_set_valign(fa_center);
	//draw_text(room_width-700,100, "Total: " + string(ds_list_size(rules)));
	for(var i = 0; i < ds_list_size(rules); i++){
		//rules[| i].DrawRuleText(room_width-500, 100 + 20*i);
		//rules[| i].DrawPrettyRuleText(room_width - 1000, 400 + 50*i);
		_aStr += string(i+1) + ". ";
		_aStr += rules[| i].rulePrettyText;
		_aStr += "\r\n"
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_set_font(font_standard);
	draw_text(room_width-500,25,difficulty + " puzzle #" + puzzleNum);
	draw_text(room_width-500,50,"Time Taken: " + ms_convert(current_time - _timing));
	draw_text(room_width-500,75,"Clues:");
	
	draw_text_ext(room_width-600,100,_aStr,20,600);
	
	if(notSolved){
		draw_text(room_width - sprite_get_width(spr_clearGrid)-10 - sprite_get_width(spr_ClearErrors),room_height-sprite_get_height(spr_abandon_puzzle)-35 - sprite_get_height(spr_check_solution) - sprite_get_height(spr_clearGrid),"You have " + string(errorCount) + " error(s).");
	}
}
/*
if(!ds_list_empty(solutions)){
	for(var i = 0; i < ds_list_size(solutions); i++){
		//Draw the solution details.
		draw_text(room_width-700,125 + (25 * i),"Gen solve in clues : " + string(solutions[|i][0]));
	}
}