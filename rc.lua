-- Standard awesome library
package.path = package.path .. ';/usr/share/awesome/lib/?/init.lua;/usr/share/awesome/lib/?.lua'

local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
local util = require('awful.util')
require("awful.autofocus")
--require("eminent")
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
--local launchbar = require("launchbar")
--local mylb = launchbar("/home/nlare/.config/awesome/launchbar")
--local wicked = require("wicked") 
--local calendar = require("calendar")
--local revelation = require("revelation")
-- local blingbling = require("blingbling")
-- module("blingbling.helpers")
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

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ") 2>/dev/null")
end

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
themes_dir = os.getenv("HOME") .. ".config/awesome/themes"
beauty_theme = "/home/nlare/.config/awesome/themes/bw/theme.lua"
beautiful.init(beauty_theme)

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

local layouts =
{
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
     awful.layout.suit.floating
}
-- }}}

-- {{{ Wallpaper
wallpaper =  os.getenv("HOME") .. "/.config/awesome/themes/bw/black-wood.jpg"

if wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(wallpaper, s)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "web", "code", "analyze", "find", "vm",  "im", "mm", "remote" }, s, layouts[5])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "edit theme", editor_cmd .. " " .. beauty_theme },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
   { "gracefully restart", "/home/nlare/_scripts/awesome/grace_restart.sh" },
   { "gracefully shutdown", "/home/nlare/_scripts/awesome/grace_shutdown.sh" }
}

myaudiomenu = {
    { "gtkguitune", "gtkguitune" },
    { "audacity", "audacity" },
    { "flacon", "flacon" },
    { "soundconverter", "soundconverter" }
}

myvideomenu = {
    -- { "LightWorks", "lightworks" },
    { "OpenShot", "openshot" },
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

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

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

    vicious.register(coretemp[i], vicious.widgets.thermal, "$1",10 ,{"coretemp.0/hwmon/hwmon2", "core", i+1})
--    end
end

gputemp = blingbling.value_text_box()
gputemp:set_text_background_color("#212121")
gputemp:set_text_color(beautiful.textbox_widget_as_label_font_color)
--hddtemp:set_rounded_size(0.3)
gputemp:set_values_text_color({{"#FFFFFFff",0}, --all value > 0 will be displayed using this color
                          {"#d4aa00ff", 0.50},
                          {"#d45500ff",0.70}})

gputemp:set_font("Terminus")
gputemp:set_font_size(12)
gputemp:set_label("GPU:$percent°")
gputemp:set_width(45)

function update_amd()
    return { awful.util.pread(os.getenv("HOME") .. '/_scripts/amd_temp.sh')}
end

vicious.register(gputemp, update_amd, "$1",10)

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
--	return { awful.util.pread(os.getenv("HOME") .. '/_scripts/apc/read_status.sh')}
--end

--vicious.register(ups_stat, update_ups_status, "$1", 10)

--ups_input_voltage = blingbling.value_text_box()
--ups_input_voltage:set_text_background_color("#98989844")
--ups_input_voltage:set_font("Terminus")
--ups_input_voltage:set_font_size(12)
--ups_input_voltage:set_label("IN:$percent")
--ups_input_voltage:set_width(55)

--function update_ups_input_voltage()
--	return { awful.util.pread(os.getenv("HOME") .. '/_scripts/apc/read_linev.sh') }
--end

--vicious.register(ups_input_voltage, update_ups_input_voltage, "$1", 10)

--ups_output_voltage = blingbling.value_text_box()
--ups_output_voltage:set_text_background_color("#98989844")
--ups_output_voltage:set_font("Terminus")
--ups_output_voltage:set_font_size(12)
--ups_output_voltage:set_label("OUT:$percent")
--ups_output_voltage:set_width(60)

--function update_ups_output_voltage()
--	return { awful.util.pread(os.getenv("HOME") .. '/_scripts/apc/read_outputv.sh')}
--end

--vicious.register(ups_output_voltage, update_ups_output_voltage, "$1", 9)

--ups_load = blingbling.value_text_box()
--ups_load:set_text_background_color("#98989844")
--ups_load:set_font("Terminus")
--ups_load:set_font_size(12)
--ups_load:set_label("LOAD:$percentW")
--ups_load:set_width(75)

--function update_ups_load()
--	return { awful.util.pread(os.getenv("HOME") .. '/_scripts/apc/read_load.sh')}
--end

--vicious.register(ups_load, update_ups_load, "$1", 10)

--ups_temp = blingbling.value_text_box()
--ups_temp:set_text_background_color("#98989844")
--ups_temp:set_font("Terminus")
--ups_temp:set_font_size(12)
--ups_temp:set_label("TEMP:$percent°")
--ups_temp:set_width(65)

--function update_ups_temp()
--	return { awful.util.pread(os.getenv("HOME") .. '/_scripts/apc/read_temp.sh')}
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
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywiboxtop[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    local mid_layout = wibox.layout.fixed.horizontal()
    
    --mid_layout:add(cmus_widget)
    mid_layout:add(mytasklist[s])
 
    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()

    -- right_layout:add(gmaillabel)
    -- right_layout:add(gmail)
    right_layout:add(pacwidget)
--    right_layout:add(mylb)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])
    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()

    layout:set_left(left_layout)
    layout:set_middle(mid_layout)
    --layout:set_left(task_layout)
    --layout:set_middle(mid_layout)
    layout:set_right(right_layout)

    mywiboxtop[s]:set_widget(layout)
    
    -- Create a bot wibox
    mywiboxbot[s] = awful.wibox({ position = "bottom", screen = s })

    local left_graph = wibox.layout.fixed.horizontal()

    left_graph:add(cpu_graph)
    
