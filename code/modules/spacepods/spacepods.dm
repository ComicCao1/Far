// honk
#define DAMAGE			1
#define FIRE			2
#define EQUIP			3

/obj/spacepod
	name = "\improper space pod"
	desc = "A space pod meant for space travel."
	icon = 'icons/48x48/pods.dmi'
	density = 1 //Dense. To raise the heat.
	opacity = 0
	anchored = 1
	unacidable = 1
	layer = 3.9
	infra_luminosity = 15
	var/list/log = new
	var/list/proc_res = list() //stores proc owners, like proc_res["functionname"] = owner reference
	var/mob/living/carbon/occupant
	var/mob/living/carbon/passenger
	var/datum/spacepod/equipment/equipment_system
	var/obj/item/weapon/cell/battery
	var/datum/gas_mixture/cabin_air
	var/obj/machinery/portable_atmospherics/canister/internal_tank
	var/datum/effect/effect/system/ion_trail_follow/space_trail/ion_trail
	var/use_internal_tank = 0
	var/datum/global_iterator/pr_int_temp_processor //normalizes internal air mixture temperature
	var/datum/global_iterator/pr_give_air //moves air from tank to cabin
	var/hatch_open = 0
	var/next_firetime = 0
	var/list/pod_overlays
	var/health = 200
	var/can_move = 1
	var/move_delay = 2

	var/max_equip = 1
	var/list/equipment = new
	var/obj/item/device/spacepod_equipment/selected

	var/obj/structure/closet/crate/baggage = null

/obj/spacepod/New()
	. = ..()
	name = "Pod-[rand(100,999)]"
	if(!pod_overlays)
		pod_overlays = new/list(2)
		pod_overlays[DAMAGE] = image(icon, icon_state="pod_damage")
		pod_overlays[FIRE] = image(icon, icon_state="pod_fire")
	bound_width = 64
	bound_height = 64
//	dir = EAST
	battery = new()
	add_cabin()
	add_airtank()
	src.ion_trail = new /datum/effect/effect/system/ion_trail_follow/space_trail()
	src.ion_trail.set_up(src)
	src.ion_trail.start()
	src.use_internal_tank = 1
	pr_int_temp_processor = new /datum/global_iterator/pod_preserve_temp(list(src))
	pr_give_air = new /datum/global_iterator/pod_tank_give_air(list(src))
	equipment_system = new(src)

/obj/spacepod/Destroy()
	del(ion_trail)
	..()

/obj/spacepod/proc/click_action(atom/target,mob/user)
	if(!src.occupant || src.occupant != user )
		return
	if(user.stat)
		return
	if(hatch_open)
		occupant_message("<font color='red'>Maintenance protocols in effect, close the hatch!</font>")
		return
	if(!get_charge())
		return
	if(src == target)
		return
	var/dir_to_target = get_dir(src,target)
	if(dir_to_target && !(dir_to_target & src.dir))//wrong direction
		return
/*	if(hasInternalDamage(MECHA_INT_CONTROL_LOST))
		target = safepick(view(3,target))
		if(!target)
			return*/
	if(!target.Adjacent(src.get_active_part(1)) && !target.Adjacent(src.get_active_part(2)))
		if(selected && selected.is_ranged())
			selected.action(target)
	else if(selected && selected.is_melee())
		selected.action(target)
	else
		src.melee_action(target)
	return

/obj/spacepod/proc/melee_action(atom/target)
	return

/obj/spacepod/proc/range_action(atom/target)
	return

/obj/spacepod/proc/update_icons()
	if(!pod_overlays)
		pod_overlays = new/list(2)
		pod_overlays[DAMAGE] = image(icon, icon_state="pod_damage")
		pod_overlays[FIRE] = image(icon, icon_state="pod_fire")

	if(selected && selected.overlay_icon)
		pod_overlays.len = 3
		pod_overlays[EQUIP] = image(icon, icon_state="[src.selected.overlay_icon]")
		overlays += pod_overlays[EQUIP]

	if(health <= round(initial(health)/2))
		overlays += pod_overlays[DAMAGE]
		if(health <= round(initial(health)/4))
			overlays += pod_overlays[FIRE]
		else
			overlays -= pod_overlays[FIRE]
	else
		overlays -= pod_overlays[DAMAGE]

