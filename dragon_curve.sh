#/bin/bash

# axiom: FX
# rules:
# X -> X+YF+
# Y -> -FX-Y

function L {
  case $1 in
    X ) echo -n "X + Y F + " ;;
    Y ) echo -n "- F X - Y " ;;
    * ) echo -n "$1 " ;;
  esac
}
function map {
  for c in $*
    do
      L $c
    done
}
function draw {
  case $1 in 
    0 ) tput cup $y $x; echo -n "|"; let y--;;
    1 ) let x++; tput cup $y $x; echo -n "_"; let x++;;
    2 ) let y++; tput cup $y $x; echo -n "|";;
    3 ) let x--; tput cup $y $x; echo -n "_"; let x--;;
  esac
}
function dragon {
  for c in $*
    do
      case $c in
	F ) draw ${angle} ;;
	- ) let angle=(angle+3)%4 ;;
	+ ) let angle=(angle+1)%4 ;;
      esac
    done  
}
function iter {
  s="F X "
  for i in `seq $1`
    do
      s=`map $s`
    done
  echo $s
}


read -p "Enter number of iterations (from 0 to 10): " n
if [[ $n =~ ^[0-9]+$ ]] 
  then
    if [[ $n -gt 10 ]]
      then
	echo please no
	exit
      fi
  else
    echo try again later
    exit
  fi

w=$(tput cols)
h=$(tput lines)
(( t=n/8*8+n/7*9+n/9*3+2 ))
(( b=(n+4)/8*2+(n+5)/8*2+n/10*5+2 ))
(( r=n/9*32+n/8*10+n/10*32+4 ))
(( l=(n+3)/8*8+n/6*8+1 ))
if [ $(( t+b+2 )) -gt $h -o $(( r+l )) -gt $w ]
  then  
    echo "please expand termilal window and press any key"
    echo "(at least $(( t+b+2 )) lines and $(( r+l )) rows)"
    read -n 1 -s q
    w=$(tput cols)
    h=$(tput lines)
  fi
while ([ $(( t+b+2 )) -gt $h -o $(( r+l )) -gt $w ])
  do  
    echo "not enough"
    read -n 1 -s q
    w=$(tput cols)
    h=$(tput lines)
  done
tput clear
# exit
x=20
y=$t
angle=0
dragon `iter $n`
tput cup $(( t+b )) 0
