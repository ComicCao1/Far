/datum/design/pod/drill
	name = "Spacepod Module Design (Mining Drill)"
	desc = "A very powerful drill, designed to be ounted onto spacepods."
	id = "spacepod_drill"
	build_type = PODFAB
	req_tech = list("materials" = 4, "engineering" = 3)
	build_path = /obj/item/device/spacepod_equipment/tool/drill
	category = "Spacepod Tools"

/datum/design/pod/laser
	name = "Spacepod Module Design (Mounted Laser)"
	desc = "Allows for the construction of Spacepod-mounted Laser Gun."
	id = "pod_laser"
	build_type = PODFAB
	req_tech = list("combat" = 3, "magnets" = 3)
	build_path = /obj/item/device/spacepod_equipment/weapon/energy/laser
	category = "Spacepod Weaponry"

/datum/design/pod/taser
	name = "Spacepod Module Design (Mounted Taser)"
	desc = "Allows for the construction of Spacepod-mounted Taser Gun."
	id = "pod_taser"
	build_type = PODFAB
	req_tech = list("combat" = 2, "magnets" = 3)
	build_path = /obj/item/device/spacepod_equipment/weapon/energy/taser
	category = "Spacepod Weaponry"

/datum/design/pod/core
	name = "Space Pod Core Design"
	desc = "A spacepod core, the basic part of the whole construction."
	id = "pod_core"
	build_type = PODFAB
	req_tech = list("materials" = 4, "plasmatech" = 3, "bluespace" = 2, "engineering" = 3)
	build_path = /obj/item/pod_parts/core
	category = "Spacepod Parts"

/datum/design/pod/armor/ind
	name = "Industrial Space Pod Armor Design"
	desc = "Industrial Pod Armor, a part, which allows to build industrial spacepods."
	id = "spacepod_ind_armor"
	build_type = PODFAB
	req_tech = list("materials" = 4, "engineering" = 3)
	build_path = /obj/item/pod_parts/armor/mining
	category = "Spacepod Armor"