block1=┏━━┓
block2=┗━━┛
block_n=4
block_m=8
blocks1=`printf "%0.s$block1 " $(seq $block_m)`
blocks2=`printf "%0.s$block2 " $(seq $block_m)`
w=$(tput cols)
h=$(tput lines)
(( h = h > 42 ? 42 : h ))
(( w = w > 69 ? 69 : w ))
angle_x=( -4 -3 -2 -1 -1 -1 0 1 1 1 2 3 4 )
whitespace=`printf "%0.s " $(seq $w)`
board=◄▬▬▬▬▬▬▬▬▬▬►
len=${#board}
vel_x=1
vel_y=-1
pos_x=3
pos_y=1
pos=$h
fit() {
    [[ $1 -lt $w && $1 -ge 0 && $2 -lt $h && $2 -ge 0 ]] && return 0 || return 1
}
draw_board() {
    echo -en "\033[${h};${pos}H$whitespace"
    (( pos += $1 ))
    (( pos = pos < 1 ? 1 : pos > w - len ? w - len : pos ))
    echo -en "\033[${h};${pos}H$board"
}
tput civis
tput clear
echo
for i in `seq $block_n`; do
    echo "         $blocks1"
    echo "         $blocks2" 
done
draw_board 1

while [[ $q != q ]]; do
    if (( pos_y <= block_m )); then
        echo -en "\033[$(( pos_y / 2 * 2 +1 ));$(( pos_x / 5 * 5 ))H    "
        echo -en "\033[$(( pos_y / 2 * 2 +0 ));$(( pos_x / 5 * 5 ))H    "
    fi
    fit $pos_x $pos_y && echo -e "\033[${pos_y};${pos_x}H●"
    read -n 1 -s -t 0.05 q 
    case "$q" in 
        [aA] ) draw_board -2;;
        [dD] ) draw_board 2;; 
    esac
    fit $pos_x $pos_y && echo -e "\033[${pos_y};${pos_x}H "
    (( pos_x > w || pos_x < 1 )) && (( vel_x=-vel_x ))
    (( pos_y < 1 )) && (( vel_y=-vel_y ))
    if (( pos_y > h-2 )); then
        if (( pos_x >= pos && pos_x <= pos + len )); then
           #echo $x, ${angle_y[$x]}, ${angle_x[$x]}
           (( vel_x=(pos_x-pos-1-len/2)/2 ))
#           (( vel_x=angle_x[x] ))
           (( vel_y=-vel_y ))
        else
            pos_x=1
            pos_y=1
            vel_x=1
            vel_y=1
        fi
    fi
#    (( vel_y += 1 )) 
    (( pos_x += vel_x ))
    (( pos_y += vel_y ))
done
tput cnorm