/obj/spacepod/bullet_act(var/obj/item/projectile/P)
	if(P.damage && !P.nodamage)
		deal_damage(P.damage)

/obj/spacepod/proc/deal_damage(var/damage)
	var/oldhealth = health
	health = max(0, health - damage)
	var/percentage = (health / initial(health)) * 100
	if((occupant || passenger) && oldhealth > health && percentage <= 25 && percentage > 0)
		var/sound/S = sound('sound/effects/engine_alert2.ogg')
		S.wait = 0 //No queue
		S.channel = 0 //Any channel
		S.volume = 50
		if(occupant)
			occupant << S
		if(passenger)
			passenger << S
	if((occupant || passenger) && oldhealth > health && !health)
		var/sound/S = sound('sound/effects/engine_alert1.ogg')
		S.wait = 0
		S.channel = 0
		S.volume = 50
		if(occupant)
			occupant << S
		if(passenger)
			passenger << S
	if(!health)
		spawn(0)
			if(occupant)
				occupant << "<big><span class='warning'>Critical damage to the vessel detected, core explosion imminent!</span></big>"
			if(passenger)
				passenger << "<big><span class='warning'>Critical damage to the vessel detected, core explosion imminent!</span></big>"
			for(var/i = 10, i >= 0; --i)
				if(occupant)
					occupant << "<span class='warning'>[i]</span>"
				if(passenger)
					passenger << "<span class='warning'>[i]</span>"
				if(i == 0)
					explosion(loc, 2, 4, 8)
				sleep(10)

	update_icons()

/obj/spacepod/ex_act(severity)
	switch(severity)
		if(1)
			var/mob/living/carbon/human/H = occupant
			var/mob/living/carbon/human/H2 = passenger
			if(H)
				H.loc = get_turf(src)
				H.ex_act(severity + 1)
				H << "<span class='warning'>You are forcefully thrown from \the [src]!</span>"
			if(H2)
				H2.loc = get_turf(src)
				H2.ex_act(severity + 1)
				H2 << "<span class='warning'>You are forcefully thrown from \the [src]!</span>"
			del(ion_trail)
			del(src)
		if(2)
			deal_damage(100)
		if(3)
			if(prob(40))
				deal_damage(50)

/obj/spacepod/attackby(obj/item/W as obj, mob/user as mob)
	if(iscrowbar(W))
		hatch_open = !hatch_open
		user.visible_message("<span class='notice'>[user] [hatch_open ? "opens" : "closes"] [src]'s maintenance hatch.</span>")
	if(istype(W, /obj/item/weapon/cell))
		if(!hatch_open)
			user << "<span class='warning'>Open the maintenance hatch first!</span>"
			return ..()
		if(battery)
			user << "<span class='notice'>The pod already has a battery.</span>"
			return
		user.drop_item(W)
		battery = W
		W.loc = src
		user.visible_message("<span class='notice'>[user] inserts [W] into [src].</span>")
		return
	if(istype(W, /obj/item/device/spacepod_equipment))
		var/obj/item/device/spacepod_equipment/E = W
		if(!hatch_open)
			user << "<span class='warning'>Open the maintenance hatch first!</span>"
			return ..()
		if(E.can_attach(src))
			user.drop_item()
			E.attach(src)
			user.visible_message("[user] attaches [W] to [src]", "You attach [W] to [src]")
			update_icons()
		else
			user << "You were unable to attach [W] to [src]"
		return

