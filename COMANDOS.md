# Guía de comandos — de principiante a senior

Objetivo: trabajar **100% con teclado**, sin tocar el mouse, y sentirte
cómodo en Neovim como en un IDE profesional.

Convenciones de esta guía:

- `\` es la **tecla líder** (backslash). `\ca` significa: presiona `\` y luego `c` y luego `a`.
- `Ctrl-x` significa mantener Control y presionar x.
- Los comandos que empiezan con `:` se escriben en modo normal y terminan con Enter.
- 💡 **Truco para aprender**: presiona `\` o `;` o `g` y espera medio segundo —
  **which-key** te muestra en pantalla todas las combinaciones disponibles.
- 📖 `:Guia` abre esta guía dentro de Neovim en cualquier momento.
- 🖥️ En la terminal: `v archivo` abre Neovim, `v .` abre el proyecto,
  `lg` abre LazyGit (aliases ya configurados en tu zsh).

---

## 🟢 NIVEL PRINCIPIANTE — sobrevivir la primera semana

### Los modos (lo más importante de entender)

Vim tiene modos. Todo lo demás depende de esto:

| Modo | Para qué | Cómo entrar | Cómo salir |
|---|---|---|---|
| **Normal** | Moverse y ejecutar comandos | `Esc` | — |
| **Insertar** | Escribir texto | `i` | `Esc` |
| **Visual** | Seleccionar texto | `v` | `Esc` |
| **Comando** | Ejecutar `:comandos` | `:` | `Enter` o `Esc` |

> Regla de oro: si no sabes en qué modo estás, presiona `Esc` (o `Esc Esc`).

### Abrir, guardar, salir

| Comando | Acción |
|---|---|
| `nvim archivo.txt` | Abrir archivo desde la terminal |
| `:w` | Guardar |
| `:q` | Salir |
| `:wq` | Guardar y salir |
| `:q!` | Salir SIN guardar (descartar cambios) |

### Entrar a modo insertar (varias puertas)

| Tecla | Empieza a escribir... |
|---|---|
| `i` | antes del cursor |
| `a` | después del cursor |
| `I` | al inicio de la línea |
| `A` | al final de la línea |
| `o` | en una línea nueva abajo |
| `O` | en una línea nueva arriba |

### Moverse (¡sin flechas ni mouse!)

| Tecla | Movimiento |
|---|---|
| `h` `j` `k` `l` | ← ↓ ↑ → (la base de todo) |
| `w` / `b` | siguiente / anterior palabra |
| `e` | final de la palabra |
| `0` / `$` | inicio / final de la línea |
| `gg` / `G` | inicio / final del archivo |
| `{` / `}` | párrafo anterior / siguiente |
| `Ctrl-d` / `Ctrl-u` | media página abajo / arriba |
| `:25` | ir a la línea 25 |

### Editar lo básico

| Tecla | Acción |
|---|---|
| `x` | borrar carácter (en esta config: sin copiarlo) |
| `dd` | borrar (cortar) la línea |
| `yy` | copiar la línea |
| `p` / `P` | pegar abajo / arriba |
| `u` | deshacer |
| `Ctrl-r` | rehacer |
| `dw` | en esta config: borrar palabra hacia atrás |
| `.` | repetir el último cambio |

### Buscar

| Tecla | Acción |
|---|---|
| `/texto` + Enter | buscar hacia adelante |
| `n` / `N` | siguiente / anterior resultado |
| `:noh` | apagar el resaltado de la búsqueda |

### Los superpoderes de esta config (úsalos desde el día 1)

| Atajo | Acción |
|---|---|
| `;f` | 🔍 buscar archivo por nombre (como Cmd+P en VS Code) |
| `;r` | 🔍 buscar texto en TODO el proyecto |
| `;o` | 🕐 archivos recientes |
| `;c` | 🎨 paleta de comandos (como Cmd+Shift+P) |
| `Ctrl-n` | 🌲 árbol de archivos lateral (otra vez `Ctrl-n` lo cierra) |
| `sf` | 📁 explorador flotante de la carpeta del archivo actual |
| `Espacio` | saltar a la siguiente ventana |
| `Tab` / `Shift-Tab` | siguiente / anterior pestaña |
| `Ctrl-a` | seleccionar todo |
| `\?` | ver todos los atajos del buffer (which-key) |
| `;k` | buscar cualquier atajo por nombre |

Al abrir `nvim` sin archivo aparece el **dashboard**: `f` buscar, `r`
recientes, `s` restaurar sesión, `l` LazyGit, `q` salir.

Dentro del árbol de archivos (`Ctrl-n`): muévete con `j`/`k`, abre con
`Enter`, crea archivo con `a`, renombra con `r`, borra con `d`, `?` muestra
la ayuda completa.

### Plan de práctica (semana 1)

1. Prohibido el mouse y las flechas: solo `hjkl`.
2. Abre archivos únicamente con `;f`.
3. Fuérzate a usar `w`/`b` en vez de mantener `l`/`h`.
4. `vimtutor` en la terminal: 30 minutos que valen oro (`nvim +Tutor`).

---

## 🟡 NIVEL INTERMEDIO — la gramática de Vim y el flujo IDE

### La gramática: verbo + cantidad + objeto

Aquí es donde Vim hace clic. Los comandos se **componen**:

- Verbos: `d` (borrar), `c` (cambiar = borrar y entrar a insertar), `y` (copiar), `v` (seleccionar)
- Objetos: `w` (palabra), `i"` (dentro de comillas), `a(` (paréntesis incluidos), `ip` (párrafo), `it`/`at` (etiqueta HTML)

