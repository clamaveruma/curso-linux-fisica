# Linux, redes y sistemas para físicos — Documento de diseño

*Versión 0.1 — borrador para el piloto. Agosto 2026.*

<!-- Documento interno: el prefijo _ evita que Quarto lo compile.
     Es la referencia de diseño contra la que se redactan los capítulos. -->

---

## 1. Perfil del alumno objetivo

Sintetizado de la encuesta (n=1, el piloto) y del contexto aportado:

Estudiante de física de últimos cursos. Usa Linux Mint como escritorio diario desde bachillerato, pero solo la capa gráfica: actualiza desde el gestor de Mint, no ha abierto la terminal más que puntualmente, y la instalación se la hicieron. Programa con soltura (Python/NumPy, algo de C y Fortran), domina la representación numérica (binario, coma flotante) por la asignatura de computación, pero el sistema operativo es una caja negra: no sabe qué es `/etc`, ni qué hace el kernel, ni qué pasa al encender el ordenador. Cuando algo falla, le pregunta a una IA y copia-pega sin entender. Quiere dejar de hacer eso.

Motivación alta (más de 8 h/semana, formato intensivo de dos semanas), teoría 4/5 — quiere el porqué, no el recetario —, y aspira a doctorado sin saber qué es SLURM.

**Objetivos de autonomía declarados:** instalar Linux desde USB en un PC nuevo, montar y entender su red doméstica partiendo del router de la compañía, conectarse a servidores remotos y nubes (hosts de la universidad), y nociones de virtualización para cuando le den una máquina virtual de trabajo.

## 2. Parámetros de diseño

**Extensión:** ~30 horas efectivas en 12 sesiones de 2–3 h, pensadas para dos semanas intensivas o un mes tranquilo. Cada sesión debe cerrar con una victoria visible.

**Tono:** español con términos técnicos en inglés. Teoría integrada como cajas «Por dentro» al final de cada sección práctica — primero funciona, luego se entiende por qué.

**Ejercicios:** muchos, anclados en material de física (CSVs de medidas, logs de adquisición, barridos de simulaciones). Soluciones ocultas con explicación razonada del porqué, no corrección binaria. Tests de autocomprobación breves al final de cada capítulo, como repaso, no como eje.

**Entorno:** el equipo propio del alumno con Linux (piloto: Mint). Para la versión publicada, un Anexo 0 cubrirá a quien venga de Windows (VirtualBox o WSL) sin engordar el cuerpo del curso.

**Regla de seguridad transversal:** nada destructivo se practica en la máquina de trabajo. Particionar, instalar y romper se hace en la VM. Los cambios en el router de casa se dividen en exploración (solo lectura), reversibles (con procedimiento de vuelta atrás) y avanzados (opcionales).

**Terminal y herramientas gráficas** *(añadido 2026-08-23)*: la terminal es el eje del curso, pero sin menospreciar la vía gráfica. Cuando exista un equivalente gráfico de uso común, se menciona en una línea o caja al cierre de la sección («esto mismo, con ratón»), señalando qué aporta cada vía. Anclas concretas en el temario:

- Cap. 5: los gestores gráficos de paquetes (Gestor de software de Mint, Synaptic) como cara visible de `apt`; y un apartado breve sobre **qué es una distro de verdad** (kernel + paquetes + escritorio) con panorama de escritorios (Cinnamon, GNOME, KDE…).
- Cap. 6: **Disks (gnome-disks) y GParted** junto a `lsblk`/`mount` — GParted reaparece como herramienta estándar en la instalación del cap. 8.
- Caps. 9–10: NetworkManager (el applet de red y `nmtui`) junto a `ip`, por ser lo que se usa de verdad al configurar redes.
- `nano` ya es el editor del curso desde el cap. 2 (con `vim` mencionado con honestidad).

## 3. Temario

### Bloque A — La terminal (3 sesiones, ~7 h)

