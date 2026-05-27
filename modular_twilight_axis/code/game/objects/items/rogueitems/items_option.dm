
/obj/item/rogueweapon/Initialize()
	. = ..()
	// Double weapon max values without snapping current state to the new max.
	// This prevents changing blade_int/max_blade_int ratio, which feeds into penetration (pen_info).
	if(max_blade_int)
		var/old_max_blade_int = max_blade_int
		var/old_blade_int = blade_int
		max_blade_int = old_max_blade_int * 2
		blade_int = round((old_blade_int / max(old_max_blade_int, 1)) * max_blade_int)
	if(force >= 10)
		var/old_max_integrity = max_integrity
		var/old_obj_integrity = obj_integrity
		max_integrity = old_max_integrity * 2
		obj_integrity = round((old_obj_integrity / max(old_max_integrity, 1)) * max_integrity)

/obj/item/clothing/suit/roguetown/Initialize()
	. = ..()
	if(armor)
		max_integrity = max_integrity*2
		obj_integrity = max_integrity

/datum/intent/New()
	if(blade_class == BCLASS_BLUNT)
		intent_intdamage_factor = intent_intdamage_factor*2
