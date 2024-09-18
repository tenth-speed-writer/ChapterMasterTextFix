
//function fr tallying arrays
function array_sum(_prev, _curr, _index) {
    return _prev + _curr;
}



//to be run within with scope
function set_fleet_target(targ_x, targ_y, final_target){
	action_x = targ_x;
	action_y = targ_y;
	target = final_target;
	action_eta=floor(point_distance(x,y,targ_x,targ_y)/128)+1;
}

function fleets_next_location(fleet="none"){
	var targ_location ="none";
	if (fleet=="none"){
		if (action!=""){
	        var goal_x=action_x;
	        var goal_y=action_y;
	        targ_location=instance_nearest(goal_x,goal_y,obj_star);
		} else {
			targ_location=instance_nearest(x,y,obj_star);
		}		
	} else if (instance_exists(fleet)){
		with (fleet){
			targ_location = fleets_next_location();
		}
	}
	return targ_location;
}
function chase_fleet_target_set(){
	var targ_location = fleets_next_location(target);
	if (targ_location!="none"){
		action_x=targ_location.x;
	    action_y=targ_location.y;
	    action="";
	    set_fleet_movement();
	}
}

function fleet_intercept_time_calculate(target_intercept){
	var intercept_time = -1
	targ_location = fleets_next_location(target_intercept);
	if (instance_exists(targ_location)){
		intercept_time=floor(point_distance(x,y,action_x,action_y)/action_spd)+1;
	}
	return intercept_time;
}


function get_largest_player_fleet(){

	var chosen_fleet = "none";
	if instance_exists(obj_p_fleet){
		with(obj_p_fleet){
			if (point_in_rectangle(x, y, 0, 0, room_width, room_height)){
				if (chosen_fleet=="none"){
					chosen_fleet=self;
					continue;
				}
				if (!(capital_number==0 && chosen_fleet.capital_number==0)){
					if (capital_number>chosen_fleet.capital_number){
						chosen_fleet = self;
					}
				} else if (!(frigate_number==0 && chosen_fleet.frigate_number==0)) {
					if (frigate_number>chosen_fleet.frigate_number){
						chosen_fleet = self;
					}
				}else if (!(escort_number==0 && chosen_fleet.escort_number==0)) {
					if (escort_number>chosen_fleet.escort_number){
						chosen_fleet = self;
					}
				}
			}
		}
	}
	return chosen_fleet;
}

