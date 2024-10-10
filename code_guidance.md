Coders guidance
add to as you see fit, but try to keep doc easy to use

Useful functions:
TTRPG_stats(faction, comp, mar, class = "marine")
		creates a new unit struct see scr_marine_struct.gml for more info


		unit_Struct.name_role()
			provides a string representation of the unit name combined with the unit role 
			taking into account the unit role display name as provided by the units squad type

scr_random_marine(argument0, argument1)
		selects a random player unit within the parameters given
		if no marine is available with give parameters returns "none"


keys and data:
faction key:
	imperium:2
	mechanics:3
	inquisition:4
	sororities:5


Visual and draw functions

tooltip_draw(x,y,tooltip_text)
	creates a hover over tool tip at the given coordinate where:
		x is the left most point of the tooltip box
		y is the topmost point of the tooltip box,
		tooltip_text is the text to display (text should be preformatted e.g string_hash_to_newline() to create lines)

scr_convert_company_to_string(marine company)
	returns a sting representation of a marines compant


How does combat work?????

-  First obj_ncombat is creates.
- second scr_battle_Roster is run with the location planet and star as arguments to collect player forces in battle

- within obj_ncombat create the obj_pnunit.alarm[3] is set to run for next step
	- this tallies up the total player forces in obj_encombat

- obj_ncombat.alarm[0] is set to run the turn after
	-	 this populates the enemy forces
	- it also bizzarly seems to set up some of the player defences

- obj_ncombat.alarm[1] runs a turn after alarm[0] this sets up teh opening text for the confrontation, most of which it seems is there but the player never sees

- obj_ncombat.alarm[2] runs this sets ally forces curiously setting them up after their existane has been announced to the player by alarm[1]

- at the same time as obj_ncombat.alarm[2] is set the obj_ncombat.keypress[13] script runs (line 69 onwards) so that if the player presses a button the obj_pnunit.alarm[8] on a timer sets to run 8 frames later meaning it can only run as early as the eralier set obj_ncombat.alarm[2]

	- all obj_pnunit.alarm[8] does is set obj_pnunit.alarm[1] to a one turn timer

- obj_pnunit.alarm[1] will now run after a key has been pressed officially beggining the battle this runs the scr_player_combat_weapon_stacks() for each obj_pnunit instance (e.g each red line on teh battle map)

