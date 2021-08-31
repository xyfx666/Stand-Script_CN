-------------------------------------------------------------------WiriScript v5---------------------------------------------------------------------------------------
--[[ Thanks to
		
		MrPainKiller for the name suggestion,
		Koda,
		ICYPhoenix,
		jayphen,
		Fwishky,
		Sainan

		and testers: 
		
		komt, <3
		Ren, 
		NONECKED

and all other developers who shared their work and nice people who helped me. All of you guys teached me things I used in this script <3.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
This is an open code for you to use and share. Feel free to add, modify or remove features as long as you don't try to sell this script. Please consider 
sharing your own versions with Stand's community.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
To have 'Detach Entities' installed would be a good idea. You don't want a monkey attached to a player forever. :D I didn't include detach options cuz
such a nice script exists. --]]
-------------------------------------------------------------------by: nowiry------------------------------------------------------------------------------------------

require("natives-1627063482")
json = require("json")
script = {}

local audible = true
local shake, delay = 1, 300 --default shake camera and loop delay
local ped_weapon, ped_type = "weapon_pistol", "s_f_y_cop_01" --these are the default weapon and appearance for attackers
local scriptdir = filesystem.scripts_dir()
local owned = false
local cage_type = 1
local spoofname, spoofrid = true, true
local standlike
local version = "5"
local spawned_attackers = {}

util.async_http_get("pastebin.com", "/raw/EhH1C6Dh", function(output)
    if version < output then
        shownotification("~r~WiriScript v"..output.." is available")
    end
end,
function ()
    util.log("[WiriScript] Failed to check for updates.")
end)

function game_notification(message)
	GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT("DIA_ZOMBIE1", 0)
	while not GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED("DIA_ZOMBIE1") do
		util.yield()
	end
	util.BEGIN_TEXT_COMMAND_THEFEED_POST(message..".")

	local tittle = "WiriScript"
	local subtitle = "~c~Notification"
	HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT("DIA_ZOMBIE1", "DIA_ZOMBIE1", true, 4, tittle, subtitle)

	HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(true, false)
end

function stand_notification(message)
	util.toast(tostring(message.."."), TOAST_ABOVE_MAP)
end

function shownotification(message)
	if not standlike then
		game_notification(message)
	else
		message = "[WiriScript] "..message
		stand_notification(message)
	end
end

local weapons = {						--here you can modify which weapons are available to choose
	["Pistol"] = "weapon_pistol", --['name shown in Stand'] =  'weapon ID'
	["Stun Gun"] = "weapon_stungun",
	["Up-n-Atomizer"] =  "weapon_raypistol",
	["Special Carabine"] = "weapon_specialcarbine",
	["Pump Shotgun"] = "weapon_pumpshotgun",
	["Combat MG"] = "weapon_combatmg",
	["Heavy Sniper"] = "weapon_heavysniper",
	["Minigun"] = "weapon_minigun",
	["RPG"] = "weapon_rpg"
}
local random_weapons = {
	"weapon_pistol",
	"weapon_specialcarbine", 
	"weapon_combatmg",
	"weapon_pumpshotgun",
	"weapon_assaultrifle", 
	"weapon_microsmg"
}

local melee_weapons = {
	["Unarmed"] = "weapon_unarmed", --['name shown in Stand'] = 'weapon ID'
	["Knife"] = "weapon_knife",
	["Machete"] = "weapon_machete",
	["Battle Axe"] = "weapon_battleaxe",
	["Wrench"] = "weapon_wrench",
	["Hammer"] = "weapon_hammer",
	["Baseball Bat"] = "weapon_bat"
}

local peds = {									--here you can modify which peds are available to choose
	["Prisoner"] =  "s_m_y_prismuscl_01", --['name shown in Stand'] = 'ped model ID'
	["Mime"] = "s_m_y_mime",
	["Astronaut"] = "s_m_m_movspace_01",
	["Black Ops Soldier"] = "s_m_y_blackops_01",
	["SWAT"] = "s_m_y_swat_01",
	["Ballas Ganster"] =  "csb_ballasog",
	["Female Police Officer"] =  "s_f_y_cop_01",
	["Male Police Officer"] = "s_m_y_cop_01",
	["Jesus"] = "u_m_m_jesus_01",
	["Zombie"] = "u_m_y_zombie_01",
	["Juggernaut"] = "u_m_y_juggernaut_01",
	["Clown"] = "s_m_y_clown_01"
}

local random_peds = {				--add models here if you want
	"s_m_y_prismuscl_01",
	"s_m_y_mime",
	"s_m_m_movspace_01",
	"s_m_y_blackops_01",
	"s_m_y_swat_01",
	"csb_ballasog",
	"cs_movpremf_01",
	"a_f_m_prolhost_01",
	"g_m_y_ballasout_01",
	"g_m_y_lost_02",
	"g_m_y_ballaeast_01",
	"s_f_y_cop_01",
	"ig_claypain",
	"u_m_m_jesus_01",
	"u_m_y_rsranger_01",
	"u_m_y_imporage",
	"u_m_y_zombie_01",
	"u_m_y_juggernaut_01",
	"s_m_y_clown_01",
	"s_m_y_cop_01"
}

local gunner_weapon_list = {              --these are the buzzard's gunner weapons. You can include some (make sure gunners can use them from heli :O)
	["Combat MG"] = "weapon_combatmg",
	["RPG"] = "weapon_rpg"
}

function set_ent_face_ent(ent1, ent2) --All credits to Ren for suggesting me this function
	local pos1 = ENTITY.GET_ENTITY_COORDS(ent1)
	local pos2 = ENTITY.GET_ENTITY_COORDS(ent2)
	local dx = pos2.x - pos1.x
	local dy = pos2.y - pos1.y
	local heading = MISC.GET_HEADING_FROM_VECTOR_2D(dx, dy)
	return ENTITY.SET_ENTITY_HEADING(ent1, heading)
end

function explode(pid, type, owned)
	local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
	pos.z = pos.z-0.9
	if not owned then
		FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, type, 1000, audible, invisible, shake, false)
	else
		FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), pos.x, pos.y, pos.z, type, 1000, audible, invisible, shake, true)
	end
end

function cage_player(pos, type)
	pos.z = pos.z - 0.9
	local object = {}
	local object_name ={
		"prop_gold_cont_01b",
		"prop_rub_cage01a"
	}
	local hash = util.joaat(object_name[type])
	STREAMING.REQUEST_MODEL(hash)
	while not STREAMING.HAS_MODEL_LOADED(hash) do
		util.yield()
	end
	object[1] = OBJECT.CREATE_OBJECT(hash, pos.x, pos.y, pos.z, true, true, true) --why do you think I spawned the same object twice? lol --just one of these objects is useless
	if type == 2 then
		pos.z = pos.z + 2.2
	end
	object[2] = OBJECT.CREATE_OBJECT(hash, pos.x, pos.y, pos.z, true, true, true)
	for k, v in pairs(object) do
		if v == 0 then --if 'CREATE_OBJECT' fails to create one of the objects
			shownotification("~r~Something went wrong creating cage")
			return
		end
		ENTITY.FREEZE_ENTITY_POSITION(v, true)
	end
	local rot  = ENTITY.GET_ENTITY_ROTATION(object[2])
	if type == 1 then
		rot.z = 180
	end
	if type == 2 then
		rot.x = -180
		rot.z = 90
	end
	ENTITY.SET_ENTITY_ROTATION(object[2], rot.x,rot.y,rot.z,1,true)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
end

function add_model_to_list(list, model)
	for k, v in pairs(list) do
		if v == model then return end
	end
	table.insert(list, model)
end

function spawn_attacker(pid, model, ped_weapon, godmode, stationary)
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
	pos.z = pos.z - 0.9
	pos.x  = pos.x + math.random(-3, 3)
	pos.y = pos.y + math.random(-3, 3)
	local re_group
	local ped_hash = util.joaat(model); local weapon_hash = util.joaat(ped_weapon)
	STREAMING.REQUEST_MODEL(ped_hash)
	while not STREAMING.HAS_MODEL_LOADED(ped_hash) do
		util.yield()
	end
	local ped = util.create_ped(0, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z); add_model_to_list(spawned_attackers, model)
	ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ped, true, true)
	set_ent_face_ent(ped, player_ped)
	WEAPON.GIVE_WEAPON_TO_PED(ped, weapon_hash, 9999, true, true)
	ENTITY.SET_ENTITY_INVINCIBLE(ped, godmode)
	PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
	TASK.TASK_COMBAT_PED(ped, player_ped, 0, 16)
	if stationary then
		PED.SET_PED_COMBAT_MOVEMENT(ped, 0)
	end
	PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, 1)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
	if not PED._DOES_RELATIONSHIP_GROUP_EXIST(re_group) then
		local re_group_ptr = memory.alloc(32); PED.ADD_RELATIONSHIP_GROUP("re_group", re_group_ptr); local re_group = memory.read_int(re_group_ptr); memory.free(re_group_ptr)
	end
	PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, re_group)
	return re_group
end 

function shoot_owned_bullet(pid, weaponID, damage)
	local user = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local target = PED.GET_PED_BONE_COORDS(player_ped, 0xe0fd, 0.4, 0, 0)
	local spawn_pos = CAM.GET_GAMEPLAY_CAM_COORD()
	local weapon_hash = util.joaat(weaponID)
	WEAPON.REQUEST_WEAPON_ASSET(weapon_hash, 31, 26)
	while not WEAPON.HAS_WEAPON_ASSET_LOADED(weapon_hash) do
		util.yield()
	end
	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(spawn_pos.x, spawn_pos.y, spawn_pos.z, target.x , target.y, target.z, damage, 0, weapon_hash, user, true, false, -1.0)
end

function add_blip_for_entity(entity, blipSprite, colour)
	local blip_ptr = memory.alloc()
	local blip = HUD.ADD_BLIP_FOR_ENTITY(entity)
	memory.write_int(blip_ptr, blip)
	HUD.SET_BLIP_SPRITE(blip, blipSprite)
	HUD.SET_BLIP_COLOUR(blip, colour)
	HUD.SHOW_HEIGHT_ON_BLIP(blip, false)
	HUD.SET_BLIP_ROTATION(blip, SYSTEM.CEIL(ENTITY.GET_ENTITY_HEADING(entity)))
	util.create_thread(function()
		while ENTITY.GET_ENTITY_HEALTH(entity) > 0 do
			HUD.SET_BLIP_ROTATION(blip, SYSTEM.CEIL(ENTITY.GET_ENTITY_HEADING(entity)))
			util.yield()
		end
		HUD.SET_BLIP_DISPLAY(blip, 0)
		HUD.REMOVE_BLIP(memory.read_int(blip_ptr))
		memory.free(blip_ptr)
		util.stop_thread()
	end)
	return blip
end

function spawn_buzzard(pid, gunner_weapon, buzzard_godmode, buzzard_visible)
	local player_ped =  PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
	pos.x = pos.x + math.random(-20, 20)
	pos.y = pos.y + math.random(-20, 20)
	pos.z = pos.z + math.random(20, 40)
	local heli_hash = util.joaat("buzzard2")
	local ped_hash = util.joaat("s_m_y_blackops_01")
	STREAMING.REQUEST_MODEL(ped_hash)
	STREAMING.REQUEST_MODEL(heli_hash)
	while not STREAMING.HAS_MODEL_LOADED(ped_hash) or not STREAMING.HAS_MODEL_LOADED(heli_hash) do
		util.yield()
	end
	local relHash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(player_ped)
	local heli = util.create_vehicle(heli_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
	if not ENTITY.DOES_ENTITY_EXIST(heli) then 
		shownotification("~r~Failed to create buzzard. Please try again")
		return
	end
	ENTITY.SET_ENTITY_AS_MISSION_ENTITY(heli, true, true)
	ENTITY.SET_ENTITY_INVINCIBLE(heli, buzzard_godmode)
	ENTITY.SET_ENTITY_VISIBLE(heli, buzzard_visible, 0)	
	VEHICLE.SET_VEHICLE_ENGINE_ON(heli, true, true, true)
	VEHICLE.SET_HELI_BLADES_FULL_SPEED(heli)
	local blip = add_blip_for_entity(heli, 422, 35)

	local function create_ped_into_vehicle(seat)
		local pedNetId = NETWORK.PED_TO_NET(util.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z))
		if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(NETWORK.NET_TO_PED(pedNetId)) then
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(pedNetId, true)
		end
		NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(pedNetId, players.user(), true)
		local ped = NETWORK.NET_TO_PED(pedNetId)
		PED.SET_PED_INTO_VEHICLE(ped, heli, seat)
		WEAPON.GIVE_WEAPON_TO_PED(ped, util.joaat(gunner_weapon) , 9999, false, true)
		PED.SET_PED_COMBAT_ATTRIBUTES(ped, 20, true)
		PED.SET_PED_MAX_HEALTH(ped, 500)
		ENTITY.SET_ENTITY_HEALTH(ped, 500)
		ENTITY.SET_ENTITY_INVINCIBLE(ped, buzzard_godmode)
		ENTITY.SET_ENTITY_VISIBLE(ped, buzzard_visible, 0)
		PED.SET_PED_SHOOT_RATE(ped, 1000)
		PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, util.joaat("ARMY"))
		TASK.TASK_COMBAT_HATED_TARGETS_AROUND_PED(ped, 1000, 0)
		return pedNetId
	end

	local pilot = NETWORK.NET_TO_PED(create_ped_into_vehicle(-1))
	PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pilot, true)
	for seat = 1, 2 do
		create_ped_into_vehicle(seat)
	end

	local function give_task_to_pilot(param0, param1)
		if param1 ~= param0 then
			if param0 == 0 then
				TASK.TASK_HELI_CHASE(pilot, player_ped, 0, 0, 50)
				PED.SET_PED_KEEP_TASK(pilot, true)
			end
			if param0 == 1 then
				TASK.TASK_HELI_MISSION(pilot, heli, 0, player_ped, 0.0, 0.0, 0.0, 23, 30.0, -1.0, -1.0, 10.0, 10.0, 5.0, 0)
				PED.SET_PED_KEEP_TASK(pilot, true)
			end
		end
		return param0
	end
	
	util.create_thread(function()
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(5, util.joaat("ARMY"), relHash)
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(5, relHash, util.joaat("ARMY"))
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, util.joaat("ARMY"), util.joaat("ARMY"))
	end)

	util.create_thread(function()
		local param0, param1
		flee_buzzard = false
		while ENTITY.GET_ENTITY_HEALTH(pilot) > 0 do
			local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
			local a, b = ENTITY.GET_ENTITY_COORDS(player_ped), ENTITY.GET_ENTITY_COORDS(heli)
			if MISC.GET_DISTANCE_BETWEEN_COORDS(a.x, a.y, a.z, b.x, b.y, b.z, true) > 90 then
				param0 = 0
			else
				param0 = 1
			end
			param1 = give_task_to_pilot(param0, param1)
			util.yield()
		end
		util.stop_thread()
	end)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(heli_hash)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