function set_fleet_movement(fastest_route = true){
	if (action!=""){
	    var sys, sys_dist, mine, connected, fleet, cont;
	    sys_dist=9999;connected=0;cont=0;
	    
	    fleet=instance_id_get( 0 );
	    sys=instance_nearest(action_x,action_y,obj_star);
	    sys_dist=point_distance(action_x,action_y,sys.x,sys.y);
	    act_dist=point_distance(x,y,sys.x,sys.y);
	    mine=instance_nearest(x,y,obj_star);

	    connected = determine_warp_join(mine, sys);
	    
	    var eta=0;
	    eta=floor(point_distance(x,y,action_x,action_y)/action_spd)+1;
	    if (connected=0) then eta=eta*2;
	    if (connected=1) then connected=1;
	    
	    if (owner=eFACTION.Inquisition) and (action_eta<2) then action_eta=2;
	    // action_x=sys.x;
	    // action_y=sys.y;
	    action="move";
	    
	    if (owner != eFACTION.Eldar) and (mine.storm>0) then action_eta+=10000;
	    
	    x=x+lengthdir_x(24,point_direction(x,y,sys.x,sys.y));
	    y=y+lengthdir_y(24,point_direction(x,y,sys.x,sys.y));
	}


	else if (action==""){
	    var sys, sys_dist, mine, connected, fleet, cont, target_dist;
	    sys_dist=9999;connected=0;cont=0;target_dist=0;
	    if (fastest_route){
	    	var star_travel = new fastest_route_algorithm(x,y,action_x,action_y, self.id);
	    	var targ = star_by_name(star_travel[0]);
	    	if (targ!="none"){
	    		array_delete(star_travel,0,1);
	    		complex_route = star_travel
	    		action_x = target_planet.x;
				action_y = target_planet.y;
	    		set_fleet_movement(false);
	    	} else {
	    		set_fleet_movement(false);
	    	}
	    } else {

		    fleet=id;
		    sys=instance_nearest(action_x,action_y,obj_star);
		    sys_dist=point_distance(action_x,action_y,sys.x,sys.y);
		    if (target!=0) and (instance_exists(target)) then target_dist=point_distance(x,y,target.action_x,target.action_y);
		    act_dist=point_distance(x,y,sys.x,sys.y);
		    mine=instance_nearest(x,y,obj_star);
		    
		    // if (owner = eFACTION.Tau) then mine.tau_fleets-=1;
		    // if (owner = eFACTION.Tau) and (image_index!=1) then mine.tau_fleets-=1;
		    // mine.present_fleets-=1;
		    
		    connected = determine_warp_join(sys, mine);
		    cont=1;
		    
		    
		    if (cont=1){
		        cont=20;
		    }
		    
		    
		    if (cont=20){// Move the entire fleet, don't worry about the other crap
		        var eta=0;
		        
		        if (trade_goods!="") and (owner != eFACTION.Tyranids) and (owner != eFACTION.Chaos) and (string_count("Inqis",trade_goods)=0) and (string_count("merge",trade_goods)=0)and (string_count("_her",trade_goods)=0) and (trade_goods!="cancel_inspection") and (trade_goods!="return"){
		            if (target!=0) and (instance_exists(target)){
		                if (target.action!=""){
		                    if (target_dist>sys_dist){
		                        action_x=target.action_x;
		                        action_y=target.action_y;
		                        sys=instance_nearest(action_x,action_y,obj_star);}
		                }
		            }
		        }        
		        
		        eta = calculate_fleet_eta(x,y,action_x,action_y,instance_exists(target),instance_exists(orbiting),warp_able);
		        
		        if (action_eta<=0) or (owner  != eFACTION.Inquisition){
		            action_eta=eta;
		            if (owner  = eFACTION.Inquisition) and (action_eta<2) and (string_count("_her",trade_goods)=0) then action_eta=2;
		        }
		        
		        if (owner != eFACTION.Eldar) and (mine.storm>0) then action_eta+=10000;
		        
		        // action_x=sys.x;
		        // action_y=sys.y;
		        action="move";
		        
		        if (minimum_eta>action_eta) and (minimum_eta>0) then action_eta=minimum_eta;
		        minimum_eta=0;
		        if (etah>action_eta) and (etah!=0) then action_eta=etah;
		        
		        x=x+lengthdir_x(24,point_direction(x,y,sys.x,sys.y));
		        y=y+lengthdir_y(24,point_direction(x,y,sys.x,sys.y));
		    }
		}
	}

	etah=0;	
}


//TODO build into unit struct
function load_unit_to_fleet(fleet, unit){
	var loaded = false;
	var all_ships = fleet_full_ship_array(fleet);
	var i, ship_ident;

	for (i=0;i<array_length(all_ships);i++){
		ship_ident = all_ships[i];
		  if (obj_ini.ship_capacity[ship_ident]>obj_ini.ship_carrying[ship_ident]){
		  	obj_ini.ship_carrying[ship_ident]+=unit.size;
		  	unit.planet_location=0;
		  	obj_ini.loc[unit.company][unit.marine_number]=obj_ini.ship_location[ship_ident];
		  	unit.ship_location=ship_ident;
		  	loaded=true;
		  	break
		  }
	}
	return loaded;
}
function calculate_fleet_eta(xx,yy,xxx,yyy, fleet_speed,star1=true, star2=true,warp_able=false){
	var warp_lane = false;
	eta = 0;
		//Some duke unfinished webway stuff copied here for reference
		/*for (var w = 1;w<5;w++){
			if (planet_feature_bool(mine.p_feature[w], P_features.Webway)==1) then web1=1;
			if (planet_feature_bool(sys.p_feature[w], P_features.Webway)==1) then web2=1;
		}*/
	if (star1 && star2){
		star1 = instance_nearest(xx,yy, obj_star);
		star2 = instance_nearest(xxx,yyy, obj_star);
		warp_lane = determine_warp_join(star1.id,star2.id);
	} else if (star1){
		star1 = instance_nearest(xx,yy, obj_star);
	}
	eta=floor(point_distance(xx,yy,xxx,yyy)/fleet_speed)+1;
	if (!warp_lane || !warp_able) then eta*=2;
	if (warp_lane) then eta = ceil(eta/warp_lane);
	if (instance_exists(star2)){
		if (star2.storm){
			eta += 10000;
		}
	}
	return eta;
}