/obj/spacepod/attack_hand(mob/user as mob)
	if(!hatch_open)
		return ..()
	if(!equipment_system || !istype(equipment_system))
		user << "<span class='warning'>The pod has no equpment datum, or is the wrong type, yell at pomf.</span>"
		return
	var/list/possible = list()
	if(battery)
		possible.Add("Energy Cell")
	if(selected)
		possible.Add("Weapon System")
	/* Not yet implemented
	if(equipment_system.engine_system)
		possible.Add("Engine System")
	if(equipment_system.shield_system)
		possible.Add("Shield System")
	*/
	var/obj/item/device/spacepod_equipment/SPE
	switch(input(user, "Remove which equipment?", null, null) as null|anything in possible)
		if("Energy Cell")
			if(user.put_in_any_hand_if_possible(battery))
				user << "<span class='notice'>You remove \the [battery] from the space pod</span>"
				battery = null
		if("Weapon System")
			SPE = selected
			SPE.detach()
			user.put_in_any_hand_if_possible(SPE)
			user << "<span class='notice'>You remove \the [SPE] from the equipment system.</span>"
		/*
		if("engine system")
			SPE = equipment_system.engine_system
			if(user.put_in_any_hand_if_possible(SPE))
				user << "<span class='notice'>You remove \the [SPE] from the equipment system.</span>"
				equipment_system.engine_system = null
			else
				user << "<span class='warning'>You need an open hand to do that.</span>"
		if("shield system")
			SPE = equipment_system.shield_system
			if(user.put_in_any_hand_if_possible(SPE))
				user << "<span class='notice'>You remove \the [SPE] from the equipment system.</span>"
				equipment_system.shield_system = null
			else
				user << "<span class='warning'>You need an open hand to do that.</span>"
		*/

	return

/obj/spacepod/civilian
	icon_state = "pod_civ"
	desc = "A civilian-class vehicle pod, often used for exploration and trading."

	New()
		..()
		name = "Pod C-[rand(100,999)]"

/obj/spacepod/civilian/attackby(obj/item/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(G.state >= 2)
			if(src.occupant)
				user << "\red Someone is occupying the passenger's seat."
				return
			user.visible_message("\red [user] starts stuffing [G.affecting] into [name]!")
			if(do_after(user, 50))
				if(!src.occupant)
					moved_inside(G.affecting, 2)
					return
				else
					user << "\red Someone is occupying the passenger's seat."
					return
	..(W, user)

/obj/spacepod/industrial
	icon_state = "pod_industrial"
	desc = "A slow yet sturdy industrial pod, designed for hazardous work in asteroid belts."
	health = 400
	move_delay = 3

	New()
		..()
		name = "Pod I-[rand(100,999)]"

/obj/spacepod/random
	icon_state = "pod_civ"
// placeholder

/obj/spacepod/random/New()
	..()
	icon_state = pick("pod_civ", "pod_black", "pod_mil", "pod_synd", "pod_gold", "pod_industrial")
	switch(icon_state)
		if("pod_civ")
			desc = "A sleek civilian space pod."
		if("pod_black")
			desc = "An all black space pod with no insignias."
		if("pod_mil")
			desc = "A dark grey space pod brandishing the Nanotrasen Military insignia."
		if("pod_synd")
			desc = "A menacing military space pod with \"Fuck NT\" stenciled onto the side."
		if("pod_gold")
			desc = "A civilian space pod with a gold body, must have cost somebody a pretty penny."
		if("pod_industrial")
			desc = "A rough looking space pod meant for industrial work."

/obj/spacepod/verb/toggle_internal_tank()
	set name = "Toggle internal airtank usage"
	set category = "Spacepod"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant && usr!=src.passenger)
		return
	use_internal_tank = !use_internal_tank

	occupant_message("<span class='notice'>Now taking air from [use_internal_tank?"internal airtank":"environment"].</span>")

	return

