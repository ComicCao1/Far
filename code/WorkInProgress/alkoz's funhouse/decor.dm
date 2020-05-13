/obj/structure/statue
	name = "statue"
	desc = "A statue is well-designed image of a remarkably generic person. A plaque on the postment is blank."
	icon = 'icons/obj/statue.dmi'
	anchored = 1
	density = 1

	New()
		var/mob/P
		var/datum/mind/character
		var/action

		while (player_list.len == 0)
			sleep(100)
		P = pick(player_list)
		character = P.mind
		if(prob(50))
			var/list/possible_objects = list()
			for(var/obj_type in typesof(/obj))
				if(istype(obj_type, /obj/machinery) || istype(obj_type, /obj/item) || istype(obj_type, /obj/structure))
					possible_objects += obj_type
				else
			var/object = pick(possible_objects)
			action = pick("surrounded by", "commiting dissalute act with", "sitting on", "licking", "consuming", "adoring", "disassembling", "attacked by", "avoiding", "decorating", "studying", "vandalizing")
			desc = "A statue is well-designed image of [character.name], [character.assigned_role] and [object]. [character.name] is [action] [object]."
		else
			action = pick("smiling", "shivering in terror", "waving hand", "standing at attention", "meditating", "praying", "laughing", "smoking", "sitting on postment", "saluting", "crying", "masturbating", "committing suicide")
			desc = "A statue is well-designed image of [character.name], [character.assigned_role]. [character.name] is [action]."

		var/state = pick("terrified", "happy", "thoughtful", "sad", "content", "unhappy", "astonished", "shocked", "calm", "aroused", "disgusted")
		desc += " [character.name] looks [state]."



