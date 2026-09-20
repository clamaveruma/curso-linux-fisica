#!/usr/bin/env python3
"""Comprueba que ningún texto de las figuras SVG se sale del marco ni de
su caja. Uso: python3 tema/comprobar-svg.py [ficheros.svg]  (por defecto,
todos los de imagenes/).

Los SVG se incrustan como <img>, así que la fuente la pone el navegador del
lector (la web font del libro no llega dentro): se estima el ancho con
0,62 em por carácter en monoespaciada (IBM Plex Mono y DejaVu Sans Mono
miden 0,60) y se exige un margen de 10 px al marco y 3 px a la caja."""
import sys, glob, xml.etree.ElementTree as ET

NS = '{http://www.w3.org/2000/svg}'
EM_MONO, EM_SANS = 0.62, 0.55
MARGEN_MARCO, MARGEN_CAJA = 10, 3

def recorrer(el, tam, fam, textos, cajas):
    s = el.get('font-size'); tam = float(s) if s else tam
    f = el.get('font-family'); fam = f if f else fam
    if el.tag == NS + 'rect':
        try:
            cajas.append(tuple(float(el.get(k)) for k in ('x', 'y', 'width', 'height')))
        except (TypeError, ValueError):
            pass
    if el.tag == NS + 'text':
        txt = ''.join(el.itertext())
        em = EM_MONO if 'ono' in (fam or '') else EM_SANS
        w = len(txt) * tam * em
        x = float(el.get('x', 0)); y = float(el.get('y', 0))
        a = el.get('text-anchor', 'start')
        x0 = x - w / 2 if a == 'middle' else (x - w if a == 'end' else x)
        textos.append((x0, x0 + w, y, txt))
    for hijo in el:
        recorrer(hijo, tam, fam, textos, cajas)

def comprobar(f):
    raiz = ET.parse(f).getroot()
    vb = [float(v) for v in raiz.get('viewBox', '0 0 700 300').split()]
    x_min, x_max = vb[0], vb[0] + vb[2]
    textos, cajas = [], []
    recorrer(raiz, 12.0, None, textos, cajas)
    avisos = []
    for x0, x1, y, t in textos:
        if x0 < x_min + MARGEN_MARCO or x1 > x_max - MARGEN_MARCO:
            avisos.append(f"  MARCO  [{x0:5.0f},{x1:5.0f}]  «{t[:80]}»")
        cx = (x0 + x1) / 2
        dentro = [c for c in cajas if c[0] <= cx <= c[0] + c[2] and c[1] <= y <= c[1] + c[3]]
        if dentro:
            c = min(dentro, key=lambda c: c[2] * c[3])
            if x0 < c[0] + MARGEN_CAJA or x1 > c[0] + c[2] - MARGEN_CAJA:
                avisos.append(f"  CAJA   [{x0:5.0f},{x1:5.0f}] vs [{c[0]:5.0f},{c[0]+c[2]:5.0f}]  «{t[:70]}»")
    return avisos

if __name__ == '__main__':
    ficheros = sys.argv[1:] or sorted(glob.glob('imagenes/**/*.svg', recursive=True))
    con_avisos = 0
    for f in ficheros:
        avisos = comprobar(f)
        if avisos:
            con_avisos += 1
            print(f); print('\n'.join(avisos))
    print(f"\n{con_avisos} de {len(ficheros)} SVG con avisos")
    sys.exit(1 if con_avisos else 0)