--    for i=1,2 do
--       left_graph:add(cores_graphs[i]) 
--    end

    left_graph:add(mem_graph)
    --left_graph:add(mem_all)
    --left_graph:add(cpu_icon)
    --left_graph:add(cpuwidget)
    --
    --left_graph:add(mem_icon)
    --left_graph:add(memgraph)
    --mid_layout:add(memwidget)
--    left_graph:add(netu)
--    left_graph:add(netd)
	
	left_graph:add(cpufreq_label)
	left_graph:add(cpufreq)

    left_graph:add(temps)

    for i=1,4 do
--        if i%2 == 1 then
            left_graph:add(coretemp[i])
--        end
    end

    left_graph:add(hddtemp)
    left_graph:add(gputemp)
    left_graph:add(space_usage)
    left_graph:add(home_dir)
    left_graph:add(tmp_dir)
--    left_graph:add(total_write)
--    left_graph:add(iostatlabel)
--    left_graph:add(write_stat)
--    left_graph:add(read_stat)
--	left_graph:add(ups_label)
--	left_graph:add(ups_stat)
--	left_graph:add(ups_input_voltage)
--	left_graph:add(ups_output_voltage)
--	left_graph:add(ups_load)
--	left_graph:add(ups_temp)
--	left_graph:add(netlabel)
--	left_graph:add(wan_ip)

	local mid_graph = wibox.layout.fixed.horizontal() 

    --mid_graph:add(cmus_widget)
    --mid_graph:add(mytaglist[s])
    --mid_graph:add(mpdstat)

--	mid_graph:add(netlabel)
--	mid_graph:add(mylb)
  mid_graph:add(lan_ip_label)
  mid_graph:add(lan_ip)
  mid_graph:add(wan_ip_label)
  mid_graph:add(wan_ip)

--    mid_graph:add(wan_ip)

    local right_graph = wibox.layout.fixed.horizontal()

--    right_graph:add(netssid)
    right_graph:add(netwidget)

	if s == 1 then right_graph:add(wibox.widget.systray()) end

    local layout_graph = wibox.layout.align.horizontal()
    layout_graph:set_left(left_graph)
    layout_graph:set_middle(mid_graph)
    layout_graph:set_right(right_graph)

    mywiboxbot[s]:set_widget(layout_graph)

--    mywiboxleft[s] = awful.wibox({ position = "left", screen = s })
 
--    local mylaunchbar = wibox.layout.fixed.vertical()

--    right_graph:add(netssid)
--    mylaunchbar:add(netwidget)

--    local layout = wibox.layout.align.horizontal()

--    layout:set_left(mylaunchbar)

--    mywiboxleft[s]:set_widget(layout)

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
    awful.key({ modkey,           }, "e", revelation),
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
    awful.key({ modkey,   "Shift"    }, "e", function () awful.util.spawn(editor .. " " .. awesome.conffile) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, "Shift"   }, "Left", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.screen.focus_relative(-1) end),
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

    awful.key({ modkey,           }, "grave", function () awful.util.spawn_with_shell("urxvt -e canto -u") end),
