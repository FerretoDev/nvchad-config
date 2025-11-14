return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",

  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {

      {
        name = "obsidian-student-vault",
        --path = "~/OneDrive_MarcosDev@8n2f0w.onmicrosoft.com/Obsidian/Cloud Files/obsidian-student-vault",
        --path = "/mnt/c/Users/marco/OneDrive - MSFT/Obsidian/Cloud Files/obsidian-student-vault",
        path = "/home/maru/Sync/Obsidian/Cloud Files/obsidian-student-vault",
        -- Optional, override certain settings.
        overrides = {
          notes_subdir = "000 - Inbox",       -- Subdirectory for notes
          new_notes_location = "000 - Inbox", -- Location for new notes
          note_templates = "z - Templates",
          preferred_link_style = "wiki",

          disable_frontmatter = false,

          -- Settings for attachments
          attachments = {
            img_folder = "z - Attachments/Images", -- Folder for image attachments
          },

          -- Settings for daily notes
          daily_notes = {
            template = "000-NVIM-INBOX-TEMPLATE.md", -- Template for daily notes
          },
          -- Function to generate note IDs
          --note_id_func = function(title)
          -- Create note IDs with YYYYMMDDHHmmss format and title
          -- A note with the title 'My new note' will generate an ID like:
          -- '20240214153022_My_New_Note', and therefore the file name '20240214153022_My_New_Note.md'

          -- Get current time and format it
          --local current_time = os.date("%Y%m%d%H%M%S")

          --local formatted_title = ""

          --if title ~= nil then
          -- If title is given, capitalize first letter of each word and replace spaces with underscores
          --formatted_title = title:gsub("(%a)([%w_']*)", function(first, rest)
          --return first:upper() .. rest:lower()
          --end)
          --formatted_title = formatted_title:gsub(" ", "_")
          --else
          -- If title is nil, just add 4 random uppercase letters
          --for _ = 1, 4 do
          --formatted_title = formatted_title .. string.char(math.random(65, 90))
          --end
          --end

          --return current_time .. "_" .. formatted_title
          --end,

          -- function to generate frontmatter for notes
          note_frontmatter_func = function(note)
            -- This is equivalent to the default frontmatter function.
            local out = { title = note.id, aliases = note.aliases, tags = note.tags }

            -- `note.metadata` contains any manually added fields in the frontmatter.
            -- So here we just make sure those fields are kept in the frontmatter.
            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
              for k, v in pairs(note.metadata) do
                out[k] = v
              end
            end
            return out
          end,
          -- Function to generate note IDs
          note_id_func = function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will be given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            local suffix = ""
            if title ~= nil then
              -- If title is given, transform it into valid file name.
              suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
              -- If title is nil, just add 4 random uppercase letters to the suffix.
              for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90))
              end
            end
            return tostring(os.time()) .. "-" .. suffix
          end,

          -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
          -- URL it will be ignored but you can customize this behavior here.
          ---@param url string
          follow_url_func = function(url)
            -- Open the URL in the default web browser.
            --vim.fn.jobstart({ "open", url }) -- Mac OS
            vim.fn.jobstart { "xdg-open", url } -- linux
            -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
            vim.ui.open(url)                    -- need Neovim 0.10.0+
          end,
          use_advanced_uri = false,

          -- Settings for templates
          templates = {
            subdir = "z - Templates", -- Subdirectory for templates
            date_format = "%Y-%m-%d", -- Date format for templates
            gtime_format = "%H:%M",   -- Time format for templates
            tags = "",                -- Default tags for templates
          },
        },
      },
    },
    completion = {
      nvim_cmp = true, -- Habilita autocompletado con nvim-cmp
      --nvim_lsp = true, -- Habilita autocompletado con nvim-cmp
    },
    mappings = {
      ["<leader>och"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },

    -- see below for full list of options 👇
    -- Mapping para toggle frontmatter
    --map("n", "<leader>of", function()
    --opts.workspaces[1].overrides.toggle_frontmatter()
    --end, { desc = "Toggle Frontmatter" })
  },
}
