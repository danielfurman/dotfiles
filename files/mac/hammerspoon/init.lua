-- Look for Spoons in ~/.hammerspoon/my-spoons as well
-- package.path = package.path .. ";" ..  hs.configdir .. "/my-spoons/?.spoon/init.lua"

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Audio input/output management

hs.loadSpoon("MicMute")
spoon.MicMute:bindHotkeys({
    toggle = {{"shift", "ctrl", "alt", "cmd"}, "a"}
}, 0.75)

local function setDefaultInputDevice(deviceName)
	local inputDevice = hs.audiodevice.findInputByName(deviceName)
	if inputDevice then
		local success = inputDevice:setDefaultInputDevice()
		if success then
			hs.notify.new({title="Hammerspoon", informativeText="Input set to " .. deviceName}):send()
		else
			hs.notify.new({title="Hammerspoon", informativeText="Failed to set input to " .. deviceName}):send()
		end
		return
	end
	hs.notify.new({title="Hammerspoon", informativeText="MacBook Pro mic not found"}):send()
end

hs.hotkey.bind({"shift", "ctrl", "alt", "cmd"}, "f", function()
	setDefaultInputDevice("MacBook Pro Microphone")
end)

local function toggleSpotifyPlayback()
	hs.spotify.playpause()
end

hs.hotkey.bind({"shift", "ctrl", "alt", "cmd"}, "s", function()
	toggleSpotifyPlayback()
end)

-- Window management

local secondaryScreenName = "DELL P2414H"

local function handleScreenChange()
	if hs.screen.find(secondaryScreenName) then
		applyWindowLayout()
	end
end

local function applyWindowLayout()
	local windowLayout = {
		{"Obsidian", nil, secondaryScreenName, hs.layout.maximized, nil, nil},
	}
	hs.layout.apply(windowLayout)
end

hs.hotkey.bind({"shift", "ctrl", "alt", "cmd"}, "w", applyWindowLayout)
local screenWatcher = hs.screen.watcher.new(handleScreenChange)
screenWatcher:start()
