-- {{{ License
--
-- Awesome configuration, using awesome 3.4 on Arch GNU/Linux
--   * Adrian C. <anrxc@sysphere.org>

-- Screenshot: http://sysphere.org/gallery/snapshots

-- This work is licensed under the Creative Commons Attribution Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Libraries
require("awful")
require("awful.rules")
require("awful.autofocus")
-- User libraries
require("vicious")
require("teardrop")
require("scratchpad")
require("eminent")
require("beautiful")
-- }}}


-- {{{ Variable definitions
--
-- Beautiful theme
beautiful.init(awful.util.getdir("config") .. "/zenburn.lua")
--beautiful.init("/usr/share/awesome/themes/lunar/theme.lua")

-- Modifier keys
local altkey = "Mod1" -- Super_L
local modkey = "Mod4" -- Alt_L

-- Function aliases
local exec  = awful.util.spawn
local sexec = awful.util.spawn_with_shell

-- Window management layouts
local layouts = {
    awful.layout.suit.tile,        -- 1
    awful.layout.suit.tile.left,   -- 2
    awful.layout.suit.tile.bottom, -- 3
    awful.layout.suit.tile.top,    -- 4
    awful.layout.suit.max,         -- 5
    awful.layout.suit.magnifier,   -- 6
    awful.layout.suit.floating     -- 7
}
-- }}}


-- {{{ Tags
local tags = {}
tags.setup = {
    { name = "zsh",  layout = layouts[3]  },
    { name = "vim",     layout = layouts[2] },
    { name = "ssh", layout = layouts[3]  },
    { name = "http",   layout = layouts[6]  },
    { name = "mail",  layout = layouts[6]  ,mwfact = 0.85 },
    { name = "do",     layout = layouts[3] },
    { name = "media",    layout = layouts[5] },
    { name = "office",   layout = layouts[3]  },
    { name = "misc", layout = layouts[1]  }
}

for s = 1, screen.count() do
    tags[s] = {}
    for i, t in ipairs(tags.setup) do
        tags[s][i] = tag({ name = t.name })
        tags[s][i].screen = s
        awful.tag.setproperty(tags[s][i], "layout", t.layout)
        awful.tag.setproperty(tags[s][i], "mwfact", t.mwfact)
        awful.tag.setproperty(tags[s][i], "hide",   t.hide)
    end
    tags[s][1].selected = true
end
-- }}}


-- {{{ Autostart
exec("run_once urxvtd")
-- }}}


