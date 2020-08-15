local addon, ns = ...
local E, L, V, P, G, _ = unpack(ElvUI)
local AutoHideChat = E:NewModule('AutoHideChat')
local EP = LibStub("LibElvUIPlugin-1.0")

local RightChatPanel = 'RightChatPanel'
local LeftChatPanel = 'LeftChatPanel'

P['AutoHideChat'] = {
    ['dungeon'] = true,
    ['raid'] = true,
    ['arena'] = true,
    ['pvp'] = true,
    ['world'] = false,
    ['leftChat'] = true,
    ['rightChat'] = true
}

function AutoHideChat:GenerateOptions()
    E.Options.args.AutoHideChat = {
        order = 9010,
        type = 'group',
        name = "AutoHideChat",
        args = {
            name = {
                order = 1,
                type = "header",
                name = "Automatic Chat Hider",
            },
            desc = {
                order = 2,
                type = "description",
                name = "Automatically hides the chat panels with entering combat.",
            },
            spacer1 = {
                order = 3,
                type = "description",
                name = "",
            },
            apartylog = {
                order = 4,
                type = "group",
                name = "AutoHideChat Options",
                guiInline = true,
                args = {
                    spacer2 = {
                        order = 1,
                        type = "description",
                        name = "Select combat triggers to hide the Chat Panels:",
                    },
                    party = {
                        order = 2,
                        name = "Dungeon",
                        desc = "Hide when entering Dungeon combat.",
                        type = 'toggle',
                        get = function(info)
                            return E.db.AutoHideChat[info[#info]]
                        end,
                        set = function(info, value)
                            E.db.AutoHideChat[info[#info]] = value;
                        end,
                    },
                    raid = {
                        order = 3,
                        name = "Raid",
                        desc = "Hide when entering Raid combat.",
                        type = 'toggle',
                        get = function(info)
                            return E.db.AutoHideChat[info[#info]]
                        end,
                        set = function(info, value)
                            E.db.AutoHideChat[info[#info]] = value;
                        end,
                    },
                    arena = {
                        order = 4,
                        name = "Arena",
                        desc = "Hide when entering Arena combat.",
                        type = 'toggle',
                        get = function(info)
                            return E.db.AutoHideChat[info[#info]]
                        end,
                        set = function(info, value)
                            E.db.AutoHideChat[info[#info]] = value;
                        end,
                    },
                    pvp = {
                        order = 5,
                        name = "PvP",
                        desc = "Hide when entering PvP combat.",
                        type = 'toggle',
                        get = function(info)
                            return E.db.AutoHideChat[info[#info]]
                        end,
                        set = function(info, value)
                            E.db.AutoHideChat[info[#info]] = value;
                        end,
                    },
                    world = {
                        order = 6,
                        name = "World",
                        desc = "Hide when entering World combat.",
                        type = 'toggle',
                        get = function(info)
                            return E.db.AutoHideChat[info[#info]]
                        end,
                        set = function(info, value)
                            E.db.AutoHideChat[info[#info]] = value;
                        end,
                    },
                    spacer3 = {
                        order = 7,
                        type = "description",
                        name = "Select which panel(s) to hide:",
                    },
                    leftChat = {
                        order = 8,
                        name = "Left Chat Panel",
                        desc = "Hide left chat when above conditions are met.",
                        type = 'toggle',
                        get = function(info)
                            return E.db.AutoHideChat[info[#info]]
                        end,
                        set = function(info, value)
                            E.db.AutoHideChat[info[#info]] = value;
                        end,
                    },
                    rightChat = {
                        order = 9,
                        name = "Right Chat Panel",
                        desc = "Hide right chat when above conditions are met.",
                        type = 'toggle',
                        get = function(info)
                            return E.db.AutoHideChat[info[#info]]
                        end,
                        set = function(info, value)
                            E.db.AutoHideChat[info[#info]] = value;
                        end,
                    }
                },
            },
        },
    }
end

function AutoHideChat:Initialize()
    EP:RegisterPlugin(addon, AutoHideChat.GenerateOptions)
end

--[[
    == nil = Chat Panel Shown
    ~= nil = Chat Panel Hidden
]]
local function IsPanelHidden(name)
    return E.db[name .. "Faded"] ~= nil
end

local AutoHideChatCheck = CreateFrame("Frame")

AutoHideChatCheck:RegisterEvent("PLAYER_REGEN_ENABLED") --Leaving Combat
AutoHideChatCheck:RegisterEvent("PLAYER_REGEN_DISABLED") --Entering Combat

local function HideBothChats()
    if not IsPanelHidden(RightChatPanel) and E.db.AutoHideChat.rightChat then
        HideRightChat()
    end
    if not IsPanelHidden(LeftChatPanel) and E.db.AutoHideChat.leftChat then
        HideLeftChat()
    end
end

local function ShowBothChats()
    if IsPanelHidden(RightChatPanel) then
        HideRightChat()
    end
    if IsPanelHidden(LeftChatPanel) then
        HideLeftChat()
    end
end

AutoHideChatCheck:SetScript("OnEvent", function(self, event, ...)
    local inInstance, instanceType = IsInInstance()
    if event == "PLAYER_REGEN_DISABLED" then
        if (inInstance) then
            if instanceType == "pvp" and E.db.AutoHideChat.pvp then
                HideBothChats()
            elseif instanceType == "arena" and E.db.AutoHideChat.arena then
                HideBothChats()
            elseif instanceType == "party" and E.db.AutoHideChat.party then
                HideBothChats()
            elseif instanceType == "raid" and E.db.AutoHideChat.raid then
                HideBothChats()
            end
        elseif (instanceType == "none" or instanceType == nil) and E.db.AutoHideChat.world then
            HideBothChats()
        end
    elseif (event == "PLAYER_REGEN_ENABLED") then
        ShowBothChats()
    end
end)

--local Autologcheck = CreateFrame("Frame")
--Autologcheck:RegisterEvent("PLAYER_ENTERING_WORLD")
--Autologcheck:RegisterEvent("PLAYER_LOGOUT")
--Autologcheck:SetScript("OnEvent", function(self, event,...)
--	if event == "PLAYER_LOGOUT" then
--		LoggingCombat(0)
--		DEFAULT_CHAT_FRAME:AddMessage("AutoLog: Combat log disabled due to logout.")
--	else
--		local inInstance, instanceType = IsInInstance()
--		local loggingCombat = LoggingCombat()
--		if(instanceType == "raid" and E.db.AutoLog.raid and not loggingCombat) then
--			LoggingCombat(1)
--			DEFAULT_CHAT_FRAME:AddMessage("AutoLog: Combat log enabled.")
--		elseif(instanceType == "party" and E.db.AutoLog.party and not loggingCombat) then
--			LoggingCombat(1)
--			DEFAULT_CHAT_FRAME:AddMessage("AutoLog: Combat log enabled.")
--		elseif(instanceType == "none" and loggingCombat) then
--			LoggingCombat(0)
--			DEFAULT_CHAT_FRAME:AddMessage("AutoLog: Combat log disabled.")
--		end
--	end
--end)

E:RegisterModule(AutoHideChat:GetName())
