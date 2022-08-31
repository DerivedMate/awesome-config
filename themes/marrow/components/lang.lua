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

  awful.spawn.easy_async_with_shell("setxkbmap " .. langs[1])

  local function trim1(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
  end

  awesome.connect_signal("keyboard_lang_change",
    function()
        awful.spawn.easy_async_with_shell(
          "setxkbmap -print -verbose 10 | grep layout | awk '{ print $2 }' | sed 's/[\\s\\t\\n\\r]+//g'",
          function(stdout)
              local current_lang = trim1(stdout)
              local i = (tonumber(lang_index[current_lang]) % lang_len) + 1
              local new_lang = langs[i]

              awful.spawn.easy_async_with_shell(
                "setxkbmap " .. new_lang ,
                function(stdout)
                  if string.len(stdout) > 0
                  then
                    naughty.notify({ title = "Lang switch error", text = stdout, timeout = 0 })
                  else
                    lang_widget.markup = new_lang
                  end
                end
              )
          end,
          false
        )
    end
  )

  return lang_widget
end

return factory