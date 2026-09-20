-- Pistas de los ejercicios:  ::: {.pista} ... :::
-- · HTML: callout plegable, cerrado, titulado «Pista» — el lector decide
--   si la lee (la pista pegada al enunciado se leía sin querer).
-- · PDF: párrafo aparte, con la etiqueta «Pista.» en cursiva.

function Div(el)
  if not el.classes:includes("pista") then return nil end

  if FORMAT:match("latex") then
    local blocks = pandoc.List()
    for i, b in ipairs(el.content) do
      if i == 1 and b.t == "Para" then
        local inl = pandoc.Inlines({
          pandoc.Emph(pandoc.Inlines({pandoc.Str("Pista.")})), pandoc.Space()})
        inl:extend(b.content)
        blocks:insert(pandoc.Para(inl))
      else
        blocks:insert(b)
      end
    end
    return blocks
  end

  -- Nodo callout de Quarto (los divs .callout-* ya se han procesado
  -- cuando corren los filtros de usuario; la API sí funciona aquí)
  return quarto.Callout({
    type = "note", title = "Pista", collapse = true, content = el.content })
end
