-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- wicked library
require("wicked")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- The default is a dark theme
-- theme_path = "/usr/share/awesome/themes/default/theme"
-- for patch:
theme_path = "/usr/share/awesome/themes/default/theme.lua"
-- Uncommment this for a lighter theme
-- theme_path = "/usr/share/awesome/themes/sky/theme.lua"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Auutostart Programms
-- these applications will automatically start
os.execute("run_once urxvt &")
-- os.execute("firefox &")

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps =
{
    -- by class
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
    -- by instance
    ["mocp"] = true,
    ["Game.exe"] = true,
    ["Cellwriter"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    ["Shiretoko"] = { screen = 1, tag = 3 },
    ["Thunderbird-bin"] = { screen = 1, tag = 4 },
    ["pidgin"] = { screen = 1, tag = 2},
    ["Eclipse"] = { screen = 1, tag = 6 },
    ["OpenOffice.org 3.1"] = { screen = 1, tag = 8 },
    ["Xournal"] = { screen = 1, tag = 7 },
    ["Sunbird-bin"] = { screen = 1, tag = 5},
    ["cellwriter"] = { screen = 1, tag = 7 },
    ["evince"] = { screen = 1, tag = 8 },
    ["Songbird"] = { screen = 1, tag = 5 },
    ["digikam"] = { screen = 1, tag = 5 },
    ["gpicview"] = { screen = 1, tag = 5 },
	["gcalctools"] = { screen = 1, tag = 9 },
	["thunar"] = { screen = 1, tag = 9 },
	["file-roller"] = { screen = 1, tag = 9},
	["skype"] = { screen = 1, tag = 2 },
	["gwibber"] = { screen = 1, tag = 9 },
	["rhythmbox"] = { screen = 1, tag = 5 },
	["choqok"] = { screen = 1, tag = 9},
    -- ["mocp"] = { screen = 2, tag = 4 },
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Tags
-- Define tags table.
tags = {}
tagnames = {}
tagnames[1] = "1»shell"
tagnames[2] = "2»im"
tagnames[3] = "3»http"
tagnames[4] = "4»mail"
tagnames[5] = "5»media"
tagnames[6] = "6»code"
tagnames[7] = "7»wacom"
tagnames[8] = "8»office"
tagnames[9] = "9»misc"

for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag(tagnumber)
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
	tags[s][tagnumber].name = tagnames[tagnumber]
		-- for thunderbird maxes windows only
		if tagnumber == 4 then 
			awful.layout.set(layouts[7], tags[s][tagnumber])
		else
    	    awful.layout.set(layouts[3], tags[s][tagnumber])
		end
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
end
-- }}}
-- {{{ Wibox
-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "cap @ hermodr  "

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

--additionnal menu "progs1"
progs1menu = {
	{ "thunar",		"thunar" },
	{ "cellwriter", "cellwriter" },
	{ "ooffice",	"soffice" },
	{ "fileroller", "file-roller" },
	{ "gcalc",		"gcalctool"},
	{ "techlab",	"ktechlab"},
	{ "gpicview",	"gpicview" },
	{ "digikam",	"digikam" },
	{ "eclipse",	"eclipse" },
	{ "the_gimp",	"gimp" },
	{ "choqoK",		"choqok" },
	{ "skype",		"skype" },
}

mymainmenu = awful.menu.new({ items = {
					{ "awesome", myawesomemenu, beautiful.awesome_icon },
					{ "urxvt", terminal },
                 -- { "pidgin", "pidgin" },
					{ "chat", terminal .. " -e weechat-curses" },
					{ "firefox", "firefox" },
                    { "thunderbird", "thunderbird" },
					{ "evince", "evince" },
					{ "xournal", "xournal" },
					{ "rhythmbox", "rhythmbox" },
					{ "progs1", progs1menu, beautiful.awesome_icon },
                                      }
							 })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })

-- Create a systray
mysystray = widget({ type = "systray", align = "right" })






-- Create a wibox for each screen and add it
mywibox = {}
--mywibox2 = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = { button({ }, 1, awful.tag.viewonly),
                      button({ modkey }, 1, awful.client.movetotag),
                      button({ }, 3, function (tag) tag.selected = not tag.selected end),
                      button({ modkey }, 3, awful.client.toggletag),
                      button({ }, 4, awful.tag.viewnext),
                      button({ }, 5, awful.tag.viewprev) }
mytasklist = {}
mytasklist.buttons = { button({ }, 1, function (c)
                                          if not c:isvisible() then
                                              awful.tag.viewonly(c:tags()[1])
                                          end
                                          client.focus = c
                                          c:raise()
                                      end),
                       button({ }, 3, function () if instance then instance:hide() end instance = awful.menu.clients({ width=250 }) end),
                       button({ }, 4, function ()
                                          awful.client.focus.byidx(1)
                                          if client.focus then client.focus:raise() end
                                      end),
                       button({ }, 5, function ()
                                          awful.client.focus.byidx(-1)
                                          if client.focus then client.focus:raise() end
                                      end) }

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = widget({ type = "textbox", align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
    mylayoutbox[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                return awful.widget.tasklist.label.currenttags(c, s)
                                              end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = wibox({ position = "top", fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = { mylauncher,
                           mytaglist[s],
                           mypromptbox[s],
                           mytextbox,
                           mylayoutbox[s],
                           s == 1 and mysystray or nil }
    mywibox[s].screen = s

   -- mywibox2[s] = wibox({ position = "bottom", fg = beatiful.fg_normal, bg = beatiful.bg_normal })
   -- mywibox2[s].screen = s
end
-- }}}
--  

-- {{{ Mouse bindings
root.buttons({
    button({ }, 3, function () mymainmenu:toggle() end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings
globalkeys =
{
    key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    key({ modkey,           }, "Escape", awful.tag.history.restore),

    key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    key({ modkey, "Control" }, "j", function () awful.screen.focus( 1)       end),
    key({ modkey, "Control" }, "k", function () awful.screen.focus(-1)       end),
    key({ modkey,           }, "u", awful.client.urgent.jumpto),
    key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    key({ modkey, "Control" }, "r", awesome.restart),
    key({ modkey, "Shift"   }, "q", awesome.quit),

    key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    key({ modkey }, "F1",
        function ()
            awful.prompt.run({ prompt = "  » run : " },
            mypromptbox[mouse.screen],
            awful.util.spawn, awful.completion.bash,
            awful.util.getdir("cache") .. "/history")
        end),

    key({ modkey }, "F4",
        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen],
            awful.util.eval, awful.prompt.bash,
            awful.util.getdir("cache") .. "/history_eval")
        end),
}

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys =
{
    key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    key({ modkey }, "t", awful.client.togglemarked),
    key({ modkey,}, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
}

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    table.insert(globalkeys,
        key({ modkey }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewonly(tags[screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control" }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    tags[screen][i].selected = not tags[screen][i].selected
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.movetotag(tags[client.focus.screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control", "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.toggletag(tags[client.focus.screen][i])
                end
            end))
end


for i = 1, keynumber do
    table.insert(globalkeys, key({ modkey, "Shift" }, "F" .. i,
                 function ()

                     local screen = mouse.screen
                     if tags[screen][i] then
                         for k, c in pairs(awful.client.getmarked()) do
                             awful.client.movetotag(tags[screen][i], c)
                         end
                     end
                 end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end

    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, awful.mouse.client.move),
        button({ modkey }, 3, awful.mouse.client.resize)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] then
        awful.client.floating.set(c, floatapps[inst])
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
    client.focus = c

    -- Set key bindings
    c:keys(clientkeys)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
	--size_hints_honor = false
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout and beautiful["layout_" ..layout] then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)


-- }}}










-- Widgets using wicked
-- Memory usage
memwidget = widget({
   type = 'textbox',
   name = 'memwidget',
   align = "right"
})
wicked.register(memwidget, wicked.widgets.mem,
    ' || <span color="white">ram:</span> $1% ||',
nil, nil, {2, 4, 4})


--date
datewidget = widget({
   type = 'textbox',
   name = 'datewidget',
})
wicked.register(datewidget, wicked.widgets.date,' %c')

-- file system
fswidget = widget({
   type = 'textbox',
   name = 'fswidget',
   align = "right"
})

wicked.register(fswidget, wicked.widgets.fs,
    ' || <span color="white">du </span> / ${/ usep}% | /home ${/home usep}%  || ', 120)


--cpu
cpuwidget = widget({
   type = 'textbox',
   name = 'cpuwidget',
   align = "right"
})
wicked.register(cpuwidget, wicked.widgets.cpu,
    ' <span color="white">cpu:</span> $1% || ',3)



cpugraphwidget = widget({
    type = 'graph',
    name = 'cpugraphwidget',
    align = 'right'
})

cpugraphwidget.height = 0.85
cpugraphwidget.width = 45
cpugraphwidget.bg = '#333333'
cpugraphwidget.border_color = '#0a0a0a'
cpugraphwidget.grow = 'left'

cpugraphwidget:plot_properties_set('cpu', {
    fg = '#AEC6D8',
    fg_center = '#285577',
    fg_end = '#285577',
    vertical_gradient = false
})

wicked.register(cpugraphwidget, wicked.widgets.cpu, '$1', 1, 'cpu')


batteries = 1
-- Function to extract charge percentage
function read_battery_life(number)
  return function(format)
            local fh = io.popen('acpi')
            local output = fh:read("*a")
            fh:close()
            count = 0
			if output == "" then
				return {0}
			end
            for s in string.gmatch(output, "(%d+)%%") do
               if number == count then
                  return {s}
               end
               count = count + 1
            end
         end
end
-- Display one vertical progressbar per battery
for battery=0, batteries-1 do

  batterygraphwidget = widget({ type = 'progressbar',
                                name = 'batterygraphwidget',
                                align = 'right' })
  batterygraphwidget.height = 0.85
  batterygraphwidget.width = 8
  batterygraphwidget.bg = '#333333'
  batterygraphwidget.border_color = '#0a0a0a'
  batterygraphwidget.vertical = true
  batterygraphwidget:bar_properties_set('battery',
                                        { fg = '#AEC6D8',
                                          fg_center = '#285577',
                                          fg_end = '#285577',
                                          fg_off = '#222222',
                                          vertical_gradient = true,
                                          horizontal_gradient = false,
                                          ticks_count = 0,
                                          ticks_gap = 0 })

  wicked.register(batterygraphwidget, read_battery_life(battery), '$1', 1, 'battery')

	batterytextwidget = widget ({ type = 'textbox',
								  name = 'batterytextwidget',
								  align= "right" })

wicked.register(batterytextwidget, read_battery_life(battery), '|| <span color="white">bat0</span>: $1% ')

end

-- net
netwidget = widget({
   type = 'textbox',
   name = 'netwidget',
   align = "right"
})
-- hier was reinbasteln fuer ethernet da oder nicht...
netset = 42

if netset == 42 then
wicked.register(netwidget, wicked.widgets.net,
' <span color="white">eth0</span> down: ${eth0 down_kb}kb | up: ${eth0 up_kb}kb | rx:${eth0 rx_mb}mb | tx:${eth0 tx_mb}mb ',	
		2, nil, 4)
else
		
wicked.register(netwidget, wicked.widgets.net,
' <span color="white">wlan0</span> down: ${wlan0 down_kb}kb | up: ${wlan0 up_kb}kb | rx:${wlan0 rx_mb}mb | tx:${wlan0 tx_mb}mb ',
		2, nil, 4)
end


-- statebar in the bottom
mystatebar = wibox( {position = "bottom", fg = beautiful.fg_normal, bg = beautiful.bg_normal} )
mystatebar.widgets = {
   datewidget,
   fswidget,    
   cpuwidget,
   cpugraphwidget,
   memwidget,  
   netwidget,
   batterytextwidget,
}
mystatebar.screen = 1

