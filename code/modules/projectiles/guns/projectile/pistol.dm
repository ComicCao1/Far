/obj/item/weapon/gun/projectile/automatic/pistol/toggle_fire()
	set hidden = 1
	return


/obj/item/weapon/gun/projectile/automatic/pistol/mk58
	name = "\improper MK 58"
	desc = "A small handgun used by NT security forces"
	icon_state = "secguncomp"
	w_class = 2.0
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_magazine/external/sm45
	fire_sound = 'sound/weapons/Gunshot2.ogg'

/obj/item/weapon/gun/projectile/automatic/pistol/silenced/usp
	name = "usp silenced"
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds."
	icon_state = "silenced_pistol"
	w_class = 3.0
	caliber = ".45"
	origin_tech = "combat=3;materials=2;syndicate=8"
	fire_sound = 'sound/weapons/Gunshot_silenced.ogg'
	mag_type = /obj/item/ammo_magazine/external/sm45


/obj/item/weapon/gun/projectile/automatic/pistol/usp
	name = "usp"
	desc = "A well known german pistol. Uses .45 rounds."
	icon_state = "usp"
	w_class = 3.0
	caliber = ".45"
	origin_tech = "combat=2;materials=2;syndicate=5"
	fire_sound = 'sound/weapons/gunshot_usp.ogg'
	mag_type = /obj/item/ammo_magazine/external/sm45


/obj/item/weapon/gun/projectile/automatic/deagle
	name = "desert eagle"
	desc = "A robust handgun that uses .50 AE ammo"
	icon_state = "deagle"
	force = 14.0
	mag_type = /obj/item/ammo_magazine/external/m50

/*obj/item/weapon/gun/projectile/automatic/pistol/glock
	name = "glock"
	desc = "A old Glock 17 pistol. Uses 9mm rounds"
	icon_state = "glock"
	force = 14.0
	mag_type = /obj/item/ammo_magazine/external/mc9mm

/obj/item/weapon/gun/projectile/automatic/pistol/glock/New()
	..()
	del(magazine)
	magazine = new /obj/item/ammo_magazine/external/mc9mm/extended(src)*/

/obj/item/weapon/gun/projectile/automatic/pistol/beretta
	name = "beretta" // Thanks to MarcusAga
	desc = "A old Beretta M9. Uses 9mm rounds."
	icon_state = "beretta"
	fire_sound = 'sound/weapons/gunshot_m9.ogg'
	force = 14.0
	mag_type = /obj/item/ammo_magazine/external/mc9mm

/obj/item/weapon/gun/projectile/automatic/pistol/beretta/New()
	..()
	del(magazine)
	magazine = new /obj/item/ammo_magazine/external/mc9mm/extended(src)


/obj/item/weapon/gun/projectile/automatic/deagle/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(!chambered && !get_ammo() && !alarmed)
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
		alarmed = 1
	return

/obj/item/weapon/gun/projectile/automatic/deagle/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"


/obj/item/weapon/gun/projectile/automatic/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/obj/item/weapon/gun/projectile/automatic/deagle/camo
	desc = "A Deagle brand Deagle for operators operating operationally. Uses .50 AE ammo."
	icon_state = "deaglecamo"
	item_state = "deagleg"



/obj/item/weapon/gun/projectile/automatic/gyropistol
	name = "gyrojet pistol"
	desc = "A bulky pistol designed to fire self propelled rounds"
	icon_state = "gyropistol"
	fire_sound = 'sound/effects/Explosion1.ogg'
	origin_tech = "combat=3"
	mag_type = /obj/item/ammo_magazine/external/m75

/obj/item/weapon/gun/projectile/automatic/gyropistol/New()
	..()
	update_icon()
	return


/obj/item/weapon/gun/projectile/automatic/gyropistol/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(!chambered && !get_ammo() && !alarmed)
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
		alarmed = 1
	return

/obj/item/weapon/gun/projectile/automatic/gyropistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "loaded" : ""]"
	return

/obj/item/weapon/gun/projectile/automatic/pistol
	name = "\improper TSP-12 pistol"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol"
	w_class = 2
	silenced = 0
	origin_tech = "combat=3;materials=2"
	mag_type = /obj/item/ammo_magazine/external/mc9mm

