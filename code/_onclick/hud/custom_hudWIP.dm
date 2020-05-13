/datum/hud_special
	var/datum/hud/myhud
	var/list/locations = list()
	var/list/hideable = list()

	New(var/datum/hud/owner)
		myhud = owner

	proc/hidden_inventory_update()
		return 0

	proc/persistant_inventory_update()
		return 0


/proc/get_special_uistyle(ui_style)
	if(ui_style in list("Inferno", "Cooldown"))
		return /datum/hud_special/inferno

/datum/hud_special/inferno
	locations = list(
	"inventory" = "SOUTH,WEST+2",

	"mask" = "SOUTH-1,WEST",
	"oclothing" = "SOUTH-1,WEST+1",
	"iclothing" = "SOUTH-1,WEST+2",

	"sstore1" = "SOUTH-1,WEST+3",
	"id" = "SOUTH-1,WEST+4",
	"belt" = "SOUTH-1,WEST+5",
	"back" = "SOUTH-1,WEST+6",

	"rhand" = "SOUTH-1,CENTER",
	"lhand" = "SOUTH-1,CENTER+1",
	"equip" = "SOUTH,CENTER",
	"swaphand1" = "SOUTH,CENTER",
	"swaphand2" = "SOUTH,CENTER+1",

	"storage1" = "SOUTH-1,EAST-5",
	"storage2" = "SOUTH-1,EAST-4",

	"throw" = "SOUTH,EAST",
	"resist" = "SOUTH,EAST-1",
	"acti" = "SOUTH-1,EAST-1",
	"movi" = "SOUTH-1,EAST-2",
	"zonesel" = "SOUTH-1,EAST",

	"inventory2" = "SOUTH+1,WEST+2",
	"shoes" = "SOUTH,WEST",
	"head" = "SOUTH,WEST+1",
	"gloves" = "SOUTH,WEST+2",
	"ears" = "SOUTH,WEST+3",
	"glasses" = "SOUTH,WEST+4",

	"filler" = "SOUTH-1,WEST to SOUTH-1,EAST",

	"nutrition" = "14:28,5:11",
	"temp" = "14:28,6:13",
	"health" = "14:28,7:15",
	"internal" = "14:28,8:17",

	"toxin" = "14:28,13:27",
	"fire" = "14:28,12:25",
	"oxygen" = "14:28,11:23",
	"pressure" = "14:28,10:21")

	hideable = list(
	"inventory2" =1, "shoes" = 1,
	"head" = 1, "gloves" = 1,
	"ears" = 1, "glasses" = 1)

	hidden_inventory_update()
		if(ishuman(myhud.mymob))
			var/mob/living/carbon/human/H = myhud.mymob
			if(myhud.inventory_shown && myhud.hud_shown)
				if(H.shoes)		H.shoes.screen_loc = locations["shoes"]
				if(H.gloves)	H.gloves.screen_loc = locations["gloves"]
				if(H.ears)		H.ears.screen_loc = locations["ears"]
				if(H.glasses)	H.glasses.screen_loc = locations["glasses"]
				if(H.head)		H.head.screen_loc = locations["head"]
			else
				if(H.shoes)		H.shoes.screen_loc = null
				if(H.gloves)	H.gloves.screen_loc = null
				if(H.ears)		H.ears.screen_loc = null
				if(H.glasses)	H.glasses.screen_loc = null
				if(H.head)		H.head.screen_loc = null
		return 1

/datum/hud/proc/custom_hud(var/uistyle='icons/mob/screen1_inferno.dmi', var/specialtype = /datum/hud_special/inferno)
	src.adding = list()
	src.other = list()
	src.hotkeybuttons = list() //These can be disabled for hotkey usersx
	src.special = new specialtype(src)

	var/obj/screen/using
	var/obj/screen/inventory/inv_box

	using = new /obj/screen()
	using.name = "act_intent"
	using.dir = SOUTHWEST
	using.icon = uistyle
	using.icon_state = "intent_"+mymob.a_intent
	using.screen_loc = special.locations["acti"]
	using.layer = 20
	src.adding += using
	action_intent = using

