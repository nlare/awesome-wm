-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local blingbling = require("blingbling") 
local socket = require("socket") 

local hotkeys_popup = require("awful.hotkeys_popup").widget

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
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.get_themes_dir() .. "bw/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
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
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
-- myawesomemenu = {
--    { "hotkeys", function() return false, hotkeys_popup.show_help end},
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
--    { "restart", awesome.restart },
--    { "quit", function() awesome.quit() end}
-- }

-- mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                     { "open terminal", terminal }
--                                   }
--                         })

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   -- { "edit theme", editor_cmd .. " " .. beauty_theme },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
   { "gracefully restart", "/home/nlare/_scripts/awesome/grace_restart.sh" },
   { "gracefully shutdown", "/home/nlare/_scripts/awesome/grace_shutdown.sh" }
}

myaudiomenu = {
    { "gtkguitune", "gtkguitune" },
    -- { "audacity", "audacity" },
    -- { "flacon", "flacon" },
    { "soundconverter", "soundconverter" }
}

myvideomenu = {
    -- { "LightWorks", "lightworks" },
    { "OpenShot", "openshot" }
}

mygamesmenu = {
    {"Steam", "/usr/bin/steam-native" },
    {"xboard (chess)", "xboard" },
    {"Doom3 BFG Edition", "/home/nlare/data/games/Doom_3_BFG_Edition/RBDoom3BFG.x64" },
    {"Heroes III", "/home/nlare/games/HoMM3/bin/vcmilauncher" },
    {"NWN", "sh /home/nlare/data/games/NeverwinterNights/nwn" },
    {"Diablo II (window)", "sh /home/nlare/data/_scripts/games/run_diablo_windowed.sh" },
    {"Diablo II (fullscr)", "sh /home/nlare/data/_scripts/games/run_diablo_fullscreen.sh" },
    {"Quake3", "urxvt -e \"sh /home/nlare/_scripts/run-xephyr-quake.sh\"" },
    {"winecfg", "winecfg" }
}

mynetmenu = {
    { "wireshark", "wireshark" },
    { "filezilla", "filezilla" },
    { "VPN-PIRS", "urxvt -e sudo /usr/bin/openconnect --authgroup=\"PIRS Co. Ltd\" vpn.pirsoilgas.ru" }
}

myvmmenu = {
    { "VirtualBox", "virtualbox" }
}

mydevmenu = {
    { "sublime_commander", "subl3" },
    { "SQLdeveloper", "/home/nlare/SQLDeveloper/sqldeveloper.sh" },
    { "Intellij IDEA", "/home/nlare/IDEA/bin/idea.sh" },
    { "Intel XDK", "/opt/intel/XDK/xdk.sh" },
    { "netbeans", "netbeans" },
    { "maple", "/home/nlare/maple16/bin/xmaple" },
    { "matlab", "/usr/local/MATLAB/R2012b/bin/matlab -desktop" },
    { "octave-gui", "qtoctave" }
}

mygraphsmenu = {
--    { "sublime_commander", "subl3" },
    { "QtiPlot", "qtiplot" }
}

myvirtualmenu = {
  { "Spicy", "/usr/bin/spicy" }
}


mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "devenv" , mydevmenu},
                                    { "virtual" , myvirtualmenu},
                                    { "graphs" , mygraphsmenu},
                                    { "network" , mynetmenu},
                                    { "audio" , myaudiomenu},
                                    { "video" , myvideomenu},
                                    { "games" , mygamesmenu},
--                                    { "recordmydesktop", "gtk-recordMyDesktop" },
--                                    { "gtypist", terminal .. " -e gtypist" },
--                                    { "gnote", "gnote" },
                                    { "TkDVD", "sh /home/nlare/data/_dstr/tkdvd/TkDVD.sh" },
                                    { "xpaint", "/usr/bin/xpaint" },
                                    { "7zFM", "/usr/bin/7zFM" },
                                    { "ink level (Epson)", "/home/nlare/_scripts/epson_ink_level.sh" },
                                    { "ncdu (Disk Analyzer)", "urxvt -e ncdu" },
                                    { "gtklp (Printing GUI)", "gtklp" },
                                    { "vim.tutorial", "feh /home/nlare/_img/vim_keys.jpg" },
                                    { "mc.filetypes", "gvim /home/nlare/.config/mc/mc.ext" },
                                    { "ClamTK", "/usr/bin/clamtk" },
                                    { "mc.filetypes", "gvim /home/nlare/.config/mc/mc.ext" },
