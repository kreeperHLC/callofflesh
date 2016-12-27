/obj/item/weapon/storage/firstaid/stalker
	icon = 'icons/stalker/items.dmi'
	icon_state = "aptechkar"
	desc = "������������� ����������� �����. ������&#255;�� ������&#255;���&#255; � �������� ���������� ���� � ������� ��������� - ������&#255;��, �������, ���������&#255;�� � ������."

/obj/item/weapon/storage/firstaid/stalker/New()
	..()
	if(empty) return
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/gauze(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	return

/obj/item/weapon/storage/firstaid/army
	icon = 'icons/stalker/items.dmi'
	icon_state = "aptechkab"
	desc = "������������������ ����������� ����� ��&#255; ������ � ����������� ����������&#255;�� � �������������. � ���� ����&#255;� ���������� ��&#255; ��������&#255; ����������&#255; �����, ��������������, ����������� � �������� ������&#255;����."

/obj/item/weapon/storage/firstaid/army/New()
	..()
	if(empty) return
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/gauze(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	return

/obj/item/weapon/storage/firstaid/science
	icon = 'icons/stalker/items.dmi'
	icon_state = "aptechkay"
	desc = "����������� �����, ������������� ���������� ��&#255; ������ � ������&#255;� ����. ������ ������ �������� ��� ��&#255; ������ � ������&#255;��, ��� � ��&#255; ������ ������������� �� ���������. ����&#255;������� �������� ������� �������, � ����� ������� ���� ����������� ��������."

/obj/item/weapon/storage/firstaid/science/New()
	..()
	if(empty) return
	new /obj/item/weapon/reagent_containers/pill/patch/styptic(src)
	new /obj/item/weapon/reagent_containers/pill/patch/styptic(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/syringe/charcoal(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen/stalker/antirad(src)
	return

/obj/item/stack/medical/bruise_pack/bint
	name = "bruise pack"
	singular_name
	desc = "�����&#255;������ ��������. �������� ���������� ������������."
	icon = 'icons/stalker/items.dmi'
	icon_state = "bint"