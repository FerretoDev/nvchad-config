-- Traducción de mensajes de Ruff al español
local M = {}

-- Diccionario de traducciones de mensajes comunes de Ruff
M.translations = {
  -- Imports
  ["imported but unused"] = "importado pero no usado",
  ["Module imported but unused"] = "Módulo importado pero no usado",
  ["undefined name"] = "nombre no definido",
  ["module level import not at top of file"] = "importación de módulo no al inicio del archivo",
  
  -- Variables
  ["local variable .* assigned to but never used"] = "variable local asignada pero nunca usada",
  ["local variable .* is assigned to but never used"] = "variable local asignada pero nunca usada",
  
  -- Strings
  ["invalid escape sequence"] = "secuencia de escape inválida",
  
  -- Líneas
  ["line too long"] = "línea demasiado larga",
  ["trailing whitespace"] = "espacios en blanco al final",
  ["no newline at end of file"] = "falta línea nueva al final del archivo",
  ["blank line contains whitespace"] = "línea en blanco contiene espacios",
  
  -- Funciones/Clases
  ["function name should be lowercase"] = "nombre de función debe ser minúsculas",
  ["class name should use CapWords convention"] = "nombre de clase debe usar convención CapWords",
  ["argument name should be lowercase"] = "nombre de argumento debe ser minúsculas",
  
  -- Comparaciones
  ["comparison to None should be"] = "comparación con None debe ser",
  ["comparison to True should be"] = "comparación con True debe ser",
  ["use 'is' or 'is not'"] = "usa 'is' o 'is not'",
  
  -- Sintaxis
  ["missing whitespace after"] = "falta espacio después de",
  ["missing whitespace around operator"] = "falta espacio alrededor del operador",
  ["unexpected spaces around keyword / parameter equals"] = "espacios inesperados alrededor del signo igual",
  ["multiple statements on one line"] = "múltiples declaraciones en una línea",
  
  -- Imports específicos
  ["Do not use bare 'except'"] = "No uses 'except' sin especificar excepción",
  ["Use of assert detected"] = "Uso de 'assert' detectado",
  
  -- F-strings
  ["f-string is missing placeholders"] = "f-string no tiene marcadores de posición",
  
  -- Type hints
  ["Missing type annotation"] = "Falta anotación de tipo",
  
  -- Palabras comunes
  ["Remove"] = "Eliminar",
  ["unused"] = "sin usar",
  ["invalid"] = "inválido",
  ["undefined"] = "no definido",
  ["missing"] = "falta",
}

-- Traducir un mensaje de diagnóstico
function M.translate_message(message)
  if not message then return message end
  
  local translated = message
  
  -- Intentar traducciones con patrones regex
  for pattern, translation in pairs(M.translations) do
    if message:match(pattern) then
      translated = message:gsub(pattern, translation)
      break
    end
  end
  
  -- Si no se encontró traducción, intentar traducciones simples
  if translated == message then
    for english, spanish in pairs(M.translations) do
      if not english:find("%*") and not english:find("%.") then
        translated = translated:gsub(english, spanish)
      end
    end
  end
  
  return translated
end

-- Configurar handler personalizado para diagnósticos
function M.setup()
  local original_handler = vim.diagnostic.handlers.virtual_text
  
  vim.diagnostic.handlers.virtual_text = {
    show = function(namespace, bufnr, diagnostics, opts)
      -- Traducir mensajes de ruff
      local translated_diagnostics = {}
      for _, diagnostic in ipairs(diagnostics) do
        local new_diagnostic = vim.deepcopy(diagnostic)
        if diagnostic.source == "ruff" or diagnostic.source == "Ruff" then
          new_diagnostic.message = M.translate_message(diagnostic.message)
        end
        table.insert(translated_diagnostics, new_diagnostic)
      end
      
      -- Llamar al handler original con los mensajes traducidos
      original_handler.show(namespace, bufnr, translated_diagnostics, opts)
    end,
    
    hide = original_handler.hide,
  }
  
  -- Comando para desactivar traducción
  vim.api.nvim_create_user_command("RuffSpanishOff", function()
    vim.diagnostic.handlers.virtual_text = original_handler
    vim.notify("Traducción de Ruff desactivada - mensajes en inglés", vim.log.levels.INFO)
  end, { desc = "Desactivar traducción de Ruff al español" })
  
  -- Comando para reactivar traducción
  vim.api.nvim_create_user_command("RuffSpanishOn", function()
    M.setup()
    vim.notify("Traducción de Ruff al español activada", vim.log.levels.INFO)
  end, { desc = "Activar traducción de Ruff al español" })
  
  vim.notify("Traducción de Ruff al español activada ✓", vim.log.levels.INFO)
end

return M