-- {{{ Wibox
--
-- {{{ Widgets configuration
--
-- {{{ Reusable separators
local spacer    = widget({ type = "textbox" })
local separator = widget({ type = "textbox" })
spacer.text     = " "
separator.text  = "|"
-- }}}

-- {{{ CPU usage and temperature
local cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
local tempicon = widget({ type = "imagebox" })
tempicon.image = image(beautiful.widget_temp)
--

---- Initialize widgets
local tzswidget = widget({ type = "textbox" })
local cpugraph = awful.widget.graph()
---- Graph properties
cpugraph:set_width(26)
cpugraph:set_height(10)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_color(beautiful.fg_end_widget)
cpugraph:set_gradient_angle(0)
cpugraph:set_gradient_colors({ beautiful.fg_end_widget,
    beautiful.fg_center_widget, beautiful.fg_widget })
awful.widget.layout.margins[cpugraph.widget] = { top = 2, bottom = 2 }
--- Register widgets
vicious.register(cpugraph,  vicious.widgets.cpu,     "$1", 3)
vicious.register(tzswidget, vicious.widgets.thermal, "$1°C", 19, "thermal_zone0", "core")
---- }}}
--
-- {{{ Battery state
local baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
-- Initialize widget
batwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
-- }}}
--
-- {{{ Memory usage
local memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
-- Initialize widget
local membar = awful.widget.progressbar()
-- Pogressbar properties
membar:set_width(8)
membar:set_height(10)
membar:set_vertical(true)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_border_color(nil)
membar:set_color(beautiful.fg_widget)
membar:set_gradient_colors({ beautiful.fg_widget,
    beautiful.fg_center_widget, beautiful.fg_end_widget })
awful.widget.layout.margins[membar.widget] = { top = 2, bottom = 2 }
-- Register widget
vicious.register(membar, vicious.widgets.mem, "$1", 13)
-- }}}
--
---- {{{ Uptime and Load
uptimewidget = widget({ type = "textbox" })
loadwidget = widget({ type = "textbox" })
--
vicious.register(uptimewidget, vicious.widgets.uptime, "$2h")
vicious.register(loadwidget, vicious.widgets.uptime, "$4 $5 $6")
---- }}}
--
--
---- {{{ File system usage
local fsicon = widget({ type = "imagebox" })
fsicon.image = image(beautiful.widget_fs)
---- Initialize widgets
local fs = {
  r = awful.widget.progressbar(),  h = awful.widget.progressbar(),
  s = awful.widget.progressbar(),
 -- b = awful.widget.progressbar()
}
---- Progressbar properties
for _, w in pairs(fs) do
  w:set_width(5)
  w:set_height(12)
  w:set_vertical(true)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_border_color(beautiful.border_widget)
  w:set_color(beautiful.fg_widget)
  w:set_gradient_colors({ beautiful.fg_widget,
    beautiful.fg_center_widget, beautiful.fg_end_widget })
  awful.widget.layout.margins[w.widget] = { top = 1, bottom = 1 }
  -- Register buttons
  w.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("rox", false) end)
 ))
end
---- Enable caching
vicious.cache(vicious.widgets.fs)
---- Register widgets
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}")
vicious.register(fs.h, vicious.widgets.fs, "${/home used_p}")
vicious.register(fs.s, vicious.widgets.fs, "${/home/cap/data used_p}")
--vicious.register(fs.b, vicious.widgets.fs, "${/mnt/backup used_p}",  599)
---- }}}
--
--{{ hdd temp
--local hddtempwidget = widget({ type = "textbox" })
--vicious.register(hddtempwidget, vicious.widgets.hddtemp, "${/dev/sda}", 19)


-- }}


-- {{{ Network usage
local dnicon = widget({ type = "imagebox" })
local upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)
-- Initialize widget
local netwidget = widget({ type = "textbox" })
-- Register widget
if 0==1 then
vicious.register(netwidget, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netdn_widget ..'">${eth0 down_kb}</span> <span color="'
  .. beautiful.fg_netup_widget ..'">${eth0 up_kb}</span>', 3)
else
vicious.register(netwidget, vicious.widgets.net, '<span color="'
  .. beautiful.fg_netdn_widget ..'">${wlan0 down_kb}</span> <span color="'
  .. beautiful.fg_netup_widget ..'">${wlan0 up_kb}</span>', 3)
end
-- }}}
-- {{{ Wireless
local wifiicon = widget({ type = "imagebox" })
wifiicon.image = image(beautiful.widget_sat)

local wifiwidget = widget({ type = "textbox" })
local ssidwidget = widget({ type = "textbox" })
vicious.register(wifiwidget, vicious.widgets.wifi, "${link}%", 7, "wlan0")
vicious.register(ssidwidget, vicious.widgets.wifi, "${ssid}", 17, "wlan0")


-- }}}


---- {{{ Mail subject
----local mailicon = widget({ type = "imagebox" })
----mailicon.image = image(beautiful.widget_mail)
---- Initialize widget
----local mailwidget = widget({ type = "textbox" })
---- Register widget
----vicious.register(mailwidget, vicious.widgets.mbox, "$1", 181, "/home/anrxc/mail/Inbox")
---- Register buttons
----mailwidget:buttons(awful.util.table.join(
----  awful.button({ }, 1, function () exec("urxvt -title Alpine -e alpine_exp") end)
----))
---- }}}
--
---- {{{ Org-mode agenda
----local orgicon = widget({ type = "imagebox" })
----orgicon.image = image(beautiful.widget_org)
------ Initialize widget
----local orgwidget = widget({ type = "textbox" })
------ Configure widget
----local orgmode = {
----  files = {
----    "/home/anrxc/.org/work.org",     "/home/anrxc/.org/index.org",
----    "/home/anrxc/.org/personal.org", "/home/anrxc/.org/computers.org"
----  },
----  color = {
----    past   = '<span color="'..beautiful.fg_urgent..'">',
----    today  = '<span color="'..beautiful.fg_normal..'">',
----    soon   = '<span color="'..beautiful.fg_widget..'">',
----    future = '<span color="'..beautiful.fg_netup_widget..'">'
----}}
---- Register widget
----vicious.register(orgwidget, vicious.widgets.org,
----  orgmode.color.past .. '$1</span>|' .. orgmode.color.today  .. '$2</span>|' ..
-- -- orgmode.color.soon .. '$3</span>|' .. orgmode.color.future .. '$4</span>',
----  601, orgmode.files)
---- Register buttons
----orgwidget:buttons(awful.util.table.join(
----  awful.button({ }, 1, function () exec("emacsclient --eval '(org-agenda-list)'") end),
----  awful.button({ }, 3, function () exec("emacsclient --eval '(make-remember-frame)'") end)
----))
---- }}}
--
---- {{{ Volume level
--local volicon = widget({ type = "imagebox" })
--volicon.image = image(beautiful.widget_vol)
---- Initialize widgets
--local volwidget = widget({ type = "textbox" })
--local volbar    = awful.widget.progressbar()
---- Progressbar properties
--volbar:set_width(8)
--volbar:set_height(10)
--volbar:set_vertical(true)
--volbar:set_background_color(beautiful.fg_off_widget)
--volbar:set_border_color(nil)
--volbar:set_color(beautiful.fg_widget)
--volbar:set_gradient_colors({ beautiful.fg_widget,
--    beautiful.fg_center_widget, beautiful.fg_end_widget })
--awful.widget.layout.margins[volbar.widget] = { top = 2, bottom = 2 }
---- Enable caching
--vicious.enable_caching(vicious.widgets.volume)
---- Register widgets
--vicious.register(volwidget, vicious.widgets.volume, "$1%", 2, "PCM")
--vicious.register(volbar,    vicious.widgets.volume, "$1",  2, "PCM")
---- Register buttons
--volbar.widget:buttons(awful.util.table.join(
--   awful.button({ }, 1, function () exec("kmix") end),
--   awful.button({ }, 2, function () exec("amixer -q sset Master toggle") end),
--   awful.button({ }, 4, function () exec("amixer -q sset PCM 2dB+") end),
--   awful.button({ }, 5, function () exec("amixer -q sset PCM 2dB-") end)
--)) volwidget:buttons( volbar.widget:buttons() )
---- }}}
--
-- {{{ Date and time
local dateicon = widget({ type = "imagebox" })
dateicon.image = image(beautiful.widget_date)
-- Initialize widget
datewidget = widget({ type = "textbox" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%b %d, %R", 61)
-- Register buttons
--datewidget:buttons(awful.util.table.join(
--  awful.button({ }, 1, function () exec("pylendar.py") end)
--))
-- }}}

-- {{{ System tray
local systray = widget({ type = "systray" })
-- }}}
-- }}}
--
--
--


