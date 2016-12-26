#define DMG_TYPE_GIB 1
#define DMG_TYPE_ENERGY 2
#define DMG_TYPE_BURN 4
#define DMG_TYPE_BRAIN 8
#define DMG_TYPE_RADIATION 16
#define DMG_TYPE_IGNITION 32
#define DMG_TYPE_BIO 64





/obj/anomaly
	name = "Anomaly"
	var/damage_amount = 0 				//Сколько дамажит
	var/damage_type = DMG_TYPE_ENERGY	//Тип дамага
	var/activated_icon_state = null 	//Спрайт при активации
	var/cooldown = 5 					//Кулдаун в секундах
	var/incooldown = 0
	var/list/trapped = new/list()
	var/idle_luminosity = 0
	var/activated_luminosity = 0
	var/sound = null
	var/delay = 0
	var/attachedSpawner = null
	var/active_icon_state = null
	var/inactive_icon_state = null;
	icon = 'icons/stalker/anomalies.dmi'
	unacidable = 1
	anchored = 1
	pass_flags = PASSTABLE | PASSGRILLE

/obj/anomaly/New()
	..()
	if(prob(30))
		if(attachedSpawner)
			new attachedSpawner(src)
	icon_state = inactive_icon_state

/obj/anomaly/Crossed(atom/A)
	..()
	if(!incooldown && !istype(A,/obj/item/projectile) && !istype(A,/obj/item/weapon/artefact))
		icon_state = active_icon_state
		spawn(10)
			icon_state = inactive_icon_state

		if (!incooldown && istype(A,/mob/living))
			playsound(src.loc, src.sound, 50, 1, channel = 0)
			var/mob/living/carbon/M = A
			src.trapped.Add(M)
			if(src.trapped.len == 1 && !incooldown)
				src.Think()

		else if(!incooldown && istype(A,/obj/item))
			playsound(src.loc, src.sound, 50, 1, channel = 0)
			src.incooldown = 1
			var/obj/item/Q = A
			if(Q.unacidable == 0)
				spawn(5)
					var/turf/T = get_turf(Q)
					var/obj/effect/decal/cleanable/molten_item/I = new (T)
					I.pixel_x = rand(-16,16)
					I.pixel_y = rand(-16,16)
					I.desc = "Looks like this was \an [Q] some time ago."
					if(istype(A,/obj/item/weapon/storage))
						var/obj/item/weapon/storage/S = Q
						S.do_quick_empty()
					qdel(Q)
					//trapped.Remove(Q)
					spawn(src.delay * 10 - 5)
						qdel(I)
			spawn(src.delay * 10)
				src.incooldown = 0

/obj/anomaly/Uncrossed(atom/A)
	..()
	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		src.trapped.Remove(M)
//	if (istype(A,/obj/item) && !istype(A,/obj/item/projectile) && !istype(A,/obj/item/weapon/artefact))
//		var/obj/item/O = A
//		src.trapped.Remove(O)

/obj/anomaly/proc/Think()
	playsound(src.loc, src.sound, 50, 1, channel = 0)
	spawn(src.delay * 10)
		for(var/atom/A in src.trapped)
			if(istype(A, /mob/living))
				var/mob/living/carbon/human/M = A
				switch(src.damage_type)
					if(DMG_TYPE_ENERGY)
						M.apply_damage(src.damage_amount, BURN, null, M.getarmor(null, "electro"))
					if(DMG_TYPE_BIO)
						M.apply_damage(src.damage_amount, BURN, null, M.getarmor(null, "bio"))
					if(DMG_TYPE_RADIATION)
						M.rad_act(src.damage_amount)
					if(DMG_TYPE_GIB)
						M.gib()
						trapped.Remove(M)
					if(DMG_TYPE_IGNITION)
						A.fire_act()
	src.set_light(src.activated_luminosity)
	spawn(10)
		src.set_light(src.idle_luminosity)
	src.incooldown = 1
	spawn(src.cooldown * 10)
		src.incooldown = 0
		if(src.trapped.len > 0)
			src.Think()
	return

/obj/anomaly/electro
	name = "anomaly"
	damage_amount = 40
	cooldown = 2
	sound = 'sound/stalker/anomalies/electra_blast1.ogg'
	idle_luminosity = 1
	activated_luminosity = 2
	damage_type = DMG_TYPE_ENERGY
	inactive_icon_state = "electra0"
	active_icon_state = "electra1"

/obj/anomaly/electro/New()
	..()
	src.set_light(luminosity)

