function new_colony_fleet (doner_star, doner_planet, target, large=false){
    var new_colonise_fleet=instance_create(doner_star.x,doner_star.y,obj_en_fleet);
    new_colonise_fleet.owner = eFACTION.Imperium;
    new_colonise_fleet.sprite_index=spr_fleet_civilian;
    new_colonise_fleet.image_index=3;

    if (large){
    	new_colonise_fleet.image_index=3;
	    if (doner_star.p_large[doner_planet]=1) and (doner_star.p_type[doner_planet]=="Hive") and ((new_colonise_fleet.trade_goods="") or (new_colonise_fleet.trade_goods="colonizeL")){
	        new_colonise_fleet.guardsmen+=(doner_star.p_population[doner_planet]*0.01);
	        doner_star.p_population[doner_planet]=doner_star.p_population[doner_planet]*0.99;
	        doner_star.p_population[doner_planet]=floor(doner_star.p_population[doner_planet]*100)/100;// Round to two decimals
	        new_colonise_fleet.trade_goods="colonizeL";
	    }
    } else {
    	new_colonise_fleet.image_index=choose(1,2);
        if (doner_star.p_large[doner_planet]=1) and (doner_star.p_type[doner_planet]="Hive") and ((new_colonise_fleet.trade_goods="") or (new_colonise_fleet.trade_goods="colonize")){
            new_colonise_fleet.guardsmen+=floor(((doner_star.p_population[doner_planet]*0.01))*10000*10000);
            new_colonise_fleet.trade_goods="colonize";
        }    	
    }

    new_colonise_fleet.action_x=target.x;
    new_colonise_fleet.action_y=target.y;
    new_colonise_fleet.alarm[4]=1;
}