-- {{{ Wibox initialisation
local wibox     = {}
local promptbox = {}
local layoutbox = {}
local taglist   = {}
local taskbar 	= {}
taglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev
))

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create a layoutbox
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))
	 
    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)
    -- Create the wibox
    wibox[s] = awful.wibox({      screen = s,
        fg = beautiful.fg_normal, height = 14,
        bg = beautiful.bg_normal, position = "top"
    })
    -- Add widgets to the wibox
    -- Create the wibox
    -- Add widgets to the wibox - order matters
    taskbar[s] = awful.wibox({ screen = s,
        fg = beautiful.fg_normal, height = 12,
        bg = beautiful.bg_normal, position = "bottom"
			})

    taskbar[s].widgets = { mytasklist[s], 
            layout = awful.widget.layout.horizontal.leftright}

    if s == 2 or screen.count() == 1 then
    wibox[s].widgets = {
        {   taglist[s],
            layoutbox[s],
            promptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
		s == screen.count() and systray or nil,
        spacer, datewidget, spacer ,dateicon,
		spacer, uptimewidget, spacer,
--        separator, volwidget, spacer, volbar.widget, volicon,
--       separator, spacer, orgwidget, orgicon,
--        separator, mailwidget, mailicon,
        separator, spacer, fs.s.widget, fs.h.widget, fs.r.widget, fsicon,
	    separator, upicon, netwidget, dnicon,
		separator, spacer, wifiwidget, spacer, wifiicon,
--	    ssidwidget, spacer,
        separator, spacer, membar.widget, spacer, memicon,
		separator, spacer, cpugraph.widget, spacer, cpuicon,
		spacer, loadwidget, spacer,
		separator, spacer, tzswidget, tempicon, 
      separator, spacer, batwidget, baticon,
        layout = awful.widget.layout.horizontal.rightleft
    }
	else
    wibox[s].widgets = {
        {   taglist[s],
            layoutbox[s],
            promptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
		s == screen.count() and systray or nil,
        datewidget, dateicon,
        layout = awful.widget.layout.horizontal.rightleft
    }
	end
end
-- }}}
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Client bindings
local clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}


