// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/weapon/light)


// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3
/*


/obj/item/wallframe/light_fixture
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	result_path = /obj/machinery/light_construct
	inverse = 1

/obj/item/wallframe/light_fixture/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	result_path = /obj/machinery/light_construct/small
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)


/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = 1
	layer = 5
	var/stage = 1
	var/fixture_type = "tube"
	var/sheets_refunded = 2
	var/obj/machinery/light/newlight = null

/obj/machinery/light_construct/New(loc, ndir, building)
	..()
	if(building)
		dir = ndir

/obj/machinery/light_construct/examine(mob/user)
	..()
	switch(src.stage)
		if(1)
			user << "It's an empty frame."
		if(2)
			user << "It's wired."
		if(3)
			user << "The casing is closed."

/obj/machinery/light_construct/attackby(obj/item/weapon/W, mob/user, params)
	add_fingerprint(user)
	switch(stage)
		if(1)
			if(istype(W, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				usr << "<span class='notice'>You begin deconstructing [src]...</span>"
				if (!do_after(usr, 30/W.toolspeed, target = src))
					return
				new /obj/item/stack/sheet/metal( get_turf(src.loc), sheets_refunded )
				user.visible_message("[user.name] deconstructs [src].", \
					"<span class='notice'>You deconstruct [src].</span>", "<span class='italics'>You hear a ratchet.</span>")
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 75, 1)
				qdel(src)
				return

			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/coil = W
				if(coil.use(1))
					switch(fixture_type)
						if ("tube")
							icon_state = "tube-construct-stage2"
						if("bulb")
							icon_state = "bulb-construct-stage2"
					stage = 2
					user.visible_message("[user.name] adds wires to [src].", \
						"<span class='notice'>You add wires to [src].</span>")
				else
					user << "<span class='warning'>You need one length of cable to wire [src]!</span>"
				return
		if(2)
			if(istype(W, /obj/item/weapon/wrench))
				usr << "<span class='warning'>You have to remove the wires first!</span>"
				return

			if(istype(W, /obj/item/weapon/wirecutters))
				stage = 1
				switch(fixture_type)
					if ("tube")
						icon_state = "tube-construct-stage1"
					if("bulb")
						icon_state = "bulb-construct-stage1"
				new /obj/item/stack/cable_coil(get_turf(loc), 1, "red")
				user.visible_message("[user.name] removes the wiring from [src].", \
					"<span class='notice'>You remove the wiring from [src].</span>", "<span class='italics'>You hear clicking.</span>")
				playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
				return

			if(istype(W, /obj/item/weapon/screwdriver))
				user.visible_message("[user.name] closes [src]'s casing.", \
					"<span class='notice'>You close [src]'s casing.</span>", "<span class='italics'>You hear screwing.</span>")
				playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
				switch(fixture_type)
					if("tube")
						newlight = new /obj/machinery/light/built(loc)
					if ("bulb")
						newlight = new /obj/machinery/light/small/built(loc)
				newlight.dir = dir
				transfer_fingerprints_to(newlight)
				qdel(src)
				return
	..()


/obj/machinery/light_construct/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-stage1"
	fixture_type = "bulb"
	sheets_refunded = 1

// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube1"
	desc = "A lighting fixture."
	anchored = 1
	layer = 5  					// They were appearing under mobs which is a little weird - Ostaf
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	var/on = 0					// 1 if on, 0 if off
	var/on_gs = 0
	var/static_power_used = 0
	var/brightness = 8			// luminosity when on, also used in power calculation
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = 0
	var/light_type = /obj/item/weapon/light/tube		// the type of light item
	var/fitting = "tube"
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = 0				// true if rigged to explode

// the smaller bulb light fixture

/obj/machinery/light/small
	icon_state = "bulb1"
	base_state = "bulb"
	fitting = "bulb"
	brightness = 4
	desc = "A small lighting fixture."
	light_type = /obj/item/weapon/light/bulb


/obj/machinery/light/Move()
	if(status != LIGHT_BROKEN)	broken(1)
	return ..()

/obj/machinery/light/built/New()
	status = LIGHT_EMPTY
	update(0)
	..()

/obj/machinery/light/small/built/New()
	status = LIGHT_EMPTY
	update(0)
	..()


// create a new lighting fixture
/obj/machinery/light/New()
	..()
	spawn(2)
		switch(fitting)
			if("tube")
				brightness = 8
				if(prob(2))
					broken(1)
			if("bulb")
				brightness = 4
				if(prob(5))
					broken(1)
		spawn(1)
			update(0)

///obj/machinery/light/Destroy()
//	var/area/A = get_area(src)
//	if(A)
//		on = 0
//		A.update_lights()
//	return ..()

/obj/machinery/light/update_icon()

	switch(status)		// set icon_states
		if(LIGHT_OK)
			icon_state = "[base_state][on]"
		if(LIGHT_EMPTY)
			icon_state = "[base_state]-empty"
			on = 0
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			on = 0
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			on = 0
	return

// update the icon_state and luminosity of the light depending on its state
/obj/machinery/light/proc/update(trigger = 1)

	update_icon()
	if(on)
		if(!light || light.light_range != brightness)
			switchcount++
			if(rigged)
				if(status == LIGHT_OK && trigger)
					explode()
			else if( prob( min(60, switchcount*switchcount*0.01) ) )
				if(status == LIGHT_OK && trigger)
					status = LIGHT_BURNED
					icon_state = "[base_state]-burned"
					on = 0
					set_light(0)
			else
				use_power = 2
				set_light(brightness)
	else
		use_power = 1
		set_light(0)

	active_power_usage = (brightness * 10)
	if(on != on_gs)
		on_gs = on
		if(on)
			static_power_used = brightness * 20 //20W per unit luminosity
			addStaticPower(static_power_used, STATIC_LIGHT)
		else
			removeStaticPower(static_power_used, STATIC_LIGHT)


// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(s)
	on = (s && status == LIGHT_OK)
	update()

// examine verb
/obj/machinery/light/examine(mob/user)
	..()
	switch(status)
		if(LIGHT_OK)
			user << "It is turned [on? "on" : "off"]."
		if(LIGHT_EMPTY)
			user << "The [fitting] has been removed."
		if(LIGHT_BURNED)
			user << "The [fitting] is burnt out."
		if(LIGHT_BROKEN)
			user << "The [fitting] has been smashed."



// attack with item - insert light (if right type), otherwise try to break the light

/obj/machinery/light/attackby(obj/item/W, mob/living/user, params)

	//Light replacer code
	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = W
		if(isliving(user))
			var/mob/living/U = user
			LR.ReplaceLight(src, U)
			return

	// attempt to insert light
	if(istype(W, /obj/item/weapon/light))
		if(status != LIGHT_EMPTY)
			user << "<span class='warning'>There is a [fitting] already inserted!</span>"
			return
		else
			src.add_fingerprint(user)
			var/obj/item/weapon/light/L = W
			if(istype(L, light_type))
				if(!user.drop_item())
					return
				status = L.status
				user << "<span class='notice'>You insert the [L.name].</span>"
				switchcount = L.switchcount
				rigged = L.rigged
				brightness = L.brightness
				on = has_power()
				update()

				qdel(L)

				if(on && rigged)
					explode()
			else
				user << "<span class='warning'>This type of light requires a [fitting]!</span>"
				return

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(src)
		if(W.damtype == STAMINA)
			return
		if(prob(1+W.force * 5))

			user.visible_message("<span class='danger'>[user.name] smashed the light!</span>", \
								"<span class='danger'>You hit the light, and it smashes!</span>", \
								 "<span class='italics'>You hear a tinkle of breaking glass.</span>")
			if(on && (W.flags & CONDUCT))
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			user.visible_message("<span class='danger'>[user.name] hits the light!</span>")

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(istype(W, /obj/item/weapon/screwdriver)) //If it's a screwdriver open it.
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 75, 1)
			user.visible_message("[user.name] opens [src]'s casing.", \
				"<span class='notice'>You open [src]'s casing.</span>", "<span class='italics'>You hear a noise.</span>")
			var/obj/machinery/light_construct/newlight = null
			switch(fitting)
				if("tube")
					newlight = new /obj/machinery/light_construct(src.loc)
					newlight.icon_state = "tube-construct-stage2"

				if("bulb")
					newlight = new /obj/machinery/light_construct/small(src.loc)
					newlight.icon_state = "bulb-construct-stage2"
			newlight.dir = src.dir
			newlight.stage = 2
			transfer_fingerprints_to(newlight)
			qdel(src)
			return

		user << "<span class='userdanger'>You stick \the [W] into the light socket!</span>"
		if(has_power() && (W.flags & CONDUCT))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))


// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/proc/has_power()
	var/area/A = src.loc.loc
	return A.master.lightswitch && A.master.power_light

/obj/machinery/light/proc/flicker(var/amount = rand(10, 20))
	if(flickering) return
	flickering = 1
	spawn(0)
		if(on && status == LIGHT_OK)
			for(var/i = 0; i < amount; i++)
				if(status != LIGHT_OK) break
				on = !on
				update(0)
				sleep(rand(5, 15))
			on = (status == LIGHT_OK)
			update(0)
		flickering = 0

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/user)
	src.flicker(1)
	return

// Aliens smash the bulb but do not get electrocuted./N
/obj/machinery/light/attack_alien(mob/living/carbon/alien/humanoid/user)//So larva don't go breaking light bulbs.
	if(status == LIGHT_EMPTY||status == LIGHT_BROKEN)
		user << "\green That object is useless to you."
		return
	else if (status == LIGHT_OK||status == LIGHT_BURNED)
		user.do_attack_animation(src)
		visible_message("<span class='danger'>[user.name] smashed the light!</span>", "<span class='italics'>You hear a tinkle of breaking glass.</span>")
		broken()
	return

/obj/machinery/light/attack_animal(mob/living/simple_animal/M)
	if(M.melee_damage_upper == 0)	return
	if(status == LIGHT_EMPTY||status == LIGHT_BROKEN)
		M << "<span class='danger'>That object is useless to you.</span>"
		return
	else if (status == LIGHT_OK||status == LIGHT_BURNED)
		M.do_attack_animation(src)
		visible_message("<span class='danger'>[M.name] smashed the light!</span>", "<span class='italics'>You hear a tinkle of breaking glass.</span>")
		broken()
	return
// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player

/obj/machinery/light/attack_hand(mob/living/carbon/human/user)
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		user << "There is no [fitting] in this light."
		return

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))

			if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					prot = (G.max_heat_protection_temperature > 360)
		else
			prot = 1

		if(prot > 0)
			user << "<span class='notice'>You remove the light [fitting].</span>"
		else if(istype(user) && user.dna.check_mutation(TK))
			user << "<span class='notice'>You telekinetically remove the light [fitting].</span>"
		else
			user << "<span class='warning'>You try to remove the light [fitting], but you burn your hand on it!</span>"

			var/obj/item/organ/limb/affecting = H.get_organ("[user.hand ? "l" : "r" ]_arm")
			if(affecting.take_damage( 0, 5 ))		// 5 burn damage
				H.update_damage_overlays(0)
			H.updatehealth()
			return				// if burned, don't remove the light
	else
		user << "<span class='notice'>You remove the light [fitting].</span>"
	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/weapon/light/L = new light_type()
	L.status = status
	L.rigged = rigged
	L.brightness = brightness

	// light item inherits the switchcount, then zero it
	L.switchcount = switchcount
	switchcount = 0

	L.update()
	L.add_fingerprint(user)
	L.loc = loc

	user.put_in_active_hand(L)	//puts it in our active hand

	status = LIGHT_EMPTY
	update()

/obj/machinery/light/attack_tk(mob/user)
	if(status == LIGHT_EMPTY)
		user << "There is no [fitting] in this light."
		return

	user << "<span class='notice'>You telekinetically remove the light [fitting].</span>"
	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/weapon/light/L = new light_type()
	L.status = status
	L.rigged = rigged
	L.brightness = brightness

	// light item inherits the switchcount, then zero it
	L.switchcount = switchcount
	switchcount = 0

	L.update()
	L.add_fingerprint(user)
	L.loc = loc

	status = LIGHT_EMPTY
	update()

// break the light and make sparks if was on

/obj/machinery/light/proc/broken(skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		if(on)
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
	status = LIGHT_BROKEN
	update()

/obj/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK
	brightness = initial(brightness)
	on = 1
	update()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/machinery/light/ex_act(severity, target)
	..()
	if(!gc_destroyed)
		switch(severity)
			if(2)
				if(prob(50))
					broken()
			if(3)
				if(prob(25))
					broken()

// called when area power state changes
/obj/machinery/light/power_change()
	var/area/A = get_area(src)
	A = A.master
	seton(A.lightswitch && A.power_light)

// called when on fire

/obj/machinery/light/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

// explode the light

/obj/machinery/light/proc/explode()
	var/turf/T = get_turf(src.loc)
	spawn(0)
		broken()	// break it first to give a warning
		sleep(2)
		explosion(T, 0, 0, 2, 2)
		sleep(1)
		qdel(src)

// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/weapon/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = 1
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	materials = list(MAT_METAL=60)
	var/rigged = 0		// true if rigged to explode
	var/brightness = 2 //how much light it gives off

/obj/item/weapon/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	materials = list(MAT_GLASS=100)
	brightness = 8

/obj/item/weapon/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	materials = list(MAT_GLASS=100)
	brightness = 4

/obj/item/weapon/light/throw_impact(atom/hit_atom)
	..()
	shatter()

// update the icon state and description of the light

/obj/item/weapon/light/proc/update()
	switch(status)
		if(LIGHT_OK)
			icon_state = base_state
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			desc = "A broken [name]."


/obj/item/weapon/light/New()
	..()
	update()


// attack bulb/tube with object
// if a syringe, can inject plasma to make it explode
/obj/item/weapon/light/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = I

		user << "<span class='notice'>You inject the solution into \the [src].</span>"

		if(S.reagents.has_reagent("plasma", 5))

			rigged = 1

		S.reagents.clear_reagents()
	else
		..()
	return

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/weapon/light/afterattack(atom/target, mob/user,proximity)
	if(!proximity) return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != "harm")
		return

	shatter()

/obj/item/weapon/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		src.visible_message("<span class='danger'>[name] shatters.</span>","<span class='italics'>You hear a small glass object shatter.</span>")
		status = LIGHT_BROKEN
		force = 5
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		update()
*/

























