#!/bin/bash

# axiom: FX
# rules:
# X -> X+YF+
# Y -> -FX-Y

w=$( tput cols )
h=$( tput lines )
fit() {
    [[ $1 -lt $w && $1 -ge 0 && $2 -lt $h && $2 -ge 0 ]] && return 0 || return 1
}

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
    0 ) fit $x $y && (tput cup $y $x; echo -n "|"); let y--;;
    1 ) let x++; fit $x $y && (tput cup $y $x; echo -n "_"); let x++;;
    2 ) let y++; fit $x $y && (tput cup $y $x; echo -n "|");;
    3 ) let x--; fit $x $y && (tput cup $y $x; echo -n "_"); let x--;;
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
tput clear
n=$(( n > 10 ? 10 : n < 0 ? 0 : n ))
(( b=(n+4)/8*2+(n+5)/8*2+n/10*5+2 ))
(( t=n/8*8+n/7*9+n/9*3+2 ))
x=20
y=$t
angle=0
dragon `iter $n`
tput cup $(( t+b )) 0
