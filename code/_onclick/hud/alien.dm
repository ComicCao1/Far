/datum/hud/proc/alien_hud()

	src.adding = list(  )
	src.other = list(  )

	var/obj/screen/using
	var/obj/screen/inventory/inv_box

	using = new /obj/screen()
	using.name = "act_intent"
	using.dir = SOUTHWEST
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.icon_state = (mymob.a_intent == "hurt" ? "harm" : mymob.a_intent)
	using.screen_loc = ui_acti
	using.layer = 20
	src.adding += using
	action_intent = using

//ACCount's Intents Panel Beginning

	using = new /obj/screen()
	using.name = "help"
	using.icon_state = "help_m"
	using.screen_loc = ui_iarrowleft
	using.layer = 21
	adding += using

	using = new /obj/screen()
	using.name = "grab"
	using.icon_state = "grab_m"
	using.screen_loc = ui_iarrowleft
	using.layer = 21
	adding += using


	using = new /obj/screen()
	using.name = "disarm"
	using.icon_state = "disarm_m"
	using.screen_loc = ui_iarrowright
	using.layer = 21
	adding += using

	using = new /obj/screen()
	using.name = "harm"
	using.icon_state = "harm_m"
	using.screen_loc = ui_iarrowright
	using.layer = 21
	adding += using

//ACCount's Intents Panel End


	using = new /obj/screen() //Right hud bar
	using.dir = SOUTH
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.screen_loc = "EAST+1,SOUTH to EAST+1,NORTH"
	using.layer = 18
	adding += using

	using = new /obj/screen() //Lower hud bar
	using.dir = EAST
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.screen_loc = "WEST,SOUTH-1 to EAST,SOUTH-1"
	using.layer = 18
	adding += using

	using = new /obj/screen() //Corner Button
	using.dir = NORTHWEST
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.screen_loc = "EAST+1,SOUTH-1"
	using.layer = 18
	adding += using

	using = new /obj/screen()
	using.name = "act_intent"
	using.dir = SOUTHWEST
	using.icon_state = mymob.a_intent
	using.screen_loc = ui_acti
	using.layer = 20
	adding += using
	src.action_intent = using

	using = new /obj/screen()
	using.name = "mov_intent"
	using.dir = SOUTHWEST
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
	using.screen_loc = ui_movi
	using.layer = 20
	src.adding += using
	move_intent = using

	using = new /obj/screen()
	using.name = "drop"
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.icon_state = "act_drop"
	using.screen_loc = ui_dropbutton
	using.layer = 19
	src.adding += using

//equippable shit
	//suit
	inv_box = new /obj/screen/inventory()
	inv_box.name = "o_clothing"
	inv_box.dir = SOUTH
	inv_box.icon = 'icons/mob/screen1_alien.dmi'
	inv_box.icon_state = "equip"
	inv_box.screen_loc = ui_iclothing
	inv_box.slot_id = slot_wear_suit
	inv_box.layer = 19
	src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "r_hand"
	inv_box.dir = WEST
	inv_box.icon = 'icons/mob/screen1_alien.dmi'
	inv_box.icon_state = "hand_inactive"
	if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = ui_id
	inv_box.layer = 19
	src.r_hand_hud_object = inv_box
	inv_box.slot_id = slot_r_hand
	src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "l_hand"
	inv_box.dir = EAST
	inv_box.icon = 'icons/mob/screen1_alien.dmi'
	inv_box.icon_state = "hand_inactive"
	if(mymob && mymob.hand)	//This being 1 means the left hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = ui_belt
	inv_box.layer = 19
	inv_box.slot_id = slot_l_hand
	src.l_hand_hud_object = inv_box
	src.adding += inv_box

	using = new /obj/screen/inventory()
	using.name = "hand"
	using.dir = NORTH
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.icon_state = "hand"
	using.screen_loc = ui_swaphand
	using.layer = 19
	src.swaphands_hud_object = using
	src.adding += using

	//pocket 1
	inv_box = new /obj/screen/inventory()
	inv_box.name = "storage1"
	inv_box.icon = 'icons/mob/screen1_alien.dmi'
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = ui_storage1
	inv_box.slot_id = slot_l_store
	inv_box.layer = 19
	src.adding += inv_box

	//pocket 2
	inv_box = new /obj/screen/inventory()
	inv_box.name = "storage2"
	inv_box.icon = 'icons/mob/screen1_alien.dmi'
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = ui_storage2
	inv_box.slot_id = slot_r_store
	inv_box.layer = 19
	src.adding += inv_box

	//head
	inv_box = new /obj/screen/inventory()
	inv_box.name = "head"
	inv_box.icon = 'icons/mob/screen1_alien.dmi'
	inv_box.icon_state = "hair"
	inv_box.screen_loc = ui_oclothing
	inv_box.slot_id = slot_head
	inv_box.layer = 19
	src.adding += inv_box
//end of equippable shit


	using = new /obj/screen()
	using.name = "resist"
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.icon_state = "act_resist"
	using.screen_loc = ui_resist
	using.layer = 19
	src.adding += using


	mymob.throw_icon = new /obj/screen()
	mymob.throw_icon.icon = 'icons/mob/screen1_alien.dmi'
	mymob.throw_icon.icon_state = "act_throw_off"
	mymob.throw_icon.name = "throw"
	mymob.throw_icon.screen_loc = ui_drop_throw

	mymob.oxygen = new /obj/screen()
	mymob.oxygen.icon = 'icons/mob/screen1_alien.dmi'
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = ui_oxygen

	mymob.toxin = new /obj/screen()
	mymob.toxin.icon = 'icons/mob/screen1_alien.dmi'
	mymob.toxin.icon_state = "tox0"
	mymob.toxin.name = "toxin"
	mymob.toxin.screen_loc = ui_toxin

	mymob.fire = new /obj/screen()
	mymob.fire.icon = 'icons/mob/screen1_alien.dmi'
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_fire

	mymob.healths = new /obj/screen()
	mymob.healths.icon = 'icons/mob/screen1_alien.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_health

	mymob.pullin = new /obj/screen()
	mymob.pullin.icon = 'icons/mob/screen1_alien.dmi'
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = ui_pull

	mymob.blind = new /obj/screen()
	mymob.blind.icon = 'icons/mob/screen1_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.layer = 0

	mymob.flash = new /obj/screen()
	mymob.flash.icon = 'icons/mob/screen1_alien.dmi'
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.layer = 17

	mymob.zone_sel = new /obj/screen/zone_sel()
	mymob.zone_sel.icon = 'icons/mob/screen1_alien.dmi'
	mymob.zone_sel.overlays.Cut()
	mymob.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]")

	mymob.client.screen = null

	mymob.client.screen += list( mymob.throw_icon, mymob.zone_sel, mymob.oxygen, mymob.toxin, mymob.fire, mymob.healths, mymob.pullin, mymob.blind, mymob.flash) //, mymob.hands, mymob.rest, mymob.sleep, mymob.mach )
	mymob.client.screen += src.adding + src.other