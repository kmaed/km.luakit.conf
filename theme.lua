--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

-- Default settings
theme.font = "12px M+ 1mn"
theme.fg   = "#f6f3e8"
theme.bg   = "#242424"

-- Genaral colours
theme.success_fg = "#0f0"
theme.loaded_fg  = "#33AADD"
theme.error_fg = "#FFF"
theme.error_bg = "#F00"

-- Warning colours
theme.warning_fg = "#F00"
theme.warning_bg = "#FFF"

-- Notification colours
theme.notif_fg = "#444"
theme.notif_bg = "#FFF"

-- Menu colours
theme.menu_fg                   = "#f6f3e8"
theme.menu_bg                   = "#242424"
theme.menu_selected_fg          = "#f6f3e8"
theme.menu_selected_bg          = "#444444"
theme.menu_title_bg             = "#000000"
theme.menu_primary_title_fg     = "#8888ff"
theme.menu_secondary_title_fg   = "#666"

theme.menu_disabled_fg = "#999"
theme.menu_disabled_bg = theme.menu_bg
theme.menu_enabled_fg = theme.menu_fg
theme.menu_enabled_bg = theme.menu_bg
theme.menu_active_fg = "#060"
theme.menu_active_bg = theme.menu_bg

-- Proxy manager
theme.proxy_active_menu_fg      = '#000'
theme.proxy_active_menu_bg      = '#FFF'
theme.proxy_inactive_menu_fg    = '#888'
theme.proxy_inactive_menu_bg    = '#FFF'

-- Statusbar specific
theme.sbar_fg         = "#f6f3e8"
theme.sbar_bg         = "#242424"

-- Downloadbar specific
theme.dbar_fg         = "#f6f3e8"
theme.dbar_bg         = "#242424"
theme.dbar_error_fg   = "#F00"

-- Input bar specific
theme.ibar_fg           = "#f6f3e8"
theme.ibar_bg           = "#242424"

-- Tab label
theme.tab_fg            = "#838383"
theme.tab_bg            = "#393f3f"
theme.tab_hover_bg      = "#484848"
theme.tab_ntheme        = "#ddd"
theme.selected_fg       = "#d3d7cf"
theme.selected_bg       = "#555753"
theme.selected_ntheme   = "#ddd"
theme.loading_fg        = "#fad43a"
theme.loading_bg        = "#000000"

theme.selected_private_tab_bg = "#3d295b"
theme.private_tab_bg    = "#22254a"

-- Trusted/untrusted ssl colours
theme.trust_fg          = "#0F0"
theme.notrust_fg        = "#F00"

-- General colour pairings
theme.ok = { fg = theme.ibar_fg, bg = theme.ibar_bg }
theme.warn = { fg = theme.ibar_fg, bg = theme.ibar_bg }
theme.error = { fg = theme.ibar_fg, bg = theme.ibar_bg }

return theme

-- vim: et:sw=4:ts=8:sts=4:tw=80
