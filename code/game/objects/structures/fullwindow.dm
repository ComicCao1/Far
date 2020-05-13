/obj/structure/window/full
//	sheets = 2
	health = 0
	dir=SOUTHWEST
	mouse_opacity=2 // Complete opacity.
	layer = 2.91 // Abowe grilles, beneath firelocks.

/obj/structure/window/full/CheckExit(atom/movable/O as mob|obj, target as turf)
	return 1

/obj/structure/window/full/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	return 0

/obj/structure/window/full/is_fulltile()
	return 1

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/full/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	//This spawn is here so windows get properly updated when one gets deleted.
	spawn(2)
		if(!src) return
		if(!is_fulltile())
			return
		var/junction = 0 //will be used to determine from which side the window is connected to other windows
		if(anchored)
			for(var/obj/structure/window/full/W in orange(src,1))
				if(W.anchored && W.density) //Only counts anchored, not-destroyed full-tile windows.
					if(abs(x-W.x)-abs(y-W.y) ) 		//doesn't count windows, placed diagonally to src
						junction |= get_dir(src,W)
		icon_state = "[initial(icon_state)][junction]"

		overlays.Cut()
		var/ratio = health / maxhealth
		ratio = Ceiling(ratio*4) * 25
		overlays += "damage[ratio]"
		return

/obj/structure/window/full/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf) tforce *= 0.25
	playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
	health = max(0, health - tforce)
	update_nearby_icons()
	if(health <= 7 && !reinf)
		anchored = 0
		step(src, get_dir(AM, src))
	if(health <= 0)
		new /obj/item/weapon/shard(loc)
		if(reinf) new /obj/item/stack/rods(loc)
		del(src)


/obj/structure/window/full/basic
	desc = "It looks thin and flimsy. A few knocks with... anything, really should shatter it."
	icon_state = "window"
	basestate = "window"
	maxhealth = 50

/obj/structure/window/full/plasmabasic
	name = "plasma window"
	desc = "A plasma-glass alloy window. It looks insanely tough to break. It appears it's also insanely tough to burn through."
	basestate = "plasmawindow"
	icon_state = "plasmawindow"
	shardtype = /obj/item/weapon/shard/plasma
	maxhealth = 100

/obj/structure/window/full/plasmabasic/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 32000)
		hit(round(exposed_volume / 1000), 0)
	..()

/obj/structure/window/full/plasmareinforced
	name = "reinforced plasma window"
	desc = "A plasma-glass alloy window, with rods supporting it. It looks hopelessly tough to break. It also looks completely fireproof, considering how basic plasma windows are insanely fireproof."
	basestate = "plasmarwindow"
	icon_state = "plasmarwindow"
	shardtype = /obj/item/weapon/shard/plasma
	reinf = 1
	maxhealth = 160

/obj/structure/window/full/plasmareinforced/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/obj/structure/window/full/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	basestate = "rwindow"
	maxhealth = 100
	reinf = 1

/obj/structure/window/full/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	basestate = "twindow"
//	opacity = 1

/obj/structure/window/full/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"
	basestate = "fwindow"
	maxhealth = 50