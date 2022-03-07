define-command peek -docstring %{ open a buffer with all your saved marks, it refers to the file where they are stored so you can manipulate it } -override %{
  edit %sh{
    rootdir=$(git rev-parse --show-toplevel)
    meatsfile="$rootdir/.meats"
    [[ -f "$meatsfile" ]] || touch "$meatsfile"
    printf "$meatsfile\n"
  }
  set buffer autoreload true
}

define-command stab -override -docstring %{ save a meat to marks } %{
  info -style modal "Stab!!!: "
  on-key %{
    info -style modal
    nop %sh{ 
      rootdir=$(git rev-parse --show-toplevel)
      meatsfile="$rootdir/.meats"
      [[ -f "$meatsfile" ]] || touch "$meatsfile"
      cat "$meatsfile" | grep -v "^$kak_key" | tee "$meatsfile" 1>/dev/null
      cat "$meatsfile" | kak -f "ggi$kak_key::$kak_buffile:$kak_cursor_line:$kak_cursor_column<ret>" | tee "$meatsfile" 1>/dev/null
    }
    echo ::SAGE::
  }
}

define-command lick -override -docstring %{ prompt for a key to open a mark } %{
  info -style modal %sh{
    rootdir=$(git rev-parse --show-toplevel)
    meatsfile="$rootdir/.meats"
    printf "Pick your poison:\n"
    cat "$meatsfile" | xargs printf "%s\n"
  }
  on-key %{
    info -style modal
    eval %sh{
      rootdir=$(git rev-parse --show-toplevel)
      meatsfile="$rootdir/.meats"
      command=$(cat "$meatsfile" | grep -m 1 "^$kak_key" | kak -f 's.<plus>::<ret>dxs:<ret>r<space>')
      printf "edit $command\n"
      # printf "edit ~/.config/kak/kakrc 12 12"
    }
  }
}

# Suggested mappings
# declare-user-mode meats
# map global user  u ': enter-user-mode meats<ret>'
# map global meats u ': stab<ret>'       -docstring "STAB"
# map global meats i ': lick<ret>'       -docstring "LICK"
# map global meats o ': peek<ret>'       -docstring "PEEK"
