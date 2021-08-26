-------------------------------------------------------------------WiriScript v4-------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
This is an open code for you to use and share. Feel free to add, modify or remove features as long as you don't try to sell this script. Please consider 
sharing your own versions with Stand's community.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To have 'Detach Entities' installed would be a good idea. You don't want a monkey attached to a player forever. :D I didn't include detach options cuz
such a nice script exists. 
--]]
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
local version = "4"

util.async_http_get("pastebin.com", "/raw/EhH1C6Dh", function(output)
    if version < output then
        shownotification("~r~WiriScript v"..output.." 已经可供下载")
    end
end,
function ()
    util.log("[WiriScript] 检查更新失败")
end)


function game_notification(message)
	GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT("DIA_ZOMBIE1", 0)
	while not GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED("DIA_ZOMBIE1") do
		util.yield()
	end
	util.BEGIN_TEXT_COMMAND_THEFEED_POST(message..".")

	local tittle = "WiriScript"
	local subtitle = "~c~通知"
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
	{"手枪", "weapon_pistol"}, --{'name shown in Stand', 'weapon ID'}
	{"电击枪", "weapon_stungun"},
	{"原子能枪", "weapon_raypistol"},
	{"卡宾步枪", "weapon_specialcarbine"},
	{"泵动式霰弹枪", "weapon_pumpshotgun"},
	{"战斗机枪", "weapon_combatmg"},
	{"重型狙击步枪", "weapon_heavysniper"},
	{"火神机枪", "weapon_minigun"},
	{"火箭炮（RPG）", "weapon_rpg"}
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
	{"徒手", "weapon_unarmed"}, --{'name shown in Stand', 'weapon ID'}
	{"小刀", "weapon_knife"},
	{"开山刀", "weapon_machete"},
	{"战斗斧", "weapon_battleaxe"},
	{"管钳扳手", "weapon_wrench"},
	{"铁锤", "weapon_hammer"},
	{"棒球棒", "weapon_bat"}
}

local peds = {									--here you can modify which peds are available to choose
	{"囚犯", "s_m_y_prismuscl_01"}, --{'name shown in Stand', 'ped model ID'}
	{"哑剧演员", "s_m_y_mime"},
	{"宇航员", "s_m_m_movspace_01"},
	{"特种兵", "s_m_y_blackops_01"},
	{"特警", "s_m_y_swat_01"},
	{"巴勒帮成员", "csb_ballasog"},
	{"女警官", "s_f_y_cop_01"},
	{"男警官", "s_m_y_cop_01"},
	{"上帝", "u_m_m_jesus_01"},
	{"僵尸", "u_m_y_zombie_01"},
	{"重装兵", "u_m_y_juggernaut_01"},
	{"小丑", "s_m_y_clown_01"}
}