--                                    { "blink(alt.skype)", "blink" },
--                                    { "ati_config", "driconf" },
                                    { "open terminal", terminal }
                                  }
                        })


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

--calendar.addCalendarToWidget(mytextclock, "<span color='green'>%s</span>")
--cores_graph_conf = {height = 18, width = 8, rounded_size = 0.3}
cpu_graph = blingbling.line_graph()
cpu_graph:set_height(20)
cpu_graph:set_width(120)
cpu_graph:set_text_color("#d2d2d2")
cpu_graph:set_graph_color("#222222")
--cpu_graph:set_graph_background_border("#00000077")
cpu_graph:set_graph_line_color("#dedede")
cpu_graph:set_show_text(true)
cpu_graph:set_label("CPU:$percent%")
cpu_graph:set_font("Terminus")
cpu_graph:set_font_size(8)

blingbling.popups.htop(cpu_graph, {  
    title_color=beautiful.notify_title_color,
    user_color=beautiful.notify_user_color,
    root_color=beautiful.notify_root_color,
    terminal = "urxvt"})

vicious.register(cpu_graph, vicious.widgets.cpu, '$1', 1)
--vicious.register(cpu_temp, vicious.widgets.thermal,               function (widget, args)                     f = io.popen("sensors | grep 'CPU Temp' | cut -b 22-23")                    return f                end, 5)

--cores_graphs = {}
--for i=1,4 do
--  cores_graphs[i] = blingbling.progress_graph.new()
--    cores_graphs[i]:set_height(18)
--    cores_graphs[i]:set_width(6)
--    cores_graphs[i]:set_rounded_size(0.0)
--    cores_graphs[i]:set_h_margin(1)
--    cores_graphs[i]:set_tiles_color("#000000")
--    cores_graphs[i]:set_background_color("#00000033")
--    cores_graphs[i]:set_graph_color("#98989844")
--    cores_graphs[i]:set_graph_line_color("#ffffff")
--  vicious.register(cores_graphs[i], vicious.widgets.cpu, "$"..(i+1).."",1)
--end

-- Initialize widget
mem_graph = blingbling.line_graph()
-- Progressbar properties
mem_graph:set_width(120)
mem_graph:set_text_color("#d2d2d2")
mem_graph:set_graph_color("#222222")
--mem_graph:set_graph_background_color("#ffffff22")
mem_graph:set_graph_line_color("#dedede")
mem_graph:set_show_text(true)
mem_graph:set_label("MEM:$percent%")
mem_graph:set_font("Terminus")
mem_graph:set_font_size(8)

--memwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
-- Register widget
vicious.register(mem_graph, vicious.widgets.mem, "$1", 2)

--batwidget = wibox.widget.textbox()
--vicious.register(batwidget, vicious.widgets.bat, "$2% ", 31, "BAT0")

--*:draw - need to set cairo context, to do this, we must install oocairo lib (sources need latest patch) or no?
--net_icon= wibox.widget.imagebox()
--net_icon:st_image("/home/nlare/.config/awesome/themes/nlare/icons/hardware/net-wired2.xbm")

--mygmailimg = widget({ type = "imagebox" })
--mygmailimg.image = image("/home/username/.config/awesome/gmail.png")
 
gmaillabel= wibox.widget.textbox()
gmaillabel:set_markup(" inbox: ")

--gmail = wibox.widget.textbox()
--gmail_t = awful.tooltip({ objects = { gmail },})

-- vicious.register(gmail, vicious.widgets.gmail,
                -- function (widget, args)
                    --gmail_t:set_text(args["{subject}"])
                    --gmail_t:add_to_object(mygmailimg)
                 --    return args["{count}"]
                 -- end, 120) 
                 --the '120' here means check every 2 minutes.

-- Pacman Widget
pacwidget = wibox.widget.textbox()
pacwidget_t = awful.tooltip({ objects = { pacwidget},})

