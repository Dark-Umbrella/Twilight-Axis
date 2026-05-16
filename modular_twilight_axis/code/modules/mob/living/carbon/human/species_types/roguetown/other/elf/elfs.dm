/datum/species/elf/wood
	race_bonus = list()
	custom_selection = list(
		"+1 SPD, +1 INT" = list(STAT_SPEED = 1, STAT_INTELLIGENCE = 1),
		"Azurean Native (Force Origin, No Ambush if not Run)" = list(TRAIT_AZURENATIVE, /datum/virtue/origin/azuria),
		"Lesser Forest Blessing (No Leech, Kneestingers Immunity, Harmony With Animals)" = list(TRAIT_LEECHIMMUNE, TRAIT_SHOCKIMMUNE, /datum/virtue/utility/harmony)
		)