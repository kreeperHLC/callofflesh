#define NORTH_EDGING	"north"
#define SOUTH_EDGING	"south"
#define EAST_EDGING		"east"
#define WEST_EDGING		"west"

/turf/simulated/floor/plating/asteroid/snow/lite
	name = "snow"
	desc = "Выгл&#255;дит холодным."
	icon = 'icons/turf/snow.dmi'
	baseturf = /turf/simulated/floor/plating/asteroid/snow
	icon_state = "snow"
	icon_plating = "snow"
	temperature = 293
	slowdown = 4
	environment_type = "snow"
	dug = 1

/obj/structure/grille/stalker
	desc = "Хороший, крепкий железный забор."
	name = "fence"
	icon = 'icons/stalker/structure.dmi'
	icon_state = "fence1"
	density = 1
	anchored = 1
	flags = CONDUCT
	layer = 2.9
	health = 10000000

/obj/structure/grille/stalker/ex_act(severity, target)
	return

/obj/structure/grille/stalker/attack_paw(mob/user)
	return

/obj/structure/grille/stalker/attack_hand(mob/living/user)
	user.do_attack_animation(src)
	return

/obj/structure/grille/stalker/attack_animal(var/mob/living/simple_animal/M)
	M.do_attack_animation(src)
	return

/obj/structure/grille/stalker/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return
	..()
	if((Proj.damage_type != STAMINA)) //Grilles can't be exhausted to death
		return
	return

/obj/structure/grille/stalker/attackby(obj/item/weapon/W, mob/user, params)
	return

/obj/structure/grille/hitby(AM as mob|obj)
	..()
	return

/obj/structure/grille/stalker/wood
	desc = "Хороший, старый дерев&#255;нный забор."
	icon_state = "zabor_horizontal1"
	density = 1
	opacity = 0

/obj/structure/grille/stalker/beton
	icon = 'icons/stalker/beton_zabor.dmi'
	desc = "Слишком крепкий."
	icon_state = "1"
	density = 1
	opacity = 1

/obj/structure/grille/stalker/beton/green
	icon = 'icons/stalker/green_zabor.dmi'
	desc = "Зелённый забор лучше, чем серый."
	icon_state = "1"
	layer = 6.1

obj/structure/grille/stalker/beton/CanPass(atom/movable/mover, turf/target, height=0)
	if(height==0) return 1
	if(istype(mover) && mover.checkpass(PASSGRILLE))
		return 1
	else
		if(istype(mover, /obj/item/projectile) && density)
			return prob(0)
		else
			return !density

/turf/stalker
	name = "stalker turf"
	icon = 'icons/stalker/grass.dmi'

/turf/stalker/floor
	name = "Grass"
	icon = 'icons/stalker/grass.dmi'
	icon_state = "grass1"
	layer = TURF_LAYER

/turf/stalker/floor/digable


/turf/stalker/floor/digable/grass
	icon = 'icons/stalker/zemlya.dmi'
	icon_state = "grass1"

/turf/stalker/floor/digable/grass/New()
	icon_state = "grass[rand(1, 3)]"

/turf/stalker/floor/digable/grass/dump
	icon = 'icons/stalker/zemlya.dmi'
	icon_state = "dump_grass1"

/turf/stalker/floor/digable/grass/dump/New()
	icon_state = "dump_grass[rand(1, 3)]"

/turf/stalker/floor/sidor
	name = "floor"
	icon = 'icons/turf/beton.dmi'
	icon_state = "sidorpol"

/obj/machinery/door/unpowered/stalker
	icon = 'icons/turf/beton.dmi'

/turf/stalker/floor/asphalt
	name = "road"
	icon = 'icons/stalker/Prishtina/asphalt.dmi'
	icon_state = "road3"
	layer = 2.01

/turf/stalker/floor/tropa
	name = "road"
	icon = 'icons/stalker/tropa.dmi'
	icon_state = "road3"
	layer = 2.01

/turf/stalker/floor/road
	name = "road"
	icon = 'icons/stalker/building_road.dmi'
	icon_state = "road2"
	layer = 2.01

/turf/stalker/floor/road/New()
	if(prob(80))
		icon_state = "road1"
	else if (prob(50))
		icon_state = "road2"
	else if(prob(50))
		icon_state = "road3"
	else if (prob(50))
		icon_state = "road4"
	else
		icon_state = "road5"

/turf/stalker/floor/gryaz
	name = "dirt"
	icon = 'icons/stalker/zemlya.dmi'
	icon_state = "gryaz1"
	layer = 2.01

var/global/list/GryazEdgeCache

