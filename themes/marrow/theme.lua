--[[

     Powerarrow Awesome WM theme
     github.com/lcpz

--]]

local gears     = require("gears")
local lain      = require("lain")
local awful     = require("awful")
local wibox     = require("wibox")
local dpi       = require("beautiful.xresources").apply_dpi
local naughty   = require("naughty")
local beautiful = require("beautiful")
-- local mylang  = require("components.lang")

local math, string, os = math, string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/marrow"
theme.wallpaper                                 = theme.dir .. "/wall.png"
theme.font                                      = "Terminus 13"
theme.fg_normal                                 = "#F0EDEE"
theme.fg_focus                                  = "#32D6FF"
theme.fg_urgent                                 = "#C83F11"
theme.bg_normal                                 = "#0A090Ca0"
theme.bg_focus                                  = "#1E2320"
theme.bg_urgent                                 = "#3F3F3F"
theme.taglist_fg_focus                          = "#00CCFF"
theme.tasklist_bg_focus                         = "#222222"
theme.tasklist_fg_focus                         = "#00CCFF"
theme.border_width                              = dpi(2)
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#32D6FF"
theme.border_marked                             = "#CC9393"
theme.titlebar_bg_focus                         = "#3F3F3F"
theme.titlebar_bg_normal                        = "#3F3F3F"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_stages                     = {
    [100] = theme.dir .. "/icons/battery-100.png",
    [90] = theme.dir .. "/icons/battery-90.png",
    [80] = theme.dir .. "/icons/battery-80.png",
    [70] = theme.dir .. "/icons/battery-70.png",
    [60] = theme.dir .. "/icons/battery-60.png",
    [50] = theme.dir .. "/icons/battery-50.png",
    [40] = theme.dir .. "/icons/battery-40.png",
    [30] = theme.dir .. "/icons/battery-30.png",
    [20] = theme.dir .. "/icons/battery-20.png",
    [10] = theme.dir .. "/icons/battery-10.png",
}
theme.widget_battery_sync                       = theme.dir .. "/icons/battery_sync.png"
theme.widget_battery_charging                   = theme.dir .. "/icons/battery_charging.png"
theme.widget_brightness                         = theme.dir .. "/icons/brightness.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 5
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"
theme.bg_systray                                = theme.bg_normal
theme.notification_max_height                   = 120
theme.notification_icon_size                    = 120

local markup = lain.util.markup
local separators = lain.util.separators

-- Volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(theme.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(theme.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(theme.widget_vol_low)
        else
            volicon:set_image(theme.widget_vol)
        end

        widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "% "))
    end
})
theme.volume.widget:buttons(awful.util.table.join(
    awful.button({}, 4, function()
        awful.util.spawn("amixer set Master 1%+")
        theme.volume.update()
    end),
    awful.button({}, 5, function()
        awful.util.spawn("amixer set Master 1%-")
        theme.volume.update()
    end)
))

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

-- Coretemp (lain, average)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C "))
    end
})
--]]
local tempicon = wibox.widget.imagebox(theme.widget_temp)

-- / fs
local fsicon = wibox.widget.imagebox(theme.widget_hdd)

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery_sync)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then

            if bat_now.ac_status == 1 then
                baticon:set_image(theme.widget_battery_charging)
                return
            else
                local perc = tonumber(bat_now.perc)

                for icon_percent, battery_icon in pairs(theme.widget_battery_stages) do
                    if perc <= icon_percent then
                        baticon:set_image(battery_icon)
                    end
                end
            end
            widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
        else
            baticon:set_image(theme.widget_battery_sync)
        end
    end
})

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#FEFEFE", " " .. net_now.received .. " ↓↑ " ..
            net_now.sent .. " "))
    end
})

-- Separators
local arrow = separators.arrow_left

function theme.powerline_rl(cr, width, height)
    local arrow_depth, offset = height / 2, 0

    -- Avoid going out of the (potential) clip area
    if arrow_depth < 0 then
        width  = width + 2 * arrow_depth
        offset = -arrow_depth
    end

    cr:move_to(offset + arrow_depth, 0)
    cr:line_to(offset + width, 0)
    cr:line_to(offset + width - arrow_depth, height / 2)
    cr:line_to(offset + width, height)
    cr:line_to(offset + arrow_depth, height)
    cr:line_to(offset, height / 2)

    cr:close_path()
end

function theme.powerline_lr(cr, width, height)
    local arrow_depth, offset = height / 2, 0

    -- Avoid going out of the (potential) clip area
    if arrow_depth < 0 then
        width  = width + 2 * arrow_depth
        offset = -arrow_depth
    end

    cr:move_to(offset, 0)
    cr:line_to(offset + width - arrow_depth, 0)
    cr:line_to(offset + width, height / 2)
    cr:line_to(offset + width - arrow_depth, height)
    cr:line_to(offset, height)
    cr:line_to(offset + arrow_depth, height / 2)

    cr:close_path()
end

local function pl(widget, padding)
    return wibox.container.margin(widget, dpi(10), dpi(10), padding or dpi(5),
        padding or dpi(5))
end

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags

    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    s.systray = wibox.widget.systray()
    s.systray.visible = false

    -- Create an info widget group
    s.info_widgets = {
        pl(wibox.widget { memicon, mem.widget, layout = wibox.layout.align.horizontal }),
        pl(wibox.widget { cpuicon, cpu.widget, layout = wibox.layout.align.horizontal }),
        pl(wibox.widget { tempicon, temp.widget, layout = wibox.layout.align.horizontal }),
    }

    for index, widget in ipairs(s.info_widgets) do
        s.info_widgets[index].visible = false
    end

    -- Create a clock
    os.setlocale(os.getenv("LANG"))
    local myclock = wibox.widget.textclock()

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = dpi(30),
        bg = theme.bg_normal,
        fg = theme.fg_normal,
        type = "dock"
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.container.margin(nil, dpi(30)),
                pl(wibox.widget { require('components.lang')(), layout = wibox.layout.align.horizontal }, dpi(2)),
            },
            nil,
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                s.info_widgets[0],
                s.info_widgets[1],
                s.info_widgets[2],
                pl(wibox.widget { baticon, bat.widget, layout = wibox.layout.align.horizontal }),
                pl(wibox.widget { s.systray, layout = wibox.layout.align.horizontal }),
                wibox.container.margin(nil, dpi(30)),
            },
        },
        {
            myclock,
            valign = "center",
            halign = "center",
            layout = wibox.container.place
        } -- Middle widget
    }
end

return theme