/obj/anomaly/tramplin
	name = "anomaly"
	damage_amount = 40
	cooldown = 2
	delay = 1
	sound = 'sound/stalker/anomalies/gravi_blowout1.ogg'
	idle_luminosity = 0
	activated_luminosity = 0
	inactive_icon_state = "tramplin0"
	active_icon_state = "tramplin1"
	damage_type = DMG_TYPE_GIB

/obj/anomaly/jarka
	name = "anomaly"
	cooldown = 20
	sound = 'sound/stalker/anomalies/zharka1.ogg'
	luminosity = 2
	idle_luminosity = 3
	activated_luminosity = 5
	damage_type = DMG_TYPE_IGNITION
	icon = 'icons/stalker/anomalies.dmi'
	inactive_icon_state = "jarka0"
	active_icon_state = "jarka1"

/obj/anomaly/holodec
	name = "anomaly"
	luminosity = 3
	idle_luminosity = 3
	activated_luminosity = 5
	sound = 'sound/stalker/anomalies/buzz_hit.ogg'
	damage_type = DMG_TYPE_BIO
	damage_amount = 30
	icon = 'icons/stalker/anomalies.dmi'
	inactive_icon_state = "holodec"
	active_icon_state = "holodec" //need activation icon

/obj/anomaly/puh
	name = "anomaly"
	sound = 'sound/stalker/anomalies/buzz_hit.ogg'
	damage_type = DMG_TYPE_BIO
	damage_amount = 15
	icon = 'icons/stalker/anomalies.dmi'
	inactive_icon_state = "puh"
	active_icon_state = "puh" //need activation icon

/obj/anomaly/puh/puh2
	icon = 'icons/stalker/anomalies.dmi'
	inactive_icon_state = "puh2"
	active_icon_state = "puh2"

/obj/anomaly/fake
	name = "anomaly"

/obj/rad 	//Не наносит урона
	name = "Anomaly"
	var/damage_amount = 0 				//Сколько дамажит
	var/damage_type = DMG_TYPE_RADIATION	//Тип дамага
	var/activated_icon_state = null 	//Спрайт при активации
	var/cooldown = 1 					//Кулдаун в секундах
	var/incooldown = 0
	var/list/trapped = new/list()
	var/idle_luminosity = 0
	var/activated_luminosity = 0
	var/sound = null
	var/delay = 0
	var/attachedSpawner = null
	var/active_icon_state = null
	var/inactive_icon_state = null;
	icon = 'icons/stalker/anomalies.dmi'
	unacidable = 1
	anchored = 1
	pass_flags = PASSTABLE | PASSGRILLE

/obj/rad/rad_low
	damage_amount = 1
	sound = 'sound/stalker/pda/geiger_1.ogg'

/obj/rad/rad_medium
	damage_amount = 5
	sound = 'sound/stalker/pda/geiger_4.ogg'

/obj/rad/rad_high
	damage_amount = 20
	sound = 'sound/stalker/pda/geiger_6.ogg'


/obj/rad/Crossed(atom/A)
	..()
	if(!incooldown && istype(A,/mob/living))
		var/mob/living/carbon/M = A
		M << sound(src.sound, repeat = 0, wait = 0, volume = 50, channel = 3)
		src.trapped.Add(M)
		if(src.trapped.len == 1 && !incooldown)
			src.ThinkRad()

/obj/rad/Uncrossed(atom/A)
	..()
	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		src.trapped.Remove(M)

/obj/rad/proc/ThinkRad()
	//playsound(src.loc, src.sound, 50, 1, channel = 0)
	spawn(src.delay * 10)
		for(var/atom/A in src.trapped)
			if(istype(A, /mob/living))
				var/mob/living/carbon/human/M = A
				switch(src.damage_type)
					if(DMG_TYPE_ENERGY)
						M.apply_damage(src.damage_amount, BURN, null, M.getarmor(null, "electro"))
					if(DMG_TYPE_BIO)
						M.apply_damage(src.damage_amount, BURN, null, M.getarmor(null, "bio"))
					if(DMG_TYPE_RADIATION)
						M.rad_act(src.damage_amount)
					if(DMG_TYPE_GIB)
						M.gib()
						trapped.Remove(M)
					if(DMG_TYPE_IGNITION)
						A.fire_act()
	src.set_light(src.activated_luminosity)
	spawn(10)
		src.set_light(src.idle_luminosity)
	src.incooldown = 1
	spawn(src.cooldown * 10)
		src.incooldown = 0
		if(src.trapped.len > 0)
			src.ThinkRad()
	return