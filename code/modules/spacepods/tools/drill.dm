/obj/item/device/spacepod_equipment/tool/drill
	name = "Drill"
	desc = "This is the drill that'll pierce the heavens! (Can be attached to: Industrial Spacepods)"
	icon_state = "pod_taser"
	overlay_icon = "pod_weapon_drills"
	equip_cooldown = 15
	energy_drain = 10
	force = 15
	construction_cost = list("metal"=10000)

	action(atom/target)
		if(!action_checks(target)) return
//		if(isobj(target))
//			var/obj/target_obj = target
//			if(!target_obj.vars.Find("unacidable") || target_obj.unacidable)	return
		set_ready_state(0)
		chassis.use_power(energy_drain)
		chassis.visible_message("<font color='red'><b>[chassis] powers it's drill!</b></font>", "You hear the drill.")
		occupant_message("<font color='red'><b>You start to drill!</b></font>")
		var/T = chassis.loc
		if(do_after_cooldown(target))
			if(T == chassis.loc && src == chassis.selected)
				var/turf/T1 = get_turf(get_step(chassis.get_active_part(1), chassis.dir))
				var/turf/T2 = get_turf(get_step(chassis.get_active_part(2), chassis.dir))
				if(!istype(T1, /turf/simulated/wall/r_wall))
					T1.ex_act(2)
				else
					occupant_message("<font color='red'>[T1] is too durable to drill through.</font>")
				if(!istype(T2, /turf/simulated/wall/r_wall))
					T2.ex_act(2)
				else
					occupant_message("<font color='red'>[T2] is too durable to drill through.</font>")
				for(var/atom/movable/A in T1.contents|T2.contents)
					if(isobj(A))
						var/obj/target_obj = A
						if(!target_obj.vars.Find("unacidable") || target_obj.unacidable)	continue
					log_message("Drilled through [A]")
					A.ex_act(3)
/*				if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/weapon/ore/ore in range(chassis,1))
							if(get_dir(chassis,ore)&chassis.dir)
								ore.Move(ore_box)*/

/*					if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
						var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
						if(ore_box)
							for(var/obj/item/weapon/ore/ore in range(chassis,1))
								if(get_dir(chassis,ore)&chassis.dir)
									ore.Move(ore_box)*/
		return 1

	can_attach(obj/spacepod/SP as obj)
		if(..())
			if(istype(SP, /obj/spacepod/industrial))
				return 1
		return 0