-- {{{ Key bindings
--
-- {{{ Global keys
local globalkeys = awful.util.table.join(
    -- {{{ Applications
    awful.key({ modkey }, "t", function () exec("thunderbird") end),
    awful.key({ modkey }, "w", function () exec("firefox") end),
    awful.key({ modkey }, "Return",  function () exec("urxvtc") end),
	--    awful.key({ modkey }, "a", function () exec("urxvt -title Alpine -e alpine_exp") end),
--    awful.key({ modkey }, "g", function () sexec("GTK2_RC_FILES=~/.gtkrc-gajim gajim") end),
--    awful.key({ modkey }, "q", function () exec("emacsclient --eval '(make-remember-frame)'") end),
    -- }}}
--	Keyboard Layout change auf ThinkVantage
    awful.key({ }, "#156", function () exec("toggle_layout") end),
    -- {{{ Multimedia keys
--    awful.key({}, "#121", function () exec("pvol.py -m") end),
--    awful.key({}, "#122", function () exec("pvol.py -p -c -2") end),
--    awful.key({}, "#123", function () exec("pvol.py -p -c 2") end),
--    awful.key({}, "#232", function () exec("plight.py -s -a") end),
--    awful.key({}, "#233", function () exec("plight.py -s -a") end),
--    awful.key({}, "#244", function () exec("sudo /usr/sbin/pm-hibernate") end),
--    awful.key({}, "#150", function () exec("sudo /usr/sbin/pm-suspend") end),
--    awful.key({}, "#225", function () exec("pypres.py") end),
    -- }}}

    -- {{{ Prompt menus
    awful.key({ modkey }, "r", function ()
        awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen].widget,
            function (...) promptbox[mouse.screen].text = exec(unpack(arg), false) end,
            awful.completion.shell, awful.util.getdir("cache") .. "/history")
    end),
    awful.key({ altkey }, "F3", function ()
        awful.prompt.run({ prompt = "Dictionary: " }, promptbox[mouse.screen].widget,
            function (words)
                sexec("crodict "..words.." | ".."xmessage -timeout 10 -file -")
            end)
    end),
    awful.key({ altkey }, "F4", function ()
        awful.prompt.run({ prompt = "Run Lua code: " }, promptbox[mouse.screen].widget,
        awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
    end),
    -- }}}

    -- {{{ Awesome controls
    awful.key({ modkey, "Shift" }, "q", awesome.quit),
    awful.key({ modkey, "Ctrl" }, "r", function ()
        promptbox[mouse.screen].text = awful.util.escape(awful.util.restart())
    end),
    -- }}}

    -- {{{ Tag browsing
    awful.key({ modkey }, "Right",   awful.tag.viewnext),
    awful.key({ modkey }, "Left",   awful.tag.viewprev),
    awful.key({ modkey }, "Tab", awful.tag.history.restore),
    -- }}}

    -- {{{ Layout manipulation
    awful.key({ modkey }, "l",          function () awful.tag.incmwfact(0.05) end),
    awful.key({ modkey }, "h",          function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.incwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "h", function () awful.client.incwfact(0.05) end),
    awful.key({ modkey },          "space", function () awful.layout.inc(layouts, 1) end),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
    -- }}}

    -- {{{ Focus controls
    awful.key({ modkey }, "p", function () awful.screen.focus_relative(1) end),
    awful.key({ modkey }, "s", function () scratchpad.toggle() end),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey }, "j", function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "k", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "Tab", function ()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end)
    -- }}}
)
-- }}}