| Combinación | Resultado |
|---|---|
| `ciw` | cambiar la palabra bajo el cursor |
| `di"` | borrar lo que está dentro de las comillas |
| `ya(` | copiar el paréntesis y su contenido |
| `cit` | cambiar el contenido de una etiqueta HTML |
| `3dd` | borrar 3 líneas |
| `d$` | borrar hasta el final de la línea |
| `ggVG` | seleccionar todo el archivo |

### Código con LSP (lo que usarías en VS Code, pero con teclado)

| Atajo | Acción |
|---|---|
| `K` | 📖 documentación del símbolo (hover) |
| `gd` | definición y referencias (Lspsaga finder) |
| `gp` | vista previa de la definición (sin salir de donde estás) |
| `gr` | ✏️ renombrar el símbolo en todo el proyecto |
| `gD` | ir a la declaración |
| `gi` | ir a la implementación |
| `gl` | ver el error de la línea completo |
| `Ctrl-j` | saltar al siguiente error/warning |
| `\ca` | 💡 code actions (importar, arreglar, refactorizar) |
| `Ctrl-Space` (insertar) | forzar autocompletado |
| `Ctrl-k` (insertar) | ayuda de la firma de la función |

El autocompletado aparece solo: `Enter` acepta, `Ctrl-e` lo cierra,
`Ctrl-d`/`Ctrl-f` desplazan la documentación.

El código se **formatea solo al guardar** (prettier para web, ruff para
Python, djlint para plantillas Django, stylua para Lua).
`:FormatDisable` lo apaga, `:FormatEnable` lo enciende.

### Flutter (con el SDK instalado)

| Comando | Acción |
|---|---|
| `:FlutterRun` | correr la app (hot reload automático al guardar) |
| `:FlutterDevices` / `:FlutterEmulators` | elegir dispositivo / emulador |
| `:FlutterReload` / `:FlutterRestart` | hot reload / hot restart manual |
| `:FlutterQuit` | detener la app |
| `:FlutterOutlineToggle` | árbol de widgets lateral |

### Multicursores (como VS Code)

| Atajo | Acción |
|---|---|
| `Ctrl-d` | agregar cursor en la siguiente coincidencia de la palabra (VS Code Ctrl+D) |
| `\ma` | cursores en TODAS las coincidencias (VS Code Ctrl+Shift+L) |
| `Ctrl-↑` / `Ctrl-↓` | agregar cursor arriba / abajo |
| `Ctrl-s` (con cursores) | saltarse esta coincidencia |
| `Esc` | quitar los multicursores |

