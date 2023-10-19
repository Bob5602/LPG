// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function Group(_name,_1,_2,_3,_4,_5,_value = false,_amtType = "",_preText = "", _postText = "") constructor{
	named = _name;
	a = _1;
	b = _2;
	c = _3;
	d = _4;
	e = _5;
	value = _value;
	amtType = _amtType;
	preText = _preText;
	postText = _postText;
	
	
	
	
	static AddKeywords = function(){
		ds_list_add(obj_Master.keywords, a,b,c,d,e);
		ds_map_add(obj_Master.KeywordsToGroups,a,self);
		ds_map_add(obj_Master.KeywordsToGroups,b,self);
		ds_map_add(obj_Master.KeywordsToGroups,c,self);
		ds_map_add(obj_Master.KeywordsToGroups,d,self);
		ds_map_add(obj_Master.KeywordsToGroups,e,self);
	}
	
	static getNum = function(_name){
		if(a == _name){
			return 0;	
		}
		if(b == _name){
			return 1;	
		}
		if(c == _name){
			return 2;	
		}
		if(d == _name){
			return 3;	
		}
		if(e == _name){
			return 4;	
		}
		return -4;
	}
	
	static getName = function(_num){
		if(_num == 0){
			return a;	
		}
		if(_num == 1){
			return b;	
		}
		if(_num == 2){
			return c;	
		}
		if(_num == 3){
			return d;	
		}
		if(_num == 4){
			return e;	
		}
		return -4;
	}
	
	static contains = function(_name){
		if(a == _name || b == _name || c == _name || d == _name || e == _name){
			return true;	
		}else{
			return false;	
		}
	}
}

