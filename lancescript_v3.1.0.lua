-- coded by lance#8213, from scratch
-- if you are stealing my code to use it in another menu actually kys
require("natives-1627063482")
ocoded_for = 1.57
version = "3.1.0"
online_v = tonumber(NETWORK._GET_ONLINE_VERSION())
if online_v > ocoded_for then
    util.toast("This script is outdated for the current GTA:O version (" .. online_v .. ", coded for " .. ocoded_for .. "). Some options may not work, but most should.")
end

self_root = menu.list(menu.my_root(), "Self", {"lancescriptself"}, "")
weapons_root = menu.list(menu.my_root(), "Weapons", {"lancescriptweapons"}, "")
protections_root = menu.list(menu.my_root(), "Protections", {"lancescriptprotections"}, "")
noclip_root = menu.list(self_root, "Noclip", {"lancescriptnoclip"}, "")
world_root = menu.list(menu.my_root(), "World", {"lancescriptworld"}, "")
entity_root = menu.list(menu.my_root(), "Nearby vehicles/objects", {"lancescriptentity"}, "")
npc_root = menu.list(menu.my_root(), "Nearby NPCs", {"lancescriptnpcs"}, "")
tasks_root = menu.list(npc_root, "Tasks", {"lancescripttasks"}, "")
vehicle_root = menu.list(menu.my_root(), "Vehicle", {"lanceobjecttroll"}, "")
online_root = menu.list(menu.my_root(), "Online", {"lancescriptonline"}, "")
allplayers_root = menu.list(menu.my_root(), "All players", {"lancescriptallplayers"}, "")
--business_root = menu.list(online_root, "Business management", {"lancescriptbusiness"}, "")
gametweaks_root = menu.list(menu.my_root(), "Game tweaks", {"lancescriptgametweaks"}, "")
fakemessages_root = menu.list(gametweaks_root, "Fake messages", {"lancescriptfakemessages"}, "")
radio_root = menu.list(gametweaks_root, "Radio", {"lancescriptradio"}, "")
lancescript_root = menu.list(menu.my_root(), "LanceScript", {"lancescriptutil"}, "")
sounds_root = menu.list(lancescript_root, "Sounds", {"lancescriptsounds"}, "")

punchlines = {"we do not care", "3take2", "mIRroR On ThE WAlL", "i wont exit scam- you never paid a dollar for me!", "stand on top top top", "sainan based", "also check out phoenixscript!", "also check out wiriscript!", "¦", "sponsored by kiddions. jk", "NOT luna v2!", "ACTUALLY real!!!",
"another wonderful product by taketwo interactive", "if you like lancescript you\'ll LOVE lancescript live", "NOT $140!!!!", "optimized by the gods", "actually god", "this is a cry for help", "bring your wife. we\'ll fuck her! WE\'LL FUCK YOUR WIFE!", "doing your mom doing doing your mom",
"we live in a society...", "also try jackscript!", "i NEED feet pics!!!!", "femboy thighs please", "the original orbit menu killer", "resellers where you at :kek:", "if you have a problem with stand, POST IT IN SUPPORT!", "not responsible for your game or stand-related issues since 1984",
"mfs in #nsfw a different breed tbh", "- political opinion - ", "we bought ozark source code KEK (we didnt)", "so long daft punk", "hollywood collins BASED", "sainan notice me???", "haha what if we held hands...", "$278 spent on skirts", "also try terraria!"}
plct = 0
for k,v in pairs(punchlines) do
    if v ~= nil then
        plct = plct + 1
    end
end

-- get banned_words.txt for chat filter
file_name = filesystem.scripts_dir() .. 'banned_words.txt'
banned_words = {}

-- this is taken from lua docs at http://lua-users.org/wiki/FileInputOutput
-- check if the file exists so if it doesnt we dont encounter errors
function file_exists(path)
    local file = io.open(path, "rb")
    if file then file:close() end
    return file ~= nil
end

if not file_exists(file_name) then
  util.toast(file_name .. ' was not found, please make sure the script is installed correctly. READ THE INSTALL.TXT!!! AND FOLLOW THE INSTRUCTIONS IN THE FOLDER NAME.')
  util.stop_script()
else
    file = io.open(file_name, "r")
    i = 0
    for l in file:lines() do
        i = i + 1
        banned_words[i] = string.lower(l)
    end
    file:close()
end

--update checker
util.async_http_get("pastebin.com", "/raw/YK0P06yC", function(result)
    if version < result then
        util.toast("An update is available for Lancescript! Bringing you there now.")
        os.execute("start \"\" \"https://www.guilded.gg/stand/groups/x3ZgB10D/channels/7430c963-e9ee-40e3-ab20-190b8e4a4752/docs/265965\"")
    else
        util.toast("Lancescript is up to date!")
    end
end,
function (fail)
    util.toast("Could not check for updates.")
end)

function show_custom_alert_until_enter(l1)
    poptime = os.time()
    while true do
        if PAD.IS_CONTROL_JUST_RELEASED(18, 18) then
            if os.time() - poptime > 0.1 then
                break
            end
        end
        --HUD.SET_WARNING_MESSAGE_WITH_HEADER_AND_SUBSTRING_FLAGS("ALERT", "JL_INVITE_ND", 2, "", true, -1, -1, l1, nil, true, 0)
        native_invoker.begin_call()
        native_invoker.push_arg_string("ALERT")
        native_invoker.push_arg_string("JL_INVITE_ND")
        native_invoker.push_arg_int(2)
        native_invoker.push_arg_string("")
        native_invoker.push_arg_bool(true)
        native_invoker.push_arg_int(-1)
        native_invoker.push_arg_int(-1)
        -- line here
        native_invoker.push_arg_string(l1)
        -- optional second line here
        native_invoker.push_arg_int(0)
        native_invoker.push_arg_bool(true)
        native_invoker.push_arg_int(0)
        native_invoker.end_call("701919482C74B5AB")
        util.yield()
    end
end

scaleform_thread = util.create_thread(function (thr)
    name = os.getenv("USERNAME")
    util.toast("Hello " .. name .. "!")
    scaleForm = GRAPHICS.REQUEST_SCALEFORM_MOVIE("MP_BIG_MESSAGE_FREEMODE")
    GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleForm, "SHOW_SHARD_WASTED_MP_MESSAGE")
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_PLAYER_NAME_STRING("~p~lancescript")
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_PLAYER_NAME_STRING("~f~~italic~\"" .. punchlines[math.random(1, plct)] .. "\"~italic~~n~~w~" .. version)
    GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
    AUDIO.PLAY_SOUND_FRONTEND(55, "FocusIn", "HintCamSounds", true)
    starttime = os.time()
    while true do
        if os.time() - starttime >= 5 then
            AUDIO.PLAY_SOUND_FRONTEND(55, "FocusOut", "HintCamSounds", true)
            if file_exists(filesystem.scripts_dir() .. 'Tox1cEssent1als.lua') and not file_exists(filesystem.scripts_dir() .. 'disclaimer_viewed.txt') then
                local text = "~g~You are not banned. ~w~This is a notice from Lancescript. Toxicessentials (Tox1cEssent1als.lua) has been detected. Please read.~n~I won\'t stop you from using ToxicEssentials, that would be overstepping boundaries. But just be aware that the developer is a fucking asshole.~n~" .. 
                "Toxicessentials consists of hard work that the developer (pnn) stole from others and proceeded to sell with no profits or even credit given to these developers."
                local text2 = "You are free to keep using Toxicessentials, but one of its developers who is not a douchebag, ICYphoenix, has been maintaining a non-obfuscated, credited edition of it for months.~n~" .. 
                "You are heavily encouraged to use Phoenixscript and/or Lancescript in replacement of pnn\'s skidded, stolen work. ~n~Phoenixscript IS Toxicessentials, after all.~n~"..
                "I encourage you to no longer give people downloads of Toxicessentials. You do not have to listen to me. But Toxicessentials is poorly written, unmaintained, obfuscated, stolen code.~n~"..
                "This will be the only time you see this message. Thanks for your time."
                show_custom_alert_until_enter(text)
                show_custom_alert_until_enter(text2)
                file = io.open(filesystem.scripts_dir() .. 'disclaimer_viewed.txt', "w")
                file:write("This file exists in your Lua scripts to tell Lancescript you have viewed the disclaimer about Toxicessentials. If you remove it, you will see the disclaimer again.")
                file:close()
            end
            util.stop_thread()
        end
	    if GRAPHICS.HAS_SCALEFORM_MOVIE_LOADED(scaleForm) then
            GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scaleForm, 255, 255, 255, 255, 0)
        end
        util.yield(1)
    end
end)

function dispatch_griefer_jesus(target)
    griefer_jesus = util.create_thread(function(thr)
        util.toast("Griefer jesus sent!")
        request_model_load(-835930287)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(target)
        coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
        local jesus = util.create_ped(1, -835930287, coords, 90.0)
        ENTITY.SET_ENTITY_INVINCIBLE(jesus, true)
        PED.SET_PED_HEARING_RANGE(jesus, 9999)
	    PED.SET_PED_CONFIG_FLAG(jesus, 281, true)
        PED.SET_PED_COMBAT_ATTRIBUTES(jesus, 5, true)
	    PED.SET_PED_COMBAT_ATTRIBUTES(jesus, 46, true)
        PED.SET_PED_CAN_RAGDOLL(jesus, false)
        WEAPON.GIVE_WEAPON_TO_PED(jesus, util.joaat("WEAPON_RAILGUN"), 9999, true, true)
        TASK.TASK_GO_TO_ENTITY(jesus, target_ped, -1, -1, 100.0, 0.0, 0)
    	TASK.TASK_COMBAT_PED(jesus, target_ped, 0, 16)
        --pretty much just a respawn/rationale check
        while true do
            local player_coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
            local jesus_coords = ENTITY.GET_ENTITY_COORDS(jesus, false)
            local dist =  MISC.GET_DISTANCE_BETWEEN_COORDS(player_coords['x'], player_coords['y'], player_coords['z'], jesus_coords['x'], jesus_coords['y'], jesus_coords['z'], false)
            if dist > 100 then
                local behind = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(target_ped, -3.0, 0.0, 0.0)
                ENTITY.SET_ENTITY_COORDS(jesus, behind['x'], behind['y'], behind['z'], false, false, false, false)
            end
            -- if jesus disappears we can just make another lmao
            if not ENTITY.DOES_ENTITY_EXIST(jesus) then
                util.toast("Jesus apparently stopped existing. Stopping Jesus thread.")
                util.stop_thread()
            end
            local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(target)
            if not players.exists(target) then
                util.toast("The player target has been lost. The griefer Jesus thread is stopping.")
                util.stop_thread()
            else
                TASK.TASK_COMBAT_PED(jesus, target_ped, 0, 16)
            end
            util.yield()
        end
    end)
end
menu.toggle(lancescript_root, "Show active entity pools", {"entitypoolupdates"}, "Toasts what entity pools are being updated every tick. The more you see, the more performance loss; getting all entities is a heavy task.", function(on)
    if on then
        show_updates = true
    else
        show_updates = false
    end
end)

menu.action(lancescript_root, "Watch Konosuba! ep 1", {"konosuba"}, "", function(on_click)
    os.execute("start \"\" \"https://www.youtube.com/watch?v=H8CORxz5FKA\"")
end)
--memory.scan(string pattern)

menu.action(lancescript_root, "Tweet about Lancescript", {"tweet"}, "", function(on_click)
    os.execute("start \"\" \"https://twitter.com/compose/tweet?text=Lancescript is the best LUA script ever!\"")
end)

joinsound = false
menu.toggle(sounds_root, "Sound on player join", {"joinsound"}, "", function(on)
    if on then
        joinsound = true
    else
        joinsound = false
    end
end)

