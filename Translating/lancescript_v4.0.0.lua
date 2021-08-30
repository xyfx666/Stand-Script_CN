-- coded by lance#8213, from scratch
-- if you are stealing my code to use it in another menu actually kys
require("natives-1627063482")
ocoded_for = 1.57
version = 400
display_version = "4.0.0"
online_v = tonumber(NETWORK._GET_ONLINE_VERSION())
if online_v > ocoded_for then
    util.toast("This script is outdated for the current GTA:O version (" .. online_v .. ", coded for " .. ocoded_for .. "). Some options may not work, but most should.")
end

function set_up_groups()
    local outptr = memory.alloc(4)
    PED.ADD_RELATIONSHIP_GROUP("LANCESCRIPT_NPCS", outptr)
    local outptr = memory.read_int(outptr)
    npc_group = outptr
end
set_up_groups()

self_root = menu.list(menu.my_root(), "自我", {"lancescriptself"}, "Lets you do things to yourself/your ped")
transport_root = menu.list(self_root, "交通", {"lancescripttransport"}, "Chauffeur.")
weapons_root = menu.list(menu.my_root(), "武器", {"lancescriptweapons"}, "Weapon adjustments and tweaks")
protections_root = menu.list(menu.my_root(), "保护", {"lancescriptprotections"}, "Protect yourself before you wreck yourself.")
noclip_root = menu.list(self_root, "无碰撞", {"lancescriptnoclip"}, "Not quite levitation")
world_root = menu.list(menu.my_root(), "世界", {"lancescriptworld"}, "Rule the world")
train_root = menu.list(world_root, "火车", {"lancescripttrain"}, "Control trains to your liking")
entity_root = menu.list(menu.my_root(), "附近载具/物体", {"lancescriptentity"}, "Vehicle chaos, ascend vehicles, beep all vehicles, etc.")
npc_root = menu.list(menu.my_root(), "附近NPC", {"lancescriptnpcs"}, "NPC tasks and more")
tasks_root = menu.list(npc_root, "动作", {"lancescripttasks"}, "")
vehicle_root = menu.list(menu.my_root(), "车辆", {"lanceobjecttroll"}, "")
online_root = menu.list(menu.my_root(), "在线", {"lancescriptonline"}, "")
allplayers_root = menu.list(menu.my_root(), "所有玩家", {"lancescriptallplayers"}, "")
business_root = menu.list(online_root, "产业管理", {"lancescriptbusiness"}, "Business manager allows you to monitor your businesses. It does NOT automatically sell or resupply, so there is no risk of being banned."..
"\nAll values in business manager are reported by the game itself through stats. Lancescript does not miraculously come up with info. If there is an issue, it is an issue with how the game is reporting it, not Lancescript.")
gametweaks_root = menu.list(menu.my_root(), "游戏调整", {"lancescriptgametweaks"}, "")
fakemessages_root = menu.list(gametweaks_root, "虚假信息", {"lancescriptfakemessages"}, "")
labelpresets_root = menu.list(gametweaks_root, "标签预设", {"lancescriptlabelpresets"}, "Lets you HUD elements in the game say different things.")
radio_root = menu.list(gametweaks_root, "广播", {"lancescriptradio"}, "")
lancescript_root = menu.list(menu.my_root(), "LanceScript", {"lancescriptutil"}, "")
sounds_root = menu.list(lancescript_root, "声音", {"lancescriptsounds"}, "")
menu.action(menu.my_root(), "玩家列表", {}, "Quickly opens session players list, for convenience", function(on_click)
    menu.trigger_commands("playerlist")
end)
credits_root = menu.list(menu.my_root(), "感谢列表", {"lancescriptcredits"}, "")

function request_control_of_entity(ent)
    local netid = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(ent)
    NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netid, true)
    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
end

function do_label_preset(label, text)
    menu.trigger_commands("addlabel " .. label)
    local prep = "edit" .. string.gsub(label, "_", "") .. " " .. text
    menu.trigger_commands(prep)
    menu.trigger_commands("lancescriptlabelpresets")
    util.toast("Label set!")
end

function get_closest_vehicle_node(x, y, z)
    local closest = memory.alloc(4)
    PATHFIND.GET_CLOSEST_VEHICLE_NODE(x, y, z, closest, 1, 100.0, 2.5)
    local closest = memory.read_int(closest)
    if PATHFIND.IS_VEHICLE_NODE_ID_VALID(closest) then
        local pos = memory.alloc(4)
        PATHFIND.GET_VEHICLE_NODE_POSITION(closest, pos)
        local pos = memory.read_vector3(pos)
        return pos
    else
        util.toast("Vehicle node could not be found! Prevented a possible crash.")
        return {0, 0, 0}
    end
end

function to_rgb(r, g, b, a)
    local color = {}
    color.r = r
    color.g = g
    color.b = b
    color.a = a
    return color
end
black = to_rgb(0.0,0.0,0.0,1.0)
white = to_rgb(1.0,1.0,1.0,1.0)
red = to_rgb(1,0,0,1)
green = to_rgb(0,1,0,1)
blue = to_rgb(0.0,0.0,1.0,1.0)

menu.action(credits_root, "Sainan", {""}, "Donating $200 worth of crypto (top donor), helping with reverse engineering GTA V, developing Stand that makes Lancescript possible, and generally being a big help. Thanks for everything.", function(on_click)
end)
menu.action(credits_root, "61k", {""}, "Donating $20 worth of Litecoin. Thank you for your support.", function(on_click)
end)
menu.action(credits_root, "QuickNET", {""}, "Big help with reverse engineering, natives, memory stuff, etc. Thanks.", function(on_click)
    HUD.ACTIVATE_FRONTEND_MENU(util.joaat("FE_MENU_VERSION_SP_PAUSE"), false, -1)
end)
menu.action(credits_root, "YoYo", {""}, "Donating to my PayPal. Thanks for your support! :)", function(on_click)
end)
menu.action(credits_root, "ICYPhoenix", {""}, "Inspiring Lancescript, help with code/natives", function(on_click)
end)
menu.action(credits_root, "Hollywood Collins", {""}, "For continued support of Lancescript. Thanks a ton for the marketing ;)", function(on_click)
end)
menu.action(credits_root, "Anyone who suggested things", {""}, ":)", function(on_click)
end)
menu.action(credits_root, "You", {""}, "For using Lancescript!", function(on_click)
end)


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
  util.toast(file_name .. ' 未能找到,请确认脚本已正确安装.读INSTALL.TXT!!按照文件夹名称中的说明操作.')
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

local function hasValue( tbl, str )
    local f = false
    for i = 1, #tbl do
        if type( tbl[i] ) == "table" then
            f = hasValue( tbl[i], str )  --  return value from recursion
            if f then break end  --  if it returned true, break out of loop
        elseif tbl[i] == str then
            return true
        end
    end
    return f
end

--update checker
util.async_http_get("pastebin.com", "/raw/zQHkAuEu", function(result)
    result = tonumber(result)
    if version < result then
        util.toast("Lancescript有更新可用!可前往网站更新.")
        os.execute("start \"\" \"https://www.guilded.gg/stand/groups/x3ZgB10D/channels/7430c963-e9ee-40e3-ab20-190b8e4a4752/docs/265965\"")
    else
        util.toast("Lancescript 是最新的!!")
    end
end,
function (fail)
    util.toast("无法检查更新.")
end)

function show_custom_alert_until_enter(l1)
    poptime = os.time()
    while true do
        if PAD.IS_CONTROL_JUST_RELEASED(18, 18) then
            if os.time() - poptime > 0.1 then
                break
            end
        end
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

scaleform_thread = util.create_thread(function (thr)
    name = os.getenv("USERNAME")
    util.toast("你好 " .. name .. "!")
    local scaleForm = GRAPHICS.REQUEST_SCALEFORM_MOVIE("HACKING_MESSAGE")
    local punchline = "~f~~italic~\"" .. punchlines[math.random(1, plct)] .. "\"~italic~"
    GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scaleForm, "SET_DISPLAY")
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(3)
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_PLAYER_NAME_STRING("~p~lancescript v" .. display_version)
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_PLAYER_NAME_STRING(punchline)
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(255)
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(0)
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_INT(255)
    GRAPHICS.SCALEFORM_MOVIE_METHOD_ADD_PARAM_BOOL(true)
    GRAPHICS.END_SCALEFORM_MOVIE_METHOD()
    AUDIO.PLAY_SOUND_FRONTEND(55, "FocusIn", "HintCamSounds", true)
    starttime = os.time()
    while true do
        if os.time() - starttime >= 5 then
            AUDIO.PLAY_SOUND_FRONTEND(55, "FocusOut", "HintCamSounds", true)
            if file_exists(filesystem.scripts_dir() .. 'Tox1cEssent1als.lua') and not file_exists(filesystem.scripts_dir() .. 'disclaimer_viewed.txt') then
                 local text = "~g~阁下没有被禁止进入GTA线上模式~n~ ~w~请注意, 这是来自Lancescript开发者的一则声明,恳请您仔细阅读.~n~我已注意到您或许在使用ToxicEssentials(ToxicEssent1als.lua).~n~我不能强迫您不再使用ToxicEssentials,但它的制作组不是他妈的什么好东西.~n~" .. 
                "ToxicEssentials的内容中包括其他Lua脚本作者的辛苦创作.而它的制作组成员,pnn,在未有标明原作者,或征得原作者同意的情况下剽窃代码,并将其用于商业行为.~n~产生的任何盈利也没有回馈给这些代码的作者."
                local text2 = "您可以继续使用ToxicEssentials.但制作ToxicEssential的成员之一,~n~ICYPhoenix,相较其他制作组成员拥有良好的品德.~n~他/她过去几个月来一直在维护一个没有混淆过代码,并标注代码来源的版本.~n~" .. 
                "我强烈建议您使用Phoenixscript和/或 Lancescript 来代替pnn剽窃来的作品 ~n~毕竟Phoenixscript 本来就是 Toxicessentials.~n~"..
                "我鼓励您不再向别人分享ToxicEssentials,因为ToxicEssentials的代码是剽窃来的,被混淆过的,且质量很差.但您也可以选择忽视这条信息,并继续分享."..
                "您之后不会再看到这则声明,感谢阁下抽出您宝贵的时间阅读此声明."
                show_custom_alert_until_enter(text)
                show_custom_alert_until_enter(text2)
                file = io.open(filesystem.scripts_dir() .. 'disclaimer_viewed.txt', "w")
                file:write("该文件存在于您的 Lua 脚本中,用于告诉 Lancescript 您已查看关于 Toxicessentials 的免责声明. 如果删除它,您将再次看到免责声明.")
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
        util.toast("让耶稣伤心吧!")
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
                util.toast("J耶稣不再在人间显灵了, 正在阻止耶稣的线程.")
                util.stop_thread()
            end
            local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(target)
            if not players.exists(target) then
                util.toast("T玩家已离开, 伤心的耶稣停止了思考.")
                util.stop_thread()
            else
                TASK.TASK_COMBAT_PED(jesus, target_ped, 0, 16)
            end
            util.yield()
        end
    end)
