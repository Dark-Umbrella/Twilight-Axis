#define MEDICA_COOKING_TIME 60 SECONDS

/datum/stew_recipe/viscera
	inputs = list(/obj/item/alch/viscera)
	output = /datum/reagent/medicine/viscera
	cooktime = MEDICA_COOKING_TIME

/datum/stew_recipe/base_health_brute
	inputs = list(/obj/item/alch/calendula)
	output = /datum/reagent/medicine/boil/calendula
	cooktime = MEDICA_COOKING_TIME

/datum/stew_recipe/base_health_burn
	inputs = list(/obj/item/alch/taraxacum)
	output = /datum/reagent/medicine/boil/taraxacum
	cooktime = MEDICA_COOKING_TIME

/datum/stew_recipe/base_health_wound
	inputs = list(/obj/item/natural/worms/leech)
	output = /datum/reagent/medicine/boil/leech
	cooktime = MEDICA_COOKING_TIME

/datum/stew_recipe/base_health_blood
	inputs = list(/obj/item/alch/bonemeal)
	output = /datum/reagent/medicine/boil/bonedust
	cooktime = MEDICA_COOKING_TIME

/datum/stew_recipe/base_health_tox
	inputs = list(/obj/item/alch/tobaccodust, /obj/item/alch/swampdust)
	output = /datum/reagent/medicine/boil/leaf
	cooktime = MEDICA_COOKING_TIME

#undef MEDICA_COOKING_TIME
