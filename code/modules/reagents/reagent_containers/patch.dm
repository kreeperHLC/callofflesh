/obj/item/weapon/reagent_containers/pill/patch
	name = "chemical patch"
	desc = "A chemical patch for touch based applications."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bandaid"
	item_state = "bandaid"
	possible_transfer_amounts = list()
	volume = 50
	apply_type = PATCH
	apply_method = "apply"

/obj/item/weapon/reagent_containers/pill/patch/New()
	..()
	icon_state = "bandaid" // thanks inheritance

/obj/item/weapon/reagent_containers/pill/patch/afterattack(obj/target, mob/user , proximity)
	return // thanks inheritance again

/obj/item/weapon/reagent_containers/pill/patch/canconsume(mob/eater, mob/user)
	if(!iscarbon(eater))
		return 0
	return 1 // Masks were stopping people from "eating" patches. Thanks, inheritance.

/obj/item/weapon/reagent_containers/pill/patch/styptic
	name = "brute patch"
	desc = "Helps with brute injuries."
	list_reagents = list("styptic_powder" = 50)

/obj/item/weapon/reagent_containers/pill/patch/silver_sulf
	name = "burn patch"
	desc = "Helps with burn injuries."
	list_reagents = list("silver_sulfadiazine" = 50)

/obj/item/weapon/reagent_containers/pill/patch/stalker
	name = "kit"
	desc = "Старая советска&#255; аптечка."
	icon = 'icons/stalker/items.dmi'
	w_class = 2

/obj/item/weapon/reagent_containers/pill/patch/stalker/aptechka_r
	name = "first aid kit"
	icon_state = "apteka_red"
	list_reagents = list("cryoxadone" = 30)

/obj/item/weapon/reagent_containers/pill/patch/stalker/aptechka_b
	name = "army kit"
	icon_state = "apteka_blue"
	list_reagents = list("cryoxadone" = 60)

/obj/item/weapon/reagent_containers/pill/patch/stalker/aptechka_y
	name = "science kit"
	icon_state = "apteka_yellow"
	list_reagents = list("adminordrazine" = 1)