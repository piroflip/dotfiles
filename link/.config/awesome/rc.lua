-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
local vicious = require("vicious")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local lain    = require("lain")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- run_once("gxneur")
run_once("parcellite")
run_once("firefox")
run_once("pidgin")
run_once("unclutter -root")
run_once("urxvtd")
-- run_once("licq")
-- run_once("skype")
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
home = os.getenv("HOME")
user = os.getenv("USER")
confdir = home .. "./config/awesome"
beautiful.init("/home/" .. user .. "/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc" or "sakura"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
--    awful.layout.suit.floating,
    awful.layout.suit.tile,
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
   names  = { 1, 2, 3, 4, 5, 6, 7, "web", "chat" },
   layout = { layouts[1], layouts[1], layouts[1], layouts[1], layouts[1],
              layouts[1], layouts[1], layouts[2], layouts[1]
}}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Wibox

-- {{{ Top panel widgets

-- Volume Indicator
-- Icon

-- speaker widget
speakerwidget = wibox.widget.textbox()
speakerwidget:set_font("Symbola")
speakerwidget:set_text('🔊 ')

volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
-- Scale
-- volwidget = wibox.widget.textbox()
-- vicious.register(volwidget, vicious.widgets.volume, "$1%", 1, "Master")
-- Wifi rate
wifi = wibox.widget.textbox()
vicious.register(wifi, vicious.widgets.wifi, "[ ${ssid} | ${link}% ]", 121, "wlan0")
wicon = wibox.widget.imagebox()
wicon:set_image(beautiful.widget_wifi)

space = wibox.widget.textbox()
space:set_text(" ")

-- }}}

-- {{{ Start Gmail
mailwidget = wibox.widget.textbox()
-- gmailicon = wibox.widget.textbox()
-- gmailicon:set_text(" ✉ ")
gmailicon = wibox.widget.imagebox(beautiful.widget_mail)
gmail_t = awful.tooltip({ objects = { mailwidget },})
vicious.register(mailwidget, vicious.widgets.gmail,
        function (widget, args)
        gmail_t:set_text(args["{subject}"])
--        gmail_t:add_to_object(mailicon)
            return args["{count}"]
                 end, 120)
-- End Gmail }}}


-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
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
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(gmailicon)
    right_layout:add(mailwidget)
    right_layout:add(space)
    right_layout:add(wifi)
    right_layout:add(space)
    right_layout:add(speakerwidget)
    -- right_layout:add(volwidget)
    right_layout:add(space)
    right_layout:add(mytextclock)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    -- Volume control
    awful.key({ modkey,           }, ",",   function () awful.util.spawn("amixer -q sset Master 1dB+", false) end),
    awful.key({ modkey,           }, ".",   function () awful.util.spawn("amixer -q sset Master 1dB-", false) end),
    awful.key({  }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q sset Master 1dB+", false) end),
    awful.key({  }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q sset Master 1dB-", false) end),

    -- Capture screen
    awful.key({                   }, "Print", function () awful.util.spawn("scrot -q 100") end),

     -- Lock screen
    awful.key({ modkey            }, "y",   function () awful.util.spawn("slimlock") end),

        -- Applications
    awful.key({ modkey,           }, "g",     function () awful.util.spawn("geany")  end),
    awful.key({ modkey,           }, "f",      function () awful.util.spawn( "firefox", false ) end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "z",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false } },

    { rule = { class = "Gimp", role = "gimp-image-window" },
      properties = { maximized_horizontal = true,
                     maximized_vertical   = true } },

    { rule = { class = "Firefox" },
      properties = { tag = tags[1][8] } },

    { rule = { class = "Firefox" , instance = "DTA" },
      properties = { tag = tags[1][8], floating = true } },

    { rule = { class = "Firefox" , instance = "Toplevel" },
      properties = { tag = tags[1][8], floating = true } },

--    { rule = { class = "Firefox" , instance = "Browser" },
--      properties = { tag = tags[1][8], floating = true } },

    { rule = { class = "Firefox" , instance = "Download" },
      properties = { tag = tags[1][8], floating = true } },

    { rule = { class = "Firefox" , name = "Install user style" },
      properties = { tag = tags[1][8], floating = true } },

    { rule = { class = "Skype" },
      properties = { tag = tags[1][9], floating = true } },

    { rule = { class = "Licq" },
      properties = { tag = tags[1][9], floating = true } },

    { rule = { class = "Plugin-container"},
      properties = { tag = tags[1][8], floating = true } },

    { rule = { class = "Pidgin", role = "buddy_list" },
    properties = { tag = tags[1][9], switchtotag = true, floating=true,
                  maximized_vertical=true, maximized_horizontal=false },
    callback = function (c)
        local cl_width = 250    -- width of buddy list window
        local def_left = false  -- default placement. note: you have to restart
                                -- pidgin for changes to take effect

        local scr_area = screen[c.screen].workarea
        local cl_strut = c:struts()
        local geometry = nil

        -- adjust scr_area for this client's struts
        if cl_strut ~= nil then
            if cl_strut.left ~= nil and cl_strut.left > 0 then
                geometry = {x=scr_area.x-cl_strut.left, y=scr_area.y,
                            width=cl_strut.left}
            elseif cl_strut.right ~= nil and cl_strut.right > 0 then
                geometry = {x=scr_area.x+scr_area.width, y=scr_area.y,
                            width=cl_strut.right}
            end
        end
        -- scr_area is unaffected, so we can use the naive coordinates
        if geometry == nil then
            if def_left then
                c:struts({left=cl_width, right=0})
                geometry = {x=scr_area.x, y=scr_area.y,
                            width=cl_width}
            else
                c:struts({right=cl_width, left=0})
                geometry = {x=scr_area.x+scr_area.width-cl_width, y=scr_area.y,
                            width=cl_width}
            end
        end
        c:geometry(geometry)
    end },

    { rule = { class = "Skype" },
    properties = { tag = tags[1][9], switchtotag = true, floating=true,
                  maximized_vertical=true, maximized_horizontal=false },
    callback = function (c)
        local cl_width = 250    -- width of buddy list window
        local def_left = true   -- default placement. note: you have to restart
                                -- pidgin for changes to take effect

        local scr_area = screen[c.screen].workarea
        local cl_strut = c:struts()
        local geometry = nil

        -- adjust scr_area for this client's struts
        if cl_strut ~= nil then
            if cl_strut.left ~= nil and cl_strut.left > 0 then
                geometry = {x=scr_area.x-cl_strut.left, y=scr_area.y,
                            width=cl_strut.left}
            elseif cl_strut.right ~= nil and cl_strut.right > 0 then
                geometry = {x=scr_area.x+scr_area.width, y=scr_area.y,
                            width=cl_strut.right}
            end
        end
        -- scr_area is unaffected, so we can use the naive coordinates
        if geometry == nil then
            if def_left then
                c:struts({left=cl_width, right=0})
                geometry = {x=scr_area.x, y=scr_area.y,
                            width=cl_width}
            else
                c:struts({right=cl_width, left=0})
                geometry = {x=scr_area.x+scr_area.width-cl_width, y=scr_area.y,
                            width=cl_width}
            end
        end
        c:geometry(geometry)
    end },

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
