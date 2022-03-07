# MEATS

Bikeshedding Harpoon for kakoune,
it uses a .meats file that is created
in the first git root that it finds depending
on where you launch this bad boy

## commands
 - `Stab` read the next key you enter to save your current file and position at the top of to the .meats file
 - `Lick` prompt you for a key and show you avaiable meats to select from
 - `Peek` open the .meats file so you can edit it or do wathever, maybe reorder, delete, etc.


## suggested mappings
```kakscript
declare-user-mode meats
map global user  u ': enter-user-mode meats<ret>'
map global meats u ': stab<ret>' -docstring "save"
map global meats i ': lick<ret>' -docstring "pick"
map global meats o ': peek<ret>' -docstring "open"
```
