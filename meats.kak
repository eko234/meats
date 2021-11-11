declare-user-mode meats

map global user j ':enter-user-mode meats<ret>' -docstring 'yummy'
map global meats j ':flash-n-lick <ret>'        -docstring 'get some'
map global meats s ':stab <ret>'                -docstring 'shove'
map global meats e ':eat <ret>'                 -docstring 'slurp'

define-command stab %{
  info -style modal "enter a key to save :)"
  on-key %|
    info -style modal
    echo %sh{
      fennel ~/meats/meats.fnl stab "$kak_key:$kak_buffile:$kak_cursor_line:$kak_cursor_column"
    }
  |
}

define-command flash-n-lick %{
  info -style modal %sh{
    fennel ~/meats/meats.fnl flash
  }

  on-key %@
    info -style modal
    evaluate-commands %sh{
      if [ ${#kak_key} -gt 1 ]; then
        echo "nop"
      else
        filetoedit=$(fennel ~/meats/meats.fnl lick "$kak_key")
        echo "edit $filetoedit"
      fi
    }
  @
}

define-command eat %{
  nop %sh{
    fennel ~/meats/meats.fnl eat
  }
}
