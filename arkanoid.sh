board=◄▬▬▬▬▬▬▬▬▬▬▬► 
block1=┏━━┓
block2=┗━━┛
block_n=4
block_m=8
blocks1=`printf "%0.s$block1 " $(seq $block_m)`
blocks2=`printf "%0.s$block2 " $(seq $block_m)`
w=$(tput cols)
h=$(tput lines)
(( h = h > 42 ? 42 : h - 1 ))
(( w = w > 69 ? 69 : w ))
max_speed=3
whitespace=`printf "%0.s " $(seq $w)`
len=${#board}
vel_x=1
vel_y=-1
pos_x=3
pos_y=1
pos=$h
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
    if (( pos_y <= block_m + 1 )); then
        echo -en "\033[$(( pos_y / 2 * 2 + 1 ));$(( pos_x / 5 * 5 ))H    "
        echo -en "\033[$(( pos_y / 2 * 2 + 0 ));$(( pos_x / 5 * 5 ))H    "
    fi
    echo -e "\033[${pos_y};${pos_x}H●"
    read -n 1 -s -t 0.05 q
    case "$q" in 
        [aA] ) draw_board -2;;
        [dD] ) draw_board  2;; 
    esac
    echo -e "\033[${pos_y};${pos_x}H "
    (( pos_x > w || pos_x + vel_x <= 0 )) && (( vel_x = - vel_x ))
    (( pos_y <= 1 || pos_y > h - 2)) && (( vel_y = - vel_y ))
    if (( pos_y > h-2 )); then
        if (( pos_x >= pos && pos_x <= pos + len )); then
           (( vel_x = pos_x - pos - len / 2 ))
           (( ${vel_x//-/} > max_speed )) && vel_x=${vel_x//[0-9]*/$max_speed}
        else
            pos_x=1
            pos_y=3
            vel_y=1
            vel_x=$(( RANDOM % max_speed + 1 ))
        fi
    fi
    (( pos_x += vel_x ))
    (( pos_y += vel_y ))
done
tput cnorm
