var/const/stuff = {"
Hats
SWAT cap:/obj/item/clothing/head/secsoft/fluff/swatcap:450
Collectable Pete hat:/obj/item/clothing/head/collectable/petehat:2000
Collectable Metroid hat:/obj/item/clothing/head/collectable/metroid:1300
Collectable Xeno hat:/obj/item/clothing/head/collectable/xenom:1100
Collectable Top hat:/obj/item/clothing/head/collectable/tophat:600
Kitty Ears:/obj/item/clothing/head/kitty:100
Ushanka:/obj/item/clothing/head/ushanka:300

Personal Stuff
Eye patch:/obj/item/clothing/glasses/eyepatch:200
Cane:/obj/item/weapon/cane:200
Golden Pen:/obj/item/weapon/pen/fluff/eugene_bissegger_1:300
Zippo:/obj/item/weapon/lighter/zippo:200
Engraved Zippo:/obj/item/weapon/lighter/zippo/fluff/naples_1:250
Golden Zippo:/obj/item/weapon/lighter/zippo/fluff/michael_guess_1:500
Cigarette packet:/obj/item/weapon/storage/fancy/cigarettes:20
DromedaryCo packet:/obj/item/weapon/storage/fancy/cigarettes/dromedaryco:50
Premium Havanian Cigar:/obj/item/clothing/mask/cigarette/cigar/havana:200
Electronic Cigarette:/obj/item/clothing/mask/fluff/electriccig:100
Beer bottle:/obj/item/weapon/reagent_containers/food/drinks/beer:80
Captain flask:/obj/item/weapon/reagent_containers/food/drinks/flask:300
pAI card:/obj/item/device/paicard:300
Teapot:/obj/item/weapon/reagent_containers/glass/beaker/fluff/eleanor_stone:200
Three Mile Island Ice Tea:/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/threemileisland:100

Costume sets
Plague Doctor Set:/obj/effect/landmark/costume/plaguedoctor:3750

Shoes
Clown Shoes:/obj/item/clothing/shoes/clown_shoes:200
Rainbow Shoes:/obj/item/clothing/shoes/rainbow:200
Cyborg Shoes:/obj/item/clothing/shoes/cyborg:200
Laceups Shoes:/obj/item/clothing/shoes/laceup:200
Leather Shoes:/obj/item/clothing/shoes/leather:200
Red Shoes:/obj/item/clothing/shoes/red:100
Green Shoes:/obj/item/clothing/shoes/green:100
Blue Shoes:/obj/item/clothing/shoes/blue:100
Yellow Shoes:/obj/item/clothing/shoes/yellow:100
Purple Shoes:/obj/item/clothing/shoes/purple:100
Wooden Sandals:/obj/item/clothing/shoes/sandal:80
Fluffy Slippers:/obj/item/clothing/shoes/slippers:150

Jumpsuits
Vice Policeman:/obj/item/clothing/under/rank/vice:900
Rainbow Suit:/obj/item/clothing/under/rainbow:200
Lightblue Suit:/obj/item/clothing/under/lightblue:200
Aqua Suit:/obj/item/clothing/under/aqua:900
Purple Suit:/obj/item/clothing/under/purple:200
Lightpurple Suit:/obj/item/clothing/under/lightpurple:200
Lightbrown Suit:/obj/item/clothing/under/lightbrown:200
Brown Suit:/obj/item/clothing/under/brown:200
Darkblue suit:/obj/item/clothing/under/darkblue:200
Lightred Suit:/obj/item/clothing/under/lightred:200
Darkred Suit:/obj/item/clothing/under/darkred:200
Grim Jacket:/obj/item/clothing/under/suit_jacket:200
Black Jacket:/obj/item/clothing/under/color/blackf:200
Police Uniform:/obj/item/clothing/under/det/fluff/retpoluniform:400
Scratched Suit:/obj/item/clothing/under/scratch:200
Downy Jumpsuit:/obj/item/clothing/under/fluff/jumpsuitdown:200
Tacticool Turtleneck:/obj/item/clothing/under/syndicate/tacticool:200

Gloves
White:/obj/item/clothing/gloves/white:200
Rainbow:/obj/item/clothing/gloves/rainbow:300
Black:/obj/item/clothing/gloves/black:250

Coats
Brown Coat:/obj/item/clothing/suit/browncoat:500

Bedsheets
Clown Bedsheet:/obj/item/weapon/bedsheet/clown:300
Mime Bedsheet:/obj/item/weapon/bedsheet/mime:300
Rainbow Bedsheet:/obj/item/weapon/bedsheet/rainbow:300
Captain Bedsheet:/obj/item/weapon/bedsheet/captain:600

Toys
Rubber Duck:/obj/item/weapon/bikehorn/rubberducky:500
The Holy Cross:/obj/item/fluff/val_mcneil_1:600
Champion Belt:/obj/item/weapon/storage/belt/champion:400
Keppel:/obj/item/weapon/fluff/cado_keppel_1:400

Special Stuff
Santabag:/obj/item/weapon/storage/backpack/santabag:4000
"}


var/list/datum/donator_prize/prizes = list()
var/list/datum/donator/donators = list()

/datum/donator
	var/ownerkey
	var/money = 0
	var/maxmoney = 0
	var/allowed_num_items = 10

	New(ckey, money)
		..()
		ownerkey = ckey
		src.money = money
		maxmoney = money
		donators[ckey] = src

	proc/show()
		var/dat = "<title>Donator panel</title>"
		dat += "You have [money] / [maxmoney]<br>"
		dat += "You can spawn [ allowed_num_items ? allowed_num_items : "no" ] more items.<br><br>"

		if (allowed_num_items)
			if (!prizes.len)
				build_prizes_list()

			var/cur_cat = "None"

			for (var/i = 1, i<=prizes.len, i++)
				var/datum/donator_prize/prize = prizes[i]
				var/cat_name = prize.category
				if (cur_cat != cat_name)
					dat += "<hr><b>[cat_name]</b><br>"
				cur_cat = cat_name
				dat += "<a href='?src=\ref[src];itemid=[i]'>[prize.item_name] : [prize.cost]</a><br>"
		usr << browse(dat, "window=donatorpanel;size=250x400")

	Topic(href, href_list)
		var/id = text2num(href_list["itemid"])
		var/datum/donator_prize/prize = prizes[id]

		var/name = prize.item_name
		var/cost = prize.cost
		var/path = prize.path_to
		var/mob/living/carbon/human/user = usr.client.mob

		var/list/slots = list (
			"backpack" = slot_in_backpack,
			"left pocket" = slot_l_store,
			"right pocket" = slot_r_store,
			"left hand" = slot_l_hand,
			"right hand" = slot_r_hand,
		)

		if(cost > money)
			usr << "\red You don't have enough funds."
			return 0

		if(!allowed_num_items)
			usr << "\red You have reached maximum amount of spawned items."
			return 0

		if(!user)
			user << "\red You must be a human to use this."
			return 0

		if(!ispath(path))
			return 0

		if(user.stat) return 0

		var/obj/spawned = new path(user.loc)

		if(spawned)
			var/where = user.equip_in_one_of_slots(spawned, slots, del_on_fail=0)
			if (!where)
				spawned.loc = user.loc
				usr << "\blue Your [name] has been spawned!"
			else
				usr << "\blue Your [name] has been spawned in your [where]!"
		else
			usr << "\blue Your [name] has been spawned!"

		money -= cost
		allowed_num_items--

		show()

/datum/donator_prize
	var/item_name = "Nothing"
	var/path_to = /datum/donator_prize
	var/cost = 0
	var/category = "Debug"

proc/load_donator(ckey)
	var/DBConnection/dbcon2 = new()
	dbcon2.Connect("dbi:mysql:forum2:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")

	if(!dbcon2.IsConnected())
		world.log << "Failed to connect to database [dbcon2.ErrorMsg()] in load_donator([ckey])."
		diary << "Failed to connect to database in load_donator([ckey])."
		return 0

	var/DBQuery/query = dbcon2.NewQuery("SELECT round(sum) FROM Z_donators WHERE byond='[ckey]'")
	query.Execute()
	world.log << "PURR [query.RowCount()]"
	diary << "PURR [query.RowCount()]"
	while(query.NextRow())
		var/list/RowData = query.GetRowData()
		for(var/D in RowData)
			usr << "[D] = [RowData[D]]"
		var/money = round(text2num(query.item[1]))
		new /datum/donator(ckey, money)
		world.log << "DURR [query.item.len]"
		diary << "DURR [query.item.len]"
		world.log << "HURR [dbcon2.ErrorMsg()]"
		diary << "HURR [dbcon2.ErrorMsg()]"
		world.log << "DERP [ckey]"
		diary << "DERP [ckey]"
	dbcon2.Disconnect()
	return 1

proc/build_prizes_list()
	var/list/strings = text2list ( stuff, "\n" )
	var/cur_cat = "Miscellaneous"
	for (var/string in strings)
		if (string) //It's not a delimiter between
			var/list/item_info = text2list ( string, ":" )
			if (item_info.len==3)
				var/datum/donator_prize/prize = new
				prize.item_name = item_info[1]
				prize.path_to = text2path(item_info[2])
				prize.cost = text2num(item_info[3])
				prize.category = cur_cat
				prizes += prize
			else
				cur_cat = item_info[1]


/client/verb/cmd_donator_panel()
	set name = "Donator panel"
	set category = "OOC"

	if(!ticker || ticker.current_state < 3)
		alert("Please wait until game setting up!")
		return

	if (!donators[ckey]) //It doesn't exist yet
		if (load_donator(ckey))
			var/datum/donator/D = donators[ckey]
			if(D)
				D.show()
			else
				usr << browse ("<b>You have not donated or the database is inaccessible.</b>", "window=donatorpanel")
		else
			usr << browse ("<b>You have not donated or the database is inaccessible.</b>", "window=donatorpanel")
	else
		var/datum/donator/D = donators[ckey]
		D.show()

//SPECIAL ITEMS
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/threemileisland
	New()
		..()
		reagents.add_reagent("threemileisland", 50)
		on_reagent_change()