leavesound = false
menu.toggle(sounds_root, "Sound on player leave", {"leavesound"}, "", function(on)
    if on then
        leavesound = true
    else
        leavesound = false
    end
end)

vehicle_uses = 0
ped_uses = 0
player_uses = 0
object_uses = 0
all_vehicles = {}
all_objects = {}
all_players = {}
all_peds = {}
player_cur_car = 0

infibounty = false
function start_infibounty_thread()
    infibounty_thread = util.create_thread(function (thr)
        while true do
            if not infibounty then
                util.stop_thread()
            else
                menu.trigger_commands("bountyall 10000")
            end
            util.yield(60000)
        end
    end)
end

tint_thread = util.create_thread(function (thr)
    cur_tint = 0
    while true do
        if cur_tint < 7 then
            cur_tint = cur_tint + 1
        else
            cur_tint = 0
        end
        util.yield(200)
    end
end)

rgb_thread = util.create_thread(function (thr)
    rgb = {}
    cur_col = 1
    rgb = {255, 0, 0}
    while true do
        if cur_col == 1 then
            rgb = {255, 0, 0}
            cur_col = 2
        elseif cur_col == 2 then
            rgb = {0, 255, 0}
            cur_col = 3
        elseif cur_col == 3 then
            rgb = {0, 0, 255}
            cur_col = 1
        end
        util.yield(200)
    end
end)

player_cur_car = 0
function is_ped_player(ped)
    if PED.GET_PED_TYPE(ped) >= 4 then
        return false
    else
        return true
    end
end

function request_model_load(hash)
    request_time = os.time()
    if not STREAMING.IS_MODEL_VALID(hash) then
        util.toast("Requested model was invalid and could not be loaded.")
        return
    end
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        if os.time() - request_time >= 10 then
            util.toast("Model failed to load in 10 seconds.")
            break
        end
        util.toast("Loading model hash " .. hash)
        util.yield()
    end
end

function request_ptfx_load(hash)
    request_time = os.time()
    STREAMING.REQUEST_NAMED_PTFX_ASSET(hash)
    while not STREAMING.HAS_PTFX_ASSET_LOADED(hash) do
        if os.time() - request_time >= 10 then
            util.toast("PTFX failed to load in 5 seconds.")
            break
        end
        util.toast("Loading PTFX hash " .. hash)
        util.yield()
    end
end

function get_random_ped()
    peds = util.get_all_peds()
    npcs = {}
    valid = 0
    for k,p in pairs(peds) do
        if p ~= nil and not is_ped_player(p) then
            table.insert(npcs, p)
            valid = valid + 1
        end
    end
    return npcs[math.random(valid)]
end


function spawn_object_in_front_of_ped(ped, hash, ang, room, zoff, setonground)
    coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, room, zoff)
    request_model_load(hash)
    hdng = ENTITY.GET_ENTITY_HEADING(ped)
    new = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'], coords['y'], coords['z'], true, false, false)
    ENTITY.SET_ENTITY_HEADING(new, hdng+ang)
    if setonground then
        OBJECT.PLACE_OBJECT_ON_GROUND_PROPERLY(new)
    end
    return new
end
rainbow_tint = false
menu.toggle(weapons_root, "Rainbow weapon tint", {"rainbowtint"}, "boogie", function(on)
    plyr = PLAYER.PLAYER_PED_ID()
    if on then
        local last_tint = WEAPON.GET_PED_WEAPON_TINT_INDEX(PLAYER.PLAYER_PED_ID(), WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID()))
        rainbow_tint = true
    else
        rainbow_tint = false
        WEAPON.SET_PED_WEAPON_TINT_INDEX(PLAYER.PLAYER_PED_ID(),WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID()), last_tint)
    end
end, false)

shoot_entities = false
shoot_entity = -1
menu.toggle(weapons_root, "Shoot entities", {"shootentities"}, "Allows you to shoot the selected entity.", function(on)
    plyr = PLAYER.PLAYER_PED_ID()
    if on then
        if shoot_entity == -1 then
            util.toast("Shoot entities is on, now select an entity to fire.")
        end
        shoot_entities = true
    else
        shoot_entities = false
    end
end, false)

menu.toggle(weapons_root, "Invisible weapons", {"invisguns"}, "Makes your weapons invisible. Might be local only. You need to retoggle when switching weapons.", function(on)
    plyr = PLAYER.PLAYER_PED_ID()
    if on then
        WEAPON.SET_PED_CURRENT_WEAPON_VISIBLE(plyr, false, false, false, false) 
    else
        WEAPON.SET_PED_CURRENT_WEAPON_VISIBLE(plyr, true, false, false, false) 
    end
end, false)

noexplosives = false
menu.toggle(protections_root, "No explosives", {"noexplosives"}, "Automatically removes all explosive projectiles from the world when they spawn, even rockets. Not sure if this works nicely on other players. This is not an extensive list, and only includes some player weapons; vehicle weapons may be unaffected.", function(on)
    plyr = PLAYER.PLAYER_PED_ID()
    if on then
        noexplosives = true
    else
        noexplosives = false
    end
end, false)

noclip = false
noclip_height = 0
menu.toggle(noclip_root, "Noclip", {"noclip"}, "Simple but smart noclip. Works for vehicles too.", function(on)
    plyr = PLAYER.PLAYER_PED_ID()
    veh = PED.GET_VEHICLE_PED_IS_IN(plyr, false)
    if on then
        -- lol
        if veh ~= 0 then
            plyr = veh
        end
        noclip_height = ENTITY.GET_ENTITY_COORDS(plyr, false)['z']
        ENTITY.FREEZE_ENTITY_POSITION(plyr, true)
        ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(plyr, false, false)
        noclip = true
    else
        if veh ~= 0 then
            plyr = veh
        end
        ENTITY.FREEZE_ENTITY_POSITION(plyr, false)
        ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(plyr, true, true)
        noclip = false
    end
end, false)

noclip_hspeed = 0.1
menu.click_slider(noclip_root, "Horizontal speed", {"nocliphspeed"}, "Horizontal speed for noclip, * 0.1", 1, 50, 5, 1, function(s)
    noclip_hspeed = s * 0.1
  end)

noclip_vspeed = 0.1
menu.click_slider(noclip_root, "Vertical speed", {"noclipvspeed"}, "Vertical speed for noclip, * 0.1", 1, 50, 2, 1, function(s)
    noclip_vspeed = s * 0.1
  end)
  
menu.toggle(self_root, "Make me a cop", {"makemecop"}, "Sets your ped as a cop. To make you not a cop, it will suicide you. Will make you invisible to almost all cops, but you will report your own crimes, get a cop voice, have a vision cone, and will not be able to shoot at other cops. SWAT and army will still shoot you.", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        PED.SET_PED_AS_COP(ped, true)
    else
        menu.trigger_commands("suicide")
    end
end)

hud_rainbow = false
menu.toggle(gametweaks_root, "RGB hud", {"rgbhud"}, "RGB\'s your hud. This is AIDS, and requires a game restart to reset.", function(on)
    if on then
        hud_rainbow = true
    else
        hud_rainbow = false
    end
end)

lodscale = 1
menu.click_slider(gametweaks_root, "LOD Scale Override", {"lodscale"}, "Overrides extended distance scaling, lets you make distant objects \"look more HD\". This is an oversimplified explanation. May also make your game run like shit.", 1, 200, 1, 1, function(s)
    lodscale = s
  end)

menu.toggle(radio_root, "Music-only radio", {"musiconly"}, "Forces radio stations to only play music. No bullshit.", function(on)
    num_unlocked = AUDIO.GET_NUM_UNLOCKED_RADIO_STATIONS()
    if on then
        for i=1, num_unlocked do
            AUDIO.SET_RADIO_STATION_MUSIC_ONLY(AUDIO.GET_RADIO_STATION_NAME(i), true)
        end
    else
        for i=1, num_unlocked do
            AUDIO.SET_RADIO_STATION_MUSIC_ONLY(AUDIO.GET_RADIO_STATION_NAME(i), false)
        end
    end
end)

menu.action(radio_root, "Tracklist override - \"It\'s a setup\"", {"itsasetup"}, "ohm its a setup its a setup its a setup", function(on_click)
    local station = "RADIO_01_CLASS_ROCK"
    AUDIO.SET_RADIO_TO_STATION_NAME(station)
    AUDIO.SET_CUSTOM_RADIO_TRACK_LIST(station, "END_CREDITS_SAVE_MICHAEL_TREVOR", false)
end)

menu.action(radio_root, "Tracklist override - \"Sleepwalking\"", {"sleepwalking"}, "End music if you kill michael. Who the fuck would kill Michael?", function(on_click)
    local station = "RADIO_01_CLASS_ROCK"
    AUDIO.SET_RADIO_TO_STATION_NAME(station)
    AUDIO.SET_CUSTOM_RADIO_TRACK_LIST(station, "END_CREDITS_KILL_MICHAEL", true)
end)

menu.action(radio_root, "Tracklist override - \"Don\'t come close\"", {"dontcomeclose"}, "End music if you kill Trevor. Makes you feel like a piece of shit. I picked this option when I was young. I regret it.", function(on_click)
    local station = "RADIO_01_CLASS_ROCK"
    AUDIO.SET_RADIO_TO_STATION_NAME(station)
    AUDIO.SET_CUSTOM_RADIO_TRACK_LIST(station, "END_CREDITS_KILL_TREVOR", true)
end)

menu.action(radio_root, "Next track", {"radioskip"}, "Skips the current track", function(on_click)
    AUDIO.SKIP_RADIO_FORWARD()
end)

--SKIP_RADIO_FORWARD()

ban_msg = "HUD_ROSBANPERM"
--_SET_WARNING_MESSAGE_WITH_ALERT(char* labelTitle, char* labelMsg, int p2, int p3, char* labelMsg2, BOOL p5, int p6, int p7, char* p8, char* p9, BOOL background, int errorCode)

menu.action(fakemessages_root, "Fake ban message 1", {"fakeban"}, "Shows a completely fake ban message. Maybe use this to get free accounts from cheat devs or cause a scare on r/Gta5modding.", function(on_click)
    show_custom_alert_until_enter("You have been banned from Grand Theft Auto Online.~n~Return to Grand Theft Auto V.")
end)

menu.action(fakemessages_root, "Fake ban message 2", {"fakeban"}, "Shows a completely fake ban message. Maybe use this to get free accounts from cheat devs or cause a scare on r/Gta5modding.", function(on_click)
    show_custom_alert_until_enter("You have been banned from Grand Theft Auto Online permanently.~n~Return to Grand Theft Auto V.")
end)
--0x252F03F2

menu.action(fakemessages_root, "Services unavailable", {"fakeservicedown"}, "rOcKstaR GaMe ServICeS ArE UnAvAiLAbLe RiGht NoW", function(on_click)
    show_custom_alert_until_enter("The Rockstar game services are unavailable right now.~n~Please return to Grand Theft Auto V.")
end)

menu.action(fakemessages_root, "Suspended until xyz", {"suspendeduntil"}, "Suspended until xyz. It will ask you to input the date to show, don\'t worry.", function(on_click)
    util.toast("Input the date your \"suspension\" should end.")
    menu.show_command_box("suspendeduntil ")
end, function(on_command)
    -- fuck it lol
    show_custom_alert_until_enter("You have been suspended from Grand Theft Auto Online until " .. on_command .. ".~n~In addition, your Grand Theft Auto Online character(s) will be reset.~n~Return to Grand Theft Auto V.")
end)

menu.action(fakemessages_root, "Stand on TOP!", {"stand on top"}, "yep", function(on_click)
    show_custom_alert_until_enter("Stand on TOP!")
end)

