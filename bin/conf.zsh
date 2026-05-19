#!/usr/bin/env zsh
## shellcheck --shell=bash

DIR_SCRIPT="${0:A:h}"
LIB="$DIR_SCRIPT/../lib"

CONF="$HOME/.config/conf/conf_files.sh"
FZF_DEFAULT_OPTS_FILE=~/.config/fzf/fzfrc

. $LIB/funciones_dicc.sh
. $LIB/funciones_error.sh
. $LIB/util.sh
 
zparseopts -F -E -D\
  m:=accion -modificar:=accion\
  b=accion -borrar=accion\
  h=_ayuda -help=_ayuda\
  p=flags -print=flags\
  i=completo -fzf=completo || ayuda 1

[[ -n "${_ayuda:+1}" ]] && ayuda 0

. $CONF
conf_alias="$1"

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
  ruta=$( encontrar_valor_llave_mas_similar conf_files "$conf_alias" ) || 
  { error_exit "no se encontro archivo para '$conf_alias'." }

  case "${flags[1]}" in
    -p|--print)
      echo -n "$ruta"
      ;;
    abrir)
      if [[ -d "$ruta" ]]
      then
        cd "$ruta"
      else
        cd "${ruta:A:h}"
      fi

      nvim "$ruta"
      ;;
  esac 
fi