end	

function request_control_ent(entity)
	if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) then
		local netId = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(entity); NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netId, true)
		NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
	end
	return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity)
end

function get_nearby_entities(pid, radius, peds, vehicles)
	local entities = {}
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
	local player_veh = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
	util.create_thread(function()
		if vehicles then
			for key, vehicle in pairs(util.get_all_vehicles()) do
				local veh_pos = ENTITY.GET_ENTITY_COORDS(vehicle)
				if vehicle ~= player_veh then
					if MISC.GET_DISTANCE_BETWEEN_COORDS(pos.x, pos.y, pos.z, veh_pos.x, veh_pos.y, veh_pos.z, true) <= radius then
						table.insert(entities, vehicle)	
					end
				end
			end
		end
	end)
	util.create_thread(function()
		if peds then
			for key, ped in pairs(util.get_all_peds()) do
				if ped ~= player_ped then
					local ped_pos = ENTITY.GET_ENTITY_COORDS(ped)
					if MISC.GET_DISTANCE_BETWEEN_COORDS(pos.x, pos.y, pos.z, ped_pos.x, ped_pos.y, ped_pos.z, true) <= radius and not PED.IS_PED_A_PLAYER(ped) then 
						table.insert(entities, ped)
					end
				end
			end
		end
	end)
	util.create_thread(function()
		for key, entity in pairs(entities) do
			local entity_pos = ENTITY.GET_ENTITY_COORDS(entity)
			if MISC.GET_DISTANCE_BETWEEN_COORDS(pos.x, pos.y, pos.z, entity_pos.x, entity_pos.y, entity_pos.z, true) >= radius then
				entities[key] = nil
			end
		end
	end)
	return entities
end

local function delete_entities_by_model(model)
	local hash = util.joaat(model)
	if STREAMING.IS_MODEL_A_VEHICLE(hash) then
		for k, vehicle in pairs(util.get_all_vehicles()) do
			if ENTITY.GET_ENTITY_MODEL(vehicle) == hash then
				for k, ped in pairs(util.get_all_peds()) do
					if PED.GET_VEHICLE_PED_IS_IN(ped, true) == vehicle then
						if not PED.IS_PED_A_PLAYER(ped) then
							ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ped, false, false); util.delete_entity(ped)
						else
							goto continue
						end
					end
				end
				ENTITY.SET_ENTITY_AS_MISSION_ENTITY(vehicle, false, false); util.delete_entity(vehicle)
				::continue::
			end
		end
		return
	end
	if STREAMING.IS_MODEL_A_PED(hash) then
		for k, ped in pairs(util.get_all_peds()) do
			if ENTITY.GET_ENTITY_MODEL(ped) == hash then
				if not PED.IS_PED_A_PLAYER(ped) then
					ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ped, false, false); util.delete_entity(ped)
				end
			end
		end
		return
	end
	for k, object in pairs(util.get_all_objects()) do
		if ENTITY.GET_ENTITY_MODEL(object) == hash then
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(object, false, false); util.delete_entity(object)
		end
	end
end

--------------------------------------------OPENING CREDITS----------------------------------------------------

function AddTextToSingleLine(scaleform, text, font, colour)
	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "ADD_TEXT_TO_SINGLE_LINE")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(text)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(font)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING(colour)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL(true)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
end
AUDIO.SET_AUDIO_FLAG("LoadMPData", true)

local sounds = {
	{"Out_Of_Ammo", "DLC_AW_Machine_Gun_Ammo_Counter_Sounds"},
	{"End_Squelch", "CB_RADIO_SFX"}
}
util. create_thread(function()
	j = math.random(1, #sounds)
	AUDIO.PLAY_SOUND_FRONTEND(-1, sounds[j][1], sounds[j][2], true)
	util.yield(800)
	AUDIO.PLAY_SOUND_FRONTEND(-1, "DiggerRevOneShot", "BulldozerDefault", true)

	local startTime = os.time()
	scaleform = GRAPHICS.REQUEST_SCALEFORM_MOVIE("OPENING_CREDITS")
	while not GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED(scaleform) do
		util.yield()
	end

	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SETUP_SINGLE_LINE")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(0.5)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(0.5)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(70)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(125)
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("left")
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

	AddTextToSingleLine(scaleform, "a", "$font5", "HUD_COLOUR_MICHAEL")
	AddTextToSingleLine(scaleform, "nowiry", "$font2", "HUD_COLOUR_WHITE")
	AddTextToSingleLine(scaleform, "production: ", "$font5", "HUD_COLOUR_MICHAEL")
	AddTextToSingleLine(scaleform, "wiriscript", "$font2", "HUD_COLOUR_TREVOR")
	AddTextToSingleLine(scaleform, "v"..version, "$font5", "HUD_COLOUR_WHITE")

	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SHOW_SINGLE_LINE")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()

	GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleform, "SHOW_CREDIT_BLOCK")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_TEXTURE_NAME_STRING("presents")
	GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_FLOAT(0.5)
	GRAPHICS.END_SCALEFORM_MOVIE_METHOD()	

	while os.time() - startTime <= 8 do
    	GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scaleform, 255, 255, 255, 255, 0)
   		util.yield(1)
	end
end)

---------------------------------------------------------------------------------------------------------------

local function get_rid(pid)
	handle_ptr = memory.alloc(104)
   	NETWORK.NETWORK_HANDLE_FROM_PLAYER(pid, handle_ptr, 13)
  	local rid = NETWORK.NETWORK_MEMBER_ID_FROM_GAMER_HANDLE(handle_ptr)
  	memory.free(handle_ptr)
  	return rid
end

-----------------------------------------------------SETTINGS--------------------------------------------------

settings = menu.list(menu.my_root(), "Settings", {}, "")

menu.divider(settings, "Settings")

local display = true
menu.toggle(settings, "Display Health Info When Modding Health", {}, "", function(on)
	display = on
end, true)

menu.toggle(settings, "Use Stand's notifications", {}, "Allows you to return to Stand's notification appearance", function(on)
	standlike = on
end)
local config_list = {
	['controls'] = {
		['Vehicle Weapons'] = 86,
		['Airstrike Aircraft'] = 86
	},
	['driving style'] = {
		['Bandito Driving Style'] = 1074528293
	}
}
local controls = {
	['X'] = 73,
	['G'] = 113,
	['Mouse R'] = 70,
	['Mouse L'] = 69,
	['E'] = 86
}
local numpad_controls = {
	['Numpad 4'] = 108,
	['Numpad 5'] = 110,
	['Numpad 6'] = 107,
	['Numpad 7'] = 117,
	['Numpad 8'] = 111,
	['Numpad 9'] = 118,
	['Numpad +'] = 96,
	['Numpad -'] = 97
}
local control_settings = menu.list(settings, "Controls", {}, "")
menu.divider(control_settings, "Controls")

menu.action(control_settings, "Save Control Config", {}, "", function()
	save_config()
end)

for key, option in pairs(config_list['controls']) do
	local option_name = key
	local listname =  menu.list(control_settings, option_name, {}, "")
	menu.divider(listname, "Control: "..option_name)
	for k, control in pairs(controls) do
		menu.action(listname, k, {}, "", function()
			config_list['controls'][option_name] = control
			shownotification(option_name.." : ~r~"..k.."~s~")
		end)
	end
	local numpad_control_list = menu.list(listname, "Numpad", {}, "")
	menu.divider(numpad_control_list, 'Numpad')
	for k, control in pairs(numpad_controls) do
		menu.action(numpad_control_list, k, {}, "", function()
			config_list['controls'][option_name] = control
			shownotification(option_name.." : ~r~"..k.."~s~")
		end)
	end
end

local config_load_data = (scriptdir.."\\WiriScript\\config.data")

function save_config()
	config_data = io.open(config_load_data, "w")
	config_data:write(json.encode(config_list).."\n")
	config_data:close()
	shownotification("Config saved")
end

function profiles_load()
	if not filesystem.exists(config_load_data) then return end
	for line in io.lines(config_load_data) do config_list = json.decode(line) end
end
profiles_load()

local driving_style_flag = {
	['Stop Before Vehicles'] = 1,
	['Stop Before Peds'] = 2,
	['Avoid Vehicles'] = 4,
	['Avoid Empty Vehicles'] = 8,	
	['Avoid Peds'] = 16,
	['Avoid Objects'] = 32,
	['Stop At Traffic Lights'] = 128,
	['Reverse Only'] = 1024,
	['Take Shortest Path'] = 262144,
	['Ignore Roads'] = 4194304,
	['Ignore All Pathing'] = 16777216
}

local selected_flags = {}
local menu_driving_style = menu.list(settings, "Bandito Driving Style")

menu.divider(menu_driving_style, "Bandito Driving Style")

menu.action(menu_driving_style, "Save Driving Style", {}, "", function()
	save_config()
end)

menu.divider(menu_driving_style, "Presets")

local presets = {
	{'Normal', 'Stop before vehicles, stop before peds, avoid empty vehicles, avoid objects and stop at traffic lights.', 786603},
	{'Ignore Lights', 'Stop before vehicles, avoid vehicles and avoid objects.', 2883621},
	{'Avoid Traffic', 'Avoid vehicles and avoid objects.', 786468},
	{'Rushed', 'Stop before vehicles, avoid vehicles, avoid objects. Recommended.', 1074528293}
}

local bandito_drive_style
for j = 1, #presets do
	menu.action(menu_driving_style, presets[j][1], {}, presets[j][2], function()
		config_list['driving style']['Bandito Driving Style'] = presets[j][3]
		shownotification("Bandito driving style: ~r~"..config_list['driving style']['Bandito Driving Style'].."~s~")
	end)
end

menu.divider(menu_driving_style, "Custom")

for k, flag in pairs(driving_style_flag) do
	menu.toggle(menu_driving_style, k, {}, "", function(on) 
		local toggle = on
		if toggle then
			table.insert(selected_flags, flag)
		else
			for j = 1, #selected_flags do
				if selected_flags[j] == flag then
					selected_flags[j] = nil
				end
			end
		end
	end)
end

menu.action(menu_driving_style, "Set Custom Driving Style", {}, "", function()
	local style = 0
	for k, v in pairs(selected_flags) do
		style = style + v
	end
	config_list['driving style']['Bandito Driving Style'] = style
	shownotification("Bandito driving style: ~r~"..config_list['driving style']['Bandito Driving Style'].."~s~")
end)
-------------------------------------------------SAVE NAME STUFF*----------------------------------------------

local namedata = {}
nameloaddata = (scriptdir.."\\savednames.data")

