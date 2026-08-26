#!/bin/bash
# Uso: portada/editar-cinta.sh portada/ilustracion.png
# Atenúa la cara de la cinta hasta dejarla como marca de agua y pinta
# encima una matriz de unos y ceros. Coordenadas relativas (fracción del
# ancho/alto) medidas sobre la versión de 1024 px; se escalan solas.
set -e
IN="$1"; OUT="${IN%.*}-editada.png"
W=$(identify -format "%w" "$IN"); H=$(identify -format "%h" "$IN")
# región de la cara (x0 y0 x1 y1 como fracciones)
X0=$(python3 -c "print(int($W*0.455))"); Y0=$(python3 -c "print(int($H*0.755))")
X1=$(python3 -c "print(int($W*0.605))"); Y1=$(python3 -c "print(int($H*0.915))")
RW=$((X1-X0)); RH=$((Y1-Y0))
# 1) región atenuada: mezcla fuerte hacia el color del papel de la cinta
convert "$IN" -crop ${RW}x${RH}+${X0}+${Y0} +repage \
  -fill "#e6d3ae" -colorize 62% \
  /tmp/claude-1000/-home-claudio-proyectos-curso-linux-fisica/11d8a903-7a2e-4ef3-8f59-e1eeb9fb1d72/scratchpad/cara.png
# 2) matriz de unos y ceros del tamaño de la región
PT=$(python3 -c "print(max(9,int($RW/11)))")
python3 - "$RW" "$RH" "$PT" <<'PY' > /tmp/claude-1000/-home-claudio-proyectos-curso-linux-fisica/11d8a903-7a2e-4ef3-8f59-e1eeb9fb1d72/scratchpad/bits.txt
import sys, random
rw, rh, pt = map(int, sys.argv[1:4]); random.seed(42)
cols = max(6, rw // int(pt*0.62)); rows = max(6, rh // int(pt*1.15))
for _ in range(rows): print("".join(random.choice("01") for _ in range(cols)))
PY
convert -size ${RW}x${RH} xc:none -font DejaVu-Sans-Mono -pointsize "$PT" \
  -fill "rgba(70,52,30,0.72)" -gravity center -interline-spacing 1 \
  -annotate +0+0 "$(cat /tmp/claude-1000/-home-claudio-proyectos-curso-linux-fisica/11d8a903-7a2e-4ef3-8f59-e1eeb9fb1d72/scratchpad/bits.txt)" \
  /tmp/claude-1000/-home-claudio-proyectos-curso-linux-fisica/11d8a903-7a2e-4ef3-8f59-e1eeb9fb1d72/scratchpad/bits.png
# 3) componer: cara atenuada + bits, con bordes suavizados, sobre el original
convert /tmp/claude-1000/-home-claudio-proyectos-curso-linux-fisica/11d8a903-7a2e-4ef3-8f59-e1eeb9fb1d72/scratchpad/cara.png \
  /tmp/claude-1000/-home-claudio-proyectos-curso-linux-fisica/11d8a903-7a2e-4ef3-8f59-e1eeb9fb1d72/scratchpad/bits.png -composite \
  \( +clone -alpha extract -blur 0x6 \) -alpha off -compose CopyOpacity -composite \
  /tmp/claude-1000/-home-claudio-proyectos-curso-linux-fisica/11d8a903-7a2e-4ef3-8f59-e1eeb9fb1d72/scratchpad/parche.png
convert "$IN" /tmp/claude-1000/-home-claudio-proyectos-curso-linux-fisica/11d8a903-7a2e-4ef3-8f59-e1eeb9fb1d72/scratchpad/parche.png -geometry +${X0}+${Y0} -composite "$OUT"
echo "escrita: $OUT (${W}x${H}, región ${RW}x${RH}+${X0}+${Y0})"
