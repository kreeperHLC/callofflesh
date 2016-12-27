/obj/item/weapon/reagent_containers/pill/stalker
	name = "kit"
	desc = "Старая советска&#255; аптечка."
	icon = 'icons/stalker/items.dmi'
	w_class = 2
	possible_transfer_amounts = list()
	volume = 60
	apply_type = PATCH
	apply_method = "apply"

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_r
	name = "first aid kit"
	icon_state = "aptechka_red"
	//item_state = "bandaid"
	list_reagents = list("cryoxadone" = 30)

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_b
	name = "army kit"
	icon_state = "aptechka_blue"
	//item_state = "bandaid"
	list_reagents = list("cryoxadone" = 60)

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_y
	name = "science kit"
	icon_state = "aptechka_yellow"
	//item_state = "bandaid"
	list_reagents = list("adminordrazine" = 1)