function namesload()
	if not filesystem.exists(nameloaddata) then return end
	local savednames = menu.list(menu.my_root(), "Saved Names", {}, "")

	local function add_name_to_savednames(name)
		menu.action(savednames, name, {}, "Click to paste name in Online/Spoofing/Name Spoofing/Spoofed Name. You should use Stand\'s 'Get Spoofed RID From Spoofed Name' option before RID spoofing.", function() 
			menu.trigger_commands("spoofedname "..name)
			shownotification("Spoofed name: ~r~"..name.."~s~")
		end)
	end
	
	menu.divider(savednames,"Saved Names")
    for line in io.lines(nameloaddata) do namedata[#namedata + 1] = line end
    for i = 1, #namedata do
    	add_name_to_savednames(namedata[i])
	end
	shownotification("Saved names loaded: ~r~"..#namedata.."~s~")
end
namesload()

--------------------------------------------SPOOFING PROFILE STUFF------------------------------------------------

local profiles = menu.list(menu.my_root(), "Spoofing Profiles", {}, "")
local usingprofile = false

menu.action(profiles, "Disable Current Spoofing Profile", {}, "", function()
	if usingprofile then 
		menu.trigger_commands("spoofname off")
		menu.trigger_commands("spoofrid off")
		shownotification("Spoofing profile disabled. You will need to change sessions for others to see the change")
		usingprofile = false
	else
		shownotification("~r~You are not using any spoofing profile")
	end
end)

local profiles_list = {}
local profiles_command_ids = {}
wiriscript_folder = (scriptdir.."\\WiriScript")
-----------------------------
--WiriScript folder exists? 
-----------------------------
if not filesystem.exists(wiriscript_folder) then
	shownotification("~r~WiriScript folder does not exist. Please drag it into Lua Scripts from the file you downloaded in order to use WiriScript")
	util.stop_script()
end
-----------------------------
profiles_load_data = (scriptdir.."\\WiriScript\\Profiles.data")

function add_profile_to_list(array)
	local name = array.name
	local rid = array.rid
	local click_counter = 1
	local j = #profiles_command_ids + 1
	profile_actions = menu.list(profiles, name, {}, "")
	profiles_command_ids[j] = profile_actions
	menu.divider(profile_actions, name)
	
	menu.action(profile_actions, "Enable Spoofing Profile", {}, "", function()
		usingprofile = true 
		if spoofname then
			menu.trigger_commands("spoofedname "..name)
			menu.trigger_commands("spoofname on")
		end
		if spoofrid then
			menu.trigger_commands("spoofedrid "..rid)
			menu.trigger_commands("spoofrid hard")
		end
		shownotification("Profile applied: ~r~"..name.."~s~. You will need to change sessions for others to see the change")
	end)

	menu.action(profile_actions, "Delete", {}, "", function()
		if click_counter == 1 then
			shownotification("~r~Are you sure you want to delete this spoofing profile? Click again to proceed")
			util.yield(2500)
			click_counter = click_counter + 1
			return
		end
		profiles_data = io.open(profiles_load_data, "w")
		for k, profile in pairs(profiles_list) do
			if profile ~= array then
				profiles_data:write(json.encode(profile).."\n")
			end
		end
		for k, profile in pairs(profiles_list) do
			if profile == array then
				profiles_list[k] = nil
			end
		end
		menu.delete(profiles_command_ids[j])
		profiles_data:close()
		menu.trigger_commands("clearnotifications")
	end)
	
	menu.divider(profile_actions, "Spoof Options")
	menu.toggle(profile_actions, "Name", {}, "", function(on)
		spoofname = on
	end, true)
	menu.toggle(profile_actions, "SCID: "..rid, {}, "", function(on)
		spoofrid = on
	end, true)
end

function save_spoofing_profile(name, scid)
	local i = #profiles_list + 1
	if not filesystem.exists(profiles_load_data) or #profiles_list == 0 or profiles_list[1] == "" then
		profiles_list[i] = {name = name, rid = scid}
		profiles_data = io.open(profiles_load_data, "w")
		profiles_data:write(json.encode(profiles_list[i]).."\n")
		profiles_data:close()
		add_profile_to_list(profiles_list[i])
		shownotification("Spoofing profile created: ~r~"..profiles_list[i].name.."~s~")
	else
		for k, v in pairs(profiles_list) do 
			if profiles_list[k].name == name or profiles_list[k].rid == scid then 
				shownotification("~r~The spoofing profile already exists")
				return
			end
		end
		profiles_list[i] = {name = name, rid = scid}
		profiles_data = io.open(profiles_load_data, "a")
		profiles_data:write(json.encode(profiles_list[i]).."\n")
		profiles_data:close()
		add_profile_to_list(profiles_list[i])
		shownotification("Spoofing profile created: ~r~"..profiles_list[i].name.."~s~")
	end
end

-----------------------------------
--ADD SPOOFING PROFILE
-----------------------------------

local newname
local newrid
local newprofile = menu.list(profiles, "Add Profile", {}, "Allows you to manually create a new spoofing profile.")
menu.divider(newprofile, "Create New")

menu.action(newprofile, "Name", {"profilename"}, "Type the profile's name.", function()
	if newname ~= nil then 
		menu.show_command_box("profilename "..newname)
	else
		menu.show_command_box("profilename ")
	end
end, function(name)
	newname = name
end)

menu.action(newprofile, "SCID", {"profilerid"}, "Type then profile's SCID.", function()
	if newrid ~= nil then 
		menu.show_command_box("profilerid "..newrid)
	else
		menu.show_command_box("profilerid ")
	end
end, function(rid)
	newrid = rid
end)

menu.action(newprofile, "Save Spoofing Profile", {}, "", function()
	if newname == nil or newrid == nil then
		shownotification("~r~Name and SCID are required")
		return
	end
	save_spoofing_profile(newname, newrid)
end)
----------------------------------------

menu.divider(profiles, "Spoofing Profiles")

function profilesload()
	if not filesystem.exists(profiles_load_data) then return end
	for line in io.lines(profiles_load_data) do profiles_list[#profiles_list + 1] = json.decode(line) end
	for i = 1, #profiles_list do
		add_profile_to_list(profiles_list[i])
	end
	shownotification("Spoofing profiles loaded: ~r~"..#profiles_list.."~s~")
end
profilesload()

-------------------------------------------------------------------------------------------------------------------------
GenerateFeatures = function(pid)
	menu.divider(menu.player_root(pid),"WiriScript")		
	
----------------------------------------------CREATE SPOOFING PROFILE----------------------------------------------------

	menu.action(menu.player_root(pid), "Create Spoofing Profile", {}, "", function()
		local player_name = PLAYER.GET_PLAYER_NAME(pid)
		local player_rid = get_rid(pid)
		save_spoofing_profile(player_name, player_rid)
	end)

--------------------------------------------EXPLOSION AND LOOP STUFF-----------------------------------------------------
	
	trolling_list = menu.list(menu.player_root(pid), "Trolling & Griefing", {}, "")

	explo_settings = menu.list(trolling_list, "Custom Explosion", {}, "")

	menu.divider(explo_settings, "Custom Explosion")

	menu.slider(explo_settings, "Type", {"explotype"}, "",0,72,0,1, function(value)
		type = value
	end)
	menu.toggle(explo_settings, "Invisible", {}, "", function(on)
		invisible = on
	end, false)
	menu. toggle(explo_settings, "Audible", {}, "", function(on)
		audible = on
	end, true)
	menu.slider(explo_settings, "Camera Shake", {"shake"}, "",0,100,1,1, function(value)
		shake = value
	end)
	menu.toggle(explo_settings, "Owned Explosions", {}, "", function(on)
		owned = on
	end)

	menu.action(explo_settings, "Explode", {}, "", function()
		explode(pid, type, owned)
	end)

	menu.slider(explo_settings, "Loop Delay", {"delay"}, "Allows you to change how fast the loops are.",50,1000,300,10, function(value)
		delay = value
	end)
		
	menu.toggle(explo_settings, "Explosion Loop", {},"", function(on)
		explosion_loop = on
		while explosion_loop do
			explode(pid, type, owned)
			util.yield(delay)
		end
	end, false)
	
	menu.toggle(trolling_list, "Water Hydrant Loop", {},"", function(on)
		hydrant_loop = on
		while hydrant_loop do
			explode(pid, 13, false)
			util.yield(100)
		end
	end, false)

	menu.action(trolling_list, "Kill as Orbital Cannon", {}, "", function()
		menu.trigger_commands("becomeorbitalcannon on") 
		util.yield(200)
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), pos.x, pos.y, pos.z, 59, 999999.99, true, false, 1)
		local effectAsset = "scr_xm_orbital" 
		local effectName = "scr_xm_orbital_blast"
		STREAMING.REQUEST_NAMED_PTFX_ASSET(effectAsset)
		while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(effectAsset) do
			util.yield()
		end
		GRAPHICS.USE_PARTICLE_FX_ASSET(effectAsset)
		local fx = GRAPHICS.START_PARTICLE_FX_LOOPED_AT_COORD(effectName, pos.x, pos.y, pos.z, 0, 0, 0, 1, 0, 0, 0, 0)
		util.yield(1000)
		GRAPHICS.STOP_PARTICLE_FX_LOOPED(fx, 0)
		GRAPHICS.REMOVE_PARTICLE_FX(fx, 0)
		menu.trigger_commands("becomeorbitalcannon off")
	end)

	menu.toggle(trolling_list, "Flame Loop", {},"", function(on)
		fire_loop = on
		while fire_loop do
			explode(pid, 12, false)
			util.yield(100)
		end
	end, false)

-------------------------------------------------SHAKE CAM------------------------------------------------------------------

	menu.toggle(trolling_list, "Shake Camera", {}, "", function(on)
		shakecam = on
		while shakecam do
			local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
			FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), pos.x, pos.y, pos.z, 0, 0, false, true, 80)
			util.yield(200)
		end
	end)

-------------------------------------------ATTACKER AND CLONE OPTIONS--------------------------------------------------------

	local attacker_options = menu.list(trolling_list, "Attacker Options", {}, "")
	local attacker_quantity = 1
	menu.divider(attacker_options, "Attacker Options")

	menu.action(attacker_options, "Spawn Attacker", {}, "", function()
		local re_group
		for i = 1, attacker_quantity do
			re_group = spawn_attacker(pid, ped_type, ped_weapon, godmode, stationary)
			util.yield(150)
		end
	end)
	
	local ped_weapon_list = menu.list(attacker_options, "Select Weapon", {}, "Allows you to change the attacker/clone weapon. Default: Pistol.")	
	menu.divider(ped_weapon_list, "Attacker/Clone Weapon List")										
	local ped_melee_list = menu.list(ped_weapon_list, "Melee", {}, "")

	for k, weapon in pairs(weapons) do --creates the attacker weapon list
		menu.action(ped_weapon_list, k, {}, "", function()
			ped_weapon = weapon
			shownotification("Attacker weapon: "..k)
		end)
	end

	for k, weapon in pairs(melee_weapons) do --creates the attacker melee weapon list
		menu.action(ped_melee_list, k, {}, "", function()
			ped_weapon = weapon
			shownotification("Attacker weapon: "..k)
		end)
	end

	local ped_list = menu.list(attacker_options, "Select Model", {}, "Allows to change the attacker appearance. Default: Female Cop.")

	menu.divider(ped_list, "Attacker Model")

	for k, ped in pairs(peds) do --creates the attacker appearance list
		menu.action(ped_list, k, {}, "", function()
			ped_type = ped
			shownotification("Attacker model: "..k)
		end)
	end

	menu.action(attacker_options, "Spawn Random Attacker", {}, "", function()
		local re_group
		for i = 1, attacker_quantity do
			re_group = spawn_attacker(pid, random_peds[math.random(#random_peds)], ped_weapon, godmode, stationary)
			util.yield(150)
		end
	end)

	menu.action(attacker_options, "Clone Player (enemy)", {}, "", function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		pos.z = pos.z-0.9
		for i = 1, attacker_quantity do
			pos.x  = pos.x + math.random(-3, 3)
			pos.y = pos.y + math.random(-3, 3)
			local weapon_hash = util.joaat(ped_weapon)
			local clone = PED.CLONE_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 1, 1, 1); add_model_to_list(spawned_attackers, "mp_f_freemode_01"); add_model_to_list(spawned_attackers, "mp_m_freemode_01")
			WEAPON.GIVE_WEAPON_TO_PED(clone, weapon_hash, 9999, true, true)
			ENTITY.SET_ENTITY_COORDS(clone, pos.x, pos.y, pos.z)
			ENTITY.SET_ENTITY_INVINCIBLE(clone, godmode)
			PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(clone, true)
			TASK.TASK_COMBAT_PED(clone, PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 16)
			PED.SET_PED_COMBAT_ATTRIBUTES(clone, 46, 1)
			if stationary then
				PED.SET_PED_COMBAT_MOVEMENT(clone, 0)
			end
			util.yield(150)
		end
	end)

	menu.toggle(attacker_options, "Stationary", {}, "Use it to make the attacker stationary.", function(on)
		stationary = on
	end, false)

------------------------------------------------------
--ENEMY CHOP
------------------------------------------------------

	menu.action(attacker_options, "Enemy Chop", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		pos.z = pos.z - 0.9
		for i = 1, attacker_quantity do
			pos.x  = pos.x + math.random(-3, 3)
			pos.y = pos.y + math.random(-3, 3)
			local ped_hash = util.joaat("a_c_chop")
			STREAMING.REQUEST_MODEL(ped_hash)
			while not STREAMING.HAS_MODEL_LOADED(ped_hash) do
				util.yield()
			end
			local ped = util.create_ped(28, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z); add_model_to_list(spawned_attackers, "a_c_chop")
			ENTITY.SET_ENTITY_INVINCIBLE(ped, godmode)
			PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
			TASK.TASK_COMBAT_PED(ped, player_ped, 0, 16)
			PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, 1)
			STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
			util.create_thread(function()
				flee_attacker = false
				while ENTITY.GET_ENTITY_HEALTH(ped) > 0 do
					if flee_attacker then
						PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
						TASK.CLEAR_PED_TASKS(ped)
						TASK.TASK_SMART_FLEE_PED(ped, player_ped, 10000.0, -1, false, false)
						return
					end
					util.yield()
				end
			end)
			util.yield(150)
		end
	end)

-------------------------------------------------------
--SEND POLICE CAR
-------------------------------------------------------
	
	menu.action(attacker_options, "Send Police Car", {}, "Creates a police car which is going to chase and shoot player. ", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local veh_hash = util.joaat("police3")
		local ped_hash = util.joaat("s_m_y_cop_01")
		STREAMING.REQUEST_MODEL(veh_hash)
		STREAMING.REQUEST_MODEL(ped_hash)
		while not STREAMING.HAS_MODEL_LOADED(veh_hash) or not STREAMING.HAS_MODEL_LOADED(ped_hash) do
			util.yield()
		end
		local coords_ptr = memory.alloc()
		local nodeId = memory.alloc()
		local coords
		local weapons = {
			"weapon_pistol",
			"weapon_pumpshotgun"
		}
		for i = 1, attacker_quantity do		
			if not PATHFIND.GET_RANDOM_VEHICLE_NODE(pos.x, pos.y, pos.z, 80, 0, 0, 0, coords_ptr, nodeId) then
				pos.x = pos.x + math.random(-20,20)
				pos.y = pos.y + math.random(-20,20)
				PATHFIND.GET_CLOSEST_VEHICLE_NODE(pos.x, pos.y, pos.z, coords_ptr, 1, 100, 2.5)
			end
			coords = memory.read_vector3(coords_ptr)
			memory.free(coords_ptr)
			memory.free(nodeId)
			local veh = util.create_vehicle(veh_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			set_ent_face_ent(veh, player_ped)
			VEHICLE.SET_VEHICLE_SIREN(veh, true)
			AUDIO.BLIP_SIREN(veh)
			VEHICLE.SET_VEHICLE_ENGINE_ON(veh, true, true, true)
			ENTITY.SET_ENTITY_INVINCIBLE(veh, godmode)

			local function create_ped_into_vehicle(seat)
				local cop = util.create_ped(5, ped_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
				PED.SET_PED_RANDOM_COMPONENT_VARIATION(cop, 0)
				WEAPON.GIVE_WEAPON_TO_PED(cop, util.joaat(weapons[math.random(1, #weapons)]) , -1, false, true)
				PED.SET_PED_RELATIONSHIP_GROUP_HASH(cop, reCops)
				PED.SET_PED_NEVER_LEAVES_GROUP(cop, true)
				PED.SET_PED_COMBAT_ATTRIBUTES(cop, 1, true)
				PED.SET_PED_AS_COP(cop, true)
				PED.SET_PED_INTO_VEHICLE(cop, veh, seat)
				TASK.TASK_COMBAT_PED(cop, player_ped, 0, 16)
				ENTITY.SET_ENTITY_INVINCIBLE(cop, godmode)
				PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(cop, true)
				PED.SET_PED_KEEP_TASK(cop, true)
				return cop
			end
			for seat = -1, 0 do
				local cop = create_ped_into_vehicle(seat)
				util.create_thread(function()
					while ENTITY.GET_ENTITY_HEALTH(cop) > 0 do
						local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
						if PLAYER.IS_PLAYER_DEAD(pid) then
							while PLAYER.IS_PLAYER_DEAD(pid) do
								util.yield()
							end
							TASK.TASK_COMBAT_PED(cop, player_ped, 0, 16)
						end
						util.yield()
					end
				end)
			end
			util.yield(250)

		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_hash)
		AUDIO.PLAY_POLICE_REPORT("SCRIPTED_SCANNER_REPORT_GETAWAY_01", 0.0)
	end)
	
	menu.slider(attacker_options, "Quantity", {"attackerquantity"}, "Is how many attackers will be spawned.", 1, 15, 1, 1, function(value)
		attacker_quantity = value
	end)

	menu.toggle(attacker_options, "Invincible Attackers", {}, "Makes attacker invincible when enabled.", function(on_godmode)
		godmode = on_godmode
	end, false)

	menu.action(attacker_options, "Delete Attackers", {}, "", function()
		for k, model in pairs(spawned_attackers) do
			delete_entities_by_model(model)
			spawned_attackers[k] = nil
		end
	end)

------------------------------------------CAGE OPTIONS----------------------------------------------------------------------
	
	local cage_options = menu.list(trolling_list, "Cage", {}, "")
	
	menu.divider(cage_options, "Cage")

	menu.action(cage_options, "Simple", {"cage"}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped) 
		if PED.IS_PED_IN_ANY_VEHICLE(player_ped, false) then
			menu.trigger_commands("freeze"..PLAYER.GET_PLAYER_NAME(pid).." on")
			util.yield(300)
			if PED.IS_PED_IN_ANY_VEHICLE(player_ped, false) then
				shownotification("~r~Failed to kick player out of the vehicle")
				menu.trigger_commands("freeze"..PLAYER.GET_PLAYER_NAME(pid).." off")
				return
			end
			menu.trigger_commands("freeze"..PLAYER.GET_PLAYER_NAME(pid).." off")
			pos =  ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)) --if not it could place the cage at the wrong position
		end
		cage_player(pos, cage_type)
	end)

---------------------------------------------------
--AUTOMATIC
---------------------------------------------------
	
	menu.toggle(cage_options, "Atomatic", {"autocage"}, "Trap them in a cage. If they get out... Do it again. No, I\'ll do it for you actually.", function(on)
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local a = ENTITY.GET_ENTITY_COORDS(player_ped) --first position
		cage_loop = on
		if cage_loop then
			if PED.IS_PED_IN_ANY_VEHICLE(player_ped, false) then
				menu.trigger_commands("freeze"..PLAYER.GET_PLAYER_NAME(pid).." on")
				util.yield(300)
				if PED.IS_PED_IN_ANY_VEHICLE(player_ped, false) then
					shownotification("~r~Failed to kick player out of the vehicle")
					menu.trigger_commands("freeze"..PLAYER.GET_PLAYER_NAME(pid).." off")
					return
				end
				menu.trigger_commands("freeze"..PLAYER.GET_PLAYER_NAME(pid).." off")
				a =  ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
			end
			cage_player(a, cage_type)
		end
		while cage_loop do
			local b = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)) --current position
			local ba = {x = b.x - a.x, y = b.y - a.y, z = b.z - a.z} 
			if math.sqrt(ba.x * ba.x + ba.y * ba.y + ba.z * ba.z) >= 4 then --now I know there's a native to find distance between coords but I like this >_<
				a = b
				if PED.IS_PED_IN_ANY_VEHICLE(player_ped, false) then
					goto continue
				end
				cage_player(a, cage_type)
				shownotification(PLAYER.GET_PLAYER_NAME(pid).." was out of the cage. Doing it again")
				::continue::
			end
			util.yield(1000)
		end
	end, false)

------------------------------------------------------
--FENCE
------------------------------------------------------

	menu.action(cage_options, "Fence", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local object_hash = util.joaat("prop_fnclink_03e")
		pos.z = pos.z-0.9
		STREAMING.REQUEST_MODEL(object_hash)
		while not STREAMING.HAS_MODEL_LOADED(object_hash) do
			util.yield()
		end
		local object = {}
		object[1] = OBJECT.CREATE_OBJECT(object_hash, pos.x-1.5, pos.y+1.5, pos.z, true, true, true) 																			
		object[2] = OBJECT.CREATE_OBJECT(object_hash, pos.x-1.5, pos.y-1.5, pos.z, true, true, true)
		
		object[3] = OBJECT.CREATE_OBJECT(object_hash, pos.x+1.5, pos.y+1.5, pos.z, true, true, true) 	
		local rot_3  = ENTITY.GET_ENTITY_ROTATION(object[3])
		rot_3.z = -90
		ENTITY.SET_ENTITY_ROTATION(object[3], rot_3.x, rot_3.y, rot_3.z, 1, true)
		
		object[4] = OBJECT.CREATE_OBJECT(object_hash, pos.x-1.5, pos.y+1.5, pos.z, true, true, true) 	
		local rot_4  = ENTITY.GET_ENTITY_ROTATION(object[4])
		rot_4.z = -90
		ENTITY.SET_ENTITY_ROTATION(object[4], rot_4.x, rot_4.y, rot_4.z, 1, true)
		
		for key, value in pairs(object) do
			ENTITY.FREEZE_ENTITY_POSITION(value, true)
			if value == 0 then 
				shownotification("~r~Something went wrong creating cage")
			end
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(object_hash)
	end)

-------------------------------------------------------
--STUNT TUBE
-------------------------------------------------------

	menu.action(cage_options, "Stunt Tube", {}, "", function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = util.joaat("stt_prop_stunt_tube_s")
		STREAMING.REQUEST_MODEL(hash)

		while not STREAMING.HAS_MODEL_LOADED(hash) do		
			util.yield()
		end
		local cage_object = OBJECT.CREATE_OBJECT(hash, pos.x, pos.y, pos.z, true, true, false)

		local rot  = ENTITY.GET_ENTITY_ROTATION(cage_object)
		rot.y = 90
		ENTITY.SET_ENTITY_ROTATION(cage_object, rot.x,rot.y,rot.z,1,true)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
	end)

--------------------------------------------------------
--SIMPLE/AUTOMATIC VERSION
--------------------------------------------------------

	local cage_type_list = menu.list(cage_options, "Simple/Automatic Version", {}, "Allows you to change cage type for Simple and Automatic options.")
	menu.divider(cage_type_list, "Cage Type")

	for i = 1,2 do
		menu.action(cage_type_list, "Trolly v"..i, {}, "", function()
			cage_type = i
			shownotification("Cage type: Trolly v"..i)
		end)
	end

	menu.action(cage_options, "Delete Traps", {}, "", function()
		local trap_models = {
			"prop_gold_cont_01b",
			"prop_rub_cage01a",
			"prop_fnclink_03e",
			"stt_prop_stunt_tube_s"
		}
		for k, model in pairs(trap_models) do
			delete_entities_by_model(model)
		end
	end)

------------------------------------------------GUITAR-----------------------------------------------------------------------

	menu.action(trolling_list, "Attach Guitar", {}, "Attaches a guitar to their ped causing crazy things if they\'re in a vehicle and looks nice.", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		pos.z = pos.z - 0.9
		local object_hash = util.joaat("prop_acc_guitar_01_d1")
		STREAMING.REQUEST_MODEL(object_hash)
		while not STREAMING.HAS_MODEL_LOADED(object_hash) do
			util.yield()
		end
		local object = OBJECT.CREATE_OBJECT(object_hash, pos.x, pos.y, pos.z, true, true, true)
		if object == 0 then 
			shownotification("~r~Failure creating the entity")
		end
		ENTITY.ATTACH_ENTITY_TO_ENTITY(object, PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), PED.GET_PED_BONE_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0x5c01), 0.5, -0.2, 0.1, 0, 70, 0, false, true, true --[[Collision - This causes glitch when in vehicle]], false, 0, true)
		--ENTITY.SET_ENTITY_VISIBLE(object, false, 0) --turns guitar invisible
		util.yield(3000)
		if player_ped ~= ENTITY.GET_ENTITY_ATTACHED_TO(object) then
			shownotification("~r~The entity is not attached. ~s~Meaby "..PLAYER.GET_PLAYER_NAME(pid).." has attactment protections")
			return
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(object_hash)
	end)

