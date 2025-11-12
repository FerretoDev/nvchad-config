-- Migración completa al nuevo API de LSP, sin require('lspconfig')

-- 1) Utilidades
local function root_pattern(...)
  local patterns = { ... }
  return function(startpath)
    local path = startpath
    if not path or path == "" then
      path = vim.api.nvim_buf_get_name(0)
    end
    local found = vim.fs.find(patterns, { upward = true, path = path })
    if #found > 0 then
      return vim.fs.dirname(found[1])
    end
    return vim.loop.cwd()
  end
end

-- 2) Capacidades (nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- 3) on_attach base
local function on_attach(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end
  map("n", "gd", vim.lsp.buf.definition, "LSP Definition")
  map("n", "gr", vim.lsp.buf.references, "LSP References")
  map("n", "K", vim.lsp.buf.hover, "LSP Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "LSP Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")
end

-- 4) Definición de servidores
local servers = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_dir = root_pattern(".luarc.json", ".luarc.jsonc", ".git"),
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim" } },
      },
    },
  },
  html = {
    cmd = { vim.fn.exepath("vscode-html-language-server") ~= "" and "vscode-html-language-server" or "html-lsp", "--stdio" },
    filetypes = { "html" },
    root_dir = root_pattern("package.json", ".git"),
  },
  cssls = {
    cmd = { vim.fn.exepath("vscode-css-language-server") ~= "" and "vscode-css-language-server" or "css-lsp", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_dir = root_pattern("package.json", ".git"),
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    root_dir = root_pattern("package.json", "tsconfig.json", ".git"),
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
    settings = {
      python = { analysis = { autoImportCompletions = true, typeCheckingMode = "off" } },
    },
    on_attach = function(client, bufnr)
      client.handlers["textDocument/publishDiagnostics"] = function() end
      on_attach(client, bufnr)
    end,
  },
  ruff = {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_dir = root_pattern("pyproject.toml", "setup.cfg", "requirements.txt", ".git"),
  },
  marksman = {
    cmd = { "marksman", "server" },
    filetypes = { "markdown" },
    root_dir = root_pattern(".git", "README.md"),
  },
  clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_dir = root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
  },
  omnisharp = {
    cmd = { "omnisharp" },
    filetypes = { "cs" },
    root_dir = root_pattern("*.csproj", "*.sln", ".git"),
  },
  texlab = {
    cmd = { "texlab" },
    filetypes = { "tex", "bib" },
    root_dir = root_pattern(".git", "main.tex"),
  },
  cmake = {
    cmd = { "cmake-language-server" },
    filetypes = { "cmake" },
    init_options = { buildDirectory = "build" },
    root_dir = root_pattern("CMakeLists.txt", ".git"),
  },
}

-- 5) Auto-arranque por FileType sin lspconfig
local function ensure_lsp_autostart(server_name, cfg)
  local group = vim.api.nvim_create_augroup("LspAutostart-" .. server_name, { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = cfg.filetypes or {},
    callback = function(args)
      local bufnr = args.buf
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local root = (type(cfg.root_dir) == "function") and cfg.root_dir(bufname) or cfg.root_dir or vim.loop.cwd()

      -- Evitar duplicados por root/name
      for _, client in pairs(vim.lsp.get_clients({ name = server_name })) do
        if client.config and client.config.root_dir == root then
          return
        end
      end

      local final = vim.tbl_deep_extend("force", cfg, {
        root_dir = root,
        capabilities = capabilities,
        on_attach = cfg.on_attach or on_attach,
      })

      if vim.lsp.config then
        local lsp_cfg = vim.lsp.config(final)
        vim.lsp.start(lsp_cfg)
      else
        vim.lsp.start(final)
      end
    end,
  })
end

for name, cfg in pairs(servers) do
  local exe = cfg.cmd and cfg.cmd[1]
  if exe and vim.fn.exepath(exe) == "" then
    vim.schedule(function()
      vim.notify("[LSP] Ejecutable no encontrado para '" .. name .. "': " .. exe, vim.log.levels.WARN)
    end)
  end
  ensure_lsp_autostart(name, cfg)
end