/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return 1
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)
	return


/client/North()
	..()


/client/South()
	..()


/client/West()
	..()


/client/East()
	..()


/client/Northeast()
	var/turf/controllerlocation = locate(1, 1, usr.z)
	var/obj/item/weapon/W = mob.equipped()
	if (istype(mob, /mob/dead/observer))
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if (controller.up)
				var/turf/T = locate(usr.x, usr.y, controller.up_target)
				mob.Move(T)
	else if (istype(mob, /mob/living/silicon/ai))
		AIMoveZ(UP, mob)
	else if(isobj(mob.loc))
		mob.loc:relaymove(mob,UP)
	else if(istype(mob, /mob/living/carbon))
		if (("back" in mob.vars) && istype(mob:back, /obj/item/weapon/tank/jetpack))
			mob:back:move_z(UP, mob)
		else if(("belt" in mob.vars) && istype(mob:belt, /obj/item/weapon/tank/jetpack))
			mob:belt:move_z(UP, mob)
		else if(istype(W, /obj/item/weapon/extinguisher) && istype(mob.loc, /turf/space))
			W:move_z(UP, mob)
		else
			mob:swap_hand()
	return


/client/Southeast()
	var/turf/controllerlocation = locate(1, 1, usr.z)
	var/obj/item/weapon/W = mob.equipped()
	if (istype(mob, /mob/dead/observer))
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if (controller.down)
				var/turf/T = locate(usr.x, usr.y, controller.down_target)
				mob.Move(T)
	else if (istype(mob, /mob/living/silicon/ai))
		AIMoveZ(DOWN, mob)
	else if(isobj(mob.loc))
		mob.loc:relaymove(mob,DOWN)
	else if(istype(mob, /mob/living/carbon))
		if (("back" in mob.vars) && istype(mob:back, /obj/item/weapon/tank/jetpack))
			mob:back:move_z(DOWN, mob)
		else if(("belt" in mob.vars) && istype(mob:belt, /obj/item/weapon/tank/jetpack))
			mob:belt:move_z(DOWN, mob)
		else if(istype(W, /obj/item/weapon/extinguisher) && istype(mob.loc, /turf/space))
			W:move_z(DOWN, mob)
		else if(W)
			W.attack_self(mob)
	return


/client/Southwest()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.toggle_throw_mode()
	else
		usr << "\red This mob type cannot throw items."
	return


/client/Northwest()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(!C.get_active_hand())
			usr << "\red You have nothing to drop in your hand."
			return
		drop_item()
	else
		usr << "\red This mob type cannot drop items."
	return

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		usr << "\blue You are not pulling anything."
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = 1
	if(istype(mob, /mob/living/carbon))
		mob:swap_hand()
	if(istype(mob,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return



/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/toggle_throw_mode()
	set hidden = 1
	if(!istype(mob, /mob/living/carbon))
		return
	if (!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob:toggle_throw_mode()
	else
		return


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob))
		mob.drop_item_v()
	return


/client/Center()
	/* No 3D movement in 2D spessman game. dir 16 is Z Up
	if (isobj(mob.loc))
		var/obj/O = mob.loc
		if (mob.canmove)
			return O.relaymove(mob, 16)
	*/
	return


/atom/movable/Move(NewLoc, direct)
	if (direct & (direct - 1))
		if (direct & 1)
			if (direct & 4)
				if (step(src, NORTH))
					step(src, EAST)
				else
					if (step(src, EAST))
						step(src, NORTH)
			else
				if (direct & 8)
					if (step(src, NORTH))
						step(src, WEST)
					else
						if (step(src, WEST))
							step(src, NORTH)
		else
			if (direct & 2)
				if (direct & 4)
					if (step(src, SOUTH))
						step(src, EAST)
					else
						if (step(src, EAST))
							step(src, SOUTH)
				else
					if (direct & 8)
						if (step(src, SOUTH))
							step(src, WEST)
						else
							if (step(src, WEST))
								step(src, SOUTH)
	else
		. = ..()
	return


/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.loc = get_step(mob.control_object,direct)
	return


/client/Move(n, direct)
	if(!mob)
		return 0
	if(mob.control_object)
		return Move_object(direct)
	if(world.time < move_delay)
		return 0
	if(isAI(mob))
		return AIMove(n,direct,mob)
	if(!isliving(mob))
		return mob.Move(n,direct)
	if(moving)
		return 0
	if(mob.stat == DEAD)
		return 0
	if(isliving(mob))
		var/mob/living/L = mob
		if(L.incorporeal_move)	//Move though walls
			Process_Incorpmove(direct)
			return 0

	if(Process_Grab())	return

	if(mob.buckled)							//if we're buckled to something, tell it we moved.
		return mob.buckled.relaymove(mob, direct)

	if(!mob.canmove)
		return 0

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	if(!has_gravity(mob))
		if(!mob.Process_Spacemove(0))
			return 0


	if(isobj(mob.loc) || ismob(mob.loc))	//Inside an object, tell it we moved
		var/atom/O = mob.loc
		return O.relaymove(mob, direct)


	if(isturf(mob.loc))

		if(mob.restrained())//Why being pulled while cuffed prevents you from moving
			for(var/mob/M in range(mob, 1))
				if(M.pulling == mob)
					if(!M.restrained() && M.stat == 0 && M.canmove && mob.Adjacent(M))
						src << "\blue You're restrained! You can't move!"
						return 0
					else
						M.stop_pulling()

		if(mob.pinned.len)
			src << "\blue You're pinned to a wall by [mob.pinned[1]]!"
			return 0

		move_delay = world.time//set move delay
		mob.last_move_intent = world.time + 10
		switch(mob.m_intent)
			if("run")
				if(mob.drowsyness > 0)
					move_delay += 6
				move_delay += config.run_speed
			if("walk")
				move_delay += config.walk_speed
		move_delay += mob.movement_delay()

		if(config.Tickcomp)
			move_delay -= 1.3
			var/tickcomp = ((1/(world.tick_lag))*1.3)
			move_delay = move_delay + tickcomp




		//We are now going to move
		moving = 1
		mob.update_gravity(mob)
		//Something with pulling things
		if(locate(/obj/item/weapon/grab, mob))
			move_delay = max(move_delay, world.time + 7)
			var/list/L = mob.ret_grab()
			if(istype(L, /list))
				if(L.len == 2)
					L -= mob
					var/mob/M = L[1]
					if(M)
						if ((get_dist(mob, M) <= 1 || M.loc == mob.loc))
							var/turf/T = mob.loc
							. = ..()
							if (isturf(M.loc))
								var/diag = get_dir(mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(mob, M) > 1 || diag))
									step(M, get_dir(M.loc, T))
				else
					for(var/mob/M in L)
						M.other_mobs = 1
						if(mob != M)
							M.animate_movement = 3
					for(var/mob/M in L)
						spawn( 0 )
							step(M, direct)
							return
						spawn( 1 )
							M.other_mobs = null
							M.animate_movement = 2
							return

		else if(mob.confused)
			step(mob, pick(cardinal))
		else
			. = ..()

		moving = 0

		return .

	return


