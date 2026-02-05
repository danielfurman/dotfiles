--- === AppWindowSwitcher Tests ===
---
--- Minimal self-tests for AppWindowSwitcher match logic.
---
--- Run in Hammerspoon console:
---   dofile(hs.configdir .. "/Spoons/AppWindowSwitcher.spoon/tests.lua")
---   AppWindowSwitcherTests.runAll()

local AppWindowSwitcherTests = {}
local fakeWindow

function AppWindowSwitcherTests.runAll()
    local ok, failures = AppWindowSwitcherTests.runMatchTests()
    if ok then
        print("AppWindowSwitcher tests: ok")
    else
        print("AppWindowSwitcher tests: failed - " .. table.concat(failures, ", "))
    end
    return ok, failures
end

function AppWindowSwitcherTests.runMatchTests()
    local cases = {
        {
            name = "bundleID match",
            window = fakeWindow("com.apple.Terminal", "Terminal"),
            matchtexts = {"com.apple.Terminal"},
            want = true,
        },
        {
            name = "title prefix match",
            window = fakeWindow("com.apple.Safari", "Safari"),
            matchtexts = {"Saf"},
            want = true,
        },
        {
            name = "no match",
            window = fakeWindow("com.apple.Safari", "Safari"),
            matchtexts = {"com.apple.Terminal", "Fire"},
            want = false,
        },
        {
            name = "nil app",
            window = { application = function() return nil end },
            matchtexts = {"com.apple.Terminal"},
            want = false,
        },
    }

    local failures = {}
    for _, testCase in ipairs(cases) do
        local got = spoon.AppWindowSwitcher.match(testCase.window, testCase.matchtexts)
        if got ~= testCase.want then
            table.insert(failures, testCase.name)
        end
    end

    if #failures > 0 then
        return false, failures
    end

    return true, {}
end

fakeWindow = function(bundleID, title)
    local app = {
        bundleID = function() return bundleID end,
        title = function() return title end,
    }
    return {
        application = function() return app end,
    }
end

_G.AppWindowSwitcherTests = AppWindowSwitcherTests

return AppWindowSwitcherTests
