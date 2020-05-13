/obj/structure/stool/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair"

/obj/structure/stool/MouseDrop(atom/over_object)
	return

/obj/structure/stool/bed/chair/New()
	if(anchored)
		src.verbs -= /atom/movable/verb/pull
	..()
	spawn(3)	//sorry. i don't think there's a better way to do this.
		handle_rotation()
	return

/obj/structure/stool/bed/chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			user << "<span class='notice'>[SK] is not ready to be attached!</span>"
			return
		user.drop_item()
		var/obj/structure/stool/bed/chair/e_chair/E = new /obj/structure/stool/bed/chair/e_chair(src.loc)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.dir = dir
		E.part = SK
		SK.loc = E
		SK.master = E
		del(src)

/obj/structure/stool/bed/chair/attack_tk(mob/user as mob)
	if(buckled_mob)
		..()
	else
		rotate()
	return

/obj/structure/stool/bed/chair/proc/handle_rotation()	//making this into a seperate proc so office chairs can call it on Move()
	if(src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER
	if(buckled_mob)
		buckled_mob.dir = dir

/obj/structure/stool/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(config.ghost_interaction)
		src.dir = turn(src.dir, 90)
		handle_rotation()
		return
	else
		if(istype(usr,/mob/living/simple_animal/mouse))
			return
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return

		src.dir = turn(src.dir, 90)
		handle_rotation()
		return

/obj/structure/stool/bed/chair/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(!istype(M)) return
	buckle_mob(M, user)
	return

// Chair types
/obj/structure/stool/bed/chair/wood/normal
	icon_state = "wooden_chair"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/wood(src.loc)
		del(src)
	else
		..()

/obj/structure/stool/bed/chair/goon
	icon_state = "g-chair"

/obj/structure/stool/bed/chair/comfy
	name = "comfy chair"
	desc = "It looks comfy."

/obj/structure/stool/bed/chair/comfy/brown
	icon_state = "comfychair_brown"

/obj/structure/stool/bed/chair/comfy/beige
	icon_state = "comfychair_beige"

/obj/structure/stool/bed/chair/comfy/teal
	icon_state = "comfychair_teal"

/obj/structure/stool/bed/chair/office
	anchored = 0

/obj/structure/stool/bed/chair/comfy/black
	icon_state = "comfychair_black"

/obj/structure/stool/bed/chair/comfy/lime
	icon_state = "comfychair_lime"

/obj/structure/stool/bed/chair/office/Move()
	..()
	if(buckled_mob)
		buckled_mob.buckled = null //Temporary, so Move() succeeds.
		var/moved = buckled_mob.Move(src.loc)
		buckled_mob.buckled = src
		if(!moved)
			unbuckle()
	handle_rotation()

/obj/structure/stool/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/stool/bed/chair/office/dark
	icon_state = "officechair_dark"

/obj/structure/stool/bed/chair/shuttle
	name = "Shuttle chair"
	desc = "A strong chair welded to the floor."
	icon_state = "schair"
	anchored = 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weapon/wrench))
			if (src.anchored)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				user << "\blue You begin to unfasten \the [src] from the floor..."
				if (do_after(user, 20))
					user.visible_message( \
						"[user] unfastens \the [src].", \
						"\blue You have unfastened \the [src].", \
						"You hear ratchet.")
					src.anchored = 0
			else
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				user << "\blue You begin to fasten \the [src] to the floor..."
				if (do_after(user, 20))
					user.visible_message( \
						"[user] fastens \the [src].", \
						"\blue You have fastened \the [src].", \
						"You hear ratchet.")
					src.anchored = 1
		else
			..()
			return

//Church pews
/obj/structure/stool/bed/chair/wood/pew
	name = "pew"
	desc = "A bench for sleeping at masses."
	icon_state = "pews"

/obj/structure/stool/bed/chair/comfy/brown
	icon_state = "comfychair_brown"

/obj/structure/stool/bed/chair/comfy/beige
	icon_state = "comfychair_beige"

/obj/structure/stool/bed/chair/comfy/teal
	icon_state = "comfychair_teal"

/obj/structure/stool/bed/chair/office
	anchored = 0

/obj/structure/stool/bed/chair/comfy/black
	icon_state = "comfychair_black"

/obj/structure/stool/bed/chair/comfy/lime
	icon_state = "comfychair_lime"

/obj/structure/stool/bed/chair/office/Move()
	..()
	handle_rotation()

/obj/structure/stool/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/stool/bed/chair/office/dark
	icon_state = "officechair_dark"

//COUCHES:
/obj/structure/stool/bed/chair/comfy/couch
	name = "couch"
//BLACK///////////////////////////////////////////////
/obj/structure/stool/bed/chair/comfy/couch/black/right
	icon_state = "couchblack_right"

/obj/structure/stool/bed/chair/comfy/couch/black/left
	icon_state = "couchblack_left"

/obj/structure/stool/bed/chair/comfy/couch/black/middle
	icon_state = "couchblack_middle"

//BROWN///////////////////////////////////////////////
/obj/structure/stool/bed/chair/comfy/couch/brown/right
	icon_state = "couchbrown_right"

/obj/structure/stool/bed/chair/comfy/couch/brown/left
	icon_state = "couchbrown_left"

/obj/structure/stool/bed/chair/comfy/couch/brown/middle
	icon_state = "couchbrown_middle"

//BEIGE///////////////////////////////////////////////
/obj/structure/stool/bed/chair/comfy/couch/beige/right
	icon_state = "couchbeige_right"

/obj/structure/stool/bed/chair/comfy/couch/beige/left
	icon_state = "couchbeige_left"

/obj/structure/stool/bed/chair/comfy/couch/beige/middle
	icon_state = "couchbeige_middle"

//TEAL//////////////////////////////////////////////////
/obj/structure/stool/bed/chair/comfy/couch/teal/right
	icon_state = "couchteal_right"

/obj/structure/stool/bed/chair/comfy/couch/teal/left
	icon_state = "couchteal_left"

/obj/structure/stool/bed/chair/comfy/couch/teal/middle
	icon_state = "couchteal_middle"