vicious.register(pacwidget, vicious.widgets.pkg,
                function(widget,args)
                    local io = { popen = io.popen }
                    local s = io.popen("pacman -Qu")
                    local str = ''

                    for line in s:lines() do
                        str = str .. line .. "\n"
                    end
                    pacwidget_t:set_text(str)
                    s:close()
                    return " | upd: " .. args[1] .. " |"
                end, 1800, "Arch")

                --'1800' means check every 30 minutes

--cmus_widget = wibox.widget.textbox()

--- vicious.register(cmus_widget, vicious.widgets.cmus,
--       function (widget, args)
--           if args["{status}"] == "Stopped" then 
--               return " - "
--           else 
--               return args["{status}"]..': '.. args["{artist}"]..' - '.. args["{title}"]..'  ###  '.. args["{genre}"]
--           end
--       end, 7)
---}}}

cpufreq_label = wibox.widget.textbox()
cpufreq_label:set_markup("FREQ:")
cpufreq_label:set_font("Terminus 8")

cpufreq = blingbling.value_text_box()
cpufreq:set_text_background_color("#212121")
cpufreq:set_text_color("#dedede")

cpufreq:set_values_text_color({{"#dedede",0}, --all value > 0 will be displayed using this color
                          {"#d4aa00ff", 20.0},
                          {"#d45500ff",32.0}})

-- cpufreq:set_default_text_color("#98989844")
    --core1temp:set_rounded_size(0.3)
cpufreq:set_font("Terminus")
cpufreq:set_font_size(12)
cpufreq:set_label("·$percent°")
cpufreq:set_width(32)

vicious.register(cpufreq, vicious.widgets.cpufreq, '$1', 4, "cpu0")

temps = wibox.widget.textbox()
temps:set_markup(" TEMP::")
temps:set_font("Terminus 8")


coretemp = {}

for i=1,4 do
--    if i%2 == 1 then
    coretemp[i] = blingbling.value_text_box()
    coretemp[i]:set_text_background_color("#212121")
    coretemp[i]:set_text_color(beautiful.textbox_widget_as_label_font_color)
  coretemp[i]:set_values_text_color({{"#FFFFFFff",0}, --all value > 0 will be displayed using this color
                          {"#d4aa00ff", 0.50},
                          {"#d45500ff",0.65}})
    --core1temp:set_rounded_size(0.3)
    coretemp[i]:set_font("Terminus")
    coretemp[i]:set_font_size(12)
    coretemp[i]:set_label("·$percent°")
    coretemp[i]:set_width(32)

    vicious.register(coretemp[i], vicious.widgets.thermal, "$1",10 ,{"coretemp.0/hwmon/hwmon1", "core", i+1})
--    end
end

amdgputemp = blingbling.value_text_box()
amdgputemp:set_text_background_color("#212121")
amdgputemp:set_text_color(beautiful.textbox_widget_as_label_font_color)
--hddtemp:set_rounded_size(0.3)
amdgputemp:set_values_text_color({{"#FFFFFFff",0}, --all value > 0 will be displayed using this color
                          {"#d4aa00ff", 0.50},
                          {"#d45500ff",0.70}})

amdgputemp:set_font("Terminus")
amdgputemp:set_font_size(12)
amdgputemp:set_label("AMD:$percent°")
amdgputemp:set_width(45)

function update_amd()

	local command = io.popen(os.getenv("HOME") .. "/_scripts/GPU/amd_temp.sh")
	local res = command:read()

    return { res }

end

vicious.register(amdgputemp, update_amd, "$1",10)

nvidiagputemp = blingbling.value_text_box()
nvidiagputemp:set_text_background_color("#212121")
nvidiagputemp:set_text_color(beautiful.textbox_widget_as_label_font_color)
--hddtemp:set_rounded_size(0.3)
nvidiagputemp:set_values_text_color({{"#FFFFFFff",0}, --all value > 0 will be displayed using this color
                          {"#d4aa00ff", 0.50},
                          {"#d45500ff",0.70}})

nvidiagputemp:set_font("Terminus")
nvidiagputemp:set_font_size(12)
nvidiagputemp:set_label("NV:$percent°")
nvidiagputemp:set_width(45)

function update_nvidia()

	local command = io.popen(os.getenv("HOME") .. "/_scripts/GPU/nvidia_temp.sh")
	local res = command:read()

    return { res }
