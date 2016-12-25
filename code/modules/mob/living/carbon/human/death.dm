/mob/living/carbon/human/gib_animation(animate)
	..(animate, "gibbed-h")

/mob/living/carbon/human/dust_animation(animate)
	..(animate, "dust-h")

/mob/living/carbon/human/dust(animation = 1)
	..()

/mob/living/carbon/human/spawn_gibs()
	hgibs(loc, viruses, dna)

/mob/living/carbon/human/spawn_dust()
	new /obj/effect/decal/remains/human(loc)

var/onelive = 1

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)
		return
	if(healths)
		healths.icon_state = "health5"
	stat = DEAD
	dizziness = 0
	jitteriness = 0
	heart_attack = 0

	if(istype(loc, /obj/mecha))
		var/obj/mecha/M = loc
		if(M.occupant == src)
			M.go_out()

	if(!gibbed)
		emote("deathgasp") //let the world KNOW WE ARE DEAD

		update_canmove()
		if(client)
			blind.layer = 0
			blind.alpha = 0

	dna.species.spec_death(gibbed,src)

//��������� �����
	var/mob/living/carbon/human/dead_character = new(loc)
	client.prefs.copy_to(dead_character)
	dead_character.dna.update_dna_identity()
	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.transfer_to(dead_character)					//won't transfer key since the mind is not active

	//dead_character.name = real_name

	dead_character.key = last_ckey
	dead_character.loc = hell.loc
	dead_character.equipOutfit(/datum/outfit/phantom)

	if (GetKarma(dead_character.key) <= 800)
	//	if(TR_HASHNAME)
		dead_character.real_name = "bad phantom ([dead_character.name])"
		dead_character.name = dead_character.real_name			//[copytext(md5(real_name), 2, 6)

	else //if (GetKarma(dead_character.key) <= 1100)
		dead_character.real_name = "phantom ([dead_character.name])"
		dead_character.name = dead_character.real_name

	var/mob/DEADONE = dead_character
	var/mob/new_player/NP = new()
	if (onelive != 0)
		onelive = 0
		spawn(9000)
			NP.ckey = dead_character.ckey
			qdel(DEADONE)
			onelive = 1
	if (onelive == 0)
		qdel(DEADONE)
//

	tod = worldtime2text()		//weasellos time of death patch
	if(mind)	mind.store_memory("Time of death: [tod]", 0)
	if(ticker && ticker.mode)
//		world.log << "k"
		sql_report_death(src)
		ticker.mode.check_win()		//Calls the rounds wincheck, mainly for wizard, malf, and changeling now
	let_justice_be_done()
	return ..(gibbed)

var/obj/hellpoint/hell = null

/obj/hellpoint
	invisibility = 101

/obj/hellpoint/New()
	hell = src

/mob/living/carbon/human/proc/makeSkeleton()
	status_flags |= DISFIGURED
	set_species(/datum/species/skeleton)
	return 1

/mob/living/carbon/proc/ChangeToHusk()
	if(disabilities & HUSK)	return
	disabilities |= HUSK
	status_flags |= DISFIGURED	//makes them unknown without fucking up other stuff like admintools
	return 1

/mob/living/carbon/human/ChangeToHusk()
	. = ..()
	if(.)
		update_hair()
		update_body()

/mob/living/carbon/proc/Drain()
	ChangeToHusk()
	disabilities |= NOCLONE
	return 1