/obj/spacepod/proc/add_cabin()
	cabin_air = new
	cabin_air.temperature = T20C
	cabin_air.volume = 200
	cabin_air.adjust_multi("oxygen", O2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature), "nitrogen", N2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature))
	return cabin_air

/obj/spacepod/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

/obj/spacepod/proc/get_turf_air()
	var/turf/T = get_turf(src)
	if(T)
		. = T.return_air()
	return

/obj/spacepod/remove_air(amount)
	if(use_internal_tank)
		return cabin_air.remove(amount)
	else
		var/turf/T = get_turf(src)
		if(T)
			return T.remove_air(amount)
	return

/obj/spacepod/return_air()
	if(use_internal_tank)
		return cabin_air
	return get_turf_air()

/obj/spacepod/proc/return_pressure()
	. = 0
	if(use_internal_tank)
		. =  cabin_air.return_pressure()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.return_pressure()
	return

/obj/spacepod/proc/return_temperature()
	. = 0
	if(use_internal_tank)
		. = cabin_air.temperature
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.temperature
	return

/obj/spacepod/proc/moved_inside(var/mob/living/carbon/human/H as mob,var/seat = 1)
	if(H && H.client && H in range(1))
		H.reset_view(src)
		/*
		H.client.perspective = EYE_PERSPECTIVE
		H.client.eye = src
		*/
		H.stop_pulling()
		H.forceMove(src)
		src.add_fingerprint(H)
		if(seat == 1)
			src.occupant = H
			src.forceMove(src.loc)
		else
			src.passenger = H
			src.forceMove(src.loc)
		//dir = dir_in
		playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
		return 1
	else
		return 0

/obj/spacepod/MouseDrop_T(var/atom/movable/M, mob/user as mob, )
	if(istype(M, /obj/structure/closet/crate))
		user << "<span class='notice'>You start to putting [M.name].</spane>"
		if(do_after(user, 50))
			baggage = M
			M.loc = src
			user << "<span class='notice'>You put [M.name] to [src.name].</spane>"


	if(M != user)
		return

	move_inside(M, user)

/obj/spacepod/verb/eject_baggage(mob/user as mob)
	if(baggage!=null)
		set category = "Object"
		set name = "Eject baggage"
		set src in oview(1)
		var/obj/structure/closet/crate/O = null

		user << "<span class='notice'>You start to ejecting [baggage.name].</spane>"
		if(do_after(user, 50))
			O = baggage
			baggage = null
			O.loc = user.loc
			user << "<span class='notice'>You eject [baggage.name].</spane>"


/obj/spacepod/verb/move_inside()
	set category = "Object"
	set name = "Enter Pod"
	set src in oview(1)

	if(usr.restrained() || usr.stat || usr.weakened || usr.stunned || usr.paralysis || usr.resting) //are you cuffed, dying, lying, stunned or other
		return
	if (usr.stat || !ishuman(usr))
		return

	if(usr == src.occupant || usr == src.passenger)
		return

	var/target_place = "Driver's"

	if(istype(src, /obj/spacepod/civilian))
		target_place = alert(usr, "What seat would you like to occupy?",,"Driver's","Passenger's")

	if (target_place == "Driver's" && src.occupant)
		usr << "\blue <B>The [src.name]'s cabin is already occupied!</B>"
		return
	else if(target_place == "Passenger's" && src.passenger)
		usr << "\blue <B>The [src.name]'s passenger seat is already occupied!</B>"
		return
/*
	if (usr.abiotic())
		usr << "\blue <B>Subject cannot have abiotic items on.</B>"
		return
*/
	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.Victim == usr)
			usr << "You're too busy getting your life sucked out of you."
			return
