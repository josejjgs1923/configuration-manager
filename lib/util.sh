#!/usr/bin/env zsh
## shellcheck --shell=bash

ayuda() {
  less -FEXR <<- HELP
  uso: ${ZSH_ARGZERO:t} [conf_alias] [opciones]

  organizar archivos de configuracion. Abrir por defecto 
  el archivo del alias. Sin alias, muestra todas los alias
  registrados.


  opciones:
    --help, -h              mostrar esta ayuda y salir
    -m, --modificar ruta    agregar rutas con alias dados.   
    -b, --borrar            borrar alias y registro archivo.   
    -p, --print             mostrar ruta del alias.
    -i, --fzf               usar fzf para ver registros.
HELP
	exit "$1"
}
