/obj/item/device/spacepod_equipment/weapon
	name = "spacepod weapon"
	range = RANGED
	origin_tech = "materials=3;combat=3"
	var/projectile //Type of projectile fired.
	var/projectiles = 1 //Amount of projectiles loaded.
	var/projectiles_per_shot = 1 //Amount of projectiles fired per single shot.
	var/fire_cooldown = 0 //Duration of sleep between firing projectiles in single shot.
	var/fire_sound //Sound played while firing.
	var/fire_volume = 50 //How loud it is played.
	var/auto_rearm = 0 //Does the weapon reload itself after each shot?

/obj/item/device/spacepod_equipment/weapon/action_checks(atom/target)
	if(projectiles <= 0)
		return 0
	return ..()

/obj/item/device/spacepod_equipment/weapon/action(atom/target)
	if(!action_checks(target))
		return
	var/turf/curloc = chassis.loc
	var/turf/targloc = get_turf(target)
	if(!curloc || !targloc)
		return
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='warning'>[chassis] fires [src]!</span>")
	occupant_message("<span class='warning'>You fire [src]!</span>")
	log_message("Fired from [src], targeting [target].")
	for(var/i = 1 to min(projectiles, projectiles_per_shot))
		playsound(chassis, fire_sound, fire_volume, 1)
		projectiles--
		var/P1 = new projectile(chassis.get_active_part(1))
		var/P2 = new projectile(chassis.get_active_part(2))
		Fire(P1, P2)
		if(fire_cooldown)
			sleep(fire_cooldown)
	if(auto_rearm)
		projectiles = projectiles_per_shot
	set_ready_state(0)
	do_after_cooldown()
	return

/obj/item/device/spacepod_equipment/weapon/proc/Fire(atom/A1, atom/A2)
	var/obj/item/projectile/P1 = A1
	var/obj/item/projectile/P2 = A2
	P1.shot_from = src
	P1.starting = P1.loc
	P1.firer = chassis.occupant
	P2.shot_from = src
	P2.starting = P2.loc
	P2.firer = chassis.occupant
	P1.dumbfire(chassis.dir)
	P2.dumbfire(chassis.dir)

/obj/item/device/spacepod_equipment/weapon/energy
	name = "General Energy Weapon"
	auto_rearm = 1

/obj/item/device/spacepod_equipment/weapon/energy/taser
	name = "Spacepod Mounted Taser"
	icon_state = "pod_taser"
	overlay_icon = "pod_weapon_taser"
	energy_drain = 20
	equip_cooldown = 8
	projectile = /obj/item/projectile/energy/electrode
	fire_sound = 'sound/weapons/Taser.ogg'
	construction_cost = list("metal"=10000)


/obj/item/device/spacepod_equipment/weapon/energy/laser
	equip_cooldown = 8
	name = "Spacepod Mounted Laser"
	icon_state = "pod_w_laser"
	overlay_icon = "pod_weapon_laser"
	energy_drain = 30
	projectile = /obj/item/projectile/energy/laser
	fire_sound = 'sound/weapons/Laser.ogg'
	construction_cost = list("metal"=8000, "glass"=3000)