//	usr << "You start climbing into [src.name]"

	if(target_place == "Driver's")
		visible_message("\blue [usr] starts to climb into the [src.name].")
	else if(target_place == "Passenger's")
		visible_message("\blue [usr] starts to enter the [src.name]'s passenger's door.")

	if(enter_after(40,usr))
		if(target_place == "Driver's")
			if(!src.occupant)
				moved_inside(usr,1)
				visible_message("\blue [usr] climbs into the [src.name].")
			else if(src.occupant!=usr)
				usr << "[src.occupant] was faster. Try better next time, loser."
		else if(target_place == "Passenger's")
			if(!src.passenger)
				moved_inside(usr,2)
				visible_message("\blue [usr] climbs into the [src.name] through it's passenger's door.")
			else if(src.passenger!=usr)
				usr << "[src.passenger] was faster. Try better next time, loser."
	else
		usr << "You stop entering the spacepod."
	return

/obj/spacepod/verb/exit_pod()
	set name = "Exit pod"
	set category = "Spacepod"
	set src = usr.loc

	if(usr != src.occupant && usr != src.passenger)
		return
	if(usr == src.passenger)
		src.passenger.loc = src.loc
		src.passenger = null
		usr << "<span class='notice'>You climb out of the pod</span>"
	else if(usr == src.occupant)
		inertia_dir = 0 // engage reverse thruster and power down pod
		src.occupant.loc = src.loc
		src.occupant = null
		usr << "<span class='notice'>You climb out of the pod</span>"
	return

/obj/spacepod/proc/enter_after(delay as num, var/mob/user as mob, var/numticks = 5)
	var/delayfraction = delay/numticks

	var/turf/T = user.loc

	for(var/i = 0, i<numticks, i++)
		sleep(delayfraction)
		if(!src || !user || !user.canmove || !(user.loc == T))
			return 0

	return 1

/datum/global_iterator/pod_preserve_temp  //normalizing cabin air temperature to 20 degrees celsium
	delay = 20

	process(var/obj/spacepod/spacepod)
		if(spacepod.cabin_air && spacepod.cabin_air.volume > 0)
			var/delta = spacepod.cabin_air.temperature - T20C
			spacepod.cabin_air.temperature -= max(-10, min(10, round(delta/4,0.1)))
		return