--    return { awful.util.pread(os.getenv("HOME") .. '/_scripts/GPU/nvidia_temp.sh') }
end

vicious.register(nvidiagputemp, update_nvidia, "$1",10)

iostatlabel = wibox.widget.textbox()
iostatlabel:set_markup(" IOSTAT::")
iostatlabel:set_font("Terminus 8")

write_stat = blingbling.value_text_box()
write_stat:set_text_background_color("#212121")
--hddtemp:set_rounded_size(0.3)
write_stat:set_font("Terminus")
write_stat:set_font_size(12)
write_stat:set_label("W:$percentMb")
write_stat:set_width(80)

function update_ws()
    return { awful.util.pread(os.getenv("HOME") .. '/_scripts/write_stat.sh')}
end

vicious.register(write_stat, update_ws, "$1", 10)

read_stat = blingbling.value_text_box()
read_stat:set_text_background_color("#212121")
--hddtemp:set_rounded_size(0.3)
read_stat:set_font("Terminus")
read_stat:set_font_size(12)
read_stat:set_label("R:$percentMb")
read_stat:set_width(80)

function update_rs()
    return { awful.util.pread(os.getenv("HOME") .. '/_scripts/read_stat.sh')}
end

vicious.register(read_stat, update_rs, "$1", 10)

hddtemp = blingbling.value_text_box()
hddtemp:set_text_background_color("#212121")
hddtemp:set_values_text_color({{"#FFFFFFff",0}, --all value > 0 will be displayed using this color
                          {"#d4aa00ff", 0.40},
                          {"#d45500ff",0.50}})

--hddtemp:set_rounded_size(0.3)
hddtemp:set_font("Terminus")
hddtemp:set_font_size(12)
hddtemp:set_label("HDD:$percent°")
hddtemp:set_width(40)

vicious.register(hddtemp, vicious.widgets.hddtemp, '${/dev/sda}', 19)

--ups_label = wibox.widget.textbox()
--ups_label:set_markup(" UPS: ")
--ups_label:set_font("Terminus 8") 

--ups_stat = wibox.widget.textbox()
--ups_stat:set_font("Terminus 8") 

--function update_ups_status()
--  return { awful.util.pread(os.getenv("HOME") .. '/_scripts/apc/read_status.sh')}
--end

--vicious.register(ups_stat, update_ups_status, "$1", 10)

--ups_input_voltage = blingbling.value_text_box()
--ups_input_voltage:set_text_background_color("#98989844")
--ups_input_voltage:set_font("Terminus")
--ups_input_voltage:set_font_size(12)
--ups_input_voltage:set_label("IN:$percent")
--ups_input_voltage:set_width(55)

--function update_ups_input_voltage()
--  return { awful.util.pread(os.getenv("HOME") .. '/_scripts/apc/read_linev.sh') }
--end

--vicious.register(ups_input_voltage, update_ups_input_voltage, "$1", 10)

--ups_output_voltage = blingbling.value_text_box()
--ups_output_voltage:set_text_background_color("#98989844")
--ups_output_voltage:set_font("Terminus")
--ups_output_voltage:set_font_size(12)
--ups_output_voltage:set_label("OUT:$percent")
--ups_output_voltage:set_width(60)

--function update_ups_output_voltage()
--  return { awful.util.pread(os.getenv("HOME") .. '/_scripts/apc/read_outputv.sh')}
--end

--vicious.register(ups_output_voltage, update_ups_output_voltage, "$1", 9)

--ups_load = blingbling.value_text_box()
--ups_load:set_text_background_color("#98989844")
--ups_load:set_font("Terminus")
--ups_load:set_font_size(12)
--ups_load:set_label("LOAD:$percentW")
--ups_load:set_width(75)

--function update_ups_load()
--  return { awful.util.pread(os.getenv("HOME") .. '/_scripts/apc/read_load.sh')}
--end

--vicious.register(ups_load, update_ups_load, "$1", 10)

--ups_temp = blingbling.value_text_box()
--ups_temp:set_text_background_color("#98989844")
--ups_temp:set_font("Terminus")
--ups_temp:set_font_size(12)
--ups_temp:set_label("TEMP:$percent°")
--ups_temp:set_width(65)

