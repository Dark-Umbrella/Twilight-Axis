/*
 * TA - Huntingknife (idagger) intent rebalance override
 */

/datum/intent/dagger/thrust/pick/pickTA
	name = "pick stab"
	icon_state = "inpick"
	attack_verb = list("stabs", "impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	clickcd = 14
	swingdelay = 12
	damfactor = 1.1
	blade_class = BCLASS_PICK
	penfactor = PEN_HEAVY //Reduce piercing from requested 4 -> 3.

/datum/intent/dagger/thrust/lungeTA
	name = "deep lunge"
	icon_state = "inlunge"
	swingdelay_type = SWINGDELAY_CANCELSLOW
	canparry = FALSE
	candodge = FALSE
	swingdelay = 8
	clickcd = 15
	penfactor = PEN_BSTEEL
	damfactor = 1.1

/obj/item/rogueweapon/huntingknife/idagger/possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/thrust/pick/pickTA, /datum/intent/dagger/thrust/lungeTA, /datum/intent/dagger/cut)
