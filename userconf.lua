-- km.luakit.conf: My configuration of Luakit Web Browser
-- Copyright (c) 2019 Kazuki Maeda <kmaeda@kmaeda.net>

local settings = require("settings")
local lousy = require("lousy")
local completion = require("completion")
local keysym = require("keysym")

-- always accept cookie
soup.accept_policy = "always"

-- clear history
local history = require("history")
history.add = function(uri, title, update_visits)
   -- do nothing
end

-- tab number
lousy.widget.tab.label_format = '<span foreground="{index_fg}" font="Monospace">{index} </span>{title}'

-- follow
local follow = require("follow")
local select = require("select")
-- hint label
select.label_maker = function ()
   local chars = charset("asdfghjkl")
   return trim(sort(reverse(chars)))
end
-- Match only hint label text
follow.pattern_maker = follow.pattern_styles.match_label
follow.stylesheet = [===[
#luakit_select_overlay {
    position: absolute;
    left: 0;
    top: 0;
    z-index: 2147483647; /* Maximum allowable on WebKit */
}

#luakit_select_overlay .hint_overlay {
    display: block;
    position: absolute;
    background-color: #ffff99;
    border: 1px dotted #000;
    opacity: 0.3;
}

#luakit_select_overlay .hint_label {
    display: block;
    position: absolute;
    background-color: #000088;
    border: 1px dashed #000;
    color: #fff;
    font-size: 14px;
    font-family: monospace, courier, sans-serif;
    opacity: 0.6;
}

#luakit_select_overlay .hint_selected {
    background-color: #00ff00 !important;
}
]===]

-- key binds (Emacs like)
local modes = require("modes")
modes.remove_binds("normal", {"j", "k", "h", "l", "^", "$", "i", "w", "y", "Y", "M", "u", "%",
                              "gg", "zi", "zo", "zz", "pp", "pt", "pw", "pp", "PP", "PT", "PW",
                              "gT", "gt", "g0", "g$", "gH", "gh", "gy", "ZZ", "ZQ",
                              "<Control-f>", "<Control-b>",
                              "<Control-e>", "<Control-y>", "<Control-d>", "<Control-u>",
                              "<Control-o>", "<Control-i>", "<Control-a>", "<Control-x>",
                              "<Control-w>", "<Control-c>", "<Control-z>", "<Control-R>",
                              "<Shift-h>", "<Shift-l>", "<Shift-w>", "<Shift-j>", "<Shift-k>",
                              "<Shift-d>"})