menu.action(fakemessages_root, "Yeeyee ass haircut", {"yeeyee"}, "maybe", function(on_click)
    show_custom_alert_until_enter("Maybe if you got rid of that old ~r~yee yee ass haircut~w~ you'd get some bitches on your dick")
end)

menu.action(fakemessages_root, "Welcome to the Black Parade", {"blackparade"}, "", function(on_click)
    show_custom_alert_until_enter("When I was a young boy, my father~n~"..
    "Took me into the city to see a marching band~n~"..
    "He said, \"Son, when you grow up would you be~n~"..
    "The savior of the broken, the beaten and the damned?\"~n~"..
    "He said, \"Will you defeat them? Your demons~n~"..
    "And all the non-believers, the plans that they have made?~n~"..
    "Because one day, I\'ll leave you a phantom~n~"..
    "To lead you in the summer to join the black parade...\"~n~"..
    "~n~"..
    "When I was a young boy, my father~n~"..
    "Took me into the city to see a marching band~n~"..
    "He said, \"Son, when you grow up would you be~n~"..
    "The savior of the broken, the beaten and the damned?\"")
end)


menu.action(fakemessages_root, "Reddit", {"henlo"}, "they be like \"um ackshully u should buy 2take1\"", function(on_click)
    show_custom_alert_until_enter("Hello r/GTA5Modding!")
end)

menu.action(fakemessages_root, "Exit scam", {"exitscam"}, "you know the vibes", function(on_click)
    show_custom_alert_until_enter("Dear beloved Ozark Users, PLEASE READ THIS MESSAGE IN ITS ENTIRETY.~n~"..

    "It is with a heavy heart I have to write this message.~n~"..
    
    "I received correspondence today via a Law Firm in my local country from TakeTwo Interactive.~n~"..
    
    "Effective immediately, Ozark has shutdown and ceased all services."
)
end)

menu.action(fakemessages_root, "Custom alert", {"customalert"}, "Shows a custom alert of your liking. Credit to QuickNUT and Sainan for help with this.", function(on_click)
    util.toast("Please type what you want the alert to say. Type ~n~ for new line, ie foo~n~bar will show up as 2 lines.")
    menu.show_command_box("customalert ")
end, function(on_command)
    show_custom_alert_until_enter(on_command)
end)

menu.action(menu.my_root(), "Players shortcut", {}, "Quickly opens session players list, for convenience", function(on_click)
    menu.trigger_commands("playerlist")
end)

make_peds_cops = false
menu.toggle(npc_root, "Make nearby peds cops", {"makecops"}, "They\'re not actually real cops, but kind of are. They seem to flee very easily, but will snitch on you. Sort of like mall cops.", function(on)
    if on then
        make_peds_cops = true
        ped_uses = ped_uses + 1
    else
        make_peds_cops = false
        ped_uses = ped_uses - 1
    end
end, false)
--SET_RIOT_MODE_ENABLED(BOOL toggle)
menu.toggle(npc_root, "Riot mode", {"riotmode"}, "All nearby NPC\'s duel it out and are given weapons. Surprisingly this is handled by the game itself.", function(on)
    if on then
        MISC.SET_RIOT_MODE_ENABLED(true)
    else
        MISC.SET_RIOT_MODE_ENABLED(false)
    end
end, false)

menu.action(npc_root, "Make nearby peds musicians", {}, "now here\'s wonderwall", function(on_click)
    local peds = util.get_all_peds()
    for k,ped in pairs(peds) do
        if not is_ped_player(ped) then
            TASK.TASK_LEAVE_ANY_VEHICLE(ped, 0, 16)
            TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_MUSICIAN", 0, true)
        end
    end
end)

roast_voicelines = false
menu.toggle(npc_root, "Roast voicelines", {"npcroasts"}, "Very unethical.", function(on)
    --make_all_peds_say("GENERIC_INSULT_MED", "SPEECH_PARAMS_FORCE_SHOUTED")
    if on then
        ped_uses = ped_uses + 1
        roast_voicelines = true
    else
        ped_uses = ped_uses -1
        roast_voicelines = false
    end
end, false)

sex_voicelines = false
menu.toggle(npc_root, "Sex voicelines", {"sexlines"}, "oH FuCK YeAh", function(on)
    if on then
        ped_uses = ped_uses + 1
        sex_voicelines = true
    else
        ped_uses = ped_uses -1
        sex_voicelines = false
    end
end, false)

gluck_voicelines = false
menu.toggle(npc_root, "Gluck gluck 9000 voicelines", {"gluckgluck9000"}, "I\'m begging you, touch some grass.", function(on)
    if on then
        ped_uses = ped_uses + 1
        gluck_voicelines = true
    else
        ped_uses = ped_uses -1
        gluck_voicelines = false
    end
end, false)

screamall = false
menu.toggle(npc_root, "Scream", {"screamall"}, "Makes all nearby peds scream horrifically. Awesome.", function(on)
    if on then
        ped_uses = ped_uses + 1
        screamall = true
    else
        ped_uses = ped_uses -1
        screamall = false
    end
end, false)

play_ped_ringtones = false
menu.toggle(npc_root, "Ring all peds phones", {"ringtones"}, "Turns all nearby ped ringtones on", function(on)
    if on then
        play_ped_ringtones = true
        ped_uses = ped_uses +1
    else
        play_ped_ringtones = false
        ped_uses = ped_uses - 1
    end
end, false)

dumb_peds = false
menu.toggle(npc_root, "Make all peds dumb", {"dumbpeds"}, "Makes nearby peds dumb / marks them as \"not highly perceptive\" in the engine. Whatever that means tbh.", function(on)
    if on then
        dumb_peds = true
        ped_uses = ped_uses + 1
    else
        dumb_peds = false
        ped_uses = ped_uses - 1
    end
end, false)

safe_peds = false
menu.toggle(npc_root, "Give peds helmets", {"safepeds"}, "First-time drivers need safety.", function(on)
    if on then
        safe_peds = true
        ped_uses = ped_uses + 1
    else
        safe_peds = false
        ped_uses = ped_uses - 1
    end
end, false)

deaf_peds= false
menu.toggle(npc_root, "Make all peds deaf", {"deafpeds"}, "Makes nearby peds deaf. Probably only noticeable for stealth missions.", function(on)
    if on then
        deaf_peds = true
        ped_uses = ped_uses + 1
    else
        deaf_peds = false
        ped_uses = ped_uses - 1
    end
end, false)

kill_peds= false
menu.toggle(npc_root, "Kill peds", {"killpeds"}, "Stand already does this, but whatever. Ours is more dramatic I think.", function(on)
    if on then
        kill_peds = true
        ped_uses = ped_uses + 1
    else
        kill_peds = false
        ped_uses = ped_uses - 1
    end
end, false)

function task_handler(type)
    -- whatever, just get it once this frame
    all_peds = util.get_all_peds()
    player_ped = PLAYER.PLAYER_PED_ID()
    for k,ped in pairs(all_peds) do
        if not is_ped_player(ped) then
            if type == "flop" then
                TASK.TASK_SKY_DIVE(ped)
            elseif type == "cover" then
                TASK.TASK_STAY_IN_COVER(ped)
            elseif type == "writheme" then
                TASK.TASK_WRITHE(ped, player_ped, -1, 0)
            elseif type == "vault" then
                TASK.TASK_CLIMB(ped, true)
            elseif type =="unused" then
                --
            elseif type == "cower" then
                TASK.TASK_COWER(ped, -1)
            end

        end
    end

end
menu.action(tasks_root, "Do the FLOP", {"flop"}, "All walking NPC\'s will do the flop. All driving NPC\'s will gently park their car, leave it, and do it then.", function(on_click)
    task_handler("flop")
end)

menu.action(tasks_root, "Move to cover", {"cover"}, "Pussy peds", function(on_click)
    task_handler("cover")
end)

menu.action(tasks_root, "Vault", {"vault"}, "They vault/skip over an invisible hurdle. Olympics. It also makes drivers vault out of their vehicle and fall through the world, because rockstar.", function(on_click)
    task_handler("vault")
end)

menu.action(tasks_root, "Cower", {"cower"}, "They cower for an eternity.", function(on_click)
    task_handler("cower")
end)


menu.action(tasks_root, "Writhe me", {"writheme"}, "Makes peds infinitely suffer on the ground. Finally a use for those dumbasses. The native makes drivers become invisible until they die for some reason.", function(on_click)
    task_handler("writheme")
end)

menu.action(entity_root, "Teleport into closest vehicle", {"closestvehicle"}, "Teleports into closest vehicle (excludes any you might be in already). If the closest vehicle has a player driver, it will put you in the next available seat, if any. Keep in mind that nearby vehicles may not actually be \"real\" vehicles and may just be LOD\'s.", function(on_click)
    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
    local vehicles = util.get_all_vehicles()
    -- init this at some ridiculously large number we will never reach, ez
    local closestdist = 1000000
    local closestveh = 0
    for k, veh in pairs(vehicles) do
        if veh ~= PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID(), false) then
            local vehcoord = ENTITY.GET_ENTITY_COORDS(veh, true)
            local dist = MISC.GET_DISTANCE_BETWEEN_COORDS(coords['x'], coords['y'], coords['z'], vehcoord['x'], vehcoord['y'], vehcoord['z'], true)
            if dist < closestdist then
                closestdist = dist
                closestveh = veh
            end
        end
    end
    driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(closestveh, -1)
    if VEHICLE.IS_VEHICLE_SEAT_FREE(closestveh, -1) then
        PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), closestveh, -1)
    else
        if not is_ped_player(driver) then
            util.delete_entity(driver)
            PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), closestveh, -1)
        elseif VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(closestveh) then
            for i=0, 10 do
                if VEHICLE.IS_VEHICLE_SEAT_FREE(closestveh, i) then
                    PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), closestveh, i)
                end
            end
        else
            util.toast("No nearby vehicles with available seats found :(")
        end
    end
end)

blackhole = false
menu.toggle(entity_root, "Vehicle blackhole", {"blackhole"}, "A SUPER laggy but fun blackhole. When you toggle it on, it will set the blackhole position above you. Retoggle it to change the position. Oh also, this is very resource taxing and may temporarily fuck up collisions.", function(on)
    if on then
        holecoords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
        util.toast("Blackhole position has been set 50 units above your position. Retoggle this on and off to change the position.")
        blackhole = true
        vehicle_uses = vehicle_uses + 1
    else
        blackhole = false
        vehicle_uses = vehicle_uses - 1
    end
end, false)

hole_zoff = 50
menu.click_slider(entity_root, "Blackhole Z-offset", {"blackholeoffset"}, "How far above you to place the blackhole. Recommended to keep this fairly high.", 0, 100, 50, 10, function(s)
    hole_zoff = s
  end)

vehicle_fuckup = false
menu.toggle(entity_root, "Fuck up all cars", {"fuckupcars"}, "Beats the SHIT out of all nearby cars. But this damage is only local.", function(on)
    if on then
        vehicle_fuckup = true
        vehicle_uses = vehicle_uses + 1
    else
        vehicle_fuckup = false
        vehicle_uses = vehicle_uses - 1
    end
end, false)

godmode_vehicles = false
menu.toggle(entity_root, "Godmode all vehicles nearby", {"godmodecars"}, "Makes all cars nearby undamageable. Built for NPC cars, so don\'t whine when Mr. ||||||||||| sticky bombs your itali.", function(on)
    if on then
        godmode_vehicles = true
        vehicle_uses = vehicle_uses + 1
    else
        godmode_vehicles = false
        vehicle_uses = vehicle_uses - 1
    end
end)

disable_veh_colls = false
menu.toggle(entity_root, "Hole all nearby cars", {"nocolcars"}, "Makes all nearby cars fall through the world, or \"into a hole\".", function(on)
    if on then
        disable_veh_colls = true
        vehicle_uses = vehicle_uses + 1
    else
        disable_veh_colls = false
        vehicle_uses = vehicle_uses - 1
    end
end)


