// TA - Clothes integrity rebalance
// Doubles max_integrity for all /obj/item/clothing that have armor,
// while preserving current integrity percentage (obj_integrity/max_integrity),
// to avoid breaking piercing/penetration mechanics that depend on ratios.

#define TA_MAX_INTEGRITY_MULTIPLIER 2

#define ARMOR_CLOTHING_FEET list("blunt" = DR_NONE, "slash" = DBLOCK_NONE, "stab" = DBLOCK_NONE, "piercing" = DBLOCK_NONE, "fire" = DR_NONE, "acid" = DR_NONE, "bullet" = DR_NONE)
#define ARMOR_PADDED_BAD_FEET list("blunt" = DR_MEDIUM, "slash" = DBLOCK_LIGHT, "stab" = DBLOCK_LIGHT, "piercing" = DBLOCK_LIGHT, "fire" = DR_NONE, "acid" = DR_NONE, "bullet" = DR_NONE)
#define ARMOR_PADDED_FEET list("blunt" = DR_SUPER, "slash" = DBLOCK_MEDIUM, "stab" = DBLOCK_MEDIUM, "piercing" = DBLOCK_HEAVY, "fire" = DR_MEDIUM, "acid" = DR_NONE, "bullet" = DR_LIGHT)

/obj/item/clothing/shoes/roguetown/Initialize()
	. = ..()
	if(istype(src.smeltresult, /obj/item/ingot) || smeltresult == /obj/item/rogueore/coal)
		return

	var/list/tier_two_boots = list(
		/obj/item/clothing/shoes/roguetown/shalal,
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced,
		/obj/item/clothing/shoes/roguetown/boots/furlinedboots,
		/obj/item/clothing/shoes/roguetown/boots/furlinedanklets
	)

	var/list/tier_three_boots = list(
		/obj/item/clothing/shoes/roguetown/boots/psydonboots,
		/obj/item/clothing/shoes/roguetown/boots/otavan,
		/obj/item/clothing/shoes/roguetown/grenzelhoft/freifechter,
		/obj/item/clothing/shoes/roguetown/grenzelhoft,
		/obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman,
		/obj/item/clothing/shoes/roguetown/boots/nobleboot
	)

	for(var/type_path in tier_two_boots)
		if(istype(src, type_path))
			armor = getArmor(blunt = DBLOCK_HEAVY, slash = DBLOCK_HEAVY, stab = DBLOCK_MEDIUM, piercing = DBLOCK_MEDIUM, fire = DR_NONE, acid = DR_NONE, magic = 0, bullet = DR_NONE)
			max_integrity = 120 //240 x2
			integrity_fix()
			return

	for(var/type_path in tier_three_boots)
		if(istype(src, type_path))
			armor = getArmor(blunt = DR_SUPER, slash = DBLOCK_HEAVY, stab = DBLOCK_HEAVY, piercing = DBLOCK_HEAVY, fire = DR_MEDIUM, acid = DR_NONE, magic = 0, bullet = DR_LIGHT)
			max_integrity = 160 //320 x2
			integrity_fix()
			return

	armor = getArmor(blunt = DR_MEDIUM, slash = DBLOCK_MEDIUM, stab = DBLOCK_MEDIUM, piercing = DBLOCK_LIGHT, fire = DR_NONE, acid = DR_NONE, magic = 0, bullet = DR_NONE)
	max_integrity = 80 //160 x2
	integrity_fix()

/obj/item/clothing/shoes/roguetown/proc/integrity_fix()
	if(!armor)
		return

	if(!max_integrity)
		return

	var/old_max = max_integrity
	var/old_obj = obj_integrity

	max_integrity = round(old_max * TA_MAX_INTEGRITY_MULTIPLIER)

	obj_integrity = round(old_obj * TA_MAX_INTEGRITY_MULTIPLIER)

	if(obj_integrity > max_integrity)
		obj_integrity = max_integrity

/obj/item/clothing/Initialize()
	. = ..()

	// Only items with armor should be affected.
	if(!armor)
		return

	if(!max_integrity)
		return

	var/old_max = max_integrity
	var/old_obj = obj_integrity

	max_integrity = round(old_max * TA_MAX_INTEGRITY_MULTIPLIER)

	obj_integrity = round(old_obj * TA_MAX_INTEGRITY_MULTIPLIER)

	if(obj_integrity > max_integrity)
		obj_integrity = max_integrity

/obj/item/rogueweapon/Initialize()
	. = ..()

	// Only real weapons should be affected.
	if(force <= 10)
		return

	if(!max_integrity)
		return

	var/old_max = max_integrity
	var/old_obj = obj_integrity
	var/old_bmax = max_blade_int
	var/old_bint = blade_int

	max_integrity = round(old_max * TA_MAX_INTEGRITY_MULTIPLIER)

	obj_integrity = round(old_obj * TA_MAX_INTEGRITY_MULTIPLIER)

	max_blade_int = round(old_bmax * TA_MAX_INTEGRITY_MULTIPLIER)

	blade_int = round(old_bint * TA_MAX_INTEGRITY_MULTIPLIER)

	if(obj_integrity > max_integrity)
		obj_integrity = max_integrity

	if(blade_int > max_blade_int)
		blade_int = max_blade_int

/datum/intent/New()
	. = ..()
	if(blade_class == BCLASS_BLUNT)
		intent_intdamage_factor = intent_intdamage_factor*1.5