----------------------------------------------------RAPE--------------------------------------------------------------------

	local rape_options = menu.list(trolling_list, "Rape")
	menu.divider(rape_options, "Rape")

	menu.action(rape_options, "Monkey", {}, "Other players may not see the animation.", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local ped_hash = util.joaat("a_c_chimp")
		STREAMING.REQUEST_MODEL(ped_hash)
		STREAMING.REQUEST_ANIM_DICT("rcmpaparazzo_2")
		util.yield(50)
		while not STREAMING.HAS_MODEL_LOADED(ped_hash) or not STREAMING.HAS_ANIM_DICT_LOADED("rcmpaparazzo_2") do
			util.yield()
		end
		local ped = util.create_ped(1, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
		TASK.TASK_PLAY_ANIM(ped, "rcmpaparazzo_2", "shag_loop_a", 8, 8, -1, 1, 0, 0, 0, 0)
		ENTITY.ATTACH_ENTITY_TO_ENTITY(ped, player_ped, PED.GET_PED_BONE_INDEX(ped, 0x0), 0, -0.3, 0.2, 0, 0, 0, false, true, false, false, 0, true)
		ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
		ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(ped, false, false) --for ped not to be beaten with a melee weapon (because ped ditaches from player)
		util.yield(3000)
		if player_ped ~= ENTITY.GET_ENTITY_ATTACHED_TO(ped) then
			shownotification("~r~The entity is not attached. ~s~Meaby "..PLAYER.GET_PLAYER_NAME(pid).." has attactment protections")
			return
		end
		while player_ped == ENTITY.GET_ENTITY_ATTACHED_TO(ped) do
			if not ENTITY.IS_ENTITY_PLAYING_ANIM(ped, "rcmpaparazzo_2", "shag_loop_a",3) then
				TASK.TASK_PLAY_ANIM(ped, "rcmpaparazzo_2", "shag_loop_a", 8, 8, -1, 1, 0, 0, 0, 0)
			end
			util.yield()
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
	end)

	menu.toggle(rape_options, "By Me", {}, "", function(on)
		rape = on
		if pid ~= players.user() then
			if rape then
				local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
				STREAMING.REQUEST_ANIM_DICT("rcmpaparazzo_2")
				while not STREAMING.HAS_ANIM_DICT_LOADED("rcmpaparazzo_2") do
					util.yield()
				end
				local user_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
				TASK.TASK_PLAY_ANIM(user_ped, "rcmpaparazzo_2", "shag_loop_a", 8, -8, -1, 1, 0, false, false, false)
				local netID = NETWORK.PED_TO_NET(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
				NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(netID, true)
				ENTITY.ATTACH_ENTITY_TO_ENTITY(user_ped, player_ped, PED.GET_PED_BONE_INDEX(ped, 0x0), 0, -0.3, 0, 0, 0, 0, false, true, true, false, 0, true)
				menu.trigger_commands("nocollision on")
			end
			while rape do 
				util.yield()
			end
			TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
			ENTITY.DETACH_ENTITY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), true, false)
			menu.trigger_commands("nocollision off")
		end
	end, false)

---------------------------------------------------ENEMY BUZZARD------------------------------------------------------------------

	local enemy_vehicles = menu.list(trolling_list, "Enemy Vehicles", {}, "")
	local buzzard_quantity = 1
	local buzzard_visible = true
	local gunner_weapon = "weapon_combatmg"
	
	menu.divider(enemy_vehicles, "Buzzard")

	menu.toggle(enemy_vehicles, "Invincible", {}, "", function(on)
		buzzard_godmode = on
	end, false)
	
	local menu_gunner_weapon_list = menu.list(enemy_vehicles, "Gunners Weapon")
	menu.divider(menu_gunner_weapon_list, "Gunner Weapon List")

	for k, weapon in pairs(gunner_weapon_list) do
		menu.action(menu_gunner_weapon_list, k, {}, "", function()
			gunner_weapon = weapon
			shownotification("Now gunners will shoot with "..k.."s")
		end)
	end

	menu.toggle(enemy_vehicles, "Visible", {}, "You shouldn\'t be that toxic to turn this off.", function(on)
		buzzard_visible = on
	end, true)

	menu.action(enemy_vehicles, "Send Buzzard", {}, "", function()
		for i = 1, buzzard_quantity do
			spawn_buzzard(pid, gunner_weapon, buzzard_godmode, buzzard_visible)
			util.yield(100)
		end
	end)

	menu.slider(enemy_vehicles, "Quantity", {"numbuzzard"} , "", 1, 5, 1,1, function(value)
		buzzard_quantity = value
	end)
	
	menu.action(enemy_vehicles, "Delete Buzzards", {}, "", function()
		delete_entities_by_model("buzzard2"); delete_entities_by_model("s_m_y_blackops_01")
	end)

------------------------------------------------------------DAMAGE-------------------------------------------------------------------

	local damage = menu.list(trolling_list, "Damage", {}, "Choose the weapon and shoot \'em no matter where you are.")
	
	menu.toggle(damage, "Spectate", {}, "If player is not visible or far enough, you\'ll need to spectate before using Demage. This is just Stand\'s option duplicated.", function(on)
		spectate = on
		if spectate then
			menu.trigger_commands("spectate "..PLAYER.GET_PLAYER_NAME(pid).." on")
		else
			menu.trigger_commands("spectate "..PLAYER.GET_PLAYER_NAME(pid).." off")
		end
	end)

	menu.divider(damage, "Damage")
	local owned_bullet = true
	local damage_value = 200 --default damage value
	menu.action(damage, "Heavy Sniper", {}, "", function()
		shoot_owned_bullet(pid, "weapon_heavysniper", damage_value)
	end)

	menu.action(damage, "Shotgun", {}, "", function()
		shoot_owned_bullet(pid, "weapon_pumpshotgun", damage_value)
	end)

	menu.slider(damage, "Damage Amount", {"damagevalue"}, "The bullet demages player with the given value. ", 10, 1000, 200, 50, function(value)
		damage_value = value
	end)

	menu.toggle(damage, "Tase", {}, "", function(on)
		tase = on
		while tase do 
			shoot_owned_bullet(pid, "weapon_stungun", 1)
			util.yield(2500)
		end
	end)

