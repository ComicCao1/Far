/datum/spacepod/equipment
	var/obj/spacepod/chassis
	var/obj/item/device/spacepod_equipment/weaponry/weapon_system // weapons system
	//var/obj/item/device/spacepod_equipment/engine/engine_system // engine system
	//var/obj/item/device/spacepod_equipment/shield/shield_system // shielding system

/datum/spacepod/equipment/New(var/obj/spacepod/SP)
	..()
	if(istype(SP))
		chassis = SP

/obj/item/device/spacepod_equipment
	name = "equipment"
	icon = 'icons/pods/ship.dmi'
	var/construction_cost = list("metal"=10000)
	var/construction_time = 100
	var/overlay_icon
	var/obj/spacepod/chassis
	var/range = MELEE //bitflags
	var/equip_cooldown = 0
	var/equip_ready = 1
	var/energy_drain = 0

// base item for spacepod equipment

/obj/item/device/spacepod_equipment/proc/action(atom/target)
	return

/obj/item/device/spacepod_equipment/proc/can_attach(obj/spacepod/SP as obj)
	if(istype(SP))
		if(SP.equipment.len<SP.max_equip)
			return 1
	return 0

/obj/item/device/spacepod_equipment/proc/attach(obj/spacepod/SP as obj)
	SP.equipment += src
	chassis = SP
	src.loc = SP
	SP.log_message("[src] initialized.")
	if(!SP.selected)
		SP.selected = src
	return

/obj/item/device/spacepod_equipment/proc/detach(atom/moveto=null)
	moveto = moveto || get_turf(chassis)
	if(src.Move(moveto))
		chassis.equipment -= src
		if(chassis.selected == src)
			chassis.selected = null
		chassis.log_message("[src] removed from equipment.")
		chassis.update_icons()
		chassis = null
		set_ready_state(1)
	return

/obj/item/device/spacepod_equipment/proc/is_ranged()//add a distance restricted equipment. Why not?
	return range&RANGED

/obj/item/device/spacepod_equipment/proc/is_melee()
	return range&MELEE

/obj/item/device/spacepod_equipment/proc/do_after_cooldown(target=1)
	sleep(equip_cooldown)
	set_ready_state(1)
	if(target && chassis)
		return 1
	return 0

/obj/item/device/spacepod_equipment/proc/set_ready_state(state)
	equip_ready = state
	if(chassis)
		send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
	return

/obj/item/device/spacepod_equipment/proc/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[chassis.selected==src?"<b>":"<a href='?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected==src?"</b>":"</a>"]"

/obj/item/device/spacepod_equipment/proc/occupant_message(message)
	if(chassis)
		chassis.occupant_message("\icon[src] [message]")
	return

/obj/item/device/spacepod_equipment/proc/log_message(message)
	if(chassis)
		chassis.log_message("<i>[src]:</i> [message]")
	return

/obj/item/device/spacepod_equipment/proc/action_checks(atom/target)
	if(!target)
		return 0
	if(!chassis)
		return 0
	if(!equip_ready)
		return 0
	if(crit_fail)
		return 0
	if(energy_drain && !chassis.has_charge(energy_drain))
		return 0
	return 1
