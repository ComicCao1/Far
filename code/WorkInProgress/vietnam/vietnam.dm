/obj/item/weapon/gun/projectile/automatic/vietnam
	name = "AKM"
	desc = "A replica of Russian military rifle from 20 century"
	icon = 'icons/obj/gun.dmi'
	icon_state = "AKM"
	item_state = "c20r"
	w_class = 3.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/mag545
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'

/obj/item/ammo_magazine/external/mag762
	name = "7.62 magazine (M14)"
	icon = 'code/WorkInProgress/vietnam/ammo.dmi'
	icon_state = "m14mag"
	ammo_type = /obj/item/ammo_casing/ammo762
	caliber = "7.62"
	max_ammo = 20

/obj/item/ammo_casing/ammo762
	desc = "A 7.62 bullet casing."
	caliber = "7.62"
	projectile_type = /obj/item/projectile/bullet

/obj/item/weapon/gun/projectile/automatic/vietnam/m3a1
	name = "M3A1"
	desc = "M3A1 Grease Gun, nanotrasen ground infantry medics standard weapon"
	icon = 'code/WorkInProgress/vietnam/gun.dmi'
	icon_state = "greasegun"
	item_state = "c20r"
	w_class = 3.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/m3a145
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'

/obj/item/ammo_magazine/external/m3a145
	name = "magazine (.45)"
	icon = 'icons/obj/ammo.dmi'
	icon_state = ".45greasegun"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 30

/obj/item/weapon/gun/projectile/automatic/vietnam/mp40
	name = "MP40"
	desc = "MP40, a replica of the Nazi army standard weapon"
	icon = 'code/WorkInProgress/vietnam/gun.dmi'
	icon_state = "mp40"
	item_state = "c20r"
	w_class = 3.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/mp40919
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'

/obj/item/ammo_magazine/external/mp40919
	name = "magazine (9x19)"
	icon = 'code/WorkInProgress/vietnam/ammo.dmi'
	icon_state = "mp40mag"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 32

/obj/item/weapon/gun/projectile/automatic/vietnam/m60
	name = "M60"
	desc = "M60E1, a Nanotrasen ground forces LMG"
	icon = 'code/WorkInProgress/vietnam/gun.dmi'
	icon_state = "m60"
	item_state = "c20r"
	w_class = 3.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/m60e1
	fire_sound = 'sound/weapons/Gunshot.ogg'


/obj/item/ammo_magazine/external/m60e1
	name = "magazine (7.62)"
	icon = 'code/WorkInProgress/vietnam/ammo.dmi'
	icon_state = "m60mag"
	ammo_type = /obj/item/ammo_casing/ammo762
	caliber = "7.62"
	max_ammo = 75

/obj/item/weapon/gun/projectile/automatic/pistol/m1911
	name = "M1911"
	desc = "M911, a Nanotrasen ground forces pistol"
	icon = 'code/WorkInProgress/vietnam/gun.dmi'
	icon_state = "colt"
	item_state = "gun"
	w_class = 2.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/sm45
	fire_sound = 'sound/weapons/Gunshot_m9.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/vietnam/m14
	name = "M14"
	desc = "Nanotrasen ground infantry standard weapon"
	icon = 'code/WorkInProgress/vietnam/gun.dmi'
	icon_state = "m14"
	item_state = "c20r"
	w_class = 3.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/mag762
	fire_sound = 'sound/weapons/Gunshot.ogg'
	var
		open = 0
		obj/item/weapon/kitchen/utensil/knife = 0

/obj/item/weapon/gun/projectile/automatic/pistol/vietnam/m14/update_icon()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"][knife ? "-k" : ""]"

/obj/item/weapon/gun/projectile/automatic/pistol/vietnam/m14/attackby(obj/item/weapon/W as obj, mob/user as mob)
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
		user << "<span class='notice'>You add [knife] to \the [src]!</span>"
	update_icon()
	..()

/obj/item/weapon/gun/projectile/automatic/pistol/vietnam/m14/afterattack(mob/user as mob)
	..()
	if(knife && open)
		knife.loc = get_turf(src.loc)
		src.knife = null
		usr << "\red Bayonet fell off from [src]"
	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/pistol/vietnam/afterattack(mob/user as mob)
	..()
	update_icon()
	return

/obj/item/weapon/gun/projectile/automatic/pistol/vietnam/update_icon()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/vietnam/update_icon()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/shotgun/mosin
	name = "sawn-off Mosin"
	desc = "A sawn-off replica of WW2 Soviet infantry weapon"
	icon = 'code/WorkInProgress/vietnam/gun.dmi'
	icon_state = "mosin_sawnoff"
	item_state = "gun"
	w_class = 3.0
	origin_tech = "combat=2;materials=2;syndicate=5"
	fire_sound = 'sound/weapons/Gunshot.ogg'
	mag_type = /obj/item/ammo_magazine/external/mag545mosin
	var/AM = 0


/obj/item/ammo_magazine/external/mag545mosin
	name = "bullet clip (Mosin rifle)"
	icon = 'code/WorkInProgress/vietnam/ammo.dmi'
	icon_state = "mosinclip"
	ammo_type = /obj/item/ammo_casing/mag545
	caliber = "5.45"
	max_ammo = 5


/obj/item/weapon/gun/projectile/shotgun/mosin/pump(mob/M as mob)
	playsound(M, 'sound/weapons/bolt_action.ogg', 60, 1)
	if(magazine)
		AM++
		if(AM>5)
			AM = 0
			if(magazine)
				magazine.loc = get_turf(src)
				magazine = null
				if(in_chamber)
					in_chamber = null

	if(chambered)
		chambered.loc = get_turf(src)
		chambered = null
		if(in_chamber)
			in_chamber = null
	pumped = 0

	if(magazine)
		if(!magazine.ammo_count())	return 0
		var/obj/item/ammo_casing/AC = magazine.get_round()
		chambered = AC
	update_icon()

/obj/item/weapon/gun/projectile/shotgun/mosin/attackby(var/obj/item/A as obj, mob/user as mob)
	if(!magazine)
		if(istype(A, /obj/item/ammo_magazine/external/mag545mosin))
			user.drop_item()
			A.loc = src
			magazine = A
	if(!chambered)
		if(istype(A, /obj/item/ammo_casing/mag545))
			user.drop_item()
			A.loc = src
			chambered = A
	..()

/obj/item/weapon/gun/projectile/automatic/vietnam/m16
	name = "M16"
	desc = "SET DESC"
	icon = 'code/WorkInProgress/vietnam/gun.dmi'
	icon_state = "m16"
	item_state = "c20r"
	w_class = 3.0
	origin_tech = "combat=5;materials=3"
	mag_type = /obj/item/ammo_magazine/external/m16
	fire_sound = 'sound/weapons/Gunshot.ogg'

/obj/item/ammo_magazine/external/m16
	name = "magazine (7.62)"
	icon = 'code/WorkInProgress/vietnam/ammo.dmi'
	icon_state = "m60mag"
	ammo_type = /obj/item/ammo_casing/ammo762
	caliber = "7.62"
	max_ammo = 30