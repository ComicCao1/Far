/obj/item/clothing
	name = "clothing"
	var/list/species_restricted = null //Only these species can wear this kit.
	var/fatness_restricted = 0
	var/poop_covering = 0

//BS12: Species-restricted clothing check.
/obj/item/clothing/mob_can_equip(M as mob, slot)

	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(fatness_restricted)
			if(FAT in H.mutations)
				M << "\red Your fat ass won't fit into [src]!"
				return 0
		else if(istype(src, /obj/item/clothing/suit) && !fatness_restricted)
			if(!(FAT in H.mutations))
				M << "\red It is too big for you!"
				return 0

		if(species_restricted)

			var/wearable = null
			var/exclusive = null

			if("exclude" in species_restricted)
				exclusive = 1

			if(H.species)
				if(istype(H.species, /datum/species/xenos))		//A little dirty, but...
					M << "\red How do you imagine wearing [src]?"
					return 0
				if(exclusive)
					if(!(H.species.name in species_restricted))
						wearable = 1
				else
					if(H.species.name in species_restricted)
						wearable = 1

				if(!wearable && (slot != 15 && slot != 16)) //Pockets.
					M << "\red Your species cannot wear [src]."
					return 0

	return ..()

//Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = 1.0
	throwforce = 2
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/attack_hand(mob/user as mob)
	if (!user) return

	if (src.loc != user || !istype(user,/mob/living/carbon/human))
		..()
		return

	var/mob/living/carbon/human/H = user
	if(H.l_ear != src && H.r_ear != src)
		..()
		return

	if(!canremove)
		return

	var/obj/item/clothing/ears/O
	if(slot_flags & SLOT_TWOEARS )
		O = (H.l_ear == src ? H.r_ear : H.l_ear)
		user.u_equip(O)
		if(!istype(src,/obj/item/clothing/ears/offear))
			del(O)
			O = src
	else
		O = src

	user.u_equip(src)

	if (O)
		user.put_in_hands(O)
		O.add_fingerprint(user)

	if(istype(src,/obj/item/clothing/ears/offear))
		del(src)

/obj/item/clothing/ears/offear
	name = "Other ear"
	w_class = 5.0
	icon = 'icons/mob/screen1_Midnight.dmi'
	icon_state = "block"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

	New(var/obj/O)
		name = O.name
		desc = O.desc
		icon = O.icon
		icon_state = O.icon_state
		dir = O.dir

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

//Glasses
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = 2.0
	flags = GLASSESCOVERSEYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/invisa_view = 0

/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/


//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = 2.0
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.50
	var/wired = 0
	var/obj/item/weapon/cell/cell = 0
	var/clipped = 0
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	species_restricted = list("exclude","Unathi","Tajaran")

/obj/item/clothing/gloves/examine()
	set src in usr
	..()
	return

/obj/item/clothing/gloves/emp_act(severity)
	if(cell)
		cell.charge -= 1000 / severity
		if (cell.charge < 0)
			cell.charge = 0
		if(cell.reliability != 100 && prob(50/severity))
			cell.reliability -= 10 / severity
	..()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()

//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD


//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK

/obj/item/clothing/mask/proc/d_filter_air(datum/gas_mixture/air)
	return

//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	var/chained = 0
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET
	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	species_restricted = list("exclude","Unathi","Tajaran")

//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	fatness_restricted = 1
	flags = FPRINT | TABLEPASS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	siemens_coefficient = 0.9

//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.90
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/has_sensor = 1//For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/obj/item/clothing/tie/hastie = null
	var/displays_id = 1

