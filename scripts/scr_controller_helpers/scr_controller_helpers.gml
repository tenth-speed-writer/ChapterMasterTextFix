// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_menu_clear_up(specific_area_function){
	if (action_if_number(obj_saveload, 0, 0) &&
	    action_if_number(obj_drop_select, 0, 0) &&
	    action_if_number(obj_popup_dialogue, 0, 0) &&
	    action_if_number(obj_ncombat, 0, 0)) {
	    
	    if (combat!=0) then exit;
	    if (scrollbar_engaged!=0) then exit;
	    if (instance_exists(obj_ingame_menu)) then exit;


	    if (instance_exists(obj_turn_end)) and (obj_controller.complex_event!=true) and (!instance_exists(obj_temp_meeting)){
	        if (obj_turn_end.popups_end==1) and (audience==0) and (cooldown<=0) then with(obj_turn_end){instance_destroy();}
	    }
	    if (instance_exists(obj_turn_end)) and (audience==0) then exit;
	    if (instance_exists(obj_star_select)) then exit;
	    if (instance_exists(obj_bomb_select)) then exit;

	    if (zoomed==0) and (cooldown<=0) and (menu>=500) and (menu<=510){

	        if (mouse_y>=__view_get( e__VW.YView, 0 )+27){
	            cooldown=8000;
	            if (menu>=500) and (temp[menu-434]=""){
	                menu=0;
	                exit;
	            }
	            if (menu<503) and (menu!=0) then menu+=1;
	        }
	    }

	    if (menu>=500) then exit;

	    var zoomeh=0,diyst=999,onceh=0;
	    xx=__view_get( e__VW.XView, 0 );
	    yy=__view_get( e__VW.YView, 0 );
	    zoomeh=zoomed;

	    if (menu==0) then hide_banner=0;// 136 ;

    if (zoomed==0) and (!instance_exists(obj_ingame_menu)) and (!instance_exists(obj_popup)){
        // Main Menu
        if (scr_hit(xx+1485,yy+7,xx+1589,yy+48)){
            instance_create(0,0,obj_ingame_menu);
        }
        // Menu - Help
        if (scr_hit(xx+1375,yy+7,xx+1480,yy+48)) and (cooldown<=0){
            if (menu!=17.5) and (onceh==0){
                menu=17.5;
                onceh=1;
                cooldown=8000;
                click=1;
                hide_banner=0;
                instance_activate_object(obj_event_log);
                obj_event_log.top=1;
                obj_event_log.help=1;
            }
            if (menu==17.5) and (onceh==0){
                menu=0;
                onceh=1;
                cooldown=8000;
                click=1;
                hide_banner=0;
            }
            managing=0;
            view_squad=false;
            unit_profile=false;
        }
    }
    if (instance_exists(obj_temp_build)){
        if (obj_temp_build.isnew==1) then exit;
    }
	if (zoomed==0) and (cooldown<=0) and (diplomacy==0){
		specific_area_function(); 
	}      
}

function scr_toggle_manage(){
    scr_menu_clear_up(function(){
	    if (menu!=1){
	        scr_management(1);
	        menu=1;
	        cooldown=8000;
	        click=1;
	        popup=0;
	        selected=0;
	        hide_banner=1;
	        with(obj_star_select){instance_destroy();}
	        with(obj_fleet_select){instance_destroy();}
	        view_squad=false;
	    }
	    else if (menu==1){
	        menu=0;
	        cooldown=8000;
	        click=1;
	        hide_banner=0;
	        location_viewer.update_garrison_log();
	    }
	    managing=0;
	}
}

function scr_toggle_setting(){

}

