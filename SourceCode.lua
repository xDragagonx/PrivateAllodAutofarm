-- counter keeps adding to targets when mounting || Solved, was using https://alloder.pro/md/LuaApi/FunctionCommonUnRegisterEventHandler.html instead of https://alloder.pro/md/LuaApi/FunctionCommonUnRegisterEvent.html, so it would always register still. Ask pasidaips how it works with the if name == gift of tensess.
-- Make it only work when out of combat
--Use common.LogInfo("common", "-"..name.."-") --Log to mods.txt
--Use tostring() to concatenate non-string values in ChatLog()
-- Solved:
--  Error while running the chunk
--   [string "Mods/Addons/RessCounter/Script.luac"]:0: attempt to perform arithmetic on a nil value
--   func: __sub, metamethod, line: -1, defined: C, line: -1, [C]
--     func: ?, ?, line: 0, defined: Lua, line: 0, [string "Mods/Addons/RessCounter/Script.luac"]

--VARIABLES
local hornId

function Main()
	GetDetectedObjects()
	local inUsageRange = object.IsInUsageRange( hornId )
	ChatLog(hornId, object.GetName(hornId), inUsageRange)
	--common.RegisterEventHandler(EVENT_TALK_STARTED,"EVENT_TALK_STARTED")
	common.RegisterEventHandler(EVENT_CONTEXT_ACTIONS_CHANGED,"EVENT_CONTEXT_ACTIONS_CHANGED")

end
function EVENT_CONTEXT_ACTIONS_CHANGED()
	
end

function EVENT_TALK_STARTED()
	local talkToHorn = avatar.GetInteractorNextCues()
	if talkToHorn[0] then
		local answer = userMods.FromWString(talkToHorn[0].name)
		if answer ~= "Stop production" then
			ChatLog("Selecting name (embrium)")
			avatar.SelectInteractorCue(0);
		end
	end

	local hornPage2 = avatar.GetInteractorNextCues()
	if hornPage2[0] then
		--ChatLog("hornpage2",hornPage2)
		local answer = userMods.FromWString(hornPage2.name)
		--ChatLog("answer:",answer)
		if answer ~= "Stop production" then
			avatar.SelectInteractorCue(0);
			ChatLog("We picked 'produce embrium'")
		end
	end
end

function GetDetectedObjects()
	local detectedObjects = avatar.GetDetectedObjects()
	for k, v in pairs( detectedObjects ) do
		local objectName = userMods.FromWString(object.GetName(v))
		--ChatLog(objectName)
		if objectName == "Embrium Convertor" then
			hornId = v
			--ChatLog(objectName, hornId)
			break
		end
	end
end



if (avatar.IsExist()) then
	ChatLog("Loaded.")
	Main()
else
	ChatLog("Loaded.")
	common.RegisterEventHandler(Main, "EVENT_AVATAR_CREATED")
end