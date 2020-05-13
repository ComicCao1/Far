/obj/effect/decal/cleanable/poo
	name = "poo"
	desc = "It's a poo stain..."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7", "floor8")
//	var/datum/disease/virus = null
	var/dried = 0
//	decaltype = "poo"
//	blood_DNA = null
//	blood_type = null

/obj/effect/decal/cleanable/poo/New()
	src.icon = 'pooeffect.dmi'
	src.icon_state = pick(src.random_icon_states)
	for(var/obj/effect/decal/cleanable/poo/shit in src.loc)
		if(shit != src)
			del(shit)
//	spawn(5) src.reagents.add_reagent("poo",5)
	spawn(6000)
		src.dried = 1

/obj/effect/decal/cleanable/poo/tracks
	icon_state = "tracks"
	random_icon_states = null

/obj/effect/decal/cleanable/poo/drip
	name = "drips of poo"
	desc = "It's brown."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "drip1"
	random_icon_states = list("drip1", "drip2", "drip3", "drip4", "drip5")
//	blood_DNA = null
//	blood_type = null

/obj/effect/decal/cleanable/poo/proc/streak(var/list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (i > 0)
				new /obj/effect/decal/cleanable/poo(src.loc)
			if (step_to(src, get_step(src, direction), 0))
				break

/obj/effect/decal/cleanable/poo/HasEntered(AM as mob|obj, var/forceslip = 0)
	if (istype(AM, /mob/living/carbon) && src.dried == 0)
		var/mob/living/carbon/M =	AM
		if ((istype(M, /mob/living/carbon/human) && M:shoes.flags&NOSLIP) || M.m_intent == "walk")
			return

		if(prob(30) || forceslip)
			M.stop_pulling()
			step(M, M.dir)
			if(locate(/obj/effect/decal/cleanable/poo) in get_turf(M))
				var/obj/effect/decal/cleanable/poo/way = locate() in get_turf(M)
				way.HasEntered(M, 1)
			M << "\blue You slipped on the wet poo stain!"
			M.unlock_medal("Oh Shit!", 0, "Slip on the poo stain!", "easy")
			playsound(src.loc, 'slip.ogg', 50, 1, -3)
			M.stunned = 1
			M.weakened = 3

/obj/effect/decal/cleanable/poo/tracks/HasEntered(AM as mob|obj)
	return

/obj/effect/decal/cleanable/poo/drip/HasEntered(AM as mob|obj)
	return

/obj/effect/decal/cleanable/urine
	name = "Urine puddle"
	desc = "Someone couldn't hold it.."
	density = 0
	anchored = 1
	layer = 2
	icon = 'pooeffect.dmi'
	icon_state = "pee1"
	random_icon_states = list("pee1", "pee2", "pee3")
//	var/datum/disease/virus = null
//	decaltype = "urine"
//	blood_DNA = null
//	blood_type = null

/obj/effect/decal/cleanable/urine/HasEntered(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if ((istype(M, /mob/living/carbon/human) && istype(M:shoes, /obj/item/clothing/shoes/galoshes)) || M.m_intent == "walk")
			return

		if(prob(30))
			M.pulling = null
			M << "\blue You slipped in the urine puddle!"
	//		M.achievement_give("Pissed!", 69)
			playsound(src.loc, 'slip.ogg', 50, 1, -3)
			M.stunned = 8
			M.weakened = 5

/obj/effect/decal/cleanable/urine/New()
	src.icon_state = pick(src.random_icon_states)
//	spawn(10) src.reagents.add_reagent("urine",5)
//	..()
	spawn(800)
		del(src)