#define LIGHT_BULB_TEMPERATURE 400 //K - used value for a 60W bulb
#define LIGHTING_POWER_FACTOR 5		//5W per luminosity * range

var/global/list/light_bulb_type_cache = list()
/proc/get_light_bulb_type_instance(var/light_bulb_type)
	. = light_bulb_type_cache[light_bulb_type]
	if(!.)
		. = new light_bulb_type
		light_bulb_type_cache[light_bulb_type] = .

/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = 1
	layer = 5

	var/stage = 1
	var/fixture_type = /obj/machinery/light
	var/sheets_refunded = 2

/obj/machinery/light_construct/New(atom/newloc, var/newdir, atom/fixture = null)
	..(newloc)

	if(newdir)
		set_dir(newdir)

	if(istype(fixture))
		if(istype(fixture, /obj/machinery/light))
			fixture_type = fixture.type
		fixture.transfer_fingerprints_to(src)
		stage = 2

	update_icon()

/obj/machinery/light_construct/update_icon()
	switch(stage)
		if(1) icon_state = "tube-construct-stage1"
		if(2) icon_state = "tube-construct-stage2"
		if(3) icon_state = "tube-empty"

/obj/machinery/light_construct/examine(mob/user)
	if(!..(user, 2))
		return

	switch(src.stage)
		if(1) user << "It's an empty frame."
		if(2) user << "It's wired."
		if(3) user << "The casing is closed."

