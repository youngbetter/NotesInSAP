#!/bin/sh
curl https://confluence.successfactors.com/pages/viewpage.action?pageId=250659989 -u $1 \
|sed -n "/Dear all/ p" \
|sed "s/<\/tr>/\n/g" \
|sed "s/<td class\=\"confluenceTd\"><br\/><\/td>/<td>empty<\/td>/g" \
|sed "1,$ s/<[^>]*>/:/g" \
|awk 'BEGIN{FS=":*"}{printf"if(_value=='\''bizx/%s'\''){return '\''%s'\''}\n",$2,$(NF-1)}' \
|sed -e "1 d;$ d" \
|sed "/Undetermined/ d" \
|sed "1 i {\"script\":\"" \
|sed "$ a return 'Undetermined'\n\"}" \
|awk BEGIN{RS=EOF}'{gsub(/\n/,"");print}' \
> p_mapping.txt