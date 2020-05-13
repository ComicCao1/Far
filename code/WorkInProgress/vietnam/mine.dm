/obj/item/weapon/mine/
	name = "\improper mine"
	desc = "LM-S.Designed for explosion astronautics."
	icon = 'icons/obj/items.dmi'
	icon_state = "mine"
	w_class = 3.0
	var/active = 0
	var/power1 = 2
	var/power2 = 2

/obj/item/weapon/mine/New()
	..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-8, 8)

/obj/item/weapon/mine/active/New()
	..()
	active = 1
	update_icon()

/obj/item/weapon/mine/medium/
	desc = "LM-M.	Designed for explosion astronautics."
	power1 = 4
	power2 = 4

/obj/item/weapon/mine/extra/
	desc = "LM-E.	Designed for explosion astronautics."
	power1 = 6
	power2 = 5

/obj/item/weapon/mine/update_icon()
	if(active)
		icon_state = "mine_active"
	else
		icon_state = "mine"

/obj/item/weapon/mine/HasEntered(A as mob|obj, var/obj/item/I)
	if(active)
		if(istype(A, /mob/living/))
			if(isturf(src.loc))
				for(var/mob/O in oviewers(src))
					if ((O.client && !( O.blinded )))
						O << "\red [A] stepped on [src]."
				usr.unlock_medal("I served in Vietnam.", 0, "Stepped on a mine.", "easy")
				expl()
		else if(istype(I, /obj/item/))
			if(I.w_class >= 4)
				expl()



/obj/item/weapon/mine/proc/expl()
	for(var/mob/O in oviewers(src))
		O << "\red *beep*"
		playsound(get_turf(src), 'sound/weapons/c4armed.ogg', 60, 1)

	var/turf/T = get_turf(src.loc)
	spawn(0)
		explosion(T, 0, 0, power1, power2)
		sleep(1)
		qdel(src)


/obj/item/weapon/mine/attack_self()
	if(active)
		active = 0
		anchored = 0
		usr << "You deactivate the [src]."
	else
		usr << "You start to activate the [src]."
		if (do_after(usr, 25))
			active = 1
			anchored = 1
			usr << "You activated the [src]."
	update_icon()

/obj/item/weapon/mine/attack_hand()
	if(active)
		expl()
	else ..()
/*
/obj/item/weapon/mine/throw()
	expl()

/obj/item/weapon/mine/dropped()
	..()
	usr << "You start to planting [src].."
	for(var/mob/O in oviewers(src))
		if ((O.client && !( O.blinded )))
			O << "[usr] start to planting [src]."
	if (do_after(usr, 16))
		usr << "\blue You plant [src]."
		..()
	else return*/


/obj/item/weapon/mine/attackby(obj/item/weapon/W as obj)
	if(istype(W, /obj/item/weapon/gun/projectile/automatic/m300))
		var/obj/item/weapon/gun/projectile/automatic/m300/C = W
		if(C.knife)
			deactivate()
		else
			if(active)
				usr << "Oh, no!"
				expl()
	if(istype(W, /obj/item/weapon/kitchen/utensil/bayonet))
		deactivate()


	else if(active)
		expl()

/obj/item/weapon/mine/proc/deactivate()
	if(active)
		usr << "You start to deactivate [src]."
		if (do_after(usr, 16))
			if(prob(75))
				src.active = 0
				update_icon()
				usr << "\blue Mine has been deactivated."
				for(var/mob/O in oviewers(src))
					if ((O.client && !( O.blinded )))
						O << "\blue [usr] deactivate [src]"
			else	expl()
		else return


/obj/item/weapon/mine/bullet_act(var/obj/item/projectile/Proj)
	for(var/mob/O in oviewers(src))
		if ((O.client && !( O.blinded )))
			O << "\red [Proj] hit [src]."
	qdel(Proj)
	expl()



/// SHYTK-NOZ
/obj/item/weapon/kitchen/utensil/bayonet
	name = "\improper bayonet"
	desc = "Bayonet to search meat."
	icon = 'icons/obj/items.dmi'
	icon_state = "bayonet"
	w_class = 2.0
	force = 18.0

/// grenade
/obj/item/weapon/grenade/syndieminibomb/nanotrasen
	desc = "A nanotrasen manufactured explosive used to sow destruction and chaos"
	name = "nanotrasen minibomb"
	icon = 'icons/obj/items.dmi'
	icon_state = "nanotrasen_grenade"
	item_state = "flashbang"
	origin_tech = "materials=3;magnets=4;syndicate=2"

/obj/item/weapon/grenade/syndieminibomb/nanotrasen/prime()
	explosion(src.loc,0,0,3,3)
	qdel(src)

// space vine
/obj/item/weapon/reagent_containers/food/snacks/monkeycube/spacevine
	name = "vine cube"
	monkey_type ="vine"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/spacevine
	name = "vine cube"
	monkey_type ="vine"


////korobki
/obj/item/weapon/storage/box/spacevine
	name = "spacevine cube box"
	desc = "Compressed spacevines. Special tool of ground troops nanotransen.	. Just add water!"
	icon = 'icons/obj/items.dmi'
	icon_state = "mre"
	New()
		..()
		for(var/i = 1; i <= 7; i++)
			new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/spacevine(src)

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/spacevine/attackby(obj/item/weapon/W as obj)
	if(istype(W, /obj/item/weapon/reagent_containers/food/drinks/bottle/waterbottle))
		Expand()

