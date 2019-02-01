#!/bin/sh

set -e

DIFF="diff -u"

mv ./production/* ./
for TTYPE in short long xlong
do
  for x in tests/data/*.drf
  do
    DIG_OPTS="/E:${x}"
    DIG_OPT_FSPD="/S:0"
    if [ "${TTYPE}" = "long" -o "${TTYPE}" = "xlong" ]
    then
      TSIZE=`du -k ${x} | awk '{print $1}'`
      if [ ${TSIZE} -gt 5 ]
      then
	continue
      fi
      if [ "${TTYPE}" = "long" ]
      then
	DIG_OPTS="${DIG_OPT_FSPD} ${DIG_OPTS}"
      fi
    else
      DIG_OPTS="${DIG_OPT_FSPD} ${DIG_OPTS}"
    fi
    TFNAME="`basename ${x}`"
    TRFNAME="${TFNAME}.out"
    echo -n "${TFNAME} (${TTYPE}): "
    SDL_AUDIODRIVER=dummy SDL_VIDEODRIVER=dummy DIGGER_CI_RUN=1 ./digger ${DIG_OPTS} > "${TRFNAME}" 2>/dev/null
    ${DIFF} "tests/results/${TRFNAME}" "${TRFNAME}"
    echo "PASS"
  done
done
