#!/bin/bash
# Begin Reference: https://unix.stackexchange.com/a/665076
for argument in "$@"
do
  key=$(echo $argument | cut --fields 1 --delimiter='=')
  value=$(echo $argument | cut --fields 2 --delimiter='=')

  case "$key" in
    "d")       d="$value" ;; # directory
    "b")       b="$value" ;; # basename
    "w")       w="$value" ;; # basename without extension
    "x")       x="$value" ;; # extension
    *)
  esac
done
# End Reference

# Switch Directory
cd "$d"

# Determine Extension
if [[ -z "$x" ]] ; then
  extn=$null  
else
  extn=".$x"
fi

# Determine Copy Count
n=1
out="$w-copy$n$extn"
while [ -e "$out" ]; do
    n=$(( n + 1 ))
    out="$w-copy$n$extn"
done

# Construct Command
if [ -d "$b" ] ; then
  command=(/usr/bin/rsync -ar "$b/" "$out")
else
  command=(/usr/bin/rsync -a "$b" "$out")
fi

# DEBUG: Display Command
#zenity --info --text="${command[*]//"/\\"/}" --width=600

# Execute Command
"${command[@]}"

# Handle Command Error
res=$?
if [[ $res != 0 ]] ; then
  zenity --error --text="Duplication of $b failed (not root?)\n- base: $b\n- ext: $x\n- dir: $d" --width=600
fi