--function update_ups_temp()
--  return { awful.util.pread(os.getenv("HOME") .. '/_scripts/apc/read_temp.sh')}
--end

--vicious.register(ups_temp, update_ups_temp, "$1", 11)

space_usage = wibox.widget.textbox()
space_usage:set_markup(" SPACE::")
space_usage:set_font("Terminus 8")

--space_usage:set_font_size(12)

--total_write = blingbling.value_text_box()
--total_write:set_text_background_color("#98989844")
--total_write:set_rounded_size(0.3)
--total_write:set_font("Terminus")
--total_write:set_font_size(12)
--total_write:set_label("sda_read: $percent")
--total_write:set_width(100)

--vicious.register(total_write, vicious.widgets.dio, "${sda1 total_mb}")

home_dir = blingbling.value_text_box()
home_dir:set_text_background_color("#212121")
--home_dir:set_rounded_size(0.3)
home_dir:set_values_text_color({{"#FFFFFFff",0}, --all value > 0 will be displayed using this color
                          {"#d4aa00ff", 0.45},
                          {"#d45500ff",0.60}})
home_dir:set_font("Terminus")
home_dir:set_font_size(12)
home_dir:set_label("/:$percentGb")
home_dir:set_width(55)

vicious.register(home_dir, vicious.widgets.fs, "${/ avail_gb}", 19)

tmp_dir = blingbling.value_text_box()
tmp_dir:set_text_background_color("#212121")
tmp_dir:set_values_text_color({{"#FFFFFFff",0}, --all value > 0 will be displayed using this color
                          {"#d4aa00ff", 0.45},
                          {"#d45500ff",0.60}})

--tmp_dir:set_rounded_size(0.3)
tmp_dir:set_font("Terminus")
tmp_dir:set_font_size(12)
tmp_dir:set_label("/tmp:$percentGb")
tmp_dir:set_width(65)

vicious.register(tmp_dir, vicious.widgets.fs, "${/tmp avail_gb}", 19)

udisks_glue=blingbling.udisks_glue.new(beautiful.dialog_ok)
udisks_glue:set_mount_icon(beautiful.dialog_ok)
udisks_glue:set_umount_icon(beautiful.dialog_cancel)
udisks_glue:set_detach_icon(beautiful.dialog_cancel)
udisks_glue:set_Usb_icon(beautiful.usb_icon)
udisks_glue:set_Cdrom_icon(beautiful.cdrom_icon)

netlabel = wibox.widget.textbox()
netlabel:set_markup(" NET::")
netlabel:set_font("Terminus 8")

wan_ip = wibox.widget.textbox()
wan_ip:set_font("Terminus 8")

--function update_wan_ip()
--    return { awful.util.pread(os.getenv("HOME") .. '/_scripts/wan_ip.sh')}
--end

--vicious.register(wan_ip, update_wan_ip, "$1", 30)

function update_lanip()
  --local s = socket.udp()
  --s:setpeername("192.168.0.102", 80)
  --local ip = s:getsockname()
  --STR = tostring(ip)
  
  SYS_COMMAND = io.popen("/usr/bin/hostname -i");
  
  STR = SYS_COMMAND:read("*all")

  SYS_COMMAND:close()
  
  if not STR then
    return "LAN IP is NULL; "
  else
    return STR 
  end
end

delimiter_label = wibox.widget.textbox()
delimiter_label:set_markup("|")

lan_ip_label = wibox.widget.textbox()
lan_ip_label:set_markup(" LAN_IP:")

lan_ip = wibox.widget.textbox()
lan_ip:set_font("Terminus 8")

vicious.register(lan_ip, update_lanip, "$1",10)

function update_wan_ip()

    local SYS_COMMAND = io.popen('~/_scripts/wan_ip.sh')

  STR = SYS_COMMAND:read("*all")

  SYS_COMMAND:close()

  if not STR then
    return "WAN IP is NULL;"
  else
    return STR
  end
end

wan_ip_label = wibox.widget.textbox()
wan_ip_label:set_markup(" WAN_IP:")

wan_ip = wibox.widget.textbox()
wan_ip:set_font("Terminus 8")