//intent small hud objects
	var/icon/ico

	ico = new(uistyle, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,ico.Height()/2,ico.Width()/2,ico.Height())
	using = new /obj/screen( src )
	using.name = "help"
	using.icon = ico
	using.screen_loc = special.locations["acti"]
	using.layer = 21
	src.adding += using
	help_intent = using

	ico = new(uistyle, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,ico.Height()/2,ico.Width(),ico.Height())
	using = new /obj/screen( src )
	using.name = "disarm"
	using.icon = ico
	using.screen_loc = special.locations["acti"]
	using.layer = 21
	src.adding += using
	disarm_intent = using

	ico = new(uistyle, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,1,ico.Width(),ico.Height()/2)
	using = new /obj/screen( src )
	using.name = "grab"
	using.icon = ico
	using.screen_loc = special.locations["acti"]
	using.layer = 21
	src.adding += using
	grab_intent = using

	ico = new(uistyle, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,1,ico.Width()/2,ico.Height()/2)
	using = new /obj/screen( src )
	using.name = "harm"
	using.icon = ico
	using.screen_loc = special.locations["acti"]
	using.layer = 21
	src.adding += using
	hurt_intent = using
//end intent small hud objects

	using = new /obj/screen()
	using.name = "mov_intent"
	using.dir = SOUTHWEST
	using.icon = uistyle
	using.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
	using.screen_loc = special.locations["movi"]
	using.layer = 20
	src.adding += using
	move_intent = using

	using = new /obj/screen()
	using.name = "drop"
	using.icon = uistyle
	using.icon_state = "act_drop"
	using.screen_loc = special.locations["throw"]
	using.layer = 19
	src.hotkeybuttons += using

	inv_box = new /obj/screen/inventory()
	inv_box.name = "i_clothing"
	inv_box.dir = SOUTH
	inv_box.icon = uistyle
	inv_box.slot_id = slot_w_uniform
	inv_box.icon_state = "center"
	inv_box.screen_loc = special.locations["iclothing"]
	inv_box.layer = 19
	if(special.hideable["iclothing"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "o_clothing"
	inv_box.dir = SOUTH
	inv_box.icon = uistyle
	inv_box.slot_id = slot_wear_suit
	inv_box.icon_state = "equip"
	inv_box.screen_loc = special.locations["oclothing"]
	inv_box.layer = 19
	if(special.hideable["oclothing"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "r_hand"
	inv_box.dir = WEST
	inv_box.icon = uistyle
	inv_box.icon_state = "hand_inactive"
	if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = special.locations["rhand"]
	inv_box.slot_id = slot_r_hand
	inv_box.layer = 19
	src.r_hand_hud_object = inv_box
	src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "l_hand"
	inv_box.dir = EAST
	inv_box.icon = uistyle
	inv_box.icon_state = "hand_inactive"
	if(mymob && mymob.hand)	//This being 1 means the left hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = special.locations["lhand"]
	inv_box.slot_id = slot_l_hand
	inv_box.layer = 19
	src.l_hand_hud_object = inv_box
	src.adding += inv_box

	using = new /obj/screen/inventory()
	using.name = "hand"
	using.dir = SOUTH
	using.icon = uistyle
	using.icon_state = "hand1"
	using.screen_loc = special.locations["swaphand1"]
	using.layer = 19
	src.adding += using

	using = new /obj/screen/inventory()
	using.name = "hand"
	using.dir = SOUTH
	using.icon = uistyle
	using.icon_state = "hand2"
	using.screen_loc = special.locations["swaphand2"]
	using.layer = 19
	src.adding += using

	inv_box = new /obj/screen/inventory()
	inv_box.name = "id"
	inv_box.dir = NORTH
	inv_box.icon = uistyle
	inv_box.icon_state = "id"
	inv_box.screen_loc = special.locations["id"]
	inv_box.slot_id = slot_wear_id
	inv_box.layer = 19
	if(special.hideable["id"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "mask"
	inv_box.dir = NORTH
	inv_box.icon = uistyle
	inv_box.icon_state = "equip"
	inv_box.screen_loc = special.locations["mask"]
	inv_box.slot_id = slot_wear_mask
	inv_box.layer = 19
	if(special.hideable["mask"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "back"
	inv_box.dir = NORTH
	inv_box.icon = uistyle
	inv_box.icon_state = "back"
	inv_box.screen_loc = special.locations["back"]
	inv_box.slot_id = slot_back
	inv_box.layer = 19
	if(special.hideable["back"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "storage1"
	inv_box.icon = uistyle
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = special.locations["storage1"]
	inv_box.slot_id = slot_l_store
	inv_box.layer = 19
	if(special.hideable["storage1"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "storage2"
	inv_box.icon = uistyle
	inv_box.icon_state = "pocket"
	inv_box.dir = NORTH
	inv_box.screen_loc = special.locations["storage2"]
	inv_box.slot_id = slot_r_store
	inv_box.layer = 19
	if(special.hideable["storage2"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "suit storage"
	inv_box.icon = uistyle
	inv_box.dir = 8 //The sprite at dir=8 has the background whereas the others don't.
	inv_box.icon_state = "belt"
	inv_box.screen_loc = special.locations["sstore1"]
	inv_box.slot_id = slot_s_store
	inv_box.layer = 19
	if(special.hideable["sstore1"])
		src.other += inv_box
	else
		src.adding += inv_box

	using = new /obj/screen()
	using.name = "resist"
	using.icon = uistyle
	using.icon_state = "act_resist"
	using.screen_loc = special.locations["resist"]
	using.layer = 19
	src.hotkeybuttons += using

	using = new /obj/screen()
	using.name = "other"
	using.icon = uistyle
	using.icon_state = "other"
	using.screen_loc = special.locations["inventory"]
	using.layer = 18
	if(special.hideable["inventory"])
		src.other += using
	else
		src.adding += using

	using = new /obj/screen()
	using.name = "equip"
	using.icon = uistyle
	using.icon_state = "act_equip"
	using.screen_loc = special.locations["equip"]
	using.layer = 20
	src.adding += using

	using = new /obj/screen()
	using.name = "other"
	using.icon = uistyle
	using.icon_state = "other"
	using.screen_loc = special.locations["inventory2"]
	using.layer = 20
	if(special.hideable["inventory2"])
		src.other += using
	else
		src.adding += using

	inv_box = new /obj/screen/inventory()
	inv_box.name = "gloves"
	inv_box.icon = uistyle
	inv_box.icon_state = "gloves"
	inv_box.screen_loc = special.locations["gloves"]
	inv_box.slot_id = slot_gloves
	inv_box.layer = 19
	if(special.hideable["gloves"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "eyes"
	inv_box.icon = uistyle
	inv_box.icon_state = "glasses"
	inv_box.screen_loc = special.locations["glasses"]
	inv_box.slot_id = slot_glasses
	inv_box.layer = 19
	if(special.hideable["glasses"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "ears"
	inv_box.icon = uistyle
	inv_box.icon_state = "ears"
	inv_box.screen_loc = special.locations["ears"]
	inv_box.slot_id = slot_ears
	inv_box.layer = 19
	if(special.hideable["ears"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "head"
	inv_box.icon = uistyle
	inv_box.icon_state = "hair"
	inv_box.screen_loc = special.locations["head"]
	inv_box.slot_id = slot_head
	inv_box.layer = 19
	if(special.hideable["head"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "shoes"
	inv_box.icon = uistyle
	inv_box.icon_state = "shoes"
	inv_box.screen_loc = special.locations["shoes"]
	inv_box.slot_id = slot_shoes
	inv_box.layer = 19
	if(special.hideable["shoes"])
		src.other += inv_box
	else
		src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "belt"
	inv_box.icon = uistyle
	inv_box.icon_state = "belt"
	inv_box.screen_loc = special.locations["belt"]
	inv_box.slot_id = slot_belt
	inv_box.layer = 19
	if(special.hideable["belt"])
		src.other += inv_box
	else
		src.adding += inv_box

	mymob.throw_icon = new /obj/screen()
	mymob.throw_icon.icon = uistyle
	mymob.throw_icon.icon_state = "act_throw_off"
	mymob.throw_icon.name = "throw"
	mymob.throw_icon.screen_loc = special.locations["throw"]
	src.hotkeybuttons += mymob.throw_icon

	mymob.oxygen = new /obj/screen()
	mymob.oxygen.icon = uistyle
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = special.locations["oxygen"]

	mymob.pressure = new /obj/screen()
	mymob.pressure.icon = uistyle
	mymob.pressure.icon_state = "pressure0"
	mymob.pressure.name = "pressure"
	mymob.pressure.screen_loc = special.locations["pressure"]

	mymob.toxin = new /obj/screen()
	mymob.toxin.icon = uistyle
	mymob.toxin.icon_state = "tox0"
	mymob.toxin.name = "toxin"
	mymob.toxin.screen_loc = special.locations["toxin"]

	mymob.internals = new /obj/screen()
	mymob.internals.icon = uistyle
	mymob.internals.icon_state = "internal0"
	mymob.internals.name = "internal"
	mymob.internals.screen_loc = special.locations["internal"]

	mymob.fire = new /obj/screen()
	mymob.fire.icon = uistyle
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = special.locations["fire"]

	mymob.bodytemp = new /obj/screen()
	mymob.bodytemp.icon = uistyle
	mymob.bodytemp.icon_state = "temp1"
	mymob.bodytemp.name = "body temperature"
	mymob.bodytemp.screen_loc = special.locations["temp"]

	mymob.healths = new /obj/screen()
	mymob.healths.icon = uistyle
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = special.locations["health"]

	mymob.nutrition_icon = new /obj/screen()
	mymob.nutrition_icon.icon = uistyle
	mymob.nutrition_icon.icon_state = "nutrition0"
	mymob.nutrition_icon.name = "nutrition"
	mymob.nutrition_icon.screen_loc = special.locations["nutrition"]

	mymob.pullin = new /obj/screen()
	mymob.pullin.icon = uistyle
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = special.locations["resist"]
	src.hotkeybuttons += mymob.pullin

// --
	mymob.blind = new /obj/screen()
	mymob.blind.icon = 'icons/mob/screen1_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.mouse_opacity = 0
	mymob.blind.layer = 0

	mymob.damageoverlay = new /obj/screen()
	mymob.damageoverlay.icon = 'icons/mob/screen1_full.dmi'
	mymob.damageoverlay.icon_state = "oxydamageoverlay0"
	mymob.damageoverlay.name = "dmg"
	mymob.damageoverlay.screen_loc = "1,1"
	mymob.damageoverlay.mouse_opacity = 0
	mymob.damageoverlay.layer = 18.1 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.

	mymob.flash = new /obj/screen()
	mymob.flash.icon = uistyle
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.layer = 17

	mymob.pain = new /obj/screen(null)
// --

	mymob.zone_sel = new /obj/screen/zone_sel( null )
	mymob.zone_sel.icon = uistyle
	mymob.zone_sel.overlays.Cut()
	mymob.zone_sel.screen_loc = special.locations["zonesel"]
	mymob.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]")

	if(special.locations["filler"])
		using = new /obj/screen()
		using.icon = uistyle
		using.screen_loc = special.locations["filler"]
		using.layer = 17
		using.dir = EAST
		src.adding += using

	if(special.locations["filler2"])
		using = new /obj/screen()
		using.icon = uistyle
		using.screen_loc = special.locations["filler2"]
		using.layer = 17
		src.adding += using

	mymob.client.screen = null

	mymob.client.screen += list(mymob.throw_icon, mymob.zone_sel, mymob.oxygen, mymob.pressure, mymob.toxin, mymob.bodytemp, mymob.internals, mymob.fire, mymob.healths, mymob.nutrition_icon, mymob.pullin, mymob.blind, mymob.flash, mymob.damageoverlay)
	mymob.client.screen += src.adding + src.hotkeybuttons
	inventory_shown = 0

	return




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
