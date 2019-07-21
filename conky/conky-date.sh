#!/bin/bash
############################################################
# This work is licensed under the Creative Commons         #
# Attribution-Share Alike 3.0 Unported License.            #
# To view a copy of this license, visit                    #
# http://creativecommons.org/licenses/by-sa/3.0/           #
# or send a letter to Creative Commons, 171 Second Street, #
# Suite 300, San Francisco, California, 94105, USA.        #
############################################################

# You might want to change color1 here
DAY=$(date '+%d')
current=`cal -m`
current=$(echo "$current" |                                                               \
  sed -e /"^${DAY/#0/} "/s/"^${DAY/#0/} "/""'${color1}'"${DAY/#0/}"'${color2}'" "/ \
  -e /" ${DAY/#0/} "/s/" ${DAY/#0/} "/" "'${color1}'"${DAY/#0/}"'${color2}'" "/    \
  -e /" ${DAY/#0/}$"/s/" ${DAY/#0/}$"/" "'${color1}'"${DAY/#0/}"'${color2}'" "/    \
  -e 's/ *$//'
)

current=$(echo "$current"|sed -e /" ${DAY/#0/} "/s/" ${DAY/#0/} "/" "'${color1}'"${DAY/#0/}"'${color2}'" "/  -e 's/ *$//')
echo -e "\${color2}$current"

#current=$(echo "$current"|sed -ne /" ${DAY/#0/} "/s/" ${DAY/#0/} "/" "'${color red}'"${DAY/#0/}"'${color2}'" "/ -e 's/^ //' -e 's/ *$//' -e 2,190p)
#current=$(echo "$current"|sed -e /" ${DAY/#0/} "/s/" ${DAY/#0/} "/" "'${color #00FF00}'"${DAY/#0/}"'${color2}'" "/ -e 's/^ //' -e 's/ *$//')
#current=$(echo "$current"|sed -e /" ${DAY/#0/} "/s/" ${DAY/#0/} "/" "'${color #af0000}'"${DAY/#0/}"'${color2}'" "/  -e 's/ *$//')
