return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  init = function()
    -- Solo cargar obsidian.nvim si el archivo markdown abierto está dentro de un vault de Obsidian
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      group = vim.api.nvim_create_augroup("LazyLoadObsidian", { clear = true }),
      pattern = "*.md",
      callback = function(ev)
        local file_dir = vim.fs.dirname(ev.match)
        if file_dir then
          local obsidian_dir = vim.fs.find(".obsidian", {
            path = file_dir,
            upward = true,
            stop = vim.env.HOME,
          })[1]

          if obsidian_dir then
            require("lazy").load({ plugins = { "obsidian.nvim" } })
          end
        end
      end,
    })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "obsidian-student-vault",
        path = function()
          local buf_dir = vim.fn.expand("%:p:h")
          if buf_dir == "" or buf_dir:match("^%w+://") then
            buf_dir = vim.fn.getcwd()
          end

          -- 1. Buscar hacia arriba si el archivo actual o CWD está dentro de un vault de Obsidian
          local obsidian_dir = vim.fs.find(".obsidian", {
            path = buf_dir,
            upward = true,
            stop = vim.env.HOME,
          })[1]

          if obsidian_dir then
            return vim.fs.dirname(obsidian_dir)
          end

          -- 2. Intentar leer los vaults desde la configuración oficial de Obsidian (obsidian.json)
          local config_path = vim.env.HOME .. "/.config/obsidian/obsidian.json"
          if vim.fn.filereadable(config_path) == 1 then
            local ok, content = pcall(vim.fn.readfile, config_path)
            if ok and content and #content > 0 then
              local json_str = table.concat(content, "")
              local ok_json, data = pcall(vim.fn.json_decode, json_str)
              if ok_json and data and data.vaults then
                for _, vault in pairs(data.vaults) do
                  if vault.path and vim.fn.isdirectory(vault.path) == 1 then
                    return vault.path
                  end
                end
              end
            end
          end

          -- 3. Respaldo final si no estamos dentro de un vault ni hay configurados
          local fallback = "/home/maru/Sync/Obsidian/Cloud Files/obsidian-student-vault"
          if vim.fn.isdirectory(fallback) == 1 then
            return fallback
          end
          return vim.fn.getcwd()
        end,
        overrides = {
          notes_subdir = "000 - Inbox",
          new_notes_location = "000 - Inbox",
          note_templates = "900 - Meta/Templates",
          preferred_link_style = "wiki",
          disable_frontmatter = false,

          attachments = {
            img_folder = "z - Attachments/Images",
          },

          daily_notes = {
            template = "Daily Notes/Daily-Notes-Template.md",
          },

          note_frontmatter_func = function(note)
            local out = { title = note.id, aliases = note.aliases, tags = note.tags }
            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
              for k, v in pairs(note.metadata) do
                out[k] = v
              end
            end
            return out
          end,

          note_id_func = function(title)
            local suffix = ""
            if title ~= nil then
              suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
              for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90))
              end
            end
            return os.date("%Y-%m-%d") .. "-" .. suffix
          end,

          follow_url_func = function(url)
            if url:match("^file://") then
              local path = url:gsub("^file://", "")
              vim.cmd("edit " .. path)
            else
              vim.ui.open(url)
            end
          end,

          use_advanced_uri = false,

          templates = {
            subdir = "900 - Meta/Templates",
            date_format = "%Y-%m-%d",
            gtime_format = "%H:%M",
            tags = "",
          },
        },
      },
    },
    ui = {
      enable = false, -- Desactivar UI para evitar conflictos con render-markdown
    },
    completion = {
      nvim_cmp = true,
    },
    mappings = {
      ["<leader>och"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
  },
}
