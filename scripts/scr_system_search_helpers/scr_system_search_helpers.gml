// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function scr_get_planet_with_feature(star, feature){
	for(var i = 1; i <= star.planets; i++){
		if(planet_feature_bool(star.p_feature[i], feature) == 1)
			{
				return i;
			}
		}
	return -1;
}

//TODO make an adaptive allies system
function NSystemSearchHelpers() constructor{
	static default_allies = [
		eFACTION.Player,
		eFACTION.Imperium,
		eFACTION.Mechanicus,
		eFACTION.Inquisition,
		eFACTION.Ecclesiarchy
	]
}
global.SystemHelps = new NSystemSearchHelpers();

function scr_star_has_planet_with_feature(star, feature){
	return scr_get_planet_with_feature(star, feature) != -1;
}

function scr_is_planet_owned_by_allies(star, planet_idx) {
	if planet_idx < 1 //1 because weird indexing starting at 1 in this game
		return false;
	return array_contains(global.SystemHelps.default_allies, star.p_owner[planet_idx])
}

function scr_is_star_owned_by_allies(star) {
	return array_contains(global.SystemHelps.default_allies, star.owner)
}

function scr_get_planet_with_type(star, type){
	for(var i = 1; i <= star.planets; i++){
		if(star.p_type[i] == type)
			{
				return i;
			}
		}
	return -1;
}
function planets_without_type(type,star="none"){
	var return_planets = [];
	if (star=="none"){
		for(var i = 1; i <= planets; i++){
			if(p_type[i] != type){
				array_push(return_planets, i);
			}
		}
	} else {
		with (star){
			return_planets = planets_without_type(type);
		}
	}
	return return_planets;
}

function scr_star_has_planet_with_type(star, type){
	return scr_get_planet_with_type(star,type) != -1;
}

function scr_get_planet_with_owner(star, owner){
	for(var i = 1; i <= star.planets; i++){
		if(star.p_owner[i] == owner)
			{
				return i;
			}
		}
	return -1;
}

function scr_star_has_planet_with_owner(star, owner){
	return scr_get_planet_with_owner(star,owner) != -1;
}

function scr_get_stars() {
	var stars = [];
	with(obj_star){
		array_push(stars,id);
	}
	return stars;
}

function planet_imperium_ground_total(planet_check){
    return p_guardsmen[planet_check]+p_pdf[planet_check]+p_sisters[planet_check]+p_player[planet_check];
}

function star_by_name(search_name){
	with(obj_star){
		if (name = search_name){
			return self;
		}
	}
	return "none";
}

function distance_removed_star(origional_x,origional_y, star_offset = choose(2,3), disclude_hulk=true, disclude_elder=true, disclude_deads=true){
	var from = instance_nearest(origional_x,origional_y,obj_star);
    for(var i=0; i<star_offset; i++){
        from=instance_nearest(origional_x,origional_y,obj_star);
        with(from){
        	instance_deactivate_object(id);
        };
        from=instance_nearest(origional_x,origional_y,obj_star);
        if (instance_exists(from)){
	        if (disclude_elder && from.owner==eFACTION.Eldar){
	        	i--;
	        	instance_deactivate_object(from);
	        	continue;
	        }
	        if (disclude_deads){
	        	if (is_dead_star(from)){
		        	i--;
		        	instance_deactivate_object(from);
		        	continue;        		
	        	}
	        }
	    }        
    }
    //from=instance_nearest(origional_x,origional_y,obj_star);
    instance_activate_object(obj_star);
    return from;     
}
function nearest_star_with_ownership(xx,yy, ownership){
	var nearest = "none"
	var total_stars =  instance_number(obj_star);
	var i=0;
	if (!is_array(ownership)){
		ownership = [ownership];
	}
	while (nearest=="none" && i<total_stars){
		i++;
		var cur_star =  instance_nearest(xx,yy, obj_star);
		if (array_contains(ownership, cur_star.owner)){
			nearest=cur_star.id;
		} else {
			instance_deactivate_object(cur_star.id);
		}
	}
	instance_activate_object(obj_star);
	return nearest;
}

function adjust_influence(faction, value, planet){
	p_influence[planet][faction]+=value;
	var total_influence =  array_reduce(p_influence[planet], array_sum,1);
	var loop=0;
	if (total_influence>100){
		var difference = total_influence-100;
		while (difference>0 && loop<100){
			loop++;
			for (i=0;i<15;i++){
				if (p_influence[planet][i]>0){
					p_influence[planet][i]--;
					difference--;
				}
			}
		}
	} else if (total_influence<0){
		while (total_influence<0 && loop<100){
			loop++;
			for (i=0;i<15;i++){
				if (p_influence[planet][i]<0){
					p_influence[planet][i]++;
					total_influence++;
				}
			}
		}
	}
}

function planet_numeral_name(planet, star="none"){
	if (star=="none"){
		return $"{name} {scr_roman(planet)}";
	} else {
		with (star){
			return $"{name} {scr_roman(planet)}";
		}		
	}
}

function new_star_event_marker(colour){
    var bob=instance_create(x+16,y-24,obj_star_event);
    bob.image_alpha=1;
    bob.image_speed=1;
    bob.color=colour;
}

function is_dead_star(star="none"){
	var dead_star=true;
	if (star=="none"){
		for (i=1;i<=planets;i++){
			if (p_type[i] !="dead"){
				dead_star=false;
				break;
			}
		}
	} else {
		with (star){
			dead_star = is_dead_star();
		}
	}
	return dead_star;
}

function scr_create_space_hulk(xx,yy){
	var hulk = instance_create(xx,yy,obj_star); 
    hulk.space_hulk=1;
    hulk.p_type[1]="Space Hulk";
    hulk.name=global.name_generator.generate_hulk_name();	
    return hulk;
}

function scr_faction_string_name(faction){
	name = "";
	switch (faction){
		case eFACTION.Imperium:
			name = "Imperium";
			break;
		case eFACTION.Mechanicus:
			name = "Mechanicus";
			break;
		case eFACTION.Inquisition:
			name = "Inquisition";
			break;
		case eFACTION.Ecclesiarchy:
			name = "Ecclesiarchy";
			break;	
		case eFACTION.Eldar:
			name = "Eldar";
			break;	
		case eFACTION.Tau:
			name = "Tau";
			break;																
	}
	return name;
}

function scr_faction_string_name(faction){
	name = "";
	switch (faction){
		case eFACTION.Imperium:
			name = "Imperium";
			break;
		case eFACTION.Mechanicus:
			name = "Mechanicus";
			break;
		case eFACTION.Inquisition:
			name = "Inquisition";
			break;
		case eFACTION.Ecclesiarchy:
			name = "Ecclesiarchy";
			break;	
		case eFACTION.Eldar:
			name = "Eldar";
			break;	
		case eFACTION.Tau:
			name = "Tau";
			break;																
	}
	return name;
}

function scr_planet_image_numbers(p_type){
	var image =0;
	image_map = ["lava","lava", "Desert","Forge","Hive","Death","Agri","Feudal","Temperate","Ice","Dead","Daemon","Craftworld","","Space Hulk", "", "Shrine"];
	for (var i=0;i<array_length(image_map);i++){
		if (image_map[i] == p_type) return i;
	}
	return image;
}
//function scr_get_player_fleets() {
//	var player_fleets = [];
//	with(obj_p_fleet){
//		array_push(player_fleets,id);
//	}
//	return player_fleets;
//}