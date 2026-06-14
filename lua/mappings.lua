-- Carga modular de todos los mapeos de teclado
require "nvchad.mappings"

-- Cargar sub-mapeos específicos
pcall(require, "mappings.general")
pcall(require, "mappings.projects")
pcall(require, "mappings.obsidian")
pcall(require, "mappings.latex")