vehicle_rainbow = false
menu.toggle(entity_root, "Rainbow vehicles", {"rainbowvehicles"}, "Rainbows all nearby vehicles!", function(on)
    if on then
        vehicle_rainbow = true
        vehicle_uses = vehicle_uses + 1
    else
        vehicle_rainbow = false
        vehicle_uses = vehicle_uses - 1
    end
end, false)


clear_radius = 100
function clear_area(radius)
    target_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
    MISC.CLEAR_AREA(target_pos['x'], target_pos['y'], target_pos['z'], radius, true, false, false, false)
end

menu.action(world_root, "Clear area", {"cleararea"}, "Clears the nearby area of everything", function(on_click)
    clear_area(clear_radius)
    util.toast('Area cleared :)')
end)

-- SET_PED_SHOOTS_AT_COORD(Ped ped, float x, float y, float z, BOOL toggle)

menu.action(world_root, "Clear world", {"clearworfld"}, "Clears literally everything that can be cleared within the world (well, everything that\'s rendered in). Don\'t tell them, but it\'s really just a huge number as radius.", function(on_click)
    clear_area(1000000)
    util.toast('World cleared :)')
end)

cont_clear = false
menu.toggle(world_root, "Continuous area clear", {"contareaclear"}, "Area clear, but looped", function(on)
    if on then
        cont_clear = true
    else
        cont_clear = false
    end
end, false)

rapidtraffic = false
menu.toggle(world_root, "Party traffic lights", {"beep boop"}, "ITS TIME TO PARTY!!!!!! probably local, also it doesnt affect traffic behavior", function(on)
    if on then
        rapidtraffic = true
        object_uses = object_uses + 1
    else
        rapidtraffic = false
        object_uses = object_uses - 1
    end
end, false)

object_rainbow = false
menu.toggle(world_root, "Rainbow world lights", {"rainbowlights"}, "Rainbows all embedded light sources. EXTREME FPS KILLER, so use wisely.", function(on)
    if on then
        object_rainbow = true
        object_uses = object_uses + 1
    else
        object_rainbow = false
        object_uses = object_uses - 1
    end
end)


menu.click_slider(world_root, "Clear radius", {"clearradius"}, "Radius to clear things within", 100, 10000, 100, 100, function(s)
    radius = s
  end)

menu.click_slider(world_root, "World gravity level", {"worldgravity"}, "World gravity level (0 is normal, higher number = less gravity)", 0, 3, 1, 1, function(s)
  MISC.SET_GRAVITY_LEVEL(s)
end)

firework_spam = false
menu.toggle(world_root, "Firework spam", {"fireworkspam"}, "airplanes in the night sky are like shooting stars", function(on)
    if on then
        firework_spam = true
    else
        firework_spam = false
    end
end, false)
--FORCE_LIGHTNING_FLASH()
lightning_spam = false
menu.toggle(world_root, "Lightning spam", {"lightningspam"}, "epileptic-hating zeus. not sure if its networked or not, probably not.", function(on)
    if on then
        lightning_spam = true
    else
        lightning_spam = false
    end
end, false)


effects_root = menu.list(world_root, "Screen effects", {"lancescriptfx"}, "")

menu.toggle(effects_root, "DMT", {"dmt"}, "", function(on)
    if on then
        GRAPHICS.ANIMPOSTFX_PLAY("DMT_flight", 0, true)
    else
        GRAPHICS.ANIMPOSTFX_STOP("DMT_flight")
    end
end, false)

menu.toggle(effects_root, "Clowns", {"clowns"}, "", function(on)
    if on then
        GRAPHICS.ANIMPOSTFX_PLAY("DrugsTrevorClownsFight", 0, true)
    else
        GRAPHICS.ANIMPOSTFX_STOP("DrugsTrevorClownsFight")
    end
end, false)

menu.toggle(effects_root, "Dog vision", {"dogvision"}, "", function(on)
    if on then
        GRAPHICS.ANIMPOSTFX_PLAY("ChopVision", 0, true)
    else
        GRAPHICS.ANIMPOSTFX_STOP("ChopVision")
    end
end, false)

menu.toggle(effects_root, "Rampage", {"rampage"}, "", function(on)
    if on then
        GRAPHICS.ANIMPOSTFX_PLAY("Rampage", 0, true)
    else
        GRAPHICS.ANIMPOSTFX_STOP("Rampage")
    end
end, false)

menu.action(effects_root, "Input custom effect", {"effectinput"}, "Input a custom animpostFX to play.", function(on_click)
    util.toast("Please type the effect name")
    menu.show_command_box("effectinput ")
end, function(on_command)
    GRAPHICS.ANIMPOSTFX_PLAY(on_command, 0, true)
end)

menu.action(effects_root, "Stop all effects", {"stopfx"}, "Use only as emergency, to stop custom inputted effects, or to stop regularly-triggered effects. If you can, try untoggling the effect first here.", function(on_click)
    GRAPHICS.ANIMPOSTFX_STOP_ALL()
end)



function entity_reaper()
  for k,veh in pairs(all_vehicles) do
      if not is_ped_player(VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1)) then
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
      end
  end
  for k,ped in pairs(all_peds) do
    if not is_ped_player(ped) then
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped)
    end
  end
  for k,obj in pairs(all_objects) do
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(obj)
  end
end

entity_reap = false
menu.toggle(entity_root, "Entity reap", {"entityreap"}, "Reap all nearby entities (requests ownership)", function(on)
    if on then
        util.toast("Entity reaper is ON. This may cause performance issues.")
        entity_reap = true
        vehicle_uses = vehicle_uses + 1
        ped_uses = ped_uses + 1
        object_uses = object_uses + 1
    else
        entity_reap = false
        vehicle_uses = vehicle_uses - 1
        ped_uses = ped_uses - 1
        object_uses = object_uses - 1
    end
end, false)

ascend_vehicles = false
menu.toggle(entity_root, "Ascend all nearby vehicles", {"ascendvehicles"}, "It\'s supposed to neatly make them levitate.. but it just spends them spinning in mid air. Which is fucking hilarious.", function(on)
    if on then
        ascend_vehicles = true
        vehicle_uses = vehicle_uses + 1
    else
        ascend_vehicles = false
        vehicle_uses = vehicle_uses - 1
    end
end)

no_radio = false
menu.toggle(entity_root, "Disable radio on all cars", {"noradio"}, "serenity.", function(on)
    if on then
        no_radio = true
        vehicle_uses = vehicle_uses + 1
    else
        no_radio = false
        vehicle_uses = vehicle_uses - 1
    end
end)

loud_radio = false
menu.toggle(entity_root, "Loud radio on all cars", {"loudradio"}, "I CAN\'T HEAR YOU OVER ALL THIS BULLSHIT", function(on)
    if on then
        loud_radio = true
        vehicle_uses = vehicle_uses + 1
    else
        loud_radio = false
        vehicle_uses = vehicle_uses - 1
    end
end)


halt_traffic = false
menu.toggle(entity_root, "Halt traffic", {"halttraffic"}, "Prevents all nearby vehicles from moving, at all. Not even an inch. Irreversible so be careful.", function(on)
    if on then
        halt_traffic = true
        vehicle_uses = vehicle_uses + 1
    else
        halt_traffic = false
        vehicle_uses = vehicle_uses - 1
    end
end)

reverse_traffic = false
menu.toggle(entity_root, "Reverse traffic", {"reversetraffic"}, "Traffic, but flip it", function(on)
    if on then
        reverse_traffic = true
        vehicle_uses = vehicle_uses + 1
    else
        reverse_traffic = false
        vehicle_uses = vehicle_uses - 1
    end
end)


vehicle_chaos = false
menu.toggle(entity_root, "Vehicle chaos", {"chaos"}, "Enables the chaos...", function(on)
    if on then
        vehicle_chaos = true
        vehicle_uses = vehicle_uses + 1
    else
        vehicle_chaos = false
        vehicle_uses = vehicle_uses - 1
    end
end, false)

vc_gravity = true
menu.toggle(entity_root, "Vehicle chaos gravity", {"chaosgravity"}, "Gravity on/off", function(on)
    if on then
        vc_gravity = true
    else
        vc_gravity = false
    end
end, true)

vc_speed = 100
menu.click_slider(entity_root, "Vehicle chaos speed", {"chaosspeed"}, "The speed to force the vehicles to. Higher = more chaos.", 30, 300, 100, 10, function(s)
  vc_speed = s
end)

bullet_rain = false
bullet_rain_target = -1

num_of_spam = 30
entity_grav = true
function spam_entity_on_player(ped, hash)
    request_model_load(hash)
    for i=1, num_of_spam do
        rand_coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, math.random(-1,1), math.random(-1,1), math.random(-1,1))
        obj = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, rand_coords['x'], rand_coords['y'], rand_coords['z'], true, false, false)
        if entity_grav then
            grav_factor = 1.0
        else
            grav_factor = 0.0
        end
        ENTITY.SET_ENTITY_HAS_GRAVITY(obj, entity_grav)
        OBJECT.SET_ACTIVATE_OBJECT_PHYSICS_AS_SOON_AS_IT_IS_UNFROZEN(obj, true)
    end
    util.toast('Done spamming entities.')
end

aircraft_root = menu.list(vehicle_root, "Aircraft", {"lanceaircraft"}, "")

menu.action(vehicle_root, "Force leave vehicle", {"forceleave"}, "Force leave vehicle, in case of emergency or stuckedness", function(on_click)
    TASK.TASK_LEAVE_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), 0, 16)
end)

menu.action(aircraft_root, "Break rudder", {"breakrudder"}, "Breaks rudder. Good for stunts.", function(on_click)
    if player_cur_car then
        VEHICLE.SET_VEHICLE_RUDDER_BROKEN(player_cur_car, true)
    end
end)
--SET_PLANE_TURBULENCE_MULTIPLIER(Vehicle vehicle, float multiplier)


instantspinup = false
menu.toggle(aircraft_root, "Instant propeller spinup", {"instantspinup"}, "Immediately spins up the blades, with no wait", function(on)
    if not player_cur_car then
        return
    end
    if on then
        instantspinup = true
    else
        instantspinup = false
    end

end, false)

menu.click_slider(aircraft_root, "Turbulence", {"turbulence"}, "Sets turbulence. 0 = no turbulence, 1 = default turbulence, 2 = heavy turbulence", 0, 2, 1, 1, function(s)
    if not player_cur_car then
        return
    end
    if s == 0 then
        VEHICLE.SET_PLANE_TURBULENCE_MULTIPLIER(player_cur_car, 0.0)
    elseif s == 1 then
        VEHICLE.SET_PLANE_TURBULENCE_MULTIPLIER(player_cur_car, 0.5)
    elseif s == 2 then
        VEHICLE.SET_PLANE_TURBULENCE_MULTIPLIER(player_cur_car, 1.0)
    end
end)

menu.toggle(vehicle_root, "Invisible boatmobile", {"everythingproof"}, "Makes your vehicle everything-proof. But not invincible. Glass seems to be bulletproof though. Don\'t judge me, I didn\'t make this native.", function(on)
    if not player_cur_car then
        return
    end
    if on then
        ENTITY.SET_ENTITY_ALPHA(player_cur_car, 0, true)
        ENTITY.SET_ENTITY_VISIBLE(player_cur_car, false, false)
    else
        ENTITY.SET_ENTITY_ALPHA(player_cur_car, 255, true)
        ENTITY.SET_ENTITY_VISIBLE(player_cur_car, true, false)
    end
end)

