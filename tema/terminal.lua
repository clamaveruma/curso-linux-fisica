-- Colorea los bloques ```terminal en la salida HTML, imitando el prompt
-- de Linux Mint sobre el terminal oscuro del curso:
--   usuario@máquina : ruta $  comando   ← verde / ámbar / blanco
--   salida del sistema                  ← atenuada
-- En PDF el bloque queda como verbatim plano (fondo claro de imprenta).

local function esc(s)
  s = s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
  return s
end

function CodeBlock(el)
  if not el.classes:includes("terminal") then return nil end
  if FORMAT:match("latex") then
    -- PDF: caja con fondo gris (shadecolor, definida en _quarto.yml)
    local txt = el.text:gsub("▮", "_")
    return pandoc.RawBlock("latex",
      "\\begin{snugshade}\n\\begin{Verbatim}[fontsize=\\small]\n"
      .. txt .. "\n\\end{Verbatim}\n\\end{snugshade}")
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