local random_peds = {				--add IDs here if you want
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
	{"战斗机枪", "weapon_combatmg"},
	{"火箭炮（RPG）", "weapon_rpg"}
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

cages = {}
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
			shownotification("~r~未能创建物体")
			return
		end
		cages[#cages+1] = v
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

attackers = {}
function spawn_attacker(pid, ped_type, ped_weapon, godmode, stationary)
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
	pos.z = pos.z - 0.9
	pos.x  = pos.x + math.random(-3, 3)
	pos.y = pos.y + math.random(-3, 3)
	local ped_hash = util.joaat(ped_type)
	local weapon_hash = util.joaat(ped_weapon)
	STREAMING.REQUEST_MODEL(ped_hash)
	while not STREAMING.HAS_MODEL_LOADED(ped_hash) do
		util.yield()
	end
	local ped = util.create_ped(0, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
	attackers[#attackers + 1] = ped
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
	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(spawn_pos.x, spawn_pos.y, spawn_pos.z, target.x , target.y, target.z, damage, 0, weapon_hash, user, true, false, 0)
end

function add_blip_for_entity(entity, blipSprite)
	local blip_ptr = memory.alloc()
	local blip = HUD.ADD_BLIP_FOR_ENTITY(entity)
	memory.write_int(blip_ptr, blip)
	HUD.SET_BLIP_SPRITE(blip, blipSprite)
	HUD.SET_BLIP_COLOUR(blip, 35)
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
end

buzzard_entities = {}
function spawn_buzzard(pid, gunner_weapon)
	local player_ped =  PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
	pos.x = pos.x + math.random(-20, 20)
	pos.y = pos.y + math.random(-20, 20)
	pos.z = pos.z + math.random(20, 40)
	PED.SET_PED_RELATIONSHIP_GROUP_HASH(player_ped, util.joaat("PLAYER"))
	local heli_hash = util.joaat("buzzard2")
	local ped_hash = util.joaat("s_m_y_blackops_01")
	STREAMING.REQUEST_MODEL(ped_hash)
	STREAMING.REQUEST_MODEL(heli_hash)
	while not STREAMING.HAS_MODEL_LOADED(ped_hash) or not STREAMING.HAS_MODEL_LOADED(heli_hash) do
		util.yield()
	end
	local heli = util.create_vehicle(heli_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
	if not ENTITY.DOES_ENTITY_EXIST(heli) then 
		shownotification("~r~未能创建秃鹰直升机，请再试一次")
		return
	end
	buzzard_entities[#buzzard_entities + 1] = heli
	ENTITY.SET_ENTITY_AS_MISSION_ENTITY(heli, true, true)
	VEHICLE._DISABLE_VEHICLE_WORLD_COLLISION(heli)
	ENTITY.SET_ENTITY_INVINCIBLE(heli, buzzard_godmode)
	ENTITY.SET_ENTITY_VISIBLE(heli, buzzard_visible, 0)	
	VEHICLE.SET_VEHICLE_ENGINE_ON(heli, true, true, true)
	VEHICLE.SET_HELI_BLADES_FULL_SPEED(heli)
	add_blip_for_entity(heli, 422)
		
	local pilot = util.create_ped(5, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
	buzzard_entities[#buzzard_entities + 1] = pilot
	PED.SET_PED_RELATIONSHIP_GROUP_HASH(pilot, util.joaat("ARMY"))
	ENTITY.SET_ENTITY_VISIBLE(pilot, buzzard_visible, 0)
	PED.SET_PED_INTO_VEHICLE(pilot, heli, -1)
	PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pilot, true)
	PED.SET_PED_MAX_HEALTH(pilot, 500)
	ENTITY.SET_ENTITY_HEALTH(pilot, 500)
	ENTITY.SET_ENTITY_INVINCIBLE(pilot, buzzard_godmode)

	local gunner = {}
	for i  = 1, 2 do
		gunner[i] = util.create_ped(29, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		buzzard_entities[#buzzard_entities + 1] = gunner[i]
		ENTITY.SET_ENTITY_AS_MISSION_ENTITY(gunner[i], true, true)
		PED.SET_PED_INTO_VEHICLE(gunner[i], heli, i)
		WEAPON.GIVE_WEAPON_TO_PED(gunner[i], util.joaat(gunner_weapon) , 9999, false, true)
		PED.SET_PED_COMBAT_ATTRIBUTES(gunner[i], 20 --[[ they can shoot from vehicle ]], true)
		PED.SET_PED_MAX_HEALTH(gunner[i], 500)
		ENTITY.SET_ENTITY_HEALTH(gunner[i], 500)
		ENTITY.SET_ENTITY_INVINCIBLE(gunner[i], buzzard_godmode)
		ENTITY.SET_ENTITY_VISIBLE(gunner[i], buzzard_visible, 0)
		PED.SET_PED_SHOOT_RATE(gunner[i], 1000)
		PED.SET_PED_RELATIONSHIP_GROUP_HASH(gunner[i], util.joaat("ARMY"))
		TASK.TASK_COMBAT_HATED_TARGETS_AROUND_PED(gunner[i], 1000, 0)
	end
	
	util.create_thread(function()
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(5, util.joaat("ARMY"), util.joaat("PLAYER"))
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(5, util.joaat("PLAYER"), util.joaat("ARMY"))
		PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, util.joaat("ARMY"), util.joaat("ARMY"))
		util.stop_thread()
	end)

	util.create_thread(function()
		while ENTITY.GET_ENTITY_HEALTH(pilot) > 0 do
			local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
			local a = ENTITY.GET_ENTITY_COORDS(player_ped)
			local b = ENTITY.GET_ENTITY_COORDS(heli)
			if MISC.GET_DISTANCE_BETWEEN_COORDS(a.x, a.y, a.z, b.x, b.y, b.z, true) > 90 then
				TASK.TASK_HELI_CHASE(pilot, player_ped, 0, 0, 50)
			else
				TASK.TASK_HELI_MISSION(pilot, heli, 0, player_ped, a.x, a.y, a.z, 23, 30, -1, -1, 10, 10, 5, 0)
			end
			util.yield()
		end
		util.stop_thread()
	end)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(heli_hash)
	STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
	shownotification("秃鹰直升机已送至 "..PLAYER.GET_PLAYER_NAME(pid))
end	

function request_control_ent(entity)
	if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) then
		local tick = 0
		NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
		while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick <= 10 do
			NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
			tick = tick + 1
			util.yield()
		end
	end
	return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity)
end

function get_nearby_entities(pid, radius, peds, vehicles)
	local entities = {}
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
	local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
	local player_veh = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
	
	if vehicles then
		for key, value in pairs(util.get_all_vehicles()) do
			local veh_pos = ENTITY.GET_ENTITY_COORDS(value)
			if value ~= player_veh then
				if MISC.GET_DISTANCE_BETWEEN_COORDS(pos.x, pos.y, pos.z, veh_pos.x, veh_pos.y, veh_pos.z, true) <= radius then
					entities[#entities + 1] = value		
				end
			end
		end
	end
	if peds then
		for key, value in pairs(util.get_all_peds()) do
			if value ~= player_ped then
				local ped_pos = ENTITY.GET_ENTITY_COORDS(value)
				if MISC.GET_DISTANCE_BETWEEN_COORDS(pos.x, pos.y, pos.z, ped_pos.x, ped_pos.y, ped_pos.z, true) <= radius and not PED.IS_PED_A_PLAYER(value) then 
					entities[#entities + 1] = value
				end
			end
		end
	end
	for key, value in pairs(entities) do
		local entity_pos = ENTITY.GET_ENTITY_COORDS(value)
		if MISC.GET_DISTANCE_BETWEEN_COORDS(pos.x, pos.y, pos.z, entity_pos.x, entity_pos.y, entity_pos.z, true) >= radius then
			entities[key] = nil
		end
	end
	return entities
end

function delete_all_entities(list, name)
	local tick = 0
	local deleted = 0
	if #list == 0 then
		shownotification("~r~未能找到 "..name.."")
		return
	end
	for key, value in pairs(list) do
		while ENTITY.DOES_ENTITY_EXIST(value) and tick <= 1000 do
			util.delete_entity(value)
			tick = tick + 1
			util.yield()
		end
		tick = 0
		if not ENTITY.DOES_ENTITY_EXIST(value) then
			deleted = deleted + 1
			list[key] = nil
		end
	end
	if deleted ~= 0 then
		shownotification("~r~"..deleted.." ~s~实体已成功删除")
	end
	if #list ~= 0 then
		shownotification("~r~"..#list.." ~s~无法删除实体")
	end
end

local function get_rid(pid)
	handle_ptr = memory.alloc(104)
   	NETWORK.NETWORK_HANDLE_FROM_PLAYER(pid, handle_ptr, 13)
  	local rid = NETWORK.NETWORK_MEMBER_ID_FROM_GAMER_HANDLE(handle_ptr)
  	memory.free(handle_ptr)
  	return rid
end

settings = menu.list(menu.my_root(), "设置", {}, "")

menu.divider(settings, "设置")

local display = true
menu.toggle(settings, "在修改血量的时候显示血量信息", {}, "", function(on)
	display = on
end, true)

menu.toggle(settings, "使用Stand的通知", {}, "使用Stand的通知样式和系统", function(on)
	standlike = on
end)

-------------------------------------------------SAVE NAME STUFF*-------------------------------------------------------------------------------

local namedata = {}
nameloaddata = (scriptdir.."\\savednames.data")

function namesload()
	if not filesystem.exists(nameloaddata) then return end
	local savednames = menu.list(menu.my_root(), "保存的名称", {}, "")

	local function add_name_to_savednames(name)
		menu.action(savednames, name, {}, "单击以将名称粘贴到 在线/虚假信息/虚假名称/虚假名称 中。在虚假RID之前，您应该使用Stand的“从虚假的名称获取RID”选项。", function() 
			menu.trigger_commands("spoofedname "..name)
			shownotification("Spoofed name: ~r~"..name.."~s~")
		end)
	end
	
	menu.divider(savednames,"保存的名称")
    for line in io.lines(nameloaddata) do namedata[#namedata + 1] = line end
    for i = 1, #namedata do
    	add_name_to_savednames(namedata[i])
	end
	shownotification("已加载保存的名称： ~r~"..#namedata.."~s~")
end
namesload()

-----------------------------------------------------------SPOOFING PROFILE STUFF--------------------------------------------------------------------

local profiles = menu.list(menu.my_root(), "虚假信息配置", {}, "")
local usingprofile = false

menu.action(profiles, "禁用当前配置", {}, "", function()
	if usingprofile then 
		menu.trigger_commands("spoofname off")
		menu.trigger_commands("spoofrid off")
		shownotification("已禁用虚假信息配置，欲使其生效请更换战局")
		usingprofile = false
	else
		shownotification("~r~您当前没有启用任何虚假信息配置")
	end
end)

local profiles_list = {}
local profiles_command_ids = {}
wiriscript_folder = (scriptdir.."\\WiriScript")
-----------------------------
--WiriScript folder exists? 
-----------------------------
if not filesystem.exists(wiriscript_folder) then
	shownotification("~r~WiriScript 文件夹不存在。欲使用 WiriScript，请将压缩包中所有文件拖到 Lua Scripts文件夹中")
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
	
	menu.action(profile_actions, "启用配置", {}, "", function()
		usingprofile = true 
		if spoofname then
			menu.trigger_commands("spoofedname "..name)
			menu.trigger_commands("spoofname on")
		end
		if spoofrid then
			menu.trigger_commands("spoofedrid "..rid)
			menu.trigger_commands("spoofrid hard")
		end
		shownotification("启用的配置: ~r~"..name.."~s~. 欲使其生效请更换战局")
	end)

	menu.action(profile_actions, "删除配置", {}, "", function()
		if click_counter == 1 then
			shownotification("~r~是否确实要删除此配置？再次单击以继续")
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
				table.remove(profiles_list, k)
			end
		end
		menu.delete(profiles_command_ids[j])
		profiles_data:close()
		menu.trigger_commands("clearnotifications")
	end)
	
	menu.divider(profile_actions, "选项")
	menu.toggle(profile_actions, "冒充名称", {}, "", function(on)
		spoofname = on
	end, true)
	menu.toggle(profile_actions, "冒充R* ID: "..rid, {}, "", function(on)
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
		shownotification("已创建新的虚假信息配置: ~r~"..profiles_list[i].name.."~s~")
	else
		for k, v in pairs(profiles_list) do 
			if profiles_list[k].name == name or profiles_list[k].rid == scid then 
				shownotification("~r~虚假信息配置已存在")
				return
			end
		end
		profiles_list[i] = {name = name, rid = scid}
		profiles_data = io.open(profiles_load_data, "a")
		profiles_data:write(json.encode(profiles_list[i]).."\n")
		profiles_data:close()
		add_profile_to_list(profiles_list[i])
		shownotification("已创建新的虚假信息配置: ~r~"..profiles_list[i].name.."~s~")
	end
end

-----------------------------------
--SAVE NEW SPOOFING PROFILE
-----------------------------------
local newname
local newrid
local newprofile = menu.list(profiles, "添加配置文件", {}, "创建新的虚假信息配置")
menu.divider(newprofile, "创建新的虚假信息配置")

menu.action(newprofile, "名称", {"profilename"}, "输入冒充的名称", function()
	if newname ~= nil then 
		menu.show_command_box("profilename "..newname)
	else
		menu.show_command_box("profilename ")
	end
end, function(name)
	newname = name
end)

menu.action(newprofile, "R* ID", {"profilerid"}, "输入冒充的R* ID", function()
	if newrid ~= nil then 
		menu.show_command_box("profilerid "..newrid)
	else
		menu.show_command_box("profilerid ")
	end
end, function(rid)
	newrid = rid
end)

menu.action(newprofile, "保存配置", {}, "", function()
	if newname == nil or newrid == nil then
		shownotification("~r~名称和R* ID不能为空")
		return
	end
	save_spoofing_profile(newname, newrid)
end)
----------------------------------------

menu.divider(profiles, "已保存的配置")

function profilesload()
	if not filesystem.exists(profiles_load_data) then return end
	for line in io.lines(profiles_load_data) do profiles_list[#profiles_list + 1] = json.decode(line) end
	for i = 1, #profiles_list do
		add_profile_to_list(profiles_list[i])
	end
	shownotification("已加载虚假信息配置: ~r~"..#profiles_list.."~s~")
end
profilesload()

-------------------------------------------------------------------------------------------------------------------------------------
GenerateFeatures = function(pid)
	menu.divider(menu.player_root(pid),"WiriScript")		
	
---------------------------------------------------CREATE SPOOFING PROFILE-----------------------------------------------------------------------

	menu.action(menu.player_root(pid), "创建当前玩家的虚假信息配置", {}, "", function()
		local player_name = PLAYER.GET_PLAYER_NAME(pid)
		local player_rid = get_rid(pid)
		save_spoofing_profile(player_name, player_rid)
	end)

--------------------------------------------EXPLOSION AND LOOP STUFF----------------------------------------------------------------------------
	
	trolling_list = menu.list(menu.player_root(pid), "整人选项", {}, "")

	explo_settings = menu.list(trolling_list, "自定义爆炸", {}, "")

	menu.divider(explo_settings, "自定义爆炸")

	menu.slider(explo_settings, "爆炸类型", {"explotype"}, "",0,72,0,1, function(value)
		type = value
	end)
	menu.toggle(explo_settings, "是否可见", {}, "", function(on)
		invisible = on
	end, false)
	menu. toggle(explo_settings, "音效", {}, "", function(on)
		audible = on
	end, true)
	menu.slider(explo_settings, "视角抖动", {"shake"}, "",0,100,1,1, function(value)
		shake = value
	end)
	menu.toggle(explo_settings, "自爆", {}, "", function(on)
		owned = on
	end)

	menu.action(explo_settings, "炸！", {}, "", function()
		explode(pid, type, owned)
	end)

	menu.slider(explo_settings, "循环延迟", {"delay"}, "更改每次爆炸的间隔（单位：毫秒）",50,1000,300,10, function(value)
		delay = value
	end)
		
	menu.toggle(explo_settings, "启用循环爆炸", {},"", function(on)
		explosion_loop = on
		while explosion_loop do
			explode(pid, type, owned)
			util.yield(delay)
		end
	end, false)
	
	menu.toggle(trolling_list, "喷水循环", {},"", function(on)
		hydrant_loop = on
		while hydrant_loop do
			explode(pid, 13, false)
			util.yield(75)
		end
	end, false)

	menu.action(trolling_list, "向玩家发射天基炮", {}, "", function()
		menu.trigger_commands("becomeorbitalcannon on") 
		util.yield(200)
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), pos.x, pos.y, pos.z, 59, 999999.99, true, false, 0)
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

	menu.toggle(trolling_list, "火焰循环", {},"", function(on)
		fire_loop = on
		while fire_loop do
			explode(pid, 12, false)
			util.yield(75)
		end
	end, false)

-------------------------------------------------SHAKE CAM-----------------------------------------------------------------------

	menu.toggle(trolling_list, "摇晃视角", {}, "", function(on)
		shakecam = on
		while shakecam do
			local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
			FIRE.ADD_OWNED_EXPLOSION(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), pos.x, pos.y, pos.z, 0, 0, false, true, 80)
			util.yield(200)
		end
	end)

-------------------------------------------ATTACKER AND CLONE OPTIONS-----------------------------------------------------------------------------

	local attacker_options = menu.list(trolling_list, "生成敌对NPC", {}, "")

	menu.divider(attacker_options, "生成敌对NPC")

	local ped_weapon_list = menu.list(attacker_options, "武器", {}, "更改敌对NPC的武器，默认为手枪。")	
	menu.divider(ped_weapon_list, "NPC武器列表")										
	local ped_melee_list = menu.list(ped_weapon_list, "近战武器", {}, "")

	for i = 1, #weapons do 								--creates the attacker weapon list
		menu.action(ped_weapon_list, weapons[i][1], {}, "", function()
			ped_weapon = weapons[i][2]
			shownotification("生成的NPC将会使用: "..weapons[i][1])
		end)
	end

	for i = 1, #melee_weapons do  --creates the attacker melee weapon list
		menu.action(ped_melee_list, melee_weapons[i][1], {}, "", function()
			ped_weapon = melee_weapons[i][2]
			shownotification("生成的NPC将会使用: "..melee_weapons[i][1])
		end)
	end

	local ped_list = menu.list(attacker_options, "NPC模型", {}, "更改NPC的模型，默认为女警官")

	menu.divider(ped_list, "NPC模型列表")

	for i = 1, #peds do					--creates the attacker appearance list
		menu.action(ped_list, peds[i][1], {}, "", function()
			ped_type = peds[i][2]
			shownotification("NPC将会使用的模型: "..peds[i][1])
		end)
	end

	menu.toggle(attacker_options, "无敌", {}, "生成的NPC拥有无限血量", function(on_godmode)
		godmode = on_godmode
	end, false)

	menu.toggle(attacker_options, "冻结", {}, "生成的NPC将不会移动", function(on)
		stationary = on
	end, false)

	menu.action(attacker_options, "派遣敌对NPC", {}, "", function()
		spawn_attacker(pid, ped_type, ped_weapon, godmode, stationary)
		shownotification("敌对NPC被派遣至: "..PLAYER.GET_PLAYER_NAME(pid))
	end)

	menu.action(attacker_options, "派遣随机敌对NPC", {}, "", function()
		spawn_attacker(pid, random_peds[math.random(#random_peds)], ped_weapon, godmode, stationary)
		shownotification("随机敌对NPC被派遣至: "..PLAYER.GET_PLAYER_NAME(pid))
	end)

	menu.action(attacker_options, "派遣敌对的玩家克隆", {}, "", function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		
		pos.x  = pos.x + math.random(-3, 3)
		pos.y = pos.y + math.random(-3, 3)
		pos.z = pos.z-0.9

		local weapon_hash = util.joaat(ped_weapon)
		clone = PED.CLONE_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 1, 1, 1)
		attackers[#attackers + 1] = clone

		WEAPON.GIVE_WEAPON_TO_PED(clone, weapon_hash, 9999, true, true)
		ENTITY.SET_ENTITY_COORDS(clone, pos.x, pos.y, pos.z)
		ENTITY.SET_ENTITY_INVINCIBLE(clone, godmode)
		PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(clone, true)
		TASK.TASK_COMBAT_PED(clone, PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 16)
		PED.SET_PED_COMBAT_ATTRIBUTES(clone, 46, 1)
		if stationary then
			PED.SET_PED_COMBAT_MOVEMENT(clone, 0)
		end
		shownotification("敌对的玩家克隆被派遣至: "..PLAYER.GET_PLAYER_NAME(pid))
	end)
------------------------------------------------------
--ENEMY CHOP
------------------------------------------------------

	menu.action(attacker_options, "派遣敌对小查", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		pos.z = pos.z - 0.9
		pos.x  = pos.x + math.random(-3, 3)
		pos.y = pos.y + math.random(-3, 3)

		local ped_hash = util.joaat("a_c_chop")
		STREAMING.REQUEST_MODEL(ped_hash)
		while not STREAMING.HAS_MODEL_LOADED(ped_hash) do
			util.yield()
		end
		local ped = util.create_ped(28, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		attackers[#attackers + 1] = ped

		ENTITY.SET_ENTITY_INVINCIBLE(ped, godmode)
		PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
		TASK.TASK_COMBAT_PED(ped, player_ped, 0, 16)
		PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, 1)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		
		shownotification("敌对小查被派遣至: "..PLAYER.GET_PLAYER_NAME(pid))
	end)

-------------------------------------------------------
--SEND POLICE CAR
-------------------------------------------------------

	menu.action(attacker_options, "派遣警车", {}, "Creates a police car which is going to chase and shoot player. ", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local coords_ptr = memory.alloc()
		local nodeId = memory.alloc()
		local coords
		local cop = {}
		local weapons = {
			"weapon_pistol",
			"weapon_pumpshotgun"
		}
		local veh_hash = util.joaat("police3")
		local ped_hash = util.joaat("s_m_y_cop_01")
		STREAMING.REQUEST_MODEL(veh_hash)
		STREAMING.REQUEST_MODEL(ped_hash)
		while not STREAMING.HAS_MODEL_LOADED(veh_hash) or not STREAMING.HAS_MODEL_LOADED(ped_hash) do
			util.yield()
		end
		
		if not PATHFIND.GET_RANDOM_VEHICLE_NODE(pos.x, pos.y, pos.z, 80, 0, 0, 0, coords_ptr, nodeId) then
			pos.x = pos.x + math.random(-20,20)
			pos.y = pos.y + math.random(-20,20)
			PATHFIND.GET_CLOSEST_VEHICLE_NODE(pos.x, pos.y, pos.z, coords_ptr, 1, 100, 2.5)
			coords = memory.read_vector3(coords_ptr)
		end
		coords = memory.read_vector3(coords_ptr)
		memory.free(coords_ptr)
		memory.free(nodeId)

		local veh = util.create_vehicle(veh_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		attackers[#attackers + 1] = veh
		ENTITY.SET_ENTITY_AS_MISSION_ENTITY(veh, true, true)
		set_ent_face_ent(veh, player_ped)
		VEHICLE.SET_VEHICLE_SIREN(veh, true)
		AUDIO.BLIP_SIREN(veh)
		VEHICLE.SET_VEHICLE_ENGINE_ON(veh, true, true, true)
		ENTITY.SET_ENTITY_INVINCIBLE(veh, godmode)
		for i =1, 2 do
			cop[i] = util.create_ped(5, ped_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
			attackers[#attackers + 1] = cop[i]
			ENTITY.SET_ENTITY_AS_MISSION_ENTITY(cop[i], true, true)
			PED.SET_PED_RANDOM_COMPONENT_VARIATION(cop[i], 0)
			WEAPON.GIVE_WEAPON_TO_PED(cop[i], util.joaat(weapons[math.random(1, #weapons)]) , 9999, false, true)
			PED.SET_PED_COMBAT_ATTRIBUTES(cop[i], 1, true)
			PED.SET_PED_AS_COP(cop[i], true)
			PED.SET_PED_INTO_VEHICLE(cop[i], veh, -1+(i-1))
			TASK.TASK_COMBAT_PED(cop[i], player_ped, 0, 16)
			ENTITY.SET_ENTITY_INVINCIBLE(cop[i], godmode)
		end

		util.create_thread(function()
			while ENTITY.GET_ENTITY_HEALTH(cop[1]) > 0 or ENTITY.GET_ENTITY_HEALTH(cop[2]) > 0 do
				local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
				if PLAYER.IS_PLAYER_DEAD(pid) then
					while PLAYER.IS_PLAYER_DEAD(pid) do
						util.yield()
					end
					for i = 1, 2 do
						TASK.TASK_COMBAT_PED(cop[i], player_ped, 0, 16)
					end
				end
				util.yield()
			end
			util.stop_thread()
		end)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_hash)
		shownotification("警用巡逻车正在前往 "..PLAYER.GET_PLAYER_NAME(pid).."的位置")
	end)
	
	menu.action(attacker_options, "删除敌对NPC", {}, "删除所有已生成的敌对NPC和克隆人", function()
		delete_all_entities(attackers, "attackers")
	end)

------------------------------------------CAGE OPTIONS------------------------------------------------------------------------------
	
	local cage_options = menu.list(trolling_list, "套笼", {}, "")
	
	menu.divider(cage_options, "套笼选项")

	menu.action(cage_options, "简易套笼", {"cage"}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped) 
		if PED.IS_PED_IN_ANY_VEHICLE(player_ped, false) then
			menu.trigger_commands("freeze"..PLAYER.GET_PLAYER_NAME(pid).." on")
			util.yield(300)
			if PED.IS_PED_IN_ANY_VEHICLE(player_ped, false) then
				shownotification("~r~未能将玩家踢出载具")
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
	
	menu.toggle(cage_options, "循环套笼", {"autocage"}, "如果玩家逃出笼子，脚本会再次套笼", function(on)
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local a = ENTITY.GET_ENTITY_COORDS(player_ped) --first position
		cage_loop = on
		if cage_loop then
			if PED.IS_PED_IN_ANY_VEHICLE(player_ped, false) then
				menu.trigger_commands("freeze"..PLAYER.GET_PLAYER_NAME(pid).." on")
				util.yield(300)
				if PED.IS_PED_IN_ANY_VEHICLE(player_ped, false) then
					shownotification("~r~未能成功将玩家踢出载具")
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
				shownotification(PLAYER.GET_PLAYER_NAME(pid).." 逃出了笼子，正在重新套笼...")
				::continue::
			end
			util.yield(1000)
		end
	end, false)

------------------------------------------------------
--FENCE
------------------------------------------------------

	menu.action(cage_options, "围栏套笼", {}, "", function()
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
				shownotification("~r~未能成功生成笼子模型")
			end
			cages[#cages + 1] = value
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(object_hash)
	end)

-------------------------------------------------------
--STUNT TUBE
-------------------------------------------------------

	menu.action(cage_options, "特技竞赛道具", {}, "", function()
		local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
		local hash = util.joaat("stt_prop_stunt_tube_s")
		STREAMING.REQUEST_MODEL(hash)

		while not STREAMING.HAS_MODEL_LOADED(hash) do		
			util.yield()
		end
		local cage_object = OBJECT.CREATE_OBJECT(hash, pos.x, pos.y, pos.z, true, true, false)
		cages[#cages + 1] = cage_object

		local rot  = ENTITY.GET_ENTITY_ROTATION(cage_object)
		rot.y = 90
		ENTITY.SET_ENTITY_ROTATION(cage_object, rot.x,rot.y,rot.z,1,true)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
	end)

--------------------------------------------------------
--SIMPLE/AUTOMATIC VERSION
--------------------------------------------------------

	local cage_type_list = menu.list(cage_options, "简易/循环笼子模型", {}, "更改简单套笼和循环套笼使用的笼子模型")
	menu.divider(cage_type_list, "Cage Type")

	for i = 1,2 do
		menu.action(cage_type_list, "Trolly V"..i, {}, "", function()
			cage_type = i
			shownotification("已更改笼子模型: 笼子 "..i)
		end)
	end

	menu.action(cage_options, "删除套笼", {}, "删除所有已生成的笼子模型", function()
		delete_all_entities(cages, "traps")
	end)

------------------------------------------------GUITAR-----------------------------------------------------------------------

	menu.action(trolling_list, "套吉他", {}, "在他们的模型上贴上吉他, 如果他们在车里, 就会引起疯狂的事情, 那看起来真是太棒了!", function()
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
			shownotification("~r~创建实体失败")
		end
		ENTITY.ATTACH_ENTITY_TO_ENTITY(object, PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), PED.GET_PED_BONE_INDEX(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0x5c01), 0.5, -0.2, 0.1, 0, 70, 0, false, true, true --[[Collision - This causes glitch when in vehicle]], false, 0, true)
		--ENTITY.SET_ENTITY_VISIBLE(object, false, 0) --turns guitar invisible
		util.yield(3000)
		if player_ped ~= ENTITY.GET_ENTITY_ATTACHED_TO(object) then
			shownotification("~r~实体未附加。 ~s~可能 "..PLAYER.GET_PLAYER_NAME(pid).." 有附加保护")
			return
		end
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(object_hash)
	end)

----------------------------------------------------RAPE--------------------------------------------------------------------

	local rape_options = menu.list(trolling_list, "Rape")
	menu.divider(rape_options, "强奸")

	menu.action(rape_options, "猴子", {}, "其他玩家可能看不到动画。", function()
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
			shownotification("~r~实体未附加。 ~s~可能 "..PLAYER.GET_PLAYER_NAME(pid).." 有附加保护")
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

	menu.toggle(rape_options, "由我", {}, "", function(on)
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

---------------------------------------------------ENEMY BUZZARD---------------------------------------------------------------------

	local enemy_vehicles = menu.list(trolling_list, "敌方车辆", {}, "")

	menu.divider(enemy_vehicles, "秃鹰直升机")

	buzzard_visible = true
	local gunner_weapon = "weapon_combatmg"
	
	menu.action(enemy_vehicles, "派秃鹰直升机", {}, "", function()
		spawn_buzzard(pid, gunner_weapon)
	end)

	menu.toggle(enemy_vehicles, "无敌", {}, "", function(on)
		buzzard_godmode = on
	end, false)
	
	local menu_gunner_weapon_list = menu.list(enemy_vehicles, "炮手武器")
	menu.divider(menu_gunner_weapon_list, "炮手武器列表")

	for i = 1, #gunner_weapon_list do
		menu.action(menu_gunner_weapon_list, gunner_weapon_list[i][1], {}, "", function()
			gunner_weapon = gunner_weapon_list[i][2]
			shownotification("现在炮手们将用枪射击 "..gunner_weapon_list[i][1].."s")
		end)
	end

	menu.toggle(enemy_vehicles, "可视的", {}, "你不应该那么过分，把它关掉。", function(on)
		buzzard_visible = on
	end, true)

	menu.action(enemy_vehicles, "删除秃鹰直升机", {}, "尝试删除您生成的所有秃鹰直升机。", function()
		delete_all_entities(buzzard_entities, "buzzards")
	end)

-----------------------------------------------DAMAGE----------------------------------------------------------------------------

	local damage = menu.list(trolling_list, "损坏", {}, "选择武器，无论你在哪里都要射杀他们。")
	
	menu.toggle(damage, "观看", {}, "若玩家不可见或距离不够远，你们需要在使用 损坏 之前进行观察。这只是Stand的选项重复。", function(on)
		spectate = on
		if spectate then
			menu.trigger_commands("spectate "..PLAYER.GET_PLAYER_NAME(pid).." on")
		else
			menu.trigger_commands("spectate "..PLAYER.GET_PLAYER_NAME(pid).." off")
		end
	end)

	menu.divider(damage, "损坏")
	local isBulletOwned = true
	

	local damage_value = 200 --default damage value
	menu.action(damage, "重狙击手", {}, "", function()
		shoot_owned_bullet(pid, "weapon_heavysniper", damage_value)
	end)

	menu.action(damage, "猎枪", {}, "", function()
		shoot_owned_bullet(pid, "weapon_pumpshotgun", damage_value)
	end)

	menu.slider(damage, "损害金额", {"damagevalue"}, "The bullet demages player with the given value. ", 10, 1000, 200, 50, function(value)
		damage_value = value
	end)

	menu.toggle(damage, "钥匙", {}, "", function(on)
		tase = on
		while tase do 
			shoot_owned_bullet(pid, "weapon_stungun", 1)
			util.yield(2500)
		end
	end)

-----------------------------------------------------HOSTILE PEDS------------------------------------------------------------------

	menu.action(trolling_list, "敌对的NPC", {}, "所有徒步NPC将与玩家战斗。", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local peds = get_nearby_entities(pid, 80, true, false)
		for k, v in pairs(peds) do
			if not PED.IS_PED_IN_ANY_VEHICLE(v, false) then
				request_control_ent(v)
				TASK.CLEAR_PED_TASKS_IMMEDIATELY(v)
				PED.SET_PED_COMBAT_ATTRIBUTES(v, 46, true)
				PED.SET_PED_MAX_HEALTH(v, 300)
				ENTITY.SET_ENTITY_HEALTH(v, 300)
				WEAPON.GIVE_WEAPON_TO_PED(v, util.joaat(random_weapons[math.random(1, #random_weapons)]), 9999, false, true)
				TASK.TASK_COMBAT_PED(v, player_ped, 0, 0)
				WEAPON.SET_PED_DROPS_WEAPONS_WHEN_DEAD(v, false)
			end
		end
	end)

--------------------------------------------------HOSTILE TRAFFIC-----------------------------------------------------------------

	menu.action(trolling_list, "敌对交通", {}, "", function()
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
				request_control_ent(driver)
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
	
	spawned_minitank = {}
	local minitank_godmode = false
	local hostile_rc_vehicles = menu.list(trolling_list, "手推RC载具")
	menu.divider(hostile_rc_vehicles, "RC 坦克")
	local minitank_godmode = false
	menu.action(hostile_rc_vehicles, "发送 RC 坦克", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local coords_ptr = memory.alloc()
		local nodeId = memory.alloc()
		local coords
		local minitank_hash = util.joaat("minitank")
		local ped_hash = util.joaat("s_m_y_blackops_01")
		STREAMING.REQUEST_MODEL(minitank_hash)
		STREAMING.REQUEST_MODEL(ped_hash)
		while not STREAMING.HAS_MODEL_LOADED(minitank_hash) or not STREAMING.HAS_MODEL_LOADED(ped_hash) do
			util.yield()
		end
		
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
		if not ENTITY.DOES_ENTITY_EXIST(minitank) then 
			shownotification("~r~未能创建 RC 坦克。请再试一次")
			return
		end
		spawned_minitank[#spawned_minitank + 1] = minitank
		ENTITY.SET_ENTITY_AS_MISSION_ENTITY(minitank, true, true)
		add_blip_for_entity(minitank, 742)
		ENTITY.SET_ENTITY_INVINCIBLE(minitank, minitank_godmode)
		VEHICLE.SET_VEHICLE_MOD_KIT(minitank, 0)
		for i = 0, 50 do
			VEHICLE.SET_VEHICLE_MOD(minitank, i, VEHICLE.GET_NUM_VEHICLE_MODS(minitank, i) - 1, false)
		end
		VEHICLE.SET_VEHICLE_ENGINE_ON(minitank, true, true, true)
		set_ent_face_ent(minitank, player_ped)
			
			--DOING THINGS WITH DRIVER
		local driver = util.create_ped(5, ped_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		spawned_minitank[#spawned_minitank + 1] = driver
		ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, true, true)
		PED.SET_PED_COMBAT_ATTRIBUTES(driver, 1, true)
		PED.SET_PED_INTO_VEHICLE(driver, minitank, -1)
		TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, minitank, player_ped, 6, 100, 0, 1, 0, true)
		TASK.TASK_COMBAT_PED(driver, player_ped, 0, 0)
		ENTITY.SET_ENTITY_VISIBLE(driver, false, 0)
		
		util.create_thread(function()
			while ENTITY.GET_ENTITY_HEALTH(minitank) > 0 do
				AUDIO.STOP_CURRENT_PLAYING_SPEECH(driver) --STOP DRIVER SPEECH (NEEDS TO BE CALLED EVERY TICK)
				if PLAYER.IS_PLAYER_DEAD(pid) then
					while PLAYER.IS_PLAYER_DEAD(pid) do
						util.yield()
					end
					local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
					TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, minitank, player_ped, 6, 100, 0, 2, 0, true)
					TASK.TASK_COMBAT_PED(driver, player_ped, 0, 0)
				end
				util.yield()
			end
			util.stop_thread()
		end)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(minitank_hash)
		shownotification("RC 坦克 已经被发送到了"..PLAYER.GET_PLAYER_NAME(pid))
	end)

	menu.toggle(hostile_rc_vehicles, "无敌", {}, "", function(on)
		minitank_godmode = on
	end, false)

	menu.action(hostile_rc_vehicles, "删除 RC 坦克", {}, "尝试删除您生成的所有 RC 坦克。", function()
		delete_all_entities(spawned_minitank, "minitanks")
	end)

-----------------------------------------------TROLLY BANDITO------------------------------------------------------------------
	
	bandito_entities = {}
	local bandito_godmode = false
	menu.divider(hostile_rc_vehicles, "RC 匪徒")
	menu.action(hostile_rc_vehicles, "发送 RC 匪徒", {}, "游戏启动后第一次使用此选项时，您可能会点击两次", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local coords_ptr = memory.alloc()
		local nodeId = memory.alloc()
		local coords

		local bandito_hash = util.joaat("rcbandito")
		local ped_hash = util.joaat("s_m_y_blackops_01")
		STREAMING.REQUEST_MODEL(bandito_hash)
		STREAMING.REQUEST_MODEL(ped_hash)
		while not STREAMING.HAS_MODEL_LOADED(bandito_hash) and not STREAMING.HAS_MODEL_LOADED(ped_hash) do
			util.yield()
		end

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
			shownotification("~r~未能创建 RC 匪徒。请再试一次")
			return
		end
		bandito_entities[#bandito_entities+1] = bandito
		ENTITY.SET_ENTITY_AS_MISSION_ENTITY(bandito, true, true)
		add_blip_for_entity(bandito, 646)
		VEHICLE.SET_VEHICLE_MOD_KIT(bandito, 0)
		for i = 0, 50 do
			VEHICLE.SET_VEHICLE_MOD(bandito, i, VEHICLE.GET_NUM_VEHICLE_MODS(bandito, i) - 1, false)
		end
		VEHICLE.SET_VEHICLE_ENGINE_ON(bandito, true, true, true)
		set_ent_face_ent(bandito, player_ped)

		local driver = util.create_ped(5, ped_hash, coords, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		bandito_entities[#bandito_entities+1] = driver
		ENTITY.SET_ENTITY_AS_MISSION_ENTITY(driver, true, true)
		PED.SET_PED_COMBAT_ATTRIBUTES(driver, 1, true)
		PED.SET_PED_INTO_VEHICLE(driver, bandito, -1)
		TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, bandito, player_ped, 6, 70, 0, 0, 0, true)
		PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
		ENTITY.SET_ENTITY_INVINCIBLE(bandito, bandito_godmode)
		ENTITY.SET_ENTITY_VISIBLE(driver, false, 0)
	
		util.create_thread(function()
			while ENTITY.GET_ENTITY_HEALTH(bandito) > 0 do
				AUDIO.STOP_CURRENT_PLAYING_SPEECH(driver)
				local a = ENTITY.GET_ENTITY_COORDS(player_ped)
				local b = ENTITY.GET_ENTITY_COORDS(bandito)
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
			util.stop_thread()
		end)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(bandito_hash)
		shownotification("RC 匪徒 已经被发送到了 "..PLAYER.GET_PLAYER_NAME(pid))
	end)

	menu.toggle(hostile_rc_vehicles, "在附近时爆炸", {}, "RC 匪徒 将会在他离玩家足够近是爆炸并杀死玩家", function(on)
		explode_bandito = on
	end, false)

	menu.toggle(hostile_rc_vehicles, "无敌", {}, "", function(on)
		bandito_godmode = on
	end, false)

	menu.action(hostile_rc_vehicles, "删除RC匪徒", {}, "尝试删除您生成的所有 RC 匪徒。", function()
		delete_all_entities(bandito_entities, "Bandito")
	end)

---------------------------------------------------HOSTILE JET---------------------------------------------------------------

	local jet_entities = {}

	menu.divider(enemy_vehicles, "天煞")

	menu.action(enemy_vehicles, "发送天煞", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		pos.z = pos.z + 550
		local jet_hash = util.joaat("lazer")
		local ped_hash = util.joaat("s_m_y_blackops_01")

		STREAMING.REQUEST_MODEL(jet_hash)
		STREAMING.REQUEST_MODEL(ped_hash)
		while not STREAMING.HAS_MODEL_LOADED(jet_hash) and not STREAMING.HAS_MODEL_LOADED(ped_hash) do
			util.yield()
		end

		local pilot = util.create_ped(5, ped_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		if not ENTITY.DOES_ENTITY_EXIST(pilot) then 
			shownotification("~r~未能创建天煞。请再试一次")
			return
		end
		jet_entities[#jet_entities+1] = pilot
		ENTITY.SET_ENTITY_AS_MISSION_ENTITY(pilot, true, true)
				
				--DOING THINGS WITH JET
		local jet = util.create_vehicle(jet_hash, pos, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
		if not ENTITY.DOES_ENTITY_EXIST(jet) then 
			shownotification("~r~未能创建天煞。请再试一次")
			util.delete_entity(pilot)
			return
		end
		jet_entities[#jet_entities+1] = jet
		ENTITY.SET_ENTITY_AS_MISSION_ENTITY(jet, true, true)

		add_blip_for_entity(jet, 16)
		VEHICLE._SET_VEHICLE_JET_ENGINE_ON(jet, true)
		VEHICLE.SET_VEHICLE_FORWARD_SPEED(jet, 60)
		VEHICLE.CONTROL_LANDING_GEAR(jet, 3)
		ENTITY.SET_ENTITY_INVINCIBLE(jet, jet_godmode)
		VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(jet, true)
				
				--DOING THINGS WITH PILOT
		PED.SET_PED_INTO_VEHICLE(pilot, jet, -1)
		TASK.TASK_PLANE_MISSION(pilot, jet, 0, player_ped, 0, 0, 0, 6, 100, 0, 0, 80, 50)
		PED.SET_PED_COMBAT_ATTRIBUTES(pilot, 1, true)

		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(ped_hash)
		STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(jet_hash)
	end)

	menu.toggle(enemy_vehicles, "无敌", {}, "", function(on)
		jet_godmode = on
	end, jet_godmode)

	menu.action(enemy_vehicles, "删除天煞", {}, "", function()
		delete_all_entities(jet_entities, "jets")
	end)

--------------------------------------------------------RAM PLAYER--------------------------------------------------------------

	menu.action(trolling_list, "撞死玩家", {}, "", function()
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
		local pos = ENTITY.GET_ENTITY_COORDS(player_ped)
		local offset = {-12, 12}
		pos.x = pos.x + offset[math.random(1, #offset)]
		pos.y = pos.y + offset[math.random(1, #offset)]
		local veh_hash = util.joaat("insurgent2")
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
	
	menu.toggle(trolling_list, "驮运", {}, "", function(on)
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
				ENTITY.ATTACH_ENTITY_TO_ENTITY(user_ped, player_ped, PED.GET_PED_BONE_INDEX(player_ped,0xDD1C), 0, -0.2, 0.65, 0, 0, 180, false, true, true, false, 0, true)
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

	menu.action(trolling_list, "附加外星蛋", {}, "", function()
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

	menu.toggle(trolling_list, "火箭雨", {}, "", function(on)
		rainRockets = on
		while rainRockets do
			local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
			local ground_ptr = memory.alloc()
			local offsetx = math.random(-6,6)
			local offsety = math.random(-6,6)
			MISC.GET_GROUND_Z_FOR_3D_COORD(pos.x, pos.y, pos.z, ground_ptr, false, false)
			pos.z = memory.read_float(ground_ptr)
			MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x+offsetx, pos.y+offsety, pos.z+50, pos.x+offsetx, pos.y+offsety, pos.z, 200, true, util.joaat("weapon_airstrike_rocket"), players.user(), true, false, -1.0--[[is what R* used]])
			memory.free(ground_ptr)
			util.yield(500)
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

local self_options = menu.list(menu.my_root(), "自我", {}, "")

menu.toggle(self_options, "最大生命值", {"modhealth"}, "改变最大生命值，某些菜单可能会将你标记为作弊者，当此选项关闭时，您的生命值会回到默认状态", function(on)
	modhealth  = on
	if modhealth then
		local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		PED.SET_PED_MAX_HEALTH(player_ped,  modded_health)
		ENTITY.SET_ENTITY_HEALTH(player_ped, modded_health)
		if PED.GET_PED_MAX_HEALTH(player_ped) == modded_health then
			shownotification("最大生命值 ~r~开启~s~")
		else 
			shownotification("~r~发生了一些错误")
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
			shownotification("最大生命值 ~r~关闭~s~. 当前生命值: "..defaulthealth)
		else 
			shownotification("~r~发生了一些错误")
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
			local text = "WiriScript | 玩家血量: "..ENTITY.GET_ENTITY_HEALTH(player_ped).."/"..PED.GET_PED_MAX_HEALTH(player_ped)
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

menu.slider(self_options, "设置生命值", {"maxhealth"}, "生命值由自己设置.", 100,9000,defaulthealth,50, function(value)
	modded_health = value
end)

menu.action(self_options, "最大护甲", {}, "", function()
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	PED.SET_PED_ARMOUR(player_ped, 100)
end)

menu.action(self_options, "恢复血量", {}, "", function()
	local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	ENTITY.SET_ENTITY_HEALTH(player_ped, PED.GET_PED_MAX_HEALTH(player_ped))
end)

local refillincover
menu.toggle(self_options, "在墙边回血", {}, "", function(on)
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

--------------------------------------------FORCEFIELD-------------------------------------------------------------------------------------

menu.toggle(self_options, "力场", {"forcefield"}, "降附近的实体推开.", function(on)
	forcefield = on
	util.create_thread(function()
		if forcefield then
			shownotification("力场 ~r~开始~s~")
		end
		while forcefield do
			local a = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
			local entities = get_nearby_entities(players.user(), 10, true, true)
		
			for key, value in pairs(entities) do
				local b = ENTITY.GET_ENTITY_COORDS(value)
				local ab = {x = b.x-a.x, y = b.y-a.y, z = b.z-a.z}
				local mag = math.sqrt(ab.x^2, ab.y^2, ab.z^2)
				local force = {x = ab.x/mag, y = ab.y/mag, z = ab.z/mag}

				if request_control_ent(value) then
					ENTITY.APPLY_FORCE_TO_ENTITY(value, 1, force.x, force.y, force.z, 0, 0, 0.5, 0, false, false, true)
				end

				if ENTITY.IS_ENTITY_A_PED(value) then
					PED.SET_PED_TO_RAGDOLL(value, 1000, 1000, 0, 0, 0, 0)
				end
			end
			util.yield()
		end
		shownotification("力场 ~r~关闭~s~")
		util.stop_thread()
	end)
end, false)

-----------------------------------------------FORCE-------------------------------------------------------------------------------------

menu.toggle(self_options, "控制车辆", {"force"}, "控制附近车辆上下. 通过数字（9）（6）控制.", function(on)
	force = on
	util.create_thread(function()
		if force then
			shownotification("控制车辆 ~r~开启~s~. 控制附近车辆上下. 通过数字（9）（6）控制")
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
			for k, v in pairs(entities) do
				if request_control_ent(v) then 
					ENTITY.APPLY_FORCE_TO_ENTITY(v, 1, 0, 0, 0.5, 0, 0, 0, 0, false, false, true)
				end
			end
		end
		if PAD.IS_CONTROL_PRESSED(0, 109) then
			for k, v in pairs(entities) do
				if request_control_ent(v) then 
					ENTITY.APPLY_FORCE_TO_ENTITY(v, 1, 0, 0, -70, 0, 0, 0, 0, false, false, true)
				end
			end
		end
		util.yield()
	end
	shownotification("控制车辆 ~r~关闭~s~")	
end)

---------------------------------------------------KILL KILLERS---------------------------------------------------------------------

menu.toggle(self_options, "杀死杀死你的人", {"killkillers"}, "爆炸杀死你的人.", function(on)
	kill_killers = on
	while kill_killers do
		local user_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		local killer = PED.GET_PED_SOURCE_OF_DEATH(user_ped)
		if killer ~= 0 and PED.IS_PED_A_PLAYER(killer) and killer ~= user_ped then
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

---------------------------------------------------UNDEAD OFFRADAR-------------------------------------------------------------------

menu.toggle(self_options, "亡灵雷达", {}, "降低你的最大生命值，让你不会被雷达侦测。当使用这个选项时，显示雷达外的玩家对你不起作用。有些菜单会将你标记为作弊者 ", function(on)
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

local weapons_options = menu.list(menu.my_root(), "武器")

menu.divider(weapons_options, "武器")

menu.toggle(weapons_options, "车辆更改颜色枪", {}, "对车辆随机更改颜色", function(on)
	paintgun = on
	if paintgun then
		shownotification("车辆颜色更改 ~r~开启~s~")
	end
	local user = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
	while paintgun do
		local nearbyVehicles = get_nearby_entities(players.user(), 100, false, true)
		for k, vehicle in pairs(nearbyVehicles) do
			if ENTITY.HAS_ENTITY_BEEN_DAMAGED_BY_ENTITY(vehicle, user, 1) then 
				if request_control_ent(vehicle) then
					VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, math.random(0,255), math.random(0,255), math.random(0,255))
					VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, math.random(0,255), math.random(0,255), math.random(0,255))
				end
				ENTITY.CLEAR_ENTITY_LAST_DAMAGE_ENTITY(vehicle)
			end
		end
		util.yield()
	end
end)

-----------------------------------------------------SHOOTING EFFECT--------------------------------------------------------------------

local shooting_effects = {
	{
		"小丑花", "scr_rcbarry2", "scr_clown_bul", 
		0.3, 	--scale
		0, 		--xRot
		180, 	--yRot
		0 		--zRot
	},
	{
		"小丑音乐", "scr_rcbarry2", "muz_clown", 
		0.8,
		0,
		0,
		0
	},
	{
		"可汗嘉丽的子弹", "veh_khanjali", "muz_xm_khanjali_railgun", 
		1,
		0,
		0,
		-90
	}
}

local cartoon_gun = menu.list(weapons_options, "自定义枪支射出效果")

local GunEffectAsset
local GunEffectName
local scale = 0.4
local effectRot = {x = 0, y =180, z = 0}
menu.toggle(cartoon_gun, "切换射击效果", {"shootingeffect"}, "切换射击效果.", function(on)
	cartoon = on
	if GunEffectAsset == nil then
		shownotification("~r~请选择一个射击效果")
		while GunEffectAsset == nil do
			util.yield()
		end
	end
	if cartoon then
		shownotification("射击效果是 is ~r~开启~s~")
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

menu.divider(cartoon_gun, "自定义射击效果")

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
		menu.trigger_commands("射击效果关闭")
		shownotification("射击效果: ~r~"..shooting_effects[j][1].."~s~")
		util.yield(500)
		menu.trigger_commands("射击效果开启")
	end)
end

---------------------------------------------------------TRAILS-----------------------------------------------------------

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

--------------------------------------------------------------------------------------------------------------------------

menu.action(weapons_options, "空袭标记点", {}, "", function()
	local pos = HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(8))
	local startTime = os.time() 
	while os.time()-startTime <= 15 do		
		local ground_ptr = memory.alloc()
		local offsetx = math.random(-6,6)
		local offsety = math.random(-6,6)
		MISC.GET_GROUND_Z_FOR_3D_COORD(pos.x, pos.y, pos.z, ground_ptr, false, false)
		pos.z = memory.read_float(ground_ptr)
		MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x+offsetx, pos.y+offsety, pos.z+50, pos.x+offsetx, pos.y+offsety, pos.z, 200, true, util.joaat("weapon_airstrike_rocket"), players.user(), true, false, -1.0--[[is what R* used]])
		memory.free(ground_ptr)
		util.yield(500)
	end
end)

---------------------------------------------------------------------------------

local vehicle_weapon = menu.list(weapons_options, "车辆武器")

menu.toggle(vehicle_weapon, "空袭飞机", {"airstrikeplanes"}, "使用任何飞机或直升机进行空袭。控制:E.", function(on)
	airstrike_plane = on
	if airstrike_plane then
		menu.trigger_commands("车辆武器 关闭")
		menu.trigger_commands("vehiclelasers off")
	end
	while airstrike_plane do
		local user_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
		local vehicle = PED.GET_VEHICLE_PED_IS_IN(user_ped, false)
		local vehicle_hash = ENTITY.GET_ENTITY_MODEL(vehicle)	
		if vehicle ~= 0 then
			if VEHICLE.IS_THIS_MODEL_A_PLANE(vehicle_hash) or VEHICLE.IS_THIS_MODEL_A_HELI(vehicle_hash) and PAD.IS_CONTROL_PRESSED(0, 86) then
				local pos = ENTITY.GET_ENTITY_COORDS(vehicle)
				local startTime = os.time() 
				util.create_thread(function()
					while os.time()-startTime <= 5 do		
						local ground_ptr = memory.alloc()
						MISC.GET_GROUND_Z_FOR_3D_COORD(pos.x, pos.y, pos.z, ground_ptr, false, false)
						ground = memory.read_float(ground_ptr)
						pos.x = pos.x + math.random(-3,3)
						pos.y = pos.y + math.random(-3,3)
						if ground < pos.z then
							MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z-3, pos.x, pos.y, ground, 200, true, util.joaat("weapon_airstrike_rocket"), players.user(), true, false, -1.0)
						end
						memory.free(ground_ptr)
						util.yield(500)
					end
					util.stop_thread()
				end)
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
		fl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, maximum.y+speed*0.25, 0.5), --FRONT & LEFT
		fr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, maximum.y+speed*0.25, 0.5), --FRONT & RIGHT
		bl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, minimum.y, 0.5), --BACK & LEFT
		br = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, minimum.y, 0.5)  --BACK & RIGHT
	}	
	local endcoords = {
		fl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, maximum.y+50, 0.5),
		fr = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, maximum.y+50, 0.5),
		bl = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, minimum.x, minimum.y-50, 0.5),
		br = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, maximum.x, minimum.y-50, 0.5)
	}

	for k, v in pairs(startcoords, endcoords) do
		if k == startpoint then
			coord1 = startcoords[k]
			coord2 = endcoords[k]
		end
	end
	MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(coord1.x, coord1.y, coord1.z, coord2.x, coord2.y, coord2.z, 200, true, weaponHash, players.user(), true, false, -1.0)
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
			local vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
			if vehicle ~= 0 then
				if PAD.IS_DISABLED_CONTROL_JUST_PRESSED(0, 86) then
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
			local vehicle = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
			if vehicle ~= 0 then
				if PAD.IS_DISABLED_CONTROL_JUST_PRESSED(0, 86) then
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

menu.divider(vehicle_weapon, "车辆武器")

local veh_weapons_list = {
	['火箭'] = "weapon_rpg",
	['Up-n-Atomizer'] = "weapon_raypistol",
	['烟花'] = "weapon_firework"
}

for k, weapon in pairs(veh_weapons_list) do
	menu.action(vehicle_weapon, k, {}, "", function()
		selected_veh_weapon = weapon
	end)
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

	while os.time() - startTime <=8 do
    	GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scaleform, 255, 255, 255, 255, 0)
   		util.yield(1)
	end
end)

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