menu.action(vehicle_root, "Vehicle 180", {"vehicle180"}, "Turns your vehicle around with momentum preserved. Recommended to bind this.", function(on_click)
    if player_cur_car then
        local rot = ENTITY.GET_ENTITY_ROTATION(player_cur_car, 0)
        local vel = ENTITY.GET_ENTITY_VELOCITY(player_cur_car)
        ENTITY.SET_ENTITY_ROTATION(player_cur_car, rot['x'], rot['y'], rot['z']+180, 0, true)
        ENTITY.SET_ENTITY_VELOCITY(player_cur_car, -vel['x'], -vel['y'], vel['z'])
    end
end)

racemode = false
menu.toggle(vehicle_root, "Vehicle race mode", {"racemode"}, "Tells the game the car is in \"race mode\". Not actually sure what it does lol.", function(on)
    if not player_cur_car then
        return
    end
    if on then
        racemode = true
    else
        racemode = false
        VEHICLE.SET_VEHICLE_IS_RACING(player_cur_car, false)
    end
end)

stickyground = false
menu.toggle(vehicle_root, "Stick to ground", {"stick2ground"}, "Keeps your car on the ground.", function(on)
    if not player_cur_car then
        return
    end
    if on then
        stickyground = true
    else
        stickyground = false
    end
end)

mph_plate = false
menu.toggle(vehicle_root, "Speedometer plate", {"speedplate"}, "Unlike Ozark, which had this feature, I don\'t exit scam! Will reset your plate to what it was originally when you disable, also has KPH and MPH settings, so this is already better.", function(on)
    if on then
        if player_cur_car then
            original_plate = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(player_cur_car)
        else
            util.toast("You were not in a vehicle when starting this. You won\'t be able to revert plate text.")
            original_plate = "LANCE"
        end
        mph_plate = true
    else
        if player_cur_car then
            if original_plate == nil then
                original_plate = "LANCE"
            end
            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(player_cur_car, original_plate)
        end
        mph_plate = false
    end
end)

mph_unit = "kph"
menu.toggle(vehicle_root, "Use MPH for speedometer plate", {"usemph"}, "Toggle off if you aren\'t American.", function(on)
    if on then
        mph_unit = "mph"
    else
        mph_unit = "kph"
    end
end, false)

everythingproof = false
menu.toggle(vehicle_root, "Everything-proof", {"everythingproof"}, "Makes your vehicle everything-proof. But not invincible. Glass seems to be bulletproof though. Don\'t judge me, I didn\'t make this native.", function(on)
    if on then
        everythingproof = true
    else
        everythingproof = false
    end
end)

menu.click_slider(vehicle_root, "Vehicle top speed", {"topspeed"}, "Sets vehicle top speed (this is known as engine power multiplier elsewhere)", 1, 2000, 200, 50, function(s)
    VEHICLE.MODIFY_VEHICLE_TOP_SPEED(player_cur_car, s)
end)

shift_drift = false
menu.toggle(vehicle_root, "Hold shift to drift", {"shiftdrift"}, "You heard me.", function(on)
    if on then
        shift_drift = true
    else
        shift_drift = false
    end
end)


infcms = false
menu.toggle(vehicle_root, "Infinite countermeasures", {"infinitecms"}, "We also don\'t charge $140 for this feature. It\'s a single native call lmao", function(on)
    if on then
        infcms = true
    else
        infcms = false
    end
end)

menu.click_slider(vehicle_root, "Dirt level", {"dirtlevel"}, "Arctic Monkeys - Do I Wanna Know", 0, 15.0, 0, 1, function(s)
    if player_cur_car then
        VEHICLE.SET_VEHICLE_DIRT_LEVEL(player_cur_car, s)
    end
end)

menu.click_slider(vehicle_root, "Light multiplier", {"lightmultiplier"}, "Sets brightness of lights in the vehicle. Local only.", 0, 1000000, 1, 1, function(s)
    if player_cur_car then
        VEHICLE.SET_VEHICLE_LIGHT_MULTIPLIER(player_cur_car, s)
    end
end)


mock = false
swiss_cheese_dmg = 0
hit_times = 1
mock_target = -1
ped_chase = false
chase_target = -1
earrape = false
earrape_target = -1
towfrombehind = false
ram_onground = false
function ram_ped_with(ped, vehicle, offset, sog)
    request_model_load(vehicle)
    local front = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, offset, 0.0)
    front.x = front['x']
    front.y = front['y']
    front.z = front['z']
    local veh = util.create_vehicle(vehicle, front, ENTITY.GET_ENTITY_HEADING(ped)+180)
    if ram_onground then
        OBJECT.PLACE_OBJECT_ON_GROUND_PROPERLY(veh)
    end
    VEHICLE.SET_VEHICLE_ENGINE_ON(veh, true, true, true)
    VEHICLE.SET_VEHICLE_FORWARD_SPEED(veh, 100.0)
end

