#define ADD_STAT(stat,n) stat += n
#define REDUCE_STAT(stat,n) stat -= n
#define CHANGE_STAT(stat,n) stat = n

/mob/living/carbon
	var/datum/skills/my_skills = null
	proc
		init_skills()
			var/datum/skills/newSkills = new
			newSkills.host = src
			newSkills.rand_stats()
			my_skills = newSkills

/datum/skills
	var/mob/living/carbon/host = null
	var/combat = 0
	var/physical = 0
	var/movement = 0
	var/mental = 0
	proc
		rand_stats()
			CHANGE_STAT(combat,rand(-2,2))
			CHANGE_STAT(physical,rand(-2,2))
			CHANGE_STAT(movement,rand(-2,2))
			CHANGE_STAT(mental,rand(0,2))

		job_stats(var/job)
			if(job)
				switch(job)
					if("Unassigned")
						CHANGE_STAT(combat,rand(0,1))
						CHANGE_STAT(physical,0)
						CHANGE_STAT(movement,0)
						CHANGE_STAT(mental,rand(0,1))
						return
					if("Captain")
						CHANGE_STAT(combat,rand(1,2))
						CHANGE_STAT(physical,1)
						CHANGE_STAT(movement,rand(0,1))
						CHANGE_STAT(mental,1)
						return
					if("Head of Personnel")
						CHANGE_STAT(combat,rand(-1,1))
						CHANGE_STAT(physical,1)
						CHANGE_STAT(movement,1)
						CHANGE_STAT(mental,2)
						return
					if("Bartender"||"Chef"||"Botanist"||"Quartermaster"||"Librarian")
						CHANGE_STAT(combat,rand(-1,1))
						CHANGE_STAT(physical,0)
						CHANGE_STAT(movement,rand(0,1))
						CHANGE_STAT(mental,rand(-1,0))
						return
					if("Cargo Technician"||"Shaft Miner"||"Janitor")
						CHANGE_STAT(combat,rand(0,1))
						CHANGE_STAT(physical,rand(1,2))
						CHANGE_STAT(movement,rand(0,1))
						CHANGE_STAT(mental,rand(-1,0))
						return
					if("Vessel Engineer"||"Atmospheric Technician")
						CHANGE_STAT(combat,rand(0,1))
						CHANGE_STAT(physical,rand(1,2))
						CHANGE_STAT(movement,0)
						CHANGE_STAT(mental,rand(0,1))
						return
					if("Chief Engineer")
						CHANGE_STAT(combat,rand(1,2))
						CHANGE_STAT(physical,rand(1,2))
						CHANGE_STAT(movement,1)
						CHANGE_STAT(mental,2)
						return
					if("Medical Doctor"||"Chemist"||"Geneticist"||"Virologist")
						CHANGE_STAT(combat,-1)
						CHANGE_STAT(physical,0)
						CHANGE_STAT(movement,1)
						CHANGE_STAT(mental,2)
						return
					if("Chief Medical Officer"||"Research Director")
						CHANGE_STAT(combat,-1)
						CHANGE_STAT(physical,rand(0,1))
						CHANGE_STAT(movement,rand(0,2))
						CHANGE_STAT(mental,rand(2,3))
						return
					if("Scientist"||"Roboticist")
						CHANGE_STAT(combat,0)
						CHANGE_STAT(physical,rand(-1,1))
						CHANGE_STAT(movement,rand(-1,1))
						CHANGE_STAT(mental,rand(1,2))
						return
					if("Head of Security"||"Warden")
						CHANGE_STAT(combat,rand(2,3))
						CHANGE_STAT(physical,2)
						CHANGE_STAT(movement,rand(0,2))
						CHANGE_STAT(mental,rand(0,2))
						return
					if("Detective")
						CHANGE_STAT(combat,1)
						CHANGE_STAT(physical,rand(0,1))
						CHANGE_STAT(movement,rand(1,2))
						CHANGE_STAT(mental,rand(1,3))
						return
					if("Security Officer")
						CHANGE_STAT(combat,2)
						CHANGE_STAT(physical,rand(2,3))
						CHANGE_STAT(movement,rand(-1,0))
						CHANGE_STAT(mental,rand(-2,0))
						return