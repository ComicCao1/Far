/*
	The global hud:
	Uses the same visual objects for all players.
*/
var/datum/global_hud/global_hud = new()

/datum/hud/var/obj/screen/grab_intent
/datum/hud/var/obj/screen/hurt_intent
/datum/hud/var/obj/screen/disarm_intent
/datum/hud/var/obj/screen/help_intent

/datum/global_hud
	var/obj/screen/druggy
	var/obj/screen/blurry
	var/list/vimpaired
	var/list/darkMask
	//Mask d_filters
	var/obj/screen/g_dither = null
	var/obj/screen/r_dither = null
	var/obj/screen/gray_dither = null
	var/obj/screen/lp_dither = null


/datum/global_hud/New()
	//420erryday psychedellic colours screen overlay for when you are high
	druggy = new /obj/screen()
	druggy.screen_loc = "WEST,SOUTH to EAST,NORTH"
	druggy.icon_state = "druggy"
	druggy.layer = 17
	druggy.mouse_opacity = 0

	//that white blurry effect you get when you eyes are damaged
	blurry = new /obj/screen()
	blurry.screen_loc = "WEST,SOUTH to EAST,NORTH"
	blurry.icon_state = "blurry"
	blurry.layer = 17
	blurry.mouse_opacity = 0

	//Green d_filter for the gasmask
	g_dither = new /obj/screen()
	g_dither.screen_loc = "WEST,SOUTH to EAST,NORTH"
	g_dither.name = "gasmask"
	g_dither.icon_state = "dither12g"
	g_dither.layer = 17
	g_dither.mouse_opacity = 0

	//Red d_filter for the thermal glasses
	r_dither = new /obj/screen()
	r_dither.screen_loc = "WEST,SOUTH to EAST,NORTH"
	r_dither.name = "thermal glasses"
	r_dither.icon_state = "ditherred"
	r_dither.layer = 17
	r_dither.mouse_opacity = 0

	//Gray d_filter for the sunglasses
	gray_dither = new /obj/screen()
	gray_dither.screen_loc = "WEST,SOUTH to EAST,NORTH"
	gray_dither.name = "sunglasses"
	gray_dither.icon_state = "dark32"
	gray_dither.layer = 17
	gray_dither.mouse_opacity = 0

	//Yellow d_filter for the mesons
	lp_dither = new /obj/screen()
	lp_dither.screen_loc = "WEST,SOUTH to EAST,NORTH"
	lp_dither.name = "mesons"
	lp_dither.icon_state = "ditherlimepulse"
	lp_dither.layer = 17
	lp_dither.mouse_opacity = 0


	var/obj/screen/O
	var/i
	//that nasty looking dither you  get when you're short-sighted
	vimpaired = newlist(/obj/screen,/obj/screen,/obj/screen,/obj/screen)
	O = vimpaired[1]
	O.screen_loc = "1,1 to 5,15"
	O = vimpaired[2]
	O.screen_loc = "5,1 to 10,5"
	O = vimpaired[3]
	O.screen_loc = "6,11 to 10,15"
	O = vimpaired[4]
	O.screen_loc = "11,1 to 15,15"

	//welding mask overlay black/dither
	darkMask = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = darkMask[1]
	O.screen_loc = "3,3 to 5,13"
	O = darkMask[2]
	O.screen_loc = "5,3 to 10,5"
	O = darkMask[3]
	O.screen_loc = "6,11 to 10,13"
	O = darkMask[4]
	O.screen_loc = "11,3 to 13,13"
	O = darkMask[5]
	O.screen_loc = "1,1 to 15,2"
	O = darkMask[6]
	O.screen_loc = "1,3 to 2,15"
	O = darkMask[7]
	O.screen_loc = "14,3 to 15,15"
	O = darkMask[8]
	O.screen_loc = "3,14 to 13,15"

	for(i = 1, i <= 4, i++)
		O = vimpaired[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

		O = darkMask[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = 0

	for(i = 5, i <= 8, i++)
		O = darkMask[i]
		O.icon_state = "black"
		O.layer = 17
		O.mouse_opacity = 0

/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/datum/hud
	var/mob/mymob

	var/hud_shown = 1			//Used for the HUD toggle (F12)
	var/inventory_shown = 1		//the inventory
	var/show_intent_icons = 0
	var/hotkey_ui_hidden = 0	//This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/obj/screen/lingchemdisplay
	var/obj/screen/blobpwrdisplay
	var/obj/screen/blobhealthdisplay
	var/obj/screen/r_hand_hud_object
	var/obj/screen/l_hand_hud_object
	var/obj/screen/swaphands_hud_object
	var/obj/screen/action_intent
	var/obj/screen/move_intent
	var/obj/screen/att_intent
	var/obj/screen/rest_hud_object


	var/list/adding
	var/list/other
	var/list/obj/screen/hotkeybuttons

	var/list/obj/screen/item_action/item_action_list = list()	//Used for the item action ui buttons.


datum/hud/New(mob/owner)
	mymob = owner
	instantiate()
	..()


/datum/hud/proc/hidden_inventory_update()
	if(!mymob) return
	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob

		if(mymob.client && mymob.client.prefs.UI_type == "TG")
			if(inventory_shown && hud_shown)
				if(H.shoes)		H.shoes.screen_loc = ui_tg_shoes
				if(H.gloves)	H.gloves.screen_loc = ui_tg_gloves
				if(H.l_ear)		H.l_ear.screen_loc = ui_tg_l_ear
				if(H.r_ear)		H.r_ear.screen_loc = ui_tg_r_ear
				if(H.glasses)	H.glasses.screen_loc = ui_tg_glasses
				if(H.w_uniform)	H.w_uniform.screen_loc = ui_tg_iclothing
				if(H.wear_suit)	H.wear_suit.screen_loc = ui_tg_oclothing
				if(H.wear_mask)	H.wear_mask.screen_loc = ui_tg_mask
				if(H.head)		H.head.screen_loc = ui_tg_head
			else
				if(H.shoes)		H.shoes.screen_loc = null
				if(H.gloves)	H.gloves.screen_loc = null
				if(H.l_ear)		H.l_ear.screen_loc = null
				if(H.r_ear)		H.r_ear.screen_loc = null
				if(H.glasses)	H.glasses.screen_loc = null
				if(H.w_uniform)	H.w_uniform.screen_loc = null
				if(H.wear_suit)	H.wear_suit.screen_loc = null
				if(H.wear_mask)	H.wear_mask.screen_loc = null
				if(H.head)		H.head.screen_loc = null
		else
			if(inventory_shown && hud_shown)
				if(H.s_store)	H.s_store.screen_loc = ui_sstore1
				if(H.shoes)		H.shoes.screen_loc = ui_shoes
				if(H.gloves)	H.gloves.screen_loc = ui_gloves
				if(H.l_ear)		H.l_ear.screen_loc = ui_l_ear
				if(H.r_ear)		H.r_ear.screen_loc = ui_r_ear
				if(H.glasses)	H.glasses.screen_loc = ui_glasses
			else
				if(H.s_store)	H.s_store.screen_loc = null
				if(H.shoes)		H.shoes.screen_loc = null
				if(H.gloves)	H.gloves.screen_loc = null
				if(H.l_ear)		H.l_ear.screen_loc = null
				if(H.r_ear)		H.r_ear.screen_loc = null
				if(H.glasses)	H.glasses.screen_loc = null

/datum/hud/proc/persistant_inventory_update()
	if(!mymob)
		return

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		if(mymob.client && mymob.client.prefs.UI_type == "TG")
			if(hud_shown)
				if(H.s_store)	H.s_store.screen_loc = ui_tg_sstore1
				if(H.wear_id)	H.wear_id.screen_loc = ui_tg_id
				if(H.belt)		H.belt.screen_loc = ui_tg_belt
				if(H.back)		H.back.screen_loc = ui_tg_back
				if(H.l_store)	H.l_store.screen_loc = ui_tg_storage1
				if(H.r_store)	H.r_store.screen_loc = ui_tg_storage2
			else
				if(H.s_store)	H.s_store.screen_loc = null
				if(H.wear_id)	H.wear_id.screen_loc = null
				if(H.belt)		H.belt.screen_loc = null
				if(H.back)		H.back.screen_loc = null
				if(H.l_store)	H.l_store.screen_loc = null
				if(H.r_store)	H.r_store.screen_loc = null
		else
			if(hud_shown)
				if(H.wear_id)	H.wear_id.screen_loc = ui_id
				if(H.belt)		H.belt.screen_loc = ui_belt
				if(H.back)		H.back.screen_loc = ui_back
				if(H.l_store)	H.l_store.screen_loc = ui_storage1
				if(H.r_store)	H.r_store.screen_loc = ui_storage2
				if(H.w_uniform)	H.w_uniform.screen_loc = ui_iclothing
				if(H.wear_suit)	H.wear_suit.screen_loc = ui_oclothing
				if(H.wear_mask)	H.wear_mask.screen_loc = ui_mask
				if(H.head)		H.head.screen_loc = ui_head
			else
				if(H.wear_id)	H.wear_id.screen_loc = null
				if(H.belt)		H.belt.screen_loc = null
				if(H.back)		H.back.screen_loc = null
				if(H.l_store)	H.l_store.screen_loc = null
				if(H.r_store)	H.r_store.screen_loc = null
				if(H.w_uniform)	H.w_uniform.screen_loc = null
				if(H.wear_suit)	H.wear_suit.screen_loc = null
				if(H.wear_mask)	H.wear_mask.screen_loc = null
				if(H.head)		H.head.screen_loc = null



/datum/hud/proc/instantiate()
	if(!ismob(mymob)) return 0
	if(!mymob.client) return 0
	var/ui_style = ui_style2icon(mymob.client.prefs.UI_style)
	var/ui_color = mymob.client.prefs.UI_style_color
	var/ui_alpha = mymob.client.prefs.UI_style_alpha
	var/ui_type = mymob.client.prefs.UI_type

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		if(H.species in xeno_species)
			alien_hud()
		if(ui_type == "Luna")
			human_hud_luna(ui_style, ui_color, ui_alpha) // Pass the player the UI style chosen in preferences
		else if(ui_type == "TG")
			human_hud_tg(ui_style, ui_color, ui_alpha)
		else
			human_hud_luna(ui_style, ui_color, ui_alpha)
	else if(ismonkey(mymob))
		monkey_hud(ui_style)
	else if(isbrain(mymob))
		brain_hud(ui_style)
	else if(islarva(mymob))
		larva_hud()
	else if(isalien(mymob))
		alien_hud()
	else if(isAI(mymob))
		ai_hud()
	else if(isrobot(mymob))
		robot_hud()
	else if(isobserver(mymob))
		ghost_hud()

/datum/hud/proc/get_slot_loc(var/slot)
	if(mymob.client && mymob.client.prefs.UI_type == "TG")
		switch(slot)
			if("mask") return ui_tg_mask
			if("oclothing") return ui_tg_oclothing
			if("iclothing") return ui_tg_iclothing

			if("sstore1") return ui_tg_sstore1
			if("id") return ui_tg_id
			if("belt") return ui_tg_belt
			if("back") return ui_tg_back

			if("rhand") return ui_tg_rhand
			if("lhand") return ui_tg_lhand

			if("storage1") return ui_tg_storage1
			if("storage2") return ui_tg_storage2

			if("shoes") return ui_tg_shoes
			if("head") return ui_tg_head
			if("gloves") return ui_tg_gloves
			if("r_ear") return ui_tg_r_ear
			if("l_ear") return ui_tg_l_ear
			if("glasses") return ui_tg_glasses

			if("acti") return ui_tg_acti

	else
		switch(slot)
			if("mask") return ui_mask
			if("oclothing") return ui_oclothing
			if("iclothing") return ui_iclothing

			if("sstore1") return ui_sstore1
			if("id") return ui_id
			if("belt") return ui_belt
			if("back") return ui_back

			if("rhand") return ui_rhand
			if("lhand") return ui_lhand

			if("storage1") return ui_storage1
			if("storage2") return ui_storage2

			if("shoes") return ui_shoes
			if("head") return ui_head
			if("gloves") return ui_gloves
			if("r_ear") return ui_r_ear
			if("l_ear") return ui_l_ear
			if("glasses") return ui_glasses

			if("acti") return ui_acti

/mob/living/carbon/human/proc/get_slot_loc(var/slot)
	if(src.client && src.client.prefs.UI_type == "Luna")
		switch(slot)
			if("mask") return ui_mask
			if("oclothing") return ui_oclothing
			if("iclothing") return ui_iclothing

			if("sstore1") return ui_sstore1
			if("id") return ui_id
			if("belt") return ui_belt
			if("back") return ui_back

			if("rhand") return ui_rhand
			if("lhand") return ui_lhand

			if("storage1") return ui_storage1
			if("storage2") return ui_storage2

			if("shoes") return ui_shoes
			if("head") return ui_head
			if("gloves") return ui_gloves
			if("r_ear") return ui_r_ear
			if("l_ear") return ui_l_ear
			if("glasses") return ui_glasses

			if("acti") return ui_acti
	else
		switch(slot)
			if("mask") return ui_tg_mask
			if("oclothing") return ui_tg_oclothing
			if("iclothing") return ui_tg_iclothing

			if("sstore1") return ui_tg_sstore1
			if("id") return ui_tg_id
			if("belt") return ui_tg_belt
			if("back") return ui_tg_back

			if("rhand") return ui_tg_rhand
			if("lhand") return ui_tg_lhand

			if("storage1") return ui_tg_storage1
			if("storage2") return ui_tg_storage2

			if("shoes") return ui_tg_shoes
			if("head") return ui_tg_head
			if("gloves") return ui_tg_gloves
			if("r_ear") return ui_tg_r_ear
			if("l_ear") return ui_tg_l_ear
			if("glasses") return ui_tg_glasses

			if("acti") return ui_tg_acti



//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12(var/full = 0 as null)
	set name = "F12"
	set hidden = 1
	return

	/*
	if(hud_used)
		if(ishuman(src))
			if(!client) return
			if(client.view != world.view)
				return
			if(hud_used.hud_shown)
				hud_used.hud_shown = 0
				if(src.hud_used.adding)
					src.client.screen -= src.hud_used.adding
				if(src.hud_used.other)
					src.client.screen -= src.hud_used.other
				if(src.hud_used.hotkeybuttons)
					src.client.screen -= src.hud_used.hotkeybuttons
				if(src.hud_used.item_action_list)
					src.client.screen -= src.hud_used.item_action_list

				//Due to some poor coding some things need special treatment:
				//These ones are a part of 'adding', 'other' or 'hotkeybuttons' but we want them to stay
				if(!full)
					src.client.screen += src.hud_used.l_hand_hud_object	//we want the hands to be visible
					src.client.screen += src.hud_used.r_hand_hud_object	//we want the hands to be visible
					src.client.screen += src.hud_used.action_intent		//we want the intent swticher visible
					src.hud_used.action_intent.screen_loc = ui_acti_alt	//move this to the alternative position, where zone_select usually is.
				else
					src.client.screen -= src.healths
					src.client.screen -= src.internals
					src.client.screen -= src.gun_setting_icon

				//These ones are not a part of 'adding', 'other' or 'hotkeybuttons' but we want them gone.
				src.client.screen -= src.zone_sel	//zone_sel is a mob variable for some reason.

			else
				hud_used.hud_shown = 1
				if(src.hud_used.adding)
					src.client.screen += src.hud_used.adding
				if(src.hud_used.other && src.hud_used.inventory_shown)
					src.client.screen += src.hud_used.other
				if(src.hud_used.hotkeybuttons && !src.hud_used.hotkey_ui_hidden)
					src.client.screen += src.hud_used.hotkeybuttons
				if(src.healths)
					src.client.screen |= src.healths
				if(src.internals)
					src.client.screen |= src.internals
				if(src.gun_setting_icon)
					src.client.screen |= src.gun_setting_icon

				src.hud_used.action_intent.screen_loc = ui_acti //Restore intent selection to the original position
				src.client.screen += src.zone_sel				//This one is a special snowflake

			hud_used.hidden_inventory_update()
			hud_used.persistant_inventory_update()
			update_action_buttons()
		else
			usr << "\red Inventory hiding is currently only supported for human mobs, sorry."
	else
		usr << "\red This mob type does not use a HUD."
*/