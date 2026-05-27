/obj/item/clothing/shoes/roguetown/boots/armor/Initialize()
	. = ..()
	if(smeltresult)
		armor_class = ARMOR_CLASS_MEDIUM

/obj/item/clothing/gloves/roguetown/plate/Initialize()
	. = ..()
	if(smeltresult)
		armor_class = ARMOR_CLASS_MEDIUM

/obj/item/clothing/wrists/roguetown/bracers/Initialize()
	. = ..()
	if(smeltresult)
		armor_class = ARMOR_CLASS_MEDIUM