> ⚠️ `Ctrl-d` ya no baja media página: usa `Ctrl-f`/`Ctrl-b` para paginar.

### Ver el código como en un IDE

| Atajo | Acción |
|---|---|
| `\o` | outline: panel lateral con los símbolos del archivo |
| `;b` | navegar los breadcrumbs (ruta de símbolos de arriba) |
| `za` | abrir/cerrar el pliegue bajo el cursor |
| `zR` / `zM` | abrir / cerrar todos los pliegues |
| `zp` | ver el contenido de un pliegue sin abrirlo |
| — | sticky scroll: la función actual queda fija arriba sola |

### Archivos anclados (Harpoon)

| Atajo | Acción |
|---|---|
| `;a` | anclar el archivo actual |
| `;1` `;2` `;3` `;4` | saltar al archivo anclado 1-4 |
| `;h` | menú de anclados (edítalo como texto) |

### Ventanas y pestañas como senior

| Atajo | Acción |
|---|---|
| `ss` / `sv` | split horizontal / vertical |
| `sh` `sj` `sk` `sl` | moverse entre ventanas (como hjkl) |
| `Espacio` | rotar a la siguiente ventana |
| `Ctrl-w` + flechas | redimensionar |
| `Ctrl-w o` | modo zen (solo el archivo actual, sin ruido) |
| `te` | nueva pestaña (escribe el nombre del archivo y Enter) |

### Git y GitHub sin salir del editor

| Atajo | Acción |
|---|---|
| `\gg` | 🚀 **LazyGit**: stage, commit, push, branches, todo visual |
| `\gd` | diff visual de tus cambios (abrir/cerrar) |
| `\gh` | historial de commits del archivo actual |
| `\gp` | 🐙 **GitHub: lista de pull requests** (revisar, comentar, aprobar) |
| `\gi` | 🐙 GitHub: lista de issues |
| `\gb` | blame de la línea (quién y cuándo) |
| `\go` | abrir el archivo en GitHub |
| — | blame inline: la línea actual muestra autor y fecha sola |

Dentro de LazyGit: `espacio` hace stage, `c` commit, `P` push, `?` ayuda.
Con Octo: `:Octo pr checkout` trae el PR, `:Octo review start` para
revisar código comentando línea por línea.

### Terminales integradas

| Atajo | Acción |
|---|---|
| `Ctrl-\` | abrir/cerrar terminal flotante principal |
| `\tf` / `\th` / `\tv` | terminal flotante / horizontal / vertical |
| `2Ctrl-\` | segunda terminal (3, 4... con el número delante) |
| `Esc Esc` (en terminal) | pasar la terminal a modo normal (para copiar output) |
| `:LazyGit` | LazyGit (igual que `\gg`) |

### Edición avanzada

| Atajo | Acción |
|---|---|
| `gcc` | comentar/descomentar línea |
| `gc` (en visual) | comentar la selección |
| `ysiw"` | rodear la palabra con comillas (**y**ou **s**urround) |
| `cs"'` | cambiar comillas dobles por simples |
| `ds(` | quitar los paréntesis |
| `;s` + 2 letras | ⚡ flash: salta a cualquier palabra visible |
| `+` / `-` | incrementar / decrementar número |
| `]t` / `[t` | siguiente / anterior TODO |

### Panorama del proyecto

| Atajo | Acción |
|---|---|
| `\xx` | panel con TODOS los errores del proyecto (trouble) |
| `\xt` | panel con todos los TODO/FIXME |
| `;e` | diagnósticos en telescope |
| `\\` | lista de buffers abiertos |
| `;;` | reabrir la última búsqueda de telescope |
| `\qs` | restaurar la sesión del proyecto (todo como lo dejaste) |

### Plan de práctica (semanas 2-4)

1. Un text object nuevo por día: lunes `ciw`, martes `di"`, miércoles `ya(`...
2. Todo cambio de nombre con `gr`, nunca a mano.
3. Commits solo con `\gg` (LazyGit).
4. Cuando repitas una edición, pregúntate: ¿podía hacerlo con `.`?

