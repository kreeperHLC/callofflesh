/*
Assistant
*/
/datum/job/duty
	title = "Duty"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "Major"
	selection_color = "#601919"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 1
	outfit = /datum/outfit/job/duty

/datum/outfit/job/duty
	name = "Duty"

/datum/outfit/job/duty/pre_equip(mob/living/carbon/human/H)
	head = null
	uniform = pick(/obj/item/clothing/under/color/switer, /obj/item/clothing/under/color/switer/dark)
	suit = /obj/item/clothing/suit/hooded/kozhanka/psz9d
	ears = null
	belt = /obj/item/weapon/stalker/knife
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/weapon/storage/wallet/stalker
	back = /obj/item/weapon/storage/backpack/stalker
	back2 = pick(/obj/item/weapon/gun/projectile/automatic/aksu74, /obj/nothing)
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/stalker/b545 = 1,
							/obj/item/ammo_box/magazine/stalker/m545 = 2,
							/obj/item/device/radio = 1,
							/obj/item/device/flashlight/seclite = 1)
	r_pocket = /obj/item/weapon/stalker/bolts
	l_pocket = pick(/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,/obj/item/weapon/reagent_containers/food/snacks/stalker/baton)

/datum/outfit/duty  // For select_equipment
	name = "Duty Soldier"

	head = null
	suit = /obj/item/clothing/suit/hooded/kozhanka/psz9d
	ears = null
	belt = /obj/item/weapon/stalker/knife
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/weapon/storage/wallet/stalker
	back = /obj/item/weapon/storage/backpack/stalker
	shoes = /obj/item/clothing/shoes/jackboots/warm
	backpack_contents = list(/obj/item/ammo_box/stalker/b545 = 1,
							/obj/item/ammo_box/magazine/stalker/m545 = 2,)
	r_pocket = /obj/item/weapon/stalker/bolts

/datum/outfit/duty/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = pick(/obj/item/clothing/under/color/switer, /obj/item/clothing/under/color/switer/dark)
	suit = /obj/item/clothing/suit/hooded/kozhanka/psz9d
	back2 = pick(/obj/item/weapon/gun/projectile/automatic/aksu74, /obj/nothing)
	ears = null
	l_pocket = pick(/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa,/obj/item/weapon/reagent_containers/food/snacks/stalker/baton)
	r_pocket =/obj/item/weapon/stalker/bolts

/datum/job/barman2
	title = "Barman2"
//	flag = ASSISTANT
//	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = ""
	selection_color = "#601919"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	whitelist_only = 1
	outfit = /datum/outfit/job/barman2

/datum/outfit/job/barman2
	name = "Barman"

/datum/outfit/job/barman2/pre_equip(mob/living/carbon/human/H)
	head = null
	uniform = /obj/item/clothing/under/color/switer/dark
	suit = /obj/item/clothing/suit/jacket/sidor
	ears = null
	belt = /obj/item/weapon/gun/projectile/automatic/pistol/cora
	id = /obj/item/weapon/storage/wallet/stalker
	shoes = /obj/item/clothing/shoes/sneakers/black
	back = null
