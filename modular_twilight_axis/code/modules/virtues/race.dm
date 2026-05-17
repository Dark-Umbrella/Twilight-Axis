/datum/virtue/combat/devotee/god_affinity
	name = "God Affinity (Racial, Aasimar)"
	desc = "This Virtue is unlisted and should not be visible."
	unlisted = TRUE

/datum/virtue/utility/winged_form
	name = "Winged Form (Racial, Aasimar)"
	desc = "This Virtue is unlisted and should not be visible."
	unlisted = TRUE

/datum/virtue/utility/winged_form/apply_to_human(mob/living/carbon/human/recipient)	
	var/obj/item/organ/wings/angel/wings = recipient.getorganslot(ORGAN_SLOT_WINGS) 
	if(!wings)
		to_chat(recipient, span_notice("No wings!"))
		return
	to_chat(recipient, span_notice("My wings feels strong."))
	recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/flyform)

//////////////////////////////////////////////////////////////////////////////////
/obj/effect/proc_holder/spell/self/flyform
	name = "Winged Form"
	desc = ""
	overlay_icon = 'icons/mob/actions/mage_augmentation.dmi'
	overlay_state = "leap"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = null
	associated_skill = /datum/skill/misc/athletics
	antimagic_allowed = TRUE
	invocations = ""
	invocation_type = "none"
	recharge_time = 5 SECONDS
	miracle = FALSE

/obj/effect/proc_holder/spell/self/flyform/cast(list/targets, mob/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user

	var/obj/item/organ/wings/angel/wings = H.getorganslot(ORGAN_SLOT_WINGS) 
	if(!wings)
		return

	if(HAS_TRAIT(H, TRAIT_ZJUMP))
		to_chat(H, span_notice("I'm folding my wings until I need them."))
		user.visible_message(span_warning("[H] folds their wings!"))
		REMOVE_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)
		REMOVE_TRAIT(H, TRAIT_LEAPER, TRAIT_GENERIC)
		REMOVE_TRAIT(H, TRAIT_NOFALLDAMAGE2, TRAIT_GENERIC)
		H.remove_status_effect(/datum/status_effect/debuff/wingform)
		UnregisterSignal(H, COMSIG_LIVING_ONJUMP)
		H.Immobilize(5)
		return FALSE

	ADD_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LEAPER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOFALLDAMAGE2, TRAIT_GENERIC)
	H.apply_status_effect(/datum/status_effect/debuff/wingform)
	to_chat(H, span_warning("My wings are spread wide and ready to spring up high!"))
	user.visible_message(span_warning("[H] spreads their wings!"))
	RegisterSignal(H, COMSIG_LIVING_ONJUMP, PROC_REF(z_jump))
	return TRUE

/obj/effect/proc_holder/spell/self/flyform/proc/z_jump(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		user.visible_message(span_warning("[H] flaps their wings!"))
		playsound(H, 'sound/vo/mobs/bird/birdfly.ogg', 100, TRUE, -1)
		REMOVE_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)
		REMOVE_TRAIT(H, TRAIT_LEAPER, TRAIT_GENERIC)
		REMOVE_TRAIT(H, TRAIT_NOFALLDAMAGE2, TRAIT_GENERIC)
		H.remove_status_effect(/datum/status_effect/debuff/wingform)
		UnregisterSignal(H, COMSIG_LIVING_ONJUMP)
		H.stamina_add(100)
		H.energy_add(-50)

/datum/status_effect/debuff/wingform
	id = "wingform"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/wingform
	effectedstats = list(STATKEY_SPD = -5)
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/wingform
	name = "Winged Form"
	desc = "My wings are spread wide and ready to spring!"
	icon_state = "buff"
//////////////////////////////////////////////////////////////////////////////////

/datum/virtue/utility/underdark
	name = "Underdark (Racial, Drow)"
	desc = "This Virtue is unlisted and should not be visible."
	unlisted = TRUE

/datum/virtue/utility/underdark/apply_to_human(mob/living/carbon/human/recipient)	
	var/obj/item/organ/eyes/O = recipient.getorganslot(ORGAN_SLOT_EYES) 
	if(O)
		O.Remove(recipient,1)
		QDEL_NULL(O)
	O = new /obj/item/organ/eyes/night_vision()
	O.eye_color = "#8e0202"
	O.Insert(recipient)
	recipient.faction += "spider_lowers"
	recipient.AddComponent(/datum/component/drow_eyes_check)
	if (!(istype(recipient.patron, /datum/patron/inhumen/zizo)))
		recipient.set_patron(/datum/patron/inhumen/zizo)

/datum/status_effect/debuff/underdark_eye_day
	id = "underdark_eye_day"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/debuff/underdark_eye_day
	effectedstats = list(STATKEY_PER = -5)

/atom/movable/screen/alert/status_effect/debuff/underdark_eye_day
	name = "The Sun"
	desc = "Astrata blinding me! I should wait out this hell underground!"
	icon_state = "debuff"

/datum/virtue/utility/harmony
	name = "Harmony (Racial, Elf)"
	desc = "This Virtue is unlisted and should not be visible."
	unlisted = TRUE

/datum/virtue/utility/harmony/apply_to_human(mob/living/carbon/human/recipient)
	harmony_return(recipient)

/datum/virtue/utility/harmony/proc/harmony_ruin(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		to_chat(H, span_warning("My harmony breaks!"))
		UnregisterSignal(H, COMSIG_MOB_ITEM_ATTACK)
		UnregisterSignal(H, COMSIG_MOB_ITEM_BEING_ATTACKED)
		UnregisterSignal(H, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED)
		UnregisterSignal(H, COMSIG_MOB_ATTACKED_BY_HAND)
		H.faction -= "wildlife"
		H.faction -= "wolfs"
		addtimer(CALLBACK(src, PROC_REF(harmony_return), H), 1 MINUTES)

/datum/virtue/utility/harmony/proc/harmony_return(mob/user)
	if(!user || QDELETED(user) || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	to_chat(H, span_warning("My beast harmony returns!"))
	H.faction += "wildlife"
	H.faction += "wolfs"
	RegisterSignal(H, COMSIG_MOB_ITEM_ATTACK, PROC_REF(harmony_ruin))
	RegisterSignal(H, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(harmony_ruin))
	RegisterSignal(H, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED, PROC_REF(harmony_ruin))
	RegisterSignal(H, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(harmony_ruin))