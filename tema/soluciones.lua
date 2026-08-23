-- Solo en PDF: mueve las soluciones al final de cada capítulo.
-- · Los divs .solucion (dentro de cada .ejercicio) se sustituyen por una
--   nota y su contenido se recoloca bajo «Soluciones del capítulo».
-- · Los divs .solucion-final (p. ej. las respuestas del test) se mueven
--   tal cual a esa misma sección.
-- En HTML no toca nada: las soluciones siguen plegadas junto al ejercicio.

local utils = pandoc.utils

function Pandoc(doc)
  if not FORMAT:match("latex") then return nil end

  local out = pandoc.List()
  local sols = pandoc.List()

  local function flush()
    if #sols == 0 then return end
    out:insert(pandoc.Header(2,
      pandoc.Inlines(pandoc.Str("Soluciones del capítulo")),
      pandoc.Attr("", {"unnumbered"})))
    for _, b in ipairs(sols) do out:insert(b) end
    sols = pandoc.List()
  end

  for _, blk in ipairs(doc.blocks) do
    if blk.t == "Header" and blk.level == 1 then
      flush()                               -- antes de empezar otro capítulo
      out:insert(blk)
    elseif blk.t == "Div" and blk.classes:includes("proxima") then
      flush()                               -- antes del cierre «La próxima sesión»
      out:insert(blk)
    elseif blk.t == "Div" and blk.classes:includes("ejercicio") then
      local titulo
      blk:walk({ Strong = function(s)
        if not titulo then titulo = utils.stringify(s) end
      end })
      local kept = pandoc.List()
      for _, b in ipairs(blk.content) do
        if b.t == "Div" and b.classes:includes("solucion") then
          sols:insert(pandoc.Para(pandoc.Inlines(
            pandoc.Strong(pandoc.Inlines(pandoc.Str(titulo or "Ejercicio"))))))
          for _, sb in ipairs(b.content) do sols:insert(sb) end
          kept:insert(pandoc.Para(pandoc.Inlines(
            pandoc.Emph(pandoc.Inlines(pandoc.Str("(Solución al final del capítulo.)"))))))
        else
          kept:insert(b)
        end
      end
      blk.content = kept
      out:insert(blk)
    elseif blk.t == "Div" and blk.classes:includes("solucion-final") then
      for _, sb in ipairs(blk.content) do sols:insert(sb) end
    else
      out:insert(blk)
    end
  end
  flush()
  doc.blocks = out
  return doc
end
