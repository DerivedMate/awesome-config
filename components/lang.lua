-- ===================================================================
-- Initialization
-- ===================================================================


local wibox     = require("wibox")
local awful     = require("awful")
local gears     = require("gears")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local dpi       = beautiful.xresources.apply_dpi

local factory = function (args)
  local langs = { 'pl', 'gr', 'il', 'ru' }
  local def_lang = 'pl'
  local lang_len = 0
  local lang_index = {}
  for i, v in ipairs(langs) do
    lang_len = lang_len + 1
    lang_index[v] = i
  end

  local lang_widget = wibox.widget {
    markup = langs[1],
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  local function trim1(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
  end

  local function get_current_lang_index(cb)
    awful.spawn.easy_async_with_shell(
      "setxkbmap -print -verbose 10 | grep layout | awk '{ print $2 }' | sed 's/[\\s\\t\\n\\r]+//g'",
      function(stdout)
          local current_lang = trim1(stdout)
          cb(tonumber(lang_index[current_lang]) % lang_len)
      end,
      false
    )
  end

  local function set_lang(new_lang)
    awful.spawn.easy_async_with_shell(
      "setxkbmap " .. new_lang ,
      function(stdout)
        if string.len(stdout) > 0
        then
          naughty.notify({ title = "Lang switching error", text = stdout, timeout = 0 })
        else
          local new_markup = ""
          for _, l in ipairs(langs) do
            if l == new_lang then
              new_markup = new_markup .. "<b>".. l .."</b> "
            else
              new_markup = new_markup .. "<span color='gray'>".. l .."</span> "
            end
          end
          lang_widget.markup = new_markup
        end
      end
    )
  end

  set_lang(langs[1])

  awesome.connect_signal("keyboard_lang_change",
    function()
      get_current_lang_index(function(i) 
        set_lang(langs[i + 1]) 
      end)
    end
  )

  awesome.connect_signal("keyboard_lang_change_prev",
    function()
      get_current_lang_index(function(i) 
        set_lang(langs[(i - 2) % lang_len + 1]) 
      end)
    end
  )

  return lang_widget
end

return factory