end
menu.toggle(lancescript_root, "显示活动的实体池", {"entitypoolupdates"}, "Toasts what entity pools are being updated every tick. The more you see, the more performance loss; getting all entities is a heavy task.", function(on)
    if on then
        show_updates = true
    else
        show_updates = false
    end
end)

menu.action(lancescript_root, "Toast stat", {"toaststat"}, "Input a stat to toast", function(on_click)
    util.toast("Please type the stat name")
    menu.show_command_box("toaststat ")
end, function(on_command)
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(on_command), outptr, -1)
    util.toast("STAT returned " .. memory.read_int(outptr))
end)


menu.action(lancescript_root, "在YouTube上观看为美好的世界献上祝福!的第一集", {"konosuba"}, "", function(on_click)
    os.execute("start \"\" \"https://www.youtube.com/watch?v=H8CORxz5FKA\"")
end)
--memory.scan(string pattern)

menu.action(lancescript_root, "发送推特以示对LanceScript的支持", {"tweet"}, "", function(on_click)
    os.execute("start \"\" \"https://twitter.com/compose/tweet?text=Lancescript is the best LUA script ever!\"")
end)

--menu.action(lancescript_root, "查看脚本汉化仓库", {"github"}, "", function(on_click)
--    os.execute("start \"\" \"https://github.com/xyfx666/Stand-Script_CN\"")
--end)

joinsound = false
menu.toggle(sounds_root, "玩家加入时的音效", {"joinsound"}, "", function(on)
    if on then
        joinsound = true
    else
        joinsound = false
    end
end)

leavesound = false
menu.toggle(sounds_root, "玩家离开时的音效", {"leavesound"}, "", function(on)
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

--_SET_HYDRAULIC_WHEEL_VALUE(Vehicle vehicle, int wheelId, float value)
function start_vehdance_thread()
    vehdance_thread = util.create_thread(function (thr)
        local state = 2
        while true do
            if not veh_dance then
                util.stop_thread()
            end
            local vehicles = util.get_all_vehicles()
            for k,veh in pairs(vehicles) do
                local vhash = ENTITY.GET_ENTITY_MODEL(veh)
                VEHICLE.SET_VEHICLE_MOD(veh, 38, VEHICLE.GET_NUM_VEHICLE_MODS(veh, 38)-1, false)
                if player_cur_car ~= veh and not is_ped_player(VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1)) then
                    request_control_of_entity(veh)
                    if vhash % 2 == 0 then
                        if state == 2 then
                            ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 1.0, state*2, 0.0, 0.0, 0, false, false, true, false, true)
                        else
                            ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 1.0, state*2, 0.0, 0.0, 0, false, false, true, false, true)
                        end
                    else
                        if state == 2 then
                            ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 1.0, state*2, 0.0, 0.0, 0, false, false, true, false, true)
                        else
                            ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 1.0, state*2, 0.0, 0.0, 0, false, false, true, false, true)
                        end
                    end
                end
            end
            if state == 2 then
                state = -2
            else
                state = 2
            end
            util.yield(500)
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
        util.toast("请求的模型无效, 无法加载.")
        return
    end
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        if os.time() - request_time >= 10 then
            util.toast("模型将在十秒内加载.")
            break
        end
        util.toast("正在加载模组HASH值 " .. hash)
        util.yield()
    end
end

function request_ptfx_load(hash)
    request_time = os.time()
    STREAMING.REQUEST_NAMED_PTFX_ASSET(hash)
    while not STREAMING.HAS_PTFX_ASSET_LOADED(hash) do
        if os.time() - request_time >= 10 then
            util.toast("粒子特效 未能在5秒内加载完成.")
            break
        end
        util.toast("正在加载粒子特效HASH..." .. hash)
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
menu.toggle(weapons_root, "彩虹武器涂装", {"rainbowtint"}, "boogie", function(on)
    plyr = PLAYER.PLAYER_PED_ID()
    if on then
        local last_tint = WEAPON.GET_PED_WEAPON_TINT_INDEX(PLAYER.PLAYER_PED_ID(), WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID()))
        rainbow_tint = true
    else
        rainbow_tint = false
        WEAPON.SET_PED_WEAPON_TINT_INDEX(PLAYER.PLAYER_PED_ID(),WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.PLAYER_PED_ID()), last_tint)
    end
end, false)

menu.toggle(weapons_root, "I隐藏武器", {"invisguns"}, "让你的武器不可见. 或许只对自己可见, 切换武器后需重新开启.", function(on)
    plyr = PLAYER.PLAYER_PED_ID()
    if on then
        WEAPON.SET_PED_CURRENT_WEAPON_VISIBLE(plyr, false, false, false, false) 
    else
        WEAPON.SET_PED_CURRENT_WEAPON_VISIBLE(plyr, true, false, false, false) 
    end
end, false)

aim_info = false
menu.toggle(weapons_root, "目标信息", {"aiminfo"}, "显示你所瞄准的实体信息", function(on)
    if on then
        aim_info = true
    else
        aim_info = false
    end
end, false)

gun_stealer = false
menu.toggle(weapons_root, "汽车偷窃者枪", {"gunstealer"}, "射击一辆车来偷它。如果是一辆有玩家司机的车，它会把你传送到下一个空位.", function(on)
    if on then
        gun_stealer = true
    else
        gun_stealer = false
    end
end, false)

paintball = false
menu.toggle(weapons_root, "彩弹射击", {"paintball"}, "射击一辆车，它会变成随机的颜色!:)", function(on)
    if on then
        paintball = true
    else
        paintball = false
    end
end, false)

noexplosives = false
menu.toggle(protections_root,  "禁止爆炸", {"noexplosives"}, "自动从世界中移除所有爆炸弹药, 包括火箭. 或许只对自己可见. 并不包括所有爆炸, 只包括一些玩家武器. 车载武器可能不受影响. ", function(on)
    plyr = PLAYER.PLAYER_PED_ID()
    if on then
        noexplosives = true
    else
        noexplosives = false
    end
end, false)