function set_up_player_actions(pid)
    menu.divider(menu.player_root(pid), "LanceScript")
    ls_proot = menu.list(menu.player_root(pid), "Lancescript", {"entityspam"}, "")
    entspam_root = menu.list(ls_proot, "Entity spam", {"entityspam"}, "")
    npctrolls_root = menu.list(ls_proot, "NPC trolling", {"npctrolls"}, "")
    objecttrolls_root = menu.list(ls_proot, "Object trolling", {"objecttrolls"}, "")
    ram_root = menu.list(ls_proot, "Ram", {"ram"}, "")
    attach_root = menu.list(ls_proot, "Attach", {"attach"}, "")

    --AUDIO.PLAY_PED_RINGTONE("Dial_and_Remote_Ring", ped, true)
    menu.action(ls_proot, "Infinite phone ring", {"infiphonering"}, "[EXPERIMENTAL] Infinitely plays a phone ringing sound, even if they join singleplayer. Still need adequate testing. I\'m no man of morals but please only do this to people who fuck with you.", function(on_click)
        AUDIO.PLAY_PED_RINGTONE("Dial_and_Remote_Ring", PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
    end)

    menu.toggle(ram_root, "Set on ground", {"ramonground"}, "Leave off if the user is flying aircraft", function(on)
        if on then
            ram_onground = true
        else
            ram_onground = false
        end
    end, true)

    menu.action(ram_root, "Howard", {"ramhoward"}, "brrt", function(on_click)
        ram_ped_with(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), -1007528109, 10.0, true)
    end)

    menu.action(ram_root, "Rally truck", {"ramtruck"}, "vroom", function(on_click)
        ram_ped_with(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), -2103821244, 10.0, false)
    end)

    menu.action(ram_root, "Cargo plane", {"ramcargo"}, "some menus might have this blocked lol", function(on_click)
        ram_ped_with(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 368211810, 15.0, false)
    end)

    -- 	368211810
    ---2103821244

    menu.action(ls_proot, "Fire jet", {"firejet"}, "one of the classic trolls", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
        FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 12, 100.0, true, false, 0.0)
    end)

    menu.action(ls_proot, "Water jet", {"waterjet"}, "one of the classic trolls", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
        FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 13, 100.0, true, false, 0.0)
    end)

    menu.toggle(attach_root, "Attach to player", {"attachto"}, "Useful, because if you\'re near the player your trolling works better", function(on)
        if on then
            ENTITY.ATTACH_ENTITY_TO_ENTITY(PLAYER.PLAYER_PED_ID(), PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
        else
            ENTITY.DETACH_ENTITY(PLAYER.PLAYER_PED_ID(), false, false)
        end
    end, false)

    menu.toggle(attach_root, "Attach to player car", {"attachtocar"}, "Only works if they have a car/last car", function(on)
        local lastveh = PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
        if on and lastveh ~= 0 then
            ENTITY.ATTACH_ENTITY_TO_ENTITY(PLAYER.PLAYER_PED_ID(), lastveh, 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
        else
            ENTITY.DETACH_ENTITY(PLAYER.PLAYER_PED_ID(), false, false)
        end
    end, false)


    menu.toggle(ls_proot, "Earrape", {"earrape"}, "Be evil.", function(on)
        if on then
            earrape = true
            earrape_target = pid
        else
            earrape = false
        end
    end, false)

    menu.toggle(ls_proot, "Blackhole target", {"bhtarget"}, "A really toxic thing to do but you should do it anyways because it\'s fun. Obviously requires blackhole to be on.", function(on)
        if on then
            bh_target = pid
            if not blackhole then
                blackhole = true
                menu.trigger_commands("blackhole on")
            end
        else
            bh_target = -1
            if blackhole then
                blackhole = false
                menu.trigger_commands("blackhole off")
            end
        end
    end, false)

    menu.toggle(ls_proot, "Mock this player in chat", {"mockplayer"}, "Mocks them when they say a message by repeating it in chat lIkE ThiS", function(on)
        if on then
            mock_target = pid
            mock = true
        else
            mock_target = -1
            mock = false
        end
    end)
    ---1788665315
    menu.action(npctrolls_root, "Dog attack", {"dogatk"}, "arf uwu", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
        local hash = -1788665315
        request_model_load(hash)
        local dog = util.create_ped(28, hash, coords, math.random(0, 270))
        ENTITY.SET_ENTITY_INVINCIBLE(dog, true)
        TASK.TASK_COMBAT_PED(dog, target_ped, 0, 16)
    end)


    menu.action(npctrolls_root, "Mountain lion attack", {"cougaratk"}, "rawr", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
        local hash = 307287994
        request_model_load(hash)
        local cat = util.create_ped(28, hash, coords, math.random(0, 270))
        ENTITY.SET_ENTITY_INVINCIBLE(cat, true)
        TASK.TASK_COMBAT_PED(cat, target_ped, 0, 16)
    end)

    --ATTACH_VEHICLE_TO_TOW_TRUCK(Vehicle towTruck, Vehicle vehicle, BOOL rear, float hookOffsetX, float hookOffsetY, float hookOffsetZ)
    menu.action(npctrolls_root, "Tow last car", {"towtruck"}, "They didn\'t pay their lease. ONLY works on cars that the player is NOT in but WAS in (because you cant touch entities the player is driving).", function(on_click)
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local last_veh = PED.GET_VEHICLE_PED_IS_IN(player_ped, true)
        local cur_veh = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
        if last_veh ~= 0 then
            if last_veh == cur_veh then
                util.toast("They are still inside the car. Wait until they leave it.")
                return
            end
            tow_hash = -1323100960
            request_model_load(tow_hash)
            tower_hash = 0x9C9EFFD8
            request_model_load(tower_hash)
            local rots = ENTITY.GET_ENTITY_ROTATION(last_veh, 0)
            local dir = 5.0
            hdg = ENTITY.GET_ENTITY_HEADING(last_veh)
            if towfrombehind then
                dir = -5.0
                hdg = hdg + 180
            end
            local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(last_veh, 0.0, dir, 0.0)
            local tower = util.create_ped(28, tower_hash, coords, 30.0)
            local towtruck = util.create_vehicle(tow_hash, coords, hdg)
            ENTITY.SET_ENTITY_HEADING(towtruck, hdg)
            PED.SET_PED_INTO_VEHICLE(tower, towtruck, -1)
            VEHICLE.ATTACH_VEHICLE_TO_TOW_TRUCK(towtruck, last_veh, true, 0, 0, 0)
            TASK.TASK_VEHICLE_DRIVE_TO_COORD(tower, towtruck, math.random(1000), math.random(1000), math.random(100), 100, 1, ENTITY.GET_ENTITY_MODEL(last_veh), 4, 5, 0)
        end
    end)

    
    menu.toggle(npctrolls_root, "Tow from behind", {"towbehind"}, "Toggle on if the front of the car is blocked", function(on)
        if on then
            towfrombehind = true
        else
            towfrombehind = false
        end
    end)



    menu.action(npctrolls_root, "Cat explosion", {"meow"}, "UWU", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
        hash = util.joaat("a_c_cat_01")
        request_model_load(hash)
        for i=1, 30 do
            local cat = util.create_ped(28, hash, coords, math.random(0, 270))
            local rand_x = math.random(-10, 10)*5
            local rand_y = math.random(-10, 10)*5
            local rand_z = math.random(-10, 10)*5
            ENTITY.SET_ENTITY_INVINCIBLE(cat, true)
            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(cat, 1, rand_x, rand_y, rand_z, true, false, true, true)
        end
    end)


    menu.action(npctrolls_root, "Send griefer Jesus", {"sendgrieferjesus"}, "Spawns an invincible Jesus with a railgun that will constantly attack the player, even after they die, teleporting to them if they are too far away. This tends to be super glitchy sometimes, but it\'s usually due to networking.", function(on_click)
        dispatch_griefer_jesus(pid)
    end)

    menu.toggle(objecttrolls_root, "Glitch vehicle", {"glitchveh"}, "Glitches the car they\'re in/if they enter one.", function(on)
        if on then
            local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local veh = PED.GET_VEHICLE_PED_IS_IN(target_ped, true)
            local coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
            local hash = 4173164723
            request_model_load(hash)
            guitar = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'], coords['y'], coords['z'], true, false, false)
            ENTITY.SET_ENTITY_VISIBLE(guitar, false)
            ENTITY.ATTACH_ENTITY_TO_ENTITY(guitar, target_ped, 0, 0.0, -0.20, 0.50, 1.0, 1.0,1, true, true, true, false, 0, true)
        else
            ENTITY.DETACH_ENTITY(guitar, false, false)
            util.delete_entity(guitar)
        end
    end)

    menu.action(npctrolls_root, "Send jets", {"sendjets"}, "We don\'t charge $140 for this extremely basic feature. However the jets will only target the player until the player dies, otherwise we would need another thread, and I don\'t want to make one.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(target_ped, 1.0, 0.0, 500.0)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
        local hash = util.joaat("lazer")
        request_model_load(hash)
        request_model_load(-163714847)
        for i=1, 10 do
            coords.x = coords.x + i*2
            coords.y = coords.y + i*2
            local jet = util.create_vehicle(hash, coords, 90.0)
            local pilot = util.create_ped(28, -163714847, coords, 30.0)
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(jet, 100.0)
            VEHICLE.SET_VEHICLE_FORCE_AFTERBURNER(jet, true)
            PED.SET_PED_INTO_VEHICLE(pilot, jet, -1)
            TASK.TASK_COMBAT_PED(pilot, target_ped, 0, 16)
        end
    end)

    menu.action(entspam_root, "Traffic cones", {"conespam"}, "Spams traffic cones", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 3760607069)
    end)

    menu.action(entspam_root, "Dildo", {"dildospam"}, ":flushed:", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 3872089630)
    end)

    menu.action(entspam_root, "Hot dog", {"hotdogspam"}, "a dog thats hot", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 2565741261)
    end)

    menu.action(entspam_root, "Hot dog STAND", {"hotdogstandspam"}, "You know why I capitalized what I did.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 2713464726)
    end)

    menu.action(entspam_root, "Ferris wheel", {"ferriswheelspam"}, "BE CAREFUL", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 3291218330)
    end)

    menu.action(entspam_root, "Rollercoaster car", {"rollerspam"}, "fun times", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 3413442113)
    end)

    menu.action(entspam_root, "Air radar", {"radarspam"}, "they spin", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 2306058344)
    end)
    --1681875160


    menu.action(entspam_root, "Custom entity", {"customentityspam"}, "Inputs a custom entity. Try not to input invalid hashes, but the requester function is smart and should be fine if you do.", function(on_click)
        util.toast("Please input the model hash")
        menu.show_command_box("customentityspam ")
    end, function(on_command)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, on_command)
    end)

    menu.toggle(entspam_root, "Entities have gravity", {"entitygrav"}, "", function(on)
        if on then
            entity_grav = true
        else
            entity_grav = false
        end
    end, true)

    menu.click_slider(entspam_root, "Number of entities", {"entspamnum"}, "Number of ents to spam. Obviously, setting this to a high number will crash you or freeze your game indefinitely.", 1, 100, 30, 10, function(s)
        num_of_spam = s
    end)

    menu.action(objecttrolls_root, "Ramp in front of player", {"ramp"}, "Spawns a ramp right in front of the player. Most nicely used when they are in a car.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local hash = 2282807134
        request_model_load(hash)
        spawn_object_in_front_of_ped(target_ped, hash, 90, 50.0, -0.5, true)
    end)

    menu.action(objecttrolls_root, "Barrier in front of player", {"barrier"}, "Spawns a *frozen* barrier right in front of the player. Good for causing accidents.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local hash = 3729169359
        local obj = spawn_object_in_front_of_ped(target_ped, hash, 0, 5.0, -0.5, false)
        ENTITY.FREEZE_ENTITY_POSITION(obj, true)
    end)

    menu.action(objecttrolls_root, "Windmill player", {"windmill"}, "gotem.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local hash = 1952396163
        local obj = spawn_object_in_front_of_ped(target_ped, hash, 0, 5.0, -30, false)
        ENTITY.FREEZE_ENTITY_POSITION(obj, true)
    end)

    menu.action(objecttrolls_root, "Radar player", {"radar"}, "also gotem.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local hash = 2306058344
        local obj = spawn_object_in_front_of_ped(target_ped, hash, 0, 0.0, -5.0, false)
        ENTITY.FREEZE_ENTITY_POSITION(obj, true)
    end)

    menu.action(ls_proot, "Owned snipe", {"snipe"}, "Snipes the player with you as the attacker [Will not work if you do not have LOS with the target]", function(on_click)
        local owner = PLAYER.PLAYER_PED_ID()
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local target = ENTITY.GET_ENTITY_COORDS(target_ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z']+0.1, 300.0, true, 100416529, owner, true, false, 100.0)
    end)
    menu.action(ls_proot, "Anon snipe", {"selfsnipe"}, "Snipes the player anonymously, as if a random ped did it [The randomly selected ped needs to have LOS, I think]", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local target = ENTITY.GET_ENTITY_COORDS(target_ped)
        local random_ped = get_random_ped()
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z']+0.1, 300.0, true, 100416529, random_ped, true, false, 100.0)
    end)

    --SET_VEHICLE_WHEEL_HEALTH(Vehicle vehicle, int wheelIndex, float health)
    menu.action(ls_proot, "Cage", {"lscage"}, "Basic cage option. Cause you cant handle yourself. We are a little more ethical here at Lance Studios though, so the cage has some wiggle room (our special cage model also means that like, no menu blocks the model).", function(on_click)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(ped, true)
        local hash = 779277682
        request_model_load(hash)
        local cage1 = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'], coords['y'], coords['z'], true, false, false)
        ENTITY.SET_ENTITY_ROTATION(cage1, 0.0, -90.0, 0.0, 1, true)
        local cage2 = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'], coords['y'], coords['z'], true, false, false)
        ENTITY.SET_ENTITY_ROTATION(cage2, 0.0, 90.0, 0.0, 1, true)
    end)

    menu.action(npctrolls_root, "NPC jack last car", {"npcjack"}, "Sends an NPC to steal their car. Works best if they are out of their car.", function(on_click)
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local last_veh = PED.GET_VEHICLE_PED_IS_IN(player_ped, true)
        local cur_veh = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
        if last_veh ~= 0 then
            local hash = 0x9C9EFFD8
            request_model_load(hash)
            local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player_ped, -2.0, 0.0, 0.0)
            coords.x = coords['x']
            coords.y = coords['y']
            coords.z = coords['z']
            local ped = util.create_ped(28, hash, coords, 30.0)
            if cur_veh ~= last_veh then
                PED.SET_PED_INTO_VEHICLE(ped, last_veh, -1)
            end
            ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
            PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
            PED.SET_PED_FLEE_ATTRIBUTES(ped, 0, false)
            PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
            PED.SET_PED_CAN_BE_DRAGGED_OUT(ped, false)
            PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(ped, false)
            --TASK.TASK_GO_TO_COORD_ANY_MEANS(ped, math.random(1000), math.random(1000), math.random(100), 80.0, 0, true, 262144, 1)
            TASK.TASK_COMBAT_PED(ped, playerped, 0, 16)
            TASK.TASK_VEHICLE_DRIVE_TO_COORD(ped, last_veh, math.random(1000), math.random(1000), math.random(100), 100, 1, ENTITY.GET_ENTITY_MODEL(last_veh), 4, 5, 0)
        end
    end)

    menu.action(npctrolls_root, "Bri'ish mode", {"british"}, "God save the queen.", function(on_click)
        local hash = 0x9C9EFFD8
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        request_model_load(hash)
        local coords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
        for i=1, 5 do
            coords.x = coords['x']
            coords.y = coords['y']
            ped = util.create_ped(28, hash, coords, 30.0)
            PED.SET_PED_AS_ENEMY(ped, true)
            PED.SET_PED_FLEE_ATTRIBUTES(ped, 0, false)
            PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
            WEAPON.GIVE_WEAPON_TO_PED(ped, -1834847097, 0, false, true)
            TASK.TASK_COMBAT_PED(ped, player_ped, 0, 16)
        end
    end)

    menu.action(npctrolls_root, "Tell nearby peds to arrest", {"arrest"}, "Tells nearby peds to arrest the player. Obviously there is no arrest mechanic in GTA:O. So they don\'t actually arrest. But they will try.", function(on_click)
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local all_peds = util.get_all_peds()
        for k, ped in pairs(all_peds) do
            if not is_ped_player(ped) then
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped)
                PED.SET_PED_AS_COP(ped, true)
                PED.SET_PED_FLEE_ATTRIBUTES(ped, 0, false)
                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped, 453432689, 0, false, true)
                TASK.TASK_ARREST_PED(ped, player_ped)
            end
        end
    end)

    menu.action(npctrolls_root, "Fill car with peds", {"fillcar"}, "Fills the player\'s car with nearby peds", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        if PED.IS_PED_IN_ANY_VEHICLE(target_ped, true) then
                local veh = PED.GET_VEHICLE_PED_IS_IN(target_ped, false)
                local success = true
                while VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(veh) do
                    util.yield()
                    --  sometimes peds fail to get seated, so we will have something to break after 10 attempts if things go south
                    local iteration = 0
                    if iteration >= 20 then
                        util.toast("Failed to fully fill vehicle after 20 attempts. Please try again.")
                        local success = false
                        iteration = 0
                        break
                    end
                    local iteration = iteration + 1
                    local nearby_peds = util.get_all_peds()
                    for k,ped in pairs(nearby_peds) do
                        if PED.GET_VEHICLE_PED_IS_IN(ped, false) ~= veh and ENTITY.GET_ENTITY_HEALTH(ped) > 0 and not PED.IS_PED_FLEEING(ped) then
                            --dont touch player peds
                            if(PED.GET_PED_TYPE(ped) > 4) then
                                local veh = PED.GET_VEHICLE_PED_IS_IN(target_ped, false)
                                local iteration = iteration + 1
                                    for index = 0, VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(ENTITY.GET_ENTITY_MODEL(veh)) do
                                        if VEHICLE.IS_VEHICLE_SEAT_FREE(veh, index) then
                                            -- i think requesting control and clearing task deglitches the peds
                                            -- this is specifically to counter weird A-posing
                                            -- EDIT: it doesnt. why the fuck do some peds a-pose??? maybe ill find out eventually. oh well.
                                            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ped)
                                            TASK.CLEAR_PED_TASKS(ped)
                                            PED.SET_PED_INTO_VEHICLE(ped, veh, index)
                                            PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                                            PED.SET_PED_FLEE_ATTRIBUTES(ped, 0, false)
                                            PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
                                            PED.SET_PED_CAN_BE_DRAGGED_OUT(ped, false)
                                            PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(ped, false)
                                        end
                                    end
                                break
                            end
                        end
                    end
                end
                if success then
                    util.toast("Every available seat should now be full of peds. If it isn\'t, try spamming this or try again in a bit.")
                end
        else
            util.toast("Player is not in a car :(")
        end
    end)
    
    menu.toggle(npctrolls_root, "Nearby traffic chases player", {"pedchase"}, "", function(on)
        if on then
            ped_chase = true
            ped_uses = ped_uses + 1
            chase_target = pid
        else
            ped_chase = false
            ped_uses = ped_uses - 1
        end
    end, false)

    menu.toggle(ls_proot, "Dispatch cops for player", {"dispatchcops"}, "Dispatches cops on the player.", function(on)
        ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        if on then
            PLAYER.SET_DISPATCH_COPS_FOR_PLAYER(ped, true)
        else
            PLAYER.SET_DISPATCH_COPS_FOR_PLAYER(ped, true)
        end
    end)

    menu.toggle(ls_proot, "Swiss cheese", {"swisscheese"}, "Rains a shit ton of bullets on the player. Anonymously.", function(on)
        if on then
            bullet_rain = true
            bullet_rain_target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            bullet_rain_scapegoat = get_random_ped()
        else
            bullet_rain = false
        end
    end)

    menu.click_slider(ls_proot, "Swiss cheese damage", {"swisscheesedmg"}, "Sets what damage swiss cheese option should do", 0, 1000, 0, 100, function(s)
        swiss_cheese_dmg = s
      end)