/obj/item/weapon/gun/projectile/automatic/pistol/stechtkin
	name = "\improper Stechtkin pistol"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "pistol1"
	w_class = 2
	silenced = 0
	origin_tech = "combat=2;materials=2;syndicate=2"
	mag_type = /obj/item/ammo_magazine/external/mc9mm

/obj/item/weapon/gun/projectile/automatic/pistol/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(magazine)
		if(!chambered && !magazine.ammo_count())
			magazine.update_icon()
			magazine.loc = get_turf(src.loc)
			magazine = null
	return

/obj/item/weapon/gun/projectile/automatic/pistol/attack_hand(mob/user as mob)
	if(loc == user)
		if(silenced)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			user << "<span class='notice'>You unscrew [silenced] from [src].</span>"
			user.put_in_hands(silenced)
			var/obj/item/weapon/silencer/S = silenced
			fire_sound = S.oldsound
			silenced = 0
			w_class = 2
			update_icon()
			return
	..()

/obj/item/weapon/gun/projectile/automatic/pistol/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/silencer))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			user << "<span class='notice'>You'll need [src] in your hands to do that.</span>"
			return
		user.drop_item()
		user << "<span class='notice'>You screw [I] onto [src].</span>"
		silenced = I	//dodgy?
		var/obj/item/weapon/silencer/S = I
		S.oldsound = fire_sound
		fire_sound = 'sound/weapons/Gunshot_silenced.ogg'
		w_class = 3
		I.loc = src		//put the silencer into the gun
		update_icon()
		return
	..()

/obj/item/weapon/gun/projectile/automatic/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][silenced ? "-silencer" : ""][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/pistol/update_icon()
	..()
	icon_state = "[initial(icon_state)][silenced ? "-silencer" : ""][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/pistol/syndie/New()
	..()
	del(magazine)
	magazine = new /obj/item/ammo_magazine/external/mc9mm/extra(src)

/obj/item/weapon/gun/projectile/automatic/deagle/glock
	name = "glock"
	desc = "A glock pistol. Uses 9mm ammo."
	icon_state = "glock"
	force = 10.0
	origin_tech = "combat=4;materials=3"
	mag_type = /obj/item/ammo_magazine/external/mc9mm

///obj/item/weapon/gun/projectile/automatic/deagle/glock/attackby(obj/item/W as obj, mob/user as mob)
//	if(istype(W,/obj/item/weapon/screwdriver))


/obj/item/weapon/assembly/glock
	icon = 'icons/obj/buildingobject.dmi'

/obj/item/weapon/assembly/glock/barrel
	name = "handgun barrel"
	desc = "One third of a low-caliber handgun."
	icon_state = "glock1"
	m_amt = 400000 // expensive, will need an autolathe upgrade to hold enough metal to produce the barrel. this way you need cooperation between 3 departments to finish even 1.

/obj/item/weapon/assembly/glock/construction
	name = "handgun barrel and grip"
	desc = "Two thirds of a low-caliber handgun."
	icon_state = "glockstep1"
	var/construction = 0

/obj/item/weapon/assembly/glock/construction/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/assembly/glock/slide))
		user << "You attach the slide to the gun."
		construction = 1
		del(W)
		icon_state = "glockstep2"
		name = "unfinished handgun"
		desc = "An almost finished handgun."
		return
	if(istype(W,/obj/item/weapon/screwdriver))
		if(construction)
			user << "You finish the handgun."
			new /obj/item/weapon/gun/projectile/automatic/deagle/glock(user.loc)
			del(src)
			return

/obj/item/weapon/assembly/glock/barrel/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/assembly/glock/grip))
		user << "You attach the grip to the barrel."
		new /obj/item/weapon/assembly/glock/construction(user.loc)
		del(W)
		del(src)
		return

/obj/item/weapon/assembly/glock/grip
	name = "handgun grip"
	desc = "One third of a low-caliber handgun."
	icon_state = "glock2"

/obj/item/weapon/assembly/glock/slide
	name = "handgun slide"
	desc = "One third of a low-caliber handgun."
	icon_state = "glock3"


/obj/item/weapon/silencer
	name = "silencer"
	desc = "a silencer"
	icon = 'icons/obj/gun.dmi'
	icon_state = "silencer"
	w_class = 2
	var/oldsound = 0 //Stores the true sound the gun made before it was silenced
