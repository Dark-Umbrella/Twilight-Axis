/datum/species/aasimar
	inherent_traits = list(TRAIT_SILVER_BLESSED, TRAIT_ZOMBIE_IMMUNE, TRAIT_UNLYCKERABLE, TRAIT_NOHUNGER)
	possible_ages = AASIMAR_AGES_LIST
	custom_selection = list(
		"+1 FOR" = STATKEY_LCK,
		"+1 INT" = STATKEY_INT,
		"+1 CON" = STATKEY_CON,
		"+1 WIL" = STATKEY_WIL,
		"+1 PER" = STATKEY_PER,
		"Divine Siphon (gain T0 miracles, +1 miracle skill)" = list(/datum/virtue/combat/devotee/god_affinity),
		"Winged Form (Z lvl mobility, requires wings)" = list(/datum/virtue/utility/winged_form)
	)