/obj/machinery/light_construct/attackby(var/obj/item/W, var/mob/user)
	src.add_fingerprint(user)
	//if (W.iswrench())
	//	if (src.stage == 1)
	//		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
	//		usr << "You begin deconstructing \a [src]."
	//		if (!do_after(usr, 30,src))
	//			return
	//		new /obj/item/stack/material/steel( get_turf(src.loc), sheets_refunded )
	//		user.visible_message("[user.name] deconstructs [src].", \
				"You deconstruct [src].", "You hear a noise.")
	//		playsound(src.loc, 'sound/items/Deconstruct.ogg', 75, 1)
		//	qdel(src)
	//	if (src.stage == 2)
	//		usr << "You have to remove the wires first."
	//		return
//
	//	if (src.stage == 3)
	//		usr << "You have to unscrew the case first."
	//		return

//	if(W.iswirecutter())
//		if (src.stage != 2) return
//		src.stage = 1
//		src.update_icon()
//		new /obj/item/stack/cable_coil(get_turf(src.loc), 1, "red")
//		user.visible_message("[user.name] removes the wiring from [src].", \
//			"You remove the wiring from [src].", "You hear a noise.")
//		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
//		return

//	if(W.iscoil())
//		if (src.stage != 1) return
//		var/obj/item/stack/cable_coil/coil = W
//		if (coil.use(1))
//			src.stage = 2
//			src.update_icon()
//			user.visible_message("[user.name] adds wires to [src].", \
//				"You add wires to [src].")
//		return

