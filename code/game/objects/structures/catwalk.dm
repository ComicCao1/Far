/obj/structure/catwalk
	layer = TURF_LAYER + 0.5
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk"
	name = "catwalk"
	desc = "Cats really don't like these things."
	density = 0
	anchored = 1.0

	New()
		..()
		spawn(4)
			if(src)
				update_icon()
				for (var/dir in cardinal)
					if(locate(/obj/structure/catwalk, get_step(src, dir)))
						var/obj/structure/catwalk/L = locate(/obj/structure/catwalk, get_step(src, dir))
						L.update_icon() //so siding get updated properly
	proc
		is_catwalk()
			if(istype(src, /obj/structure/catwalk))
				return 1
			else
				return 0




/obj/structure/catwalk/update_icon()
	world << "/blue Okey, i'am started."

	var/connectdir = 0
	for(var/direction in cardinal)
		world << "I'am in list [direction]."
		if(locate(/obj/structure/catwalk, get_step(src, dir)))
			var/obj/structure/catwalk/FF = locate(/obj/structure/catwalk, get_step(src, dir))
			world << "Yeeh, my type is [src]."
			world << "[FF] is ready?"
			if(FF.is_catwalk())
				world << "*happy* [FF] is [src]"
				connectdir |= direction
				world << "/red [direction] is finished ok!"
	//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
	var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
	world << "Now to digonalcoonnect!"
	//Northeast
	if(connectdir & NORTH && connectdir & EAST)
		world << "Ok. In [connectdir] and [NORTH] and [connectdir] and [EAST]"
		if(istype(get_step(src,NORTHEAST),/obj/structure/catwalk))
			world << "Ok. Type is [src]"
			var/obj/structure/catwalk/FF = get_step(src,NORTHEAST)
			if(FF.is_catwalk())
				world << "Ok. [FF] is [src]"
				diagonalconnect |= 1
			//Southeast
	if(connectdir & SOUTH && connectdir & EAST)
		world << "Ok. In [connectdir] and [NORTH] and [connectdir] and [EAST]"
		if(istype(get_step(src,SOUTHEAST),/obj/structure/catwalk))
			world << "Ok. Type is [src]"
			var/obj/structure/catwalk/FF = get_step(src,SOUTHEAST)
			if(FF.is_catwalk())
				world << "Ok. [FF] is [src]"
				diagonalconnect |= 2
	//Northwest
	if(connectdir & NORTH && connectdir & WEST)
		world << "Ok. In [connectdir] and [NORTH] and [connectdir] and [EAST]"
		if(istype(get_step(src,NORTHWEST),/obj/structure/catwalk))
			world << "Ok. Type is [src]"
			var/obj/structure/catwalk/FF = get_step(src,NORTHWEST)
			if(FF.is_catwalk())
				world << "Ok. [FF] is [src]"
				diagonalconnect |= 4
	//Southwest
	if(connectdir & SOUTH && connectdir & WEST)
		world << "Ok. In [connectdir] and [NORTH] and [connectdir] and [EAST]"
		if(istype(get_step(src,SOUTHWEST),/obj/structure/catwalk))
			world << "Ok. Type is [src]"
			var/obj/structure/catwalk/FF = get_step(src,SOUTHWEST)
			if(FF.is_catwalk())
				world << "Ok. [FF] is [src]"
				diagonalconnect |= 8

	icon_state = "catwalk[connectdir]-[diagonalconnect]"


/obj/structure/catwalk/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/catwalk/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			user << "\blue Slicing lattice joints ..."
			new /obj/item/stack/rods(src.loc)
			new /obj/item/stack/rods(src.loc)
			new /obj/structure/lattice/(src.loc)
			qdel(src)
	return
