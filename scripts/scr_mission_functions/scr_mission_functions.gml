// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_new_governor_mission(planet){
	problem = "";
	var planet_type= p_type[planet];
	if (planet_type=="Death"){
		problem = choose("hunt_beast", "provide_garrison");
		accept_time = 6+irandom(30);
	} else if (planet_type == "Hive"){
		problem = choose("Show_of_power", "provide_garrison", "purge_enemies", "raid_black_market");
	} else if (planet_type == "Temperate"){
		problem = choose("provide_garrison", "train_forces", "join_parade");
	}else if (planet_type == "Shrine"){
		problem = choose("provide_garrison", "join_communion");
	}else if (planet_type == "Ice"){
		problem = choose("provide_garrison", "hunt_beast");
	}else if (planet_type == "Lava"){
		problem = choose("provide_garrison", "protect_raiders");
	}else if (planet_type == "Agri"){
		problem = choose("provide_garrison", "protect_raiders", "recover_artifacts");
	}else if (planet_type == "Desert"){
		problem = choose("provide_garrison", "protect_raiders", "recover_artifacts");
	}else if (planet_type == "Feudal"){
		problem = choose("hunt_beast", "protect_raiders");
	}
	var mission_data = {
		stage : "preliminary",
		applicant : "Governor"
	};
	if (problem != ""){
		if (problem == "provide_garrison"){
			if (system_garrison[planet-1].garrison_force) then exit;
			mission_data.reason = choose("stability", "importance");
		} else if (problem=="purge_enemies"){
			var enemy = 0;
			if (planets>1){
				for (var i=1;i<=planets;i++){
					if(i=planet) then continue;
					if (p_owner[i]==eFACTION.Imperium){
						enemy=i;
						break;
					}
				}
			}
			mission_data.target=enemy;
			if (!enemy) then exit;
		}
		add_new_problem(planet,problem, 20+irandom(20), ,mission_data);
	}
}

function has_any_problem_planet(planet, star="none"){
	if (star=="none"){
		for (var i=0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] != ""){
				return true;
			}
		}
	} else {
		with (star){
			return has_any_problem_planet(planet);
		}
	}
	return false;
}


function has_problem_star(problem, star="none"){
	var has_problem = false;
	if (star=="none"){
		for (var i=1;i<planets;i++){
			has_problem = has_problem_planet(i, problem);
			if (has_problem){
				has_problem=i;
				break
			}
		}
	} else {
		with (star){
			has_problem = has_problem_star(problem);
		}
	}
	return has_problem;
}

function has_problem_planet(planet, problem, star="none"){
	if (star=="none"){
		return array_contains(p_problem[planet], problem);
	} else {
		with (star){
			return has_problem_planet(planet, problem);
		}
	}
}
function has_problem_planet_and_time(planet, problem, time,star="none"){
	var had_problem = false;
	if (star=="none"){
		for (var i = 0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] == problem){
				if (p_timer[planet][i] == time){
					had_problem=i;
				}
			}
		}
	} else {
		with (star){
			had_problem=remove_planet_problem(planet, problem)
		}
	}
	return had_problem;	
}
 function has_problem_planet_with_time(planet, problem,star="none"){
	var had_problem = false;
	if (star=="none"){
		for (var i =0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] == problem){
				if (p_timer[planet][i] >0){
					had_problem=i;
				}
			}
		}
	} else {
		with (star){
			had_problem=remove_planet_problem(planet, problem)
		}
	}
	return had_problem;	
}

function find_problem_planet(planet, problem, star="none"){
	if (star=="none"){
		for (var i =1;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] == problem){
				return i;
			}
		}
	} else {
		with (star){
			return find_problem_planet(planet, problem);
		}
	}
	return -1;
}

function remove_planet_problem(planet, problem, star="none"){
	var had_problem = false;
	if (star=="none"){
		for (var i =1;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] == problem){
				p_problem[planet][i]="";
				p_timer[planet][i]=-1;
				p_problem_other_data[planet][i]={};
				had_problem=true;
			}
		}
	} else {
		with (star){
			had_problem=remove_planet_problem(planet, problem);
		}
	}
	return had_problem;	
}

function open_problem_slot(planet, star="none"){
	if (star=="none"){
		for (var i=0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] == ""){
				return i;
			}
		}
	} else {
		with (star){
			return open_problem_slot(planet)
		}
	}
	return -1;
}

function remove_star_problem(problem, star="none"){
	if (star=="none"){
		for (var i=1;i<=planets;i++){
			remove_planet_problem(i, problem);
		}
	} else {
		with (star){
			remove_remove_star_problem(problem);
		}
	}
}

function problem_count_down(planet, count_change=1){
	for (var i=1;i<array_length(p_problem[planet]);i++){
		if (p_problem[planet][i]!=""){
			p_timer[planet][i]-=count_change;
			if (p_timer[planet][i]==-5){
				p_problem[planet][i]="";
				p_timer[planet][i]=-1;
			}
		}
	}
}

function add_new_problem(planet, problem, timer,star="none", other_data={}){
	var problem_added=false;
	if (star=="none"){
		for (var i=0;i<array_length(p_problem[planet]);i++){
			if (p_problem[planet][i] ==""){
				p_problem[planet][i]= problem;
				p_problem_other_data[planet][i]=other_data;
				p_timer[planet][i] = timer;
				problem_added=i;
				break;
			}
		}
	} else {
		with (star){
			problem_added =  add_new_problem(planet, problem, timer,"none",other_data);
		}
	}
	return 	problem_added;
}

function problem_has_key_and_value(planet, problem,key,value="",star="none"){
	var has_data=false;
	if (star=="none"){
		var problem_data = p_problem_other_data[planet][problem];
		if (struct_exists(problem_data, key)){
			if (value==""){
				has_data=true
			} else if( problem_data[$ key] == value){
				has_data=true;
			}
		}
	} else {
		with (star){
			has_data= problem_has_key_and_value(planet, problem,key,value,star="none");
		}
	}
	return 	has_data;
}