function fastest_route_algorithm(start_x,start_y, xx,yy,fleet, start_from_star=false) constructor{
	var star_number = instance_number(obj_star);
	target = instance_nearest(xx,yy,obj_star);
	self.fleet=fleet;
	self.ship_speed = fleet.action_spd;
	worst_case = (floor(point_distance(start_x,start_y, xx,yy)/ship_speed+2))*2;
	start_star = instance_nearest(start_x,start_y,obj_star).id;
	unvisited_stars = [
		[start_star,-1, [], false],
		[target,-1, [], false],
	];

	for (var i = 0; i < star_number; i++){
		if (instance_find(obj_star,i).id == start_star.id) then continue;
		if (instance_find(obj_star,i).id == target.id) then continue;
		var i_star = instance_find(obj_star,i);
		for (var s=1;s<array_length(unvisited_stars);s++){
			var s_star = unvisited_stars[s][0];
			if (point_distance(i_star.x,i_star.y, start_star.x,start_star.y)<point_distance(s_star.x,s_star.y, start_star.x,start_star.y)){
				array_insert(unvisited_stars, s, [i_star,-1, [], false]);
				break;
			}
		}
	};

	function find_star_travel_distances(cur_star_id){
		var current_star = unvisited_stars[cur_star_id][0];
		var cur_travel = unvisited_stars[cur_star_id][1];
		var eta;
		var warp_lane = false;
		for (var s=cur_star_id+1; s<array_length(unvisited_stars);s++){
			var visit_data = unvisited_stars[s];
			if (visit_data[3]) then continue;
			visit_star = unvisited_stars[s][0];
			eta = calculate_fleet_eta(current_star.x,current_star.y,visit_star.x,visit_star.y, ship_speed, true, true, fleet.warp_able);
			if (eta){
				if (eta+cur_travel<visit_data[1]
					|| visit_data[1]==-1 ){
					visit_data[1] = eta+cur_travel;
					visit_data[2] =[];
					for (var c=0;c<array_length(unvisited_stars[cur_star_id][2]);c++){
						array_push(visit_data[2], unvisited_stars[cur_star_id][2][c]);
					}
					if (!array_contains(visit_data[2], current_star.id)){
						array_push(visit_data[2], current_star.id);
					};
				}
			} else {
				visit_data[3] = true;
			}
			/*if (cur_star_id==0){
				if (eta>worst_case){
					visit_data[3] = true;
				}
			}*/
			unvisited_stars[s] = visit_data;
		}
		unvisited_stars[cur_star_id][3] = true;
	}

	for (var i=0;i<array_length(unvisited_stars);i++){
		if (!unvisited_stars[i][3]){
			find_star_travel_distances(i);
		}
	}

	final_route_info = unvisited_stars[array_length(unvisited_stars)-1];
	static draw_route = function(){
	    draw_set_color(c_blue);
        draw_set_alpha(1);            
        var cur_star = start_star;
        for (var i=0;i<array_length(final_route_info[2]);i++){
             draw_line_dashed(cur_star.x,cur_star.y,final_route_info[2][i].x,final_route_info[2][i].y,16,0.5);
             cur_star = final_route_info[2][i];
        }
        draw_line_dashed(cur_star.x,cur_star.y,final_route_info[0].x,final_route_info[0].y,16,0.5);
        var eta = $"ETA {final_route_info[1]+1}";
        if (obj_controller.zoomed=0) then draw_text_transformed(cur_star.x+16,cur_star.y+15,eta,1,1,0);
        if (obj_controller.zoomed=1) then draw_text_transformed(cur_star.x+24,cur_star.y+40,eta,5,5,0);             
	}
	static final_array_path = function(){
		var final_path = final_route_info[2];
		var path_store = [];
		array_push(final_path, final_route_info[0]);
		for (var i=0;i<array_length(final_path);i++){
			array_push(path_store, final_path[i].name);
		}
		return path_store;
	}
}



function calculate_action_speed(capitals=true, frigates=true, escorts=true){
	var fleet_speed=128;
	if (capitals>0){
	    fleet_speed=100;
	} else if (frigates>0){
	    fleet_speed=128;
	}else if (escorts>0){
	    fleet_speed=174;
	}
	if (obj_controller.stc_ships>=6) and (fleet_speed>=100) then fleet_speed*=0.8;
	return fleet_speed;
}