//	if(W.isscrewdriver())
//		if (src.stage == 2)
//			src.stage = 3
//			src.update_icon()
//			user.visible_message("[user.name] closes [src]'s casing.", \
//				"You close [src]'s casing.", "You hear a noise.")
//			playsound(src.loc, 'sound/items/Screwdriver.ogg', 75, 1)
//
//			var/obj/machinery/light/newlight = new fixture_type(src.loc, src)
//			newlight.set_dir(src.dir)
//
//			src.transfer_fingerprints_to(newlight)
//			qdel(src)
//			return
	return
	..()

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = 1
	layer = 5
	stage = 1
	fixture_type = /obj/machinery/light/small
	sheets_refunded = 1

/obj/machinery/light_construct/small/update_icon()
	switch(stage)
		if(1) icon_state = "bulb-construct-stage1"
		if(2) icon_state = "bulb-construct-stage2"
		if(3) icon_state = "bulb-empty"

// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube1"
	desc = "A lighting fixture."
	anchored = 1
	layer = 5  					// They were appearing under mobs which is a little weird - Ostaf
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list

	var/on = 0					// 1 if on, 0 if off
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = 0
	var/light_bulb_type = /obj/item/light/tube		// the type of light item
	var/construct_type = /obj/machinery/light_construct
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = 0				// true if rigged to explode
	//var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread

	//default lighting - these are obtained from light_bulb_type
	var/brightness_range = 5
	var/brightness_power = 4
	var/brightness_color
	var/list/lighting_modes

	var/current_mode = null