modes.remove_binds("insert", {"<Control-e>", "<Control-z>"})
-- from binds.lua
local actions = { zoom = {
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
                   {"<Control-g>", "Return to `normal` mode.",
                     function (w)
                        if not w:is_mode("passthrough") then w:set_prompt(); w:set_mode() end
                        return not w:is_mode("passthrough")
                   end },
                   {"<Control-h>", "Backspace",
                    function (w) keysym.send(w, "<BackSpace>") end },
                   {"<Control-m>", "Return",
                    function (w) keysym.send(w, "<Return>") end },
                   {"<Control-b>", "Left",
                    function (w) keysym.send(w, "<Left>") end },
                   {"<Control-f>", "Right",
                    function (w) keysym.send(w, "<Right>") end },
                   {"<Control-p>", "Up",
                    function (w) keysym.send(w, "<Up>") end },
                   {"<Control-n>", "Down",
                    function (w) keysym.send(w, "<Down>") end },
                   {"<Control-w>", "Cut",
                    function (w) keysym.send(w, "<Control-x>") end },
                   {"<Mod1-w>", "Copy",
                    function (w) keysym.send(w, "<Control-c>") end },
                   {"<Control-y>", "Paste",
                    function (w) keysym.send(w, "<Control-v>") end },
                   { "<Mouse2>", [[Open link under mouse cursor in new tab or navigate to the
                                   contents of `luakit.selection.primary`.]],
                     function (w, m)
                        -- Ignore button 2 clicks in form fields
                        if not m.context.editable then
                           -- Open hovered uri in new tab
                           local uri = w.view.hovered_uri
                           if uri then
                              w:new_tab(uri, { switch = false, private = w.view.private })
                           end
                        end
                     end
                   },
})
modes.add_binds("normal", {
                   {"<Control-g>", "Stop loading and close the prompt.",
                    function (w) w.view:stop(); w:set_prompt() end },
                   {"<Control-v>", "Scroll the current page down",
                    function (w) w:scroll{ ypagerel =  0.95 } end },
                   {"<Mod1-v>", "Scroll the current page up",
                    function (w) w:scroll{ ypagerel =  -0.95 } end },
                   {"<space>", "Scroll the current page down",
                    function (w) w:scroll{ ypagerel =  0.95 } end },
                   {"<Shift-space>", "Scroll the current page up",
                    function (w) w:scroll{ ypagerel =  -0.95 } end },
                   {"<", "Scroll to the top of the document.",
                    function (w) w:scroll{ y =  0 } end },
                   {">", "Scroll to the end of the document.",
                    function (w) w:scroll{ y = -1 } end },
                   {"<Mod1-w>", "Copy current selection to clipboard.", function (w)
                       if luakit.selection.primary then
                          luakit.selection.clipboard = luakit.selection.primary
                          w:notify("Copy to clipboard: " .. luakit.selection.primary)
                       end
                   end },
                   {"<Control-Mod1-w>", "Copy to clipboard.", function (w)
                       local uri = string.gsub(w.view.uri or "", " ", "%%20")
                       luakit.selection.clipboard = uri
                       w:notify("Copy to clipboard: " .. uri)
                   end },
                   {"<Control-T>", "Undo closed tab (restoring tab history).",
                     function (w, m) w:undo_close_tab(-m.count) end, {count=1} },
                   {"<Control-Mod1-r>", "Restart luakit (reloading configs).",
                    function (w) w:restart() end },
                   {"<Control-q>", "Enter `passthrough` mode, ignores all luakit keybindings.",
                    function (w) w:set_mode("passthrough") end },
                   {"0", actions.zoom.zoom_set},
                   {"=", actions.zoom.zoom_in},
                   {"b", "Go back in the browser history `[count=1]` items.",
                    function (w, m) w:back(m.count) end },
                   {"f", "Go forward in the browser history `[count=1]` times.",
                    function (w, m) w:forward(m.count) end },
                   {"B", "Go back in the browser history `[count=1]` items.",
                    function (w, m) w:back(m.count) end },
                   {"F", "Go forward in the browser history `[count=1]` times.",
                    function (w, m) w:forward(m.count) end },
                   {"<BackSpace>", "Go back in the browser history `[count=1]` items.",
                    function (w, m) w:back(m.count) end },
                   {"^m$", [[Start `follow` mode. Hint all clickable elements
                            (as defined by the `follow.selectors.clickable`
                             selector) and open links in the current tab.]],
                    function (w)
                       w:set_mode("follow", {
                                     selector = "clickable", evaluator = "click",
                                     func = function (s) w:emit_form_root_active_signal(s) end,
                       })
                   end },
                   {"^M$", [[Start follow mode. Hint all links (as defined by the
                              `follow.selectors.uri` selector) and open links in a new tab.]],
                    function (w)
                       w:set_mode("follow", {
                                     prompt = "background tab", selector = "uri", evaluator = "uri",
                                     func = function (uri)
                                        assert(type(uri) == "string")
                                        w:new_tab(uri, { switch = false, private = w.view.private })
                                     end
                       })
                   end },
})
modes.add_binds("completion", {
                   {"<Control-g>", "Stop completion and restore original command.",
                    completion.exit_completion },
})
modes.add_binds("insert", {
                   {"<Control-q>", "Enter `passthrough` mode, ignores all luakit keybindings.",
                    function (w) w:set_mode("passthrough") end },
})
modes.add_binds("passthrough", {
                   {"<Control-g>", "Return to `normal` mode.",
                    function (w) w:set_prompt(); w:set_mode() end },
})
