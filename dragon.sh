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
x=20
y=22
angle=0
tput clear
dragon `iter 10`