**1. Abrir la caja negra.** Terminal, shell y consola: qué es cada cosa y por qué la línea de comandos sobrevivió 50 años. Anatomía de un comando: programa, opciones, argumentos. `pwd`, `ls`, `cd`; rutas absolutas y relativas. Autocompletado con Tab e historial desde el primer día — productividad antes que memorización. Pedir ayuda: `man`, `--help`. Se presenta `script(1)` como cuaderno de laboratorio de la sesión: el alumno registra todo el curso.
*Práctica:* expedición por el árbol de su propio Mint; primer contacto con un dataset de medidas.

**2. Ficheros.** `mkdir`, `cp`, `mv`, `rm` (y por qué `rm` no perdona), comodines y globbing, `cat`, `less`, `head`, `tail`, `find`. Editar en `nano`; `vim` mencionado con honestidad. Ficheros ocultos y dotfiles.
*Práctica:* organizar el directorio de un experimento real: renombrado en lote, estructura de carpetas por fecha y run.

**3. El flujo de datos.** stdin/stdout/stderr, redirección `>` `>>`, tuberías. `grep`, `sort`, `uniq`, `cut`, `wc`. La filosofía Unix: programas pequeños que hacen una cosa y se encadenan.
*Práctica estrella:* análisis completo de un log de adquisición solo con tuberías; el mismo análisis en Python, y cuándo conviene cada herramienta.

### Bloque B — El sistema por dentro (3 sesiones, ~7 h)

**4. El árbol y los permisos.** FHS: qué vive en `/etc`, `/home`, `/var`, `/usr`, `/tmp`. Usuarios y grupos. Qué significa `sudo` de verdad. Permisos rwx, `chmod`, `chown`.
*Ancla:* localizar dónde guardan su configuración conda, Jupyter y el propio shell.

**5. Paquetes y procesos.** Lo que el gestor gráfico de Mint hace por debajo: `apt update` vs `upgrade`, repositorios, dependencias. Procesos: `ps`, `top`/`htop`, señales, `kill`, segundo plano. Variables de entorno y `$PATH` — por qué a veces `python` no es el Python que crees (dolor clásico en física computacional).

**6. Discos, particiones y arranque.** Dispositivos de bloque, `lsblk`, sistemas de ficheros, montar y desmontar, la partición EFI, swap, `df`/`du`. Qué pasa desde el botón de encendido: UEFI → GRUB → kernel → init.
*Este capítulo es el prerrequisito directo de la instalación del bloque C.*

### Bloque C — Virtualización e instalación (2 sesiones, ~5 h)

**7. VirtualBox en serio.** Qué se virtualiza: CPU, RAM, disco y red virtuales. Crear una VM desde cero. Instantáneas como superpoder: romper sin miedo. Redes NAT y puente — siembra deliberada para los bloques D y E. Qué te están dando cuando te asignan «una máquina virtual» en remoto.

**8. Instalar Linux de verdad.** Preparar un USB de arranque; en la VM, la ISO hace ese papel. Instalación completa de Debian con particionado manual aplicando el capítulo 6. Post-instalación. Romperla y reinstalar hasta que aburra.
*Anexo C1:* checklist de la instalación física en un PC real, para el día del estreno.

### Bloque D — La red de casa (2 sesiones, ~5 h)

**9. Qué es una red.** IP, máscara y el famoso /24. DHCP. El router de la compañía por dentro: la página de administración como territorio a explorar (solo lectura). NAT, IP pública frente a privada. `ip a`, `ping`.
*Práctica:* censo de todos los dispositivos de casa leyendo la tabla DHCP del router.

**10. Nombres y caminos.** DNS: todo lo que pasa al escribir una URL. `traceroute` hasta la universidad. Puertos y servicios: por qué 22 es SSH y 443 es HTTPS. TCP vs UDP en diez minutos. Cortafuegos conceptual. Wi-Fi frente a cable.
*Práctica:* cambios reversibles en el router con procedimiento de vuelta atrás escrito antes de tocar nada.

### Bloque E — Trabajar en remoto (2 sesiones, ~5 h)

