return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "obsidian-student-vault",
        path = "/home/maru/Sync/Obsidian/Cloud Files/obsidian-student-vault",
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
            return tostring(os.time()) .. "-" .. suffix
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