/obj/machinery/light/set_dir(var/newdir)
	. = ..(newdir)
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? 3 : -3)
	pixel_y = (dir & 3) ? (dir == 1 ? 3 : -3) : 0

// the smaller bulb light fixture
/obj/machinery/light/small
	icon_state = "bulb1"
	base_state = "bulb"
	desc = "A small lighting fixture."
	light_bulb_type = /obj/item/light/bulb
	construct_type = /obj/machinery/light_construct/small

/obj/machinery/light/small/emergency
	light_bulb_type = /obj/item/light/bulb/red

/obj/machinery/light/small/red
	light_bulb_type = /obj/item/light/bulb/red

/obj/machinery/light/spot
	name = "spotlight"
	light_bulb_type = /obj/item/light/tube/large

// create a new lighting fixture
/obj/machinery/light/New(atom/newloc, obj/machinery/light_construct/construct = null)
	..(newloc)

	//s.set_up(1, 1, src)

	if(construct)
		status = LIGHT_EMPTY
		construct_type = construct.type
		construct.transfer_fingerprints_to(src)
		set_dir(construct.dir)
	else
		var/obj/item/light/L = get_light_bulb_type_instance(light_bulb_type)
		update_from_bulb(L)
		//if(prob(L.broken_chance))
			//broken(1)
		pixel_x = (dir & 3) ? 0 : (dir == 4 ? 3 : -3)
		pixel_y = (dir & 3) ? (dir == 1 ? 3 : -3) : 0

	on = powered()
	update(0)


