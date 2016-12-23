#!/bin/bash

n=4
tiles=( [0]=0
        [2]=137
        [4]=221
        [8]=94
        [16]=228
        [32]=186
        [64]=185
        [128]=179
        [256]=178
        [512]=222
        [1024]=221
        [2048]=220 )
a=( 0  0  0  0  
    0  0  0  0 
    0  0  0  0 
    0  0  0  0 )
blanks=( )

update_blanks() {
    read -r -a blanks <<< $(for i in `seq 0 $((n**2-1))`
    do
        [[ ${a[i]} == 0 ]] && echo $i
    done)
}

new_tile() {
    update_blanks
    tile=$(( RANDOM % 100 > 87 ? 4 : 2 ))
    pos=$(( RANDOM % ${#blanks[@]} ))
    a[${blanks[pos]}]=$tile
}

format() {
  echo -en "\e[1m\e[38;5;${tiles[$1]}m$1\e[0m\e[21m"
}

show() {
    for i in `seq 0 $((n-1))`; do # TODO read pos of curent shell line
        tput cup $((i*2+1)) 0
        echo '                                   '
        for j in `seq 0 $((n-1))`; do
            tput cup $((i*2+1)) $((j*5+1))
            format ${a[i*n+j]}
        done 
        echo
    done
}

slice() {
    for i in `seq $1 $2 $3`; do
        echo ${a[i]}
    done
}

shifted() {
    read x;
    while [[ -n $x ]]; do
        read y || { echo $x; exit; }
        if [[ $x == $y ]]; then
            echo $(( 2*x ))
            read x
        else
            echo $x
            x=$y
        fi
    done    
}

add_zeros() {
    reverse=$1
    numbers=
    zeros=
    cnt=$n
    while read x; do
        numbers+="$x "
        (( cnt-- ))
    done
    for i in `seq $cnt`; do
        zeros+="0 "
    done 
    [[ 0 == $reverse ]] && echo $numbers$zeros || echo $zeros$numbers
}

shift_() {
    horiz=$1
    s=$(( horiz ? 1 : n ))
    reverse=$2
    for j in `seq 0 $((n-1))`; do
        l=$(( horiz ? n*j : j ))
        r=$(( horiz ? n*(j+1)-1 : n**2-1 ))
        new=$(slice $l $s $r | sed '/^0$/d' | shifted | add_zeros $reverse)
        for i in `seq $l $s $r`; do
            read x
            a[$i]=$x
        done < <(echo $new | xargs -n 1)
    done
}

new_tile
new_tile
tput civis
tput clear
while [[ "$w" != "q" ]]; do
    tput cup 0 0
    show
    prev="${a[@]}"
    read -n 1 -s w
    case "$w" in
        [wW] ) shift_ 0 0 ;;
        [aA] ) shift_ 1 0 ;;
        [sS] ) shift_ 0 1 ;;
        [dD] ) shift_ 1 1 ;;
    esac
    [[ ($prev != "${a[@]}") && (${#blanks[@]} != 0) ]] && new_tile
done
tput cnorm