--    awful.key({ modkey,           }, "m", function () awful.util.spawn_with_shell("sudo umount /media/*") end),i
    awful.key({ modkey, "Shift"	  }, "u", function () awful.util.spawn_with_shell("urxvt -e devmon --unmount-removable") end),
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
    awful.key({	"Shift",          }, "XF86Sleep", function () awful.util.spawn("/home/nlare/_scripts/suspend/hibernate.sh") end),
    awful.key({		              }, "Print", function () awful.util.spawn("scrot -u -e 'mv $f ~/screenshots/$n'") end),
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
    awful.key({ modkey,    		  }, "r", function () awful.util.spawn("urxvt -e canto-curses") end),
    awful.key({ modkey,           }, "g", function () awful.util.spawn("gvim") end),
    awful.key({ modkey,  "Shift"  }, "g", function () awful.util.spawn_with_shell("subl3") end),
    awful.key({ modkey,  		  }, "a", function () awful.util.spawn_with_shell("urxvt -e anamnesis -b") end),
    awful.key({ "Control",        }, "Escape", function () awful.util.spawn("urxvt -e sudo wifi-menu") end),
    awful.key({ modkey,   "Shift"     }, "i", function () awful.util.spawn("skype") end),
    awful.key({ modkey,    		  }, "i", function () awful.util.spawn("urxvt -e screen -S irssi /usr/bin/irssi") end),
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
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    -- awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    -- awful.key({ modkey },            "r",     function () awful.util.spawn_with_shell("dmenu_run -b") end),

    --awful.key({ modkey }, "x",
    --          function ()
    --              awful.prompt.run({ prompt = "Run Lua code: " },
    --              mypromptbox[mouse.screen].widget,
    --              awful.util.eval, nil,
    --              awful.util.getdir("cache") .. "/history_eval")
    --          end),
    -- Menubar
    awful.key({ modkey, "Shift" }, "r", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
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
   keynumber = math.min(9, math.max(#tags[s], keynumber))
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

 --for i = 1, 9 do
 --   globalkeys = awful.util.table.join(globalkeys,
 --       -- View tag only.
 --       awful.key({ modkey }, "#" .. i + 9,
 --                 function ()
 --                       local screen = awful.screen.focused()
 --                       local tag = screen.tags[i]
 --                       if tag then
 --                          tag:view_only()
 --                       end
 --                 end,
 --                 {description = "view tag #"..i, group = "tag"}),
 --       -- Toggle tag.
 --       awful.key({ modkey, "Control" }, "#" .. i + 9,
 --                 function ()
 --                     local screen = awful.screen.focused()
 --                     local tag = screen.tags[i]
 --                     if tag then
 --                        awful.tag.viewtoggle(tag)
 --                     end
 --                 end,
 --                 {description = "toggle tag #" .. i, group = "tag"}),
 --       -- Move client to tag.
 --       awful.key({ modkey, "Shift" }, "#" .. i + 9,
 --                 function ()
 --                     if client.focus then
 --                         local tag = client.focus.screen.tags[i]
 --                         if tag then
 --                             client.focus:move_to_tag(tag)
 --                         end
 --                    end
 --                 end,
 --                 {description = "move focused client to tag #"..i, group = "tag"}),
 --       -- Toggle tag on focused client.
 --       awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
 --                 function ()
 --                     if client.focus then
 --                         local tag = client.focus.screen.tags[i]
 --                         if tag then
 --                             client.focus:toggle_tag(tag)
 --                         end
 --                     end
 --                 end,
 --                 {description = "toggle focused client on tag #" .. i, group = "tag"})
 --   )
 --end

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
--      properties = { border_width = beautiful.border_width,
--                     border_color = beautiful.border_normal,
--                     focus = awful.client.focus.filter,
--                     keys = clientkeys,
--                     buttons = clientbuttons } },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },		
    { rule = { class = "MPlayer" },
      properties = { floating = true }, tag = tags[2][7] },
	{ rule = { class = "Vlc" },
      properties = { maximaze = true }, tag = tags[2][7] }, 
    { rule = { class = "skype" },
      properties = { floating = true, tag = tags[2][6] } },
	{ rule = { name = "uTox" },
      properties = { floating = false, tag = tags[1][6] } },
	{ rule = { name = "Video Preview" },
      properties = { floating = true, tag = tags[1][7] } },
    { rule = { class = "Doublecmd" },
      properties = { floating = true, tag = tags[1][3] } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "chromium" },
      properties = { floating = false, tag = tags[2][1], switchtotag = true } },
	{ rule = { instance = "exe" },
      properties = { floating = true } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    { rule = { class = "Plugin-container" },
      properties = { floating = true, tag = tags[1][1] } },
    { rule = { class = "Gvim" },
      properties = { floating = false, size_hints_honor = false } },
    { rule = { class = "URxvt" },
      properties = { floating = false, size_hints_honor = false } },
    { rule = { class = "Java" },
      properties = { floating = true} },
    { rule = { class = "Eclipse" },
      properties = { floating = true, tag = tags[1][2]} },
	{ rule = { class = "Zathura" },
      properties = { floating = false, tag = tags[1][3], switchtotag = true } },
	{ rule = { name = "QEMU" },
	  properties = { floating = true, tag = tags[1][5] } },
--	{ rule = { name = "Connect to SPICE" },
--	  properties = { floating = true, tag = tags[1][5] } },
	{ rule = { class = "Spicy" },
	  properties = { floating = false, tag = tags[1][5], fullscreen = false, switchtotag = true } },
	{ rule = { class = "net-minecraft-server-MinecraftServer" },
	  properties = { floating = false, tag = tags[1][8], fullscreen = false, switchtotag = false } },
	{ rule = { class = "Gifview" },
      properties = { floating = true } },
	{ rule = { class = "lxappearance" },
      properties = { floating = true, tag = tags[1][6]} },
	{ rule = { class = "Wine" },
      properties = { floating = true } },
	{ rule = { class = "nwn" },
      properties = { floating = false, tag = tags[1][4]} },
	{ rule = { class = "Conky" },
      properties = { floating = true,
	  				 sticky = false,
				     ontop = false,
      				 focusable = false } },
	{ rule = { name = "Save File" },
      properties = { floating = false } },
	{ rule = { class = "Clamtk" },
      properties = { floating = true } },
	{ rule = { class = "Tkabber" },
      properties = { floating = false, tag = tags[1][6] } },
	{ rule = { class = "Toplevel" },
      properties = { floating = false, tag = tags[1][6] } },
	{ rule = { class = "xfreerdp" },
      properties = { floating = false, tag = tags[1][5] } },
	{ rule = { class = "Pidgin" },
      properties = { floating = false, tag = tags[1][6] } },
    { rule = { instance = "crx_knipolnnllmklapflnccelgolnpehhpl" },
	  properties = { floating = false, tag = tags[1][6] } },
    { rule = { instance = "crx_nckgahadagoaajjgafhacjanaoiihapd" },
	  properties = { floating = false, tag = tags[1][6] } },
    { rule = { class = "jetbrains-studio" },
      properties = { floating = false, maximaze = true, tag = tags[2][2] } },
    { rule = { class = "sun-awt-X11-XDialogPeer" },
      properties = { floating = false, maximaze = true, tag = tags[2][2] } },
    { rule = { class = "Subl3" },
      properties = { floating = true, tag = tags[2][2] } },    
	{ rule = { class = "RBDoom3BFG" },
      properties = { floating = true, tag = tags[1][7], switchtotag = true } },
	{ rule = { class = "Steam" },
      properties = { floating = true, tag = tags[1][7], switchtotag = true } },
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
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
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
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--awful.util.spawn_with_shell("setxkbmap -layout \"us,ru\" -option \"grp:caps_toggle,grp_led:scroll\"")
--awful.util.spawn_with_shell("sudo dhcpcd")
--run_once("compton --config ~/.compton.conf")
--run_once("feh --bg-scale /home/nlare/.config/awesome/themes/nlare/background.jpg")
--ftp_mount = os.getenv("HOME") .. "/_scripts/ftp_mount.sh"
--awful.util.spawn_with_shell(ftp_mount)
--run_once("cairo-compmgr")
run_once("wmname LG3D")
run_once("kbdd")
--run_once("devmon")
run_once("yeahconsole")
run_once("anamnesis --start")
run_once("notify-listener")
--run_once("pulseaudio --start")
--run_once("firefox")
--run_once("dropbox")
--run_once("udiskie --tray")
--run_once("utox")
awful.util.spawn_with_shell("/home/nlare/_scripts/hdd_stop.sh /dev/sdb")
awful.util.spawn_with_shell("/home/nlare/_scripts/hdd_stop.sh /dev/sdc")
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