/datum/global_iterator/pod_tank_give_air
	delay = 15

	process(var/obj/spacepod/spacepod)
		if(spacepod.internal_tank)
			var/datum/gas_mixture/tank_air = spacepod.internal_tank.return_air()
			var/datum/gas_mixture/cabin_air = spacepod.cabin_air

			var/release_pressure = ONE_ATMOSPHERE
			var/cabin_pressure = cabin_air.return_pressure()
			var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
			var/transfer_moles = 0
			if(pressure_delta > 0) //cabin pressure lower than release pressure
				if(tank_air.temperature > 0)
					transfer_moles = pressure_delta*cabin_air.volume/(cabin_air.temperature * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
					cabin_air.merge(removed)
			else if(pressure_delta < 0) //cabin pressure higher than release pressure
				var/datum/gas_mixture/t_air = spacepod.get_turf_air()
				pressure_delta = cabin_pressure - release_pressure
				if(t_air)
					pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
				if(pressure_delta > 0) //if location pressure is lower than cabin pressure
					transfer_moles = pressure_delta*cabin_air.volume/(cabin_air.temperature * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
					if(t_air)
						t_air.merge(removed)
					else //just delete the cabin gas, we're in space or some shit
						del(removed)
		else
			return stop()
		return

/obj/spacepod/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0)
	..()
	if(dir == 1 || dir == 4)
		src.loc.Entered(src)

/obj/spacepod/Process_Spacemove(var/check_drift = 0, mob/user)
	var/dense_object = 0
	if(!user)
		for(var/direction in list(NORTH, NORTHEAST, EAST))
			var/turf/cardinal = get_step(src, direction)
			if(istype(cardinal, /turf/space))
				continue
			dense_object++
			break
	if(!dense_object)
		return 0
	inertia_dir = 0
	return 1

/obj/spacepod/proc/canmove_over_z(var/direction)
	var/turf/controllerlocation = locate(1, 1, src.z)
	if(!isturf(src.loc))
		return 0
	if(!direction)
		return 0
	var/list/probable_block = new/list(4)
	var/free_cells = 0
	var/turf/T1 = get_turf(src)
	var/turf/T2 = locate(T1.x, (T1.y+1), T1.z)
	var/turf/T3 = locate((T1.x+1), T1.y, T1.z)
	var/turf/T4 = locate((T1.x+1), (T1.y+1), T1.z)

	if(direction == UP)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if (controller.up)
				T1 = locate(T1.x, T1.y, controller.up_target)
				T2 = locate(T2.x, T2.y, controller.up_target)
				T3 = locate(T3.x, T3.y, controller.up_target)
				T4 = locate(T4.x, T4.y, controller.up_target)
				probable_block.Add(T1,T2,T3,T4)
				for(var/turf/T in probable_block)
					if(istype(T, /turf/space) || istype(T, /turf/simulated/floor/open))
						var/blocked = 0
						for(var/atom/A in T.contents)
							if(T.density)
								blocked = 1
								break
						if(!blocked)
							free_cells++
	else if(direction == DOWN)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if (controller.down)
				T1 = locate(T1.x, T1.y, controller.down_target)
				T2 = locate(T2.x, T2.y, controller.down_target)
				T3 = locate(T3.x, T3.y, controller.down_target)
				T4 = locate(T4.x, T4.y, controller.down_target)
				probable_block.Add(T1,T2,T3,T4)
				for(var/turf/T in probable_block)
					if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/floor/open)))
						return 0
					if(istype(T, /turf/space) || istype(T, /turf/simulated/floor/open))
						var/blocked = 0
						for(var/atom/A in T.contents)
							if(T.density)
								blocked = 1
								break
						if(!blocked)
							free_cells++
	if(free_cells == 4)
		return 1
	else
		return 0


/obj/spacepod/relaymove(mob/user, direction)
	var/moveship = 1
	var/turf/controllerlocation = locate(1, 1, src.z)

	if(user == passenger)
		user << "<span class='warning'>You are not driving this pod!</span>"
		return

	if(!can_move)
		return

	if(battery && battery.charge >= 3 && health)
		var/olddir = dir
		src.dir = direction
		switch(direction)
			if(1)
				if(inertia_dir == 2)
					inertia_dir = 0
					moveship = 0
			if(2)
				if(inertia_dir == 1)
					inertia_dir = 0
					moveship = 0
			if(4)
				if(inertia_dir == 8)
					inertia_dir = 0
					moveship = 0
			if(8)
				if(inertia_dir == 4)
					inertia_dir = 0
					moveship = 0
			if(UP)
				for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
					if(controller.up)
						if(canmove_over_z(UP))
							var/turf/T = locate(x, y, controller.up_target)
							Move(T, dir)
							dir = olddir
							moveship = 0
						else
							occupant_message("\red Something is blocking the way up!")
					else
						occupant_message("\blue There is nothing of interest in this direction.")
			if(DOWN)
				for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
					if(controller.down)
						if(canmove_over_z(DOWN))
							var/turf/T = locate(x, y, controller.down_target)
							Move(T, dir)
							dir = olddir
							moveship = 0
						else
							occupant_message("\red Something is blocking the way down!")
					else
						occupant_message("\blue There is nothing of interest in this direction.")

		if(moveship)
			step(src, direction)
			if(istype(src.loc, /turf/space))
				inertia_dir = direction
			can_move = 0
			sleep(move_delay)
			can_move = 1
	else
		if(!battery)
			user << "<span class='warning'>No energy cell detected.</span>"
		else if(battery.charge < 3)
			user << "<span class='warning'>Not enough charge left.</span>"
		else if(!health)
			user << "<span class='warning'>She's dead, Jim</span>"
		else
			user << "<span class='warning'>Unknown error has occurred, yell at pomf.</span>"
		return 0
	battery.charge = max(0, battery.charge - 3)


