#key bindings are in fish_user_key_bindings

if test $TERM != linux
  set -g -x TERM screen-256color
end

set -xg VIRTUAL_ENV_DISABLE_PROMPT "no prompt" 
set PATH $PATH ~/bin/
