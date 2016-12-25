/obj/item/weapon/stalker/bolts
	name = "bolts"
	desc = "���� ������."
	icon = 'icons/stalker/bolt.dmi'
	icon_state = "kucha"
	w_class = 2

/obj/item/weapon/stalker/bolt
	name = "bolt"
	desc = "������ ��������� ����, ���������� ���������,"
	icon = 'icons/stalker/bolt.dmi'
	icon_state = "bolt"
	w_class = 1

/obj/item/weapon/stalker/bolt/New()
	spawn(10000)
		qdel(src)

/obj/item/weapon/stalker/bolts/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(M.restrained() || M.stat || !Adjacent(M))
		return

	if(over_object == M)
		M.put_in_hands(src)

	else if(istype(over_object, /obj/screen))
		switch(over_object.name)
			if("r_hand")
				if(!remove_item_from_storage(M))
					M.unEquip(src)
				M.put_in_r_hand(src)
			if("l_hand")
				if(!remove_item_from_storage(M))
					M.unEquip(src)
				M.put_in_l_hand(src)

	add_fingerprint(M)


/obj/item/weapon/paper_bin/attack_paw(mob/user)
	return attack_hand(user)


/obj/item/weapon/paper_bin/attack_hand(mob/user)
	if(user.lying)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/obj/item/weapon/stalker/bolt/P
	P = new /obj/item/weapon/stalker/bolt
	P.loc = user.loc
	user.put_in_hands(P)
	user << "<span class='notice'>�� �������� ���� �� ����.</span>"
	add_fingerprint(user)