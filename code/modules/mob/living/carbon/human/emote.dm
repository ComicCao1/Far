/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null, var/cooldown = 2)
	var/param = null

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's  unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	//var/m_type = 1

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	if(src.stat == 2.0 && (act != "deathgasp"))
		return
	if(emote_cooldown > 0)
		return
	switch(act)
		if ("airguitar")
			if (!src.restrained())
				message = "<B>[src]</B> is strumming the air and headbanging like a safari chimp."
				m_type = 1

		if ("blink")
			message = "<B>[src]</B> blinks."
			m_type = 1

		if ("blink_r")
			message = "<B>[src]</B> blinks rapidly."
			m_type = 1

		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<B>[src]</B> bows to [param]."
				else
					message = "<B>[src]</B> bows."
			m_type = 1

		if ("custom")
			var/input = sanitize(input("Choose an emote to display.") as text|null)
			if (!input)
				return
			var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
			if (input2 == "Visible")
				m_type = 1
			else if (input2 == "Hearable")
				if (src.miming)
					return
				m_type = 2
			else
				alert("Unable to use this emote, must be either hearable or visible.")
				return
			return custom_emote(m_type, message)

		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "\red You cannot send IC messages (muted)."
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			return custom_emote(m_type, message)

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "<B>[src]</B> salutes to [param]."
				else
					message = "<B>[src]</b> salutes."
			m_type = 1

		if ("choke")
			if(miming)
				message = "<B>[src]</B> clutches his throat desperately!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> chokes!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a strong noise."
					m_type = 2

		if ("clap")
			if (!src.restrained())
				message = "<B>[src]</B> claps."
				m_type = 2
				if(miming)
					m_type = 1
		if ("flap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps his wings."
				m_type = 2
				if(miming)
					m_type = 1

		if ("aflap")
			if (!src.restrained())
				message = "<B>[src]</B> flaps his wings ANGRILY!"
				m_type = 2
				if(miming)
					m_type = 1

		if ("drool")
			message = "<B>[src]</B> drools."
			m_type = 1

		if ("eyebrow")
			message = "<B>[src]</B> raises an eyebrow."
			m_type = 1

		if ("chuckle")
			if(miming)
				message = "<B>[src]</B> appears to chuckle."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> chuckles."
					m_type = 2
				else
					message = "<B>[src]</B> makes a noise."
					m_type = 2

		if ("twitch")
			message = "<B>[src]</B> twitches violently."
			m_type = 1

		if("poo")
			src.handle_shit()
			m_type = 1

		if("pee")
			src.handle_piss()
			m_type = 1

		if ("twitch_s")
			message = "<B>[src]</B> twitches."
			m_type = 1

		if ("faint")
			message = "<B>[src]</B> faints."
			if(src.sleeping)
				return //Can't faint while asleep
			src.sleeping += 10 //Short-short nap
			m_type = 1

		if ("cough")
			if(miming)
				message = "<B>[src]</B> appears to cough!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> coughs!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a strong noise."
					m_type = 2

		if ("frown")
			message = "<B>[src]</B> frowns."
			m_type = 1

		if ("nod")
			message = "<B>[src]</B> nods."
			m_type = 1

		if ("blush")
			message = "<B>[src]</B> blushes."
			m_type = 1

		if ("wave")
			message = "<B>[src]</B> waves."
			m_type = 1

		if ("gasp")
			if(miming)
				message = "<B>[src]</B> appears to be gasping!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> gasps!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a weak noise."
					m_type = 2

		if ("deathgasp")
			message = "<B>[src]</B> seizes up and falls limp, \his eyes dead and lifeless..."
			m_type = 1

		if ("giggle")
			if(miming)
				message = "<B>[src]</B> giggles silently!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> giggles."
					m_type = 2
				else
					message = "<B>[src]</B> makes a noise."
					m_type = 2

		if ("glare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> glares at [param]."
			else
				message = "<B>[src]</B> glares."

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> stares at [param]."
			else
				message = "<B>[src]</B> stares."

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if (!M)
				param = null

			if (param)
				message = "<B>[src]</B> looks at [param]."
			else
				message = "<B>[src]</B> looks."
			m_type = 1

		if ("grin")
			message = "<B>[src]</B> grins."
			m_type = 1

		if ("cry")
			if(miming)
				message = "<B>[src]</B> cries."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> cries."
					m_type = 2
				else
					message = "<B>[src]</B> makes a weak noise. \He frowns."
					m_type = 2

		if ("sigh")
			if(miming)
				message = "<B>[src]</B> sighs."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> sighs."
					m_type = 2
				else
					message = "<B>[src]</B> makes a weak noise."
					m_type = 2

		if ("laugh")
			if(miming)
				message = "<B>[src]</B> acts out a laugh."
				m_type = 1
			else
				if (!muzzled)
					if (stat)
						return
					message = "<B>[src]</B> laughs."
					m_type = 2
					call_sound_emote("laugh")
				else
					message = "<B>[src]</B> makes a noise."
					m_type = 2

		if("elaugh")
			if(miming)
				message = "<B>[src]</B> acts out a laugh."
				m_type = 1
			else if (mind.special_role)
				if(!(world.time-lastElaugh >= 600))
					usr << "<span class='warning'>You not ready to laugh again!"
				else
					message = "<B>[src]</B> laugh like a true evil! Mu-ha-ha!"
					m_type = 2
					call_sound_emote("elaugh")
					lastElaugh=world.time
			else
				if (!muzzled)
					if (stat)
						return
					if (!(world.time-lastElaugh >= 600))
						usr << "<span class='warning'>You not ready to laugh again!"
					else
						message = "<B>[src]</B> laughs."
						m_type = 2
						call_sound_emote("laugh")
				else
					message = "<B>[src]</B> makes a noise."
					m_type = 2

		if ("mumble")
			message = "<B>[src]</B> mumbles!"
			m_type = 2
			if(miming)
				m_type = 1

		if ("grumble")
			if(miming)
				message = "<B>[src]</B> grumbles!"
				m_type = 1
			if (!muzzled)
				message = "<B>[src]</B> grumbles!"
				m_type = 2
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("groan")
			if(miming)
				message = "<B>[src]</B> appears to groan!"
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> groans!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a loud noise."
					m_type = 2

		if ("moan")
			if(miming)
				message = "<B>[src]</B> appears to moan!"
				m_type = 1
			else
				message = "<B>[src]</B> moans!"
				m_type = 2

		if ("johnny")
			var/M
			if (param)
				M = param
			if (!M)
				param = null
			else
				if(miming)
					message = "<B>[src]</B> takes a drag from a cigarette and blows \"[M]\" out in smoke."
					m_type = 1
				else
					message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows his name out in smoke."
					m_type = 2

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					message = "<B>[src]</B> points."
				else
					M.point()

				if (M)
					message = "<B>[src]</B> points to [M]."
				else
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<B>[src]</B> raises a hand."
			m_type = 1

		if("shake")
			message = "<B>[src]</B> shakes \his head."
			m_type = 1

		if ("shrug")
			message = "<B>[src]</B> shrugs."
			m_type = 1

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
			m_type = 1

		if ("smile")
			message = "<B>[src]</B> smiles."
			m_type = 1

		if ("shiver")
			message = "<B>[src]</B> shivers."
			m_type = 2
			if(miming)
				m_type = 1

		if ("pale")
			message = "<B>[src]</B> goes pale for a second."
			m_type = 1

		if ("tremble")
			message = "<B>[src]</B> trembles in fear!"
			m_type = 1

		if ("sneeze")
			if (miming)
				message = "<B>[src]</B> sneezes."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> sneezes."
					m_type = 2
				else
					message = "<B>[src]</B> makes a strange noise."
					m_type = 2

		if ("sniff")
			message = "<B>[src]</B> sniffs."
			m_type = 2
			if(miming)
				m_type = 1

		if ("snore")
			if (miming)
				message = "<B>[src]</B> sleeps soundly."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> snores."
					m_type = 2
				else
					message = "<B>[src]</B> makes a noise."
					m_type = 2

		if ("whimper")
			if (miming)
				message = "<B>[src]</B> appears hurt."
				m_type = 1
			else
				if (!muzzled)
					message = "<B>[src]</B> whimpers."
					m_type = 2
				else
					message = "<B>[src]</B> makes a weak noise."
					m_type = 2

		if ("wink")
			message = "<B>[src]</B> winks."
			m_type = 1

		if ("yawn")
			if (!muzzled)
				message = "<B>[src]</B> yawns."
				m_type = 2
				if(miming)
					m_type = 1

		if ("collapse")
			Paralyse(2)
			message = "<B>[src]</B> collapses!"
			m_type = 2
			if(miming)
				m_type = 1

		if("hug")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "<B>[src]</B> hugs [M]."
				else
					message = "<B>[src]</B> hugs \himself."

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>[src]</B> shakes hands with [M]."
					else
						message = "<B>[src]</B> holds out \his hand to [M]."

		if("dap")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>[src]</B> gives daps to [M]."
				else
					message = "<B>[src]</B> sadly can't find anybody to give daps to, and daps \himself. Shameful."

		if ("scream")
			if (miming)
				message = "<B>[src]</B> acts out a scream!"
				m_type = 1
			else
				if (!muzzled)//NO MORE SCREAMING FROM DEAD AND UNCONCIOUS PEOPLE PLEASE!
					if (stat)
						return
					message = "<B>[src]</B> screams!"
					m_type = 2
					call_sound_emote("scream")
				else
					message = "<B>[src]</B> makes a very loud noise."
					m_type = 2

//SHITTY EMOTES BEGIN

		if("fart")
			if(world.time-lastFart >= 600)
				if (src.nutrition >= 150)
					call_sound_emote("fart")
					m_type = 2
	//				if(src.butt_op_stage == 4.0)
	//					src << "\blue You don't have a butt!"
	//					return
					switch(rand(1, 48))
						if(1)
							message = "<B>[src]</B> lets out a girly little 'toot' from \his butt."

						if(2)
							message = "<B>[src]</B> farts loudly!"

						if(3)
							message = "<B>[src]</B> lets one rip!"

						if(4)
							message = "<B>[src]</B> farts! It sounds wet and smells like rotten eggs."

						if(5)
							message = "<B>[src]</B> farts robustly!"

						if(6)
							message = "<B>[src]</B> farted! It reminds you of your grandmother's queefs."

						if(7)
							message = "<B>[src]</B> queefed out \his ass!"

						if(8)
							message = "<B>[src]</B> farted! It reminds you of your grandmother's queefs."

						if(9)
							message = "<B>[src]</B> farts a ten second long fart."

						if(10)
							message = "<B>[src]</B> groans and moans, farting like the world depended on it."

						if(11)
							message = "<B>[src]</B> breaks wind!"

						if(12)
							message = "<B>[src]</B> expels intestinal gas through the anus."

						if(13)
							message = "<B>[src]</B> release an audible discharge of intestinal gas."

						if(14)
							message = "<B>[src]</B> is a farting motherfucker!!!"

						if(15)
							message = "<B>[src]</B> suffers from flatulence!"

						if(16)
							message = "<B>[src]</B> releases flatus."

						if(17)
							message = "<B>[src]</B> releases gas generated in \his digestive tract, \his stomach and \his intestines. <B>It stinks way bad!</B>"

						if(18)
							message = "<B>[src]</B> farts like your mom used to!"

						if(19)
							message = "<B>[src]</B> farts. It smells like Soylent Surprise!"

						if(20)
							message = "<B>[src]</B> farts. It smells like pizza!"

						if(21)
							message = "<B>[src]</B> farts. It smells like George Melons' perfume!"

						if(22)
							message = "<B>[src]</B> farts. It smells like atmos in here now!"

						if(23)
							message = "<B>[src]</B> farts. It smells like medbay in here now!"

						if(24)
							message = "<B>[src]</B> farts. It smells like the bridge in here now!"

						if(25)
							message = "<B>[src]</B> farts like a pubby!"

						if(26)
							message = "<B>[src]</B> farts like a goone!"

						if(27)
							message = "<B>[src]</B> farts so hard he's certain poop came out with it, but dares not find out."

						if(28)
							message = "<B>[src]</B> farts delicately."

						if(29)
							message = "<B>[src]</B> farts timidly."

						if(30)
							message = "<B>[src]</B> farts very, very quietly. The stench is OVERPOWERING."

						if(31)
							message = "<B>[src]</B> farts and says, \"Mmm! Delightful aroma!\""

						if(32)
							message = "<B>[src]</B> farts and says, \"Mmm! Sexy!\""

						if(33)
							message = "<B>[src]</B> farts and fondles \his own buttocks."

						if(34)
							message = "<B>[src]</B> farts and fondles YOUR buttocks."

						if(35)
							message = "<B>[src]</B> fart in he own mouth. A shameful [src]."

						if(36)
							message = "<B>[src]</B> farts out pure plasma! <B>FUCK!</B>"
	//						src.achievement_give("Pure Plasma", 65)

						if(37)
							message = "<B>[src]</B> farts out pure oxygen. What the fuck did he eat?"

						if(38)
							message = "<B>[src]</B> breaks wind noisily!"

						if(39)
							message = "<B>[src]</B> releases gas with the power of the gods! The very station trembles!!"

						if(40)
							message = "<B>[src]</B> farts with the force of one thousand suns."

						if(41)
							message = "<B>[src] shat \his pants!</B>"

						if(42)
							message = "<B>[src] shat \his pants!</B> Oh, no, that was just a really nasty fart."

						if(43)
							message = "<B>[src]</B> is a flatulent whore."

						if(44)
							message = "<B>[src]</B> likes the smell of \his own farts."

						if(45)
							message = "<B>[src]</B> doesnt wipe after he poops."

						if(46)
							message = "<B>[src]</B> farts! Now he smells like Tiny Turtle."

						if(47)
							message = "<B>[src]</B> burps! He farted out of \his mouth!! That's Showtime's style, baby."

						if(48)
							message = "<B>[src]</B> laughs! His breath smells like a fart."

					for(var/mob/M in viewers(src, null))
						if(M.stat != 2 && M:getBrainLoss() >= 60)
							spawn(10)
								if(prob(20))
									switch(pick(1,2,3))
										if(1)
											M.say("[M == src ? "&#255;" : src.name] �����!!")
										if(2)
											M.emote("giggle")
										if(3)
											M.emote("clap")
				lastFart=world.time
				m_type = 2
			else
				message = "<b>[src]</b> strains, and nothing happens."
				m_type = 1


		if(("poo") || ("poop") || ("shit") || ("crap"))
			if(!config.allow_shit)
				message = "<b>[src]</b> strains, and nothing happens."
				m_type = 1

			else if (src.nutrition <= 300)
				src.emote("fart")
				m_type = 2
			else
				if (src.w_uniform)
					message = "<B>[src]</B> poos in their uniform."
					playsound(src.loc, 'fart.ogg', 60, 1)
					playsound(src.loc, 'squishy.ogg', 40, 1)
//					src.achievement_give("The Brown Medal", 65)
					src.nutrition -= 80
					m_type = 2
				else
					var/obj/structure/toilet/T = locate() in src.loc
					if(T && T.open)
						message = "<B>[src]</B> lands their butt onto a [T] and craps."
						playsound(src.loc, 'fart.ogg', 60, 1)
						playsound(src.loc, 'squishy.ogg', 40, 1)
						src.nutrition -= rand(60,80)
						m_type = 2
					else
						message = "<B>[src]</B> poos on the floor."
						playsound(src.loc, 'fart.ogg', 60, 1)
						playsound(src.loc, 'squishy.ogg', 40, 1)
	//					src.achievement_give("The Brown Medal", 65)
						var/turf/location = src.loc

						var/obj/effect/decal/cleanable/poo/D = new/obj/effect/decal/cleanable/poo(location)
						if(src.reagents)
							src.reagents.trans_to(D, rand(1,5))

						var/obj/item/weapon/reagent_containers/food/snacks/poo/V = new/obj/item/weapon/reagent_containers/food/snacks/poo(location)
						if(src.reagents)
							src.reagents.trans_to(V, rand(1,5))

						src.nutrition -= rand(60,80)
						m_type = 2

		if(("pee") || ("urinate") || ("piss"))
			if((!config.allow_shit) || (!src.reagents) || (src.nutrition < 250))
				message = "<b>[src]</b> strains, and nothing happens."
				m_type = 1
			else
				if (src.w_uniform)
					message = "<B>[src]</B> urinates in their uniform."
					src.nutrition -= rand(40,80)
				else
					var/obj/structure/urinal/U = locate() in src.loc
					var/obj/structure/toilet/T = locate() in src.loc
					var/obj/structure/sink/S = locate() in src.loc
					if((U || S) && gender != FEMALE)
						message = "<B>[src]</B> urinates into the [U ? U : S]."
						src.reagents.remove_any(rand(1,8))
						src.nutrition -= 80
						m_type = 1
					else if(T)
						if(gender == FEMALE)
							message = "<B>[src]</B> lands her butt onto [T] and urinates."
						else
							message = "<B>[src]</B> urinates into the [T]."
						src.reagents.remove_any(rand(1,8))
						src.nutrition -= 80
						m_type = 1
					else
						var/obj/effect/decal/cleanable/urine/D = new/obj/effect/decal/cleanable/urine(src.loc)
						if(src.reagents)
							src.reagents.trans_to(D, rand(1,8))
						message = "<B>[src]</B> urinates on the floor."
						src.nutrition -= 80
						m_type = 1

		if(("vomit") || ("puke") || ("throwup"))
			if(!src.reagents || src.nutrition <= 80)
				message = "<B>[src]</B> gags as if trying to throw up but nothing comes out."
				src << "You gag as you want to throw up, but there's nothing in your stomach!"
			else
				var/obj/effect/decal/cleanable/vomit/V = new/obj/effect/decal/cleanable/vomit(src.loc)
				if(src.reagents)
					src.reagents.trans_to(V, 10)
				message = "<B>[src]</B> [pick("vomits", "throws up")]!"
				src.nutrition -= rand(40,80)
				if(src.dizziness)
					src.dizziness -= rand(2,8)
				if(src.drowsyness)
					src.drowsyness -= rand(2,8)
				if(src.stuttering)
					src.stuttering -= rand(2,8)
				if(src.confused)
					src.confused -= rand(2,8)
			m_type = 1

//SHITTY EMOTES END

		if("z_roar")
			message = "<font color='red'><B>[src]</B> roars!</font>"
			m_type = 1
			call_sound_emote("z_roar")
		if("z_shout")
			message = "<font color='red'><B>[src]</B> shouts!</font>"
			m_type = 1
			call_sound_emote("z_shout")
		if("z_mutter")
			message = "<font color='red'><B>[src]</B> mutters!</font>"
			m_type = 1
			call_sound_emote("z_mutter")
		if("z_rawr")
			message = "<font color='red'><B>[src]</B> rawrs!</font>"
			m_type = 1

		if ("help")
			src << "blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough,\ncry, custom, deathgasp, drool, eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob, glare-(none)/mob,\ngrin, laugh, elaugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, raise, salute, shake, shiver, shrug,\nsigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, vomit, twitch_s, poo, pee, whimper,\nwink, yawn. For custom emotes use '*emote.'"

		else
			message = "<B>[src]</B> [sanitize(act)]"
			cooldown = 0





	if (message)
		message = sanitize_uni(message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			for (var/mob/O in get_mobs_in_view(world.view,src))
				O.show_message(message, m_type)
		else if (m_type & 2)
			for (var/mob/O in (hearers(src.loc, null) | get_mobs_in_view(world.view,src)))
				O.show_message(message, m_type)

		emote_cooldown += cooldown


/mob/living/carbon/human/proc/call_sound_emote(var/E)
	switch(E)
		if("scream")
			if (src.gender == "male")
				playsound(src.loc, pick('sound/voice/Screams_Male_1.ogg', 'sound/voice/Screams_Male_2.ogg', 'sound/voice/Screams_Male_3.ogg'), 50, 1)
			else
				playsound(src.loc, pick('sound/voice/Screams_Woman_1.ogg', 'sound/voice/Screams_Woman_2.ogg', 'sound/voice/Screams_Woman_3.ogg'), 50, 1)

		if("laugh")
			if (src.gender == "male")
				playsound(src.loc, pick('sound/voice/male_laugh_1.ogg', 'sound/voice/male_laugh_1.ogg', 'sound/voice/male_laugh_1.ogg'), 50, 1)
			else
				playsound(src.loc, pick('sound/voice/female_laugh_1.ogg', 'sound/voice/female_laugh_2.ogg'), 100, 1)

		if("fart")
			playsound(playsound(src.loc, 'fart.ogg', 65, 1))

		if("elaugh")
			playsound(src.loc, 'sound/voice/elaugh.ogg', 50, 1)

		if("z_roar")
			playsound(src.loc, 'sound/voice/z_roar.ogg', 50, 1)

		if("z_shout")
			playsound(src.loc, 'sound/voice/z_shout.ogg', 50, 1)

		if("z_mutter")
			playsound(src.loc, 'sound/voice/z_mutter.ogg', 50, 1)



/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  sanitize(input(usr, "This is [src]. \He is...", "Pose", null)  as text)


/mob/living/carbon/human/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Update Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=general'>General:</a> "
	HTML += TextPreview(flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=head'>Head:</a> "
	HTML += TextPreview(flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=face'>Face:</a> "
	HTML += TextPreview(flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=eyes'>Eyes:</a> "
	HTML += TextPreview(flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=torso'>Body:</a> "
	HTML += TextPreview(flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=arms'>Arms:</a> "
	HTML += TextPreview(flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=hands'>Hands:</a> "
	HTML += TextPreview(flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=legs'>Legs:</a> "
	HTML += TextPreview(flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='byond://?src=\ref[src];flavor_change=feet'>Feet:</a> "
	HTML += TextPreview(flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML +="<a href='?src=\ref[src];flavor_change=done'>\[Done\]</a>"
	HTML += "<tt>"
	src << browse(HTML, "window=flavor_changes;size=430x300")