-- {{{ Client manipulation
local clientkeys = awful.util.table.join(
    awful.key({ modkey }, "b", function ()
        wibox[mouse.screen].visible = not wibox[mouse.screen].visible
    end),
    awful.key({ modkey }, "c", function (c) c:kill() end),
    awful.key({ modkey }, "d", function (c) scratchpad.set(c, 0.60, 0.60, true) end),
    awful.key({ modkey }, "f", function (c) awful.titlebar.remove(c)
        c.fullscreen = not c.fullscreen; c.above = not c.fullscreen
    end),
    awful.key({ modkey }, "m", function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end),
    awful.key({ modkey }, "o",     awful.client.movetoscreen),
    awful.key({ modkey }, "Next",  function () awful.client.moveresize(20, 20, -20, -20) end),
    awful.key({ modkey }, "Prior", function () awful.client.moveresize(-20, -20, 20, 20) end),
    awful.key({ modkey }, "Down",  function () awful.client.moveresize(0, 20, 0, 0) end),
    awful.key({ modkey }, "Up",    function () awful.client.moveresize(0, -20, 0, 0) end),
    awful.key({ modkey, "Shift" }, "m", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift" }, "c", function (c) exec("kill -CONT " .. c.pid) end),
    awful.key({ modkey, "Shift" }, "s", function (c) exec("kill -STOP " .. c.pid) end),
    awful.key({ modkey, "Shift" }, "t", function (c)
        if   c.titlebar then awful.titlebar.remove(c)
        else awful.titlebar.add(c, { modkey = modkey }) end
    end),
    awful.key({ modkey, "Shift" }, "f", function (c) awful.client.floating.toggle(c)
        if   awful.client.floating.get(c)
        then c.above = true; awful.titlebar.add(c); awful.placement.no_offscreen(c)
        else c.above = false; awful.titlebar.remove(c) end
    end)
)
-- }}}

-- {{{ Keyboard digits
local keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end
-- }}}

-- {{{ Tag controls
for i = 1, keynumber do
    globalkeys = awful.util.table.join( globalkeys,
        awful.key({ modkey }, i, function ()
            local screen = mouse.screen
            if tags[screen][i] then
                awful.tag.viewonly(tags[screen][i])
            end
        end),
        awful.key({ modkey, "Control" }, i, function ()
            local screen = mouse.screen
            if tags[screen][i] then
                awful.tag.viewtoggle(tags[screen][i])
            end
        end),
        awful.key({ modkey, "Shift" }, i, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end),
        awful.key({ modkey, "Control", "Shift" }, i, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.toggletag(tags[client.focus.screen][i])
            end
        end))
end
-- }}}

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
	if screen.count() == 1 then
	awful.rules.rules = {
	    { rule = { },
	      properties = {
	          border_width = beautiful.border_width,
	          border_color = beautiful.border_normal,
	          focus = true,
	          keys = clientkeys,
	          buttons = clientbuttons
	    }},
	    { rule = { class = "Lanikai" },
	      properties = { tag = tags[1][5] } },
	    { rule = { class = "evince" },
	      properties = { tag = tags[1][8] } },
	    { rule = { class = "Xournal" },
	      properties = { tag = tags[1][6] } },
	    { rule = { class = "Namoroka" },
	      properties = { tag = tags[1][4] } },
	    { rule = { class = "digikam" },
	      properties = { tag = tags[1][6] } },
	    { rule = { class = "Choqok" },
	      properties = { tag = tags[1][9] } },
	    { rule = { class = "Eclipse" },
	      properties = { tag = tags[1][6] } },
	    { rule = { class = "Xmessage", instance = "xmessage" },
	      properties = { floating = true } },
	    { rule = { class = "Game.exe" },
	      properties = { floating = true } },
	    { rule = { class = "digikam" },
	      properties = { tag = tags[1][6] } },
	    { rule = { class = "OpenOffice.org 3.1" },
	      properties = { tag = tags[1][8]} },
	    { rule = { class = "Pinentry-gtk-2" },
	      properties = { floating = true } },
	    { rule = { instance = "firefox" },
	      properties = { floating = true } },
	    { rule = { class = "Kile" },
	      properties = { tag = tags[1][6] } },
	    { rule = { class = "Okular" },
	      properties = { tag = tags[1][8] } },
	}
else
	awful.rules.rules = {
	    { rule = { },
	      properties = {
	          border_width = beautiful.border_width,
	          border_color = beautiful.border_normal,
	          focus = true,
	          keys = clientkeys,
	          buttons = clientbuttons
	    }},
	    { rule = { class = "Kile" },
	      properties = { tag = tags[2][8] } },
	    { rule = { class = "Okular" },
	      properties = { tag = tags[2][8] } },
	    { rule = { class = "Lanikai" },
	      properties = { tag = tags[2][5] } },
	    { rule = { class = "evince" },
	      properties = { tag = tags[2][8] } },
	    { rule = { class = "Xournal" },
	      properties = { tag = tags[2][7] } },
	    { rule = { class = "Namoroka" },
	      properties = { tag = tags[2][4] } },
	    { rule = { class = "digikam" },
	      properties = { tag = tags[2][6] } },
	    { rule = { class = "Choqok" },
	      properties = { tag = tags[2][9] } },
	    { rule = { class = "Eclipse" },
	      properties = { tag = tags[2][6] } },
	    { rule = { class = "Xmessage", instance = "xmessage" },
	      properties = { floating = true } },
	    { rule = { class = "Game.exe" },
	      properties = { floating = true } },
	    { rule = { class = "digikam" },
	      properties = { tag = tags[2][6] } },
	    { rule = { class = "OpenOffice.org 3.1" },
	      properties = { tag = tags[2][8]} },
	    { rule = { class = "Pinentry-gtk-2" },
	      properties = { floating = true } },
	    { rule = { instance = "firefox" },
	      properties = { floating = true } },
	}
end
-- }}}

-- {{{ Signals
--
-- {{{ Signal function to execute when a new client appears
client.add_signal("manage", function (c, startup)
    -- Add a titlebar to each floating client
    if awful.client.floating.get(c)
    or awful.layout.get(c.screen) == awful.layout.suit.floating then
        if not c.titlebar and c.class ~= "Xmessage" then
            awful.titlebar.add(c, { modkey = modkey })
        end
        -- Floating clients are always on top
        c.above = true
    end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function (c)
        if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Client placement
    if not startup then
        awful.client.setslave(c)

        if  not c.size_hints.user_position
        and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    -- Honor size hints
    c.size_hints_honor = false
end)
-- }}}

-- {{{ Focus signal functions
client.add_signal("focus",   function (c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
-- }}}
-- }}}