--wan_ip = blingbling.value_text_box()
--wan_ip:set_text_background_color("#98989844")
--wan_ip:set_rounded_size(0.3)
--wan_ip:set_font("Terminus")
--wan_ip:set_font_size(12)
--wan_ip:set_label("wan:$percent")
--wan_ip:set_width(100)

vicious.register(wan_ip, update_wan_ip, "$1",10)

netwidget = blingbling.net({interface = "eth0", show_text = true})
--netwidget:set_ippopup()
netwidget:set_graph_color("#ffffff99")
netwidget:set_graph_line_color("#98989844")
netwidget:set_font("Terminus")
netwidget:set_font_size("8")

--netssid = wibox.widget.textbox()
--vicious.register(netssid, vicious.widgets.wifi, "${ssid} ", 3, "wlan0")

--netu = blingbling.value_text_box()
--netu:set_text_background_color("#98989844")
--netu:set_rounded_size(0.3)
--netu:set_font_size(10)
--netu:set_label("↑ $percent")
--netu:set_width(45)


--netu:set_label("usage $percent")
--vicious.register(netwidget, vicious.widgets.net,'${enp2s0 up_kb}', 1)

--netd = blingbling.value_text_box()
--netd:set_text_background_color("#98989844")
--netd:set_rounded_size(0.3)
--netd:set_font_size(10)
--netd:set_label("↓ $percent")
--hddtemp:set_h_margin(2)
--netd:set_width(45)

--netd:set_label("usage $percent")
--vicious.register(netd, vicious.widgets.net,'${enp2s0 down_kb}', 2)

--netd = blingbling.value_text_box()
--netd:set_width(10)
--vicious.register(netd, vicious.widgets.net,'${enp2s0 down_kb}', 1)

--separator = wibox.widget.textbox()
--separator:set_markup(" | ")

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "web", "code", "analyze", "find", "vm",  "im", "mm", "remote" }, s, awful.layout.layouts[4])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the top wibox
    s.mytopwibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mytopwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            pacwidget,
            mytextclock,
            s.mylayoutbox,
        },
    }

    -- Create the bottom wibox
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s })

    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            cpu_graph,
            mem_graph,
            cpufreq_label,
            cpufreq,
            temps,
            coretemp[1],
            coretemp[2],
            coretemp[3],
            coretemp[4],
            amdgputemp,
            nvidiagputemp,
            space_usage,
            home_dir,
            tmp_dir,
        },
        delimiter_label, -- Middle widget

        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            delimiter_label,        
            lan_ip_label,
            lan_ip,    
            wan_ip_label,
            wan_ip,
        	delimiter_label,
			netwidget,
        },
    }

end)
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
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Left", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.screen.focus_relative(-1) end),


    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- Any actions

    awful.key({ modkey,           }, "grave", function () awful.util.spawn_with_shell("urxvt -e canto -u") end),
--    awful.key({ modkey,           }, "m", function () awful.util.spawn_with_shell("sudo umount /media/*") end),i
    awful.key({ modkey, "Shift"   }, "u", function () awful.util.spawn_with_shell("urxvt -e devmon --unmount-removable") end),
    awful.key({ modkey,           }, "KP_Subtract", function () awful.util.spawn("amixer sset Master 5-") end),
    awful.key({ modkey,           }, "KP_Add", function () awful.util.spawn("amixer sset Master 5+") end),
    awful.key({                   }, "XF86AudioPlay", function () awful.util.spawn("cmus-remote -u") end),
    awful.key({                   }, "XF86AudioStop", function () awful.util.spawn("cmus-remote -s") end),
    awful.key({                   }, "XF86AudioNext", function () awful.util.spawn("cmus-remote -n") end),
    awful.key({                   }, "XF86AudioPrev", function () awful.util.spawn("cmus-remote -r") end),