**11. SSH.** Cliente y servidor. Instalar `openssh-server`. Claves ed25519, `ssh-copy-id`, el fichero `~/.ssh/config`. Copiar con `scp` y `rsync`.
*Práctica en tres niveles* (ver §4): localhost → la VM del bloque C → un host real si se tiene.

**12. Vivir en remoto.** `tmux`: lanzar una simulación, desconectarse, volver. Túneles SSH y el caso estrella: Jupyter corriendo en el servidor, abierto en tu navegador local. Qué es «la nube» en términos concretos. SLURM en dos páginas: qué es una cola, aspecto de un job script — la puerta al doctorado.

### Proyecto final (~3 h)

**Tu primer servidor.** VM Debian sin escritorio creada e instalada por el alumno, red configurada, acceso por SSH con clave desde el anfitrión. Transferir un dataset, lanzar un análisis en Python dentro de tmux, desconectarse, volver, recoger resultados. Es el ensayo general, pieza a pieza, del flujo de trabajo remoto de un físico.

### Anexos opcionales

- **0. Vengo de Windows:** preparar entorno con VirtualBox o WSL (para la versión publicada).
- **B1. Scripting:** bash con bucles y condicionales, `cron`. Fuera del cuerpo por presupuesto de tiempo.
- **E1. La IA como herramienta, no como oráculo:** cómo pedir comandos, cómo verificarlos con `man` antes de ejecutar, por qué jamás se copia-pega un `curl | bash` ni un `sudo` sin leer. Nace directamente del «pregunto a la IA y copio-pego» de la encuesta.

## 4. El problema del host remoto: solución por capas

| Nivel | Host | Quién lo tiene |
|---|---|---|
| 0 | `ssh localhost` en su propia máquina | Todos |
| 1 | La VM del bloque C, por red puente | Todos los que sigan el curso |
| 2 | Host real: cuenta de la universidad, servidor del profesor con acceso temporal, capa gratuita de nube o shell público | Recomendado, no requisito |

El curso se escribe contra el nivel 1: nadie queda excluido y la experiencia es funcionalmente idéntica a un servidor real. El capítulo 11 lista las vías del nivel 2 con una nota: verificar disponibilidad y condiciones de las opciones gratuitas en el momento de redactarlo, porque cambian.

## 5. Instrumentación del piloto

- El alumno registra sus sesiones con `script(1)` desde el capítulo 1 (marco: cuaderno de laboratorio). Los logs revelan dónde se atasca de verdad, no dónde dice que se atasca.
- Al final de cada capítulo, tres micropreguntas: tiempo real invertido, qué no se entendió, qué ejercicio falló. Por WhatsApp vale para n=1; para la publicación se puede reutilizar el mecanismo de la encuesta-artefacto.
- Encuesta de salida al terminar, comparable con la de entrada (mismas preguntas de autodiagnóstico): la diferencia entre ambas es la medida del curso.

## 6. Cadena de producción

Fuente única en Markdown con Quarto. Dos salidas por capítulo o bloque: HTML autocontenido (`embed-resources: true`, soluciones en bloques plegables, tests interactivos) y PDF vía LaTeX (soluciones como apéndice final). Repositorio en GitHub; los datasets de ejercicios versionados junto al texto para que texto y soluciones no se desincronicen jamás.

## 7. Pendiente de decidir

- Portada bonita para el libro (web y PDF; Quarto admite `cover-image`) — se hará más adelante.
- ~~Nombre del curso~~ → decidido (2026-08-23): **«Bendito maldito Linux»**, subtítulo «Trabajar en Linux y conceptos de redes, explicado tan fácil que hasta un físico lo puede entender», lema «Terminal, sistemas, redes y trabajo remoto · 12 sesiones prácticas».
- Distribución Debian vs Mint para la VM del bloque C (Debian es más «servidor real»; Mint es continuidad con su escritorio — propuesta: Mint no, Debian sí, y explicar por qué en el propio capítulo).
- Nombre del curso.
- Si el bloque D incluye o no un vistazo a DNS filtrado tipo Pi-hole como ejercicio avanzado opcional.
- Calendario del piloto y fecha de la encuesta de salida.