/obj/machinery/light/Destroy()
	var/area/A = get_area(src)
	//if(s)
	//	qdel(s)
	//	s = null
	if(A)
		on = 0
	//	A.update_lights()
	return ..()

/obj/machinery/light/update_icon()

	switch(status)		// set icon_states
		if(LIGHT_OK)
			icon_state = "[base_state][on]"
		if(LIGHT_EMPTY)
			icon_state = "[base_state]-empty"
			on = 0
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			on = 0
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			on = 0
	return

// update lighting
/obj/machinery/light/proc/update(var/trigger = 1)
	update_icon()
	if(on)
		use_power = 2

		var/changed = 0
		if(current_mode && (current_mode in lighting_modes))
			changed = set_light(arglist(lighting_modes[current_mode]))
		else
			changed = set_light(brightness_range, brightness_power, brightness_color)

		if(trigger && changed)
			switch_check()
	else
		use_power = 0
		light_off()

	active_power_usage = ((light_range * light_power) * LIGHTING_POWER_FACTOR)

/obj/machinery/light/proc/light_off()
	if(light_obj)
		light_obj.light_off()

/obj/machinery/light/proc/switch_check()
	if(status != LIGHT_OK)
		return //already busted

	switchcount++
	if(rigged)
		log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
		message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

		explode()
	else if( prob( min(60, switchcount*switchcount*0.01) ) )
		burn_out()
/*
/obj/machinery/light/attack_generic(var/mob/user, var/damage)
	if(!damage)
		return
	if(status == LIGHT_EMPTY||status == LIGHT_BROKEN)
		user << "That object is useless to you."
		return
	if(!(status == LIGHT_OK||status == LIGHT_BURNED))
		return
	visible_message("<span class='danger'>[user] smashes the light!</span>")
	//attack_animation(user)
	broken()
	return 1
*/
/obj/machinery/light/proc/set_mode(var/new_mode)
	if(current_mode != new_mode)
		current_mode = new_mode
		update(0)

/obj/machinery/light/proc/set_emergency_lighting(var/enable)
	if(enable)
		if("emergency_lighting" in lighting_modes)
			set_mode("emergency_lighting")
			power_channel = ENVIRON
	else
		if(current_mode == "emergency_lighting")
			set_mode(null)
			power_channel = initial(power_channel)

// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(var/s)
	on = (s && status == LIGHT_OK)
	update()

// examine verb
/obj/machinery/light/examine(mob/user)
	var/fitting = get_fitting_name()
	switch(status)
		if(LIGHT_OK)
			user << "[desc] It is turned [on? "on" : "off"]."
		if(LIGHT_EMPTY)
			user << "[desc] The [fitting] has been removed."
		if(LIGHT_BURNED)
			user << "[desc] The [fitting] is burnt out."
		if(LIGHT_BROKEN)
			user << "[desc] The [fitting] has been smashed."

/obj/machinery/light/proc/get_fitting_name()
	var/obj/item/light/L = light_bulb_type
	return initial(L.name)

/obj/machinery/light/proc/update_from_bulb(var/obj/item/light/L)
	status = L.status
	switchcount = L.switchcount
	rigged = L.rigged
	brightness_range = L.brightness_range
	brightness_power = L.brightness_power
	brightness_color = L.brightness_color
	lighting_modes = L.lighting_modes.Copy()

// attack with item - insert light (if right type), otherwise try to break the light

/obj/machinery/light/proc/insert_bulb(var/obj/item/light/L)
	update_from_bulb(L)
	qdel(L)

	on = powered()
	update()

	if(on && rigged)

		log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
		message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

		explode()

/obj/machinery/light/proc/remove_bulb()
	. = new light_bulb_type(src.loc, src)

	switchcount = 0
	status = LIGHT_EMPTY
	update()