---

## 🔴 NIVEL AVANZADO — velocidad senior

### Macros: automatiza ediciones repetitivas

1. `qa` — empieza a grabar en el registro `a`
2. ... haz la edición una vez (idealmente empezando con `0` y terminando con `j`) ...
3. `q` — detén la grabación
4. `@a` — reprodúcela · `15@a` — 15 veces · `@@` — repite la última

### Buscar y reemplazar como cirujano

| Comando | Acción |
|---|---|
| `:s/viejo/nuevo/` | en la línea actual (primera aparición) |
| `:%s/viejo/nuevo/g` | en todo el archivo |
| `:%s/viejo/nuevo/gc` | confirmando una por una (`y`/`n`) |
| `:'<,'>s/viejo/nuevo/g` | solo en la selección visual |
| `\sr` | 🌍 **grug-far**: buscar/reemplazar en TODO el proyecto con vista previa |

El `inccommand=split` de esta config te muestra la vista previa del
reemplazo en vivo mientras escribes.

### El comando global `:g` (poder puro)

| Comando | Acción |
|---|---|
| `:g/console.log/d` | borrar todas las líneas con console.log |
| `:g/TODO/t$` | copiar todas las líneas con TODO al final |
| `:v/error/d` | borrar todas las líneas que NO contienen "error" |

### Registros y marcas

| Comando | Acción |
|---|---|
| `"ayy` / `"ap` | copiar/pegar usando el registro `a` (portapapeles extra) |
| `:reg` | ver todos los registros |
| `"0p` | pegar lo último COPIADO (ignora lo borrado) |
| `ma` / `` `a `` | marcar posición `a` / volver a ella |
| `` `` ` `` | volver a donde estabas antes del último salto |
| `Ctrl-o` / `Ctrl-i` | atrás / adelante en el historial de saltos |

### Debugger (nvim-dap)

| Atajo | Acción |
|---|---|
| `\db` | poner/quitar breakpoint |
| `F5` o `\dc` | iniciar / continuar |
| `F10` | paso siguiente (step over) |
| `F11` / `F12` | entrar / salir de la función |
| `\du` | abrir/cerrar el panel (variables, stack, consola) |
| `\dt` | terminar la sesión de debug |

Python usa `debugpy` y JS/TS usa `js-debug` — Mason los instala solo.

### Quickfix: el flujo de trabajo multi-archivo

1. `;r` busca en el proyecto → en telescope, `Ctrl-q` manda los resultados al quickfix.
2. `:cnext` / `:cprev` (o `\xq`) para recorrerlos.
3. `:cdo s/viejo/nuevo/g | update` — aplica un cambio a CADA resultado.

### Selección visual en bloque (columnas)

1. `Ctrl-v` — visual block
2. Selecciona hacia abajo con `j`
3. `I` (insertar al inicio) o `A` (al final), escribe, `Esc`
4. El texto aparece en TODAS las líneas seleccionadas

### Trucos finales de senior

| Comando | Acción |
|---|---|
| `;S` | seleccionar nodos de sintaxis expandiendo (flash treesitter) |
| `gv` | re-seleccionar la última selección visual |
| `g;` | volver al último lugar editado |
| `:earlier 5m` | ⏰ el archivo como estaba hace 5 minutos (undo por tiempo) |
| `Ctrl-a` sobre un número | incrementarlo (en esta config: `+`) |
| `:Lazy` / `:Mason` | administrar plugins / LSPs |
| `:checkhealth` | diagnóstico completo de Neovim |

### Mentalidad senior

1. **Si lo hiciste dos veces igual, automatízalo**: `.`, una macro, o `:g`.
2. **No navegues: salta.** `;f` por nombre, `;r` por contenido, `;s` por vista, `gd` por semántica.
3. **El teclado es más rápido que tu memoria**: `\?` y which-key están para consultarse sin vergüenza.
4. **Practica una cosa a la vez** hasta que sea automática, luego la siguiente.
