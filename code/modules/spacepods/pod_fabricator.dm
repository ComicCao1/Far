/////////////////////////////
///// Part Fabricator ///////
/////////////////////////////

/obj/machinery/mecha_part_fabricator/pod
	name = "Spacepod Fabricator"
	desc = "Used for producing all the spacepod goodies."
	icon = 'icons/obj/robotics.dmi'
	req_access = list(10)
//	build_number = 32
//	nano_file = "podfab.tmpl"
	part_sets = list( //set names must be unique
	"Spacepod Frame" = list(
						/obj/item/pod_parts/pod_frame/fore_port,
						/obj/item/pod_parts/pod_frame/fore_starboard,
						/obj/item/pod_parts/pod_frame/aft_port,
						/obj/item/pod_parts/pod_frame/aft_starboard
						),
	"Spacepod Armor" = list(
						/obj/item/pod_parts/armor,
						),
	"Spacepod Parts" = list(),
	"Spacepod Weaponry" = list(),
	"Spacepod Tools" = list()
	)

//	research_flags = NANOTOUCH | HASOUTPUT | HASMAT_OVER | TAKESMATIN | ACCESS_EMAG | LOCKBOXES


/obj/machinery/mecha_part_fabricator/pod/New()
	. = ..()

	component_parts = newlist(
		/obj/item/weapon/circuitboard/podfab,
		/obj/item/weapon/stock_parts/matter_bin,
		/obj/item/weapon/stock_parts/matter_bin,
		/obj/item/weapon/stock_parts/matter_bin,
		/obj/item/weapon/stock_parts/manipulator,
		/obj/item/weapon/stock_parts/manipulator,
		/obj/item/weapon/stock_parts/micro_laser,
		/obj/item/weapon/stock_parts/micro_laser
	)

	RefreshParts()


/obj/machinery/mecha_part_fabricator/pod/convert_designs()
	if(!files) return
	var/i = 0
	for(var/datum/design/D in files.known_designs)
		if(D.build_type & 32)		//PODFAB
			if(D.category in part_sets)//Checks if it's a valid category
				if(add_part_to_set(D.category, D.build_path))//Adds it to said category
					i++
			else
				if(add_part_to_set("Misc", D.build_path))//If in doubt, chunk it into the Misc
					i++
	return i