--    awful.key({ modkey,  "Shift"  }, "m", function () awful.util.spawn("xset dpms force off") end),
--    awful.key({                   }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Headphone 2+") end),
--    awful.key({                   }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Headphone 2-") end),
--    awful.key({                   }, "XF86AudioMute", function () awful.util.spawn("amixer set Master toggle") end),
    awful.key({                   }, "XF86AudioRaiseVolume", function () awful.util.spawn("pulseaudio-ctl up") end),
    awful.key({                   }, "XF86AudioLowerVolume", function () awful.util.spawn("pulseaudio-ctl down") end),
    awful.key({                   }, "XF86AudioMute", function () awful.util.spawn("pulseaudio-ctl mute") end),
    awful.key({                   }, "XF86Sleep", function () awful.util.spawn("/home/nlare/_scripts/suspend/suspend.sh") end),
    awful.key({ "Shift",          }, "XF86Sleep", function () awful.util.spawn("/home/nlare/_scripts/suspend/hibernate.sh") end),
    awful.key({                 }, "Print", function () awful.util.spawn("scrot -u -e 'mv $f ~/screenshots/$n'") end),
    awful.key({                   }, "XF86Tools", 
    function ()
--         local screen = mouse.screen
       local curtag = tags[2][7]
     awful.tag.viewonly(curtag)
--         run_once("screen -S cmus-session /usr/bin/cmus")
         --.maximized = true
    end),
    awful.key({ modkey,           }, "m",
    function () 
--        local curtag = tags[2][7]
--        awful.tag.viewonly(curtag)
        awful.util.spawn_with_shell("urxvt -e /usr/bin/cmus") 
    end),
    awful.key({ modkey, "Shift"    }, "m",
    function () 
--        local curtag = tags[2][7]
--        awful.tag.viewonly(curtag)
        awful.util.spawn_with_shell("urxvt -e screen -r cmus-session") 
    end),

  awful.key({ modkey,           }, "s",
    function () 
        local curtag = tags[2][2]
        awful.tag.viewonly(curtag)
        awful.util.spawn_with_shell("subl3'") 
    end),
    awful.key({ modkey,           }, "b", function () awful.util.spawn("chromium") end),
    awful.key({ modkey,  "Shift"  }, "b", function () awful.util.spawn("chromium --user-data-dir=/home/nlare/_adm/browser/chrome/data_dir/ --incognito") end),
    awful.key({ modkey,           }, "f", function () awful.util.spawn_with_shell("urxvt -e mc") end),
    awful.key({ modkey,  "Shift"  }, "f", function () awful.util.spawn_with_shell("doublecmd") end),
    awful.key({ modkey,  "Shift"  }, "a", function () awful.util.spawn_with_shell("xrandr --auto") end),
    awful.key({ modkey,           }, "d", function () awful.util.spawn("urxvt -e sdcv") end),
    awful.key({ modkey,         }, "r", function () awful.util.spawn("urxvt -e canto-curses") end),
    awful.key({ modkey,           }, "g", function () awful.util.spawn("gvim") end),
    awful.key({ modkey,  "Shift"  }, "g", function () awful.util.spawn_with_shell("subl3") end),
    awful.key({ modkey,       }, "a", function () awful.util.spawn_with_shell("urxvt -e anamnesis -b") end),
    awful.key({ "Control",        }, "Escape", function () awful.util.spawn("urxvt -e sudo wifi-menu") end),
    awful.key({ modkey,   "Shift"     }, "i", function () awful.util.spawn("skype") end),
    awful.key({ modkey,         }, "i", function () awful.util.spawn("urxvt -e screen -S irssi /usr/bin/irssi") end),
--    awful.key({ modkey,    }, "i", function () awful.util.spawn(terminal .. " -e toxic") end),
        -- Escape from keyboard focus trap (eg Flash plugin in Firefox)
    awful.key({ modkey, "Control" }, "Escape", function ()
         awful.util.spawn("xdotool getactivewindow mousemove --window %1 0 0 click --clearmodifiers 2")
    end), 
    --

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"}),
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

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    -- { rule_any = {type = { "normal", "dialog" }
      -- }, properties = { titlebars_enabled = true } },

    -- Set other rules for other windows of other programs

  { rule = { class = "MPlayer" },
      properties = { floating = true }, screen = 1, tag = 7 },
  { rule = { class = "Vlc" },
      properties = { maximaze = true }, screen = 1, tag = 7 }, 
  { rule = { class = "skype" },
      properties = { floating = true, screen = 1, tag = 6 } },
  { rule = { name = "uTox" },
      properties = { floating = false, screen = 1, tag = 6  } },
  { rule = { class = "pinentry" },
      properties = { floating = true } },
  { rule = { class = "gimp" },
      properties = { floating = true } },
  { rule = { class = "chromium" },
      properties = { floating = false, screen = 2, tag = 1, switchtotag = true } },
  { rule = { instance = "exe" },
      properties = { floating = true } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    { rule = { class = "Plugin-container" },
      properties = { floating = true, screen = 2, tag = 1  } },
    { rule = { class = "Gvim" },
      properties = { floating = false, size_hints_honor = false } },
    { rule = { class = "URxvt" },
      properties = { floating = false, size_hints_honor = false } },
    { rule = { class = "Java" },
      properties = { floating = true} },
  { rule = { class = "Zathura" },
      properties = { floating = false, screen = 3, tag = 3, switchtotag = true } },
  { rule = { class = "Spicy" },
    properties = { floating = false, screen = 1, tag = 5, fullscreen = false, switchtotag = true } },
  { rule = { class = "net-minecraft-server-MinecraftServer" },
    properties = { floating = false, screen = 2, tag = 8, fullscreen = false, switchtotag = false } },
  { rule = { class = "Gifview" },
      properties = { floating = true } },
  { rule = { class = "Wine" },
      properties = { floating = true } },
  { rule = { class = "nwn" },
      properties = { floating = false, screen = 1, tag = 7 } },
  { rule = { class = "Conky" },
      properties = { floating = true,
             sticky = false,
             ontop = false,
               focusable = false } },
  { rule = { name = "Save File" },
      properties = { floating = false } },
  { rule = { class = "Clamtk" },
      properties = { floating = true } },
  { rule = { class = "xfreerdp" },
      properties = { floating = false, screen = 1, tag = 8  } },
  { rule = { instance = "crx_knipolnnllmklapflnccelgolnpehhpl" },
    properties = { floating = false, screen = 1, tag = 6  } },
  { rule = { instance = "crx_nckgahadagoaajjgafhacjanaoiihapd" },
    properties = { floating = false, screen = 1, tag = 6  } },
  { rule = { class = "jetbrains-studio" },
      properties = { floating = false, screen = 1, tag = 2 } },
  { rule = { class = "sun-awt-X11-XDialogPeer" },
      properties = { floating = false, screen = 1, tag = 2 } },
  -- { rule = { class = "Subl3" },
      -- properties = { floating = false, screen = 1, tag = 2 } },
  { rule = { class = "RBDoom3BFG" },
      properties = { floating = true, screen = 1, tag = 7, switchtotag = true } },
  { rule = { class = "Steam" },
      properties = { floating = true, screen = 1, tag = 7, switchtotag = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
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

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ") 2>/dev/null")
end

run_once("wmname LG3D")
-- run_once("kbdd")
--run_once("devmon")
run_once("yeahconsole")
run_once("anamnesis --start")
run_once("notify-listener")
--run_once("pulseaudio --start")
--run_once("firefox")
--run_once("dropbox")
--run_once("udiskie --tray")
--run_once("utox")
-- awful.util.spawn_with_shell("/home/nlare/_scripts/hdd_stop.sh /dev/sdb")
-- awful.util.spawn_with_shell("/home/nlare/_scripts/hdd_stop.sh /dev/sdc")
--awful.util.spawn_with_shell("/home/nlare/_scripts/alsa/enable_spdif.sh")
awful.util.spawn_with_shell("tmux new-session -s conky-windows -d /home/nlare/conky/conky-run.sh")
awful.util.spawn_with_shell("/home/nlare/_scripts/VNC/x11vnc-run.sh")
awful.util.spawn_with_shell("/usr/bin/xautolock -time 30 -locker /usr/local/bin/i3lock-full-command -detectsleep")
awful.util.spawn_with_shell("sudo /usr/bin/ethtool -s eth0 wol g")
--awful.util.spawn_with_shell("dropbox-cli start")
--awful.util.spawn_with_shell("tmux new-session -s sbxkb-proc -d sbxkb")
--run_once("~/_scripts/apc/apc_status.sh")
--run_once("~/_scripts/apc/apc_linev.sh")
--run_once("~/_scripts/apc/apc_outputv.sh")
--run_once("~/_scripts/apc/apc_load.sh")
--run_once("~/_scripts/apc/apc_temp.sh")
-- run_once("xscreensaver -no-splash")
-- run_once("xbattbar-acpi -b 1")