///Process_Grab()
///Called by client/Move()
///Checks to see if you are being grabbed and if so attemps to break it
/client/proc/Process_Grab()
	if(locate(/obj/item/weapon/grab, locate(/obj/item/weapon/grab, mob.grabbed_by.len)))
		var/list/grabbing = list()
		if(istype(mob.l_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = mob.l_hand
			grabbing += G.affecting
		if(istype(mob.r_hand, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = mob.r_hand
			grabbing += G.affecting
		for(var/obj/item/weapon/grab/G in mob.grabbed_by)
			if((G.state == 1)&&(!grabbing.Find(G.assailant)))	del(G)
			if(G.state == 2)
				move_delay = world.time + 10
				if(!prob(25))	return 1
				mob.visible_message("\red [mob] has broken free of [G.assailant]'s grip!")
				del(G)
			if(G.state == 3)
				move_delay = world.time + 10
				if(!prob(5))	return 1
				mob.visible_message("\red [mob] has broken free of [G.assailant]'s headlock!")
				del(G)
	return 0


///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct)
	var/turf/mobloc = get_turf(mob)
	if(!isliving(mob))
		return
	var/mob/living/L = mob
	switch(L.incorporeal_move)
		if(1)
			L.loc = get_step(L, direct)
			L.dir = direct
		if(2)
			if(prob(50))
				var/locx
				var/locy
				switch(direct)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y+2)
						if(locy>world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y-2)
						if(locy<1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x+2)
						if(locx>world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x-2)
						if(locx<1)
							return
					else
						return
				L.loc = locate(locx,locy,mobloc.z)
				spawn(0)
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, L.loc))
						spawn(0)
							anim(T,L,'icons/mob/mob.dmi',,"shadow",,L.dir)
						limit--
						if(limit<=0)	break
			else
				spawn(0)
					anim(mobloc,mob,'icons/mob/mob.dmi',,"shadow",,L.dir)
				L.loc = get_step(L, direct)
			L.dir = direct
	return 1

///Process_Spacemove
///Called by /client/Move()
///For moving in space
///Return 1 for movement 0 for none
/mob/Process_Spacemove(var/movement_dir = 0)

	if(..())
		return 1

	var/atom/movable/dense_object_backup
	for(var/atom/A in orange(1, get_turf(src)))
		if(isarea(A))
			continue

		else if(isturf(A))
			var/turf/turf = A
			if(istype(turf,/turf/space))
				continue

			if(!turf.density && !mob_negates_gravity())
				continue

			return 1

		else
			var/atom/movable/AM = A
			if(AM == buckled) //Kind of unnecessary but let's just be sure
				continue
			if(AM.density)
				if(AM.anchored)
					if(istype(AM, /obj/item/projectile)) //"You grab the bullet and push off of it!" No
						continue
					return 1
				if(pulling == AM)
					continue
				dense_object_backup = AM

	if(movement_dir && dense_object_backup)
		if(dense_object_backup.newtonian_move(turn(movement_dir, 180))) //You're pushing off something movable, so it moves
			src << "<span class='info'>You push off of [dense_object_backup] to propel yourself.</span>"


		return 1
	return 0

/mob/proc/Process_Spaceslipping(var/prob_slip = 5)
	//Setup slipage
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.
	if(stat)
		prob_slip = 0  // Changing this to zero to make it line up with the comment.

	prob_slip = round(prob_slip)
	return(prob_slip)

/mob/proc/slip(var/s_amount, var/w_amount, var/obj/O, var/lube)
	return

/mob/proc/mob_has_gravity(turf/T)
	return has_gravity(src, T)

/mob/proc/mob_negates_gravity()
	return 0

/mob/proc/update_gravity()
	return