/obj/spacepod/verb/toggleDoors()
	set name = "Toggle Nearby Pod Doors"
	set category = "Spacepod"
	set src = usr.loc

	for(var/obj/machinery/door/poddoor/P in oview(3,src))
		if(istype(P, /obj/machinery/door/poddoor/four_tile_ver/podlock))
			var/mob/living/carbon/human/L = usr
			if(P.check_access(L.get_active_hand()) || P.check_access(L.wear_id))
				if(P.density)
					P.open()
					return 1
				else
					P.close()
					return 1
			usr << "<span class='warning'>Access denied.</span>"
			return
	usr << "<span class='warning'>You are not close to any pod doors.</span>"
	return

////////////////////////////////
/////// Messages and Log ///////
////////////////////////////////

/obj/spacepod/proc/occupant_message(message as text)
	if(message)
		if(src.occupant && src.occupant.client)
			src.occupant << "\icon[src] [message]"
		if(src.passenger && src.passenger.client)
			src.passenger << "\icon[src] [message]"
	return

/obj/spacepod/proc/log_message(message as text,red=null)
	log.len++
	log[log.len] = list("time"=world.timeofday,"message"="[red?"<font color='red'>":null][message][red?"</font>":null]")
	return log.len

/obj/spacepod/proc/log_append_to_last(message as text,red=null)
	var/list/last_entry = src.log[src.log.len]
	last_entry["message"] += "<br>[red?"<font color='red'>":null][message][red?"</font>":null]"
	return


///////////////////////
///// Power stuff /////
///////////////////////

/obj/spacepod/proc/has_charge(amount)
	return (get_charge()>=amount)

/obj/spacepod/proc/get_charge()
	return call((proc_res["dyngetcharge"]||src), "dyngetcharge")()

/obj/spacepod/proc/dyngetcharge()//returns null if no powercell, else returns cell.charge
	if(!src.battery) return
	return max(0, src.battery.charge)

/obj/spacepod/proc/use_power(amount)
	return call((proc_res["dynusepower"]||src), "dynusepower")(amount)

/obj/spacepod/proc/dynusepower(amount)
	if(get_charge())
		battery.use(amount)
		return 1
	return 0


/obj/spacepod/proc/get_active_part(var/num = 1)
	var/first
	var/second
	var/third
	var/fourth

	switch(dir)
		if(NORTH)
			first = get_step(src, NORTH)
			second = get_step(first,EAST)
			third = get_step(src, EAST)
			fourth = get_turf(src)
		if(SOUTH)
			first = get_turf(src)
			second = get_step(first,EAST)
			third = get_step(src, NORTH)
			fourth = get_step(second, NORTH)
		if(EAST)
			first = get_turf(src)
			first = get_step(first, EAST)
			second = get_step(first,NORTH)
			third = get_step(first, WEST)
			fourth = get_step(second, WEST)
		if(WEST)
			first = get_turf(src)
			second = get_step(first,NORTH)
			third = get_step(first, EAST)
			fourth = get_step(second, EAST)

	switch(num)
		if(1)
			return first
		if(2)
			return second
		if(3)
			return third
		if(4)
			return fourth

////////////////////////////////
/////// Other shit	//// ///////
////////////////////////////////

/obj/effect/landmark/spacepod/random
	name = "spacepod spawner"
	invisibility = 101
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1

/obj/effect/landmark/spacepod/random/New()
	..()

/turf/Enter(var/obj/spacepod/S)
	if(!istype(S))
		return ..()
	if(!istype(src, /turf/space) && !istype(src, /turf/simulated/floor/engine) && !istype(src,/turf/simulated/floor/plating) && !istype(src, /turf/simulated/floor/open))
		return 0
	else
		return ..()


#undef DAMAGE
#undef FIRE
#undef EQUIP