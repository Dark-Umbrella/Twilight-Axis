/obj/item/ointment
	name = "debug ointment"
	icon_state = null
	desc = "WTF man?"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	flags_ai_inventory = AI_ITEM_BANDAGE
	obj_flags = null
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_HIP
	body_parts_covered = null
	experimental_onhip = FALSE //rip
	max_integrity = 20
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = TRUE
	/// Effectiveness when used as a bandage, how much it'll lower the bloodloss, bloodloss will get multiplied by this.
	var/bandage_effectiveness = 0.5
	var/bandage_speed = 7 SECONDS
	///How much you can bleed into the bandage until it needs to be changed
	var/bandage_health = 150 //75 total blood stopped
	//bandage_health * (1 - bandage_effectiveness) = total amount of blood saved from one bandage
	/// If the bandage is soaked in some kind of medicine.
	var/medicine_quality
	var/medicine_amount = 0
	var/use_amount = 0

/obj/item/ointment/examine(mob/user)
	. = ..()
	if(use_amount)
		. += span_notice("It's can use [useuse_amount] times!")

/obj/item/natural/cloth/attack(mob/living/M, mob/user)

	bandage(M, user)

/obj/item/natural/cloth/wash_act()
	. = ..()
	wet = 10
	bandage_health = initial(bandage_health)
	medicine_amount = 0
	medicine_quality = 0
	detail_color = null
	desc = initial(desc)
	update_icon()

/obj/item/natural/cloth/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/C = I
	if(!istype(C))
		return ..()
	if(C.reagents.has_reagent(/datum/reagent/medicine/healthpot, 10) && !medicine_amount)
		to_chat(user, span_notice("You start soaking the [src] in lyfeblood..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/medicine/healthpot, 10)
			medicine_quality = 1
			medicine_amount += 10
			desc += " It has been soaked in lyfeblood."
			detail_color = "#ff0000"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/medicine/stronghealth, 10) && !medicine_amount)
		to_chat(user, span_notice("You start soaking the [src] in strong lyfeblood..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/medicine/stronghealth, 10)
			medicine_quality = 2
			medicine_amount += 10
			desc += " It has been soaked in strong lyfeblood."
			detail_color = "#820000"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/consumable/ethanol/aqua_vitae, 10) && !medicine_amount)
		to_chat(user, span_notice("You start soaking the [src] in aqua vitae..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/consumable/ethanol/aqua_vitae, 10)
			medicine_quality = 0.5 //slower than health potions, more healing overall. Good for fractures or other big wounds.
			medicine_amount += 60
			desc += " It has been soaked in aqua vitae."
			detail_color = "#6e6e6e"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/water/blessed, 10) && !medicine_amount)
		to_chat(user, span_notice("You start soaking the [src] in blessed water..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/water/blessed, 10)
			medicine_quality = 0.2 //cheap, easy to get, doesn't even heal wounds if it's not on a bandage
			medicine_amount += 20
			desc += " It has been soaked in blessed water."
			detail_color = "#6a9295"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/water/medicine, 10) && !medicine_amount)
		to_chat(user, span_notice("You start soaking the [src] in Pestran Medicine..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/water/medicine, 10)
			medicine_quality = 0.6 //cheap yet not very common
			medicine_amount += 30 // medicine_amount is equal to half the medication duration on a bandage, this will heal a total of 36 on a targeted area
			desc += " It has been soaked in Pestran Medicine."
			detail_color = "#428b42"
			update_icon()

/obj/item/natural/cloth/update_icon()
	cut_overlays()
	if(medicine_amount > 0)
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/natural/cloth/proc/bandage(mob/living/M, mob/user)
	var/used_time = bandage_speed
	var/medskill = 0

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		medskill = human_user.get_skill_level(/datum/skill/misc/medicine)
		used_time -= ((medskill * 10) + (human_user.STASPD / 2)) //With 20 SPD you can insta bandage at max medicine.

	if(istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal_patient = M
		if(!animal_patient.bruteloss)
			to_chat(user, span_warning("[animal_patient] doesn't need bandaging right now."))
			return
		playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
		if(!move_after(user, used_time, target = animal_patient))
			return
		playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
		animal_patient.adjustHealth(-((animal_patient.maxHealth / 5) * (medskill + 1)), TRUE)
		user.visible_message(span_notice("[user] bandages [M]'s wounds."), span_notice("I bandage [M]'s wounds."))
		// clear all the wounds
		for(var/datum/wound/wound as anything in animal_patient.get_wounds())
			qdel(wound)
		qdel(src)
		return

	if(!M.can_inject(user, TRUE))
		return

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M
	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
	if(!affecting)
		return
	if(affecting.bandage)
		to_chat(user, span_warning("There is already a bandage."))
		return

	playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
	if(!move_after(user, used_time, target = M))
		return
	playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)

	user.dropItemToGround(src)
	affecting.try_bandage(src)
	H.update_damage_overlays()

	if(M == user)
		user.visible_message(span_notice("[user] bandages [user.p_their()] [affecting]."), span_notice("I bandage my [affecting.name]."))
	else
		user.visible_message(span_notice("[user] bandages [M]'s [affecting]."), span_notice("I bandage [M]'s [affecting.name]."))