end

function read_global_int(global)
    return memory.read_int(memory.script_global(global))
end

function get_business_stat(business, offset)
    return read_global_int(1590908 + 1 + (PLAYER.PLAYER_ID() * 874) + 267 + 183 + 1 + (business*12) + offset)
    --1590535+1+(PLAYER_ID()*876)+274+183+1+(ID*12)
end

--[[
bm_meth = false
menu.toggle(business_root, "Meth", {"bm_meth"}, "", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        bm_meth = true
    else
        bm_meth = false
    end
end, false)

bm_weed = false
menu.toggle(business_root, "Weed", {"bm_weed"}, "", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        bm_weed = true
    else
        bm_weed = false
    end
end, false)

bm_documents = false
menu.toggle(business_root, "Documents", {"bm_documents"}, "", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        bm_documents = true
    else
        bm_documents = false
    end
end, false)
]]

attachall_root = menu.list(allplayers_root, "Attach", {"attach"}, "")

function attachall(hash, bone, isnpc)
    request_model_load(hash)
    for k, pid in pairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(ped, true)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
        if isnpc then
            obj = util.create_ped(1, 0x9C9EFFD8, coords, 90.0)
        else
            obj = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'], coords['y'], coords['z'], true, false, false)
        end
        ENTITY.SET_ENTITY_INVINCIBLE(obj, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(obj, ped, bone, 0.0, 0.0, 0.0, 0.0, 90.0, 0.0, false, false, true, false, 0, true)
    end
end

menu.action(attachall_root, "Ball", {"aaball"}, "The OG", function(on_click)
    attachall(148511758, 0, false)
end)

menu.action(attachall_root, "Cone hat", {"aacone"}, "coneheads", function(on_click)
    attachall(3760607069, 98, false)
end)

menu.action(attachall_root, "Ferris wheel", {"aafwheel"}, "toxic", function(on_click)
    attachall(3291218330, 0, false)
end)

menu.action(attachall_root, "Fuel tanker", {"aatanker"}, "boom", function(on_click)
    attachall(3763623269, 0, false)
end)

menu.action(attachall_root, "NPC", {"aanpc"}, "toxic", function(on_click)
    attachall(3291218330, 0, true)
end)

show_voicechatters = false
menu.toggle(online_root, "Show me who\'s using voicechat", {"showvoicechat"}, "Shows who is actually using GTA:O voice chat, in 2021. Which is likely to be nobody. So this is a bitch to test. but.", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        show_voicechatters = true
        player_uses = player_uses + 1
    else
        show_voicechatters = false
        player_uses = player_uses - 1
    end
end)

aptloop = false
menu.toggle(allplayers_root, "Apartment tp loop", {"apartmenttploop"}, "Please advise, extremely toxic", function(on)
    if on then
        aptloop = true
    else
        aptloop = false
    end
end, false)

menu.action(allplayers_root, "Session-wide chat", {"sessionwidechat"}, "Makes everyone in the session except you say something.", function(on_click)
    util.toast("Please type what you want the entire session to say.")
    menu.show_command_box("sessionwidechat ")
end, function(on_command)
    if #on_command > 140 then
        util.toast("That message is too long to show fully! I just saved you from humiliation.")
        return
    end
    for k,p in pairs(players.list(false, true, true)) do
        local name = PLAYER.GET_PLAYER_NAME(p)
        menu.trigger_commands("chatas" .. name .. " on")
        chat.send_message(on_command, false, true, true)
        menu.trigger_commands("chatas" .. name .. " off")
    end
end)

menu.action(allplayers_root, "Toast best mug target", {"best mug"}, "Toasts you the player with the most wallet money, so you can mug them nicely.", function(on_click)
    local most = 0
    for k,p in pairs(players.list(false, true, true)) do
        cur_wallet = players.get_wallet(p)
        if cur_wallet > most then
            local most = p
        end
    end
    if cur_wallet == nil then
        util.toast("You are alone. Cannot find best mug target.")
        return
    end
    if most ~= nil then
        util.toast(PLAYER.GET_PLAYER_NAME(most) .. " has the most money in their wallet ($" .. cur_wallet .. ")")
    else
        util.toast("Couldn\'t find best mug target.")
    end
end)

antioppressor = false
menu.toggle(allplayers_root, "Antioppressor", {"antioppressor"}, "Automatically blows up oppressor mkII\'s", function(on)
    if on then
        antioppressor = true
        player_uses = player_uses + 1
    else
        antioppressor = false
        player_uses = player_uses - 1
    end
end, false)

menu.toggle(allplayers_root, "Mean antioppressor", {"meanantioppressor"}, "Requires antioppressor to be on. Simply tells antioppressor to kick the player instead of messing with explosives.", function(on)
    if on then
        meanantioppressor = true
    else
        meanantioppressor = false
    end
end, false)

chat_filter = false
menu.toggle(online_root, "Chat filter", {"chatfilter"}, "Auto-kicks players who say words in your banned words list", function(on)
    if on then
        chat_filter = true
    else
        chat_filter = false
    end
end, false)

infibounty = false
menu.toggle(allplayers_root, "Infibounty", {"infibounty"}, "Applies $10k bounty to all players, every 60 seconds", function(on)
    if on then
        infibounty = true
        start_infibounty_thread()
    else
        infibounty = false
    end
end, false)

menu.action(allplayers_root, "Crash all", {"crashall"}, "Crashes everyone using a basic yet working method I discovered. 2take1 punching the air rn. Please don\'t abuse it.", function(on_click)
    str = string.char(98) .. string.char(101) .. string.char(97) .. string.char(108) .. string.char(111) .. string.char(110) .. string.char(101)
    util.toast("Crashall initiated, please hold")
    menu.trigger_commands(str)
end)

for k,p in pairs(players.list(true, true, true)) do
    set_up_player_actions(p)
end

players.on_join(function(pid)
    set_up_player_actions(pid)
    if joinsound then
        AUDIO.PLAY_SOUND_FRONTEND(23, "LOSER", "HUD_AWARDS", true)
    end
end)

players.on_leave(function(pid)
    if leavesound then
        AUDIO.PLAY_SOUND_FRONTEND(28, "COLLECTED", "HUD_AWARDS", true)
    end
end)

vehicles_thread = util.create_thread(function (thr)
    while true do
        for k,veh in pairs(all_vehicles) do
            if player_cur_car ~= veh and not is_ped_player(VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1)) then
                if blackhole then
                    if bh_target ~= -1 then
                        holecoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
                    end
                    vcoords = ENTITY.GET_ENTITY_COORDS(veh, true)
                    speed = 100
                    local x_vec = (holecoords['x']-vcoords['x'])*speed
                    local y_vec = (holecoords['y']-vcoords['y'])*speed
                    local z_vec = ((holecoords['z']+hole_zoff)-vcoords['z'])*speed
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                    -- dumpster fire if this goes wrong lol
                    ENTITY.SET_ENTITY_INVINCIBLE(veh, true)
                    --losioVEHICLE.SET_VEHICLE_GRAVITY(veh, false)
                    ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(veh, 1, x_vec, y_vec, z_vec, true, false, true, true)
                end
                if vehicle_chaos then
                    VEHICLE.SET_VEHICLE_OUT_OF_CONTROL(veh, false, true)
                    VEHICLE.SET_VEHICLE_FORWARD_SPEED(veh, vc_speed)
                    VEHICLE.SET_VEHICLE_GRAVITY(veh, vc_gravity)
                end
    
                if halt_traffic then
                    VEHICLE.BRING_VEHICLE_TO_HALT(veh, 0.0, -1, true)
                    coords = ENTITY.GET_ENTITY_COORDS(veh, false)
                end
                if ascend_vehicles then
                    VEHICLE.SET_VEHICLE_UNDRIVEABLE(veh, true)
                    VEHICLE.SET_VEHICLE_GRAVITY(veh, false)
                    ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(veh, 4, 5.0, 0.0, 0.0, true, true, true, true)
                end
    
                if vehicle_fuckup then
                    VEHICLE.SET_VEHICLE_DAMAGE(veh, math.random(-5.0, 5.0), math.random(-5.0, 5.0), math.random(-5.0,5.0), 200.0, 10000.0, true)
                end
    
                if godmode_vehicles then
                    ENTITY.SET_ENTITY_CAN_BE_DAMAGED(veh, false)
                end
    
                if disable_veh_colls then
                    VEHICLE._DISABLE_VEHICLE_WORLD_COLLISION(veh)
                end
    
                if vehicle_rainbow then
                    VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(veh, rgb[1], rgb[2], rgb[3])
                    VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(veh, rgb[1], rgb[2], rgb[3])
                    for i=0, 3 do
                        VEHICLE._SET_VEHICLE_NEON_LIGHT_ENABLED(veh, i, true)
                    end
                    VEHICLE._SET_VEHICLE_NEON_LIGHTS_COLOUR(veh, rgb[1], rgb[2], rgb[3])
                    VEHICLE.SET_VEHICLE_LIGHTS(veh, 2)
                end
    
                if no_radio then
                    AUDIO.SET_VEHICLE_RADIO_ENABLED(veh, false)
                end
    
                if loud_radio then
                    AUDIO.SET_VEHICLE_RADIO_LOUD(veh, true)
                end

                if reverse_traffic then
                    ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1)
                    TASK.TASK_VEHICLE_TEMP_ACTION(ped, veh, 3, -1)
                end
            end
        end
        util.yield()
    end
end)

