/obj/item/device/stalker_pda
	name = "My lovely PDA"
	desc = "A portable device, used to communicate with other stalkers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	w_class = 1
	var/show_title = 0
	var/mainhtml = ""
	slot_flags = SLOT_ID | SLOT_BELT

/obj/item/device/stalker_pda/New()
	..()
	return

/obj/item/device/stalker_pda/attack_self(mob/user)
	user.set_machine(src)

	mainhtml = "<html> \
	\
	<style>\
	a:link {color: #607D8B;}\
	a:visited {color: #607D8B;}\
	a:active {color: #607D8B;}\
	a:hover {background-color: #9E9E9E;}\
	a {text-decoration: none;}\
	body {\
	background: #000000;\
	}\
	table {\
	    background: #131416;\
	    padding: 15px;\
	    margin-bottom: 10px;\
	    color: #afb2a1;\
	}\
	\
	#table-bottom1 {\
		background: #2e2e38;\
		padding-top: 5px;\
		padding-bottom: 5px;\
	}\
	</style>\
	\
	\
	<body>\
	\
	<table border=0 height=\"250\" width=\"600\">\
	<tr>\
	<td align=\"left\" width=200>\
	<div style=\"overflow: hidden; height: 200px; width: 180px;\" ><img height=200 width=200 src=\"http://www.clubstalker.ru/images/resize/photo/640x480/de573c3358fd4160fe545f04b864fd69.jpg\"></div>\
	</td>\
	<td valign=\"top\" align=\"left\">\
	 <div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div><br>\
	 <b>Им&#x44F;:</b> [user.name]<br><br>\
	 <b>Ранг:</b> Эксперт<br><br>\
	 <b>Группировка:</b> Сталкер<br><br>\
	 <b>Репутаци&#x44F;:</b> <font color=\"green\">Добродушный</font>\
	</td>\
	</tr>\
	\
	<tr>\
	<td colspan=\"2\" align=\"center\" id=\"table-bottom1\" height=60>\
			| <a href=\"\">Сообщени&#x44F;</a> | <a href=\"\">Фонарь</a>(<font color=\"#ff5722\">Off</font>) | <a href=\"\">Заметки</a> | <a href=\"\">Рейтинг</a> | <a href=\"\">Лента</a> | <a href=\"\">Карта</a> |<br>\
	<div align=\"center\"><a href='byond://?src=\ref[src];choice=close'>\[ Выйти \]</a></div>\
	</td>\
	</tr>\
	\
	</table>\
	\
	</body>\
	\
	</html>"
	user << browse(mainhtml, "window=mainhtml;size=625x305;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=0")


/obj/item/device/stalker_pda/Topic(href, href_list)
	..()

	var/mob/living/U = usr

	switch(href_list["choice"])
		if("title")
			if(show_title)
				U << browse(mainhtml, "window=mainhtml;size=625x305;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=0")
				show_title = 0
			else
				U << browse(mainhtml, "window=mainhtml;size=625x305;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=1")
				show_title = 1
		if("close")
			U << browse(null, "window=mainhtml")
	return