/obj/machinery/light/attackby(obj/item/W, mob/user)
/*
	//Light replacer code
	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/lightreplacer/LR = W
		if(isliving(user))
			var/mob/living/U = user
			//LR.ReplaceLight(src, U)
			return

	// attempt to insert light
	if(istype(W, /obj/item/light))
		if(status != LIGHT_EMPTY)
			user << "There is a [get_fitting_name()] already inserted."
			return
		if(!istype(W, light_bulb_type))
			user << "This type of light requires a [get_fitting_name()]."
			return

		user << "You insert [W]."
		insert_bulb(W)
		src.add_fingerprint(user)

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)

		if(prob(1+W.force * 5))

			user << "You hit the light, and it smashes!"
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] smashed the light!", 3, "You hear a tinkle of breaking glass", 2)
			if(on && (W.flags & CONDUCT))
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			user << "You hit the light!"

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(W.isscrewdriver()) //If it's a screwdriver open it.
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 75, 1)
			user.visible_message("[user.name] opens [src]'s casing.", \
				"You open [src]'s casing.", "You hear a noise.")

			new construct_type(src.loc, src.dir, src)
			qdel(src)
			return

		user << "You stick \the [W] into the light socket!"
		if(powered() && (W.flags & CONDUCT))
			//var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			//s.set_up(3, 1, src)
		//	s.start()
			//if(!user.mutations & COLD_RESISTANCE)
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))
*/

// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/powered()
	var/area/A = get_area(src)
	return A && A.lightswitch && ..(power_channel)

/obj/machinery/light/proc/flicker(var/amount = rand(10, 20))
	if(flickering) return
	flickering = 1
	spawn(0)
		if(on && status == LIGHT_OK)
			for(var/i = 0; i < amount; i++)
				if(status != LIGHT_OK) break
				on = !on
				update(0)
				sleep(rand(5, 15))
			on = (status == LIGHT_OK)
			update(0)
		flickering = 0

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/user)
	src.flicker(1)
	return

// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player
/obj/machinery/light/attack_hand(mob/user)

	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		user << "There is no [get_fitting_name()] in this light."
		return

	//if(istype(user,/mob/living/carbon/human))
		//var/mob/living/carbon/human/H = user
		//if(H.species.can_shred(H))
		//	for(var/mob/M in viewers(src))
		//		M.show_message("\red [user.name] smashed the light!", 3, "You hear a tinkle of breaking glass", 2)
		//	broken()
		//	return

	// make it burn hands if not wearing fire-insulated gloves
	//if(on)
		//var/prot = 0
		//var/mob/living/carbon/human/H = user

		//if(istype(H))
			//if(H.getSpeciesOrSynthTemp(HEAT_LEVEL_1) > LIGHT_BULB_TEMPERATURE)
			//prot = 1
			//if(H.gloves)
				//var/obj/item/clothing/gloves/G = H.gloves
				//if(G.max_heat_protection_temperature)
					//if(G.max_heat_protection_temperature > LIGHT_BULB_TEMPERATURE)
						//prot = 1
		//else
			//prot = 1

		//if(prot > 0) //|| (COLD_RESISTANCE in user.mutations))
			//user << "You remove the light [get_fitting_name()]"
		//else if(TK in user.mutations)
			//user << "You telekinetically remove the light [get_fitting_name()]."
		//else
			//user << "You try to remove the light [get_fitting_name()], but it's too hot and you don't want to burn your hand."
		//	return				// if burned, don't remove the light
	//else
		//user << "You remove the light [get_fitting_name()]."

	// create a light tube/bulb item and put it in the user's hand
	//user.put_in_active_hand(remove_bulb())	//puts it in our active hand

/*
/obj/machinery/light/attack_tk(mob/user)
	if(status == LIGHT_EMPTY)
		user << "There is no [get_fitting_name()] in this light."
		return

	user << "You telekinetically remove the light [get_fitting_name()]."
	remove_bulb()
*/
// ghost attack - make lights flicker like an AI, but even spookier!
/obj/machinery/light/attack_ghost(mob/user)
		src.flicker(rand(2,5))
	//else return ..()

