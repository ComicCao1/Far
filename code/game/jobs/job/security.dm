/datum/job/hos
	title = "Head of Security"
	flag = HOS
	department_head = list("Captain")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffdddd"
	idtype = /obj/item/weapon/card/id/hos
	access = list(access_security, access_sec_doors, access_brig, access_armory, access_court,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_armory, access_court,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway)
	minimal_player_age = 14

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_sec(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hos(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_security(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hos(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
//		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), slot_wear_mask) //Grab one from the armory you donk
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), slot_glasses)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/gun(H), slot_s_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_l_store)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/device/flashlight/seclite(H), slot_in_backpack)
		var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		var/datum/organ/external/affected = H.organs_by_name["head"]
		affected.implants += L
		L.part = affected
		return 1



/datum/job/warden
	title = "Warden"
	flag = WARDEN
	department_head = list("Head of Security")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	idtype = /obj/item/weapon/card/id/sec
	access = list(access_security, access_sec_doors, access_brig, access_armory, access_court, access_maint_tunnels, access_morgue)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_armory, access_court, access_maint_tunnels)
	minimal_player_age = 5

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_sec(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/warden(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/warden(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(H), slot_glasses)
//		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(H), slot_wear_mask) //Grab one from the armory you donk
		H.equip_to_slot_or_del(new /obj/item/device/flash(H), slot_l_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_l_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/device/flashlight/seclite(H), slot_in_backpack)
		var/obj/item/weapon/implant/mentor/L = new/obj/item/weapon/implant/mentor(H)
		L.imp_in = H
		L.implanted = 1
		return 1



/datum/job/detective
	title = "Detective"
	flag = DETECTIVE
	department_head = list("Head of Security")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	idtype = /obj/item/weapon/card/id/det

	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court, access_morgue)
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court, access_morgue)
	minimal_player_age = 3
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/det(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/detective(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/det_suit(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/det_hat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/weapon/flame/lighter/zippo(H), slot_l_store)

		if(H.backbag == 1)//Why cant some of these things spawn in his office?
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/evidence(H), slot_l_hand)
			H.equip_to_slot_or_del(new /obj/item/device/detective_scanner(H), slot_r_store)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/evidence(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/device/detective_scanner(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/device/flashlight/seclite(H), slot_in_backpack)
		var/obj/item/weapon/implant/mentor/L = new/obj/item/weapon/implant/mentor(H)
		L.imp_in = H
		L.implanted = 1
		return 1

/datum/job/officer
	title = "Security Officer"
	flag = OFFICER
	department_head = list("Head of Security")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	idtype = /obj/item/weapon/card/id/sec
	access = list(access_security, access_sec_doors, access_brig, access_court, access_maint_tunnels, access_morgue)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_court, access_maint_tunnels)
	minimal_player_age = 3
	equip(var/mob/living/carbon/human/H)
		if(!H)
			return 0
		..()
		assign_sec_to_department(H)
		switch(H.backbag)
			if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/security(H), slot_back)
			if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_sec(H), slot_back)
			if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
	//	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/security(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_s_store)
		H.equip_to_slot_or_del(new /obj/item/device/flash(H), slot_l_store)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_l_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_in_backpack)
			H.equip_to_slot_or_del(new /obj/item/device/flashlight/seclite(H), slot_in_backpack)
		var/obj/item/weapon/implant/mentor/L = new/obj/item/weapon/implant/mentor(H)
		L.imp_in = H
		L.implanted = 1
		return 1

var/list/sec_departments = list("engineering", "supply", "medical", "science")

/datum/job/officer/proc/assign_sec_to_department(var/mob/living/carbon/human/H as mob)
	if(sec_departments.len)
		var/department = pick(sec_departments)
		sec_departments -= department
		switch(department)
			if("supply")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/alternative/cargo(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec/department/supply(H), slot_l_ear)
				minimal_access += list(access_mailsorting, access_mining)
			if("engineering")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/alternative/engine(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec/department/engi(H), slot_l_ear)
				minimal_access += list(access_construction, access_engine)
			if("medical")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/alternative/med(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec/department/med(H), slot_l_ear)
				minimal_access += list(access_medical)
			if("science")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/alternative/science(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec/department/sci(H), slot_l_ear)
				minimal_access += list(access_research, access_tox)
			else
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security/alternative(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)

/obj/item/device/radio/headset/headset_sec/department/New()
	if(radio_controller)
		initialize()
	recalculateChannels()

/obj/item/device/radio/headset/headset_sec/department/engi
	keyslot1 = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_eng

/obj/item/device/radio/headset/headset_sec/department/supply
	keyslot1 = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_cargo

/obj/item/device/radio/headset/headset_sec/department/med
	keyslot1 = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_med

/obj/item/device/radio/headset/headset_sec/department/sci
	keyslot1 = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_sci

/obj/item/clothing/under/rank/security/alternative/cargo/New()
	attachTie(new /obj/item/clothing/tie/armband/cargo)

/obj/item/clothing/under/rank/security/alternative/engine/New()
	attachTie(new /obj/item/clothing/tie/armband/engine)

/obj/item/clothing/under/rank/security/alternative/science/New()
	attachTie(new /obj/item/clothing/tie/armband/science)

/obj/item/clothing/under/rank/security/alternative/med/New()
	attachTie(new /obj/item/clothing/tie/armband/med)