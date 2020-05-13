/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage = 0
	damage_type = BURN
	flag = "energy"


/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	nodamage = 1

	stun = 10
	weaken = 10
	stutter = 10

// Если кто ещё вздумает "пофиксить" тазер то лучше сразу врежте себе по яйцам и вырежте печень.

//	agony = 65
//	damage_type = HALLOSS
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/laser
	name = "laser bolt"
	icon_state =  "laser2"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 40
	damage_type = BURN

	process()
		SetLuminosity(2,0,0)
		..()



/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	nodamage = 1
	damage_type = CLONE
	irradiate = 40


/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 15
	damage_type = TOX
	weaken = 7


/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 20
	damage_type = TOX
	nodamage = 0
	weaken = 10
	stutter = 10


/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage = 40


/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage = 10
	damage_type = TOX
	weaken = 5



