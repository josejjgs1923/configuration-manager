#!/usr/bin/env zsh


modificar_entrada()
{
  dicc="$1"
  llave="$2"
  valor="$3"

  [[ -z "$dicc" ]] && return 1
  [[ -z "$llave" ]] && return 1

  eval "${dicc}[${llave}]=${valor}"
}

eliminar_entrada()
{
  dicc="$1"
  llave="$2"

  [[ -z "$dicc" ]] && return 1
  [[ -z "$llave" ]] && return 1

  unset "${dicc}[${llave}]"
}

salvar_dict()
{
  dicc="$1"
  carpeta="$2"

  declare -p "$dicc" > "$carpeta"
}


iterar_llaves()
{
  dicc="$1"
  fun="$2"

  [[ -z "$dicc" ]] && return 1
  [[ -z "$fun" ]] && return 1


  for llave in "${(kP)dicc}"
  do
    $fun "$llave" 
  done
}

iterar_valores()
{
  dicc="$1"
  fun="$2"

  for valor in "${(vP)dicc}"
  do
    $fun "$valor" 
  done
}

iterar_items()
{
  dicc="$1"
  fun="$2"

  for llave valor in "${(kvP)dicc}"
  do
    $fun "$llave" "$valor" 
  done
}

print_tabla()
{
  dicc="$1"
  sep="$2"

  [[ -z "$dicc" ]] && return 1
  [[ -z "$sep" ]] && sep="|"

  printf "%s $sep %s\n" ${(kvP)dicc} 
}

encontrar_llave_mas_similar()
{
  dicc="$1"
  patron="$2"

  [[ -z "$dicc" ]] && return 1
  [[ -z "$patron" ]] && return 1

  mas_similar="$( grep "$patron" <<< $(printf "%s\n" ${(kP)dicc} ) | head -1 )"

  [[ -z "$mas_similar" ]] && return 1

  printf "%s" "$mas_similar"
}

encontrar_valor_llave_mas_similar()
{
  dicc="$1"
  patron="$2"

  [[ -z "$dicc" ]] && return 1
  [[ -z "$patron" ]] && return 1

  llave_mas_similar="$( encontrar_llave_mas_similar "$dicc" "$patron" )"

  [[ -z "$llave_mas_similar" ]] && return 1

  printf "%s" "${${(P)dicc}[$llave_mas_similar]}"
}