peds_thread = util.create_thread(function (thr)
    while true do
        for k,ped in pairs(all_peds) do
            if not is_ped_player(ped) then
                -- voicelines
                if roast_voicelines then
                    AUDIO.PLAY_PED_AMBIENT_SPEECH_NATIVE(ped, "GENERIC_INSULT_MED", "SPEECH_PARAMS_FORCE_SHOUTED")
                end

                if sex_voicelines then
                    AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(ped, "SEX_GENERIC_FEM", "S_F_Y_HOOKER_01_WHITE_FULL_01", "SPEECH_PARAMS_FORCE_SHOUTED", 0)
                end

                if gluck_voicelines then
                    AUDIO.PLAY_PED_AMBIENT_SPEECH_WITH_VOICE_NATIVE(ped, "SEX_ORAL_FEM", "S_F_Y_HOOKER_01_WHITE_FULL_01", "SPEECH_PARAMS_FORCE_SHOUTED", 0)
                end

                if screamall then
                    AUDIO.PLAY_PAIN(ped, 7, 0)
                end

                if play_ped_ringtones then
                    AUDIO.PLAY_PED_RINGTONE("Dial_and_Remote_Ring", ped, true)
                end
    
                if dumb_peds then
                    PED.SET_PED_HIGHLY_PERCEPTIVE(ped, false)
                    PED.SET_PED_ALERTNESS(ped, 0)
                    PED.SET_PED_FLEE_ATTRIBUTES(ped, 0, false)
                end
    
                if peds_arrest_player then
                    TASK.TASK_ARREST_PED(ped, arrest_target)
                end
    
                if deaf_peds then
                    PED.SET_PED_HEARING_RANGE(ped, 0.0)
                end
    
                if safe_peds then
                    PED.GIVE_PED_HELMET(ped, true, 4096, 0)
                end

                if kill_peds then
                    if ENTITY.GET_ENTITY_HEALTH(ped) > 0 then
                        PED.EXPLODE_PED_HEAD(ped, -771403250)
                    end
                end

                if ped_chase then
                    if PED.IS_PED_IN_ANY_VEHICLE(ped) then
                        PED.SET_PED_COMBAT_ATTRIBUTES(ped, 5, true)
                        PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
                        TASK.SET_TASK_VEHICLE_CHASE_IDEAL_PURSUIT_DISTANCE(ped, 0.0)
                        TASK.SET_TASK_VEHICLE_CHASE_BEHAVIOR_FLAG(ped, 1, true)
                        TASK.TASK_VEHICLE_CHASE(ped, PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(chase_target))
                    end
                end
            end
        end
        util.yield()
    end
end)

players_thread = util.create_thread(function (thr)
    while true do
        for k,pid in pairs(all_players) do
            if antioppressor then
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                if vehicle then
                  local hash = util.joaat("oppressor2")
                  if VEHICLE.IS_VEHICLE_MODEL(vehicle, hash) then
                    if meanantioppressor then
                        menu.trigger_commands("kick".. PLAYER.GET_PLAYER_NAME(pid))
                    else
                        menu.trigger_commands("explode".. PLAYER.GET_PLAYER_NAME(pid))
                    end
                  end
                end
            end

            if show_voicechatters then
                if NETWORK.NETWORK_IS_PLAYER_TALKING(pid) then
                    util.toast(PLAYER.GET_PLAYER_NAME(pid) .. " is talking")
                end
            end
        end    
        util.yield()
    end
end)

-- thread i use when i want stuff to occur on a loop, but have a delay
-- same premise of rgb thread
timed_thread = util.create_thread(function (thr)
    tlightstate = 0
    while true do
        if tlightstate < 3 then
            tlightstate = tlightstate + 1
        else
            tlightstate = 0
        end
        util.yield(100)
    end
end)

objects_thread = util.create_thread(function (thr)
    while true do
        for k,obj in pairs(all_objects) do
            if object_rainbow then
                OBJECT._SET_OBJECT_LIGHT_COLOR(obj, 1, rgb[1], rgb[2], rgb[3])
            end

            if rapidtraffic then
                ENTITY.SET_ENTITY_TRAFFICLIGHT_OVERRIDE(obj, tlightstate)
            end
        end    
        util.yield()
    end
end)
chat.on_message(function(sender_player_id, sender_player_name, message, is_team_chat)
    if sender_player_id ~= players.user() then
        if chat_filter then
            for n, w in pairs(banned_words) do
                if string.find(string.lower(message), w) then
                    util.toast(sender_player_name .. ' said a banned word (' .. w .. '). Kicking them.')
                    menu.trigger_commands("kick ".. sender_player_name)
                end
            end
        end

        if antiad then
            if string.find(message, '□') then
                util.toast("Goodbye advertiser!")
                menu.trigger_commands("crash" .. sender_player_name)
            end
        end

        if mock then
            if sender_player_id == mock_target then
                mock_str = ""
                mode = 1
                for i=1, string.len(message) do
                    letter = string.sub(message, i, i)
                    if mode == 1 then
                        mock_str = mock_str .. string.upper(letter)
                        mode = 2
                    else
                        mock_str = mock_str .. string.lower(letter)
                        mode = 1
                    end
                end
                chat.send_message(mock_str, false, true, true)
            end
        end
    end
end)

while true do
    if shoot_entities then
        plyr = PLAYER.PLAYER_PED_ID()
        if shoot_entity ~= -1 then
            if PAD.IS_CONTROL_PRESSED(24, 24) then
                request_model_load(shoot_entity)
                obj = spawn_object_in_front_of_ped(plyr, shoot_entities, 90.0, 10, 0, false)
                camrot = CAM.GET_GAMEPLAY_CAM_ROT(0)
                ENTITY.SET_ENTITY_ROTATION(obj, camrot['x'], camrot['y'], camrot['z'], 0, true)
            end
        end
    end
    if aptloop then
        menu.trigger_commands("aptmeall")
    end
    if rainbow_tint then
        WEAPON.SET_PED_WEAPON_TINT_INDEX(PLAYER.PLAYER_PED_ID(),WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID()), cur_tint)
    end
    if noexplosives then
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(741814745, false)
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(-1312131151, false)
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(-1568386805, false)
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(2138347493, false)
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(1672152130, false)
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(125959754, false)
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(-1813897027, false)
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(615608432, false)
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(1420407917, false)
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(1169823560, false)
    end

    if stickyground then
        if player_cur_car then
            local vel = ENTITY.GET_ENTITY_VELOCITY(player_cur_car)
            ENTITY.SET_ENTITY_VELOCITY(player_cur_car, vel['x'], vel['y'], -0.2)
        end
    end
    if bm_meth then
        local id = 0
        util.toast(get_business_stat(id, 2))
    end
    if bm_weed then
        local id = 1
        util.toast(get_business_stat(1, 1))
    end
    if bm_documents then
        local id = 4
    end
    if earrape then
        coords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(earrape_target), true)
        coords['x'] = coords['x'] + 15
        coords['y'] = coords['y'] + 15
        coords['z'] = coords['z'] + 15
        FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 38, 0.0, true, true, 0.0)
    end

    if lightning_spam then
        MISC.FORCE_LIGHTNING_FLASH()
    end

    if firework_spam then
        coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
        coords['x'] = coords['x'] + math.random(-100, 100)
        coords['y'] = coords['y'] + math.random(-100, 100)
        coords['z'] = coords['z'] + math.random(30, 100)
        FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 38, 100.0, false, false, 0.0)
    end

    if instantspinup then
        if player_cur_car then
            VEHICLE.SET_HELI_BLADES_FULL_SPEED(player_cur_car)
        end
    end

    if mph_plate then
        if player_cur_car then
            if mph_unit == "kph" then
                unit_conv = 3.6
            else
                unit_conv = 2.236936
            end
            speed = math.ceil(ENTITY.GET_ENTITY_SPEED(player_cur_car)*unit_conv)
            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(player_cur_car, speed .. " " .. mph_unit)
        end
    end

    if noclip then
        HUD.DISPLAY_SNIPER_SCOPE_THIS_FRAME()
        player_ped = PLAYER.PLAYER_PED_ID()
        veh = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
        if veh ~= 0 then
            player_ped = veh
        end
        player_coord = ENTITY.GET_ENTITY_COORDS(player_ped, false)
        camrot = CAM.GET_GAMEPLAY_CAM_ROT(0)
        ENTITY.SET_ENTITY_ROTATION(player_ped, 0, 0, camrot['z'], 0, true)
        forward = ENTITY.GET_ENTITY_FORWARD_VECTOR(player_ped)
        -- i know this part looks redundant but i promise its necessary
        if PAD.IS_CONTROL_PRESSED(32, 32) then
            ENTITY.SET_ENTITY_COORDS(player_ped, player_coord['x']+forward['x']*noclip_hspeed, player_coord['y']+forward['y']*noclip_hspeed, noclip_height, false, false, false, false)
        elseif PAD.IS_CONTROL_PRESSED(130, 130) then
            ENTITY.SET_ENTITY_COORDS(player_ped, player_coord['x']-forward['x']*noclip_hspeed, player_coord['y']-forward['y']*noclip_hspeed, noclip_height, false, false, false, false)
        else
            if PAD.IS_CONTROL_PRESSED(102, 102) then
                ENTITY.SET_ENTITY_COORDS(player_ped, player_coord['x'], player_coord['y'], noclip_height, false, false, false, false)
                noclip_height = noclip_height + noclip_vspeed
            elseif PAD.IS_CONTROL_PRESSED(36, 36) then
                ENTITY.SET_ENTITY_COORDS(player_ped, player_coord['x'], player_coord['y'], noclip_height, false, false, false, false)
                noclip_height = noclip_height - noclip_vspeed
            end
        end

        if PAD.IS_CONTROL_PRESSED(102, 102) then
            noclip_height = noclip_height + noclip_vspeed
            --ENTITY.SET_ENTITY_COORDS(player_ped, player_coord['x'], player_coord['y'], noclip_height, false, false, false, false)
        end

        if PAD.IS_CONTROL_PRESSED(36, 36) then
            noclip_height = noclip_height - noclip_vspeed
            --ENTITY.SET_ENTITY_COORDS(player_ped, player_coord['x'], player_coord['y'], noclip_height, false, false, false, false)
        end

    end
    if vehicle_uses > 0 then
        if show_updates then
            util.toast("Vehicle pool is being updated")
        end
        all_vehicles = util.get_all_vehicles()
    end

    if player_uses > 0 then
        if show_updates then
            util.toast("Player pool is being updated")
        end
        all_players = players.list(true, true, true)
    end

    if ped_uses > 0 then
        if show_updates then
            util.toast("Ped pool is being updated")
        end
        all_peds = util.get_all_peds()
    end

    if object_uses > 0 then
        if show_updates then
            util.toast("Object pool is being updated")
        end
        all_objects = util.get_all_objects()
    end

    player_cur_car = PED.GET_VEHICLE_PED_IS_IN(PLAYER.PLAYER_PED_ID())
    
    if hud_rainbow then
        for i=0,215 do
            HUD.REPLACE_HUD_COLOUR_WITH_RGBA(i, rgb[1], rgb[2], rgb[3], 255)
        end
    end

    if player_cur_car then
        if everythingproof then
            ENTITY.SET_ENTITY_PROOFS(player_cur_car, true, true, true, true, true, true, true, true)
        end
        if racemode then
            VEHICLE.SET_VEHICLE_IS_RACING(player_cur_car, true)
        end

        if infcms then
            if VEHICLE._GET_VEHICLE_COUNTERMEASURE_COUNT(player_cur_car) < 100 then
                VEHICLE._SET_VEHICLE_COUNTERMEASURE_COUNT(player_cur_car, 100)
            end
        end

        if shift_drift then
            if PAD.IS_CONTROL_PRESSED(21, 21) then
                VEHICLE.SET_VEHICLE_REDUCE_GRIP(player_cur_car, true)
                VEHICLE._SET_VEHICLE_REDUCE_TRACTION(player_cur_car, 0.0)
            else
                VEHICLE.SET_VEHICLE_REDUCE_GRIP(player_cur_car, false)
            end
        end
    end

    if cont_clear then
        clear_area(clear_radius)
    end
    if entity_reap then
        entity_reaper()
    end

    if bullet_rain then
        target = ENTITY.GET_ENTITY_COORDS(bullet_rain_target)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z']+0.1, swiss_cheese_dmg, true, 100416529, bullet_rain_scapegoat, true, false, 100.0)
    end
	util.yield()
end