function SubGroup(_a,_b) constructor{
	grid = ds_grid_create(5,5);
	xSide = _a;
	ySide = _b;
	
	name = _a.named + " x " + _b.named;
	
	ds_grid_set_region(grid,0,0,4,4,0);
	
	static SetX = function(_x){
		x = _x;	
	}
	
	static SetY = function(_y){
		y = _y;	
	}
	
	static SetSize = function(_size){
		size = _size;
	}
	
	static CheckMouseOver = function(_mx,_my){
		if(point_in_rectangle(_mx,_my,x,y,x+size,y+size)){
			return true;	
		}else{
			return false;
		}
	}
	
	static GetMouseOverCell = function(_mx,_my){
		var _xCell = floor((_mx - x)/32)
		var _yCell = floor((_my - y)/32)
		
		
		return [xSide.getName(_xCell),ySide.getName(_yCell)];
	}
	
	static FillBlanks = function(){
		//Go through the entire grid
		for(var i = 0; i < ds_grid_width(grid); i++){
			for(var j = 0; j < ds_grid_height(grid); j++){
				if(grid[# i,j] != 2){
					grid[# i,j] = 1;
				}
			}
		}	
	}
	
	static NameExists = function(_name){
		if(xSide.getNum(_name) != -4){
			return true;	
		}
		if(ySide.getNum(_name) != -4){
			return true;
		}
		
		return false;
	}
	
	static SetFalse = function(_a,_b){
		if(!NameExists(_a) || !NameExists(_b)){
			//show_message("Error, name not in subGroup");
			return;	
		}
		
		if(xSide.contains(_a)){
			var _x = xSide.getNum(_a);
			var _y = ySide.getNum(_b);
		}else{
			var _x = xSide.getNum(_b);
			var _y = ySide.getNum(_a);		
		}

		grid[# _x,_y] = 1;
	}
	
	static SetClear = function(_a,_b){
		if(!NameExists(_a) || !NameExists(_b)){
			//show_message("Error, name not in subGroup");
			return;	
		}
		
		if(xSide.contains(_a)){
			var _x = xSide.getNum(_a);
			var _y = ySide.getNum(_b);
		}else{
			var _x = xSide.getNum(_b);
			var _y = ySide.getNum(_a);
		}

		grid[# _x,_y] = 0;
		ds_grid_set_region(grid,_x,0,_x,4,0);
		ds_grid_set_region(grid,0,_y,4,_y,0);
	}
	
	static SetClearSingle = function(_a,_b){
		if(!NameExists(_a) || !NameExists(_b)){
			//show_message("Error, name not in subGroup");
			return;	
		}
		
		if(xSide.contains(_a)){
			var _x = xSide.getNum(_a);
			var _y = ySide.getNum(_b);
		}else{
			var _x = xSide.getNum(_b);
			var _y = ySide.getNum(_a);
		}

		grid[# _x,_y] = 0;
	}
	
	static SetDirectValue = function(_a,_b,_val){
		if(!NameExists(_a) || !NameExists(_b)){
			//show_message("Error, name not in subGroup");
			return;	
		}
		
		if(xSide.contains(_a)){
			var _x = xSide.getNum(_a);
			var _y = ySide.getNum(_b);
		}else{
			var _x = xSide.getNum(_b);
			var _y = ySide.getNum(_a);
		}

		grid[# _x,_y] = _val;
	}
	
	static Validate = function(){
		var trues = 0;
		//Go through each column
		for(var i = 0; i < ds_grid_width(grid); i++){
			//Reset trues every new new column
				trues = 0;
			//Go through each row per column
			for(var j = 0; j < ds_grid_height(grid); j++){
				if(grid[# i,j] == 2){
					trues += 1;	
				}
				//If there is more than 1 true, its not valid
				if(trues > 1){
					return false;
				}
			}
		}
		
		//Go through each row
		for(var i = 0; i < ds_grid_height(grid); i++){
			//Reset trues every new new row
			trues = 0;
			//Go through each column per row
			for(var j = 0; j < ds_grid_width(grid); j++){
				if(grid[# j,i] == 2){
					trues += 1;	
				}
				//If there is more than 1 true, its not valid
				if(trues > 1){
					return false;
				}
			}
		}
		
		//If we got here, we must be ok
		return true;
	}
	
	static ValidateComplete = function(){
		var trues = 0;
		//Go through each column
		for(var i = 0; i < ds_grid_width(grid); i++){
			//Go through each row per column
			for(var j = 0; j < ds_grid_height(grid); j++){
				if(grid[# i,j] == 2){
					trues += 1;	
				}
			}
		}
		if(trues == 5){
			return true;	
		}else{
			return false;	
		}
	}
	
	static SetEitherOr = function(_a,_b,_c){
		if(xSide.contains(_a)){
			var _x = xSide.getNum(_a);
			var _y1 = ySide.getNum(_b);
			var _y2 = ySide.getNum(_c);
			ds_grid_set_region(grid,_x,0,_x,4,1);
			grid[# _x,_y1] = 0;
			grid[# _x,_y2] = 0;
		}else{
			var _x1 = xSide.getNum(_b);
			var _x2 = xSide.getNum(_c);
			var _y = ySide.getNum(_a);
			ds_grid_set_region(grid,0,_y,4,_y,1);
			grid[# _x1,_y] = 0;
			grid[# _x2,_y] = 0;
		}

	}
	
	static SetTrue = function(_a,_b){
		if(!NameExists(_a) || !NameExists(_b)){
			//show_message("Error, name not in subGroup");
			return;	
		}
		
		if(xSide.contains(_a)){
			var _x = xSide.getNum(_a);
			var _y = ySide.getNum(_b);
		}else{
			//show_message("Reverse order");
			var _x = xSide.getNum(_b);
			var _y = ySide.getNum(_a);		
		}
		if(_x == -4 || _y == -4) return;
		
		//Mark the row false;
		ds_grid_set_region(grid,_x,0,_x,4,1);
		//Mark the column false
		ds_grid_set_region(grid,0,_y,4,_y,1);
		
		//Mark the overlap true;
		grid[# _x,_y] = 2;
		
	}
	
	static CheckForPositives = function(){
		//Check columns
		for(var i = 0; i < 5; i++){
			var _numBlank = ds_list_create();
			//Go through all the columns in this row
			for(var j = 0; j < 5; j++){
				if(grid[# i,j] == 0){
					//If its blank, write it down
					ds_list_add(_numBlank, j);
				}
			}
			//If there is only 1 blank, it should be a positive
			if(ds_list_size(_numBlank) == 1){
				var _a = xSide.getName(i);
				var _b = ySide.getName(_numBlank[| 0]);
				//show_message("Found a positive - " + _a + " , " + _b);
				MarkTrue(_a,_b);
			}
		}
		
		//Check columns
		for(var i = 0; i < 5; i++){
			var _numBlank = ds_list_create();
			//Go through all the columns in this row
			for(var j = 0; j < 5; j++){
				if(grid[# j,i] == 0){
					//If its blank, write it down
					ds_list_add(_numBlank, j);
				}
			}
			//If there is only 1 blank, it should be a positive
			if(ds_list_size(_numBlank) == 1){
				var _b = ySide.getName(i);
				var _a = xSide.getName(_numBlank[| 0]);
				//show_message("Found a positive - " + _a + " , " + _b);
				MarkTrue(_a,_b);
			}
		}

	}
	
	static CheckForPseudoPairs = function(){
		
		
		//Go through columns
		for(var i = 0; i < 4; i++){
			var _blankNames = ds_list_create();
			//Go through all the rows in this column
			for(var j = 0; j < 5; j++){
				if(grid[# i,j] == 0){
					//If its blank, write it down
					ds_list_add(_blankNames, ySide.getName(j));
				}
			}
			
			//If 2 exactly are blank
			if(ds_list_size(_blankNames) == 2){
				//Now we check to see if any other column is the same
				for(var o = i+1; o < 5; o++){
					if(grid[# i,0] == grid[# o,0] &&
					grid[# i,1] == grid[# o,1] &&
					grid[# i,2] == grid[# o,2] &&
					grid[# i,3] == grid[# o,3] &&
					grid[# i,4] == grid[# o,4]){
						//We have a positive match for a pseudo pair
						//show_message("We got a pseudo pair!");
						for(var p = 0; p < 5; p++){
							if(p != i && p != o){
								MarkFalse(_blankNames[| 0], xSide.getName(p));
								MarkFalse(_blankNames[| 1], xSide.getName(p));
							}
						}
					}
				}
			}
			ds_list_destroy(_blankNames);
		}
		
		
		//Go through rows
		for(var i = 0; i < 4; i++){
			var _blankNames = ds_list_create();
			//Go through all the rows in this column
			for(var j = 0; j < 5; j++){
				if(grid[# j,i] == 0){
					//If its blank, write it down
					ds_list_add(_blankNames, xSide.getName(j));
				}
			}
			
			//If 2 exactly are blank
			if(ds_list_size(_blankNames) == 2){
				//Now we check to see if any other column is the same
				for(var o = i+1; o < 5; o++){
					if(grid[# 0,i] == grid[# 0,o] &&
					grid[# 1,i] == grid[# 1,o] &&
					grid[# 2,i] == grid[# 2,o] &&
					grid[# 3,i] == grid[# 3,o] &&
					grid[# 4,i] == grid[# 4,o]){
						//We have a positive match for a pseudo pair
						//show_message("We got a pseudo pair!");
						for(var p = 0; p < 5; p++){
							if(p != i && p != o){
								MarkFalse(_blankNames[| 0], ySide.getName(p));
								MarkFalse(_blankNames[| 1], ySide.getName(p));
							}
						}
					}
				}
			}
			ds_list_destroy(_blankNames);
		}
	}
	
	static CheckForCrosses = function(){
		//Go through columns
		for(var i = 0; i < 5; i++){
			var _blankNames = ds_list_create();
			//Go through all the rows in this column
			for(var j = 0; j < 5; j++){
				if(grid[# i,j] == 0){
					//If its blank, write it down
					ds_list_add(_blankNames, ySide.getName(j));
				}
			}
			
			//If 2 or 3 are blank. 
			if(ds_list_size(_blankNames) == 2 || ds_list_size(_blankNames) == 3){
				//This is the item we found the blanks for
				var _a = xSide.getName(i);
				//This is the group to which the items belong
				// _blankNames is the LIST of items
				var _blanksGroup = ySide;
				
				//Get all the subgroups that these blanks are part of
				var _gsg = GetSubGroups(_blanksGroup);
				
				//Go through the subgroups
				for(var o = 0; o < ds_list_size(_gsg); o++){
					//Skip if its yourself
					if(_gsg[| o] == self){
						//show_message("This is my own group, skip it");
						continue;
					}
					//Find out WHICH side the blanksgroup is...
					//If its the xSide side...
					if(_gsg[| o].xSide == _blanksGroup){
						//Go through the columns...
						for(var p = 0; p < 5; p++){
							//This is the name of the column we're checking
							var _bla = _gsg[| o].ySide.getName(p);
							//We assume this will match
							var _isMatch = true;
							//Check it against the name of the blanks we have...
							for(var l = 0; l < ds_list_size(_blankNames); l++){
								//IF any of OUR BLANKS is not a FALSE in this column, its not a match
								if(GetState(_bla,_blankNames[| l]) != 1){
									_isMatch = false;	
								}
							}
							if(_isMatch){
								//show_message("Is a match");
								MarkFalse(_bla,_a);
							}
						}
					}else{
						//Go through the rows...
						for(var p = 0; p < 5; p++){
							//This is the name of the column we're checking
							var _bla = _gsg[| o].xSide.getName(p);
							//We assume this will match
							var _isMatch = true;
							//Check it against the name of the blanks we have...
							for(var l = 0; l < ds_list_size(_blankNames); l++){
								//IF any of OUR BLANKS is not a FALSE in this column, its not a match
								if(GetState(_bla,_blankNames[| l]) != 1){
									_isMatch = false;	
								}
							}
							if(_isMatch){
								//show_message("Is a match");
								MarkFalse(_bla,_a);
							}
						}
					}
					
				}
				ds_list_destroy(_gsg);	
			}
			ds_list_destroy(_blankNames);
		}

		//Go through rows
		for(var i = 0; i < 5; i++){
			var _blankNames = ds_list_create();
			//Go through all the rows in this column
			for(var j = 0; j < 5; j++){
				if(grid[# j,i] == 0){
					//If its blank, write it down
					ds_list_add(_blankNames, xSide.getName(j));
				}
			}
			
			//If 2 or 3 are blank. 
			if(ds_list_size(_blankNames) == 2 || ds_list_size(_blankNames) == 3){
				//This is the item we found the blanks for
				var _a = ySide.getName(i);
				//This is the group to which the items belong
				// _blankNames is the LIST of items
				var _blanksGroup = xSide;
				
				//Get all the subgroups that these blanks are part of
				var _gsg = GetSubGroups(_blanksGroup);
				
				//Go through the subgroups
				for(var o = 0; o < ds_list_size(_gsg); o++){
					//Skip if its yourself
					if(_gsg[| o] == self){
						//show_message("This is my own group, skip it");
						continue;
					}
					//Find out WHICH side the blanksgroup is...
					//If its the xSide side...
					if(_gsg[| o].xSide == _blanksGroup){
						//Go through the columns...
						for(var p = 0; p < 5; p++){
							//This is the name of the column we're checking
							var _bla = _gsg[| o].ySide.getName(p);
							//We assume this will match
							var _isMatch = true;
							//Check it against the name of the blanks we have...
							for(var l = 0; l < ds_list_size(_blankNames); l++){
								//IF any of OUR BLANKS is not a FALSE in this column, its not a match
								if(GetState(_bla,_blankNames[| l]) != 1){
									_isMatch = false;	
								}
							}
							if(_isMatch){
								//show_message("Is a match");
								MarkFalse(_bla,_a);
							}
						}
					}else{
						//Go through the rows...
						for(var p = 0; p < 5; p++){
							//This is the name of the column we're checking
							var _bla = _gsg[| o].xSide.getName(p);
							//We assume this will match
							var _isMatch = true;
							//Check it against the name of the blanks we have...
							for(var l = 0; l < ds_list_size(_blankNames); l++){
								//IF any of OUR BLANKS is not a FALSE in this column, its not a match
								if(GetState(_bla,_blankNames[| l]) != 1){
									_isMatch = false;	
								}
							}
							if(_isMatch){
								//show_message("Is a match");
								MarkFalse(_bla,_a);
							}
						}	
					}
				
				}
				ds_list_destroy(_gsg);		
			}
			ds_list_destroy(_blankNames);
		}
	}
	
	static Draw = function(_x,_y,_xlabel,_ylabel){
		draw_set_color(c_white);
		
		
		_x = x;
		_y = y;
		
		//Draw the grid for the squares
		for (var i = 0; i < 5; ++i) {
			for (var j = 0; j < 5; ++j) {
				draw_sprite(spr_cell,grid[# i,j],_x + 16 + (i*32),_y + 16 + (j*32));
			}
		}
		//If xlabel, draw the label texts
		if(_xlabel){
			draw_set_valign(fa_left);
			draw_set_halign(fa_left);
			draw_text_ext_transformed(_x+8,_y-15,xSide.a,1,1000,1,1,45);
			draw_text_ext_transformed(_x+8+32,_y-15,xSide.b,1,1000,1,1,45);
			draw_text_ext_transformed(_x+8+64,_y-15,xSide.c,1,1000,1,1,45);
			draw_text_ext_transformed(_x+8+96,_y-15,xSide.d,1,1000,1,1,45);
			draw_text_ext_transformed(_x+8+128,_y-15,xSide.e,1,1000,1,1,45);
		}
		//If ylabel, draw the label texts
		if(_ylabel){
			draw_set_valign(fa_center);
			draw_set_halign(fa_right);
			draw_text(_x-4,_y+16,ySide.a);
			draw_text(_x-4,_y+16+32*1,ySide.b);
			draw_text(_x-4,_y+16+32*2,ySide.c);
			draw_text(_x-4,_y+16+32*3,ySide.d);
			draw_text(_x-4,_y+16+32*4,ySide.e);
		}
		//Draw the bolder outer subgroup square
		draw_sprite(spr_subGroup,0,_x,_y);
	}
	
	static Destroy = function(){
		ds_grid_destroy(grid);
	}
}

function FindPositiveRelations(_name){
	var _sg = GetSubGroups(FindGroup(_name));
	var _pos = ds_list_create();
	
	//Go through all the subgroups this name is part of.
	for(var i = 0; i < ds_list_size(_sg); i++){
		
		//Different per side, sure.
		if(_sg[| i].xSide.contains(_name)){
			_x = _sg[| i].xSide.getNum(_name);
			
			//Go through the column or row if there is a posiitive
			for(var j = 0; j < 5; j++){
				if(_sg[| i].grid[# _x,j] == 2){
					//Get the name of the item it is positive with
					//show_message(_name + " Is positive with " + _sg[| i].ySide.getName(j));
					ds_list_add(_pos,_sg[| i].ySide.getName(j));
				}
			}
		}else{
			_y = _sg[| i].ySide.getNum(_name);
			for(var j = 0; j < 5; j++){
				if(_sg[| i].grid[# j,_y] == 2){
					//show_message(_name + " Is positive with " + _sg[| i].xSide.getName(j));
					ds_list_add(_pos,_sg[| i].xSide.getName(j));
				}
			}
		}		
	}
	
	return _pos;
}

function FindNegativeRelations(_name){
	var _sg = GetSubGroups(FindGroup(_name));
	var _neg = ds_list_create();
	
	//Go through all the subgroups this name is part of.
	for(var i = 0; i < ds_list_size(_sg); i++){
		
		//Different per side, sure.
		if(_sg[| i].xSide.contains(_name)){
			_x = _sg[| i].xSide.getNum(_name);
			
			//Go through the column or row if there is a posiitive
			for(var j = 0; j < 5; j++){
				if(_sg[| i].grid[# _x,j] == 1){
					//Get the name of the item it is positive with
					//show_message(_name + " Is positive with " + _sg[| i].ySide.getName(j));
					ds_list_add(_neg,_sg[| i].ySide.getName(j));
				}
			}
		}else{
			_y = _sg[| i].ySide.getNum(_name);
			for(var j = 0; j < 5; j++){
				if(_sg[| i].grid[# j,_y] == 1){
					//show_message(_name + " Is positive with " + _sg[| i].xSide.getName(j));
					ds_list_add(_neg,_sg[| i].xSide.getName(j));
				}
			}
		}		
	}
	
	return _neg;
}

function TransposePositives(_name){
	//show_message("Transposing Positives for " + _name);
	//Find all the positives for this _name
	var _posList = FindPositiveRelations(_name);
	//Check all THOSE positives for other positives, a new list
	for(var i = 0; i < ds_list_size(_posList); i++){
		var _posList2nd = FindPositiveRelations(_posList[| i]);
		//for each of THOSE positives (one of which HAS to be _name)
		for(var j = 0; j < ds_list_size(_posList2nd); j++){
			//If its not this actual named one..
			if(_posList2nd[| j] != _name){
				//Mark it true dude
				if(GetState(_name,_posList2nd[| j]) != 2){
					MarkTrue(_name,_posList2nd[| j]);
				}
			}
		}
		ds_list_destroy(_posList2nd);
	}
	ds_list_destroy(_posList);
}

function TransposeNegatives(_name){
	var _group = FindGroup(_name);
	var _num = _group.getNum(_name);
	//Find positives
	var _negList = ds_list_create();
	var _posList = ds_list_create();
	//First get the subGroups that this item is a part of
	var _subs = GetSubGroups(_group);
	
	//show_message("Transposing Negatives for " + _name);
	//Go through each of the groups
	for(var i = 0; i < ds_list_size(_subs); i++){
		
		//Find which side this is in...
		if(_subs[| i].xSide == _group){
			////show_message("This is X side");
			//Go through the 5 items it is in, check for negatives
			for(var j = 0; j < 5; j++){
				if(_subs[| i].grid[# _num,j] == 1){
					ds_list_add(_negList, _subs[| i].ySide.getName(j));
					//show_message("Adding to negatives list - " + _subs[| i].ySide.getName(j));
				}else if(_subs[| i].grid[# _num,j] == 2){
					ds_list_add(_posList, _subs[| i].ySide.getName(j));
					//show_message("Adding to positive list - " + _subs[| i].ySide.getName(j));					
				}
			}			
		}else if(_subs[| i].ySide == _group){
			//Go through the 5 items it is in, check for negatives
			for(var j = 0; j < 5; j++){
				if(_subs[| i].grid[# j,_num] == 1){
					ds_list_add(_negList, _subs[| i].xSide.getName(j));
					//show_message("Adding to negatives list - " + _subs[| i].xSide.getName(j));
				}else if(_subs[| i].grid[# j,_num] == 2){
					ds_list_add(_posList, _subs[| i].xSide.getName(j));
					//show_message("Adding to positive list - " + _subs[| i].xSide.getName(j));					
				}
			}			
		}
		
	}

	//So now we have the positive matches, and all the negatives to transpose
	ds_list_destroy(_subs);
	//Go through all the positive matches
	for(var i = 0; i < ds_list_size(_posList); i++){
		//Go through the new negatives
		for(var u = 0; u < ds_list_size(_negList); u++){
			MarkFalse(_posList[| i],_negList[| u]);
		}
	}
	
	ds_list_destroy(_posList);
	ds_list_destroy(_negList);
	
	
	
}
//Pass in the name of a thing, get the group its part of
function FindGroup(_name){
	
	var _a = obj_Master.KeywordsToGroups[? _name];
	if(_a == undefined){
		return -4;	
	}else{
		return _a;	
	}
	/*
	var _ml = obj_Master.groups;
	for(var i = 0; i < ds_list_size(_ml); i++){
		if(_ml[| i].getNum(_name) != -4){
			var _b = obj_Master.KeywordsToGroups[? _name];
			if(_b != _ml[| i]){
				show_message("Not the same group!");	
			}else{
				show_debug_message("Groups are the same for " + _name);	
			}
			return _ml[| i];
		}
	}
	ds_map_find_value()
	return -4;
	*/
}


function GetSubGroups(_group){
	var _temp = ds_list_create();
	var _ml = obj_Master.subGroups;
	for(var i = 0; i < ds_list_size(_ml); i++){
		if(_ml[| i].xSide == _group || _ml[| i].ySide == _group){
			ds_list_add(_temp,_ml[| i]);	
		}
	}
	return _temp;
}

function GetIntersectingGroups(_nameA,_nameB){
	var _a = ds_list_find_index(obj_Master.groups,_nameA);
	var _b = ds_list_find_index(obj_Master.groups,_nameB);
	var _tot = ds_list_size(obj_Master.groups);
	
	var _ret = obj_Master.puzzleGrid[# _a,_tot-_b-1];
	if(_ret == 0){
		_ret = obj_Master.puzzleGrid[# _b,_tot-_a-1];	
	}
	return _ret;

}
/*
function GetIntersectingGroups(_nameA,_nameB){
	var _aGroups = GetSubGroups(_nameA);
	var _bGroups = GetSubGroups(_nameB);
	var _comboGroup;
	
	//Go through all of A's subgroups
	for(var i = 0; i < ds_list_size(_aGroups); i++){
		//If it exists in B's subgroups
		if(ds_list_find_index(_bGroups,_aGroups[| i]) != -1){
			_comboGroup = _aGroups[| i];
			break;
		}
	}
	
	//Get rid of extra lists
	ds_list_destroy(_aGroups);
	ds_list_destroy(_bGroups);
	var _test = GetIntersectingGroupsAlt(_nameA,_nameB);
	if(_comboGroup == _test){
		//show_message("The same combo group!");	
	}else{
		show_message("Wrong combo group");	
	}
	//Return
	return _comboGroup;
}
*/

function MarkTrue(_aName,_bName){
	
	var _aGroup = FindGroup(_aName);
	var _bGroup = FindGroup(_bName);
	if(_aGroup == _bGroup){
		//show_message("Same Group, skipping");	
		return;
	}
	
	if(GetState(_aName,_bName) == 2){
		TransposeNegatives(_aName);
		TransposeNegatives(_bName);
		TransposePositives(_aName);
		TransposePositives(_bName);
		return;
	}
	var _tests = GetIntersectingGroups(_aGroup,_bGroup);
	
	_tests.SetTrue(_aName,_bName);
	
	TransposeNegatives(_aName);
	TransposeNegatives(_bName);
	TransposePositives(_aName);
	TransposePositives(_bName);
}

function MarkFalse(_aName,_bName){
	var _aGroup = FindGroup(_aName);
	var _bGroup = FindGroup(_bName);
	if(_aGroup == _bGroup){
		//show_message("Same Group, skipping");	
		return;
	}
	if(GetState(_aName,_bName) == 1){
		return;	
	}
	
	var _tests = GetIntersectingGroups(_aGroup,_bGroup);
	
	_tests.SetFalse(_aName,_bName);	
}

function MarkEitherOr(_aName,_bName,_cName){
	var _aGroup = FindGroup(_aName);
	var _bGroup = FindGroup(_bName);
	
	var _tests = GetIntersectingGroups(_aGroup,_bGroup);
	
	_tests.SetEitherOr(_aName,_bName,_cName);
}

function GetState(_aName,_bName){
	var _aGroup = FindGroup(_aName);
	var _bGroup = FindGroup(_bName);
	if(_aGroup == _bGroup){
		//show_message("Same Group, skipping");	
		return -4;
	}
	
	/*
	var _a = ds_list_find_index(obj_Master.keywords,_aName);
	var _b = ds_list_find_index(obj_Master.keywords,_bName);
	
	var _result = obj_Master.truthGrid[# _a,_b];
	*/
	
	
	var _g = GetIntersectingGroups(_aGroup,_bGroup);
	var _x, _y;
	if(_g.xSide.contains(_aName)){
		_x = _g.xSide.getNum(_aName);
		_y = _g.ySide.getNum(_bName);
	}else{
		_x = _g.xSide.getNum(_bName);
		_y = _g.ySide.getNum(_aName);		
	}
	
	var _result = _g.grid[# _x,_y];
	//show_message(_aName + " / " + _bName + " = " + string(_result));
	
	return _result;
}


//Loops through all the subgroups and does some checks
function CheckOtherMatches(){
	var _ml = obj_Master.subGroups;
	for(var i = 0; i < ds_list_size(_ml); i++){
		_ml[| i].CheckForPositives();
		_ml[| i].CheckForPseudoPairs();
		_ml[| i].CheckForCrosses();
	}		
}

function MarkClear(_aName,_bName){
	var _aGroup = FindGroup(_aName);
	var _bGroup = FindGroup(_bName);
	if(_aGroup == _bGroup){
		//show_message("Same Group, skipping");	
		return;
	}
	if(GetState(_aName,_bName) == 0){
		return;	
	}
	
	var _tests = GetIntersectingGroups(_aGroup,_bGroup);
	
	_tests.SetClear(_aName,_bName);	
}

function MarkClearSingle(_aName,_bName){
	var _aGroup = FindGroup(_aName);
	var _bGroup = FindGroup(_bName);
	if(_aGroup == _bGroup){
		//show_message("Same Group, skipping");	
		return;
	}
	if(GetState(_aName,_bName) == 0){
		return;	
	}
	
	var _tests = GetIntersectingGroups(_aGroup,_bGroup);
	
	_tests.SetClearSingle(_aName,_bName);	
}

function MarkValue(_aName,_bName,_val){
	var _aGroup = FindGroup(_aName);
	var _bGroup = FindGroup(_bName);
	if(_aGroup == _bGroup){
		//show_message("Same Group, skipping");	
		return;
	}
	
	var _tests = GetIntersectingGroups(_aGroup,_bGroup);
	
	_tests.SetDirectValue(_aName,_bName,_val);	
}

//Clears all the cells in all of the subgroups
function ClearAll(){
	for(var q = 0; q < ds_list_size(obj_Master.subGroups); q++){
		ds_grid_clear(obj_Master.subGroups[| q].grid,0);
	}
}

function CycleCell(_aName,_bName){
	if(GetState(_aName,_bName) == 0){
		MarkValue(_aName,_bName,1)
		return;
	}
	if(GetState(_aName,_bName) == 1){
		MarkValue(_aName,_bName,2)
		return;
	}
	if(GetState(_aName,_bName) == 2){
		MarkValue(_aName,_bName,3)
		return;
	}
	if(GetState(_aName,_bName) == 3){
		MarkValue(_aName,_bName,0)
		return;
	}
}
function ClearCell(_aName,_bName){
	MarkValue(_aName,_bName,0);	
}

//Validation checks

function ValidateSubGroup(_sub){
	var t = _sub.Validate();
	return t;
}

function ValidateWholeBoard(){
	for(var i = 0; i < ds_list_size(obj_Master.subGroups); i++){
		if(!ValidateSubGroup(obj_Master.subGroups[| i])){
			return false;	
		}
	}
	
	for(var i = 0; i < ds_list_size(obj_Master.keywords); i++){
		if(!ValidatePositives(obj_Master.keywords[| i])){
			return false;	
		}
	}
	
	return true;
}

function ValidateSubGroupComplete(_sub){
	return _sub.ValidateComplete();
}

function ValidateWholeBoardComplete(){
	//show_message("entering Board Complete");
	for(var i = 0; i < ds_list_size(obj_Master.subGroups); i++){
		if(!ValidateSubGroupComplete(obj_Master.subGroups[| i])){
			//show_message("exiting Board Complete - failure");
			return false;
		}
	}
	//show_message("exiting Board Complete - success");
	return true;
}

function ValidatePositives(_name){
	
	//Find all the positives for this _name
	var _posList = FindPositiveRelations(_name);
	//Check all THOSE positives for other positives, a new list
	for(var i = 0; i < ds_list_size(_posList); i++){
		var _posList2nd = FindPositiveRelations(_posList[| i]);
		//for each of THOSE positives (one of which HAS to be _name)
		for(var j = 0; j < ds_list_size(_posList2nd); j++){
			//If its not this actual named one..
			if(_posList2nd[| j] != _name){
				if(GetState(_name,_posList2nd[| j]) != 2){
					ds_list_destroy(_posList);
					ds_list_destroy(_posList2nd);
					return false;
				}
			}
		}
		ds_list_destroy(_posList2nd);
	}
	ds_list_destroy(_posList);
	return true;
}

function GenerateRules(_rulesList){
	//First we will in all the negatives, so we have a truly complete board
	for(var i = 0; i < ds_list_size(obj_Master.subGroups); i++){
		obj_Master.subGroups[| i].FillBlanks();
	}
	var _now = current_time;
	GenerateTrueRules(_rulesList);
	GenerateFalseRules(_rulesList);
	GenerateEitherOrRules(_rulesList);
	GenerateNeitherNorRules(_rulesList);
	
	
	/*
	var _tList = ds_list_create();
	var _tList2 = ds_list_create();
	GenerateMultiRule(_tList);
	GenerateMultiRuleAlt(_tList2);
	
	show_debug_message("OLD:");
	for(var i = 0; i < ds_list_size(_tList); i++){
		show_debug_message(_tList[| i].ToString());	
	}
	show_debug_message("NEW:");
	for(var i = 0; i < ds_list_size(_tList2); i++){
		show_debug_message(_tList2[| i].ToString());	
	}
	
	*/
	
	//GenerateMultiRule(_rulesList);
	//show_debug_message("Dupes after this matter");
	GenerateMultiRuleAlt(_rulesList);
	GeneratePairRules(_rulesList);
	GenerateValueRules(_rulesList);
	var _timeElapes = current_time - _now;
	show_debug_message("Generation took " + string(_timeElapes) + " ms for " + string(ds_list_size(_rulesList)) + " Rules");
	//show_message("Generation took " + string(_timeElapes) + " ms for " + string(ds_list_size(_rulesList)) + " Rules");
}

function GeneratePuzzleSolution(){
	//This will randomly generate a solved puzzle
	//Wherein, we end up with 5 sets, of X values.
	//where X = number of Groups
	
	//And stored in an array?
	
	
	/*
	var _solutions = [];
	var _numList = ds_list_create()
	var _numList2 = ds_list_create();
	ds_list_add(_numList,0,1,2,3,4);
	ds_list_add(_numList2,0,1,2,3,4);
	ds_list_shuffle(_numList);
	ds_list_shuffle(_numList2);
	
	var _aGroups = [];
	for(var i = 0; i < ds_list_size(obj_Master.groups); i++){
		array_push(_aGroups,obj_Master.groups[| i]);	
	}
	
	for(var j = 0; j < 5; j++){
			var _aName = _aGroups[0].getName(j);	
			var _bName = _aGroups[1].getName(_numList[| 0]);
			var _cName = _aGroups[2].getName(_numList2[| 0]);
			
			MarkTrue(_aName,_bName);
			MarkTrue(_aName,_cName);
			var _sol = [_aName,_bName,_cName];
			array_push(_solutions,_sol);
			ds_list_delete(_numList,0);
			ds_list_delete(_numList2,0);
	}
	
	CheckOtherMatches();
	ds_list_destroy(_numList);
	ds_list_destroy(_numList2);
	
	*/
	
	var _solutions = [];
	//Just 1 list, of all the values;
	var _numList = ds_list_create();
	ds_list_add(_numList,0,1,2,3,4); 
	
	var _aGroups = [];
	for(var i = 0; i < ds_list_size(obj_Master.groups); i++){
		ds_list_shuffle(_numList);
		var _randVals = ds_list_to_array(_numList);
		var _gArray = array_create(2);
		//array_push(_aGroups,obj_Master.groups[| i]);
		_gArray[0] = obj_Master.groups[| i];
		_gArray[1] = _randVals;
		array_push(_aGroups,_gArray);
	}
	
	
	for(var j = 0; j < 5; j++){
		var _aName = _aGroups[0][0].getName(j);	
		var _sol = array_create(1);
		_sol[0] = _aName;
		
		for(var k = 1; k < array_length(_aGroups); k++){
			var _nName = _aGroups[k][0].getName(_aGroups[k][1][j]);	
			MarkTrue(_aName,_nName);
			array_push(_sol,_nName);
		}
		
		array_push(_solutions,_sol);
	}
	CheckOtherMatches();
	
	ds_list_destroy(_numList);
	//show_debug_message(_solutions);
	//obj_Master.curSolve = _solutions;
	
	var _t = current_time;
	var _tot = ds_list_size(obj_Master.keywords)
	var _testGrid = ds_grid_create(_tot,_tot);
	
	for (var i = 0; i < ds_grid_width(_testGrid); i++) {
	    for(var j = 0; j < ds_grid_height(_testGrid);j++){
			var _a = obj_Master.keywords[| i];
			var _b = obj_Master.keywords[| j];
			var _res = GetState(_a,_b);
			_testGrid[# i,j] = _res;
		}
	}
	//show_message("Time taken to generate truth grid in ms - " + string(current_time - _t));
	if(obj_Master.truthGrid != -4){
		ds_grid_destroy(obj_Master.truthGrid);	
	}
	obj_Master.truthGrid = _testGrid;
	
	
		show_debug_message("Consistency Check:")
		var _str = "";
	for(var o = 0; o < ds_list_size(obj_Master.keywords); o++){
		_str += obj_Master.keywords[| o] + ", ";
	}
	show_debug_message(_str);
	repeat(10){
		var _rand1 = irandom(14);
		var _rand2 = irandom(14);
		var _a = obj_Master.keywords[| _rand1];
		var _b = obj_Master.keywords[| _rand2];
		
		var _c = GetState(_a,_b);
		
		var _d = _rand1;//ds_list_find_index(keywords,_a);
		var _e = _rand2;//ds_list_find_index(keywords,_b);
		
		if(_rand1 != _d){
			show_debug_message("Not the same?");	
		}
		if(_rand2 != _e){
			show_debug_message("Not the same?");	
		}
		var _f = obj_Master.truthGrid[# _d,_e];
		
		if(_c == _f){
			show_debug_message("Passed " + string(_c) + " = " + string(_f));	
		}else{
			show_debug_message("Failed " + string(_c) + " = " + string(_f));	
		}
	}
	
	return _solutions;
	
}

function verifyPuzzleSolved(_solution){
	//Get the group we have
	var _g = obj_Master.groups[| 0];
	for(var i = 0; i < 5; i++){
		//Name of the variable we wanna get the solutions for
		var _aName = _g.getName(i);
		//Get this name's positive relatinos
		var _posList = FindPositiveRelations(_aName);
		//Go through the array
		for(var j = 0; j < array_length(_solution); j++){
			//Get the array
			var _sol = _solution[j];
			//If this part of the solution contains this value
			if(array_contains(_sol,_aName)){
				
				
				if(array_length(_sol) != ds_list_size(_posList) + 1){
					//If they aren't equal, its def not right
					ds_list_destroy(_posList);
					return false;
				}
				
				//go through all the expected positives
				for(var k = 0; k < array_length(_sol); k++){
					//If its just itself move along
					if(_sol[k] == _aName){
						continue;	
					}
					
					//If the expected positive
					//Is NOT in the positive list
					//Then this can't be correct
					if(ds_list_find_index(_posList,_sol[k]) == -1){
						//If its not there, its a false;
						ds_list_destroy(_posList);
						return false;
					}
				}
			//If we at least found the right array, we can break this loop	
			break;
			}
		}
		//If we got here, we didn't have a false so we're gonna go to a new _aName
		//So we can destroy the array
		ds_list_destroy(_posList);
	}
	//If we got down here, we can return true?
	return true;
}