/*
/obj/item/weapon/reagent_containers/pill/stalker/aptechka_r
	icon = 'icons/stalker/items.dmi'
	icon_state = "aptechkar"
	desc = "������������� ����������� �����. ������&#255;�� ������&#255;���&#255; � �������� ���������� ���� � ������� ��������� - ������&#255;��, �������, ���������&#255;�� � ������."

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_r/New()
	..()
	if(empty) return
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/gauze(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	return

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_b
	icon = 'icons/stalker/items.dmi'
	icon_state = "aptechkab"
	desc = "������������������ ����������� ����� ��&#255; ������ � ����������� ����������&#255;�� � �������������. � ���� ����&#255;� ���������� ��&#255; ��������&#255; ����������&#255; �����, ��������������, ����������� � �������� ������&#255;����."

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_b/New()
	..()
	if(empty) return
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/bruise_pack/bint(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/stack/medical/gauze(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen(src)
	return

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_y
	icon = 'icons/stalker/items.dmi'
	icon_state = "aptechkay"
	desc = "����������� �����, ������������� ���������� ��&#255; ������ � ������&#255;� ����. ������ ������ �������� ��� ��&#255; ������ � ������&#255;��, ��� � ��&#255; ������ ������������� �� ���������. ����&#255;������� �������� ������� �������, � ����� ������� ���� ����������� ��������."

/obj/item/weapon/reagent_containers/pill/stalker/aptechka_y/New()
	..()
	if(empty) return
	new /obj/item/weapon/reagent_containers/pill/patch/styptic(src)
	new /obj/item/weapon/reagent_containers/pill/patch/styptic(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/pill/patch/silver_sulf(src)
	new /obj/item/weapon/reagent_containers/syringe/charcoal(src)
	new /obj/item/weapon/reagent_containers/hypospray/medipen/stalker/antirad(src)
	return
*/
/obj/item/stack/medical/bruise_pack/bint
	name = "bruise pack"
	singular_name
	desc = "�����&#255;������ ��������. �������� ���������� ������������."
	icon = 'icons/stalker/items.dmi'
	icon_state = "bint"

