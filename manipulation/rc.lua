-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
naughty = require("naughty")
vicious = require("vicious")
cairo = require("oocairo")
blingbling = require("blingbling")

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
    awesome.add_signal("debug::error", function (err)
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

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/nlare/.config/awesome/themes/any_theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "gvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "web", "code", "find", "[ maple", "matlab", "TeX ]", "conf", "irc", "mm" }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal },
                                    { "netbeans", "netbeans" },
                                    { "maple", "/home/nlare/maple16/bin/xmaple" },
                                    { "matlab", "/usr/local/MATLAB/R2012b/bin/matlab -desktop" },
                                    { "octave-gui", "qtoctave" },
                                    { "virtualbox", "virtualbox" },
                                    { "gtypist", terminal .. " -e gtypist" },
                                    { "gnote", "gnote" },
                                    { "vim.tutorial", "feh /home/nlare/_img/vim_keys.jpg" },
                                    { "blink(alt.skype)", "blink" },
                                    { "ati_config", "driconf" }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Graph begin

 cpulabel= widget({ type = "textbox" })
 cpulabel.text='CPU:'
   
 memlabel= widget({ type = "textbox" })
 memlabel.text=' MEM:'

 mpdlabel= widget({ type = "textbox" })
 mpdlabel.text=' MPD:'

 udnlabel= widget({ type = "textbox" })
 udnlabel.text=' u/d: '

 mycpugraph=blingbling.classical_graph.new()
 mycpugraph:set_height(18)
 mycpugraph:set_width(300)
 mycpugraph:set_tiles_color("#00000022")
 mycpugraph:set_show_text(true)
 mycpugraph:set_graph_color("#01a6e3ff")
 mycpugraph:set_graph_line_color("#01a6e3ff")
 --mycpugraph:set_label("Load: $percent %")
 --blingbling.popups.htop(mycpugraph.widget,
--       { title_color=beautiful.notify_font_color_1, 
--          user_color=beautiful.notify_font_color_2, 
--          root_color=beautiful.notify_font_color_3, 
--          terminal = "urxvt"})
 vicious.register(mycpugraph, vicious.widgets.cpu,'$1',2)

 mycore1=blingbling.value_text_box.new()
 mycore1:set_height(22)
 mycore1:set_width(15)
 mycore1:set_filled(true)
 mycore1:set_filled_color("#000000")
 --mycore1:set_rounded_size(0)
 mycore1:set_values_text_color({{"#01a6e3ff",0},{"#01a6e3ff", 0.5},{"#dd0000",0.75}})
 mycore1:set_font_size(8)
 mycore1:set_background_color("#00000044")
 mycore1:set_label("$percent%")
 vicious.register(mycore1, vicious.widgets.cpu, "$2")

 mycore2=blingbling.value_text_box.new()
 mycore2:set_height(22)
 mycore2:set_width(15)
 mycore2:set_filled(true)
 mycore2:set_filled_color("#000000")
 --mycore2:set_rounded_size(0)
 mycore2:set_values_text_color({{"#01a6e3ff",0},{"#01a6e3ff", 0.5},{"#dd0000",0.75}})
 mycore2:set_font_size(8)
 mycore2:set_background_color("#00000044")
 mycore2:set_label("$percent%")
 vicious.register(mycore2, vicious.widgets.cpu, "$3")

 mycore3=blingbling.value_text_box.new()
 mycore3:set_height(22)
 mycore3:set_width(15)
 mycore3:set_filled(true)
 mycore3:set_filled_color("#000000")
 --mycore3:set_rounded_size(0)
 mycore3:set_values_text_color({{"#01a6e3ff",0},{"#01a6e3ff", 0.5},{"#dd0000",0.75}})
 mycore3:set_font_size(8)
 mycore3:set_background_color("#00000044")
 mycore3:set_label("$percent%")
 vicious.register(mycore3, vicious.widgets.cpu, "$4")

 mycore4=blingbling.value_text_box.new()
 mycore4:set_height(22)
 mycore4:set_width(15)
 mycore4:set_filled(true)
 mycore4:set_filled_color("#000000")
 --mycore4:set_rounded_size(0)
 mycore4:set_values_text_color({{"#01a6e3ff",0},{"#01a6e3ff", 0.5},{"#dd0000",0.75}})
 mycore4:set_font_size(8)
 mycore4:set_background_color("#00000044")
 mycore4:set_label("$percent%")
 vicious.register(mycore4, vicious.widgets.cpu, "$5")

 memwidget=blingbling.classical_graph.new()
 memwidget:set_height(18)
 memwidget:set_width(300)
 memwidget:set_tiles_color("#00000022")
 memwidget:set_graph_color("#01a6e3ff")
 memwidget:set_graph_line_color("#01a6e3ff")
 memwidget:set_show_text(true)
 vicious.register(memwidget, vicious.widgets.mem, '$1', 2)

 mynet_down=blingbling.value_text_box.new()
 mynet_down:set_height(18)
 mynet_down:set_width(30)
 --mynet_down:set_v_margin(2)
 mynet_down:set_filled(true)
 mynet_down:set_filled_color("#00000099")
 mynet_down:set_values_text_color({{"#01a6e3ff",0}, --all value > 0 will be displaying using this color
                              {"#01a6e3ff", 0.75},
                              {"#01a6e3ff",0.77}})
 mynet_down:set_default_text_color(beautiful.textbox_widget_as_label_font_color)
 mynet_down:set_rounded_size(0.4)
 mynet_down:set_background_color("#00000044")
 --mynet_down:set_label("down: $percent")
 --mynet_down:set_interface("wlan0")
 vicious.register(mynet_down, vicious.widgets.net, "${wlan0 down_kb}", 1)
 

 mynet_ssid=blingbling.value_text_box.new()
 mynet_ssid:set_height(18)
 mynet_ssid:set_width(40)
 mynet_ssid:set_v_margin(2)
 mynet_ssid:set_filled(true)
 mynet_ssid:set_filled_color("#00000099")
 --mynet_ssid:set_default_text_color(beautiful.textbox_widget_as_label_font_color)
 mynet_ssid:set_rounded_size(0.4)
 mynet_ssid:set_background_color("#00000044")
 vicious.register(mynet_ssid, vicious.widgets.wifi, "${essid}", 1, "wlan0")


 mynet_up=blingbling.value_text_box.new()
 mynet_up:set_height(18)
 mynet_up:set_width(30)
 --mynet_up:set_v_margin(2)
 mynet_up:set_filled(true)
 mynet_up:set_filled_color("#00000099")
 mynet_up:set_values_text_color({{"#01a6e3ff",0}, --all value > 0 will be displaying using this color
                              {"#01a6e3ff", 0.75},
                              {"#01a6e3ff",0.77}})
 mynet_up:set_default_text_color(beautiful.textbox_widget_as_label_font_color)
 mynet_up:set_rounded_size(0.4)
 mynet_up:set_background_color("#00000044")
 --mynet_up:set_label("down: $percent")
 --mynet_up:set_interface("wlan0")
 vicious.register(mynet_up, vicious.widgets.net, "${wlan0 up_kb}", 2)
 
  my_net_icon=blingbling.net.new()
  my_net_icon:set_height(18)
  my_net_icon:set_width(88)
  my_net_icon:set_v_margin(3)
  my_net_icon:set_graph_line_color("#01a6e3ff")
  my_net_icon:set_graph_color("#01a6e3ff")
  my_net_icon:set_filled_color("#01a6e3ff")

 -- mpdlabel= widget({ type = "textbox" })
 -- mpdlabel.text='MPD: '
 --
 my_mpd_volume=blingbling.volume.new()
 my_mpd_volume:set_height(18)
 my_mpd_volume:set_width(30)
 --bind the volume graph on mpd  
 --my_mpd_volume:update_mpd()
 --use bar, default is a triangle
 my_mpd_volume:set_bar(false)
 --
 mympd=blingbling.mpd_visualizer.new()
 mympd:set_height(18)
 mympd:set_width(700)
 --my_mpd:set_backgrond_color("#01a6e3ff");
 --my_mpd:add_value(0.5)
 mympd:update()
 --display pcm graph with a line
 mympd:set_line(true)
 --mympd:set_h_margin(10)
 --mympd:set_v_margin(20)
 mympd:set_graph_color("#01a6e3ff")
 --bind mpc commands on the widget
 mympd:set_mpc_commands("urxvt -e ncmpcpp")
 --mympd:set_filled(true)
 --mympd:set_filled_color("#01a6e3ff")
 -- Show the artist name and the current song
 mympd:set_show_text(true)
 mympd:set_label("$artist > $title")

 --myhdd=widget({type = "textbox"})
 --vicious.register(myhdd, vicious.widgets.hddtemp, "${/dev/sda}", 10)

 -- Task 
 task_warrior=blingbling.task_warrior.new(beautiful.tasks_icon)
 task_warrior:set_task_done_icon(beautiful.task_done_icon)
 task_warrior:set_task_icon(beautiful.task_icon)
 task_warrior:set_project_icon(beautiful.project_icon)

 -- Calendar
 my_cal=blingbling.calendar.new({type = "imagebox", image = beautiful.calendar})
 my_cal:set_cell_padding(2)
 my_cal:set_title_font_size(9)
 my_cal:set_font_size(8)
 my_cal:set_inter_margin(1)
 my_cal:set_columns_lines_titles_font_size(8)
 my_cal:set_columns_lines_titles_text_color("#d4aa00ff")

-- End
--
-- Create a wibox for each screen and add it
mywiboxtop = {}
mywiboxbot = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
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
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywiboxtop[s] = awful.wibox({ position = "top", screen = s })
    mywiboxbot[s] = awful.wibox({ position = "bottom", screen = s })
    -- Add widgets to the wibox - order matters
    mywiboxtop[s].widgets = {
        {
           -- mylauncher,
            task_warrior,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
       -- mynet_ssid,
       -- my_net_icon,
--        myhdd,
--        myvolume,
        s == 1 and mysystray or nil,
        my_cal,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
    mywiboxbot[s].widgets = {

        mytextclock,
        cpulabel,
        mycpugraph,
        --mycore1,
        --mycore2,
        --mycore3,
        --mycore4,
        memlabel,
        memwidget,
        mpdlabel,
        mympd,
        udnlabel,
        mynet_up,
        mynet_down,
        layout = awful.widget.layout.horizontal.leftright
    }
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),
    awful.key({ modkey,   "Shift"    }, "e", function () awful.util.spawn( editor .. " " .. awesome.conffile ) end),

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

    -- Any actions

    awful.key({                   }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer sset Master 5+") end),
    awful.key({                   }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer sset Master 5-") end),
    awful.key({                   }, "XF86AudioPlay", function () awful.util.spawn("mpc play") end),
    awful.key({                   }, "XF86AudioStop", function () awful.util.spawn("mpc stop") end),
    awful.key({                   }, "XF86AudioNext", function () awful.util.spawn("mpc next") end),
    awful.key({                   }, "XF86AudioPrev", function () awful.util.spawn("mpc prev") end),
    awful.key({ modkey,           }, "p", function () awful.util.spawn_with_shell("urxvt -e ncmpcpp") end),
    awful.key({ modkey,           }, "t", function () awful.util.spawn_with_shell("urxvt -e rtorrent") end),
    awful.key({ modkey,           }, "b", function () awful.util.spawn("firefox") end),
    awful.key({ modkey,           }, "f", function () awful.util.spawn_with_shell("doublecmd") end),
    awful.key({ modkey,           }, "d", function () awful.util.spawn("urxvt -e sdcv") end),
    awful.key({ modkey,           }, "g", function () awful.util.spawn("gvim") end),
    awful.key({ modkey,  "Shift"  }, "g", function () awful.util.spawn_with_shell("netbeans") end),
    awful.key({ "Control",        }, "Escape", function () awful.util.spawn("urxvt -e sudo wifi-menu") end),
    awful.key({ modkey,        }, "i", function () awful.util.spawn("skype") end),
    awful.key({ modkey,  "Shift"  }, "i", function () awful.util.spawn("pidgin") end),
    
    --

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
    -- awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey },            "r",     function () awful.util.spawn_with_shell("dmenu_run -b") end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey, "Shift"   }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "Up",
        function (c)
            c.maximized_horizontal = true
            c.maximized_vertical   = true
        end),
    awful.key({ modkey,           }, "Down",
        function (c)
            c.maximized_horizontal = false
            c.maximized_vertical   = false
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
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
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true, tag = tags[1][7] } },
    { rule = { class = "Skype" },
      properties = { floating = true,tag = tags[1][8] } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 1 of screen 1.
    { rule = { class = "Firefox" },
       properties = { tag = tags[1][1] } },
    { rule = { class = "NetBeans IDE 7.2.1" },
       properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
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
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--


function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("compton --config ~/.compton.conf")
run_once("sbxkb")
run_once("udisks-glue")
run_once("parcellite")
run_once("wmname LG3D")
run_once("firefox")
-- run_once("xbattbar-acpi -b 1")
