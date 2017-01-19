#!/bin/bash

n=4
color=( [0]=0        [2]=137      [4]=221       [8]=94       
        [16]=228     [32]=186     [64]=185      [128]=179     
        [256]=178    [512]=222    [1024]=221    [2048]=220 ) 
a=( 0  0  0  0  
    0  0  0  0 
    0  0  0  0 
    0  0  0  0 ) 
blanks=( ) 

update_blanks() {
    read -r -a blanks <<< $(
    for i in `seq 0 $(( n**2-1 ))`; do
        (( ! ${a[i]} )) && echo $i
    done)
}

new_tile() {
    update_blanks
    tile=$(( RANDOM % 100 > 87 ? 4 : 2 ))
    pos=$(( RANDOM % ${#blanks[@]} ))
    a[${blanks[pos]}]=$tile
}

echo_tile() {
  echo -en "\033[$2;$3H    "
  echo -en "\033[$2;$3H\e[1m\e[38;5;${color[$1]}m$1\e[0m\e[21m"
}

show() {
    for i in `seq 0 $(( n**2-1 ))`; do 
        echo_tile ${a[i]} $(( i/n*2+1 )) $(( i%n*5+1 ))
    done
}

slice() {
    for i in `seq $1 $2 $3`; do
        (( ${a[i]} )) && echo ${a[i]}
    done | ( [[ $4 == 1 ]] && tac || cat )
}

shift_line() {
    read x;
    while [[ -n $x ]]; do
        read y || { echo $x; exit; }
        if (( $x == $y )); then
            echo $(( 2*x ))
            read x
        else
            echo $x
            x=$y
        fi
    done | ( [[ $1 == 1 ]] && tac || cat )  
}

add_zeros() {
    (( cnt = n-$#+1 ))
    (( cnt > 0 )) && zeros=`printf "%0.s0 " $(seq $cnt)` || zeros=
    (( 0 == $1 )) && echo ${*:2} $zeros || echo $zeros ${*:2}
}

shift_all() {
    horiz=$1
    step=$(( horiz ? 1 : n ))
    reverse=$2
    for j in `seq 0 $(( n-1 ))`; do
        first=$(( horiz ? n*j : j )) 
        last=$(( horiz ? n*(j+1)-1 : n**2-n+j ))
        tmp=$(slice $first $step $last $reverse | shift_line $reverse)
        new=$(add_zeros $reverse $tmp)
        for i in `seq $first $step $last`; do
            read a[$i]
        done < <(echo $new | xargs -n 1)
    done
}

new_tile
new_tile
tput civis
tput clear
while [[ "$w" != "q" ]]; do
    show
    prev="${a[@]}"
    read -n 1 -s w
    case "$w" in
        [wW] ) shift_all 0 0 ;;
        [aA] ) shift_all 1 0 ;;
        [sS] ) shift_all 0 1 ;;
        [dD] ) shift_all 1 1 ;;
    esac
    [[ $prev != "${a[@]}" ]] && (( ${#blanks[@]} != 0 )) && new_tile
done
tput cnorm
echo
