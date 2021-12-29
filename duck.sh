#!/bin/bash

. /etc/envvars.merged

#https://www.duckdns.org/update?domains={YOURVALUE}&token={YOURVALUE}[&ip={YOURVALUE}][&ipv6={YOURVALUE}][&verbose=true][&clear=true]
endpoint=https://www.duckdns.org/update

#-----------------------------------------------------------------------------------------------------------------------

function ts {
  echo [`date '+%b %d %X'`]
}

#-----------------------------------------------------------------------------------------------------------------------


while true
do

  if [ "$IPV6" = "yes" ]; then  
    ip6=`bash -c "$IPV6_SCRIPT"`
    ip4=
    echo "$(ts) IP6 address is ${ip6}"
  else
    echo "Will detect ipv4 automatically"
    ip6=
    ip4=
  fi

  RESPONSE=$(curl -S -s "${endpoint}?domains=$DOMAINS&token=$TOKEN&ip=${ip4}&ipv6=${ip6}" 2>&1)

  if [ "$RESPONSE" = "OK" ]
  then
    echo "$(ts) DuckDNS successfully called. Result was \"$RESPONSE\"."
  elif [[ "$RESPONSE" == "KO" ]]
  then
    echo "$(ts) DuckDNS reported an error. Check your settings. Result was \"$RESPONSE\"."
    exit 2
  else
    # For example: "curl: (6) Could not resolve host: www.duckdns.org". Also sometimes the response is ""
    echo "$(ts) Something went wrong. Result was \"$RESPONSE\". Trying again in 5 minutes."
  fi

  sleep $INTERVAL
done
