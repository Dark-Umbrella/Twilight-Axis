/datum/component/drow_eyes_check
	/// Whether this mob is currently in sunlight
	var/in_sunlight = FALSE

/datum/component/drow_eyes_check/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(check_sunlight))

/datum/component/drow_eyes_check/proc/check_sunlight(mob/living/source)
	var/mob/living/carbon/human/H = source
	if(!H || H.stat == DEAD || H.advsetup)
		return

	if(GLOB.tod == "night")
		in_sunlight = FALSE

	// Check if outside and in light
	if(isturf(H.loc))
		var/turf/T = H.loc
		if(T.can_see_sky())

			if(!in_sunlight)
				in_sunlight = TRUE
				to_chat(H, span_danger("The sunlight blind my eyes!"))

			if(HAS_TRAIT(H, UNDERDARK_DROW))
				H.apply_status_effect(/datum/status_effect/debuff/underdark_eye_day)

		else
			if(in_sunlight)
				to_chat(H, span_notice("The scorching gaze of the Sun-Tyrant blind me no more."))
			in_sunlight = FALSE

			if(HAS_TRAIT(H, UNDERDARK_DROW))
				H.remove_status_effect(/datum/status_effect/debuff/underdark_eye_day)

	else
		in_sunlight = FALSE