-----------------------------------------------------HOSTILE PEDS------------------------------------------------------------------

	menu.action(trolling_list, "Hostile Peds", {}, "All on foot peds will combat player.", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local peds = get_nearby_entities(pid, 80, true, false)
		local rel_group_ptr = memory.alloc()
		PED.ADD_RELATIONSHIP_GROUP("rel_group", rel_group_ptr)
		local rel_group = memory.read_int(rel_group_ptr)
		memory.free(rel_group_ptr)
		for k, ped in pairs(peds) do
			if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
				local tick = 0
				while not request_control_ent(ped) and tick <= 10 do
					request_control_ent(ped)
					tick = tick + 1
					util.yield()
				end
				TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
				PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
				PED.SET_PED_MAX_HEALTH(ped, 300)
				ENTITY.SET_ENTITY_HEALTH(ped, 300)
				WEAPON.GIVE_WEAPON_TO_PED(ped, util.joaat(random_weapons[math.random(1, #random_weapons)]), 9999, false, true)
				TASK.TASK_COMBAT_PED(ped, player_ped, 0, 0)
				WEAPON.SET_PED_DROPS_WEAPONS_WHEN_DEAD(ped, false)
				PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, rel_group)
			end
		end
	end)

--------------------------------------------------HOSTILE TRAFFIC-----------------------------------------------------------------

	menu.action(trolling_list, "Hostile Traffic", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos  = ENTITY.GET_ENTITY_COORDS(player_ped)
		local vehicles = {}
		for k, entity in pairs(get_nearby_entities(pid,130, false, true)) do
			if ENTITY.IS_ENTITY_A_VEHICLE(entity) and not VEHICLE.IS_VEHICLE_SEAT_FREE(entity, -1) then
				vehicles[#vehicles+1] = entity
			end
		end
		for k, vehicle in pairs(vehicles) do
			local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
			if PED.IS_PED_A_PLAYER(dirver) then
				vehicles[k] = nil
			else
				local tick = 0
				while not request_control_ent(driver) and tick <= 10 do
					request_control_ent(driver)
					tick = tick + 1
					util.yield()
				end
				PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
				PED.SET_PED_MAX_HEALTH(driver, 300)
				ENTITY.SET_ENTITY_HEALTH(driver, 300)
				TASK.CLEAR_PED_TASKS_IMMEDIATELY(driver)
				PED.SET_PED_INTO_VEHICLE(driver, vehicle, -1)
				PED.SET_PED_COMBAT_ATTRIBUTES(driver, 46, true)
				TASK.TASK_COMBAT_PED(driver, player_ped, 0, 0)
				TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, player_ped, 6, 100, 0, 0, 0, true)
			end
			vehicles[k] = nil
		end
	end)

--------------------------------------------------ENEMY MINITANK----------------------------------------------------------------
	
	local minitank_godmode = false
	local minitank_quantity = 1
	local flee_minitank = false
	local hostile_rc_vehicles = menu.list(trolling_list, "Trolly RC Vehicles")
	menu.divider(hostile_rc_vehicles, "RC Tank")
	local minitank_godmode = false
	menu.action(hostile_rc_vehicles, "Send RC Tank", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local minitank_hash = util.joaat("minitank")
		local ped_hash = util.joaat("s_m_y_blackops_01")
		STREAMING.REQUEST_MODEL(minitank_hash)
		STREAMING.REQUEST_MODEL(ped_hash)
		while not STREAMING.HAS_MODEL_LOADED(minitank_hash) or not STREAMING.HAS_MODEL_LOADED(ped_hash) do
			util.yield()
		end
		for i = 1, minitank_quantity do
			local coords_ptr = memory.alloc()
			local nodeId = memory.alloc()
			local coords
			if not PATHFIND.GET_RANDOM_VEHICLE_NODE(pos.x, pos.y, pos.z, 80, 0, 0, 0, coords_ptr, nodeId) then
				pos.x = pos.x + math.random(-20,20)
				pos.y = pos.y + math.random(-20,20)
				PATHFIND.GET_CLOSEST_VEHICLE_NODE(pos.x, pos.y, pos.z, coords_ptr, 1, 100, 2.5)
				coords = memory.read_vector3(coords_ptr)
			end
			coords = memory.read_vector3(coords_ptr)
			memory.free(coords_ptr)
			memory.free(nodeId)
				--DOING THINGS WITH MINITANK
			local minitank = util.create_vehicle(minitank_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			ENTITY._SET_ENTITY_CLEANUP_BY_ENGINE(minitank, false)
			if not ENTITY.DOES_ENTITY_EXIST(minitank) then 
				shownotification("~r~Failed to create minitank. Please try again")
				return
			end
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(minitank, true, true)
			local blip = add_blip_for_entity(minitank, 742, 35)
			ENTITY.SET_ENTITY_INVINCIBLE(minitank, minitank_godmode)
			VEHICLE.SET_VEHICLE_MOD_KIT(minitank, 0)
			for i = 0, 50 do
				VEHICLE.SET_VEHICLE_MOD(minitank, i, VEHICLE.GET_NUM_VEHICLE_MODS(minitank, i) - 1, false)
			end
			VEHICLE.SET_VEHICLE_ENGINE_ON(minitank, true, true, true)
			set_ent_face_ent(minitank, player_ped)
				--DOING THINGS WITH DRIVER
			local driver = util.create_ped(5, ped_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			ENTITY._SET_ENTITY_CLEANUP_BY_ENGINE(driver, false)
			PED.SET_PED_COMBAT_ATTRIBUTES(driver, 1, true)
			PED.SET_PED_COMBAT_ATTRIBUTES(driver, 3, false)
			PED.SET_PED_INTO_VEHICLE(driver, minitank, -1)
			TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, minitank, player_ped, 6, 100, 0, 2, 0, true)
			TASK.TASK_COMBAT_PED(driver, player_ped, 0, 0)
			ENTITY.SET_ENTITY_VISIBLE(driver, false, 0)
			PED.SET_PED_RELATIONSHIP_GROUP_HASH(driver, util.joaat("ARMY"))
			PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, util.joaat("ARMY"), util.joaat("ARMY"))
			util.create_thread(function()
				while ENTITY.GET_ENTITY_HEALTH(minitank) > 0 do
					AUDIO.STOP_CURRENT_PLAYING_SPEECH(driver) --STOPS DRIVER SPEECH (NEEDS TO BE CALLED EVERY TICK)
					if PLAYER.IS_PLAYER_DEAD(pid) then
						while PLAYER.IS_PLAYER_DEAD(pid) do
							util.yield()
						end
						local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
						TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, minitank, player_ped, 6, 100, 1074528813, 2, 0, true)
						TASK.TASK_COMBAT_PED(driver, player_ped, 0, 0)
					end
					util.yield()
				end
			end)
			util.yield(150)
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(minitank_hash)
	end)

	menu.slider(hostile_rc_vehicles, "Quantity", {"numminitank"}, "", 1,25,1,1, function(value)
		minitank_quantity = value
	end)

	menu.toggle(hostile_rc_vehicles, "Invincible", {}, "", function(on)
		minitank_godmode = on
	end, false)

	menu.action(hostile_rc_vehicles, "Delete Minitanks", {}, "", function()
		delete_entities_by_model("minitank"); delete_entities_by_model("s_m_y_blackops_01")
	end)
	

-----------------------------------------------TROLLY BANDITO------------------------------------------------------------------
	
	local bandito_godmode = false
	local bandito_quantity = 1
	menu.divider(hostile_rc_vehicles, "RC Bandito")
	menu.action(hostile_rc_vehicles, "Send RC Bandito", {}, "You may hit this option twice the very first time you use it after game startup", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local bandito_hash = util.joaat("rcbandito")
		local ped_hash = util.joaat("s_m_y_blackops_01")
		STREAMING.REQUEST_MODEL(bandito_hash)
		STREAMING.REQUEST_MODEL(ped_hash)
		while not STREAMING.HAS_MODEL_LOADED(bandito_hash) and not STREAMING.HAS_MODEL_LOADED(ped_hash) do
			util.yield()
		end
		for i = 1, bandito_quantity do
			local coords_ptr = memory.alloc()
			local nodeId = memory.alloc()
			local coords
			if not PATHFIND.GET_RANDOM_VEHICLE_NODE(pos.x, pos.y, pos.z, 80, 0, 0, 0, coords_ptr, nodeId) then
				pos.x = pos.x + math.random(-20,20)
				pos.y = pos.y + math.random(-20,20)
				PATHFIND.GET_CLOSEST_VEHICLE_NODE(pos.x, pos.y, pos.z, coords_ptr, 1, 100, 2.5)
				coords = memory.read_vector3(coords_ptr)
			else
				coords = memory.read_vector3(coords_ptr)
			end
			memory.free(coords_ptr)
			memory.free(nodeId)
		
			local bandito = util.create_vehicle(bandito_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			if not ENTITY.DOES_ENTITY_EXIST(bandito) then --SOMETIMES BANDITO IS NOT SPAWNED THE VERY FIRST TIME YOU USE THE OPTION AFTER A GAME RESTART
				shownotification("~r~Failed to create bandito. Please try again")
				return
			end
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(bandito, true, true)
			local blip = add_blip_for_entity(bandito, 646, 35)
			VEHICLE.SET_VEHICLE_MOD_KIT(bandito, 0)
			for i = 0, 50 do
				VEHICLE.SET_VEHICLE_MOD(bandito, i, VEHICLE.GET_NUM_VEHICLE_MODS(bandito, i) - 1, false)
			end
			VEHICLE.SET_VEHICLE_ENGINE_ON(bandito, true, true, true)
			set_ent_face_ent(bandito, player_ped)

			local driver = util.create_ped(5, ped_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, true, true)
			PED.SET_PED_COMBAT_ATTRIBUTES(driver, 1, true)
			PED.SET_PED_INTO_VEHICLE(driver, bandito, -1)
			TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, bandito, player_ped, 6, 70.0, config_list['driving style']['Bandito Driving Style'], 0, 10.0, true) --1074528293 --1074528813(mine)
			PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
			ENTITY.SET_ENTITY_INVINCIBLE(bandito, bandito_godmode)
			ENTITY.SET_ENTITY_VISIBLE(driver, false, 0)

			util.create_thread(function()
				flee_bandito = false
				while ENTITY.GET_ENTITY_HEALTH(bandito) > 0 do
					AUDIO.STOP_CURRENT_PLAYING_SPEECH(driver)
					local a,b = ENTITY.GET_ENTITY_COORDS(player_ped), ENTITY.GET_ENTITY_COORDS(bandito)
					if explode_bandito then
						if MISC.GET_DISTANCE_BETWEEN_COORDS(a.x, a.y, a.z, b.x, b.y, b.z, false) < 3 then
							FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), b.x, b.y, b.z, 2, 999999.99, true, false, 1)
							if not bandito_godmode then
								VEHICLE.SET_VEHICLE_ENGINE_HEALTH(bandito, -4000)
								ENTITY.SET_ENTITY_HEALTH(driver, 0)
							end
						end
					end
					util.yield()
				end
				ENTITY.SET_ENTITY_HEALTH(driver, 0)
			end)
			util.yield(150)
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(bandito_hash)
	end)

	menu.slider(hostile_rc_vehicles, "Quantity", {"numbandito"}, "", 1,25,1,1, function(value)
		bandito_quantity = value
	end)

	menu.toggle(hostile_rc_vehicles, "Explode When Nearby", {}, "Bandito will explode and kill the player as you when it\'s close enough.", function(on)
		explode_bandito = on
	end, false)

	menu.toggle(hostile_rc_vehicles, "Invincible", {}, "", function(on)
		bandito_godmode = on
	end, false)

	menu.action(hostile_rc_vehicles, "Delete Banditos", {}, "", function()
		delete_entities_by_model("rcbandito"); delete_entities_by_model("s_m_y_blackops_01")
	end)

