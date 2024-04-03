#!/bin/bash
echo '#define str_check(A, B, C) if(iseq(A,B)){return C;}'
echo '#define iseq(A,B) strcmp(A,B)==0'
echo '#include <string.h>'
echo 'char* str_to_label(char* str) {'
set -o pipefail
cat /usr/include/X11/keysymdef.h | grep "^#define " | tr -s " "  | grep -v Return | while read line ; do
    label=$(echo "$line" | cut -f2 -d" " | sed "s/^XK_//g")
    code=$(echo "$line" | cut -f3 -d" " | grep "^0x")
    code=$(printf "${code/0x/"\U"}")
    if echo $line | grep "deprecated" >/dev/null ; then
        echo "    str_check(str, \"$label\", \"\");"
    elif [[ "$code" != "" && "$code" != "$label" ]] ; then
        echo "    str_check(str, \"$label\", \"$code\");"
    fi
done | sed 's/\\/\\\\/g' | sed 's/"""/"\\""/g'
echo '    return str;'
echo '}'
