/turf/simulated/floor/open
	name = "open space"
	intact = 0
	density = 0
	icon_state = "black"
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts
	var/icon/darkoverlays = null
	var/turf/floorbelow
	var/list/overlay_references

	New()
		..()
		getbelow()
		return

	Enter(var/atom/movable/AM)
		if (..()) //TODO make this check if gravity is active (future use) - Sukasa
			spawn(1)
				// only fall down in defined areas (read: areas with artificial gravitiy)
				if(!floorbelow) //make sure that there is actually something below
					if(!getbelow())
						return
				if(AM)
					var/blocked = 0
					for(var/atom/A in floorbelow.contents)
						if(A.density)
							blocked = 1
							break
						if(istype(A, /obj/machinery/atmospherics/pipe/zpipe/up) && istype(AM,/obj/item/pipe))
							blocked = 1
							break
						if(istype(A, /obj/structure/disposalpipe/crossZ/up) && istype(AM,/obj/item/pipe))
							blocked = 1
							break

							//dont break here, since we still need to be sure that it isnt blocked

					if (!blocked && has_gravity(src))
						if ( istype(AM, /mob/living/carbon/human))
							var/mob/living/carbon/human/H = AM
							if(AM:back && istype(AM:back, /obj/item/weapon/tank/jetpack))
								return
							blocked = 0
							for(var/atom/A in src)
								if(A.density&&A!=AM)
									blocked = 1
									break
								if(istype(A, /obj/machinery/atmospherics/pipe))
									blocked = 1
									if(prob(20))
										blocked = 0
										AM.visible_message("<span class='warning'>[AM.name] breaks through [A] and falls down!","<span class='warning'>You breaks through [A] and falls down!")
										A.Destroy()
								//	else if((FAT in AM.mutations) && prob(80))
								//		blocked = 0
								//		AM.visible_message("<span class='warning'>[AM.name] breaks through [A] and falls down!","<span class='warning'>You breaks through [A] and falls down!")
								//		A.Destroy()
									break

								if(istype(A, /obj/structure/disposalpipe))
									blocked = 1
									if(prob(10))
										blocked = 0
										AM.visible_message("<span class='warning'>[AM.name] breaks through [A] and falls down!","<span class='warning'>You breaks through [A] and falls down!")
										A.Destroy()
								//	else if((FAT in AM.mutations) && prob(40))
								//		blocked = 0
								//		AM.visible_message("<span class='warning'>[AM.name] breaks through [A] and falls down!","<span class='warning'>You breaks through [A] and falls down!")
								//		A.Destroy()
									break
								if(istype(A, /obj/structure/catwalk))
									blocked = 1
								if(istype(A, /obj/structure/lattice))
									blocked = 1
									if(prob(3))
										blocked = 0
										AM.visible_message("<span class='warning'>[AM.name] breaks through [A] and falls down!","<span class='warning'>You breaks through [A] and falls down!")
										A.Destroy()
								//	else if((FAT in AM.mutations) && prob(10))
								//		blocked = 0
								//		AM.visible_message("<span class='warning'>[AM.name] breaks through [A] and falls down!","<span class='warning'>You breaks through [A] and falls down!")
								//		A.Destroy()
									break

							if (!blocked)
								AM.Move(floorbelow)
								var/damage = 10
	//							H.apply_damage(rand(0,damage), BRUTE, "groin")
								H.apply_damage(damage/2 + rand(-5,5), BRUTE, "l_leg")
								H.apply_damage(damage/2 + rand(-5,5), BRUTE, "r_leg")
								H.apply_damage(damage + rand(-5,5), BRUTE, "l_foot")
								H.apply_damage(damage + rand(-5,5), BRUTE, "r_foot")
								H:weakened = max(H:weakened,2)
								playsound(H.loc, 'sound/effects/fallsmash.ogg', 50, 1)//Splat
								H:updatehealth()
						else
							AM.Move(floorbelow)
		return ..()

/turf/simulated/floor/open/proc/getbelow()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		// check if there is something to draw below
		if(!controller.down)
			src.ChangeTurf(/turf/space)
			return 0
		else
			floorbelow = locate(src.x, src.y, controller.down_target)
			return 1
	return 1

// override to make sure nothing is hidden
/turf/simulated/floor/open/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

//overwrite the attackby of space to transform it to openspace if necessary
/turf/space/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/cable_coil))
		var/turf/simulated/floor/open/W = src.ChangeTurf(/turf/simulated/floor/open)
		W.attackby(C, user)
		return
	..()

/turf/simulated/floor/open/ex_act(severity)
	// cant destroy empty space with an ordinary bomb
	return

/turf/simulated/floor/open/attackby(obj/item/C as obj, mob/user as mob)
	(..)
	if (istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/cable = C
		cable.turf_place(src, user)
		return

	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		user << "\blue Constructing support lattice ..."
		playsound(src.loc, 'sound/weapons/Genhit.ogg', 50, 1)
		ReplaceWithLattice()
		R.use(1)
		return

	if (istype(C, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			del(L)
			playsound(src.loc, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			user << "\red The plating is going to need some support."
	return