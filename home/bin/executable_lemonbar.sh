#!/bin/bash
# Script for lemonbar on herbstluftwm
# Updates using herbstclient rather than looping to make it more efficient. Can be manually refreshed on demand by sending signal 10 (pkill -10 herbbar), or by using herbstluftwm emit hooks: `herbstclient emit_hook UPDATE_PANEL`
if [ -z "$1" ]; then
  lockf="${XDG_RUNTIME_DIR}/herbbar.lock"
  fifo=${XDG_RUNTIME_DIR:-/tmp}/herb-bar.fifo
  test -e "$fifo" && rm "$fifo"
  mkfifo "$fifo"
  monitor=0
else
  lockf="${XDG_RUNTIME_DIR}/herbbar1.lock"
  fifo=${XDG_RUNTIME_DIR:-/tmp}/herb-bar2.fifo
  test -e "$fifo" && rm "$fifo"
  mkfifo "$fifo"
  monitor=1
fi
trap 'update' 10 # allows user to instantaneously update the bar

trap "pkill lemonbar; kill $(jobs -p); rm -r $fifo; rm -r $lockf" EXIT # Cleanly exit

fgb='%{F#88c0d0}'
fgn='%{F-}'
fga='%{F#8fbcbb}'
bgf='%{B#81a1c1}'
clock='\uf017'
# Date
check_date() {
  while :; do
    echo -e "DAT$(date "+%a, %b %d ${fgb}${fgn} %I:%M %p")" >"$fifo"
    sleep 1 &
    wait
  done &
}
# Network
check_net() {
  while :; do
    netp=""
    con_up="$(nmcli --terse --fields NAME,TYPE,DEVICE con show --active | grep -v 'virbr0')"
    if [[ "$con_up" =~ .*ethernet.* ]]; then
      net="$(echo "$con_up" | grep 'ethernet' | awk -F: '{print $1}')"
      netp=""
    fi
    if [[ "$con_up" =~ .*wireless.* ]]; then
      net="$(echo "$con_up" | grep 'wireless' | awk -F: '{print $1}')"
      netp="${netp} "
    fi
    if [[ ! "$con_up" =~ .*ethernet.* && ! "$con_up" =~ .*wireless.* ]]; then
      net="Airplane mode"
      netp=""
    fi

    if [[ "$con_up" =~ .*tun.* || "$con_up" =~ .*vpn.* ]]; then
      echo "VPN${fga}" >"$fifo"
    else
      echo "VPN  "
    fi

    echo "NET${fgb}$netp %{T3}${fgn}$net%{T2}" >"$fifo"
    sleep 60 &
    wait
  done &
}
# Battery
check_bat() {
  while :; do
    bat="$(awk '{print $1}' /sys/class/power_supply/BAT*/capacity)"
    bat_state="$(cat /sys/class/power_supply/BAT1/status)"
    if [ "$bat" -lt 20 ]; then
      bati=""
    elif [ "$bat" -ge "20" ] && [ "$bat" -lt "40" ]; then
      bati=""
    elif [ "$bat" -ge "40" ] && [ "$bat" -lt "60" ]; then
      bati=""
    elif [ "$bat" -ge "60" ] && [ "$bat" -lt "90" ]; then
      bati=""
    elif [ "$bat" -gt "90" ]; then
      bati=""
    fi
    case "$bat_state" in
    Charging)
      bat="%{T3}$bat%+%{T2}"
      bati=""
      ;;
    *)
      bat="%{T3}${bat}% %{T2}"
      ;;
    esac
    echo "BAT${fgb}$bati ${fgn}$bat" >"$fifo"
    sleep 120 &
    wait
  done &
}
# Volume
check_vol() {
  while :; do
    vol="$(pacmd list-sinks | grep -A 15 '* index' | awk '/volume: front/{ print $5 }' | sed 's/%//g')"

    if [ "$vol" -ge "0" ] && [ "$vol" -lt "30" ]; then
      voli=""
    elif [ "$vol" -ge "30" ] && [ "$vol" -lt "60" ]; then
      voli="奔"
    elif [ "$vol" -ge "60" ] && [ "$vol" -lt "90" ]; then
      voli="墳"
    elif [ "$vol" -ge "90" ] && [ "$vol" -le "100" ]; then
      voli="墳"
    else
      voli="墳"
    fi

    echo "VOL${fgb}$voli %{T3}${fgn}${vol}%%%{T2}" >"$fifo"
    sleep 20 &
    wait
  done &
}
# Cmus
check_mus() {
  # no while loop, refresh the bar with pkill whenever you launch cmus
  while :; do
    if pgrep -x "cmus" >/dev/null 2>&1; then
      title="$(cmus-remote -Q | grep "tag title " | sed "s/tag title //")"
      album="$(cmus-remote -Q | grep "tag album " | sed "s/tag album //")"
      artist="$(cmus-remote -Q | grep "tag artist " | sed "s/tag artist //")"
      echo "MUS${fgb} ~ ${fgn}$album${fgb} | $title ${fgn}" >$fifo &
    else
      echo "MUS${fgb} ~ " >$fifo &

    fi
    sleep 5 &
    wait
  done &

}
rami="$(echo '\uf85a')"
memory() {
  while :; do
    ram="$(free -m | awk 'NR==2{printf "%s/%sMB\n", $3,$2,$3*100/$2 }')"
    echo "RAM${fgb} ${fgn}${ram} " >"$fifo" &
    sleep 5 &
    wait
  done &
}

check_tag() {
  if [ "$monitor" == "0" ]; then
    tags_list=($(herbstclient tag_status 0))
  else
    tags_list=($(herbstclient tag_status 1))
  fi
  tags=""
  for t in "${tags_list[@]}"; do
    if [[ "$t" == \#* ]]; then
      tags="${tags}$bgf%{U#60584f}%{+u} ${t#?} %{B-}%{-u}"
    elif [[ "$t" == +* ]]; then
      tags="${tags}%{U#60584f}%{+u} ${t#?} %{B-}%{-u}"
    elif [[ "$t" == :* || "$t" == -* || "$t" == %* ]]; then
      tags="${tags} ${t#?} "
    fi
  done
  echo "DE$tags" >$fifo &
}

check_wm() {
  while read -r line; do
    case $line in
    tag_changed*)
      check_tag
      ;;
    tag_flags)
      check_tag
      check_mus
      ;;
    focus_changed*)
      #check_hidden ;;
      ;;
    UPDATE_PANEL)
      update
      ;;
    esac
  done < <(herbstclient -i) &
}

parse_fifo() {
  while read -r line; do
    case $line in
    DAT*)
      date="${line#???}"
      ;;
    DES*)
      desktop="${line#???}"
      ;;
    NET*)
      network="${line#???}"
      ;;
    VPN*)
      vpnname="${line#???}"
      ;;
    VOL*)
      volume="${line#???}"
      ;;
    BAT*)
      battery="${line#???}"
      ;;
    MUS*)
      music="${line#???}"
      ;;
    RAM*)
      memory="${line#???}"
      ;;
    UPD*)
      update
      ;;
    *) ;;
    esac
    echo "%{T-}%{l}%{O1}%{T2}%{B-}%{O20}${music} %{c}%{T3}${fgn}${date} %{r}${memory}  ${volume} ${network}  ${battery}"
  done < <(tail -f "$fifo")
}

update() {
  check_tag
  check_wm
  check_date
  check_vol
  memory
}

update
parse_fifo
