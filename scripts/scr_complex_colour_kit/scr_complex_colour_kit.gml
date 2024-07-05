function coord_relevative_positions(coords, xx, yy){
	return [coords[0]+xx, coords[1]+yy,coords[2]+xx, coords[3]+yy];
}

function colour_item(xx,yy) constructor{
	self.xx=xx;
	self.yy=yy;
    static scr_unit_draw_data = function(){
        map_colour = {
            left_leg_lower : 0,
            left_leg_upper : 0,
            left_leg_knee : 0,
            right_leg_lower : 0,
            right_leg_upper : 0,
            right_leg_knee : 0,
            metallic_trim : 0,
            right_trim : 0,
            left_trim : 0,
            left_chest : 0,
            right_chest : 0,
            left_thorax : 0,
            right_thorax : 0, 
            left_pauldron : 0,
            left_arm : 0,
            left_hand : 0,
            right_pauldron: 0,
            right_arm : 0,
            right_hand : 0,
            left_head : 0,
            right_head: 0, 
            left_muzzle: 0,
            right_muzzle: 0,
            eye_lense :0,                                
        }
    }

    static image_location_maps = {
    		left_leg_lower : [103,165, 148,217],
            left_leg_upper : [83,107, 119,134],
            left_leg_knee : [105,138, 126,159],
            right_leg_lower : [15,165, 57,218],
            right_leg_upper : [43,107, 73,139],
            right_leg_knee : [35,138, 58,160],
            metallic_trim : [70,53, 100,70],
            right_trim :  0,
            left_trim : 0,
            left_chest : [84,72, 108,92],
            right_chest : [50,73, 82,103],
            left_thorax : 0,
            right_thorax : 0, 
            left_pauldron :[114,31, 150,67],
            right_pauldron: [19,31, 43,71],
            left_head : [81,15, 94,30],	
            right_head: [68,15, 81,31],	
            left_muzzle: [82,32, 90,42],	
            right_muzzle: [73,32, 82,42],	
            eye_lense :0,
            left_arm : 0,
            left_hand : 0,
            right_arm : 0,
            right_hand : 0,                                
    }
    static lower_left = ["left_leg_lower","left_leg_upper","left_leg_knee"];
    static lower_right = ["right_leg_lower","right_leg_upper","right_leg_knee"];
    static upper_left =  ["left_chest","left_arm","left_hand"]; 
    static chest =  ["left_chest", "right_chest"];
    static upper_right = ["right_chest","right_arm","right_hand"];    
    static legs = ["left_leg_lower","left_leg_upper","left_leg_knee","left_right_lower","left_right_upper","left_right_knee"];
    static head_set = ["left_head", "right_head","left_muzzle", "right_muzzle"];

    static set_pattern = function(col, pattern){
        for (var i=0 ;i<array_length(pattern);i++){
            map_colour[$ pattern[i]] = col;
        }
    }
    colour_pick=false;
    static draw_base = function(){
    	if (is_struct(colour_pick)){
    		var action = colour_pick.draw();
    		if (action == "destroy"){
    			colour_pick=false;
    		} else {
    			if (colour_pick.chosen!=-1){
    				map_colour[$ colour_pick.area] = colour_pick.chosen;
    			}
    		}
    	}

		shader_set(full_livery_shader);
		var spot_names = struct_get_names(map_colour);
		for (var i=0;i<array_length(spot_names);i++){
			var colour = map_colour[$ spot_names[i]];
			var colour_set = [obj_creation.col_r[colour]/255, obj_creation.col_g[colour]/255, obj_creation.col_b[colour]/255];
			shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, spot_names[i]), colour_set);
		}		
		//draw_sprite(sprite_index, 0, x, y);
		draw_sprite(spr_mk7_complex, 0, xx, yy);
		draw_sprite(spr_mk7_complex, 2, xx, yy);  	
		draw_sprite(spr_mk7_complex, 3, xx, yy); 		
		draw_sprite(spr_mk7_complex, 1, xx, yy);	
    	//draw_sprite(xx,yy,2,spr_mk7_full_colour);
    	//draw_sprite(xx,yy,3,spr_mk7_full_colour);
    	shader_reset();    
    	var map_names = struct_get_names(image_location_maps);
    	for (var i=0;i<array_length(map_names);i++){
    		if (!is_array(image_location_maps[$map_names[i]])) then continue;
    		var rel_position = coord_relevative_positions(image_location_maps[$map_names[i]],xx, yy);
    		if (scr_hit(rel_position)){
    			tooltip_draw(map_names[i]);
    		}
    		if (point_and_click(rel_position)){
    			colour_pick = new colour_picker(xx, yy);
    			colour_pick.area = map_names[i];
    			colour_pick.title = map_names[i];
    		}
    	}
    }
}


function colour_picker(xx,yy) constructor{
	x=xx;
	x=yy;
	chosen = -1;
	count_destroy=false;
	static draw = function(){
		if (count_destroy) then return "destroy";
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(144,550,title,0.6,0.6,0);
        rows = 4;
        columns = 10;
        var column;
        var current_color = 0;
        var row = 0;
        repeat(rows) {
            row += 1;
            column = 0;
            repeat(columns) {
                column += 1;
                if (current_color < global.colors_count) {
                    draw_set_color(make_color_rgb(obj_creation.col_r[current_color], obj_creation.col_g[current_color], obj_creation.col_b[current_color]));
                    var x1, x2, y1, y2;
                    x1 = 6 + (column * 40);
                    y1 = 541 + (row * 40);
                    x2 = 46 + (column * 40);
                    y2 = 581 + (row * 40);
                    draw_rectangle(x1, y1, x2, y2, 0);
                    draw_set_color(38144);
                    draw_rectangle(x1, y1, x2, y2, 1);
                    if (scr_hit(x1, y1, x2, y2) = true) {
                        draw_set_color(c_white);
                        draw_set_alpha(0.2);
                        draw_rectangle(x1, y1, x2, y2, 0);
                        draw_set_alpha(1);
                        chosen = current_color;
			            if (mouse_check_button_pressed(mb_left)) {
			               count_destroy=true;
			            }                        
                    }
                    current_color += 1;
                }
            }
        }
        
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14b);
        draw_set_color(38144);
        draw_rectangle(334 - (string_width("Close") / 2), 742, 334 + (string_width("Close") / 2), 762, 0);
        draw_set_color(0);
        draw_text(334, 743, "Close");
        if (scr_hit(334 - (string_width("Close") / 2), 742, 334 + (string_width("Close") / 2), 762) = true) {
            draw_set_color(c_white);
            draw_set_alpha(0.2);
            draw_rectangle(634 - (string_width("Close") / 2), 742, 334 + (string_width("Close") / 2), 762, 0);
            draw_set_alpha(1);
            if (mouse_check_button_pressed(mb_left)) {
               return "destroy";
            }
        }

        if (!scr_hit(130,536,545,748) && mouse_check_button_pressed(mb_left)) {
        }
        draw_set_alpha(1);		
	}
}