---------------------------------------------------HOSTILE JET---------------------------------------------------------------

	local jet_entities = {}
	local lazer_quantity = 1
	menu.divider(enemy_vehicles, "Lazer")

	menu.toggle(enemy_vehicles, "Invincible", {}, "", function(on)
		jet_godmode = on
	end, jet_godmode)

	menu.action(enemy_vehicles, "Send Lazer", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local jet_hash = util.joaat("lazer")
		local ped_hash = util.joaat("s_m_y_blackops_01")
		STREAMING.REQUEST_MODEL(jet_hash)
		STREAMING.REQUEST_MODEL(ped_hash)
		while not STREAMING.HAS_MODEL_LOADED(jet_hash) and not STREAMING.HAS_MODEL_LOADED(ped_hash) do
			util.yield()
		end
		for i = 1, lazer_quantity do
			pos.x = pos.x + math.random(-80, 80)
			pos.y = pos.y + math.random(-80, 80)
			pos.z = pos.z + math.random(500, 550)

			local pilot = util.create_ped(5, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			if not ENTITY.DOES_ENTITY_EXIST(pilot) then 
				shownotification("~r~Failed to create jet. Please try again")
				return
			end
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(pilot, true, true)
				
				--DOING THINGS WITH JET
			local jet = util.create_vehicle(jet_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			if not ENTITY.DOES_ENTITY_EXIST(jet) then 
				shownotification("~r~Failed to create jet. Please try again")
				util.delete_entity(pilot)
				return
			end
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(jet, true, true)

			set_ent_face_ent(jet, player_ped)
			local blip = add_blip_for_entity(jet, 16, 35)
			VEHICLE._SET_VEHICLE_JET_ENGINE_ON(jet, true)
			VEHICLE.SET_VEHICLE_FORWARD_SPEED(jet, 60)
			VEHICLE.CONTROL_LANDING_GEAR(jet, 3)
			ENTITY.SET_ENTITY_INVINCIBLE(jet, jet_godmode)
			VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(jet, true)
				
				--DOING THINGS WITH PILOT
			PED.SET_PED_INTO_VEHICLE(pilot, jet, -1)
			TASK.TASK_PLANE_MISSION(pilot, jet, 0, player_ped, 0, 0, 0, 6, 100, 0, 0, 80, 50)
			PED.SET_PED_COMBAT_ATTRIBUTES(pilot, 1, true)
			util.yield(150)
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(jet_hash)
	end)

	menu.slider(enemy_vehicles, "Quantity", {"numlazer"}, "", 1, 15, 1, 1, function(value)
		lazer_quantity = value
	end) 

	menu.action(enemy_vehicles, "Delete Lazers", {}, "", function()
		delete_entities_by_model("lazer"); delete_entities_by_model("s_m_y_blackops_01")
	end)

--------------------------------------------------------RAM PLAYER--------------------------------------------------------------

	menu.click_slider(trolling_list, "Ram Player", {"ram"}, "", 1, 3, 1, 1, function(value)
		local hash = value
		local vehicle_hash = {
			"insurgent2",
			"phantom2",
			"adder"
		}
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local offset = {-12, 12}
		pos.x = pos.x + offset[math.random(1, #offset)]
		pos.y = pos.y + offset[math.random(1, #offset)]
		local veh_hash = util.joaat(vehicle_hash[hash])
		STREAMING.REQUEST_MODEL(veh_hash)
		while not STREAMING.HAS_MODEL_LOADED(veh_hash) do
			util.yield()
		end
		local veh = util.create_vehicle(veh_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		set_ent_face_ent(veh, player_ped)
		VEHICLE.SET_VEHICLE_DOORS_LOCKED(veh, 2)
		VEHICLE.SET_VEHICLE_FORWARD_SPEED(veh, 100)
	end)

----------------------------------------------------------PIGGY BACK-------------------------------------------------------------
	
	menu.toggle(trolling_list, "Piggy Back", {}, "", function(on)
		piggyback = on
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local user_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		local tick = 0
		if pid ~= players.user() then
			if piggyback then
				STREAMING.REQUEST_ANIM_DICT("rcmjosh2")
				while not STREAMING.HAS_ANIM_DICT_LOADED("rcmjosh2") do
					util.yield()
				end
				ENTITY.ATTACH_ENTITY_TO_ENTITY(user_ped, player_ped, PED.GET_PED_BONE_INDEX(player_ped, 0xDD1C), 0, -0.2, 0.65, 0, 0, 180, false, true, true, false, 0, true)
				TASK.TASK_PLAY_ANIM(user_ped, "rcmjosh2", "josh_sitting_loop", 8, -8, -1, 1, 0, false, false, false)
				menu.trigger_commands("nocollision on")
			else
				TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
				ENTITY.DETACH_ENTITY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), true, false)
				menu.trigger_commands("nocollision off")
				while user_ped == ENTITY.GET_ENTITY_ATTACHED_TO(player_ped) and tick <= 15 do
					ENTITY.DETACH_ENTITY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), true, false)
					tick = tick + 1
					util.yield()
				end
			end
		end
	end)

--------------------------------------------------------------ALIEN EGG------------------------------------------------------------------

	menu.action(trolling_list, "Attach Alien Egg", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local object_hash = util.joaat("prop_alien_egg_01")
		STREAMING.REQUEST_MODEL(object_hash)
		while not STREAMING.HAS_MODEL_LOADED(object_hash) do
			util.yield()
		end
		local object = OBJECT.CREATE_OBJECT(object_hash, pos.x, pos.y, pos.z, true, true, true)
		ENTITY.ATTACH_ENTITY_TO_ENTITY(object, player_ped, PED.GET_PED_BONE_INDEX(player_ped, 0x0), 0, 0, 0, 0, 0, 0, false, true, false, false, 0, true)
	end)

--------------------------------------------------------------RAIN ROCKETS----------------------------------------------------------------

	local function rain_rockets(pid, owned)
		local user_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local owner
		pos.x = pos.x + math.random(-6,6)
		pos.y = pos.y + math.random(-6,6)
		local ground_ptr = memory.alloc(32); MISC.GET_GROUND_Z_FOR_3D_COORD(pos.x, pos.y, pos.z, ground_ptr, false, false); pos.z = memory.read_float(ground_ptr); memory.free(ground_ptr)
		if owned then owner = user_ped else owner = 0 end
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z+50, pos.x, pos.y, pos.z, 200, true, util.joaat("weapon_airstrike_rocket"), owner, true, false, -1.0)
	end

	menu.toggle(trolling_list, "Rain Rockets (owned)", {}, "", function(on)
		rainRockets = on
		while rainRockets do
			rain_rockets(pid, true)
			util.yield(500)
		end
	end)

	menu.toggle(trolling_list, "Rain Rockets", {}, "", function(on)
		rainRockets = on
		while rainRockets do
			rain_rockets(pid, false)
			util.yield(500)
		end
	end)

-----------------------------------------------------------FRIENDLY OPTIONS---------------------------------------------------------------

	local friendly_list = menu.list(menu.player_root(pid), "Friendly Options", {}, "")
	menu.divider(friendly_list, "Friendly Options")

-------------------------------------------------
--BODYGUARD
-------------------------------------------------

	local bodyguardGodmode = false
	local bodyguard_weapon, bodyguard_model
	local bodyguard_random_model, bodyguard_random_weapon = true, true
	local spawned_bodyguards = {}
	local bodyguards_options = menu.list(friendly_list, "Bodyguards Options", {}, "")
		
	menu.divider(bodyguards_options, "Bodyguards Options")

	menu.action(bodyguards_options, "Spawn Bodyguard (7 Max)", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local size_ptr =  memory.alloc(32); local any_ptr = memory.alloc(32)
		local groupId = PED.GET_PED_GROUP_INDEX(player_ped); PED.GET_GROUP_SIZE(groupId, any_ptr, size_ptr); local groupSize = memory.read_int(size_ptr); memory.free(size_ptr); memory.free(any_ptr)
		if groupSize == 7 then
			shownotification("You reached the max number of bodyguards")
			return
		end
		pos.x = pos.x + math.random(-3, 3)
		pos.y = pos.y + math.random(-3, 3)
		pos.z = pos.z - 0.9
		local weapon, model
		if bodyguard_random_weapon then
			weapon = random_weapons[math.random(1, #random_weapons)]
		else
			weapon = bodyguard_weapon
		end
		if bodyguard_random_model then 
			model = random_peds[math.random(1, #random_peds)]
		else
			model = bodyguard_model
		end
		local pedHash = util.joaat(model)
		STREAMING.REQUEST_MODEL(pedHash)
		while not STREAMING.HAS_MODEL_LOADED(pedHash) do 
			util.yield()
		end
		local pedNetId = NETWORK.PED_TO_NET(util.create_ped(29, pedHash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)); add_model_to_list(spawned_bodyguards, model)
		if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(NETWORK.NET_TO_PED(pedNetId)) then
			NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(pedNetId, true)
		end
		NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(pedNetId, players.user(), true)
		local ped = NETWORK.NET_TO_PED(pedNetId)
		WEAPON.GIVE_WEAPON_TO_PED(ped, util.joaat(weapon), 9999, false, true)
		PED.SET_PED_HIGHLY_PERCEPTIVE(ped, true)
		PED.SET_PED_COMBAT_RANGE(ped, 2)
		PED.SET_PED_SEEING_RANGE(ped, 100.0)
		ENTITY.SET_ENTITY_INVINCIBLE(ped, bodyguardGodmode)
		PED.SET_PED_AS_GROUP_MEMBER(ped, groupId)
		PED.SET_PED_NEVER_LEAVES_GROUP(ped, true)
		PED.SET_GROUP_FORMATION(groupId, 0)
		PED.SET_GROUP_FORMATION_SPACING(groupId, 1.0, 0.9, 3.0)
		set_ent_face_ent(ped, player_ped)
	end)

	local bodyguards_model_list = menu.list(bodyguards_options, "Select Model", {}, "")
	menu.divider(bodyguards_model_list, "Bodyguard Model")
	menu.action(bodyguards_model_list, "Random Model", {}, "", function()
		bodyguard_random_model = true
		shownotification("Bodyguard model: ~r~random~s~")
	end)
	for k, model in pairs(peds) do
		menu.action(bodyguards_model_list, k, {}, "", function()
			bodyguard_model = model
			bodyguard_random_model = false
			shownotification("Bodyguard model: ~r~"..k.."~s~")
		end)
	end

	menu.action(bodyguards_options, "Clone Player (Bodyguard)", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local size_ptr =  memory.alloc(32)
		local any_ptr = memory.alloc(32)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local groupId = PLAYER.GET_PLAYER_GROUP(pid); PED.GET_GROUP_SIZE(groupId, any_ptr, size_ptr); local groupSize = memory.read_int(size_ptr); memory.free(size_ptr); memory.free(any_ptr)
		if groupSize >= 7 then
			shownotification("~r~You reached the max number of bodyguards")
			return
		end
		pos.z = pos.z - 0.9
		pos.x = pos.x + math.random(-3, 3)
		pos.y = pos.y + math.random(-3, 3)
		local weapon
		if bodyguard_random_weapon then
			weapon = random_weapons[math.random(1, #random_weapons)]
		else
			weapon = bodyguard_weapon
		end
		local clone = PED.CLONE_PED(player_ped, 1, 1, 1); add_model_to_list(spawned_bodyguards, "mp_f_freemode_01"); add_model_to_list(spawned_bodyguards, "mp_m_freemode_01")
		WEAPON.GIVE_WEAPON_TO_PED(clone, util.joaat(weapon), 9999, false, true)
		PED.SET_PED_HIGHLY_PERCEPTIVE(clone, true)
		PED.SET_PED_COMBAT_RANGE(clone, 2)
		PED.SET_PED_SEEING_RANGE(clone, 100.0)
		ENTITY.SET_ENTITY_COORDS(clone, pos.x, pos.y, pos.z)
		ENTITY.SET_ENTITY_INVINCIBLE(clone, bodyguardGodmode)
		PED.SET_PED_AS_GROUP_MEMBER(clone, groupId)
		PED.SET_PED_NEVER_LEAVES_GROUP(clone, true)
		PED.SET_GROUP_FORMATION(groupId, 0)
		PED.SET_GROUP_FORMATION_SPACING(groupId, 1.0, 0.9, 3.0)
		set_ent_face_ent(clone, player_ped)
	end)

	local bodyguards_weapon_list = menu.list(bodyguards_options, "Select Weapon", {}, "")
	menu.divider(bodyguards_weapon_list, "Bodyguard Weapon")
	local bodyguards_melee_list = menu.list(bodyguards_weapon_list, "Melee")
	for k, weapon in pairs(melee_weapons) do
		menu.action(bodyguards_melee_list, k, {}, "", function()
			bodyguard_weapon = weapon
			bodyguard_random_weapon = false
			shownotification("Bodyguard weapon: ~r~"..k.."~s~")
		end)
	end
	menu.action(bodyguards_weapon_list, "Random Weapon", {}, "", function()
		bodyguard_random_weapon = true
		shownotification("Bodyguard weapon: ~r~random~s~")
	end)
	for k, weapon in pairs(weapons) do
		menu.action(bodyguards_weapon_list, k, {}, "", function()
			bodyguard_weapon = weapon
			bodyguard_random_weapon = false
			shownotification("Bodyguard weapon: ~r~"..k.."~s~")
		end)
	end

	menu.toggle(bodyguards_options, "Invincible Bodyguards", {}, "", function(on)
		bodyguardGodmode = on
	end)

	menu.action(bodyguards_options, "Delete Bodyguards", {}, "", function()
		for k, model in pairs(spawned_bodyguards) do
			delete_entities_by_model(model)
			spawned_bodyguards[k] = nil
		end
	end)

-------------------------------------------------
--BACKUP HELICOPTER
-------------------------------------------------
	
	local backupGodmode = false
	local backup_heli_option = menu.list(friendly_list, "Backup Helicopter")
	menu.divider(backup_heli_option, "Backup Helicopter")
	menu.action(backup_heli_option, "Spawn Backup Helicopter", {}, "", function()
		local player_ped =  PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		pos.x = pos.x + math.random(-20, 20)
		pos.y = pos.y + math.random(-20, 20)
		pos.z = pos.z + math.random(20, 40)
		local heli_hash = util.joaat("buzzard2")
		local ped_hash = util.joaat("s_m_y_blackops_01")
		local missionActive
		local player_rel_group_ptr = memory.alloc()
		local blip

		STREAMING.REQUEST_MODEL(ped_hash)
		STREAMING.REQUEST_MODEL(heli_hash)
		while not STREAMING.HAS_MODEL_LOADED(ped_hash) or not STREAMING.HAS_MODEL_LOADED(heli_hash) do
			util.yield()
		end
			--CREATING RELATIONSHIP GROUP HASH
		PED.ADD_RELATIONSHIP_GROUP("player_rel_group", player_rel_group_ptr)
		local player_rel_group = memory.read_int(player_rel_group_ptr)
		memory.free(player_rel_group_ptr)
		PED.SET_PED_RELATIONSHIP_GROUP_HASH(player_ped, player_rel_group)
		
		local heli= util.create_vehicle(heli_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		if not ENTITY.DOES_ENTITY_EXIST(heli) then 
			shownotification("~r~Failed to create buzzard. Please try again")
			return
		else
			local heliNetId = NETWORK.VEH_TO_NET(heli)
			if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(NETWORK.NET_TO_PED(heliNetId)) then
				NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(heliNetId, true)
			end
			NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(heliNetId, players.user(), true)
			ENTITY.SET_ENTITY_INVINCIBLE(heli, godmode)
			VEHICLE.SET_VEHICLE_ENGINE_ON(heli, true, true, true)
			VEHICLE.SET_HELI_BLADES_FULL_SPEED(heli)
			VEHICLE.SET_VEHICLE_SEARCHLIGHT(heli, true, true)
			--ENTITY.SET_ENTITY_CAN_BE_DAMAGED_BY_RELATIONSHIP_GROUP(heli, false, relhash)
			ENTITY.SET_ENTITY_INVINCIBLE(heli, backupGodmode)
			blip = add_blip_for_entity(heli, 422, 26)
		end

		local function create_ped_into_vehicle(seat, godmode)
			local pedNetId = NETWORK.PED_TO_NET(util.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z))
			if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(NETWORK.NET_TO_PED(pedNetId)) then
				NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(pedNetId, true)
			end
			NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(pedNetId, players.user(), true)
			local ped = NETWORK.NET_TO_PED(pedNetId)
			PED.SET_PED_INTO_VEHICLE(ped, heli, seat)
			WEAPON.GIVE_WEAPON_TO_PED(ped, util.joaat("weapon_combatmg"), 9999, false, true)
			PED.SET_PED_COMBAT_ATTRIBUTES(ped, 5, true)
			PED.SET_PED_COMBAT_ATTRIBUTES(ped, 3, false)
			PED.SET_PED_COMBAT_MOVEMENT(ped, 2)
			PED.SET_PED_COMBAT_ABILITY(ped, 2)
			PED.SET_PED_COMBAT_RANGE(ped, 2)
			PED.SET_PED_SEEING_RANGE(ped, 100.0)
			PED.SET_PED_TARGET_LOSS_RESPONSE(ped, 1)
			PED.SET_PED_HIGHLY_PERCEPTIVE(ped, true)
			PED.SET_PED_VISUAL_FIELD_PERIPHERAL_RANGE(ped, 400.0)
			PED.SET_COMBAT_FLOAT(ped, 10, 400.0)
			PED.SET_PED_MAX_HEALTH(ped, 500)
			ENTITY.SET_ENTITY_HEALTH(ped, 500)
			ENTITY.SET_ENTITY_INVINCIBLE(ped, godmode)
			PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, player_rel_group)
			return pedNetId
		end

		local pilot = NETWORK.NET_TO_PED(create_ped_into_vehicle(-1, backupGodmode))
		PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pilot, true)
		for seat = 1, 2 do
			create_ped_into_vehicle(seat, backupGodmode)
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(heli_hash)

		local function give_task_to_pilot(param0, param1)
			if param1 ~= param0 then
				if param0 == 0 then
					TASK.TASK_HELI_CHASE(pilot, player_ped, 0, 0, 50)
					PED.SET_PED_KEEP_TASK(pilot, true)
				end
				if param0 == 1 then
					TASK.TASK_HELI_MISSION(pilot, heli, 0, player_ped, 0.0, 0.0, 0.0, 23, 20.0, 40.0, -1.0, SYSTEM.CEIL(-1.0), 10, -1.0, 0)
					PED.SET_PED_KEEP_TASK(pilot, true)
				end
			end
			return param0
		end
		
		util.create_thread(function()
			local param0, param1
			flee_backup = false
			while ENTITY.GET_ENTITY_HEALTH(pilot) > 0 do
				local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				local a, b = ENTITY.GET_ENTITY_COORDS(player_ped), ENTITY.GET_ENTITY_COORDS(heli)
				
				if MISC.GET_DISTANCE_BETWEEN_COORDS(a.x, a.y, a.z, b.x, b.y, b.z, true) > 90 then
					param0 = 0
				else
					param0 = 1
				end
				param1 = give_task_to_pilot(param0, param1)
				util.yield()
			end
		end)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
	end)

	menu.toggle(backup_heli_option, "Invincible Backup", {}, "", function(on)
		backupGodmode = on
	end)

	menu.action(backup_heli_option, "Delete Buzzards", {}, "", function()
		delete_entities_by_model("buzzard2"); delete_entities_by_model("s_m_y_blackops_01")
	end)

-------------------------------------------------
--KILL KILLERS
-------------------------------------------------

	menu.toggle(friendly_list, "Kill Killers", {"explokillers"}, "Explodes those players who kill this guy.", function(on)
		kill_killers = on
		while kill_killers do
			local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
			local killer = PED.GET_PED_SOURCE_OF_DEATH(player_ped)
			if killer ~= 0 and killer ~= player_ped then
				local pos = ENTITY.GET_ENTITY_COORDS(killer)
				FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 1, 99999, true, false, 1)
				util.yield(500)
				while PLAYER.IS_PLAYER_DEAD(players.user()) do
					util.yield()
				end
			end
			util.yield()
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------

local defaulthealth = ENTITY.GET_ENTITY_MAX_HEALTH(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))

local modhealth
local modded_health = defaulthealth

--display health stuff
local screen_w, screen_h = directx.get_client_size() --from BoperSkript
function _x(yes)
	return yes / screen_w
end
function _y(yes)
	return yes / screen_h
end

-------------------------------------------------HEALTH OPTIONS--------------------------------------------------------------------

local self_options = menu.list(menu.my_root(), "Self", {"selfoptions"}, "")

menu.toggle(self_options, "Mod Health", {"modhealth"}, "Changes your ped\'s max health. Some menus will tag you as modder. It returns to defaulf max health when it\'s disabled.", function(on)
	modhealth  = on
	if modhealth then
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		PED.SET_PED_MAX_HEALTH(player_ped,  modded_health)
		ENTITY.SET_ENTITY_HEALTH(player_ped, modded_health)
		if PED.GET_PED_MAX_HEALTH(player_ped) == modded_health then
			shownotification("Mod Health is ~r~on~s~")
		else 
			shownotification("~r~Something went wrong")
			return
		end
	else
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		PED.SET_PED_MAX_HEALTH(player_ped, defaulthealth)
		menu.trigger_commands("maxhealth "..defaulthealth) -- just if you want the slider to go to defaulf value when mod health is off
		if ENTITY.GET_ENTITY_HEALTH(player_ped) > defaulthealth then 
			ENTITY.SET_ENTITY_HEALTH(player_ped, defaulthealth)
		end
		if PED.GET_PED_MAX_HEALTH(player_ped) == defaulthealth then
			shownotification("Mod Health is ~r~off~s~. Default max health: "..defaulthealth)
		else 
			shownotification("~r~Something went wrong")
			return
		end
	end
	while modhealth do
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		if PED.GET_PED_MAX_HEALTH(player_ped) ~= modded_health  then
			PED.SET_PED_MAX_HEALTH(player_ped, modded_health)
			ENTITY.SET_ENTITY_HEALTH(player_ped, modded_health)	
		end
		--thanks to boper skript
		if display then
			local logo = directx.create_texture(scriptdir.."\\WiriScript\\logo.png")
			local text = "WiriScript | Player Health: "..ENTITY.GET_ENTITY_HEALTH(player_ped).."/"..PED.GET_PED_MAX_HEALTH(player_ped)
			local wmtxt_x, wmtxt_y = directx.get_text_size(text, 0.75)
			local wmposx,wmposy = _x(80),_y(25) + wmtxt_y*0.4 --change the text position here
		
			local aspect_ratio = GRAPHICS._GET_ASPECT_RATIO()
			directx.draw_texture_client(
				logo,	 			-- id
				0,					-- index
				-9999,				-- level
				0,					-- time
				0.015,				-- sizeX
				0.015,				-- sizeY
				0.0,				-- centerX
				0.5,				-- centerY
				wmposx-wmposx*0.6,	-- posX
				wmposy+wmposy*0.35,	-- posY
				0,					-- rotation
				aspect_ratio,		-- screenHeightScaleFactor
				{					-- colour
					["r"] = 1.0,
					["g"] = 1.0,
					["b"] = 1.0,
					["a"] = 1.0
				}
			)
			directx.draw_text_client(wmposx, wmposy, text, ALIGN_TOP_LEFT, 0.7,  {["r"] = 1.0,["g"] = 1.0,["b"] = 1.0,["a"] = 1.0}, true)
			directx.draw_rect(wmposx-wmposx*0.6, wmposy - wmtxt_y*0.3, wmtxt_x+wmtxt_x*0.13, wmtxt_y + wmtxt_y*0.5, {["r"] = 0.0,["g"] = 0.0,["b"] = 0.0,["a"] = 0.2})
		end
		util.yield()
	end
end, false)

menu.slider(self_options, "Modded Health", {"maxhealth"}, "Health will be modded with the given value.", 100,9000,defaulthealth,50, function(value)
	modded_health = value
end)

menu.action(self_options, "Max Health", {"healplayer"}, "", function()
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	ENTITY.SET_ENTITY_HEALTH(player_ped, PED.GET_PED_MAX_HEALTH(player_ped))
end)

menu.action(self_options, "Max Armour", {"maxarmor"}, "", function()
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	PED.SET_PED_ARMOUR(player_ped, 50)
end)

local refillincover
menu.toggle(self_options, "Refill Health When in Cover", {}, "", function(on)
	refillincover = on
	while refillincover do
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		if PED.IS_PED_IN_COVER(player_ped) then
			PLAYER._SET_PLAYER_HEALTH_RECHARGE_LIMIT(players.user(), 1)
			PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), 15)
		else
			PLAYER._SET_PLAYER_HEALTH_RECHARGE_LIMIT(players.user(),0.5)
			PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), 1)
		end
		util.yield()
	end
	if not refillincover then
		PLAYER._SET_PLAYER_HEALTH_RECHARGE_LIMIT(players.user(), 0.5)
		PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), 1)
	end
