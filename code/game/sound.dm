/proc/playsound(var/atom/source, soundin, vol as num, vary, extrarange as num, falloff, rec = 1)

	soundin = get_sfx(soundin) // same sound for everyone

	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return

	var/frequency = get_rand_frequency() // Same frequency for everybody
	var/turf/turf_source = get_turf(source)

 	// Looping through the player list has the added bonus of working for mobs inside containers
	for (var/P in player_list)
		var/mob/M = P
		if(!M || !M.client)
			continue
		if(get_dist(M, turf_source) <= (world.view + extrarange) * 2)
			var/turf/T = get_turf(M)
			if(T && T.z == turf_source.z)
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff)
			var/z_dist = abs(T.z - turf_source.z)
			if(T && z_dist <= 1)
				M.playsound_local(turf_source, soundin, vol/(1+z_dist), vary, frequency, falloff)
			

var/const/FALLOFF_SOUNDS = 2
var/const/SURROUND_CAP = 255

/mob/proc/playsound_local(var/turf/turf_source, soundin, vol as num, vary, frequency, falloff, rec = 1)
	if(!src.client || ear_deaf > 0)	return
	soundin = get_sfx(soundin)

	var/sound/S = sound(soundin)
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol
	S.environment = 2

	if (vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	if(isturf(turf_source))
		// 3D sounds, the technology is here!
		var/turf/T = get_turf(src)
		S.volume -= get_dist(T, turf_source) * 0.5
		if (S.volume < 0)
			S.volume = 0
		var/dx = turf_source.x - T.x // Hearing from the right/left

		S.x = round(max(-SURROUND_CAP, min(SURROUND_CAP, dx)), 1)

		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = round(max(-SURROUND_CAP, min(SURROUND_CAP, dz)), 1)

		// The y value is for above your head, but there is no ceiling in 2d spessmens. //There is now lol.
		var/d = turf_source.y - T.y // Hearing from infront/behind
		S.y = round(max(-SURROUND_CAP, min(SURROUND_CAP, d)), 1)
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)
		
	src << S

/client/proc/playtitlemusic()
	if(!ticker || !ticker.login_music)	return
	if(prefs.toggles & SOUND_LOBBY)
		src << sound(ticker.login_music, repeat = 1, wait = 0, volume = 85, channel = 1) // MAD JAMS

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
			if ("explosion") soundin = pick('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg','sound/effects/Explosion2.ogg','sound/effects/Explosion3.ogg','sound/effects/Explosion4.ogg','sound/effects/Explosion5.ogg','sound/effects/Explosion6.ogg')
			if ("sparks") soundin = pick('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg')
			if ("rustle") soundin = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if ("punch") soundin = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg')
			if ("footsteps_metal") soundin = pick('sound/effects/player/boots_run_metal_1.ogg','sound/effects/player/boots_run_metal_2.ogg','sound/effects/player/boots_run_metal_3.ogg','sound/effects/player/boots_run_metal_4.ogg')
			if ("footsteps_carpet") soundin = pick('sound/effects/player/boots_run_carpet_1.ogg','sound/effects/player/boots_run_carpet_2.ogg','sound/effects/player/boots_run_carpet_3.ogg','sound/effects/player/boots_run_carpet_4.ogg')
			if ("footsteps_wood") soundin = pick('sound/effects/player/boots_run_wood_1.ogg','sound/effects/player/boots_run_wood_2.ogg','sound/effects/player/boots_run_wood_3.ogg','sound/effects/player/boots_run_wood_4.ogg')
			if ("footsteps_magboots") soundin = pick('sound/effects/player/power_metal_1.ogg','sound/effects/player/power_metal_2.ogg','sound/effects/player/power_metal_3.ogg','sound/effects/player/power_metal_4.ogg')
			if ("clownstep") soundin = pick('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
			if ("swing_hit") soundin = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if ("hiss") soundin = pick('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
			if ("pageturn") soundin = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			if ("gunshot") soundin = pick('sound/weapons/Gunshot.ogg', 'sound/weapons/Gunshot2.ogg', 'sound/weapons/Gunshot3.ogg', 'sound/weapons/Gunshot4.ogg')
			if ("bodyfall") soundin = pick('sound/effects/bodyfall1.ogg', 'sound/effects/bodyfall2.ogg', 'sound/effects/bodyfall3.ogg', 'sound/effects/bodyfall4.ogg')
			if ("erikafootsteps") soundin = pick('sound/effects/footsteps/tile1.wav','sound/effects/footsteps/tile2.wav','sound/effects/footsteps/tile3.wav','sound/effects/footsteps/tile4.wav')
			if ("grassfootsteps") soundin = pick('sound/effects/footsteps/grass/grass1.wav','sound/effects/footsteps/grass/grass2.wav','sound/effects/footsteps/grass/grass3.wav','sound/effects/footsteps/grass/grass4.wav')
			if ("dirtfootsteps") soundin = pick('sound/effects/footsteps/dirt/dirt1.wav','sound/effects/footsteps/dirt/dirt2.wav','sound/effects/footsteps/dirt/dirt3.wav','sound/effects/footsteps/dirt/dirt4.wav')
			if ("waterfootsteps") soundin = pick('sound/effects/footsteps/water/slosh1.wav','sound/effects/footsteps/water/slosh2.wav','sound/effects/footsteps/water/slosh3.wav','sound/effects/footsteps/water/slosh4.wav')
			if ("sandfootsteps") soundin = pick('sound/effects/footsteps/sand/sand_step1.ogg','sound/effects/footsteps/sand/sand_step2.ogg','sound/effects/footsteps/sand/sand_step3.ogg','sound/effects/footsteps/sand/sand_step4.ogg','sound/effects/footsteps/sand/sand_step5.ogg','sound/effects/footsteps/sand/sand_step6.ogg','sound/effects/footsteps/sand/sand_step7.ogg','sound/effects/footsteps/sand/sand_step8.ogg')
			if ("woodfootsteps") soundin = pick('sound/effects/footsteps/wood/wood_step1.ogg','sound/effects/footsteps/wood/wood_step2.ogg','sound/effects/footsteps/wood/wood_step3.ogg','sound/effects/footsteps/wood/wood_step4.ogg','sound/effects/footsteps/wood/wood_step5.ogg','sound/effects/footsteps/wood/wood_step6.ogg','sound/effects/footsteps/wood/wood_step7.ogg','sound/effects/footsteps/wood/wood_step8.ogg')
			if ("carpetfootsteps") soundin = pick('sound/effects/footsteps/carpet/carpet_step1.ogg','sound/effects/footsteps/carpet/carpet_step2.ogg','sound/effects/footsteps/carpet/carpet_step3.ogg','sound/effects/footsteps/carpet/carpet_step4.ogg','sound/effects/footsteps/carpet/carpet_step5.ogg','sound/effects/footsteps/carpet/carpet_step6.ogg','sound/effects/footsteps/carpet/carpet_step7.ogg','sound/effects/footsteps/carpet/carpet_step8.ogg')
			if ("snowfootsteps") soundin = pick('sound/effects/footsteps/snow/snowstep1.ogg', 'sound/effects/footsteps/snow/snowstep2.ogg', 'sound/effects/footsteps/snow/snowstep3.ogg', 'sound/effects/footsteps/snow/snowstep4.ogg')
	return soundin