noclip = false
noclip_height = 0
menu.toggle(noclip_root, "无碰撞", {"noclip"}, "载具也同样适用.", function(on)
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
menu.click_slider(noclip_root,  "水平速度", {"nocliphspeed"}, "无碰撞的水平速度,, * 0.1", 1, 50, 5, 1, function(s)
    noclip_hspeed = s * 0.1
  end)

noclip_vspeed = 0.1
menu.click_slider(noclip_root,"垂直速度", {"noclipvspeed"}, "无碰撞的垂直速度, * 0.1", 1, 50, 2, 1, function(s)
    noclip_vspeed = s * 0.1
  end)
  
menu.toggle(self_root, "成为警察", {"makemecop"}, "将人物模型的属性设为警察. 几乎所有的警察都看不见你, 但犯下罪行后仍会被通缉. 有警察的声音, 有警察视角显示, 不能攻击其他警察. 特警和军队仍然会向你开火. 如果不想再当警察的话需自杀一次", function(on)
    local ped = PLAYER.PLAYER_PED_ID()
    if on then
        PED.SET_PED_AS_COP(ped, true)
    else
        menu.trigger_commands("suicide")
    end
end)

menu.action(self_root, "生成妓女", {"hooker"}, "用正确的脚本在你的车里生成一个妓女。就像普通的一样.", function(on_click)
    local ped = PLAYER.PLAYER_PED_ID()
    local clown_hash = 71929310
    request_model_load(71929310)
    ENTITY.SET_ENTITY_COORDS(ped, 64.099174, 7220.637, 3.422565, true, false, false, false)
    spawn_pos = ENTITY.GET_ENTITY_COORDS(ped, true)
    for i=1,10 do
        local clown = util.create_ped(1, clown_hash, spawn_pos, 0.0)
        ENTITY.SET_ENTITY_INVINCIBLE(clown, true)
        WEAPON.GIVE_WEAPON_TO_PED(clown, -1810795771, 1000, false, true)
        PED.SET_PED_RELATIONSHIP_GROUP_HASH(clown, npc_group)
        PED.SET_PED_COMBAT_ATTRIBUTES(clown, 5, true)
        PED.SET_PED_COMBAT_ATTRIBUTES(clown, 46, true)
        TASK.TASK_COMBAT_PED(clown, ped, 0, 16)
    end
    util.toast("imagine lmao")
end)

function get_waypoint_coords()
    return HUD.GET_BLIP_COORDS(HUD.GET_FIRST_BLIP_INFO_ID(8))
end

function max_out_car(veh)
    for i=0, 49 do
        num = VEHICLE.GET_NUM_VEHICLE_MODS(veh, i)
        VEHICLE.SET_VEHICLE_MOD(veh, i, num -1, true)
    end
end

taxi_ped = 0
taxi_veh = 0
taxi_blip = -1
function create_chauffeur(vhash, phash)
    if taxi_veh ~= 0 then
        taxi_veh = 0
        util.delete_entity(taxi_veh)
    end
    if taxi_ped ~= 0 then
        taxi_ped = 0
        HUD.REMOVE_BLIP(taxi_blip)
        util.delete_entity(taxi_ped)
    end
    local plyr = PLAYER.PLAYER_PED_ID()
    local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(plyr, 0.0, 5.0, 0.0)
    coords.x = coords['x']
    coords.y = coords['y']
    coords.z = coords['z']
    request_model_load(vhash)
    request_model_load(phash)
    taxi_veh = util.create_vehicle(vhash, coords, ENTITY.GET_ENTITY_HEADING(plyr))
    max_out_car(taxi_veh)
    VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(taxi_veh, "LANCE")
    VEHICLE.SET_VEHICLE_COLOURS(taxi_veh, 145, 145)
    VEHICLE.SET_VEHICLE_INDIVIDUAL_DOORS_LOCKED(taxi_veh, 0, 2)
    ENTITY.SET_ENTITY_INVINCIBLE(taxi_veh, true)
    --VEHICLE.MODIFY_VEHICLE_TOP_SPEED(taxi_veh, 300.0)
    taxi_ped = util.create_ped(32, phash, coords, ENTITY.GET_ENTITY_HEADING(plyr))
    taxi_blip = HUD.ADD_BLIP_FOR_ENTITY(taxi_ped)
    HUD.SET_BLIP_COLOUR(taxi_blip, 7)
    ENTITY.SET_ENTITY_INVINCIBLE(taxi_ped, true)
    PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(taxi_ped, true)
    PED.SET_PED_FLEE_ATTRIBUTES(taxi_ped, 0, false)
    PED.SET_PED_CAN_BE_DRAGGED_OUT(taxi_ped, false)
    PED.SET_PED_INTO_VEHICLE(taxi_ped, taxi_veh, -1)
    util.toast("您的司机已经创建,请尽情享受")
end

menu.action(transport_root, "司机:在骷髅马中创造", {"chkuruma"}, "Spawns chauffeur in a kuruma", function(on_click)
    create_chauffeur(410882957, 988062523)
end)

menu.action(transport_root, "司机:在T20中创造", {"cht20"}, "Spawns chauffeur in a kuruma", function(on_click)
    create_chauffeur(1663218586, 988062523)
end)

menu.action(transport_root, "司机:在叛乱者中创造", {"chinsurgent"}, "Spawns chauffeur in a kuruma", function(on_click)
    create_chauffeur(-1860900134, 988062523)
end)

menu.action(transport_root, "司机“在Hakuchou中创造", {"chhakuchou"}, "Spawns chauffeur in hakuchou", function(on_click)
    create_chauffeur(1265391242, 988062523)
end)
--1265391242


menu.action(transport_root, "司机:自动开车到导航点", {"chwaypoint"}, "Commands your chauffeur to go to the waypoint. HE WILL GET THERE, WHATEVER IT TAKES. This includes going the wrong way, hitting peds, etc.", function(on_click)
    if taxi_ped == 0 then
        util.toast("在这样做之前，先创造一个司机.")
        return
    end
    local goto_coords = get_waypoint_coords()
    TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(taxi_ped, taxi_veh, goto_coords['x'], goto_coords['y'], goto_coords['z'], 300.0, 786996, 5)
end)

menu.action(transport_root, "司机:传送到司机车里", {"chtp2car"}, "Teleports you into the chauffeur\'s car", function(on_click)
    if taxi_ped == 0 then
        util.toast("在这样做之前，先创造一个司机.")
        return
    end
    local plyr = PLAYER.PLAYER_PED_ID()
    PED.SET_PED_INTO_VEHICLE(plyr, taxi_veh, 0)
end)

menu.action(transport_root, "司机:开到我这儿来", {"chtp2me"}, "Drives the chauffeur\'s car to you", function(on_click)
    if taxi_veh == 0 then
        util.toast("在这样做之前，先创造一个司机.")
        return
    end
    local plyr = PLAYER.PLAYER_PED_ID()
    goto_coords = ENTITY.GET_ENTITY_COORDS(plyr, true)
    TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(taxi_ped, taxi_veh, goto_coords['x'], goto_coords['y'], goto_coords['z'], 300.0, 786996, 5)
    util.toast("他们已经在路上了.")
end)

menu.action(transport_root, "司机：修理汽车", {"chfix"}, "Fixes/flips the car", function(on_click)
    if taxi_veh == 0 then
        util.toast("在这样做之前，先创造一个司机.")
        return
    end
    OBJECT.PLACE_OBJECT_ON_GROUND_PROPERLY(taxi_veh)
end)

--PLACE_OBJECT_ON_GROUND_PROPERLY(Object object)

menu.toggle(transport_root, "司机:关闭车门", {"chlock"}, "Locks the doors of chauffeur\'s car", function(on)
    if taxi_veh ~= 0 then
        if on then
            VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(taxi_veh, true)
        else
            VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(taxi_veh, false)
        end
    end
end)

menu.toggle(transport_root, "司机：打开车门", {"chopen"}, "Opens/closes the doors of chauffeur\'s car", function(on)
    if taxi_veh ~= 0 then
        for i=0, 7 do
            if on then
                VEHICLE.SET_VEHICLE_DOOR_OPEN(taxi_veh, i, false, false)
            else
                VEHICLE.SET_VEHICLE_DOOR_SHUT(taxi_veh, i, false)
            end
        end
    end
end)

menu.action(transport_root, "司机：停止", {"chstop"}, "Tells the chauffeur to park the car and stop. You will need to tell them where to go again.", function(on_click)
    if taxi_veh ~= 0 then
        TASK.TASK_VEHICLE_TEMP_ACTION(taxi_ped, taxi_veh, 1, -1)
    end
end)

menu.action(transport_root, "司机：删除", {"chdelete"}, "Deletes the chauffeur and his car", function(on_click)
    if taxi_veh ~= 0 then
        util.delete_entity(taxi_veh)
        taxi_veh = 0
    end
    if taxi_ped ~= 0 then
        util.delete_entity(taxi_ped)
        taxi_ped = 0
    end
    HUD.REMOVE_BLIP(taxi_blip)
    taxi_blip = -1
end)

menu.action(transport_root, "司机:自我销毁", {"chdestruct"}, "do i need to explain?", function(on_click)
    if taxi_veh ~= 0 then
        ENTITY.SET_ENTITY_INVINCIBLE(taxi_veh, false)
        ENTITY.SET_ENTITY_INVINCIBLE(taxi_ped, false)
        VEHICLE.EXPLODE_VEHICLE(taxi_veh, true, false)
        taxi_veh = 0
        taxi_ped = 0
        HUD.REMOVE_BLIP(taxi_blip)
        taxi_blip = -1
    end
end)


hud_rainbow = false
menu.toggle(gametweaks_root, "RGB hud", {"rgbhud"}, "让你的游戏UI变得RGB起来,可以提升100%的电脑性能,需重启游戏才能恢复原样.", function(on)
    if on then
        hud_rainbow = true
    else
        hud_rainbow = false
    end
end)

lodscale = 1
menu.click_slider(gametweaks_root, "细节层次系数", {"lodscale"}, "简单来说就是覆盖扩展距离缩放系数, 使远处的模型'看起来更清晰'. 控制不当会让你的游戏像狗屎一样运行 .", 1, 200, 1, 1, function(s)
    lodscale = s
  end)

menu.action(labelpresets_root, "加入GTA Online与Lancescript", {""}, "Usually says: \"Joining GTA online\"", function(on_click)
    do_label_preset("HUD_JOINING", "Joining GTA Online with Lancescript")
end)

menu.action(labelpresets_root, "加载时间太长……", {""}, "Usually says: \"Loading\"", function(on_click)
    do_label_preset("MP_SPINLOADING", "Taking forever to load...")
end)

menu.action(labelpresets_root, "艾滋病在线", {""}, "Usually says: \"GTA online\"", function(on_click)
    do_label_preset("HUD_LBD_FMF", "AIDS Online (Invite, ~1~)")
    do_label_preset("HUD_LBD_FMP", "AIDS Online (Public, ~1~)")
    do_label_preset("HUD_LBD_FMS", "AIDS Online (Solo, ~1~)")
    do_label_preset("HUD_LBD_FMF", "AIDS Online (Friend, ~1~)")
    do_label_preset("PM_SCR_MIS", "AIDS Online")
    do_label_preset("PCARD_ONLINE_OTHER", "AIDS Online")
    do_label_preset("ONLINE_BUILD", "AIDS Online")
    do_label_preset("LOADING_MPLAYER", "AIDS Online")
end)

menu.action(labelpresets_root, "Player fucking died", {""}, "Usually says: \"-playername- died.\"", function(on_click)
    do_label_preset("TICK_DIED", "~a~~HUD_COLOUR_WHITE~ fucking died.")
end)

menu.action(labelpresets_root, "Player dipped", {""}, "Usually says: \"-playername- left.\"", function(on_click)
    do_label_preset("TICK_LEFT", "~a~~HUD_COLOUR_WHITE~ dipped.")
end)

menu.action(labelpresets_root, "you got caught kiddo", {""}, "Usually says: \"You have been banned from Grand Theft Auto Online.\" Hopefully you never see this one.", function(on_click)
    do_label_preset("HUD_ROSBANNED", "you got caught kiddo")
    do_label_preset("HUD_ROSBANPERM", "you got caught kiddo")
end)

menu.toggle(radio_root, "只有音乐的电台", {"musiconly"}, "强制电台只播放音乐. 没有废话.", function(on)
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

menu.action(radio_root, "下一首歌", {"radioskip"}, "跳过当前播放曲目", function(on_click)
    AUDIO.SKIP_RADIO_FORWARD()
end)

--SKIP_RADIO_FORWARD()

ban_msg = "HUD_ROSBANPERM"
--_SET_WARNING_MESSAGE_WITH_ALERT(char* labelTitle, char* labelMsg, int p2, int p3, char* labelMsg2, BOOL p5, int p6, int p7, char* p8, char* p9, BOOL background, int errorCode)

menu.action(fakemessages_root, "虚假的封号消息 1", {"fakeban"}, "显示了一条完全虚假的禁令信息 .也许可以用它从作弊开发者那里获得免费帐户 ,或者在r/GTA5Moding上引起恐慌 .", function(on_click)
    show_custom_alert_until_enter("你已被永久禁止进入GTA线上模式。~n~返回 Grand Theft Auto V。")
end)

menu.action(fakemessages_root, "虚假的封号消息 2", {"fakeban"}, "显示了一条完全虚假的禁令信息 .也许可以用它从作弊开发者那里获得免费帐户 ,或者在r/GTA5Moding上引起恐慌 .", function(on_click)
    show_custom_alert_until_enter("你已被永久禁止进入GTA线上模式。~n~返回 Grand Theft Auto V。")
end)
--0x252F03F2

menu.action(fakemessages_root, "服务不可用", {"fakeservicedown"}, "Rockstar 游戏服务现在不可用.", function(on_click)
    show_custom_alert_until_enter("Rockstar 游戏服务现在不可用。~n~返回 Grand Theft Auto V。")
end)

menu.action(fakemessages_root, "封号到 xyz", {"suspendeduntil"}, "暂停至 xyz .它会要求您输入要显示的日期 ,不要担心 .", function(on_click)
    util.toast("Input the date your \"suspension\" should end.")
    menu.show_command_box("suspendeduntil ")
end, function(on_command)
    -- fuck it lol
    show_custom_alert_until_enter("你已被禁止进入GTA线上模式，直到 " .. on_command .. ".~n~另外,您GTA线上模式的角色会将被重置.~n~返回 Grand Theft Auto V。")
end)

menu.action(fakemessages_root, "Stand on TOP! (Stand 是最好的!)", {"stand on top"}, "yep", function(on_click)
    show_custom_alert_until_enter("Stand on TOP!")
end)

menu.action(fakemessages_root, "拉玛嘴臭富兰克林", {"yeeyee"}, "maybe", function(on_click)
    show_custom_alert_until_enter("如果你能换掉那个 ~r~土老帽的发型~w~ 可能会有一些婊子愿意让你操")
end)

menu.action(fakemessages_root, "欢迎加入The Black Parade", {"blackparade"}, "", function(on_click)
    local blkprdlrc1 = "当我还是个小孩的时候，我的父亲~n~" ..
    "领着我进城，去观赏游行乐队。~n~" ..
    "他问道：\"儿子，你长大后是否会成为~n~" ..
    "失败之人，落魄之人和诅咒之人的救世主？\"~n~" ..
    "父亲又问，\"你会打败那些恶魔和不信任你的人吗, ~n~" ..
    "会挫败他们所创造的阴谋和诡计吗? ~n~" ..
    "因为有那么一天，爸爸会化作幽灵，化作幻象~n~" ..
    "在夏天带领你参加The Black Parade...\""
    local blkprdlrc2 = "当我还是个小孩的时候，我的父亲~n~" ..
    "领着我进城，去观赏游行乐队。~n~" ..
    "他问道：\"儿子，你长大后是否会成为~n~" ..
    "失败之人，落魄之人和诅咒之人的救世主？\""
    show_custom_alert_until_enter(blkprdlrc1)
    show_custom_alert_until_enter(blkprdlrc2)
end)


menu.action(fakemessages_root, "Reddit (国外论坛)", {"henlo"}, "他们会说 \"嗯,你应该买2Take1的.\"", function(on_click)
    show_custom_alert_until_enter("Hello r/GTA5Modding!")
end)

menu.action(fakemessages_root, "Ozark的骗局", {"exitscam"}, "you know the vibes", function(on_click)
    show_custom_alert_until_enter("亲爱的Ozark用户,请完整阅读此消息.~n~"..

    "我怀着沉重的心情写这封信.~n~"..
    
    "今天我通过我所在国家的一家律师事务所收到 TakeTwo Interactive 的来信.~n~"..
    
    "Ozark已关闭并停止所有服务,立即生效."
)
end)

menu.action(fakemessages_root, "自定义警告", {"customalert"}, "显示您喜欢的自定义提醒, 感谢QuickNUT和Sainan提供的帮助. ", function(on_click)
    util.toast("请输入您想要在警告下方显示的文字, 使用~n~转行")
    menu.show_command_box("customalert ")
end, function(on_command)
    show_custom_alert_until_enter(on_command)
end)

make_peds_cops = false
menu.toggle(npc_root, "全民保安", {"makecops"}, "此选项不会将NPC的属性设为警察. 他们的行为更会像保安, 发生犯罪事件会第一时间逃跑并报告警察.", function(on)
    if on then
        make_peds_cops = true
        ped_uses = ped_uses + 1
    else
        make_peds_cops = false
        ped_uses = ped_uses - 1
    end
end, false)
--SET_RIOT_MODE_ENABLED(BOOL toggle)
menu.toggle(npc_root,"全民保安", {"makecops"}, "此选项不会将NPC的属性设为警察. 他们的行为更会像保安, 发生犯罪事件会第一时间逃跑并报告警察.", function(on)
    if on then
        MISC.SET_RIOT_MODE_ENABLED(true)
    else
        MISC.SET_RIOT_MODE_ENABLED(false)
    end
end, false)

menu.action(npc_root, "全民音乐家", {}, "人人都是音乐家, 人人都听Wonderwall. ", function(on_click)
    local peds = util.get_all_peds()
    for k,ped in pairs(peds) do
        if not is_ped_player(ped) then
            TASK.TASK_LEAVE_ANY_VEHICLE(ped, 0, 16)
            TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_MUSICIAN", 0, true)
        end
    end
end)

roast_voicelines = false
menu.toggle(npc_root, "全民嘴臭", {"npcroasts"}, "素质低下", function(on)
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
menu.toggle(npc_root, "全民高潮", {"sexlines"}, "哦, 我操你妈的, 这真是爽翻了", function(on)
    if on then
        ped_uses = ped_uses + 1
        sex_voicelines = true
    else
        ped_uses = ped_uses -1
        sex_voicelines = false
    end
end, false)

gluck_voicelines = false
menu.toggle(npc_root, "全民口交", {"gluckgluck9000"}, "爱听这个的去飞点叶子吧, 没救了", function(on)
    if on then
        ped_uses = ped_uses + 1
        gluck_voicelines = true
    else
        ped_uses = ped_uses -1
        gluck_voicelines = false
    end
end, false)

screamall = false
menu.toggle(npc_root, "全民尖叫", {"screamall"}, "让附近所有的行人惨叫. 这真是太让人兴奋了", function(on)
    if on then
        ped_uses = ped_uses + 1
        screamall = true
    else
        ped_uses = ped_uses -1
        screamall = false
    end
end, false)

play_ped_ringtones = false
menu.toggle(npc_root, "骚扰电话", {"ringtones"}, "给附近所有行人打电话, 包括自己.", function(on)
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

--start_healthbar_thread()

menu.action(entity_root, "乘坐距离最近的载具", {"closestvehicle"}, "传送到最近的载具(不包括已经乘上的载具). 如果最近的载具有驾驶员, 它会把你安排到下一个空位(如果有的话). 记住, 根据LOD机制, 附近的载具可能\"不在附近\".", function(on_click)
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
    localdriver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(closestveh, -1)
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
            util.toast("未能找到还有空位的载具 :(")
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

inferno = false
menu.toggle(entity_root, "Inferno", {"inferno"}, "An overdramatic \"blow up all cars\" option. Will continue to blow up all cars even when they\'re dead, just so you get that classic modder feel.", function(on)
    if on then
        inferno = true
        vehicle_uses = vehicle_uses + 1
    else
        inferno = false
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

beep_cars = false
menu.toggle(entity_root, "Infinite horn on all nearby vehicles", {"beepvehicles"}, "Makes all nearby vehicles beep infinitely. May not be networked.", function(on)
    if on then
        beep_cars = true
        vehicle_uses = vehicle_uses + 1
    else
        beep_cars = false
        vehicle_uses = vehicle_uses - 1
    end
end, false)

veh_dance = false
menu.toggle(entity_root, "Earthquake mode/vehicle dance", {"vehicledance"}, "Makes all vehicles dance. Or earthquake. Whichever it looks like to you. ChairX.", function(on)
    if on then
        veh_dance = true
        start_vehdance_thread()
    else
        veh_dance = false
    end
end, false)

clear_radius = 100
function clear_area(radius)
    target_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
    MISC.CLEAR_AREA(target_pos['x'], target_pos['y'], target_pos['z'], radius, true, false, false, false)
end

function get_closest_train()
    local vehicles = util.get_all_vehicles()
    for k, veh in pairs(vehicles) do
        if ENTITY.GET_ENTITY_MODEL(veh) == 1030400667 then
            request_control_of_entity(veh)
            return veh
        end
    end
    util.toast("Could not find the closest train.")
    return 0
end

menu.action(train_root, "Hijack closest train", {"hijacktrain"}, "", function(on_click)
    local train = get_closest_train()
    if train ~= 0 then
        util.delete_entity(VEHICLE.GET_PED_IN_VEHICLE_SEAT(train, -1))
        PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), train, -1)
        AUDIO.SET_VEHICLE_RADIO_ENABLED(train, true)
        util.toast("Success! Leave the train by using vehicle > force leave vehicle.")
    end
end)

menu.click_slider(train_root, "Closest train speed", {"trainspeed"}, "Setting it too high may make your game nope out of here", -1000, 1000, 20, 1, function(s)
    local train = get_closest_train()
    VEHICLE.SET_TRAIN_SPEED(train, s)
    VEHICLE.SET_TRAIN_CRUISE_SPEED(train, s)
end)


menu.action(world_root, "清除区域", {"cleararea"}, "清除附近的一切", function(on_click)
    clear_area(clear_radius)
    util.toast('Area cleared :)')
end)

-- SET_PED_SHOOTS_AT_COORD(Ped ped, float x, float y, float z, BOOL toggle)

menu.action(world_root, "清除一切", {"clearworfld"}, "细致的地清除世界上可以清除的所有东西（好吧,在中渲染的所有东西）.不要告诉他们,但事实上这只是一个巨大的数字.", function(on_click)
    clear_area(1000000)
    util.toast('World cleared :)')
end)

cont_clear = false
menu.toggle(world_root, "持续清除区域", {"contareaclear"}, "区域清晰,但呈环形", function(on)
    if on then
        cont_clear = true
    else
        cont_clear = false
    end
end, false)

rapidtraffic = false
menu.toggle(world_root, "混乱的交通灯", {"beep boop"}, "到了派对时间了!!!!!!可能是本地的,也不会影响交通行为", function(on)
    if on then
        rapidtraffic = true
        object_uses = object_uses + 1
    else
        rapidtraffic = false
        object_uses = object_uses - 1
    end
end, false)

object_rainbow = false
menu.toggle(world_root, "世界彩虹灯", {"rainbowlights"}, "可以尝试自己的CPU有多好.", function(on)
    if on then
        object_rainbow = true
        object_uses = object_uses + 1
    else
        object_rainbow = false
        object_uses = object_uses - 1
    end
end)


menu.click_slider(world_root, "清除的半径", {"clearradius"}, "清除内部事物的半径", 100, 10000, 100, 100, function(s)
    radius = s
  end)

menu.click_slider(world_root, "世界的重力水平", {"worldgravity"}, "世界重力水平（0为正常值,数值越大=重力越小）", 0, 3, 1, 1, function(s)
  MISC.SET_GRAVITY_LEVEL(s)
end)

firework_spam = false
menu.toggle(world_root, "视角晃动", {"fireworkspam"}, "夜空中的飞机就像流星", function(on)
    if on then
        firework_spam = true
    else
        firework_spam = false
    end
end, false)
--FORCE_LIGHTNING_FLASH()
lightning_spam = false
menu.toggle(world_root, "电闪雷鸣", {"lightningspam"}, "憎恨癫痫的宙斯.不确定它是否联网,可能不会.", function(on)
    if on then
        lightning_spam = true
    else
        lightning_spam = false
    end
end, false)


effects_root = menu.list(world_root, "视觉效果", {"lancescriptfx"}, "")

menu.toggle(effects_root, "DMT", {"dmt"}, "", function(on)
    if on then
        GRAPHICS.ANIMPOSTFX_PLAY("DMT_flight", 0, true)
    else
        GRAPHICS.ANIMPOSTFX_STOP("DMT_flight")
    end
end, false)

menu.toggle(effects_root, "小丑", {"clowns"}, "", function(on)
    if on then
        GRAPHICS.ANIMPOSTFX_PLAY("DrugsTrevorClownsFight", 0, true)
    else
        GRAPHICS.ANIMPOSTFX_STOP("DrugsTrevorClownsFight")
    end
end, false)

menu.toggle(effects_root, "狗", {"dogvision"}, "", function(on)
    if on then
        GRAPHICS.ANIMPOSTFX_PLAY("ChopVision", 0, true)
    else
        GRAPHICS.ANIMPOSTFX_STOP("ChopVision")
    end
end, false)

menu.toggle(effects_root, "模糊的", {"rampage"}, "", function(on)
    if on then
        GRAPHICS.ANIMPOSTFX_PLAY("Rampage", 0, true)
    else
        GRAPHICS.ANIMPOSTFX_STOP("Rampage")
    end
end, false)

menu.action(effects_root, "输入自定义视觉特效", {"effectinput"}, "输入要播放的自定义视觉特效.", function(on_click)
    util.toast("Please type the effect name")
    menu.show_command_box("effectinput ")
end, function(on_command)
    GRAPHICS.ANIMPOSTFX_PLAY(on_command, 0, true)
end)

menu.action(effects_root, "停止所有视觉特效", {"stopfx"}, "仅用于紧急情况,停止自定义输入效果,或停止定期触发的效果.如果可以,请先尝试在此处不改变效果.", function(on_click)
    GRAPHICS.ANIMPOSTFX_STOP_ALL()
end)

ascend_vehicles = false
menu.toggle(entity_root, "附近所有车辆飞天", {"ascendvehicles"}, "这应该能让他们飘浮起来.但它只是让它们在半空中旋转.这糟糕的代码了.", function(on)
    if on then
        ascend_vehicles = true
        vehicle_uses = vehicle_uses + 1
    else
        ascend_vehicles = false
        vehicle_uses = vehicle_uses - 1
    end
end)

no_radio = false
menu.toggle(entity_root, "关闭所有车辆的无线电", {"noradio"}, "serenity.", function(on)
    if on then
        no_radio = true
        vehicle_uses = vehicle_uses + 1
    else
        no_radio = false
        vehicle_uses = vehicle_uses - 1
    end
end)

loud_radio = false
menu.toggle(entity_root, "所有的车都开大声的收音机", {"loudradio"}, "我听不见你说话在这些废话当中.", function(on)
    if on then
        loud_radio = true
        vehicle_uses = vehicle_uses + 1
    else
        loud_radio = false
        vehicle_uses = vehicle_uses - 1
    end
end)


halt_traffic = false
menu.toggle(entity_root, "停止交通", {"halttraffic"}, "阻止附近所有车辆移动.连一英寸都没有.所以要小心使用.", function(on)
    if on then
        halt_traffic = true
        vehicle_uses = vehicle_uses + 1
    else
        halt_traffic = false
        vehicle_uses = vehicle_uses - 1
    end
end)

reverse_traffic = false
menu.toggle(entity_root, "反向交通", {"reversetraffic"}, "交通,但翻转它", function(on)
    if on then
        reverse_traffic = true
        vehicle_uses = vehicle_uses + 1
    else
        reverse_traffic = false
        vehicle_uses = vehicle_uses - 1
    end
end)


vehicle_chaos = false
menu.toggle(entity_root, "混乱的车辆", {"chaos"}, "开启即混乱混乱...", function(on)
    if on then
        vehicle_chaos = true
        vehicle_uses = vehicle_uses + 1
    else
        vehicle_chaos = false
        vehicle_uses = vehicle_uses - 1
    end
end, false)

vc_gravity = true
menu.toggle(entity_root, "车辆混沌引力", {"chaosgravity"}, "重力 开/关", function(on)
    if on then
        vc_gravity = true
    else
        vc_gravity = false
    end
end, true)

vc_speed = 100
menu.click_slider(entity_root, "车辆混沌速度", {"chaosspeed"}, "迫使车辆行驶的速度.越高=越混乱.", 30, 300, 100, 10, function(s)
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

aircraft_root = menu.list(vehicle_root, "飞机", {"lanceaircraft"}, "")

menu.action(vehicle_root, "强制离开载具", {"forceleave"}, "Force leave vehicle, in case of emergency or stuckedness", function(on_click)
    TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
    TASK.TASK_LEAVE_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), 0, 16)
end)

menu.action(aircraft_root, "破环船", {"breakrudder"}, "Breaks rudder. Good for stunts.", function(on_click)
    if player_cur_car then
        VEHICLE.SET_VEHICLE_RUDDER_BROKEN(player_cur_car, true)
    end
end)
--SET_PLANE_TURBULENCE_MULTIPLIER(Vehicle vehicle, float multiplier)
instantspinup = false
menu.toggle(aircraft_root, "瞬时螺旋桨加速", {"instantspinup"}, "螺旋桨立即旋转起来,无需等待.", function(on)
    if not player_cur_car then
        return
    end
    if on then
        instantspinup = true
    else
        instantspinup = false
    end
end, false)

menu.click_slider(aircraft_root, "湍流", {"turbulence"}, "设置湍流.0=无湍流,1=默认湍流,2=严重湍流", 0, 2, 1, 1, function(s)
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

tesla_ped = 0
menu.action(vehicle_root, "特斯拉召唤", {"teslasummon"}, "使自己的车开来自己身边.", function(on_click)
    lastcar = PLAYER.GET_PLAYERS_LAST_VEHICLE()
    if lastcar ~= player_cur_car then
        if lastcar == 0 then
            util.toast("没有找到你开过的最后一辆车")
            return
        end
        local plyr = PLAYER.PLAYER_PED_ID()
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(plyr, 0.0, 5.0, 0.0)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
        local phash = -67533719
        request_model_load(phash)
        tesla_ped = util.create_ped(32, phash, coords, ENTITY.GET_ENTITY_HEADING(plyr))
        tesla_blip = HUD.ADD_BLIP_FOR_ENTITY(tesla_ped)
        HUD.SET_BLIP_COLOUR(tesla_blip, 7)
        ENTITY.SET_ENTITY_VISIBLE(tesla_ped, false, 0)
        ENTITY.SET_ENTITY_INVINCIBLE(tesla_ped, true)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(tesla_ped, true)
        PED.SET_PED_FLEE_ATTRIBUTES(tesla_ped, 0, false)
        VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(lastcar, true)
        PED.SET_PED_INTO_VEHICLE(tesla_ped, lastcar, -1)
        TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(tesla_ped, lastcar, coords['x'], coords['y'], coords['z'], 300.0, 786996, 5)
    end
end)

menu.toggle(vehicle_root, "隐形载具", {"everythingproof"}, "使你的载具隐形.但不是无敌的.不过玻璃似乎是防弹的.", function(on)
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

menu.action(vehicle_root,  "180度掉头", {"vehicle180"}, "在保持动力的情况下转弯.建议使用快捷键绑定此功能.", function(on_click)
    if player_cur_car then
        util.toast(VEHICLE._GET_HYDRAULIC_WHEEL_VALUE(player_cur_car, 0))
        local rot = ENTITY.GET_ENTITY_ROTATION(player_cur_car, 0)
        local vel = ENTITY.GET_ENTITY_VELOCITY(player_cur_car)
        ENTITY.SET_ENTITY_ROTATION(player_cur_car, rot['x'], rot['y'], rot['z']+180, 0, true)
        ENTITY.SET_ENTITY_VELOCITY(player_cur_car, -vel['x'], -vel['y'], vel['z'])
    end
end)

racemode = false
menu.toggle(vehicle_root, "赛车模式", {"racemode"}, "告诉游戏汽车处于\"比赛模式\".不知道它到底是干什么的,哈哈.", function(on)
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
menu.toggle(vehicle_root, "贴地行驶", {"stick2ground"}, "使你的车保持在地面上.", function(on)
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
menu.toggle(vehicle_root, "车牌速度表", {"speedplate"}, "不像Ozark,它有这个功能,我不退出骗局! 当你禁用时,会将你的车牌重置为原来的样子,也有KPH和MPH设置,所以这已经是比较好的了.", function(on)
    if on then
        if player_cur_car then
            original_plate = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(player_cur_car)
        else
           util.toast("启动时您不在车内.您将无法还原车牌号.")
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
menu.toggle(vehicle_root, "使用英里的速度表板", {"usemph"}, "如果你不是美国人,请关掉.", function(on)
    if on then
        mph_unit = "mph"
    else
        mph_unit = "kph"
    end
end, false)

everythingproof = false
menu.toggle(vehicle_root, "防弹模式", {"everythingproof"}, "使你的车辆万无一失.但不是无敌的.不过玻璃似乎是防弹的.", function(on)
    if on then
        everythingproof = true
    else
        everythingproof = false
    end
end)

menu.click_slider(vehicle_root,"载具最高速度", {"topspeed"}, "设定载具的最高速度（这在其他地方被称为发动机功率倍增器）)", 1, 2000, 200, 50, function(s)
    VEHICLE.MODIFY_VEHICLE_TOP_SPEED(player_cur_car, s)
end)

shift_drift = false
menu.toggle(vehicle_root, "按住Shift键漂移", {"shiftdrift"}, "You heard me.", function(on)
    if on then
        shift_drift = true
    else
        shift_drift = false
    end
end)


infcms = false
menu.toggle(vehicle_root, "无限反追踪导弹烟雾", {"infinitecms"}, "让追踪导弹不会炸到载具上", function(on)
    if on then
        infcms = true
    else
        infcms = false
    end
end)

menu.click_slider(vehicle_root, "载具肮脏程度", {"dirtlevel"}, "数值越高,你的载具就越脏.", 0, 15.0, 0, 1, function(s)
    if player_cur_car then
        VEHICLE.SET_VEHICLE_DIRT_LEVEL(player_cur_car, s)
    end
end)

menu.click_slider(vehicle_root, "载具灯光亮度", {"lightmultiplier"}, "设定车内灯光的亮度.仅限本地.", 0, 1000000, 1, 1, function(s)
    if player_cur_car then
        VEHICLE.SET_VEHICLE_LIGHT_MULTIPLIER(player_cur_car, s)
    end
end)

horn_boost = false
menu.toggle(vehicle_root, "Horn boost", {"hornboost"}, "beeeeeeeeeeeeeeeeeeeeeeeeeep", function(on)
    if on then
        horn_boost = true
    else
        horn_boost = false
    end
end)

swiss_cheese_dmg = 0
hit_times = 1
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
    menu.action(ls_proot, "Chauffeur: Drive to player", {"chtoplayer"}, "Commands your chauffeur to go to the player. HE WILL GET THERE, WHATEVER IT TAKES. This includes going the wrong way, hitting peds, etc.", function(on_click)
        if taxi_ped == 0 then
            util.toast("Create a chauffeur before doing this.")
            return
        end
        local target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        --local goto_coords = ENTITY.GET_ENTITY_COORDS()
        TASK.TASK_VEHICLE_CHASE(taxi_ped, target)
        --TASK.TASK_VEHICLE_DRIVE_TO_COORD_LONGRANGE(taxi_ped, taxi_veh, goto_coords['x'], goto_coords['y'], goto_coords['z'], 300.0, 786996, 5)
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

    menu.action(ram_root, "Phantom wedge", {"ramwedge"}, "they fly", function(on_click)
        ram_ped_with(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), -1649536104, 15.0, false)
    end)

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

    menu.toggle(attach_root, "Attach current car to player car", {"attachcurrenttocar"}, "Only works if they have a car/last car", function(on)
        local lastveh = PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
        if on and player_cur_car and lastveh ~= 0 then
            ENTITY.ATTACH_ENTITY_TO_ENTITY(player_cur_car, lastveh, 0, 0.0, -5.00, 0.00, 1.0, 1.0,1, true, true, true, false, 0, true)
        else
            ENTITY.DETACH_ENTITY(player_cur_car, false, false)
        end
    end, false)

    menu.toggle(attach_root, "Attach current car to player", {"attachcurrenttocar"}, "Only works if they have a car/last car", function(on)
        local tar = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        if on and player_cur_car and lastveh ~= 0 then
            ENTITY.ATTACH_ENTITY_TO_ENTITY(player_cur_car, tar, 0, 0.0, -2.00, 0.00, 1.0, 1.0,1, true, true, true, false, 0, true)
        else
            ENTITY.DETACH_ENTITY(player_cur_car, false, false)
        end
    end, false)

    menu.action(attach_root, "Attach all nearby entities to player", {"attachallnearby"}, "be careful...", function(on_click)
        local tar = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        objects = util.get_all_objects()
        vehicles = util.get_all_vehicles()
        peds = util.get_all_peds()
        for i, ent in pairs(peds) do
            if not is_ped_player(ped) then
                ENTITY.ATTACH_ENTITY_TO_ENTITY(ent, tar, 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
            end
        end
        for i, ent in pairs(vehicles) do
            if not is_ped_player(VEHICLE.GET_PED_IN_VEHICLE_SEAT(ent, -1)) then
                ENTITY.ATTACH_ENTITY_TO_ENTITY(ent, tar, 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
            end
        end
        for i, ent in pairs(objects) do
            ENTITY.ATTACH_ENTITY_TO_ENTITY(ent, tar, 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
        end
    end)


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
            request_control_of_entity(last_veh)
            VEHICLE.ATTACH_VEHICLE_TO_TOW_TRUCK(towtruck, last_veh, false, 0, 0, 0)
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
            request_control_of_entity(last_veh)
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
                request_control_of_entity(ped)
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
                                            request_control_of_entity(ped)
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

    menu.action(npctrolls_root, "Clown attack", {"clownattack"}, "Sends clowns to attack the player", function(on_click)
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local clown_hash = 71929310
        request_model_load(clown_hash)
        local van_hash = util.joaat("speedo2")
        request_model_load(van_hash)
        local coords = ENTITY.GET_ENTITY_COORDS(player_ped, true)
        local spawn_pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player_ped, 0.0, -10.0, 0.0)
        spawn_pos.x = spawn_pos['x']
        spawn_pos.y = spawn_pos['y']
        spawn_pos.z = spawn_pos['z']
        local van = util.create_vehicle(van_hash, spawn_pos, ENTITY.GET_ENTITY_HEADING(player_ped))
        ENTITY.SET_ENTITY_INVINCIBLE(van, true)
        for i=-1, VEHICLE.GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(van) - 1 do
            local clown = util.create_ped(1, clown_hash, spawn_pos, 0.0)
            ENTITY.SET_ENTITY_INVINCIBLE(clown, true)
            PED.SET_PED_INTO_VEHICLE(clown, van, i)
            if i % 2 == 0 then
                WEAPON.GIVE_WEAPON_TO_PED(clown, -1810795771, 1000, false, true)
            else
                WEAPON.GIVE_WEAPON_TO_PED(clown, 584646201, 1000, false, true)
            end
            PED.SET_PED_RELATIONSHIP_GROUP_HASH(clown, npc_group)
            PED.SET_PED_COMBAT_ATTRIBUTES(clown, 5, true)
            PED.SET_PED_COMBAT_ATTRIBUTES(clown, 46, true)
            if i == -1 then
                TASK.TASK_VEHICLE_CHASE(clown, player_ped)
            else
                TASK.TASK_COMBAT_PED(clown, player_ped, 0, 16)
            end
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

bm_meth = false
menu.toggle(business_root, "Meth", {"bm_meth"}, "", function(on)
    if on then
        bm_meth = true
        bus_ticks = bus_ticks + 1
    else
        bm_meth = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_weed = false
menu.toggle(business_root, "Weed", {"bm_weed"}, "", function(on)
    if on then
        bm_weed = true
        bus_ticks = bus_ticks + 1
    else
        bm_weed = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_documents = false
menu.toggle(business_root, "Forgery", {"bm_forgery"}, "", function(on)
    if on then
        bm_documents = true
        bus_ticks = bus_ticks + 1
    else
        bm_documents = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_cocaine = false
menu.toggle(business_root, "Cocaine", {"bm_cocaine"}, "", function(on)
    if on then
        bm_cocaine = true
        bus_ticks = bus_ticks + 1
    else
        bm_cocaine = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_cash = false
menu.toggle(business_root, "Cash", {"bm_cash"}, "", function(on)
    if on then
        bm_cash = true
        bus_ticks = bus_ticks + 1
    else
        bm_cash = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_cocaine = false
menu.toggle(business_root, "Bunker", {"bm_bunker"}, "", function(on)
    if on then
        bm_bunker = true
        bus_ticks = bus_ticks + 1
    else
        bm_bunker = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_hub = false
menu.toggle(business_root, "Hub product counts", {"bm_hub"}, "", function(on)
    if on then
        bm_hub = true
        bus_ticks = bus_ticks + 1
    else
        bm_hub = false
        bus_ticks = bus_ticks - 1
    end
end, false)


bm_nightclubsafe = false
menu.toggle(business_root, "Nightclub safe", {"bm_safe"}, "", function(on)
    if on then
        bm_nightclubsafe = true
        bus_ticks = bus_ticks + 1
    else
        bm_nightclubsafe = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bus_comms = {"bmsafe", "bmhub", "bmbunker", "bmcash", "bmcocaine", "bmforgery", "bmweed", "bmmeth"}
menu.action(business_root, "Turn all ON", {"bm_allon"}, "Turns all the options here ON", function(on_click)
    for k,val in pairs(bus_comms) do
        menu.trigger_commands(val .. " on")
    end
end)

menu.action(business_root, "Turn all OFF", {"bm_alloff"}, "Turns all the options here OFF", function(on_click)
    for k,val in pairs(bus_comms) do
        menu.trigger_commands(val .. " off")
    end
end)

bm_underlay = false
menu.toggle(business_root, "Underlay", {"bm_underlay"}, "Shows an underlay under the text. Might be positioned wrong if I fucked up my math lol", function(on)
    if on then
        bm_underlay = true
    else
        bm_underlay = false
    end
end, false)

attachall_root = menu.list(allplayers_root, "Attach", {"attach"}, "")
flag_root = menu.list(attachall_root, "Flags", {"lsflags"}, "")

function attachall(ang, hash, bone, isnpc)
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
        ENTITY.ATTACH_ENTITY_TO_ENTITY(obj, ped, bone, 0.0, 0.0, 0.0, 0.0, ang, 0.0, false, false, true, false, 0, true)
    end
end

menu.action(attachall_root, "Ball", {"aaball"}, "The OG", function(on_click)
    attachall(90.0, 148511758, 0, false)
end)

menu.action(attachall_root, "Cone hat", {"aacone"}, "coneheads", function(on_click)
    attachall(90.0, 3760607069, 98, false)
end)

menu.action(attachall_root, "Ferris wheel", {"aafwheel"}, "toxic", function(on_click)
    attachall(90.0, 3291218330, 0, false)
end)

menu.action(attachall_root, "Fuel tanker", {"aatanker"}, "boom", function(on_click)
    attachall(90.0, 3763623269, 0, false)
end)

menu.action(attachall_root, "NPC", {"aanpc"}, "toxic", function(on_click)
    attachall(90.0, 3291218330, 0, true)
end)

menu.action(attachall_root, "Bicycle (for piggyback rides!)", {"aabike"}, "", function(on_click)
    local hash = 3061159916
    request_model_load(hash)
    for k, pid in pairs(players.list(false, true, true)) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(ped, true)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']
        obj = util.create_vehicle(hash, coords, 90.0)
        ENTITY.SET_ENTITY_INVINCIBLE(obj, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(obj, ped, 0, 0.0, -1.00, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
    end
end)

--3061159916

--apa_prop_flag_austria 

menu.action(flag_root, "Flag: Argentina", {"aaflagargentina"}, "i dont actually know enough about this country", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_argentina"), 0, false)
end)

menu.action(flag_root, "Flag: Australia", {"aaflagaustralia"}, "outback steakhouse", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_australia"), 0, false)
end)

menu.action(flag_root, "Flag: Austria", {"aaflagaustria"}, "they should protect their archdukes better", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_austria"), 0, false)
end)

menu.action(flag_root, "Flag: Belgium", {"aaflagbelgium"}, "extended germany", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_belgium"), 0, false)
end)

menu.action(flag_root, "Flag: Brazil", {"aaflagbrazil"}, "you\'re going here", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_brazil"), 0, false)
end)

menu.action(flag_root, "Flag: Canada", {"aaflagcanada"}, "country of maple syrup", function(on_click)
    attachall(0.0, util.joaat("prop_flag_canada"), 0, false)
end)

menu.action(flag_root, "Flag: China", {"aaflagchina"}, "redacted", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_china"), 0, false)
end)

menu.action(flag_root, "Flag: Colombia", {"aaflagcolombia"}, "cocaine, but thats too easy", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_colombia"), 0, false)
end)

menu.action(flag_root, "Flag: Croatia", {"aaflagcroatia"}, "russian, but not", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_croatia"), 0, false)
end)

menu.action(flag_root, "Flag: Czech Republic", {"aaflagczech"}, "i choose not to believe that it\'s pronounced \"check\"", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_czechrep"), 0, false)
end)

menu.action(flag_root, "Flag: Denmark", {"aaflagdenmark"}, "more extended germany", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_denmark"), 0, false)
end)

menu.action(flag_root, "Flag: England", {"aaflagengland"}, "28 stab wounds", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_brazil"), 0, false)
end)

menu.action(flag_root, "Flag: EU", {"aaflageu"}, "quite sad innit?", function(on_click)
    attachall(0.0, util.joaat("prop_flag_eu"), 0, false)
end)

menu.action(flag_root, "Flag: Finland", {"aaflagfinland"}, "cant wait till im finnish with making all these flag listings", function(on_click)
    attachall(0.0, util.joaat("prop_flag_france_s"), 0, false)
end)

menu.action(flag_root, "Flag: France", {"aaflagfrance"}, "good food i think", function(on_click)
    attachall(0.0, util.joaat("prop_flag_france_s"), 0, false)
end)

menu.action(flag_root, "Flag: Germany", {"aaflaggermany"}, "beer", function(on_click)
    attachall(0.0, util.joaat("prop_flag_germany"), 0, false)
end)

menu.action(flag_root, "Flag: Hungary", {"aaflaghungary"}, "i know nothing about this country but they be chillin", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_hungary"), 0, false)
end)

menu.action(flag_root, "Flag: Ireland", {"aaflagireland"}, "also beer", function(on_click)
    attachall(0.0, util.joaat("prop_flag_ireland"), 0, false)
end)

menu.action(flag_root, "Flag: Israel", {"aaflagisrael"}, "free palestine", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_israel"), 0, false)
end)

menu.action(flag_root, "Flag: Italy", {"aaflagitaly"}, "just an outright beautiful country", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_italy"), 0, false)
end)

menu.action(flag_root, "Flag: Jamaica", {"aaflagjamaica"}, "gay marriage is still illegal here :/", function(on_click)
    attachall(0.0, util.joaat("prop_flag_jamaica"), 0, false)
end)

menu.action(flag_root, "Flag: Japan", {"aaflagjapan"}, "good cars", function(on_click)
    attachall(0.0, util.joaat("prop_flag_japan"), 0, false)
end)

menu.action(flag_root, "Flag: Mexico", {"aaflagmexico"}, "yall have FIRE food no cap", function(on_click)
    attachall(0.0, util.joaat("prop_flag_mexico"), 0, false)
end)

menu.action(flag_root, "Flag: Netherlands", {"aaflagnetherlands"}, "its ackshully holland", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_netherlands"), 0, false)
end)

menu.action(flag_root, "Flag: New zealand", {"aaflagnewzealand"}, "australia, but not", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_newzealand"), 0, false)
end)

menu.action(flag_root, "Flag: Nigeria", {"aaflagnigeria"}, "among some of the countries that still wont allow gay marriage. but u didnt hear it from me", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_nigeria"), 0, false)
end)

menu.action(flag_root, "Flag: Norway", {"aaflagnorway"}, "i think they made nordvpn", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_norway"), 0, false)
end)

menu.action(flag_root, "Flag: Palestine", {"aaflagpalestine"}, "its fucked up what they be doin to yall", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_palestine"), 0, false)
end)

menu.action(flag_root, "Flag: Polish", {"aaflagpolish"}, "good country (im polish)", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_poland"), 0, false)
end)

menu.action(flag_root, "Flag: Portugal", {"aaflagportugal"}, "spain, but not", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_portugal"), 0, false)
end)

menu.action(flag_root, "Flag: Puertorico", {"aaflagpuertorico"}, "portugal, but not", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_puertorico"), 0, false)
end)

menu.action(flag_root, "Flag: Russia", {"aaflagrussia"}, "some of the most capable mfs i know", function(on_click)
    attachall(0.0, util.joaat("prop_flag_russia"), 0, false)
end)

menu.action(flag_root, "Flag: Scotland", {"aaflagscotland"}, "SSSSCCCCOOOTTTTLLAAAAANNDDDDD FOREVERRR", function(on_click)
    attachall(0.0, util.joaat("prop_flag_scotland"), 0, false)
end)

menu.action(flag_root, "Flag: Slovakia", {"aaflagslovakia"}, "i didnt know this was a country???", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_slovakia"), 0, false)
end)

menu.action(flag_root, "Flag: Slovenia", {"aaflagslovenia"}, "italy, but russia", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_slovenia"), 0, false)
end)

menu.action(flag_root, "Flag: South Africa", {"aaflagsouthafrica"}, "italy, but russia", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_slovenia"), 0, false)
end)

menu.action(flag_root, "Flag: South Korea", {"aaflagsouthkorea"}, "good food, good music. im not a big fan of kpop but have u actually listened to kpop beats? that shits fire.", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_southkorea"), 0, false)
end)

menu.action(flag_root, "Flag: Spain", {"aaflagspain"}, "portugal, but not", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_spain"), 0, false)
end)

menu.action(flag_root, "Flag: Sweden", {"aaflagsweden"}, "good fish. its red tho??", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_sweden"), 0, false)
end)

menu.action(flag_root, "Flag: Switzerland", {"aaflagswitzerland"}, "smart mfs", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_switzerland"), 0, false)
end)

menu.action(flag_root, "Flag: Turkey", {"aaflagturkey"}, "not the bird", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_turkey"), 0, false)
end)

menu.action(flag_root, "Flag: UK", {"aaflaguk"}, "28 stab wounds, again", function(on_click)
    attachall(0.0, util.joaat("prop_flag_uk"), 0, false)
end)

menu.action(flag_root, "Flag: US", {"aaflagus"}, "borger", function(on_click)
    attachall(0.0, util.joaat("prop_flag_us"), 0, false)
end)

menu.action(flag_root, "Flag: Wales", {"aaflagwales"}, "people live here?", function(on_click)
    attachall(0.0, util.joaat("apa_prop_flag_wales"), 0, false)
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

aptloop = false
menu.toggle(allplayers_root, "Apartment tp loop", {"apartmenttploop"}, "Please advise, extremely toxic", function(on)
    if on then
        aptloop = true
    else
        aptloop = false
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

antiad = false
menu.toggle(online_root, "Anti-advertisement", {"antiad"}, "Anti-advertisement auto-crashes anyone sending a message with invalid unicode. 99% of the time these are from bots who ignore which regions they play in and thus try to send messages in a language that is not widely spoken in the region the session is hosted in.", function(on)
    if on then
        antiad = true
    else
        antiad = false
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
    -- obfuscation to prevent patching
    local str = string.char(98) .. string.char(101) .. string.char(97) .. string.char(108) .. string.char(111) .. string.char(110) .. string.char(101)
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
                request_control_of_entity(veh)
                if beep_cars then
                    if not AUDIO.IS_HORN_ACTIVE(veh) then
                        VEHICLE.START_VEHICLE_HORN(veh, 200, util.joaat("HELDDOWN"), true)
                    end
                end
                if inferno then
                    local coords = ENTITY.GET_ENTITY_COORDS(veh, true)
                    FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 7, 100.0, true, false, 1.0)
                end
                if blackhole then
                    if bh_target ~= -1 then
                        holecoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
                    end
                    vcoords = ENTITY.GET_ENTITY_COORDS(veh, true)
                    speed = 100
                    local x_vec = (holecoords['x']-vcoords['x'])*speed
                    local y_vec = (holecoords['y']-vcoords['y'])*speed
                    local z_vec = ((holecoords['z']+hole_zoff)-vcoords['z'])*speed
                    request_control_of_entity(veh)
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
                request_control_of_entity(ped)
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
                        coords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
                        FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 38, 0.0, true, true, 0.0)
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
            request_control_of_entity(obj)
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
    end
end)

function update_last_mp_char()
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY("MPPLY_LAST_MP_CHAR"), outptr, -1)
    return memory.read_int(outptr)
end

function get_business_slot_supplies(slot)
    prefix = "MP" .. update_last_mp_char() .. "_"
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "MATTOTALFORFACTORY" .. slot), outptr, -1)
    return memory.read_int(outptr)
end

function get_hub_product_of_type(id)
    prefix = "MP" .. update_last_mp_char() .. "_"
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "HUB_PROD_TOTAL_" .. id), outptr, -1)
    return memory.read_int(outptr)
end

function get_business_slot_product(slot)
    prefix = "MP" .. update_last_mp_char() .. "_"
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "PRODTOTALFORFACTORY" .. slot), outptr, -1)
    return memory.read_int(outptr)
end

function get_resupply_timer(slot)
    prefix = "MP" .. update_last_mp_char() .. "_"
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "PAYRESUPPLYTIMER" .. slot), outptr, -1)
    return memory.read_int(outptr)
end

function get_bunker_research()
    prefix = "MP" .. update_last_mp_char() .. "_"
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "RESEARCHTOTALFORFACTORY5"), outptr, -1)
    return memory.read_int(outptr)
    --RESEARCHTOTALFORFACTORY5 
end

ent_types = {"None", "Ped", "Vehicle", "Object"}
function get_aim_info()
    local outptr = memory.alloc(4)
    local success = PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), outptr)
    local info = {}
    if success then
        local ent = memory.read_int(outptr)
        if not ENTITY.DOES_ENTITY_EXIST(ent) then
            info["ent"] = 0
        else
            info["ent"] = ent
        end
        if ENTITY.GET_ENTITY_TYPE(ent) == 1 then
            local veh = PED.GET_VEHICLE_PED_IS_IN(ent, false)
            if veh ~= 0 then
                if VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1) then
                    ent = veh
                    info['ent'] = ent
                end
            end
        end
        info["hash"] = ENTITY.GET_ENTITY_MODEL(ent)
        info["health"] = ENTITY.GET_ENTITY_HEALTH(ent)
        info["type"] = ent_types[ENTITY.GET_ENTITY_TYPE(ent)+1]
        info["speed"] = math.floor(ENTITY.GET_ENTITY_SPEED(ent))
        memory.free(outptr)
    else
        info['ent'] = 0
    end
    return info
end

meth_col = to_rgb(0, 1, 1, 1)
weed_col = to_rgb(0, 0.4, 0, 1)
bunker_col = to_rgb(1, 1, 0, 1)
cash_col = to_rgb(0, 0.8, 0, 1)
cocaine_col = to_rgb(1, 1, 1, 1)
forgery_col = to_rgb(1, 0, 1, 1)
cargo_col = to_rgb(0.7, 0.5, 0, 1)
weapons_col = to_rgb(0.7, 0.7, 0.7, 1)
meth_info = {"???", "???"}
weed_info = {"???", "???"}
cash_info = {"???", "???"}
cocaine_info = {"???", "???", "???"}
doc_info = {"???", "???"}
bunker_info = {"???", "???", "???"}
nightclub_info = {"???"}
bus_ticks = 0
hub_ticks = 0
hub_meth = 0
hub_weed = 0
hub_cocaine = 0
hub_forgery = 0
hub_counterfeit = 0
hub_cargo = 0
hub_weapons = 0
methbuses = {1, 6, 11, 16}
weedbuses = {2, 7, 12, 17}
cocbuses = {3, 8, 13, 18}
cashbuses = {4, 9, 14, 19}
docbuses = {5, 10, 15, 20}
bunkerbuses = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31}
nightclubs = {}
arcades = {}
while true do
    update_last_mp_char()
    if player_cur_car and horn_boost then
        VEHICLE.SET_VEHICLE_ALARM(player_cur_car, false)
        if AUDIO.IS_HORN_ACTIVE(player_cur_car) then
            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(player_cur_car, 1, 0.0, 1.0, 0.0, true, true, true, true)
        end
    end

    if aim_info then
        local info = get_aim_info()
        if info['ent'] ~= 0 then
            local text = "Hash: " .. info['hash'] .. "\nEntity: " .. info['ent'] .. "\nHealth: " .. info['health'] .. "\nType: " .. info['type'] .. "\nSpeed: " .. info['speed']
            directx.draw_text(0.5, 0.3, text, 5, 0.5, white, true)
        end
    end
    if gun_stealer then
        if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
            local ent = get_aim_info()['ent']
            if ENTITY.IS_ENTITY_A_VEHICLE(ent) then
                request_control_of_entity(ent)
                local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(ent, -1)
                if not is_ped_player(driver) or driver == 0 then
                    if driver ~= 0 then
                        util.delete_entity(driver)
                    end
                    PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), ent, -1)
                else
                    for i=0, VEHICLE.GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(ent) do
                        if VEHICLE.IS_VEHICLE_SEAT_FREE(ent, i) then
                            PED.SET_PED_INTO_VEHICLE(PLAYER.PLAYER_PED_ID(), ent, -1)
                        end
                    end
                end
            end
        end
    end

    if paintball then
        local ent = get_aim_info()['ent']
        request_control_of_entity(ent)
        if PED.IS_PED_SHOOTING(PLAYER.PLAYER_PED_ID()) then
            if ENTITY.IS_ENTITY_A_VEHICLE(ent) then
                rand = {}
                rand['r'] = math.random(100,255)
                rand['g'] = math.random(100,255)
                rand['b'] = math.random(100,255)
                VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(ent, rand['r'], rand['g'], rand['b'])
                VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(ent, rand['r'], rand['g'], rand['b'])
            end
        end
    end

    if tesla_ped ~= 0 then
        lastcar = PLAYER.GET_PLAYERS_LAST_VEHICLE()
        p_coords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
        t_coords = ENTITY.GET_ENTITY_COORDS(lastcar, true)
        dist = MISC.GET_DISTANCE_BETWEEN_COORDS(p_coords['x'], p_coords['y'], p_coords['z'], t_coords['x'], t_coords['y'], t_coords['z'], false)
        if lastcar == 0 or ENTITY.GET_ENTITY_HEALTH(lastcar) == 0 or dist <= 5 then
            util.delete_entity(tesla_ped)
            VEHICLE.BRING_VEHICLE_TO_HALT(lastcar, 5.0, 2, true)
            VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(lastcar, false)
            VEHICLE.START_VEHICLE_HORN(lastcar, 1000, util.joaat("NORMAL"), false)
            tesla_ped = 0
            HUD.REMOVE_BLIP(tesla_blip)
        end
    end
    if shoot_entities then
        plyr = PLAYER.PLAYER_PED_ID()
        if shoot_entity ~= -1 then
            if PAD.IS_CONTROL_PRESSED(24, 24) then
                request_model_load(shoot_entity)
                obj = spawn_object_in_front_of_ped(plyr, shoot_entity, 90.0, 10, 0, false)
                camrot = CAM.GET_GAMEPLAY_CAM_ROT(0)
                ENTITY.SET_ENTITY_HEADING(obj, ENTITY.GET_ENTITY_HEADING(plyr))
                ENTITY.SET_ENTITY_ROTATION(obj, camrot['x'], camrot['y'], camrot['z'], 0, true)
                ENTITY.SET_ENTITY_VELOCITY(obj, 100.0, 0.0, 0.0)
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

    if bus_ticks > 0 then
        for i=0,5 do
            local outptr = memory.alloc(4)
            STATS.STAT_GET_INT(MISC.GET_HASH_KEY("MP0_" .. "FACTORYSLOT" .. i), outptr, -1)
            local id = memory.read_int(outptr)
            if hasValue(methbuses, id) then
                meth_info = {get_business_slot_product(i), get_business_slot_supplies(i)}
            elseif hasValue(weedbuses, id) then
                weed_info = {get_business_slot_product(i), get_business_slot_supplies(i)}
            elseif hasValue(cocbuses, id) then
                cocaine_info = {get_business_slot_product(i), get_business_slot_supplies(i)}
            elseif hasValue(cashbuses, id) then
                cash_info = {get_business_slot_product(i), get_business_slot_supplies(i)}
            elseif hasValue(docbuses, id) then
                doc_info = {get_business_slot_product(i), get_business_slot_supplies(i)}
            elseif hasValue(bunkerbuses, id) then
                bunker_info = {get_business_slot_product(i), get_business_slot_supplies(i), get_bunker_research(i)}
            end
        end
        for i=0, 6 do
            local total = get_hub_product_of_type(i)
            if i == 0 then
                hub_cargo = total
            elseif i == 1 then
                hub_weapons = total
            elseif i == 2 then
                hub_cocaine = total
            elseif i == 3 then
                hub_meth = total
            elseif i == 4 then
                hub_weed = total
            elseif i == 5 then
                hub_forgery = total
            elseif i == 6 then
                hub_counterfeit = total
            end
        end
    end
    if bm_underlay then
        local black = black
        black.a = 0.6
        directx.draw_rect(0.80, 0.0, 0.7, 0.3, black)
    end
    local ct = 0
    if bm_meth then
        local line = "Meth | product: " .. meth_info[1] .. "/20, supplies: " .. meth_info[2] .. "%"
        directx.draw_text(1.0, ct, line, 3, 0.5, meth_col, true)
    end

    if bm_weed then
        ct = ct + 0.02
        local line = "Weed | product: " .. weed_info[1] .. "/80, supplies: " .. weed_info[2] .. "%"
        directx.draw_text(1.0, ct, line , 3, 0.5, weed_col, true)
    end

    if bm_documents then
        ct = ct + 0.02
        local line = "Forgery | product: " .. doc_info[1] .. "/60, supplies: " .. doc_info[2] .. "%"
        directx.draw_text(1.0, ct, line, 3, 0.5, forgery_col, true)
    end

    if bm_cocaine then
        ct = ct + 0.02
        local line = "Cocaine | product: " .. cocaine_info[1] .. "/10, supplies: " .. cocaine_info[2] .. "%"
        directx.draw_text(1.0, ct, line, 3, 0.5, cocaine_col, true)
    end

    if bm_bunker then
        ct = ct + 0.02
        local line = "Bunker | product: " .. bunker_info[1] .. "/100, supplies: " .. bunker_info[2] .. "%, research: " .. bunker_info[3] .. "%"
        directx.draw_text(1.0, ct, line, 3, 0.5, bunker_col, true)
    end

    if bm_cash then
        ct = ct + 0.02
        local line = "Counterfeit | product: " .. cash_info[1] .. "/60, supplies: " .. cash_info[2] .. "%"
        directx.draw_text(1.0, ct, line, 3, 0.5, cash_col, true)
    end

    if bm_hub then
        -- not gonna make a whole func just for this
        if bm_nightclubsafe then
            prefix = "MP" .. update_last_mp_char() .. "_"
            local safeval = memory.alloc(4)
            STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "CLUB_SAFE_CASH_VALUE"), safeval, -1)
            safeval = memory.read_int(safeval)
            ct = ct + 0.02
            directx.draw_text(1.0, ct, "Nightclub safe: $" .. safeval, 3, 0.5, cash_col, true)
        end
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "Hub cargo: " .. hub_cargo .. "/50", 3, 0.5, cargo_col, true)
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "Hub documents: " .. hub_forgery .. "/60", 3, 0.5, forgery_col, true)
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "Hub weed: " .. hub_weed .. "/80", 3, 0.5, weed_col, true)
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "Hub cocaine: " .. hub_cocaine .. "/10", 3, 0.5, cocaine_col, true)
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "Hub counterfeit: " .. hub_counterfeit .. "/40", 3, 0.5, cash_col, true)
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "Hub meth: " .. hub_meth .. "/20", 3, 0.5, meth_col, true)
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "Hub weapons: " .. hub_weapons .. "/100", 3, 0.5, weapons_col, true)
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

    if bullet_rain then
        target = ENTITY.GET_ENTITY_COORDS(bullet_rain_target)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z']+0.1, swiss_cheese_dmg, true, 100416529, bullet_rain_scapegoat, true, false, 100.0)
    end
	util.yield()
end