function new_colony_fleet (doner_star, doner_planet, target, target_planet, mission="new_colony"){
    var new_colonise_fleet=instance_create(doner_star.x,doner_star.y,obj_en_fleet);
    new_colonise_fleet.owner = eFACTION.Imperium;
    new_colonise_fleet.sprite_index=spr_fleet_civilian;
    new_colonise_fleet.image_index=3;

    var doner_volume = 0;
    if (doner_star.p_large[doner_planet]) {
        doner_volume = (doner_star.p_population[doner_planet]*0.01)*power(10,8);
        doner_star.p_population[doner_planet]*=0.99;
    } else {
        doner_volume = doner_star.p_population[doner_planet]*0.1;
        doner_star.p_population[doner_planet]*=0.90;       
    }

    var new_cargo = {
        colonists : doner_volume,
        mission : mission,
        target_planet : target_planet,
        colonist_influence : doner_star.p_influence[doner_planet]
    }

    //TODO flesh out colonisation efforts
    if (doner_star.p_population[target_planet] && doner_star.p_type[doner_planet] == "Hive"){
    	new_colonise_fleet.image_index=3; 
        new_colonise_fleet.trade_goods="colonize";
    } else {
    	new_colonise_fleet.image_index=choose(1,2);
        new_colonise_fleet.trade_goods="colonize";
    }

    new_colonise_fleet.cargo_data.colonize = new_cargo; 

    new_colonise_fleet.action_x=target.x;
    new_colonise_fleet.action_y=target.y;
    with (new_colonise_fleet){
        set_fleet_movement();
    }
    scr_event_log("green",$"New colony fleet departs from {doner_star.name}. for the {target.name} system",doner_star.name);

}

function fleet_has_cargo(desired_cargo, fleet="none"){
    if (fleet == "none"){
        return struct_exists(cargo_data, desired_cargo);
    } else {
        var has_cargo = false;
        with (fleet){
            has_cargo =  fleet_has_cargo();
        }
        return has_cargo;
    }
}

function deploy_colonisers(star){
    var lag=1,r=0;

    var data = cargo_data.colonize;
    if (data.target_planet>0){
        var targ_planet = data.target_planet;
        if (!star.p_large[targ_planet]){
            star.p_population[targ_planet] += data.colonists;
        } else {
            star.p_population[targ_planet] += data.colonists/power(10,8);
        }
        var start_influ = star.p_influence[targ_planet][eFACTION.Tyranids];
        with (star){
            merge_influences(data.colonist_influence,targ_planet);
        }
        var colony_purpose = data.mission=="new_colony"? "recolonise" : "bolster population" ;
        var alert_string = $"Imperial citizens {colony_purpose} {planet_numeral_name(targ_planet, star)} I.";
        var player_vision = star.p_player[targ_planet]>0 || star.p_owner[targ_planet] == eFACTION.Player;
        if (star.p_influence[targ_planet][eFACTION.Tyranids]>start_influ && (player_vision)){
            alert_string += " They bring with them traces of a Genestelar Cult";
        }
        scr_alert("green","duhuhuhu",alert_string,star.x,star.y);
    } else {
        for (r=1;r<=star.planets;r++){
            if (data.mission == "new_colony") && (star.p_population[r]<=0) then continue;
            if (star.p_type[r]!="") and (star.p_type[r]!="Dead") {
                if (lag=1){
                    star.p_population[r] += data.colonists;
                    star.p_large[r]=0;
                    guardsmen=0;
                }
                if (lag=2){
                    star.p_population[r] += data.colonists;
                    star.p_large[r]=1;
                    guardsmen=0;
                }

                scr_alert("green","duhuhuhu",$"Imperial citizens recolonize {planet_numeral_name(r, star)} I.",star.x,star.y);
                
                star.dispo[r]=min(obj_ini.imperium_disposition,obj_controller.disposition[2])+irandom_range(-4,4);
                if (star.name=obj_ini.home_name) and (star.p_type[r]=obj_ini.home_type) and (obj_controller.homeworld_rule!=1) then star.dispo[r]=-5000;

            }
        }  
    }
    if (struct_exists(cargo_data, "colonize")){
        struct_remove(cargo_data, "colonize");
    }
}


