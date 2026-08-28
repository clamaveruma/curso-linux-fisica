-- Colorea los bloques ```terminal en la salida HTML, imitando el prompt
-- de Linux Mint sobre el terminal oscuro del curso:
--   usuario@máquina : ruta $  comando   ← verde / ámbar / blanco
--   salida del sistema                  ← atenuada
-- En PDF va coloreado en tema claro sobre una caja gris (ver rama latex).

local function esc(s)
  s = s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
  return s
end

function CodeBlock(el)
  if not el.classes:includes("terminal") then return nil end
  if FORMAT:match("latex") then
    -- PDF: caja gris clara con colores de tema claro (definidos en
    -- _quarto.yml): prompt verde, ruta ámbar, orden en negrita,
    -- salida atenuada. Verbatim con commandchars para poder colorear.
    local function lesc(t)
      t = t:gsub("\\", "\1"):gsub("{", "\\{"):gsub("}", "\\}")
      t = t:gsub("\1", "\\textbackslash{}")
      return t
    end
    local out = {}
    for line in (el.text:gsub("▮", "_") .. "\n"):gmatch("(.-)\n") do
      local user, path, sym, cmd =
        line:match("^([%w%._%-]+@[%w%._%-]+):(%S*)([%$#])%s?(.*)$")
      if user then
        local l = "\\textcolor{tprompt}{" .. lesc(user) .. "}"
          .. "\\textcolor{tdim}{:}"
          .. "\\textcolor{tpath}{" .. lesc(path) .. "}"
          .. "\\textcolor{tdim}{" .. sym .. "}"
        if cmd ~= "" then l = l .. " \\textbf{" .. lesc(cmd) .. "}" end
        table.insert(out, l)
      elseif line == "" then
        table.insert(out, "")
      else
        table.insert(out, "\\textcolor{tout}{" .. lesc(line) .. "}")
      end
    end
    return pandoc.RawBlock("latex",
      "\\begin{snugshade}\n\\begin{Verbatim}[fontsize=\\small,commandchars=\\\\\\{\\}]\n"
      .. table.concat(out, "\n") .. "\n\\end{Verbatim}\n\\end{snugshade}")
  end
  if not FORMAT:match("html") then
    return pandoc.CodeBlock(el.text)
  end
  local out = {}
  for line in (el.text .. "\n"):gmatch("(.-)\n") do
    local user, path, sym, cmd =
      line:match("^([%w%._%-]+@[%w%._%-]+):(%S*)([%$#])%s?(.*)$")
    if user then
      local h = '<span class="t-p">' .. esc(user) .. '</span>'
        .. '<span class="t-dim">:</span>'
        .. '<span class="t-hl">' .. esc(path) .. '</span>'
        .. '<span class="t-dim">' .. esc(sym) .. '</span>'
      if cmd ~= "" then
        h = h .. ' <span class="t-cmd">' .. esc(cmd) .. '</span>'
      end
      table.insert(out, h)
    else
      table.insert(out, '<span class="t-out">' .. esc(line) .. '</span>')
    end
  end
  return pandoc.RawBlock("html",
    '<pre class="terminal"><code>' .. table.concat(out, "\n") .. '</code></pre>')
end