// break the light and make sparks if was on
/obj/machinery/light/proc/broken(var/skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		//if(on)
			//s.start()
	status = LIGHT_BROKEN
	update()

/obj/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK
	on = 1
	update()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/machinery/light/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(75))
				broken()
		if(3.0)
			if (prob(50))
				broken()
	return

//blob effect


// timed process
// use power

// called when area power state changes
/obj/machinery/light/power_change()
	spawn(10)
		seton(powered())

// called when on fire

/obj/machinery/light/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

// explode the light

/obj/machinery/light/proc/explode()
	var/turf/T = get_turf(src.loc)
	spawn(0)
		broken()	// break it first to give a warning
		sleep(2)
		explosion(T, 0, 0, 2, 2)
		sleep(1)
		qdel(src)

obj/machinery/light/proc/burn_out()
	status = LIGHT_BURNED
	update_icon()
	kill_light()

// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = 1
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	//matter = list(DEFAULT_WALL_MATERIAL = 60)
	var/rigged = 0		// true if rigged to explode
	var/broken_chance = 2

	var/brightness_range = 6 //how much light it gives off
	var/brightness_power = 5
	var/brightness_color = null
	var/list/lighting_modes = list()

/obj/item/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	//matter = list("glass" = 100)

	brightness_range = 5 // luminosity when on, also used in power calculation
	brightness_power = 7
	brightness_color = COLOUR_LTEMP_FLURO
	lighting_modes = list(
		"emergency_lighting" = list(l_range = 5, l_power = 1, l_color = "#da0205"),
		)

/obj/item/light/tube/large
	w_class = 2
	name = "large light tube"
	brightness_range = 5
	brightness_power = 9

/obj/item/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	broken_chance = 5
	//matter = list("glass" = 100)

	brightness_range = 5
	brightness_power = 6
	brightness_color = COLOUR_LTEMP_100W_TUNGSTEN
	lighting_modes = list(
		"emergency_lighting" = list(l_range = 4, l_power = 5, l_color = "#da0205"),
		)

/obj/item/light/bulb/red
	color = "#da0205"
	brightness_color = "#da0205"

/obj/item/light/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "fbulb"
	base_state = "fbulb"
	item_state = "egg4"
	//matter = list("glass" = 100)
	brightness_range = 5
	brightness_power = 2

// update the icon state and description of the light
/obj/item/light/update_icon()
	switch(status)
		if(LIGHT_OK)
			icon_state = base_state
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			desc = "A broken [name]."


/obj/item/light/New(atom/newloc, obj/machinery/light/fixture = null)
	..()
	if(fixture)
		status = fixture.status
		rigged = fixture.rigged
		switchcount = fixture.switchcount
		fixture.transfer_fingerprints_to(src)

		//shouldn't be necessary to copy these unless someone varedits stuff, but just in case
		brightness_range = fixture.brightness_range
		brightness_power = fixture.brightness_power
		brightness_color = fixture.brightness_color
		lighting_modes = fixture.lighting_modes.Copy()
	update_icon()

// attack bulb/tube with object
// if a syringe, can inject fuel to make it explode
/obj/item/light/attackby(var/obj/item/I, var/mob/user)
	..()
//	if(istype(I, /obj/item/reagent_containers/syringe))
	//	var/obj/item/reagent_containers/syringe/S = I

	//	user << "You inject the solution into the [src]."
//
	//	if(S.reagents.has_reagent("fuel", 5))

	//		log_admin("LOG: [user.name] ([user.ckey]) injected a light with fuel, rigging it to explode.")
	//		message_admins("LOG: [user.name] ([user.ckey]) injected a light with fuel, rigging it to explode.")

	//		rigged = 1
//
	//	S.reagents.clear_reagents()
	//else
	//	..()
	return

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != I_HURT)
		return

	shatter()

/obj/item/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		src.visible_message("\red [name] shatters.","\red You hear a small glass object shatter.")
		status = LIGHT_BROKEN
		force = 5
		//sharp = 1
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		update_icon()
