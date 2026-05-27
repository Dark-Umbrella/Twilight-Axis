/obj/item/clothing/Initialize()
	. = ..()

	if(!armor)
		return

	if(istype(src, /obj/item/clothing/shoes/roguetown/boots/armor) || istype(src, /obj/item/clothing/gloves/roguetown/plate) || istype(src, /obj/item/clothing/wrists/roguetown/bracers))
		if(!smeltresult)
			return
		armor_class = ARMOR_CLASS_MEDIUM
