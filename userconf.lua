-- km.luakit.conf: My configuration of Luakit Web Browser
-- Copyright (c) 2019 Kazuki Maeda <kmaeda@kmaeda.net>

local settings = require("settings")

-- clear history
local history = require("history")
history.init()
local function clearhistory()
   history.db:exec [[ DELETE FROM history ]]
end
clearhistory()

-- CSS of settings
local sc = require("settings_chrome")
sc.html_style = sc.html_style .. [[
.setting input {
    background-color: #000;
    color: #fff;
}
]]

-- key binds
local modes = require("modes")
local actions = { scroll = {
    up = {
        desc = "Scroll the current page up.",
        func = function (w, m) w:scroll{ yrel = -settings.get_setting("window.scroll_step")*(m.count or 1) } end,
    },
    down = {
        desc = "Scroll the current page down.",
        func = function (w, m) w:scroll{ yrel =  settings.get_setting("window.scroll_step")*(m.count or 1) } end,
    },
    left = {
        desc = "Scroll the current page left.",
        func = function (w, m) w:scroll{ xrel = -settings.get_setting("window.scroll_step")*(m.count or 1) } end,
    },
    right = {
        desc = "Scroll the current page right.",
        func = function (w, m) w:scroll{ xrel =  settings.get_setting("window.scroll_step")*(m.count or 1) } end,
    },
    page_up = {
        desc = "Scroll the current page up a full screen.",
        func = function (w, m) w:scroll{ ypagerel = -(m.count or 1) } end,
    },
    page_down = {
        desc = "Scroll the current page down a full screen.",
        func = function (w, m) w:scroll{ ypagerel =  (m.count or 1) } end,
    },
}, zoom = {
    zoom_in = {
        desc = "Zoom in to the current page.",
        func = function (w, m) w:zoom_in(settings.get_setting("window.zoom_step") * (m.count or 1)) end,
    },
    zoom_out = {
        desc = "Zoom out from the current page.",
        func = function (w, m) w:zoom_out(settings.get_setting("window.zoom_step") * (m.count or 1)) end,
    },
    zoom_set = {
        desc = "Zoom to a specific percentage when specifying a count, and reset the page zoom otherwise.",
        func = function (w, m)
            local zoom_level = m.count or settings.get_setting_for_view(w.view, "webview.zoom_level")
            w:zoom_set(zoom_level/100)
        end,
    },
}}
modes.add_binds("all", {
                   { "<Control-g>", "Return to `normal` mode.",
                     function (w)
                        if not w:is_mode("passthrough") then w:set_prompt(); w:set_mode() end
                        return not w:is_mode("passthrough")
                   end },
})
modes.add_binds("normal", {
                   {"<Control-p>", actions.scroll.up},
                   {"<Control-n>", actions.scroll.down},
                   {"<Control-f>", actions.scroll.left},
                   {"<Control-b>", actions.scroll.right},
                   {"<Mod1-v>", actions.scroll.page_up},
                   {"<Control-v>", actions.scroll.page_down},
                   {"<Control-0>", actions.zoom.zoom_set},
                   {"<Control-=>", actions.zoom.zoom_in},
                   {"o", "Open one or more URLs.",
                    function (w) clearhistory(); w:enter_cmd(":open ") end },
                   {"t", "Open one or more URLs in a new tab.",
                    function (w) clearhistory(); w:enter_cmd(":tabopen ") end },
                   {"O", "Open one or more URLs based on current location.",
                     function (w) clearhistory(); w:enter_cmd(":open " .. (w.view.uri or "")) end },
                   {"T", "Open one or more URLs based on current location in a new tab.",
                     function (w) clearhistory(); w:enter_cmd(":tabopen " .. (w.view.uri or "")) end },
                   {"B", "Go back in the browser history `[count=1]` items.", function (w, m) w:back(m.count) end },
                   {"F", "Go forward in the browser history `[count=1]` times.", function (w, m) w:forward(m.count) end },
})

modes.add_binds("passthrough", {
                   { "<Control-g>", "Return to `normal` mode.", function (w) w:set_prompt(); w:set_mode() end },
})
