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

zparseopts -F -E -D\
  m:=accion -modificar:=accion\
  b=accion -borrar=accion\
  h=_ayuda -help=_ayuda\
  p=flags -print=flags\
  i=completo -fzf=completo || ayuda 1


[[ -n "${_ayuda:+1}" ]] && ayuda 0

conf_alias="$1"

DIR_SCRIPT="${0:A:h}"
MODULOS="$DIR_SCRIPT/modulos"
CONF="$HOME/.config/conf/conf_files.sh"

. $MODULOS/funciones_dicc.sh
. $MODULOS/funciones_error.sh
. $CONF
 
[[ -z "${flags[1]}" ]] && flags[1]=abrir
[[ -z "$conf_alias" && -z "${completo[1]}" ]] && completo[1]=todos

if [[ -n "${accion:+1}" ]]
then

  [[ -z "$conf_alias" ]] &&
  { echo "alias vacio." && exit 1 }

  case "${accion[1]}" in
    -m|--modificar)

      { modificar_entrada conf_files "$conf_alias" "${accion[2]}" } || 
      { error_exit "valor vacio de llave." }
      ;;

    -b|--borrar)

      { eliminar_entrada conf_files "$conf_alias" } || 
      { error_exit "no se encontro entrada para '$conf_alias.'" }
      ;;
  esac
  salvar_dict conf_files $CONF

elif [[ -n "${completo:+1}" ]]
then

  case "${completo[1]}" in
    -i|--fzf)

      print_tabla conf_files "\t" | fzf --cycle\
        --query "$*"\
        --prompt "elegir:"\
        -d "\t"\
        --with-nth "1"\
        --preview-window="down,9%"\
        --preview="echo {2}"\
        --bind="enter:become( nvim {2} )"
      ;;
    todos)
      print_tabla conf_files "," | column -t --table-columns "alias:,ruta:"  -s "," -o "|"
      ;;
  esac

else
  archivo=$( encontrar_valor_llave_mas_similar conf_files "$conf_alias" ) || 
  { error_exit "no se encontro archivo para '$conf_alias'." }

  case "${flags[1]}" in
    -p|--print)
      echo -n "$archivo"
      ;;
    abrir)
      nvim "$archivo"
      ;;
  esac 
fi