/obj/item/weapon/storage/box/lunches
	name = "box of support"
	desc = "Will not die on the battlefield. Contains: dry rations, matches, water bottle."
	icon = 'icons/obj/items.dmi'
	icon_state = "mre"
	New()
		..()
		for(var/i = 1; i <= 3; i++)
			new /obj/item/weapon/reagent_containers/food/snacks/human/burger/dry_rations(src)
		new /obj/item/weapon/storage/box/matches(src)
		new /obj/item/weapon/reagent_containers/food/snacks/chocolatebar(src)
		new /obj/item/weapon/reagent_containers/pill/charcoal(src)
		new /obj/item/weapon/storage/fancy/cigarettes(src)

///food
/obj/item/weapon/reagent_containers/food/snacks/human/burger/dry_rations
	name = "dry rations"
	desc = "Contains the essentials for maintaining diet fighter. Better not to know how to do it."
	icon = 'icons/obj/items.dmi'
	icon_state = "beef"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("mindbreaker", 1)
		reagents.add_reagent("vitamin", 2)
		bitesize = 3


///// clout...odejda

/obj/item/clothing/under/syndicate/tacticool/nanotrasen
	name = "combat jumpsuit"
	desc = "Specially designed lightweight suit for NT infantry"
	icon_state = "troopsuit"
//	item_state = "jungle_s"
//	item_color = "troopsuit"
	has_sensor = 3
	armor = list(melee = 20, bullet = 30, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	var/sleeve = 1

/obj/item/clothing/under/syndicate/tacticool/nanotrasen/verb/toggle_sleeve()
	set name = "Toggle sleeve"
	set category = "Object"
	set src in usr

	if(sleeve)
		sleeve = 0
		usr << "You roll up sleeve"
		item_state +="_rolled"
	else
		sleeve = 1
		usr << "You roll down sleeve"
		item_state = initial(item_state)

	if(istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = loc
		H.update_inv_w_uniform()


/obj/item/clothing/head/helmet/tactical/nanotrasen
	name = "combat helmet"
	desc = "Standard-issue combat of terrestrial NT infantry."
	icon = 'icons/obj/items.dmi'
	icon_state = "helmet_j"
	item_state = "helmet_j"

	armor = list(melee = 30, bullet = 30, laser = 20,energy =70, bomb = 10, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/tactical/nanotrasen/med
	name = "medical combat helmet"
	desc = "Combat helmet of support terrestrial infantry nanotrasen."
	icon_state = "helmet_j_m"
	item_state = "helmet_j_m"

	armor = list(melee = 30, bullet = 30, laser = 20,energy = 70, bomb = 10, bio = 30, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/tactical/nanotrasen/tactical
	name = "Drill sergeants hat"
	desc = "For those who do not die first on the battlefield."
	icon_state = "sergeanthead_j"
	item_state = "sergeanthead_j"

	armor = list(melee = 30, bullet = 10, laser = 10,energy = 5, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/glasses/sunglasses/aviator
	desc = "My grandfather flew with them."
	name = "aviator"
	icon = 'icons/obj/items.dmi'
	icon_state = "aviator"
	item_state = "aviator"
	darkness_view = -1



/obj/item/clothing/suit/armor/bulletproof/nanotrasen
	name = "bulletproof Vest"
	desc = "A vest that excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "armor_j"
	item_state = "armor_j"
	blood_overlay_type = "armor"
	armor = list(melee = 20, bullet = 80, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7



/// ochen avtomat

/obj/item/weapon/gun/projectile/automatic/m300
	name = "\improper M14"
	desc = "A lightweight, fast firing gun, for when you REALLY need someone dead. Uses 12mm rounds. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp"
	icon = 'icons/obj/gun.dmi'
	icon_state = "har_laser"
	item_state = "c20r"
	w_class = 3.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/m12mm/nanotrasen
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'

	var/obj/item/weapon/kitchen/utensil/knife = 0
	var/open = 0

/obj/item/weapon/gun/projectile/automatic/m300/bayonet
	knife = /obj/item/weapon/kitchen/utensil/bayonet

/obj/item/weapon/gun/projectile/automatic/m300/update_icon()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"][knife ? "-k" : ""]"

/obj/item/weapon/gun/projectile/automatic/m300/attack_self(mob/user as mob)
	if(!magazine)
		if(knife && open)
			knife.loc = usr
			usr.put_in_hands(knife)
			knife = 0
			src.force = initial(force)
			user << "<span class='notice'>You remove bayonet from \the [src]!</span>"
	..()


/obj/item/weapon/gun/projectile/automatic/m300/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		if(open)
			usr << "You Tighten the screws on [src]."
			open = 0
		else
			usr << "You unscrewed the bolts on [src]."
			open = 1

	if(istype(W, /obj/item/weapon/kitchen/utensil) && open)
		knife = W
		user.drop_item()
		W.loc = src
		src.force = W.force
		user << "<span class='notice'>You add [knife.name] to \the [src]!</span>"
		update_icon()
	..()



/obj/item/weapon/gun/projectile/automatic/m300/afterattack(mob/user as mob)
	..()
	if(knife && open)
		knife.loc = get_turf(src.loc)
		src.knife = null
		usr << "\red Bayonet fell off from [src]"
	if(!chambered && !get_ammo() && !alarmed)
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
	update_icon()
	return

/obj/item/ammo_magazine/external/m12mm/nanotrasen
	name = "magazine (12mm)"
	icon = 'icons/obj/items.dmi'
	icon_state = "har_laser_cartridge"
	caliber = "12mm"
	ammo_type = /obj/item/ammo_casing/a12mm
	max_ammo = 20

/obj/item/ammo_magazine/external/m12mm/nanotrasen/update_icon()
	return

