mob/var/zombieleader = 0
mob/var/zombieimmune = 0
var/list/datum/zombies = list()

/mob/living/carbon/human/proc/zombify()
	stat &= 1
	oxyloss = 0
	becoming_zombie = 0
	bodytemperature = 310.055
	see_in_dark = 4
	set_species("Zombie")
	sight |= SEE_MOBS
	update_icons()
	src.verbs += /mob/living/carbon/human/proc/supersuicide
//	if(zombieleader)
//		src.verbs -= /mob/living/carbon/proc/zombierelease
	src << "\red<font size=3> You have become a zombie!"
	for(var/mob/O in viewers(src, null))
		O.show_message(text("\red <B>[src] seizes up and falls limp, \his eyes dead and lifeless...[src] is ZOMBIE! HARM CLAW! CLAW! CLAW!</B>"), 1)
//	if(ticker.mode.name == "Zombie Outbreak")
//		ticker.check_win()
	update_body()
	zombies.Add(src)


/mob/living/carbon/human/proc/unzombify()
	set_species("Human")
	see_in_dark = 2
	sight &= ~SEE_MOBS
	src.verbs -= /mob/living/carbon/human/proc/supersuicide
	update_icons()
	src << "\red<font size=3>You have been cured from being a zombie!"

/mob/living/carbon/human/proc/zombie_bit(var/mob/living/carbon/human/biter)
	var/mob/living/carbon/human/biten = src

	visible_message("\red <b>[biter.name] bites [name]!</b>")

	if(biten.species && biten.species.flags & IS_SYNTHETIC)
		return

	if(stat > 1)//dead: it takes time to reverse death, but there is no chance of failure
		sleep(50)
		zombify()
		return

	if((istype(biten.wear_suit, /obj/item/clothing/suit/bio_suit) || istype(biten.wear_suit, /obj/item/clothing/suit/space)) || (istype(biten.head, /obj/item/clothing/head/bio_hood) || istype(biten.head, /obj/item/clothing/head/space)))
		if((istype(biten.head, /obj/item/clothing/head/bio_hood) || istype(biten.head, /obj/item/clothing/head/space)) && (istype(biten.wear_suit, /obj/item/clothing/suit/bio_suit) || istype(biten.wear_suit, /obj/item/clothing/suit/space)))
			if(prob(70))
				visible_message("\red [biter.name]'s suit protects [biter.name] from the bite!")
				return
		else if(prob(50))
			visible_message("\red [biter.name]'s suit protects [biter.name] from the bite!")
			return
	if(zombieimmune)
		return
	zombie_infect()

/mob/living/carbon/human/proc/zombie_infect()
	var/datum/disease2/disease/D = new /datum/disease2/disease
	D.makezombie()
	D.infectionchance = 1
	virus2["[D.uniqueID]"] = D
	becoming_zombie = 1

/client/proc/admin_infect_zombie(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Infect Mob Zombie"

	if(!src.holder)
		src << "Only administrators may use this command."
		return

	log_admin("[key_name(usr)] infected [key_name(M)] with a zombie disease.")
	message_admins("[key_name_admin(usr)] infected [key_name_admin(M)] 	with a zombie disease.", 1)
	if(ishuman(M))
		var/mob/living/carbon/human/Z = M
		Z.zombie_infect()
	else
		usr << "\blue This mob is not a human!"


/mob/living/carbon/human/proc/traitor_infect()
	becoming_zombie = 1
	zombieleader = 1
	src.verbs += /mob/living/carbon/human/proc/zombierelease
	src << "You have been implanted with a chemical canister you can either release it yourself or wait until it activates."
	sleep(3000)
	if(becoming_zombie)
		zombify()

/mob/living/carbon/human/proc/supersuicide()
	set name = "Zombie suicide"
	set hidden = 0
	if(zombie == 1)
		switch(alert(usr,"Are you sure you wanna die?",,"Yes","No"))
			if("Yes")
				fireloss = 999
				src << "\red You died suprised?"
				return
			else
				src << "\red You live to see another day."
				return
	else
		src << "\red Only for zombies."

/mob/living/carbon/human/proc/zombierelease()
	set name = "Zombify"
	set desc = "Turns you into a zombie"
	if(zombieleader)
		zombify()

