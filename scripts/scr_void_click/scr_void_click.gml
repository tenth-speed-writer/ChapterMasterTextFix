function scr_void_click() {
	var view_x = __view_get( e__VW.XView, 0 )+2;
	var view_y = __view_get( e__VW.YView, 0 )+2;
	var view_w = camera_get_view_width(view_camera[0]);
	var view_h = camera_get_view_height(view_camera[0]);

	if (obj_controller.cooldown > 0) then return false;

	else if ((obj_controller.zoomed = 0) and (mouse_y<=view_y+(view_h*0.10))) or (obj_controller.menu != 0) then return false;

	else if ((obj_controller.zoomed = 0) and (mouse_y>=view_y+(view_h*0.90))) or (obj_controller.menu != 0) then return false;

	else if (instance_exists(obj_fleet_select)) {
		if (obj_fleet_select.currently_entered) then return false;
	}

	// All of this needs x and y fixing after the introduction of zoom.

	// if (instance_exists(obj_star_select)) {
	// 	if (obj_controller.selecting_planet > 0) { // This prevents clicking onto a new star by pressing the buttons or planet panel
	// 		if (scr_hit(view_x + 27, view_y + 166, view_x + 727, view_y + 458)) and(instance_exists(obj_star_select)) {
	// 			if (obj_star_select.button1 != "") then good = false;
	// 		}
	// 		if (scr_hit(view_x + 348, view_y + 461, view_x + 348 + 246, view_y + 461 + 26)) and(instance_exists(obj_star_select)) {
	// 			if (obj_star_select.button1 != "") then good = false;
	// 		}
	// 		if (scr_hit(view_x + 348, view_y + 489, view_x + 348 + 246, view_y + 489 + 26)) and(instance_exists(obj_star_select)) {
	// 			if (obj_star_select.button2 != "") then good = false;
	// 		}
	// 		if (scr_hit(view_x + 348, view_y + 517, view_x + 348 + 246, view_y + 517 + 26)) and(instance_exists(obj_star_select)) {
	// 			if (obj_star_select.button3 != "") then good = false;
	// 		}
	// 		if (scr_hit(view_x + 348, view_y + 545, view_x + 348 + 246, view_y + 545 + 26)) and(instance_exists(obj_star_select)) {
	// 			if (obj_star_select.button4 != "") then good = false;
	// 		}
	// 	}
	// }

	// if (obj_controller.popup = 3) { // Prevent hitting through the planet select
	// 	if (scr_hit(view_x + 27, view_y + 165, view_x + 347, view_y + 459) = true) then good = false;
	// 	if (obj_controller.selecting_planet > 0) {
	// 		if (scr_hit(view_x + 27, view_y + 165, view_x + 728, view_y + 459) = true) then good = false; // The area with the planetary info
	// 	}
	// }

	// if (obj_controller.menu = 60) and(scr_hit(view_x + 27, view_y + 165, view_x + 651, view_y + 597) = true) then good = false; // Build menu

	return (true);

}