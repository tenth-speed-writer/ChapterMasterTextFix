// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function add_fleet_ships_to_combat(fleet, combat){
	var capital_count = array_length(fleet.capital);
	var _ship_id;
	var _ships = fleet_full_ship_array(fleet);
	var _ship_array_length = array_length(_ships);
	for (var i=0;i<array_length(_ship_array_length);i++){
		_ship_id = _ships[i];
		if (obj_ini.ship_hp[_ship_id]<=0 || obj_ini.ship[_ship_id]==""){
			array_delete(_ships,i,1);
			i--;
			_ship_array_length--;
		}
        if (obj_ini.ship_size[_ship_id]>=3) then combat.capital++;
        if (obj_ini.ship_size[_ship_id]==2) then combat.frigate++;
        if (obj_ini.ship_size[_ship_id]==1) then combat.escort++;
        
        array_push(combat.ship_class, obj_ini.ship_class[_ship_id]);
        array_push(combat.ship, obj_ini.ship[_ship_id]);
        array_push(combat.ship_id, _ship_id);
        array_push(combat.ship_size, obj_ini.ship_size[_ship_id]);
        array_push(combat.ship_leadership, 100);
        array_push(combat.ship_hp, obj_ini.ship_hp[_ship_id]);
        array_push(combat.ship_maxhp, obj_ini.ship_maxhp[_ship_id]);
        array_push(combat.ship_conditions, obj_ini.ship_conditions[_ship_id]);
        array_push(combat.ship_speed, obj_ini.ship_speed[_ship_id]);
        array_push(combat.ship_turning, obj_ini.ship_turning[_ship_id]);
        array_push(combat.ship_front_armour, obj_ini.ship_front_armour[_ship_id]);
        array_push(combat.ship_other_armour, obj_ini.ship_other_armour[_ship_id]);
        array_push(combat.ship_weapons, obj_ini.ship_weapons[_ship_id]);
        
        array_push(combat.ship_wep, obj_ini.ship_wep[_ship_id]);
        array_push(combat.ship_wep_facing, obj_ini.ship_wep_facing[_ship_id]);
        array_push(combat.ship_wep_condition, obj_ini.ship_wep_condition[_ship_id]);
        
        array_push(combat.ship_capacity, obj_ini.ship_capacity[_ship_id]);
        array_push(combat.ship_carrying, obj_ini.ship_carrying[_ship_id]);
        array_push(combat.ship_contents, obj_ini.ship_contents[_ship_id]);
        array_push(combat.ship_turrets, obj_ini.ship_turrets[_ship_id]);		
	}
}