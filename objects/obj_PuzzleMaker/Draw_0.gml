/// @description Insert description here
// You can write your code in this editor


//draw_text(250,25,debugText);

var _str = "";

if(!obj_Master.playerReady){
	
	for(var i = 0; i < array_length(displayText); i++){
		_str += "\n";
		_str += displayText[i];	
	}
	draw_set_font(font_standard);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text(25,25,_str);
}