function new_navy_ships_forge(){
    if (trade_goods=="building_ships"){
        var onceh=0,advance=false,p=0;
    
        p=0;
        if (!instance_exists(orbiting) && action==""){
            orbiting = instance_nearest(x,y, obj_star);
        }
        for (var p=1;p<=orbiting.planets;p++){
            if (orbiting.p_type[p]="Forge"){
                //if no non-imperium,player, or eldar aligned fleets or ground forces, continue
                if (orbiting.p_orks[p]+orbiting.p_chaos[p]+orbiting.p_tyranids[p]+orbiting.p_necrons[p]+orbiting.p_tau[p]+orbiting.p_traitors[p]=0){
                    if (orbiting.present_fleet[7]+orbiting.present_fleet[8]+orbiting.present_fleet[9]+orbiting.present_fleet[10]+orbiting.present_fleet[13]=0){
                        advance=1;
                    }
                }
            }
        }
        
        if (!advance) then continue;


        if (escort_number<12) and (onceh=0) {
            escort_number+=1;onceh=1;
        }

        else if (frigate_number<5) and (onceh=0) {
            frigate_number+=0.25;
            onceh=1;
            if (frigate_number>4.99) then frigate_number=5;
        }

        if (capital_number<1) {
            capital_number+=0.0834;
            onceh=1;
            if (capital_number>1) then capital_number=1;
        }
        if (onceh=1){
            var ii=0;
            ii+=capital_number;
            ii+=round((frigate_number/2));
            ii+=round((escort_number/4));

            image_index=ii<=1?1:ii;
        }
    
        if (capital_number=1) and (frigate_number>=5) and (escort_number>=12){
            var i=0;
            repeat(capital_number){i+=1;
                capital_max_imp[i]=(((floor(random(15))+1)*1000000)+15000000)*2;
            }
            i=0;
            repeat(frigate_number){i+=1;
                frigate_max_imp[i]=(500000+(floor(random(50))+1)*10000)*2;
            }
            trade_goods="";
        }

    
        //if (trade_goods="building_ships") or (!advance) then exit;
        return advance;
    }   
}
//TODO further breakup into a nvay fleet functions script
function navy_strength_calc(){
    return (capital_number*8)+(frigate_number*2)+escort_number);
}

function dock_navy_at_forge(){

    // Got to forge world
    if (action="") and (trade_goods="goto_forge") and (instance_exists(orbiting)){
        trade_goods="building_ships";
    }
}

function send_navy_to_forge(){
    // Quene a visit to a forge world
    if (action="") and (trade_goods="") and (instance_exists(orbiting)){
        with(obj_temp_inq){
            instance_destroy();
        }
        var forge_list = [];
        with(obj_star){
            var cont=0,p=0;
            repeat(planets){
                p+=1;
                if (p_type[p]="Forge"){
                    if (p_orks[o]+p_chaos[o]+p_tyranids[o]+p_necrons[o]+p_tau[o]+p_traitors[o]=0){
                        if (present_fleet[7]+present_fleet[8]+present_fleet[9]+present_fleet[10]+present_fleet[13]=0){
                            cont=1;
                        }
                    }
                }
            }
            if (cont){
                array_push(forge_list,id);
            }
        }
        if (array_length(forge_list)){
            var go_there=nearest_from_array(forge_list);
            var target_forge = forge_list[go_there];
            action_x=target_forge.x;
            action_y=target_forge.y;
            trade_goods="goto_forge";// show_message("D");
            set_fleet_movement();
        }
    }
}