function create_complex_star_routes(){
	var north=[], east=[], west=[], south=[], central=[];
	with (obj_star){
		if (x<700) then array_push(west, id);
		if (y<700) then array_push(north, id);
		if (x>room_width-700) then array_push(east, id);
		if (y>room_height-700) then array_push(south, id);
		if (x>700) && (y>700) && (x<room_width-700) && (x<room_width-700){
			array_push(central, id);
		}
		if (irandom(10)){
			var nearest_star = distance_removed_star(x,y,1,true,true,false);
			if (determine_warp_join(nearest_star.id, self.id)){
				array_push(warp_lanes, [distance_removed_star(x,y,2,true,true,false).name, 1]);
			} else {
				array_push(warp_lanes, [nearest_star.name, 1]);
			}
		} else {
			array_push(warp_lanes, [distance_removed_star(x,y,irandom_range(3, 6),true,true,false).name, 1]);
		}
	}
	full_loci = [north, east,west,south,central];
	var current_start,set, join_set, total_joins;
	for (var i=0;i<array_length(full_loci);i++){
		if (irandom(1)) then continue;
		set = full_loci[i];
		if (array_length(set) == 0) then continue;
		current_start = set[irandom(array_length(set)-1)];
		total_joins =0;
		for (var s=0;s<array_length(full_loci);s++){
			if (!irandom(1)) then continue;
			join_set = full_loci[s];
			var set_count = array_length(join_set);
			if (s==i || set_count == 0)then continue;
			/*//if (irandom(1)) then continue;
			for (var i=0;i<array_length(full_loci[s])i++){
				//if !(irandom(2)) then
			}*/
			join_star = join_set[irandom(set_count-1)];
			array_push(current_start.warp_lanes, [join_star.name, 4]);
			total_joins++;
			if (total_joins>3) then break;
		}
	}
}

function determine_warp_join(star_a, star_b){
	var lane;
	var lane_strength = 0;
	for (var i=0;i<array_length(star_a.warp_lanes);i++){
		lane = star_a.warp_lanes[i];
		if (lane[0] == star_b.name){
			lane_strength = lane[1];
		}
	}
	if (lane_strength==0){
		for (var i=0;i<array_length(star_b.warp_lanes);i++){
			lane = star_b.warp_lanes[i];
			if (lane[0] == star_a.name){
				lane_strength = lane[1];
			}
		}		
	}
	return lane_strength;
}

