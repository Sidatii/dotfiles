return {
  "goolord/alpha-nvim",

  config = function()
    local dashboard = require("alpha.themes.dashboard")
    vim.cmd("source ~/.cache/wal/colors-wal.vim")
    local color9 = vim.g.color9 or "#ffffff"
    local color3 = vim.g.color3 or "#ffffff"
    local color4 = vim.g.color4 or "#ffffff"
    local color5 = vim.g.color5 or "#ffffff"
    local color6 = vim.g.color6 or "#ffffff"

    -- helper function for utf8 chars
    local function getCharLen(s, pos)
      local byte = string.byte(s, pos)
      if not byte then
        return nil
      end
      return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
    end

    local function applyColors(logo, colors, logoColors)
      dashboard.section.header.val = logo

      for key, color in pairs(colors) do
        local name = "Alpha" .. key
        vim.api.nvim_set_hl(0, name, color)
        colors[key] = name
      end

      dashboard.section.header.opts.hl = {}
      for i, line in ipairs(logoColors) do
        local highlights = {}
        local pos = 0

        for j = 1, #line do
          local opos = pos
          pos = pos + getCharLen(logo[i], opos + 1)

          local color_name = colors[line:sub(j, j)]
          if color_name then
            table.insert(highlights, { color_name, opos, pos })
          end
        end

        table.insert(highlights, dashboard.section.header.opts.hl)
      end
      return dashboard.opts
    end

    require("alpha").setup(applyColors({
      [[                                                    ]],
      [[  ██████  ██     ██  █████  ██████   █████  ██   ██ ]],
      [[  ██      ██     ██ ██   ██ ██   ██ ██   ██ ██   ██ ]],
      [[  ██████  ██  █  ██ ███████ ██   ██ ███████ ███████ ]],
      [[      ██  ██ ███ ██ ██   ██ ██   ██ ██   ██ ██   ██ ]],
      [[  ██████   ███ ███  ██   ██ ██████  ██   ██ ██   ██ ]],
      [[----------------------------------------------------]],
      [[                 H U M A N  Editor                  ]],
      [[----------------------------------------------------]],
    }, {
      ["a"] = { fg = color9, ctermfg = 33 },
      ["b"] = { fg = color3, ctermfg = 33 },
      ["c"] = { fg = color4, ctermfg = 33 },
      ["d"] = { fg = color5, ctermfg = 33 },
      ["e"] = { fg = color6, ctermfg = 33 },
    }, {
      [[bbbbbbba    cccccca ]],
      [[bbaaaaaa    ccaaaaa ]],
      [[bbbbba      cccccca ]],
      [[bbaaaa      ccaaaaa ]],
      [[bbbbbbba    cca     ]],
      [[aaaaaaaa    aaa     ]],
      [[d  d  d  e  e  e    ]],
    }))
    dashboard.section.footer.val = {
      "",
      "Welcome!",
    }
  end,
}
