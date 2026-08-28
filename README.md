# Bendito maldito Linux

Curso introductorio para físicos: terminal, sistema, virtualización,
redes y trabajo remoto. 13 sesiones + proyecto final. **Versión: agosto 2026** (las versiones llevan mes y año; el libro evoluciona con la IA y con la realimentación de los lectores).
Web: https://clamaveruma.github.io/curso-linux-fisica/

## Estructura
- `_quarto.yml` — configuración: libro con salida web y PDF descargable
- `_diseno.md` — documento de diseño: perfil del alumno, temario de las
  13 sesiones y parámetros del curso (no se compila)
- `capitulos/` — un .qmd por capítulo; `_cap01-prototipo-original.html`
  es el prototipo visual validado (los ficheros con `_` no se compilan)
- `tema/curso.scss` — paleta sepia y componentes (cajas, terminal, kbd,
  quiz, portada de capítulo)
- `imagenes/capNN/` — figuras SVG propias y fotos de Wikimedia Commons
  (licencia verificada; atribución en el pie de cada figura)
- `datos/` — datasets de los ejercicios, versionados junto al texto
- `.github/workflows/publicar.yml` — render + publicación automática

## Trabajar en local
    quarto preview          # servidor local con recarga en vivo
    quarto render           # genera _site/ (web) y el PDF

## Publicación
Cada push a `main` renderiza y publica en GitHub Pages (rama gh-pages).
Una sola vez: Settings → Pages → Source: Deploy from branch → gh-pages.
El botón «PDF» de la web sale de `book.downloads` en `_quarto.yml`.
