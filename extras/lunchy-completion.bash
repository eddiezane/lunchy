###
# completion written by Alexey Shockov
# on github : alexeyshockov
#
function _lunchy {
  COMPREPLY=()
  local cur=${COMP_WORDS[COMP_CWORD]}
  local cur_pos=$COMP_CWORD;

  case "$cur_pos" in
    1) COMPREPLY=($(compgen -W 'ls list start stop restart status install uninstall show edit' -- $cur))
       ;;
    *) COMPREPLY=($(compgen -W '$(lunchy list)' -- $cur))
       ;;
  esac
}

complete -F _lunchy -o default lunchy