//TODO further split this shite up
function fleet_arrival_logic(){
	var cur_star, sta, steh_dist, old_x, old_y;
    cur_star=instance_nearest(action_x,action_y,obj_star);
    sta=instance_nearest(action_x,action_y,obj_star);
    
    // cur_star.present_fleets+=1;if (owner = eFACTION.Tau) then cur_star.tau_fleets+=1;
    
    
    if (owner = eFACTION.Mechanicus){
        if (string_count("spelunk1",trade_goods)=1){
            trade_goods="mars_spelunk2";action_x=home_x;action_y=home_y;action_eta=52;exit;
        }
        if (string_count("spelunk2",trade_goods)=1){
            // Unload techmarines nao plz
            scr_mission_reward("mars_spelunk",instance_nearest(home_x,home_y,obj_star),1);
            instance_destroy();
        }
    }
    
    
    //TODO create oppertunity to purge new colonisers if they have taint and the player has garrisons or control of the planet
    if (fleet_has_cargo("colonize")){
		deploy_colonisers(cur_star);
    }
    
    
    
    
    if (trade_goods="return") and (action="move"){
        // with(instance_nearest(x,y,obj_star)){present_fleets-=1;}
        instance_destroy();
    }
    
    
    
    
    
    if (trade_goods="female_her") or (trade_goods="male_her"){
        // if (owner  = eFACTION.Inquisition) then show_message("A");
        
        var next;next=0;
        if (!instance_exists(obj_p_fleet)) then next=1;
        if (instance_exists(obj_p_fleet)){
            with(obj_p_fleet){if (action!="") then instance_deactivate_object(id);}
            var pfa;pfa=instance_nearest(x,y,obj_p_fleet);
            if (point_distance(x,y,pfa.x,pfa.y)<40) then next=2;
            if (point_distance(x,y,pfa.x,pfa.y)>=40) then next=1;
        }
        instance_activate_object(obj_p_fleet);
        if (next=1){
            action_x=choose(room_width*-1,room_width*2);
            action_y=choose(room_height*-1,room_height*2);
            alarm[4]=1;trade_goods="|DELETE|";
            action_spd=256;action="";
            obj_controller.disposition[4]-=15;
            scr_popup("Inquisitor Mission Failed","The radical Inquisitor has departed from the planned intercept coordinates.  They will now be nearly impossible to track- the mission is a failure.","inquisition","");
            scr_event_log("red","Inquisition Mission Failed: The radical Inquisitor has departed from the planned intercept coordinates.");
        }
        if (next=2){
            action="";y-=24;
            var tixt,gender;
            if (trade_goods="male_her") then gender="he";if (trade_goods="female_her") then gender="she";
            tixt="You have located the radical Inquisitor.  As you prepare to destroy their ship, and complete the mission, you recieve a hail- it appears as though "+string(gender)+" wishes to speak.";
            if (trade_goods="male_her") then scr_popup("Inquisitor Located",tixt,"inquisition","1");
            if (trade_goods="female_her") then scr_popup("Inquisitor Located",tixt,"inquisition","2");
        }
        instance_deactivate_object(id);
        instance_deactivate_object(id);
        exit;
    }
    
    
    
    
    
    
    if (navy==0){
        var cancel;
		cancel=false;
        if (string_count("Inqis",trade_goods)>0) then cancel=true;
        if (string_count("merge",trade_goods)>0) then cancel=true;
        if (trade_goods="cancel_inspection") then cancel=true;
        if (trade_goods="|DELETE|") then cancel=true;
        if (trade_goods="return") then cancel=true;
        if (string_count("_her",trade_goods)>0) then cancel=true;
        if (string_count("investigate_dead",trade_goods)>0) then cancel=true;
        if (string_count("spelunk",trade_goods)>0) then cancel=true;
        if (string_count("BLOOD",trade_goods)>0) then cancel=true;
        if (fleet_has_cargo("ork_warboss")) cancel=true;
        if (trade_goods="csm") then cancel=true;
        
        if (trade_goods!="") and (owner!=eFACTION.Tyranids) and (owner!=eFACTION.Chaos) and (cancel=false) and ((instance_exists(target)) or (obj_ini.fleet_type=1)) {
            if ((trade_goods!="return") and (target!=noone) and ((target.action!="") or (point_distance(x,y,target.x,target.y)>30))) and (obj_ini.fleet_type!=1) and (navy=0){
                var mah_x,mah_y;
                mah_x=instance_nearest(x,y,obj_star).x;
                mah_y=instance_nearest(x,y,obj_star).y;
                
                if (target!=noone) and (string_count("Inqis",trade_goods)=0){
                    if (instance_exists(target)) {
                        
                        if (target.action!="") or (point_distance(x,y,target.x,target.y)>40){
                       
                            if (target.action!="") {
								action="";
								action_x=target.action_x;
								action_y=target.action_y;
								alarm[4]=1;
								if (owner!=eFACTION.Eldar) then obj_controller.disposition[owner]-=1;exit;}
                            if (target.action="" ){
								action="";
                                action_x=instance_nearest(target.x,target.y,obj_star).x;
                                action_y=instance_nearest(target.x,target.y,obj_star).y;
                                alarm[4]=1;
								if (owner!=eFACTION.Eldar) then obj_controller.disposition[owner]-=1;exit;
                            }
                        }
                    }
                }
            }
            
            
            /*show_message(string(trade_goods));
            show_message(string_count("_her",trade_goods)=0);
            show_message(target);
            show_message(string(point_distance(x,y,target.x,target.y)));
            show_message(target.action);*/
            
            
            
            if (trade_goods!="return") and (string_count("_her",trade_goods)=0) and ((target=noone) or ((point_distance(x,y,target.x,target.y)<=40)) and ((target.action="") or (obj_ini.fleet_type=1))){
                with(obj_temp2){instance_destroy();}
                with(obj_temp3){instance_destroy();}
                with(obj_ground_mission){instance_destroy();}
                
                var targ;
                var cur_star=nearest_star_proper(x, y);
                var bleh="";
                if (owner!=eFACTION.Inquisition) 
					bleh=$"{obj_controller.faction[owner]} Fleet finalizes trade at {cur_star.name}.";
                else{
					bleh=$"Inquisitor Ship finalizes trade at {cur_star.name}.";
                }
                debugl(bleh);
                scr_alert("green","trade",bleh,cur_star.x,cur_star.y);
                scr_event_log("",bleh,cur_star.name);
                
                // Drop off here
                if (trade_goods!="stuff") and (trade_goods!="none") then scr_trade_dep();
                
                trade_goods="return";
                if (target!=noone) then target=noone;
                
                if (owner=eFACTION.Eldar){
                	cur_star = nearest_star_with_ownership(xx,yy, eFACTION.Eldar);
                	if (cur_star!="none"){
						cur_star=targ.x;
						cur_star=targ.y;  
                	}                  	
                } else {
                    action_x=home_x;
					action_y=home_y;                   	
                }
                
                action_eta=0;
				action="";

                set_fleet_movement();
            }
            exit;
        }
    }
    
    
    
    
    if (owner=eFACTION.Inquisition) and (string_count("_her",trade_goods)=0){
        if (cur_star.owner  = eFACTION.Player) and (trade_goods="cancel_inspection"){
            instance_deactivate_object(cur_star);
            repeat(choose(1,2)){
                orbiting=instance_nearest(x,y,obj_star);
                instance_deactivate_object(orbiting);
            }
            
            repeat(5){
                orbiting=instance_nearest(x,y,obj_star);
                if (orbiting.owner = eFACTION.Eldar) then instance_deactivate_object(orbiting);
            }
            
            orbiting=instance_nearest(x,y,obj_star);
            action_x=orbiting.x;
            action_y=orbiting.y;
            alarm[4]=1;
            instance_activate_object(obj_star);
            trade_goods+="|DELETE|";
            exit;
        }
    }
    
    
    /*if (owner = eFACTION.Imperium) and (guardsmen>0){// 135 ; guardsmen onto planet
        var en_p,en_planets,land,i;
        i=0;en_planets=0;land=0;
        
        if (sta.x=home_x) and (sta.y=home_y){
            repeat(4){i+=1;
                en_p[i]=0;
                if (sta.p_owner[i]<=5){en_p[i]=1;en_planets+=1;}
            }
            
            if (guardsmen>0) and (en_planets>0){
                land=floor(guardsmen/en_planets);
                i=0;
                repeat(4){i+=1;
                    if (en_p[i]=1){guardsmen-=land;sta.p_guardsmen[i]+=land;}
                }
                if (guardsmen<5) then guardsmen=0;
            }
        }
        if (sta.owner>5) or ((sta.owner  = eFACTION.Player) and (obj_controller.faction_status[eFACTION.Imperium]="War")){
            repeat(4){i+=1;
                en_p[i]=0;
                if (sta.p_player[i]>0) and (obj_controller.faction_status[eFACTION.Imperium]="War"){en_p[i]=1;en_planets+=1;}
            }
            
            if (guardsmen>0) and (en_planets>0){
                land=floor(guardsmen/en_planets);
                i=0;
                repeat(4){i+=1;
                    if (en_p[i]=1){guardsmen-=land;sta.p_guardsmen[i]+=land;}
                }
                if (guardsmen<5) then guardsmen=0;
            }
        }
    }*/
    
    
    
    
    action="";
    if (owner= eFACTION.Imperium){x=action_x;y=action_y-24;if (navy=1) then x=action_x+24;}
    else if (owner= eFACTION.Mechanicus){x=action_x;y=action_y-32;}
    else if (owner= eFACTION.Inquisition){
        x=action_x;
        y=action_y-32;
        if (string_count("DELETE",trade_goods)>0) then instance_destroy();
        if (obj_controller.known[eFACTION.Inquisition]=0) then obj_controller.known[eFACTION.Inquisition]=1;
    }
    if (owner=eFACTION.Eldar){x=action_x-24;y=action_y-24;}
    if (owner=eFACTION.Ork){x=action_x+30;y=action_y;}
    if (owner=eFACTION.Tau) {
        x=action_x-24;y=action_y-24;
        if (instance_exists(obj_p_ship)){
            var p_ship;p_ship=instance_nearest(x,y,obj_p_ship);
            if (p_ship.action="") and (point_distance(x,y,p_ship.x,p_ship.y)<80){
                if (obj_controller.p_known[8]=0) then obj_controller.p_known[8]=1;
            }
        }
    }
    if (owner=eFACTION.Tyranids){
        x=action_x;y=action_y+32;
        var mess,plap;mess=1;plap=99999;plap=instance_nearest(action_x,action_y,obj_p_fleet);
        
        if (instance_exists(plap)){if (point_distance(plap.x,plap.y,action_x,action_y)<80) then mess=0;}
        
        if (mess=1) and (sta.vision!=0){
            scr_alert("red","owner","Contact has been lost with "+string(sta.name)+"!",sta.x,sta.y);
            scr_event_log("red","Contact has been lost with "+string(sta.name)+".");sta.vision=0;}
    }
    if (owner=eFACTION.Chaos){x=action_x-30;y=action_y;}
    if (owner=eFACTION.Necrons){x=action_x+32;y=action_y+32;}
    action_x=0;
    action_y=0;
    
    
    
    
    
    
    // 135 ; fleet chase
    if (string_count("Inqis",trade_goods)>0) and (string_count("fleet",trade_goods)>0) and (string_count("_her",trade_goods)=0) {
        inquisition_fleet_inspection_chase();
    }


    old_x=x;old_y=y;
    x=-100;y=-100;
    
    cur_star=instance_nearest(old_x,old_y,obj_en_fleet);
    var mergus;mergus=0;
    
    mergus=cur_star.image_index;
    if (mergus<3) then mergus=0;
    if (mergus>=3) then mergus=10;
    if (owner = eFACTION.Tau) and (mergus>=3) then mergus=0;
    if (string_count("_her",trade_goods)=0) then mergus=99;// was 999
    
    // Think this might be causing the crash
    if (owner=eFACTION.Tau) and (sta.present_fleet[eFACTION.Imperium]+sta.present_fleet[eFACTION.Player]>=1) 
		and (sta.present_fleet[eFACTION.Tau]=1) and (image_index=1) and (ret=0) then mergus=15;
    if (cur_star.owner=eFACTION.Tau) and (owner=eFACTION.Tau) and (ret=1) then mergus=0;
    
    
    
    
    if (owner=eFACTION.Tau) and (image_index=1){
        // show_message("Tau|||  Other Owner: "+string(cur_star.owner)+"   ret: "+string(ret)+"    mergus: "+string(mergus));
    }
    
    if (owner=eFACTION.Chaos) and (trade_goods="csm") or (trade_goods="Khorne_warband") then mergus=0;
    if (trade_goods="merge") then mergus=0;
    // if (cur_star.owner!=owner) then mergus=0;
    
    
    
    
    if (cur_star.x=old_x) and (cur_star.y=old_y) and (cur_star.owner=self.owner) and (cur_star.action="") and (mergus=1999){// Merge the fleets
        cur_star.escort_number+=self.escort_number;
        cur_star.frigate_number+=self.frigate_number;// show_message("Tau fleet merging");
        cur_star.capital_number+=self.capital_number;
        cur_star.guardsmen+=self.guardsmen;
        
        
        
        cur_star=instance_nearest(old_x,old_y,obj_star);
        // if (cur_star.present_fleets>=1) then cur_star.present_fleets-=1;
        if (owner = eFACTION.Tau){obj_controller.tau_fleets-=1;cur_star.tau_fleets-=1;}
        if (owner = eFACTION.Chaos) then obj_controller.chaos_fleets-=1;
        
        instance_destroy();
    }// End merge fleets
    
    
    
    if (owner=eFACTION.Tau) and (mergus=15){                                               // Get the fuck out
        var new_star, stue;new_star=0;stue=0;ret=1;
        
        
        instance_activate_object(obj_star);// new_star
        stue=instance_nearest(x,y,obj_star);
        
        
        
        if (image_index=1){// Start influence thing
            var  tau_influence;
            var tau_influence_chance=irandom(100)+1;
            var tau_influence_planet=irandom(stue.planets)+1;
            
            with (stue){
                if (p_type[tau_influence_planet]!="Dead"){
                
                    scr_alert("green","owner",$"Tau ship broadcasts subversive messages to {planet_numeral_name(tau_influence_planet)}.",sta.x,sta.y);
                    tau_influence = p_influence[tau_influence_planet][eFACTION.Tau]
                
                    if (tau_influence_chance<=70) and (tau_influence<70){
                    	adjust_influence[tau_influence_planet](eFACTION.Tau, 10, tau_influence_planet);
                        if (p_type[tau_influence_planet]=="Forge") then adjust_influence(eFACTION.Tau, -5, tau_influence_planet);
                    }
                    
                    if (tau_influence_chance<=3) and (tau_influence<70){
                        adjust_influence(eFACTION.Tau, 30, tau_influence_planet);
                        if (p_type[tau_influence_planet]=="Forge") then adjust_influence(eFACTION.Tau, -25, tau_influence_planet);
                    }
                }
            }
        } 
        
        
        
        instance_deactivate_object(stue);
        
        with(obj_star){
        	if (owner != eFACTION.Tau) then instance_deactivate_object(instance_id);
        }
        
        var good;good=0;
        
        repeat(100){
            var xx, yy;
            if (good=0){
                xx=x+choose(random(300),random(300)*-1);
                yy=y+choose(random(300),random(300)*-1);
                new_star=instance_nearest(xx,yy,obj_star);
                if (new_star.owner!=eFACTION.Tau) then with(new_star){instance_deactivate_object(id);}
                if (new_star.owner=eFACTION.Tau) then good=1;
            }
        }
        
        // show_message("Get the fuck out working?: "+string(good));
        
        if (new_star.owner=eFACTION.Tau){
            // show_message("Tau fleet actually fleeing");
            action="";action_x=new_star.x;action_y=new_star.y;alarm[4]=1;
        }
        
        instance_activate_object(obj_star);
        // This appears bugged
    }
    
    
    
    
    
    
    x=old_x;y=old_y;
    
    if (cur_star.x=old_x) and (cur_star.y=old_y) and (cur_star.owner=self.owner) and (cur_star.action="") and ((owner = eFACTION.Tau) or (owner = eFACTION.Chaos)) and (mergus=10) and (trade_goods!="csm") and (trade_goods!="Khorne_warband"){// Move somewhere new
        var stue, stue2;stue=0;stue2=0;
        var goood;goood=0;
        
        with(obj_star){if (planets=1) and (p_type[1]="Dead") then instance_deactivate_object(id);}
        stue=instance_nearest(x,y,obj_star);
        instance_deactivate_object(stue);
        repeat(10){
            if (goood=0){
                stue2=instance_nearest(x+choose(random(400),random(400)*-1),y+choose(random(400),random(400)*-1),obj_star);
                if (owner = eFACTION.Tau) and (stue2.owner = eFACTION.Tau) then goood=1;
                if (owner = eFACTION.Chaos) and (stue2.owner != eFACTION.Chaos) then goood=1;
                if (stue2.planets=0) then goood=0;
                if (stue.present_fleet[eFACTION.Imperium]>0) or (stue.present_fleet[eFACTION.Player]>0) then goood=0;
                if (stue2.planets=1) and (stue2.p_type[1]="Dead") then goood=0;
                }
            }
        action_x=stue2.x;action_y=stue2.y;alarm[4]=1;// stue.present_fleets-=1;
        instance_activate_object(obj_star);
    }
    
    
    // ORKS
    // Right here check to see if the fleet is being useless
    // If yes check for connected planet, see if not owned by orks
    // If not owned by orks then start heading that way
    // If the connected planet is owned by orks then choose a random one within 400 not owned by orks
    
    
    if (owner = eFACTION.Ork){
        
        var kay, temp5, temp6, temp7;
        kay=0;temp5=0;temp6=0;temp7=0;
        
        var cur_star;cur_star=0;// Opposite of what normally is
		//the hell is this jank? Doesn't even make sense since all the tests will fail
        if (owner = eFACTION.Imperium) then cur_star=instance_nearest(x,y+32,obj_star);
        if (owner = eFACTION.Mechanicus) then cur_star=instance_nearest(x,y+32,obj_star);
        if (owner  = eFACTION.Inquisition) then cur_star=instance_nearest(x,y+32,obj_star);
        if (owner = eFACTION.Ork) then cur_star=instance_nearest(x-32,y,obj_star);
        if (owner = eFACTION.Tau) then cur_star=instance_nearest(x+24,y+24,obj_star);
        if (owner = eFACTION.Tyranids) then cur_star=instance_nearest(x,y-32,obj_star);
        if (owner = eFACTION.Chaos) then cur_star=instance_nearest(x+32,y,obj_star);
        
        
        // This is the new check to go along code; if doesn't add up to all planets = 7 then they exit
        
        if (cur_star.planets>=1) and (cur_star.p_type[1]!="Dead") and (cur_star.p_owner[1]!=7){kay=5;exit;}
        if (cur_star.planets>=2) and (cur_star.p_type[2]!="Dead") and (cur_star.p_owner[2]!=7){kay=5;exit;}
        if (cur_star.planets>=3) and (cur_star.p_type[3]!="Dead") and (cur_star.p_owner[3]!=7){kay=5;exit;}
        if (cur_star.planets>=4) and (cur_star.p_type[4]!="Dead") and (cur_star.p_owner[4]!=7){kay=5;exit;}
        
        if (kay=5){// KILL the enemy
            if (cur_star.present_fleet[1]>1) or (cur_star.present_fleet[2]>1) then exit;
        }
        
        if ((cur_star.owner = eFACTION.Chaos) and (image_index>=5) and (owner = eFACTION.Chaos)) or ((owner = eFACTION.Chaos) and (image_index>=5) and (cur_star.planets=0)) then kay=50;

        if (kay=50){
        
            if (owner = eFACTION.Ork) then with(obj_star){if (owner = eFACTION.Ork) then instance_deactivate_object(instance_id);}
        
            repeat(20){
                if (kay=50){
                    temp5=x+choose(random(300),random(300)*-1);temp6=y+choose(random(300),random(300)*-1);
                    temp7=instance_nearest(temp5,temp6,obj_star);
                    
                    if (owner = eFACTION.Ork) and (temp7.owner != eFACTION.Ork) and (temp7.planets>0) and (temp7.image_alpha>=1) then kay=55;
                    if (owner = eFACTION.Tau) and (temp7.owner != eFACTION.Tau) and (temp7.planets>0) and (temp7.image_alpha>=1) then kay=55;
                    if (owner = eFACTION.Chaos) and (temp7.owner != eFACTION.Chaos) and (temp7.planets>0) and (temp7.image_alpha>=1) then kay=55;
                }
            }
        
            if (kay=55) and (instance_exists(temp7)){
                action_x=temp7.x;
                action_y=temp7.y;
                alarm[4]=1;
                // cur_star.present_fleets-=1;
            }
            
            instance_activate_object(obj_star);
        }
       

        instance_activate_object(obj_star);
 
    }


    exit;// end of eta=0	
}


