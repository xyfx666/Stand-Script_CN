-- coded by lance#8213, from scratch
-- if you are stealing my code to use it in another menu actually kys
--123456
require("natives-1627063482")
ocoded_for = 1.57
version = "3.2.0"
online_v = tonumber(NETWORK._GET_ONLINE_VERSION())
if online_v > ocoded_for then
    util.toast("This script is outdated for the current GTA:O version (" .. online_v .. ", coded for " .. ocoded_for .. "). Some options may not work, but most should.")
end

self_root = menu.list(menu.my_root(), "自我", {"lancescriptself"}, "")
weapons_root = menu.list(menu.my_root(), "武器", {"lancescriptweapons"}, "")
shootentity_root = menu.list(weapons_root, "射出实体", {"lancescriptweapons"}, "")
protections_root = menu.list(menu.my_root(), "保护", {"lancescriptprotections"}, "")
noclip_root = menu.list(self_root, "无碰撞", {"lancescriptnoclip"}, "")
world_root = menu.list(menu.my_root(), "世界", {"lancescriptworld"}, "")
entity_root = menu.list(menu.my_root(), "附近的车辆/物体", {"lancescriptentity"}, "")
npc_root = menu.list(menu.my_root(), "附近的NPCs", {"lancescriptnpcs"}, "")
tasks_root = menu.list(npc_root, "任务", {"lancescripttasks"}, "")
vehicle_root = menu.list(menu.my_root(), "车辆", {"lanceobjecttroll"}, "")
online_root = menu.list(menu.my_root(), "在线", {"lancescriptonline"}, "")
allplayers_root = menu.list(menu.my_root(), "所有玩家", {"lancescriptallplayers"}, "")
business_root = menu.list(online_root, "自动产业", {"lancescriptbusiness"}, "")
gametweaks_root = menu.list(menu.my_root(), "游戏调整", {"lancescriptgametweaks"}, "")
fakemessages_root = menu.list(gametweaks_root, "虚假消息", {"lancescriptfakemessages"}, "")
radio_root = menu.list(gametweaks_root, "广播", {"lancescriptradio"}, "")
lancescript_root = menu.list(menu.my_root(), "LanceScript", {"lancescriptutil"}, "")
sounds_root = menu.list(lancescript_root, "声音", {"lancescriptsounds"}, "")

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
    util.toast('未能找到'..file_name .. ' 请确保您已过目INSTALL.TXT, 并按指示正确安装脚本.')
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
util.async_http_get("pastebin.com", "/raw/YK0P06yC", function(result)
    if version < result then
        util.toast("Lancescript 有更新可用!可前往网站更新.")
        os.execute("start \"\" \"https://www.guilded.gg/stand/groups/x3ZgB10D/channels/7430c963-e9ee-40e3-ab20-190b8e4a4752/docs/265965\"")
    else
        util.toast("Lancescript 是最新的!")
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

scaleform_thread = util.create_thread(function (thr)
    name = os.getenv("USERNAME")
    util.toast("你好 " .. name .. "!")
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
                local text = "~g~阁下没有被禁止进入GTA线上模式~n~ ~w~请注意, 这是来自Lancescript开发者的一则声明,恳请您仔细阅读.~n~我已注意到您或许在使用ToxicEssentials(ToxicEssent1als.lua).~n~我不能强迫您不再使用ToxicEssentials,但它的制作组不是他妈的什么好东西.~n~" .. 
                "ToxicEssentials的内容中包括其他Lua脚本作者的辛苦创作.而它的制作组成员,pnn,在未有标明原作者,或征得原作者同意的情况下剽窃代码,并将其用于商业行为.~n~产生的任何盈利也没有回馈给这些代码的作者."
                local text2 = "您可以继续使用ToxicEssentials.但制作ToxicEssential的成员之一,~n~ICYPhoenix,相较其他制作组成员拥有良好的品德.~n~他/她过去几个月来一直在维护一个没有混淆过代码,并标注代码来源的版本.~n~" .. 
                "我强烈建议您使用Phoenixscript和/或 Lancescript 来代替pnn剽窃来的作品 ~n~毕竟Phoenixscript 本来就是 Toxicessentials.~n~"..
                "我鼓励您不再向别人分享ToxicEssentials,因为ToxicEssentials的代码是剽窃来的,被混淆过的,且质量很差.但您也可以选择忽视这条信息,并继续分享."
                local text3 = "您之后不会再看到这则声明,感谢阁下抽出您宝贵的时间阅读此声明."
                show_custom_alert_until_enter(text)
                show_custom_alert_until_enter(text2)
                show_custom_alert_until_enter(text3)
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
                util.toast("耶稣不再在人间显灵了, 正在阻止耶稣的线程.")
                util.stop_thread()
            end
            local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(target)
            if not players.exists(target) then
                util.toast("玩家已离开, 伤心的耶稣停止了思考.")
                util.stop_thread()
            else
                TASK.TASK_COMBAT_PED(jesus, target_ped, 0, 16)
            end
            util.yield()
        end
    end)
end
menu.toggle(lancescript_root, "显示活动的实体池", {"entitypoolupdates"}, "正在更新实体池. 你看到的越多, CPU的负载越重. 建议不要长期开启", function(on)
    if on then
        show_updates = true
    else
        show_updates = false
    end
end)

menu.action(lancescript_root, "在YouTube上观看为美好的世界献上祝福!的第一集", {"konosuba"}, "", function(on_click)
    os.execute("start \"\" \"https://www.youtube.com/watch?v=H8CORxz5FKA\"")
end)
--memory.scan(string pattern)

menu.action(lancescript_root, "查看Lancescript的推特", {"tweet"}, "", function(on_click)
    os.execute("start \"\" \"https://twitter.com/compose/tweet?text=Lancescript is the best LUA script ever!\"")
end)

menu.action(lancescript_root, "查看脚本汉化仓库", {"tweet"}, "", function(on_click)
    os.execute("start \"\" \"https://github.com/xyfx666/Stand-Script_CN\"")
end)

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
        util.toast("请求的模型无效, 无法加载.")
        return
    end
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        if os.time() - request_time >= 10 then
            util.toast("模型将在十秒内加载.")
            break
        end
        util.toast("正在加载模组HASH值..." .. hash)
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

menu.toggle(weapons_root, "隐藏武器", {"invisguns"}, "让你的武器不可见. 或许只对自己可见, 切换武器后需重新开启.", function(on)
    plyr = PLAYER.PLAYER_PED_ID()
    if on then
        WEAPON.SET_PED_CURRENT_WEAPON_VISIBLE(plyr, false, false, false, false) 
    else
        WEAPON.SET_PED_CURRENT_WEAPON_VISIBLE(plyr, true, false, false, false) 
    end
end, false)

noexplosives = false
menu.toggle(protections_root, "禁止爆炸", {"noexplosives"}, "自动从世界中移除所有爆炸弹药, 包括火箭. 或许只对自己可见. 并不包括所有爆炸, 只包括一些玩家武器. 车载武器可能不受影响. ", function(on)
    plyr = PLAYER.PLAYER_PED_ID()
    if on then
        noexplosives = true
    else
        noexplosives = false
    end
end, false)

noclip = false
noclip_height = 0
menu.toggle(noclip_root, "无碰撞", {"noclip"}, "车辆也同样适用.", function(on)
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
menu.click_slider(noclip_root, "水平速度", {"nocliphspeed"}, "无碰撞的水平速度, * 0.1", 1, 50, 5, 1, function(s)
    noclip_hspeed = s * 0.1
  end)

noclip_vspeed = 0.1
menu.click_slider(noclip_root, "垂直速度", {"noclipvspeed"}, "无碰撞的垂直速度, * 0.1", 1, 50, 2, 1, function(s)
    noclip_vspeed = s * 0.1
  end)
  
menu.toggle(self_root, "让我当警察", {"makemecop"}, "将人物模型的属性设为警察. 几乎所有的警察都看不见你, 但犯下罪行后仍会被通缉. 有警察的声音, 有警察视角显示, 不能攻击其他警察. 特警和军队仍然会向你开火. 如果不想再当警察的话需自杀一次", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        PED.SET_PED_AS_COP(ped, true)
    else
        menu.trigger_commands("suicide")
    end
end)



hud_rainbow = false
menu.toggle(gametweaks_root, "RGB HUD", {"rgbhud"}, "让你的游戏UI变得RGB起来,可以提升100%的电脑性能,需重启游戏才能恢复原样. ", function(on)
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

menu.toggle(radio_root, "只有音乐的电台", {"musiconly"}, "强制电台只播放音乐. 没有废话. ", function(on)
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

menu.action(fakemessages_root, "Yeeyee ass haircut", {"yeeyee"}, "maybe", function(on_click)
    show_custom_alert_until_enter("如果你能换掉那个 ~r~土老帽的发型~w~ 可能会有一些婊子愿意让你操")
end)

menu.action(fakemessages_root, "欢迎加入黑暗行军", {"blackparade"}, "", function(on_click)
    show_custom_alert_until_enter("当我还是一个年轻的男孩的时候，我的父亲~n~"..
    "带我进城去看游行乐队~n~"..
    "他说: \"儿子,你长大后想成为什么样的人？\"~n~"..
    "救世主，失败者，还是一个该死的人？\"~n~"..
    "他说，\"你会打败他们吗？ 你的恶魔~n~"..
    "所有没有信仰的，他们指定的计划？~n~"..
    "因为有一天，我会给你留下一个幽灵~n~"..
    "在夏天带领你参加黑人游行...\"~n~"..
    "~n~"..
    "当我还是一个年轻的男孩的时候，我的父亲~n~"..
    "带我进城去看游行乐队~n~"..
    "他说: \"儿子,你长大后想成为什么样的人？~n~"..
    "救世主，失败者,还是一个该死的人？\"")
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

menu.action(fakemessages_root, "自定义警告", {"customalert"}, "显示您喜欢的自定义提醒 .这要归功于QuickNUT和Sainan的帮助 .", function(on_click)
    util.toast("Please type what you want the alert to say. Type ~n~ for new line, ie foo~n~bar will show up as 2 lines.")
    menu.show_command_box("customalert ")
end, function(on_command)
    show_custom_alert_until_enter(on_command)
end)

menu.action(menu.my_root(), "玩家菜单", {}, "为方便起见 ,快速打开会话玩家列表", function(on_click)
    menu.trigger_commands("playerlist")
end)

make_peds_cops = false
menu.toggle(npc_root, "叫附近的警察来", {"makecops"}, "他们不是真正的警察 ,但有点像 .他们似乎很容易逃跑 ,但会告密你 .有点像商场警察 .", function(on)
    if on then
        make_peds_cops = true
        ped_uses = ped_uses + 1
    else
        make_peds_cops = false
        ped_uses = ped_uses - 1
    end
end, false)
--SET_RIOT_MODE_ENABLED(BOOL toggle)
menu.toggle(npc_root, "暴动模式", {"riotmode"}, "所有附近的NPC都决斗了 ,并获得了武器 .令人惊讶的是 ,这是由游戏本身处理的 .", function(on)
    if on then
        MISC.SET_RIOT_MODE_ENABLED(true)
    else
        MISC.SET_RIOT_MODE_ENABLED(false)
    end
end, false)

menu.action(npc_root, "让附近的行人成为音乐家", {}, "现在这里是神奇墙", function(on_click)
    local peds = util.get_all_peds()
    for k,ped in pairs(peds) do
        if not is_ped_player(ped) then
            TASK.TASK_LEAVE_ANY_VEHICLE(ped, 0, 16)
            TASK.TASK_START_SCENARIO_IN_PLACE(ped, "WORLD_HUMAN_MUSICIAN", 0, true)
        end
    end
end)

roast_voicelines = false
menu.toggle(npc_root, "烧烤语音线", {"npcroasts"}, "非常不道德 .", function(on)
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
menu.toggle(npc_root, "性爱语音线", {"sexlines"}, "哦 ,我操你妈的 ,这真是爽翻了", function(on)
    if on then
        ped_uses = ped_uses + 1
        sex_voicelines = true
    else
        ped_uses = ped_uses -1
        sex_voicelines = false
    end
end, false)

gluck_voicelines = false
menu.toggle(npc_root, "Gluck gluck 9000 语音线", {"gluckgluck9000"}, "我求你 ,摸摸草 .", function(on)
    if on then
        ped_uses = ped_uses + 1
        gluck_voicelines = true
    else
        ped_uses = ped_uses -1
        gluck_voicelines = false
    end
end, false)

screamall = false
menu.toggle(npc_root, "尖叫", {"screamall"}, "让附近所有的行人惨叫 .这真是太让人兴奋了 .", function(on)
    if on then
        ped_uses = ped_uses + 1
        screamall = true
    else
        ped_uses = ped_uses -1
        screamall = false
    end
end, false)

play_ped_ringtones = false
menu.toggle(npc_root, "给所有行人打电话", {"ringtones"}, "打开附近所有的行人铃声", function(on)
    if on then
        play_ped_ringtones = true
        ped_uses = ped_uses +1
    else
        play_ped_ringtones = false
        ped_uses = ped_uses - 1
    end
end, false)

dumb_peds = false
menu.toggle(npc_root, "使所有的人哑口无言", {"dumbpeds"}, "使附近的行人变哑/在发动机中将其标记为“非高度感知” .不管那意味着什么 ,tbh .", function(on)
    if on then
        dumb_peds = true
        ped_uses = ped_uses + 1
    else
        dumb_peds = false
        ped_uses = ped_uses - 1
    end
end, false)

safe_peds = false
menu.toggle(npc_root, "给行人头盔", {"safepeds"}, "第一次开车的人需要安全 .", function(on)
    if on then
        safe_peds = true
        ped_uses = ped_uses + 1
    else
        safe_peds = false
        ped_uses = ped_uses - 1
    end
end, false)

deaf_peds= false
menu.toggle(npc_root, "让所有的行人都聋", {"deafpeds"}, "使附近的行人聋了 .可能只有在执行隐形任务时才引人注目 .", function(on)
    if on then
        deaf_peds = true
        ped_uses = ped_uses + 1
    else
        deaf_peds = false
        ped_uses = ped_uses - 1
    end
end, false)

kill_peds= false
menu.toggle(npc_root, "杀死行人", {"killpeds"}, "Stand已经这么做了 ,但不管怎样 .我认为我们的更具戏剧性.", function(on)
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
menu.action(tasks_root, "失败", {"flop"}, "所有行走的NPC都会做翻牌.所有驾驶NPC的人都会轻轻地停车,然后离开,然后再做.", function(on_click)
    task_handler("flop")
end)

menu.action(tasks_root, "移动覆盖", {"cover"}, "猫咪NPC", function(on_click)
    task_handler("cover")
end)

menu.action(tasks_root, "拱顶", {"vault"}, "他们跳过一个看不见的障碍.奥运会.这也让司机们从车里跳出来,跌入世界各地,因为rockstar.", function(on_click)
    task_handler("vault")
end)

menu.action(tasks_root, "畏缩", {"cower"}, "他们永远畏缩.", function(on_click)
    task_handler("cower")
end)


menu.action(tasks_root, "折磨我", {"writheme"}, "让NPC在地上无限痛苦.最后,这些蠢货有了用武之地.当地人让司机变得隐形,直到他们因故死亡.", function(on_click)
    task_handler("writheme")
end)

menu.action(entity_root, "传送进最近的一个车辆", {"closestvehicle"}, "传送到最近的车辆(不包括你可能已经在的车辆).如果最近的车有玩家司机,它会把你安排到下一个空位(如果有的话).记住,附近的车辆可能不是“真正的”车辆,而可能只是LOD的.", function(on_click)
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
            util.toast("附近没有空座位的车辆:(")
        end
    end
end)

blackhole = false
menu.toggle(entity_root, "车辆黑洞", {"blackhole"}, "一个超级落后但有趣的黑洞.当你打开它时,它会设置你上方的黑洞位置.可重新启动它以改变位置.哦,还有,这是非常耗费cpu,可能会导致游戏崩溃.", function(on)
    if on then
        holecoords = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), true)
        util.toast("黑洞位置在你的位置上方50单位.重新开关这个开关来改变位置.")
        blackhole = true
        vehicle_uses = vehicle_uses + 1
    else
        blackhole = false
        vehicle_uses = vehicle_uses - 1
    end
end, false)

hole_zoff = 50
menu.click_slider(entity_root, "黑洞离你有多远", {"blackholeoffset"}, "黑洞离你多远.建议保持这个数值相当高.", 0, 100, 50, 10, function(s)
    hole_zoff = s
  end)

vehicle_fuckup = false
menu.toggle(entity_root, "附近所有车变扁", {"fuckupcars"}, "比附近所有的车都厉害.但这种损害只是局部的.", function(on)
    if on then
        vehicle_fuckup = true
        vehicle_uses = vehicle_uses + 1
    else
        vehicle_fuckup = false
        vehicle_uses = vehicle_uses - 1
    end
end, false)

inferno = false
menu.toggle(entity_root, "爆炸汽车", {"inferno"}, "爆炸附近汽车,是持续的,就算他已经损坏.", function(on)
    if on then
        inferno = true
        vehicle_uses = vehicle_uses + 1
    else
        inferno = false
        vehicle_uses = vehicle_uses - 1
    end
end, false)


godmode_vehicles = false
menu.toggle(entity_root, "npc车辆无敌", {"godmodecars"}, "使附近所有的汽车不会损坏.这是为NPC车设计的,所以当人炸了你的意大利车时,不要抱怨.", function(on)
    if on then
        godmode_vehicles = true
        vehicle_uses = vehicle_uses + 1
    else
        godmode_vehicles = false
        vehicle_uses = vehicle_uses - 1
    end
end)

disable_veh_colls = false
menu.toggle(entity_root, "附近汽车沉底", {"nocolcars"}, "让附近所有的汽车掉入世界,或者“掉进一个洞里”.", function(on)
    if on then
        disable_veh_colls = true
        vehicle_uses = vehicle_uses + 1
    else
        disable_veh_colls = false
        vehicle_uses = vehicle_uses - 1
    end
end)


vehicle_rainbow = false
menu.toggle(entity_root, "彩虹车辆", {"rainbowvehicles"}, "附近所有汽车变成彩虹汽车!", function(on)
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
menu.toggle(entity_root, "实体收割者", {"entityreap"}, "获取所有附近的实体（请求所有权）", function(on)
    if on then
        util.toast("实体收割者开启.这可能会导致性能问题.")
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
    util.toast('完成垃圾邮件实体.')
end

aircraft_root = menu.list(vehicle_root, "飞机", {"lanceaircraft"}, "")

menu.action(vehicle_root, "强制离开载具", {"forceleave"}, "在紧急情况下或车辆受阻时,强行离开车辆", function(on_click)
    TASK.TASK_LEAVE_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), 0, 16)
end)

menu.action(aircraft_root, "破坏船", {"breakrudder"}, "破坏了方向舵.有利于特技表演.", function(on_click)
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

menu.action(vehicle_root, "180度掉头", {"vehicle180"}, "在保持动力的情况下转弯.建议使用快捷键绑定此功能.", function(on_click)
    if player_cur_car then
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
menu.toggle(vehicle_root, "坚守阵地", {"stick2ground"}, "使你的车保持在地面上.", function(on)
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
menu.toggle(vehicle_root, "使用MPH的速度表板", {"usemph"}, "如果你不是美国人,请关掉.", function(on)
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

menu.click_slider(vehicle_root, "载具最高速度", {"topspeed"}, "设定载具的最高速度（这在其他地方被称为发动机功率倍增器）)", 1, 2000, 200, 50, function(s)
    VEHICLE.MODIFY_VEHICLE_TOP_SPEED(player_cur_car, s)
end)

shift_drift = false
menu.toggle(vehicle_root, "按住Shift键漂移", {"shiftdrift"}, "你听到了.", function(on)
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
    ls_proot = menu.list(menu.player_root(pid), "恶搞选项", {"entityspam"}, "")
    entspam_root = menu.list(ls_proot, "实体垃圾邮件", {"entityspam"}, "")
    npctrolls_root = menu.list(ls_proot, "NPC追杀", {"npctrolls"}, "")
    objecttrolls_root = menu.list(ls_proot, "物体拖曳", {"objecttrolls"}, "")
    ram_root = menu.list(ls_proot, "内存", {"ram"}, "")
    attach_root = menu.list(ls_proot, "附加", {"attach"}, "")

    --AUDIO.PLAY_PED_RINGTONE("Dial_and_Remote_Ring", ped, true)
    menu.action(ls_proot, "无限的电话铃声", {"infiphonering"}, "[试验性] 无限播放电话铃声,即使他们加入单人游戏.仍然需要充分的测试.", function(on_click)
        AUDIO.PLAY_PED_RINGTONE("Dial_and_Remote_Ring", PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
    end)

    menu.toggle(ram_root, "落地", {"ramonground"}, "如果用户正在驾驶飞机,请关闭", function(on)
        if on then
            ram_onground = true
        else
            ram_onground = false
        end
    end, true)

    menu.action(ram_root, "霍华德", {"ramhoward"}, "brrt", function(on_click)
        ram_ped_with(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), -1007528109, 10.0, true)
    end)

    menu.action(ram_root, "拉力车", {"ramtruck"}, "vroom", function(on_click)
        ram_ped_with(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), -2103821244, 10.0, false)
    end)

    menu.action(ram_root, "货机", {"ramcargo"}, "某些菜单可能会阻止此功能", function(on_click)
        ram_ped_with(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 368211810, 15.0, false)
    end)

    -- 	368211810
    ---2103821244

    menu.action(ls_proot, "喷火", {"firejet"}, "经典恶搞之一", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
        FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 12, 100.0, true, false, 0.0)
    end)

    menu.action(ls_proot, "喷水", {"waterjet"}, "经典恶搞之一", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(target_ped, false)
        FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 13, 100.0, true, false, 0.0)
    end)

    menu.toggle(attach_root, "附加到玩家", {"attachto"}, "有用,因为如果你靠近玩家,你的恶搞效果会更好", function(on)
        if on then
            ENTITY.ATTACH_ENTITY_TO_ENTITY(PLAYER.PLAYER_PED_ID(), PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
        else
            ENTITY.DETACH_ENTITY(PLAYER.PLAYER_PED_ID(), false, false)
        end
    end, false)

    menu.toggle(attach_root, "附加到玩家的载具", {"attachtocar"}, "只有在他们有车/最后一辆车的情况下才有效", function(on)
        local lastveh = PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), true)
        if on and lastveh ~= 0 then
            ENTITY.ATTACH_ENTITY_TO_ENTITY(PLAYER.PLAYER_PED_ID(), lastveh, 0, 0.0, -0.20, 2.00, 1.0, 1.0,1, true, true, true, false, 0, true)
        else
            ENTITY.DETACH_ENTITY(PLAYER.PLAYER_PED_ID(), false, false)
        end
    end, false)


    menu.toggle(ls_proot, "耳环", {"earrape"}, "Be evil.", function(on)
        if on then
            earrape = true
            earrape_target = pid
        else
            earrape = false
        end
    end, false)

    menu.toggle(ls_proot, "黑洞目标", {"bhtarget"}, "在目标上方50米开启汽车黑洞,谨慎使用,.", function(on)
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

    menu.toggle(ls_proot, "在聊天中嘲讽这个玩家", {"mockplayer"}, "当他们说一个信息时,会在聊天中重复该信息来嘲笑他们.", function(on)
        if on then
            mock_target = pid
            mock = true
        else
            mock_target = -1
            mock = false
        end
    end)
    ---1788665315
    menu.action(npctrolls_root, "敌对的狗", {"dogatk"}, "arf uwu", function(on_click)
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


    menu.action(npctrolls_root, "敌对的狮子", {"cougaratk"}, "rawr", function(on_click)
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
    menu.action(npctrolls_root, "把他的车用拖车拖走", {"towtruck"}, "他们没有付房租.仅适用于玩家不在但在的汽车（因为你不能触摸玩家正在驾驶的实体）.", function(on_click)
        local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local last_veh = PED.GET_VEHICLE_PED_IS_IN(player_ped, true)
        local cur_veh = PED.GET_VEHICLE_PED_IS_IN(player_ped, false)
        if last_veh ~= 0 then
            if last_veh == cur_veh then
                util.toast("他们还在车内.等到他离开时候使用.")
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

    
    menu.toggle(npctrolls_root, "从车尾拖走", {"towbehind"}, "如果车头被挡住,则开启这个选项", function(on)
        if on then
            towfrombehind = true
        else
            towfrombehind = false
        end
    end)



    menu.action(npctrolls_root, "发射猫咪", {"meow"}, "UWU", function(on_click)
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


    menu.action(npctrolls_root, "发送攻击者耶稣", {"sendgrieferjesus"}, "生成一个无敌的耶稣,他有一把轨道枪,会不断地攻击玩家,甚至在他死后,如果他离得太远就会传送到他的身边.这有时会出现故障,这通常是由于网络的原因..", function(on_click)
        dispatch_griefer_jesus(pid)
    end)

    menu.toggle(objecttrolls_root, "故障车辆", {"glitchveh"}, "他们所乘的车出了故障,如果他们进了车.", function(on)
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

    menu.action(npctrolls_root, "派喷气式飞机", {"sendjets"}, "对于这个极其基本的功能,我们不收取140美元/然而,喷气机只会在玩家死亡前瞄准玩家,否则我们需要另一端代码,但是我不想写.", function(on_click)
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

    menu.action(entspam_root, "交通锥", {"conespam"}, "垃圾桶", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 3760607069)
    end)

    menu.action(entspam_root, "假阴茎", {"dildospam"}, "啊好羞耻", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 3872089630)
    end)

    menu.action(entspam_root, "热狗", {"hotdogspam"}, "一个狗,他很热,于是它变成了热狗（有个东京也很热）", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 2565741261)
    end)

    menu.action(entspam_root, "热狗摊", {"hotdogstandspam"}, "你知道我为啥把STAND大写吗hhh.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 2713464726)
    end)

    menu.action(entspam_root, "摩天轮", {"ferriswheelspam"}, "小心点", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 3291218330)
    end)

    menu.action(entspam_root, "过山车", {"rollerspam"}, "游乐时刻!", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 3413442113)
    end)

    menu.action(entspam_root, "对空雷达", {"radarspam"}, "雷达转啊转", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, 2306058344)
    end)
    --1681875160


    menu.action(entspam_root, "自定义实体", {"customentityspam"}, "输入自定义实体.尽量不要输入无效的哈希值,但是程序是智能的,你输了无效值也没事.", function(on_click)
        util.toast("Please input the model hash")
        menu.show_command_box("customentityspam ")
    end, function(on_command)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        spam_entity_on_player(target_ped, on_command)
    end)

    menu.toggle(entspam_root, "实体具有引力", {"entitygrav"}, "", function(on)
        if on then
            entity_grav = true
        else
            entity_grav = false
        end
    end, true)

    menu.click_slider(entspam_root, "实体数目", {"entspamnum"}, "发送实体垃圾的数目.设置太高容易自崩.", 1, 100, 30, 10, function(s)
        num_of_spam = s
    end)

    menu.action(objecttrolls_root, "在玩家前面的坡道", {"ramp"}, "在玩家正前方产生一个斜坡.玩家在车里时用起来最方便.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local hash = 2282807134
        request_model_load(hash)
        spawn_object_in_front_of_ped(target_ped, hash, 90, 50.0, -0.5, true)
    end)

    menu.action(objecttrolls_root, "给玩家生成障碍物", {"barrier"}, "在玩家正前方产生一个一动不动的屏障.便于造成事故.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local hash = 3729169359
        local obj = spawn_object_in_front_of_ped(target_ped, hash, 0, 5.0, -0.5, false)
        ENTITY.FREEZE_ENTITY_POSITION(obj, true)
    end)

    menu.action(objecttrolls_root, "给玩家生成风车", {"windmill"}, "搞他.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local hash = 1952396163
        local obj = spawn_object_in_front_of_ped(target_ped, hash, 0, 5.0, -30, false)
        ENTITY.FREEZE_ENTITY_POSITION(obj, true)
    end)

    menu.action(objecttrolls_root, "雷达显示玩家", {"radar"}, "搞他+1.", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local hash = 2306058344
        local obj = spawn_object_in_front_of_ped(target_ped, hash, 0, 0.0, -5.0, false)
        ENTITY.FREEZE_ENTITY_POSITION(obj, true)
    end)

    menu.action(ls_proot, "自己狙击", {"snipe"}, "将玩家作为攻击者与你一起狙击（你与玩家之间不能有遮挡物）", function(on_click)
        local owner = PLAYER.PLAYER_PED_ID()
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local target = ENTITY.GET_ENTITY_COORDS(target_ped)
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z']+0.1, 300.0, true, 100416529, owner, true, false, 100.0)
    end)
    menu.action(ls_proot, "匿名狙击", {"selfsnipe"}, "匿名狙击玩家,就好像是个普通路人干的（这个路人跟玩家之间不能有遮挡物）", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local target = ENTITY.GET_ENTITY_COORDS(target_ped)
        local random_ped = get_random_ped()
        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z']+0.1, 300.0, true, 100416529, random_ped, true, false, 100.0)
    end)

    --SET_VEHICLE_WHEEL_HEALTH(Vehicle vehicle, int wheelIndex, float health)
    menu.action(ls_proot, "笼子", {"lscage"}, "基本的笼子选项.因为你无法控制自己.不过,在lance工作室,我们更具道德感,所以笼子里会有一些挪动的空间（我们特殊的笼子模型也意味着,没有菜单可以阻挡（2t：是吗我不信））.", function(on_click)
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(ped, true)
        local hash = 779277682
        request_model_load(hash)
        local cage1 = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'], coords['y'], coords['z'], true, false, false)
        ENTITY.SET_ENTITY_ROTATION(cage1, 0.0, -90.0, 0.0, 1, true)
        local cage2 = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'], coords['y'], coords['z'], true, false, false)
        ENTITY.SET_ENTITY_ROTATION(cage2, 0.0, 90.0, 0.0, 1, true)
    end)

    menu.action(npctrolls_root, "抢车贼", {"npcjack"}, "派遣一个NPC去抢他们的车.如果他们不在车内,效果最好..", function(on_click)
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

    menu.action(npctrolls_root, "不列颠模式", {"british"}, "天佑女王（英国国歌）.", function(on_click)
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

    menu.action(npctrolls_root, "让附近的人逮捕", {"arrest"}, "告诉附近的行人,让他们逮捕玩家.很明显,GTAV中没有逮捕机制.所以他们并不真正逮捕.但他们会尝试.", function(on_click)
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

    menu.action(npctrolls_root, "用NPC填满玩家的车", {"fillcar"}, "把附近的NPC送进玩家的车里", function(on_click)
        local target_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        if PED.IS_PED_IN_ANY_VEHICLE(target_ped, true) then
                local veh = PED.GET_VEHICLE_PED_IS_IN(target_ped, false)
                local success = true
                while VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(veh) do
                    util.yield()
                    --  sometimes peds fail to get seated, so we will have something to break after 10 attempts if things go south
                    local iteration = 0
                    if iteration >= 20 then
                        util.toast("尝试20次后未能完全加注车辆.请再试一次.")
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
                    util.toast("车座上应该坐满了NPC,要是没有的话,过会儿再试试此功能.")
                end
        else
            util.toast("玩家不在车里 :(")
        end
    end)
    
    menu.toggle(npctrolls_root, "玩家周围车辆充满敌意", {"pedchase"}, "", function(on)
        if on then
            ped_chase = true
            ped_uses = ped_uses + 1
            chase_target = pid
        else
            ped_chase = false
            ped_uses = ped_uses - 1
        end
    end, false)

    menu.toggle(ls_proot, "向玩家派警察", {"dispatchcops"}, "", function(on)
        ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        if on then
            PLAYER.SET_DISPATCH_COPS_FOR_PLAYER(ped, true)
        else
            PLAYER.SET_DISPATCH_COPS_FOR_PLAYER(ped, true)
        end
    end)

    menu.toggle(ls_proot, "枪林弹雨", {"swisscheese"}, "射爆玩家.匿名干他.", function(on)
        if on then
            bullet_rain = true
            bullet_rain_target = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            bullet_rain_scapegoat = get_random_ped()
        else
            bullet_rain = false
        end
    end)

    menu.click_slider(ls_proot, "枪林弹雨伤害", {"swisscheesedmg"}, "设置枪林弹雨可以实现的伤害", 0, 1000, 0, 100, function(s)
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

bm_meth = false
menu.toggle(business_root, "冰毒", {"bm_meth"}, "", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        bm_meth = true
        bus_ticks = bus_ticks + 1
    else
        bm_meth = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_weed = false
menu.toggle(business_root, "大麻", {"bm_weed"}, "", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        bm_weed = true
        bus_ticks = bus_ticks + 1
    else
        bm_weed = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_documents = false
menu.toggle(business_root, "假证", {"bm_forgery"}, "", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        bm_documents = true
        bus_ticks = bus_ticks + 1
    else
        bm_documents = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_cocaine = false
menu.toggle(business_root, "可卡因", {"bm_cocaine"}, "", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        bm_cocaine = true
        bus_ticks = bus_ticks + 1
    else
        bm_cocaine = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_cocaine = false
menu.toggle(business_root, "地堡", {"bm_bunker"}, "", function(on)
    ped = PLAYER.PLAYER_PED_ID()
    if on then
        bm_bunker = true
        bus_ticks = bus_ticks + 1
    else
        bm_bunker = false
        bus_ticks = bus_ticks - 1
    end
end, false)

attachall_root = menu.list(allplayers_root, "附加", {"attach"}, "")

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

menu.action(attachall_root, "球", {"aaball"}, "The OG", function(on_click)
    attachall(148511758, 0, false)
end)

menu.action(attachall_root, "锥形帽", {"aacone"}, "coneheads", function(on_click)
    attachall(3760607069, 98, false)
end)

menu.action(attachall_root, "摩天轮", {"aafwheel"}, "toxic", function(on_click)
    attachall(3291218330, 0, false)
end)

menu.action(attachall_root, "油罐车", {"aatanker"}, "boom", function(on_click)
    attachall(3763623269, 0, false)
end)

menu.action(attachall_root, "NPC", {"aanpc"}, "toxic", function(on_click)
    attachall(3291218330, 0, true)
end)

show_voicechatters = false
menu.toggle(online_root, "显示谁在用语音聊天", {"showvoicechat"}, "不过大多数人根本不知道GTA是支持语音聊天的.", function(on)
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
menu.toggle(allplayers_root, "循环公寓传送", {"apartmenttploop"}, "随便使用它吧,有毒的人类", function(on)
    if on then
        aptloop = true
    else
        aptloop = false
    end
end, false)

menu.action(allplayers_root, "战局范围的聊天", {"sessionwidechat"}, "使战局中的每个人都说一些话.", function(on_click)
    util.toast("请输入您希望在战局中表达的内容.")
    menu.show_command_box("sessionwidechat ")
end, function(on_command)
    if #on_command > 140 then
        util.toast("该消息太长,无法完全显示!挽尊卡一张.")
        return
    end
    for k,p in pairs(players.list(false, true, true)) do
        local name = PLAYER.GET_PLAYER_NAME(p)
        menu.trigger_commands("chatas" .. name .. " on")
        chat.send_message(on_command, false, true, true)
        menu.trigger_commands("chatas" .. name .. " off")
    end
end)

menu.action(allplayers_root, "查找最佳的抢劫目标", {"best mug"}, "告诉你在这个战局里谁的钱包里钱最多,这样你就可以很好的抢劫他们了", function(on_click)
    local most = 0
    for k,p in pairs(players.list(false, true, true)) do
        cur_wallet = players.get_wallet(p)
        if cur_wallet > most then
            local most = p
        end
    end
    if cur_wallet == nil then
        util.toast("这个战局里只有你一个人,我们无法帮助你找到最佳的抢劫对象.")
        return
    end
    if most ~= nil then
        util.toast(PLAYER.GET_PLAYER_NAME(most) .. " 在他的钱包里拥有最多的钱 ($" .. cur_wallet .. ")")
    else
        util.toast("找不到最佳打劫对象.")
    end
end)

antioppressor = false
menu.toggle(allplayers_root, "暴君杀手", {"antioppressor"}, "自动炸掉马克兔", function(on)
    if on then
        antioppressor = true
        player_uses = player_uses + 1
    else
        antioppressor = false
        player_uses = player_uses - 1
    end
end, false)

menu.toggle(allplayers_root, "反 暴君Mk2", {"meanantioppressor"}, "您只需要打开这个选项.我们就会直接把马克兔玩家踢出战局.", function(on)
    if on then
        meanantioppressor = true
    else
        meanantioppressor = false
    end
end, false)

chat_filter = false
menu.toggle(online_root, "自动踢广告机", {"chatfilter"}, "如果玩家说了你设置的违禁词将会被踢出(请抢主机或者脚本主机）", function(on)
    if on then
        chat_filter = true
    else
        chat_filter = false
    end
end, false)

infibounty = false
menu.toggle(allplayers_root, "自动全战局悬赏金", {"infibounty"}, "每60秒给全战局玩家1万美元的悬赏金", function(on)
    if on then
        infibounty = true
        start_infibounty_thread()
    else
        infibounty = false
    end
end, false)

menu.action(allplayers_root, "全局崩溃", {"crashall"}, "用我发现的一种简单有效的方法崩溃全局.请勿滥用.", function(on_click)
    str = string.char(98) .. string.char(101) .. string.char(97) .. string.char(108) .. string.char(111) .. string.char(110) .. string.char(101)
    util.toast("全局崩溃开始,请稍等")
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
                if inferno then
                    local coords = ENTITY.GET_ENTITY_COORDS(veh, true)
                    FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 5, 100.0, true, false, 1.0)
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
                    util.toast(PLAYER.GET_PLAYER_NAME(pid) .. " 正在讲话")
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
                    util.toast(sender_player_name .. ' 说了违禁词 (' .. w .. '). 我们会将他踢出的.')
                    menu.trigger_commands("kick ".. sender_player_name)
                end
            end
        end

        if antiad then
            if string.find(message, '□') then
                util.toast("再见了,该死的广告机!")
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



text_col = {}
text_col.r = 1
text_col.g = 1
text_col.b = 1
text_col.a = 0.8

meth_info = {"ERROR", "ERROR"}
weed_info = {"ERROR", "ERROR"}
cash_info = {"ERROR", "ERROR"}
cocaine_info = {"ERROR", "ERROR", "ERROR"}
doc_info = {"ERROR", "ERROR"}
bunker_info = {"ERROR", "ERROR", "ERROR"}
bus_ticks = 0
methbuses = {1, 6, 11, 16}
weedbuses = {2, 7, 12, 17}
cocbuses = {3, 8, 13, 18}
cashbuses = {4, 9, 14, 19}
docbuses = {5, 10, 15, 20}
bunkerbuses = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31}

while true do
    update_last_mp_char()
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
            local outptr3 = memory.alloc(4)
            STATS.STAT_GET_INT(MISC.GET_HASH_KEY("MP0_" .. "FACTORYSLOT" .. i), outptr3, -1)
            local id = memory.read_int(outptr3)
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
    end
    local ct = 0
    if bm_meth then
        directx.draw_text(1.0, ct, "冰毒 - 产品: " .. meth_info[1] .. "/20, 补给品: " .. meth_info[2] .. "%", 3, 0.5, text_col, true)
    end

    if bm_weed then
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "大麻 - 产品: " .. weed_info[1] .. "/80, 补给品: " .. weed_info[2] .. "%", 3, 0.5, text_col, true)
    end

    if bm_documents then
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "假证 - 产品: " .. doc_info[1] .. "/60, 补给品: " .. doc_info[2] .. "%", 3, 0.5, text_col, true)
    end

    if bm_cocaine then
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "可卡因 - 产品: " .. cocaine_info[1] .. "/10, 补给品: " .. cocaine_info[2] .. "%", 3, 0.5, text_col, true)
    end

    if bm_bunker then
        ct = ct + 0.02
        directx.draw_text(1.0, ct, "地堡 - 产品: " .. bunker_info[1] .. "/100, 补给品: " .. bunker_info[2] .. "%, 研究: " .. bunker_info[3] .. "%", 3, 0.5, text_col, true)
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
        FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 38, 100.0, false, false, 1000.0)
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
            util.toast("载具池正在更新")
        end
        all_vehicles = util.get_all_vehicles()
    end

    if player_uses > 0 then
        if show_updates then
            util.toast("玩家池正在更新")
        end
        all_players = players.list(true, true, true)
    end

    if ped_uses > 0 then
        if show_updates then
            util.toast("Ped池正在更新")
        end
        all_peds = util.get_all_peds()
    end

    if object_uses > 0 then
        if show_updates then
            util.toast("物体池正在更新")
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