function imperial_navy_bombard(){
    if (guardsmen_unloaded=0) or ((orbiting.p_guardsmen[1]+orbiting.p_guardsmen[2]+orbiting.p_guardsmen[3]+orbiting.p_guardsmen[4]=0) and (guardsmen_unloaded=1)) or ((orbiting.p_player[cr]>0) and (obj_controller.faction_status[eFACTION.Imperium]="War")){
        if (orbiting.present_fleet[6]+orbiting.present_fleet[7]+orbiting.present_fleet[8]+orbiting.present_fleet[9]+orbiting.present_fleet[10]+orbiting.present_fleet[13]=0){
            var hol=false;
            if ((orbiting.present_fleet[1]>0) and (obj_controller.faction_status[eFACTION.Imperium]="War")) then hol=true;
    
            if (hol=false){
                var o,bombard,deaths,hurss,scare,onceh,wob,kill;
                o=0;bombard=0;deaths=0;hurss=0;onceh=0;wob=0;kill=0;
            
                repeat(orbiting.planets){
                    o+=1;
                    if (orbiting.p_type[o]!="Daemon"){
                        if (orbiting.p_population[o]=0) and (orbiting.p_tyranids[o]>0) and (onceh=0){
                            bombard=o;
                            onceh=1;
                        }
                        if (orbiting.p_population[o]=0) and (orbiting.p_orks[o]>0) and (orbiting.p_owner[o]=7) and (onceh=0){bombard=o;onceh=1;}
                        if (orbiting.p_owner[o]=8) and (orbiting.p_tau[o]+orbiting.p_pdf[o]>0) and (onceh=0){
                            bombard=o;onceh=1;
                        }
                        if (orbiting.p_owner[o]=10) and ((orbiting.p_chaos[o]+orbiting.p_traitors[o]+orbiting.p_pdf[o]>0) or (orbiting.p_heresy[o]>=50)){bombard=o;onceh=1;}
                    }
                }
            
                if (bombard>0){
                    scare=(capital_number*3)+frigate_number;
                
                
                
                    // Eh heh heh
                    if (onceh<2) and (orbiting.p_tyranids[bombard]>0){
                        if (scare>2) then scare=2;if (scare<1) then scare=0;
                        orbiting.p_tyranids[bombard]-=2;onceh=2;
                    }
                    if (onceh<2) and (orbiting.p_orks[bombard]>0){
                        if (scare>2) then scare=2;if (scare<1) then scare=0;
                        orbiting.p_orks[bombard]-=2;onceh=2;
                    }
                    if (onceh<2) and (orbiting.p_owner[bombard]=8) and (orbiting.p_tau[bombard]>0){
                        if (scare>2) then scare=2;if (scare<1) then scare=0;
                        orbiting.p_tau[bombard]-=2;onceh=2;
                    
                        if (orbiting.p_large[bombard]=0) then kill=scare*15000000;// Population if normal
                        if (orbiting.p_large[bombard]=1) then kill=scare*0.15;// Population if large
                    }
                    if (onceh<2) and (orbiting.p_owner[bombard]=8) and (orbiting.p_pdf[bombard]>0){
                        wob=scare*5000000+choose(floor(random(100000)),floor(random(100000))*-1);
                        orbiting.p_pdf[bombard]-=wob;
                        if (orbiting.p_pdf[bombard]<0) then orbiting.p_pdf[bombard]=0;
                    
                        if (orbiting.p_large[bombard]=0) then kill=scare*15000000;// Population if normal
                        if (orbiting.p_large[bombard]=1) then kill=scare*0.15;// Population if large
                    }
                    if (onceh<2) and (orbiting.p_owner[bombard]=10){
                        if (scare>2) then scare=2;if (scare<1) then scare=0;
                    
                        if (onceh!=2) and (orbiting.p_chaos[bombard]>0){orbiting.p_chaos[bombard]=max(0,orbiting.p_traitors[bombard]-1);onceh=2;}
                        if (onceh!=2) and (orbiting.p_traitors[bombard]>0){orbiting.p_traitors[bombard]=max(0,orbiting.p_traitors[bombard]-2);onceh=2;}
                    
                        if (orbiting.p_large[bombard]=0) then kill=scare*15000000;// Population if normal
                        if (orbiting.p_large[bombard]=1) then kill=scare*0.15;// Population if large
                        if (orbiting.p_heresy[bombard]>0) then orbiting.p_heresy[bombard]=max(0,orbiting.p_heresy[bombard]-5);
                    }
                
                    orbiting.p_population[bombard]-=kill;
                    if (orbiting.p_population[bombard]<0) then orbiting.p_population[bombard]=0;
                    if (orbiting.p_pdf[bombard]<0) then orbiting.p_pdf[bombard]=0;
                
                    if (orbiting.p_population[bombard]+orbiting.p_pdf[bombard]<=0) and (orbiting.p_owner[bombard]=1) and (obj_controller.faction_status[eFACTION.Imperium]="War"){
                        if (planet_feature_bool(orbiting.p_feature[bombard],P_features.Monastery)==0){orbiting.p_owner[bombard]=2;orbiting.dispo[bombard]=-50;}
                    }
                    exit;
                }
            }
        }
    }    
}