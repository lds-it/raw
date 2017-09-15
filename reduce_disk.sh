#!/bin/bash
#SUBJECT: reciclagem de arquivos de log VD.
#OBJECTIVE: proactive variable disk size reduction
#AUTHOR: joao duarte - GoSAT
#DATE: 2017-09-14

#ORIG="/var/spool/asterisk/monitorDONE/ORIG/"
. dir.list
#this function listing the huge files - gt 200MB - into ORIG directory.
_makelist(){
  for dirs in ${ORIG[@]}; do
    find ${dirs} -type f -size +$SIZE | tee $FILE
  done
}
#this function acts like a file vanisher from huge listed files.
_dellist(){
  PERCENT=$(df -hT ${ORIG} | awk '{print $6}' | grep -v "[a-z]"|tr -d '%')
  if [ $PERCENT -gt "89" ]; then
    find ${ORIG} -print -exec $(rm -rf '{}' +)
  fi
}
#
_err(){
  exit 1
}
#
case $1 in
  "--make")
    _makelist;;
  "--remove")
    _dellist;;
  *)
    _err;;
esac;

exit 0
