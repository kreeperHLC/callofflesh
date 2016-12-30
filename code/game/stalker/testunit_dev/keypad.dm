/obj/machinery/button/door/keypad
	name = "door keypad"
	desc = "A door remote control keypad."
	icon = 'icons/stalker/buttons.dmi'
	icon_state = "doorctrl"
	normaldoorcontrol = 0
	specialfunctions = OPEN // Bitflag, see assembly file
	var/keypadhtml = ""
	var/correctcode = "909"
	var/keycode = "908"

/obj/machinery/button/door/keypad/New(loc, ndir = 0, built = 0)
	..()

/obj/machinery/button/door/keypad/attack_hand(mob/user)
	if(!initialized)
		setup_device()
	src.add_fingerprint(user)

	if((stat & (NOPOWER|BROKEN)))
		return

	if(device && device.cooldown)
		return

	if(!allowed(user))
		user << "<span class='danger'>Access Denied</span>"
		flick("[skin]-denied", src)
		return

	icon_state = "[skin]1"

	keypadhtml = "\
	<html>\
	\
	<body>\
	  <form>\
	   <p><a href='byond://?src=\ref[src];choice=1'>1</a>	\
	   <a href='byond://?src=\ref[src];choice=2'>2</a>	\
	   <a href='byond://?src=\ref[src];choice=3'>3</a></p>	\
	   <p><a href='byond://?src=\ref[src];choice=4'>4</a>	\
	   <a href='byond://?src=\ref[src];choice=5'>5</a>	\
	   <a href='byond://?src=\ref[src];choice=6'>6</a></p>	\
	   <p><a href='byond://?src=\ref[src];choice=7'>7</a>	\
	   <a href='byond://?src=\ref[src];choice=8'>8</<a href>	\
	   <a href='byond://?src=\ref[src];choice=9'>9</a></p>	\
	   <p><a href='byond://?src=\ref[src];choice=C'>C</a>	\
	   <a href='byond://?src=\ref[src];choice=0'>0</a>	\
	   <a href='byond://?src=\ref[src];choice=R'>R</a></p>	\
	  </form>\
	</body>\
	\
	</html>"

	user << browse(keypadhtml, "window=keypadhtml;size=118x200;border=1;can_resize=1;can_close=1;can_minimize=1;titlebar=1")

/obj/machinery/button/door/keypad/Topic(href, href_list)
	var/mob/living/U = usr

	switch(href_list["choice"])
		if("1")
			keycode = "[keycode]" + "1"
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

		if("2")
			keycode = "[keycode]" + "2"
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

		if("3")
			keycode = "[keycode]" + "3"
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

		if("4")
			keycode = "[keycode]" + "4"
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

		if("5")
			keycode = "[keycode]" + "5"
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

		if("6")
			keycode = "[keycode]" + "6"
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

		if("7")
			keycode = "[keycode]" + "7"
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

		if("8")
			keycode = "[keycode]" + "8"
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

		if("9")
			keycode = "[keycode]" + "9"
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

		if("C")
			U << "Nothing happens."

		if("0")
			keycode = "[keycode]" + "0"
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

		if("R")
			keycode = ""
			U << browse(keypadhtml, "window=keypadhtml")
			U << "Current code: [keycode]"

	if(keycode == correctcode)
		if(device)
			device.pulsed()
	return