/turf/stalker/floor/gryaz/New()
	icon_state = "gryaz[rand(1, 3)]"
	if(!GryazEdgeCache || !GryazEdgeCache.len)
		GryazEdgeCache = list()
		GryazEdgeCache.len = 4
		GryazEdgeCache[NORTH_EDGING] = image('icons/stalker/zemlya.dmi', "gryaz_side_n", layer = 2.01)
		GryazEdgeCache[SOUTH_EDGING] = image('icons/stalker/zemlya.dmi', "gryaz_side_s", layer = 2.01)
		GryazEdgeCache[EAST_EDGING] = image('icons/stalker/zemlya.dmi', "gryaz_side_e", layer = 2.01)
		GryazEdgeCache[WEST_EDGING] = image('icons/stalker/zemlya.dmi', "gryaz_side_w", layer = 2.01)

	spawn(1)
		var/turf/T
		if((!istype(get_step(src, NORTH), /turf/stalker/floor/gryaz))  && (!istype(get_step(src, NORTH), /turf/simulated)))
			T = get_step(src, NORTH)
			if (T)
				T.overlays += GryazEdgeCache[SOUTH_EDGING]
		if((!istype(get_step(src, SOUTH), /turf/stalker/floor/gryaz)) && (!istype(get_step(src, SOUTH), /turf/simulated)))
			T = get_step(src, SOUTH)
			if (T)
				T.overlays += GryazEdgeCache[NORTH_EDGING]
		if((!istype(get_step(src, EAST), /turf/stalker/floor/gryaz)) && (!istype(get_step(src, EAST), /turf/simulated)))
			T = get_step(src, EAST)
			if (T)
				T.overlays += GryazEdgeCache[WEST_EDGING]
		if((!istype(get_step(src, WEST), /turf/stalker/floor/gryaz)) && (!istype(get_step(src, WEST), /turf/simulated)))
			T = get_step(src, WEST)
			if (T)
				T.overlays += GryazEdgeCache[EAST_EDGING]
	return

/*
/turf/stalker/floor/gryaz_border
	name = "dirt"
	icon = 'icons/stalker/zemlya.dmi'
	icon_state = "gryaz1"
	layer = 2.2


/turf/stalker/floor/gryaz/New()
	icon_state = "gryaz[rand(1, 3)]"
*/

/turf/stalker/floor/gryaz/gryaz2
	icon_state = "gryaz2"

/turf/stalker/floor/gryaz/gryaz3
	icon_state = "gryaz3"

/obj/structure/stalker/rails
	name = "rails"
	icon = 'icons/stalker/rails.dmi'
	icon_state = "sp"
	layer = 2.01
	anchored = 1
	density = 0
	opacity = 0

/turf/stalker/floor/plasteel
	name = "floor"
	icon = 'icons/stalker/floor.dmi'

/turf/stalker/floor/plasteel/plita
	icon_state = "plita1"

/turf/stalker/floor/plasteel/plita/New()
	icon_state = "plita[rand(1, 4)]"

/turf/stalker/floor/plasteel/plitochka
	icon_state = "plitka1"

/turf/stalker/floor/plasteel/plitochka/New()
	icon_state = "plitka[rand(1, 7)]"

/turf/stalker/floor/plasteel/plitka
	icon_state = "plitka_old1"

/turf/stalker/floor/plasteel/plitka/New()
	icon_state = "plitka_old[rand(1, 8)]"

/turf/stalker/floor/water
	name = "water"
	icon = 'icons/stalker/water.dmi'
	icon_state = "tupo_woda"

/turf/stalker/floor/wood
	icon = 'icons/stalker/floor.dmi'
	name = "floor"

/turf/stalker/floor/wood/brown
	icon_state = "wooden_floor"

/turf/stalker/floor/wood/grey
	icon_state = "wooden_floor2"

/turf/stalker/floor/wood/black
	icon_state = "wooden_floor3"

/turf/stalker/floor/wood/oldgor
	icon_state = "wood1"

/turf/stalker/floor/wood/oldvert
	icon_state = "woodd1"

/turf/stalker/floor/agroprom/beton
	name = "floor"
	icon = 'icons/stalker/pol_agroprom.dmi'
	icon_state = "beton1"

/turf/stalker/floor/agroprom/beton/New()
	icon_state = "beton[rand(1, 4)]"

/turf/stalker/floor/agroprom/gryaz
	name = "dirt"
	icon = 'icons/stalker/pol_agroprom.dmi'
	icon_state = "gryaz1"

/turf/stalker/floor/agroprom/gryaz/New()
	icon_state = "gryaz[rand(1, 11)]"