end)

--------------------------------------------FORCEFIELD------------------------------------------------------------------

menu.toggle(self_options, "Forcefield", {"forcefield"}, "Push nearby entities away.", function(on)
	forcefield = on
	util.create_thread(function()
		if forcefield then
			shownotification("Forcefield is ~r~on~s~")
		end
		while forcefield do
			local a = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
			local entities = get_nearby_entities(players.user(), 10, true, true)
			for key, value in pairs(entities) do
				util.create_thread(function()
					local b = ENTITY.GET_ENTITY_COORDS(value)
					local dx = b.x - a.x
					local dy = b.y - a.y
					local dz = b.z - a.z
					local mag =  SYSTEM.VMAG(dx, dy, dz)
					local force = {x = dx/mag, y = dy/mag, z = dz/mag}
					if request_control_ent(value) then
						ENTITY.APPLY_FORCE_TO_ENTITY(value, 1, force.x, force.y, force.z, 0, 0, 0.5, 0, false, false, true)
					end
					if ENTITY.IS_ENTITY_A_PED(value) then
						PED.SET_PED_TO_RAGDOLL(value, 1000, 1000, 0, 0, 0, 0)
					end
					util.stop_thread()
				end)
			end
			util.yield()
		end
		shownotification("Forcefield is ~r~off~s~")
		util.stop_thread()
	end)
end, false)

-----------------------------------------------FORCE---------------------------------------------------------------------

menu.toggle(self_options, "Force", {"force"}, "Use force in nearby vehicles. Controls: [NUM 9] & [NUM 6].", function(on)
	force = on
	util.create_thread(function()
		if force then
			shownotification("Force is ~r~on~s~. Use [NUM 9] & [NUM 6] to become a jedi")
			local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
			local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
			local effectAsset = "scr_ie_tw"
			local effectName = "scr_impexp_tw_take_zone"
			STREAMING.REQUEST_NAMED_PTFX_ASSET(effectAsset)
			while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(effectAsset) do
				util.yield()
			end
			GRAPHICS.USE_PARTICLE_FX_ASSET(effectAsset)
		
			local fx = GRAPHICS.START_PARTICLE_FX_LOOPED_ON_ENTITY(effectName, player_ped, 0, 0, -0.9, 0, 0, 0, 1, false, false, false)
			util.yield(4000)
			GRAPHICS.STOP_PARTICLE_FX_LOOPED(fx, true)
			GRAPHICS.REMOVE_PARTICLE_FX(fx, 0)
		end
	end)
	while force do
		local entities = get_nearby_entities(players.user(), 30, false, true)
		if PAD.IS_CONTROL_PRESSED(0, 118) then
			for k, entity in pairs(entities) do
				if request_control_ent(entity) then 
					ENTITY.APPLY_FORCE_TO_ENTITY(entity, 1, 0, 0, 0.5, 0, 0, 0, 0, false, false, true)
				end
			end
		end
		if PAD.IS_CONTROL_PRESSED(0, 109) then
			for k, entity in pairs(entities) do
				if request_control_ent(entity) then 
					ENTITY.APPLY_FORCE_TO_ENTITY(entity, 1, 0, 0, -70, 0, 0, 0, 0, false, false, true)
				end
			end
		end
		util.yield()
	end
	shownotification("Jedi mode is ~r~off~s~")	
end)

---------------------------------------------------KILL KILLERS----------------------------------------------------------

menu.toggle(self_options, "Kill Killers", {"explokillers"}, "Explodes any player who kills you.", function(on)
	kill_killers = on
	while kill_killers do
		local user_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		local killer = PED.GET_PED_SOURCE_OF_DEATH(user_ped)
		if killer ~= 0 and killer ~= user_ped then
			local pos = ENTITY.GET_ENTITY_COORDS(killer)
			FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z, 1, 99999, true, false, 1)
			util.yield(500)
			while PLAYER.IS_PLAYER_DEAD(players.user()) do
				util.yield()
			end
		end
		util.yield()
	end
end)

---------------------------------------------------UNDEAD OFFRADAR-------------------------------------------------------

menu.toggle(self_options, "Undead Offradar", {"undeadoffradar"}, "Decreases your ped max health to set you off the radar. Reveal Off Radar Players won't work on you when using this option. Some menus will tag you as modder. ", function(on)
	undead = on
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	local defaulthealth = ENTITY.GET_ENTITY_MAX_HEALTH(player_ped)
	if undead then
		ENTITY.SET_ENTITY_MAX_HEALTH(player_ped, 0)
	end
	while undead do
		if ENTITY.GET_ENTITY_MAX_HEALTH(player_ped) ~= 0 then
			ENTITY.SET_ENTITY_MAX_HEALTH(player_ped, 0)
		end
		util.yield()
	end
	ENTITY.SET_ENTITY_MAX_HEALTH(player_ped, defaulthealth)
end)

----------------------------------------------------PAINT GUN-----------------------------------------------------------

local weapons_options = menu.list(menu.my_root(), "Weapons")

menu.divider(weapons_options, "Weapons")

menu.toggle(weapons_options, "Vehicle Paint Gun", {"paintgun"}, "Applies a random colour combination to the damaged vehicle.", function(on)
	paintgun = on
	if paintgun then
		shownotification("Vehicle paint gun is ~r~on~s~")
	end
	while paintgun do
		if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
			local entity_ptr = memory.alloc(32); PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(PLAYER.PLAYER_ID(), entity_ptr); local entity = memory.read_int(entity_ptr); memory.free(entity_ptr)
			if entity == 0 then return end
			if ENTITY.IS_ENTITY_A_PED(entity) then
				entity = PED.GET_VEHICLE_PED_IS_IN(entity, false)
			end
			if ENTITY.IS_ENTITY_A_VEHICLE(entity) then
				request_control_ent(entity)
				VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(entity, math.random(0,255), math.random(0,255), math.random(0,255))
				VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(entity, math.random(0,255), math.random(0,255), math.random(0,255))
			end
		end
		util.yield()
	end
end)

-----------------------------------------------------SHOOTING EFFECT-----------------------------------------------------

