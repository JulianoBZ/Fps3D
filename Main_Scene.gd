extends Node2D

@onready var map_test = preload("res://Mapping/world.tscn").instantiate()

var placeholder_names = {
	Aspect
	Kraken
	Bender
	Lynch
	Big Papa
	Mad Dog
	Bowser
	O’Doyle
	Bruise
	Psycho
	Cannon
	Ranger
	Clink
	Ratchet
	Cobra
	Reaper
	Colt
	Rigs
	Crank
	Ripley
	Creep
	Roadkill
	Daemon
	Ronin
	Decay
	Rubble
	Diablo
	Sasquatch
	Doom
	Scar
	Dracula
	Shiver
	Dragon
	Skinner
	Fender
	Skull Crusher
	Fester
	Slasher
	Fisheye
	Steelshot
	Flack
	Surge
	Gargoyle
	Sythe
	Grave
	Trip
	Gunner
	Trooper
	Hash
	Tweek
	Hashtag
	Vein
	Indominus
	Void
	Ironclad
	Wardon
	Killer
	Wraith
	Knuckles
	Zero
	Steel
	Kevlar
	Lightning
	Tito
	Bullet-Proof
	Fire-Bred
	Titanium
	Hurricane
	Ironsides
	Iron-Cut
	Tempest
	Iron Heart
	Steel Forge
	Pursuit
	Steel Foil
	Sick Rebellious Names
	Upsurge
	Uprising
	Overthrow
	Breaker
	Sabotage
	Dissent
	Subversion
	Rebellion
	Insurgent
	Accidental Genius
	Acid Gosling
	Admiral Tot
	AgentHercules
	Airport Hobo
	Alley Frog
	Alpha
	AlphaReturns
	Angel
	AngelsCreed
	Arsenic Coo
	Atomic Blastoid
	Automatic Slicer
	Baby Brown
	Back Bett
	Bad Bunny
	Bazooka Har-de-har
	Bearded Angler
	Beetle King
	Betty Cricket
	Bit Sentinel
	Bitmap
	BlacKitten
	Blister
	Blistered Outlaw
	Blitz
	BloodEater
	Bonzai
	BoomBeachLuvr
	Boom Blaster
	Bootleg Taximan
	Bowie
	Bowler
	Breadmaker
	Broomspun
	Buckshot
	Bug Blitz
	Bug Fire
	Bugger
	Cabbie
	Candy Butcher
	Capital F
	Captain Peroxide
	Celtic Charger
	Centurion Sherman
	Cereal Killer
	Chasm Face
	Chew Chew
	Chicago Blackout
	Ballistic
	Furore
	Uproar
	Fury
	Ire
	Demented
	Wrath
	Madness
	Schizo
	Rage
	Savage
	Manic
	Frenzy
	Mania
	Derange
	CobraBite
	Cocktail
	CollaterolDamage
	CommandX
	Commando
	Congo Wire
	Cool Iris
	Cool Whip
	Cosmo
	Crash Override
	Crash Test
	Crazy Eights
	Criss Cross
	Cross Thread
	Cujo
	Cupid Dust
	Daffy Girl
	Dahlia Bumble
	Daisy Craft
	Dancing Madman
	Dangle
	DanimalDaze
	Dark Horse
	Darkside Orbit
	Darling Peacock
	Day Hawk
	Desert Haze
	Desperado
	Devil Blade
	Devil Chick
	Dexter
	Diamond Gamer
	Digger
	Disco Potato
	Disco Thunder
	DiscoMate
	Don Stab
	Doz Killer
	Dredd
	Drift Detector
	DriftManiac
	Drop Stone
	Dropkick
	Drugstore Cowboy
	DuckDuck
	Earl of Arms
	Easy Sweep
	Eerie Mizzen
	ElactixNova
	Elder Pogue
	Electric Player
	Electric Saturn
	Ember Rope
	Esquire
	ExoticAlpha
	EyeShooter
	Fabulous
	Fast Draw
	FastLane
	Father Abbot
	FenderBoyXXX
	Fennel Dove
	Feral Mayhem
	Fiend Oblivion
	Fifth Harmony
	Fire Feline
	Fire Fish
	FireByMisFire
	Fist Wizard
	Atilla
	Darko
	Terminator
	Conqueror
	Mad Max
	Siddhartha
	Suleiman
	Billy the Butcher
	Thor
	Napoleon
	Maximus
	Khan
	Geronimo
	Leon
	Leonidas
	Dutch
	Cyrus
	Hannibal
	Dux
	Mr. Blonde
	Agrippa
	Jesse James
	Matrix
	Bleed
	X-Skull
	Gut
	Nail
	Jawbone
	Socket
	Fist
	Skeleton
	Footslam
	Tooth
	Craniax
	Head-Knocker
	K-9
	Bone
	Razor
	Kneecap
	Cut
	Slaughter
	Soleus
	Gash
	Scalp
	Blood
	Scab
	Torque
	Torpedo
	Wildcat
	Automatic
	Cannon
	Hellcat
	Glock
	Mortar
	Tomcat
	Sniper
	Siege
	Panther
	Carbine
	Bullet
	Jaguar
	Javelin
	Aero
	Bomber
	Howitzer
	Albatross
	Strike Eagle
	Gatling
	Arsenal
	Rimfire
	Avenger
	Hornet
	Centerfire
	Hazzard
	Grizzly
	Wolverine
	Deathstalker
	Snake
	Wolf
	Scorpion
	Vulture
	Claw
	Boom slang
	Falcon
	Fang
	Viper
	Ram
	Grip
	Sting
	Boar
	Black Mamba
	Lash
	Tusk
	Goshawk
	Gnaw
	Polar Bee
	Poppy Coffee
	Poptart AK47
	Prometheus
	Psycho Thinker
	Pusher
	Racy Lion
	Radioactive an
	Raid Bucker
	Rando Tank
	Ranger
	Red Combat
	Red Rhino
	RedFeet
	RedFisher
	RedMouth
	Reed Lady
	Renegade Slugger
	Reno Monarch
	Returns
	RevengeOfOmega
	Riff Raff
	Roadblock
	Roar Sweetie
	Rocky Highway
	Roller Turtle
	Romance Guppy
	Rooster
	Rude Sniper
	Saint La-Z-Boy
	Sandbox
	Scare Stone
	ScaryNinja
	Scary Pumpkin
	Scrapper
	Scrapple
	Screw
	Screwtape
	Seal Snake
	Shadow Bishop
	Shadow Chaser
	Sherwood Gladiator
	Shooter
	ShowMeSunset
	ShowMeUrguts
	Sidewalk Enforcer
	Sienna Princess
	Silver Stone
	Sir Shove
	Skull Crusher
	Sky Bully
	Sky Herald
}

func _on_button_pressed():
	get_parent().add_child(map_test)
	self.hide()