/obj/item/clothing/under/attackby(obj/item/I, mob/user)
	if(!hastie && istype(I, /obj/item/clothing/tie))
		user.drop_item()
		hastie = I
		I.loc = src
		user << "<span class='notice'>You attach [I] to [src].</span>"

		if (istype(hastie,/obj/item/clothing/tie/holster))
			verbs += /obj/item/clothing/under/proc/holster

		if (istype(hastie,/obj/item/clothing/tie/storage))
			verbs += /obj/item/clothing/under/proc/storage

		if(istype(loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()

		return

	..()

/obj/item/clothing/under/proc/attachTie(obj/item/I, mob/user)
	if(istype(I, /obj/item/clothing/tie))
		if(hastie)
			if(user)
				user << "<span class='warning'>[src] already has an accessory.</span>"
			return
		else
			if(user)
				user.drop_item()
			hastie = I
			I.loc = src
			if(user)
				user << "<span class='notice'>You attach [I] to [src].</span>"
			I.transform *= 0.5	//halve the size so it doesn't overpower the under
			I.pixel_x += 8
			I.pixel_y -= 8
			I.layer = FLOAT_LAYER
			overlays += I


			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				H.update_inv_w_uniform(0)

			return

/obj/item/clothing/under/examine()
	set src in view()
	..()
	switch(src.sensor_mode)
		if(0)
			usr << "Its sensors appear to be disabled."
		if(1)
			usr << "Its binary life sensors appear to be enabled."
		if(2)
			usr << "Its vital tracker appears to be enabled."
		if(3)
			usr << "Its vital tracker and tracking beacon appear to be enabled."
	if(hastie)
		usr << "\A [hastie] is clipped to it."

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	var/mob/M = usr
	if (istype(M, /mob/dead/)) return
	if (usr.stat) return
	if(src.has_sensor >= 2)
		usr << "The controls are locked."
		return 0
	if(src.has_sensor <= 0)
		usr << "This suit does not have any sensors."
		return 0
	src.sensor_mode += 1
	if(src.sensor_mode > 3)
		src.sensor_mode = 0
	switch(src.sensor_mode)
		if(0)
			usr << "You disable your suit's remote sensing equipment."
		if(1)
			usr << "Your suit will now report whether you are live or dead."
		if(2)
			usr << "Your suit will now report your vital lifesigns."
		if(3)
			usr << "Your suit will now report your vital lifesigns as well as your coordinate position."
	..()

/obj/item/clothing/under/verb/removetie()
	set name = "Remove Accessory"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(hastie)
		if (istype(hastie,/obj/item/clothing/tie/holster))
			verbs -= /obj/item/clothing/under/proc/holster

		if (istype(hastie,/obj/item/clothing/tie/storage))
			verbs -= /obj/item/clothing/under/proc/storage
			var/obj/item/clothing/tie/storage/W = hastie
			if (W.hold)
				W.hold.close(usr)

		usr.put_in_hands(hastie)
		hastie = null

		if(istype(loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()

/obj/item/clothing/under/rank/New()
	sensor_mode = pick(0,1,2,3)
	..()

/obj/item/clothing/under/proc/holster()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if (!hastie || !istype(hastie,/obj/item/clothing/tie/holster))
		usr << "\red You need a holster for that!"
		return
	var/obj/item/clothing/tie/holster/H = hastie

	if(!H.holstered)
		if(!istype(usr.get_active_hand(), /obj/item/weapon/gun))
			usr << "\blue You need your gun equiped to holster it."
			return
		var/obj/item/weapon/gun/W = usr.get_active_hand()
		if (!W.isHandgun())
			usr << "\red This gun won't fit in \the [H]!"
			return
		H.holstered = usr.get_active_hand()
		usr.drop_item()
		H.holstered.loc = src
		usr.visible_message("\blue \The [usr] holsters \the [H.holstered].", "You holster \the [H.holstered].")
	else
		if(istype(usr.get_active_hand(),/obj) && istype(usr.get_inactive_hand(),/obj))
			usr << "\red You need an empty hand to draw the gun!"
		else
			if(usr.a_intent == "hurt")
				usr.visible_message("\red \The [usr] draws \the [H.holstered], ready to shoot!", \
				"\red You draw \the [H.holstered], ready to shoot!")
			else
				usr.visible_message("\blue \The [usr] draws \the [H.holstered], pointing it at the ground.", \
				"\blue You draw \the [H.holstered], pointing it at the ground.")
			usr.put_in_hands(H.holstered)
			H.holstered = null

/obj/item/clothing/under/proc/storage()
	set name = "Look in storage"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if (!hastie || !istype(hastie,/obj/item/clothing/tie/storage))
		usr << "\red You need something to store items in for that!"
		return
	var/obj/item/clothing/tie/storage/W = hastie

	if (!istype(W.hold))
		return

	W.hold.loc = usr
	W.hold.attack_hand(usr)

/obj/item/proc/negates_gravity()
	return 0