local shooting_effects = {
	{
		"Clown Flowers", "scr_rcbarry2", "scr_clown_bul", 
		0.3, 	--scale
		0, 		--xRot
		180, 	--yRot
		0 		--zRot
	},
	{
		"Clown Muzzel", "scr_rcbarry2", "muz_clown", 
		0.8,
		0,
		0,
		0
	},
	{
		"Khanjali Railgun", "veh_khanjali", "muz_xm_khanjali_railgun", 
		1,
		0,
		0,
		-90
	}
}
local cartoon_gun = menu.list(weapons_options, "Custom Shotting Effect")
local GunEffectAsset
local GunEffectName
local scale = 0.4
local effectRot = {x = 0, y =180, z = 0}
menu.toggle(cartoon_gun, "Toggle Shotting Effect", {"shootingeffect"}, "Effects while shooting.", function(on)
	cartoon = on
	if GunEffectAsset == nil then
		shownotification("~r~Please choose a shooting effect")
		while GunEffectAsset == nil do
			util.yield()
		end
	end
	if cartoon then
		shownotification("Shooting effect is ~r~on~s~")
	end
	local user = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	local effects = {}
	STREAMING.REQUEST_NAMED_PTFX_ASSET(GunEffectAsset)
	while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(GunEffectAsset) do
		util.yield()
	end

	util.create_thread(function()
		while cartoon do
			if PED.IS_PED_SHOOTING(user) then
				local weapon = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(user, false)
				GRAPHICS.USE_PARTICLE_FX_ASSET(GunEffectAsset)
				local fx = GRAPHICS.START_PARTICLE_FX_LOOPED_ON_ENTITY_BONE(
					GunEffectName, weapon,
					0.15, 			--xOffset
					0, 				--yOffset
					0, 				--zOffset
					effectRot.x, 	--xRot
					effectRot.y, 	--yRot
					effectRot.z, 	--zRot
					ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(weapon, "gun_muzzle"), --boneIndex
					scale, --scale
					false, false, false
				)
				effects[#effects+1] = fx
			end
			util.yield()
		end
		util.stop_thread()
	end)
	while cartoon do
		for k, effect in pairs(effects) do
			GRAPHICS.STOP_PARTICLE_FX_LOOPED(effect, 0)
			GRAPHICS.REMOVE_PARTICLE_FX(effect, 0)
			effects[k] = nil
		end
		util.yield(500)
	end
	for k, effect in pairs(effects) do
		GRAPHICS.STOP_PARTICLE_FX_LOOPED(effect, 0)
		GRAPHICS.REMOVE_PARTICLE_FX(effect, 0)
		effects[k] = nil
	end
end)

menu.divider(cartoon_gun, "Custom Shotting Effect")

for j = 1, #shooting_effects do
	menu.action(cartoon_gun, shooting_effects[j][1], {}, "", function()
		GunEffectAsset = shooting_effects[j][2]
		GunEffectName = shooting_effects[j][3]
		scale = shooting_effects[j][4]
		effectRot = {
			x = shooting_effects[j][5],
			y = shooting_effects[j][6],
			z = shooting_effects[j][7]
		}
		menu.trigger_commands("shootingeffect off")
		shownotification("Shooting effect: ~r~"..shooting_effects[j][1].."~s~")
		util.yield(500)
		menu.trigger_commands("shootingeffect on")
	end)
end

-------------------------------------------------TRAILS-----------------------------------------------------------

local bones = {
	['L Hand'] = 0x49D9,
	['R Hand'] = 0xDEAD,
	['L Foot'] = 0x3779,
	['R Foot'] = 0xCC4D
}

local rgb_colour = {
	['r'] = 255,
	['g'] = 0,
	['b'] = 68
}

local trails_options = menu.list(self_options, "Trails")

menu.toggle(trails_options, "Toggle Trails", {"trails"}, "", function(on)
	trails = on
	local trailAsset = "scr_rcpaparazzo1"
	local trailName = "scr_mich4_firework_sparkle_spawn"
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	local effects = {}
	STREAMING.REQUEST_NAMED_PTFX_ASSET(trailAsset)
	while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(trailAsset) do
		util.yield()
	end
	util.create_thread(function()
		while trails do
			if PLAYER.IS_PLAYER_DEAD(players.user()) then
				menu.trigger_commands("trails off")
				while PLAYER.IS_PLAYER_DEAD(players.user()) do
					util.yield()
				end
				menu.trigger_commands("trails on")
			end
			for k, boneId in pairs(bones) do
				GRAPHICS.USE_PARTICLE_FX_ASSET(trailAsset)
				local fx = GRAPHICS.START_NETWORKED_PARTICLE_FX_LOOPED_ON_ENTITY_BONE(
					trailName, 
					player_ped, 
					0, 
					0, 
					0, 
					0, 
					0, 
					0, 
					PED.GET_PED_BONE_INDEX(player_ped, boneId), --int boneIndex, 
					1.2, --scale
					false, false, false
				)
				GRAPHICS.SET_PARTICLE_FX_LOOPED_COLOUR(
					fx, 
					rgb_colour['r'], 
					rgb_colour['g'], 
					rgb_colour['b'], 
					0
				)
				effects[#effects+1] = fx
			end
			util.yield(200)
		end
	end)
	while trails do
		for k, effect in pairs(effects) do
			GRAPHICS.STOP_PARTICLE_FX_LOOPED(effect, 0)
			GRAPHICS.REMOVE_PARTICLE_FX(effect, 0)
			effects[k] = nil
		end
		util.yield(1500)
	end
	for k, effect in pairs(effects) do
		GRAPHICS.STOP_PARTICLE_FX_LOOPED(effect, 0)
		GRAPHICS.REMOVE_PARTICLE_FX(effect, 0)
		effects[k] = nil
	end
end)

menu.rainbow(menu.colour(trails_options, "Colour", {"trails"}, "", {['r'] = 255/255, ['g'] = 0, ['b'] = 255/255, ['a'] = 1.0}, false, function(colour)
	rgb_colour = colour
end))

------------------------------------------------
--AIRSTRIKE AT WAYPOINT
------------------------------------------------

menu.action(weapons_options, "Airstrike At Waypoint", {}, "", function()
	local user_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	local pos = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(8))
	local startTime = os.time() 
	while os.time()-startTime <= 15 do		
		local ground_ptr = memory.alloc()
		pos.x = pos.x + math.random(-6,6)
		pos.y = pos.y + math.random(-6,6)
		MISC.GET_GROUND_Z_FOR_3D_COORD(pos.x, pos.y, pos.z, ground_ptr, false, false)
		pos.z = memory.read_float(ground_ptr)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z+50, pos.x, pos.y, pos.z, 200, true, util.joaat("weapon_airstrike_rocket"), user_ped, true, false, -1.0)
		memory.free(ground_ptr)
		util.yield(500)
	end
end)

-------------------------------------------------
--MAGNET GUN
-------------------------------------------------

menu.toggle(weapons_options, "Magnet Gun", {"magnetgun"}, "", function(on)
	magnet_gun = on
	local user_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	util.create_thread(function()
		while magnet_gun do
			if WEAPON.IS_PED_ARMED(user_ped, 4) and PLAYER.IS_PLAYER_FREE_AIMING(players.user()) then
				local weapon = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(user_ped, false)
				local pos_1 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(weapon, 30.0, 2.0, 0.0)
				GRAPHICS._DRAW_SPHERE(pos_1.x, pos_1.y, pos_1.z, 1, 255, 0, 255, 0.5)
			end
			util.yield()
		end
	end)
	util.create_thread(function()	
		while magnet_gun do
			if WEAPON.IS_PED_ARMED(user_ped, 4) and PLAYER.IS_PLAYER_FREE_AIMING(players.user()) then
				local weapon = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(user_ped, false)
				local pos_1 = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(weapon, 30.0, 2.0, 0.0)
				GRAPHICS._DRAW_SPHERE(pos_1.x, pos_1.y, pos_1.z, 1, 255, 0, 255, 0.5)
				for key, vehicle in pairs(util.get_all_vehicles()) do
					util.create_thread(function()
						local pos_2 = ENTITY.GET_ENTITY_COORDS(vehicle)
						if SYSTEM.VDIST(pos_1.x, pos_1.y, pos_1.z, pos_2.x, pos_2.y, pos_2.z) < 75 then
							if request_control_ent(vehicle) then
								local dx = pos_2.x - pos_1.x
								local dy = pos_2.y - pos_1.y
								local dz = pos_2.z - pos_1.z
								local mag =  SYSTEM.VMAG(dx, dy, dz)
								local force = {x = -dx/mag, y = -dy/mag, z = -dz/mag}
								ENTITY.APPLY_FORCE_TO_ENTITY(vehicle, 1, force.x, force.y, force.z, 0, 0, 0.5, 0, false, false, true)
							end
						end
					end)
				end
			end
			util.yield()
		end
	end)
end)

------------------------------------------------

local vehicle_weapon = menu.list(weapons_options, "Vehicle Weapons")

------------------------------------------------
--AIRSTRIKE AIRCRAFT
------------------------------------------------

menu.toggle(vehicle_weapon, "Airstrike Aircraft", {"airstrikeplanes"}, "Use any plane or helicopter to make airstrikes. Controls: E.", function(on)
	airstrike_plane = on
	if airstrike_plane then
		menu.trigger_commands("vehicleweapons off")
		menu.trigger_commands("vehiclelasers off")
	end
	while airstrike_plane do
		local user_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		local vehicle = PED.GET_VEHICLE_PED_IS_IN(user_ped, false)
		local vehicle_hash = ENTITY.GET_ENTITY_MODEL(vehicle)
		local control = config_list['controls']['Airstrike Aircraft']
		if vehicle ~= 0 then
			if VEHICLE.IS_THIS_MODEL_A_PLANE(vehicle_hash) or VEHICLE.IS_THIS_MODEL_A_HELI(vehicle_hash) then 
				if PAD.IS_CONTROL_PRESSED(0, control) then
					local pos = ENTITY.GET_ENTITY_COORDS(vehicle)
					local startTime = os.time() 
					util.create_thread(function()
						while os.time()-startTime <= 5 do		
							local ground_ptr = memory.alloc()
							MISC.GET_GROUND_Z_FOR_3D_COORD(pos.x, pos.y, pos.z, ground_ptr, false, false)
							ground = memory.read_float(ground_ptr)
							pos.x = pos.x + math.random(-3,3)
							pos.y = pos.y + math.random(-3,3)
							if pos.z - ground > 10 then
								MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z-3, pos.x, pos.y, ground, 200, true, util.joaat("weapon_airstrike_rocket"), user_ped, true, false, -1.0)
							end
							memory.free(ground_ptr)
							util.yield(500)
						end
						util.stop_thread()
					end)
				end
			end
		end
		util.yield(200)
	end
end)

----------------------------------------------------VEHICLE WEAPONS--------------------------------------------------------

function draw_line_from_vehicle(vehicle, startpoint, display)
	local coord1
	local coord2
	local minimum_ptr = memory.alloc()
	local maximum_ptr = memory.alloc()
	MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(vehicle), minimum_ptr, maximum_ptr)
	local minimum = memory.read_vector3(minimum_ptr)
	local maximum = memory.read_vector3(maximum_ptr)
	local startcoords = {
		fl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, maximum.y, 0), --FRONT & LEFT
		fr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, maximum.y, 0)  --FRONT & RIGHT
	}	
	local endcoords = {
		fl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, maximum.y+25, 0),
		fr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, maximum.y+25, 0)
	}
	for k, v in pairs(startcoords, endcoords) do
		if k == startpoint then
			coord1 = startcoords[k]
			coord2 = endcoords[k]
		end
	end
	if display then
		GRAPHICS.DRAW_LINE(coord1.x, coord1.y, coord1.z, coord2.x, coord2.y, coord2.z, 255, 0, 0, 150)
	end
	memory.free(minimum_ptr)
	memory.free(maximum_ptr)
end

function shoot_bullet_from_vehicle(vehicle, weaponName, startpoint)
	local user_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	local weaponHash = util.joaat(weaponName)
	local minimum_ptr = memory.alloc()
	local maximum_ptr = memory.alloc()
	local coord1
	local coord2
	if not WEAPON.HAS_WEAPON_ASSET_LOADED(weaponHash) then
		WEAPON.REQUEST_WEAPON_ASSET(weaponHash, 31, 26)
		while not WEAPON.HAS_WEAPON_ASSET_LOADED(weaponHash) do
			util.yield()
		end
	end
	local veh_coords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
	MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(vehicle), minimum_ptr, maximum_ptr)
	local minimum = memory.read_vector3(minimum_ptr)
	local maximum = memory.read_vector3(maximum_ptr)
	local speed	= ENTITY.GET_ENTITY_SPEED(vehicle) 

	local startcoords = {
		fl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, maximum.y+speed*0.25, 0.3), --FRONT & LEFT
		fr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, maximum.y+speed*0.25, 0.3), --FRONT & RIGHT
		bl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, minimum.y, 0.3), --BACK & LEFT
		br = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, minimum.y, 0.3)  --BACK & RIGHT
	}	
	local endcoords = {
		fl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, maximum.y+50, 0.3),
		fr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, maximum.y+50, 0.3),
		bl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, minimum.y-50, 0.3),
		br = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, minimum.y-50, 0.3)
	}

	for k, v in pairs(startcoords, endcoords) do
		if k == startpoint then
			coord1 = startcoords[k]
			coord2 = endcoords[k]
		end
	end
	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coord1.x, coord1.y, coord1.z, coord2.x, coord2.y, coord2.z, 200, true, weaponHash, user_ped, true, false, -1.0)
	memory.free(minimum_ptr)
	memory.free(maximum_ptr)
end

local vehicle_laser

---------------------------------------------------
--VEHICLE LASER
---------------------------------------------------

menu.toggle(vehicle_weapon, "Vehicle Lasers", {"vehiclelasers"}, "", function(on)
	vehicle_laser = on
	if vehicle_laser then
		menu.trigger_commands("airstrikeplanes off")
	end
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	util.create_thread(function()
		while vehicle_laser do
			local vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
			if vehicle ~= 0 then
				draw_line_from_vehicle(vehicle, "fl", vehicle_laser)
			end
			util.yield()
		end
		util.stop_thread()
	end)
	util.create_thread(function()
		while vehicle_laser do
			local vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
			if vehicle ~= 0 then
				draw_line_from_vehicle(vehicle, "fr", vehicle_laser)
			end
			util.yield()
		end
		util.stop_thread()
	end)
end)

---------------------------------------------------
--VEHICLE WEAPONS
---------------------------------------------------

menu.toggle(vehicle_weapon, "Toggle Vehicle Weapons", {"vehicleweapons"}, "Allows you to shoot bullets with cars. Controls: E.", function(on)
	veh_rockets = on
	if veh_rockets then
		menu.trigger_commands("airstrikeplanes off")
		if selected_veh_weapon == nil then
			shownotification("~r~Please choose a weapon")
			while selected_veh_weapon == nil do
				util.yield()
			end
		end
		shownotification("Vehicle weapon is ~r~on~s~")
	end
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	util.create_thread(function()
		while veh_rockets do
			local control = config_list['controls']['Vehicle Weapons']
			local vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
			if vehicle ~= 0 then
				if PAD.IS_DISABLED_CONTROL_JUST_PRESSED(0, control) then
					local startpoint = "fl"
					if PAD.IS_CONTROL_PRESSED(0, 79) then
						startpoint = "bl"
					end
					shoot_bullet_from_vehicle(vehicle, selected_veh_weapon, startpoint)
				end
			end
			util.yield()
		end
		util.stop_thread()
	end)
	util.create_thread(function()
		while veh_rockets do
			local control = config_list['controls']['Vehicle Weapons']
			local vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
			if vehicle ~= 0 then
				if PAD.IS_DISABLED_CONTROL_JUST_PRESSED(0, control) then
					local startpoint = "fr"
					if PAD.IS_CONTROL_PRESSED(0, 79) then
						startpoint = "br"
					end
					shoot_bullet_from_vehicle(vehicle, selected_veh_weapon, startpoint)
				end
			end
			util.yield()
		end
		util.stop_thread()
	end)

end)

menu.divider(vehicle_weapon, "Vehicle Weapons")

local veh_weapons_list = {
	--['Rockets'] = "weapon_rpg",
	['Up-n-Atomizer'] = "weapon_raypistol",
	['Firework'] = "weapon_firework",
	['Khanjali Heavy Cannon'] = "VEHICLE_WEAPON_KHANJALI_CANNON_HEAVY",
	['Rogue Missile'] = "VEHICLE_WEAPON_ROGUE_MISSILE",
	--['Plane Rocket'] ="VEHICLE_WEAPON_PLANE_ROCKET",
	['Tank Cannon'] = "VEHICLE_WEAPON_TANK",
	['Lazer'] = "VEHICLE_WEAPON_PLAYER_LAZER",
}
			
for k, weapon in pairs(veh_weapons_list) do
	menu.action(vehicle_weapon, k, {}, "", function()
		selected_veh_weapon = weapon
	end)
end

---------------------------------------------------------------------------------------------------------------

for pid = 0,30 do 
	if players.exists(pid) then
		GenerateFeatures(pid)
	end
end

players.on_join(GenerateFeatures)

while true do
	util.yield()
end

--a message for whoever is watching this: I love you <3 XD