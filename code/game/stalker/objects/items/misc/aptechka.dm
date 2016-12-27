/obj/item/weapon/reagent_containers/pill/stalker
	name = "kit"
	desc = "�����&#255; ��������&#255; �������."
	icon = 'icons/stalker/items.dmi'
	w_class = 2
	possible_transfer_amounts = list()
	volume = 60
	apply_type = PATCH
	apply_method = "apply"

obj/item/weapon/reagent_containers/pill/stalker/afterattack(obj/target, mob/user , proximity)
	return // thanks inheritance again

obj/item/weapon/reagent_containers/pill/stalker/canconsume(mob/eater, mob/user)
	if(!iscarbon(eater))
		return 0
	return 1 // Masks were stopping people from "eating" patches. Thanks, inheritance.

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_r
	name = "first aid kit"
	icon_state = "aptechkar"
	//item_state = "bandaid"
	list_reagents = list("cryoxadone" = 30)

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_b
	name = "army kit"
	icon_state = "aptechkab"
	//item_state = "bandaid"
	list_reagents = list("cryoxadone" = 60)

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_y
	name = "science kit"
	icon_state = "aptechkau"
	//item_state = "bandaid"
	list_reagents = list("adminordrazine" = 1)