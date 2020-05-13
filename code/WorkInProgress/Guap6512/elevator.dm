//A creative copypasta of the mining shuttle code

#define FIRST 1
#define SECOND 0

/datum/elevator
	var/elevator_tickstomove = 30
	var/elevator_moving = 0
	var/elevator_location = FIRST

	var/area_first = /area/shuttle/elevator/cargo/first
	var/area_second = /area/shuttle/elevator/cargo/second

	var/elevator_tag = "cargo"

/datum/elevator/New()
	..()
	var/buttons_found
	for(var/obj/machinery/elevator_button/B in world)
		if(B.elevator_tag == src.elevator_tag)
			B.controlled = src
			buttons_found++
	if(buttons_found < 2)
		warning("An elevator with tag \"[elevator_tag]\" has less than two buttons.")


/datum/elevator/proc/move_elevator()
	if(elevator_moving)	return
	elevator_moving = 1
	spawn(elevator_tickstomove)
		var/area/fromArea
		var/area/toArea
		if (elevator_location == FIRST)
			fromArea = locate(area_first)
			toArea = locate(area_second)

		else
			fromArea = locate(area_second)
			toArea = locate(area_first)

		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in toArea)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		// hey you, get out of the way!
		if(elevator_location == SECOND)		//It means that the elevator can destroy something, because it is moving down.
			for(var/turf/T in dstturfs)
				// find the turf to move things to
				var/turf/D = locate(T.x, throwy - 1, 1)
				//var/turf/E = get_step(D, SOUTH)

				for(var/atom/movable/AM as mob|obj in T)
					if(istype(AM, /mob/living))
						var/mob/living/victim = AM
						victim.gib()
					else
						AM.Move(D)
					// NOTE: Commenting this out to avoid recreating mass driver glitch
					/*
					spawn(0)
						AM.throw_at(E, 1, 1)
						return
					*/

				if(istype(T, /turf/simulated))
					del(T)

			for(var/mob/living/carbon/bug in toArea) // If someone somehow is still in the shuttle's docking area...
				bug.gib()

			for(var/mob/living/simple_animal/pest in toArea) // And for the other kind of bug...
				pest.gib()

		if(elevator_location == FIRST)
			fromArea.move_contents_to(toArea, /turf/simulated/floor/plating)
		else
			fromArea.move_contents_to(toArea, /turf/simulated/floor/open)

		if (elevator_location == FIRST)
			elevator_location = SECOND
		else
			elevator_location = FIRST

		elevator_moving = 0
	return


/datum/elevator/rnd
	elevator_tag = "rnd"
	area_first = /area/shuttle/elevator/medbay/first
	area_second = /area/shuttle/elevator/medbay/second


#undef FIRST
#undef SECOND

/obj/machinery/elevator_button
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "access_button_standby"
	name = "elevator button"

	anchored = 1
	power_channel = ENVIRON

	var/on = 1
	var/elevator_tag = "cargo"
	var/datum/elevator/controlled


/obj/machinery/elevator_button/update_icon()
	if(on)
		icon_state = "access_button_standby"
	else
		icon_state = "access_button_off"

/obj/machinery/elevator_button/attack_hand(mob/user)
	add_fingerprint(usr)

	if(controlled)
		controlled.move_elevator()
	else
		error("No elevator controller.")

	flick("access_button_cycle", src)

/obj/machinery/elevator_button/rnd
	elevator_tag = "rnd"
