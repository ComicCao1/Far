/var/obj/effect/lobby_image = new/obj/effect/lobby_image()

/obj/effect/lobby_image
	name = "Baystation12"
	desc = "This shouldn't be read"
	icon = 'icons/misc/fullscreen.dmi'
	icon_state = "title"
	screen_loc = "WEST,SOUTH"

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	winset(src, null, "mainwindow.title='[vessel_name()]'")//Making it so window is named what it's named.
	if(join_motd)
		src << "<div class=\"motd\">[join_motd]</div>"

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	if(length(newplayer_start))
		loc = pick(newplayer_start)
	else
		loc = locate(1,1,1)
	lastarea = loc

	unlock_medal("First Timer", 0, "Welcome!", "easy")

	sight |= SEE_TURFS
	player_list |= src
	client.screen += lobby_image

/*
	var/list/watch_locations = list()
	for(var/obj/effect/landmark/landmark in landmarks_list)
		if(landmark.tag == "landmark*new_player")
			watch_locations += landmark.loc

	if(watch_locations.len>0)
		loc = pick(watch_locations)
*/
	new_player_panel()
	spawn(40)
		if(client)
			client.playtitlemusic()
