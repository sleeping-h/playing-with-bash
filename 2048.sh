# move: wasd
# exit: q

  ## colors ##
  
border=238
tile[0]=0
tile[2]=137
tile[4]=221
tile[8]=94
tile[16]=228
tile[32]=186
tile[64]=185
tile[128]=179
tile[256]=178
tile[512]=222
tile[1024]=221
tile[2048]=220

  ## functions ##
  
function range {
  echo `seq 0 $(( $1-1 ))`	# yep, i love python more than bash 
}
function newTile {
  if [[ $1 -eq 0 ]]
    then
      gameOver 0
    fi
  q=$(( RANDOM%100>87 ? 4 : 2 ))
  x=$(( RANDOM%$1 ))
  a[${blank[$x]}]=$q
}
function line {
  echo -en "\e[38;5;${border}m+\e[0m"
  for i in `range $n` 
    do
      echo -en "\e[38;5;${border}m - - - +\e[0m"
    done
  echo 
}
function pipes {
  echo -en "\e[38;5;${border}m|\e[0m"
  for i in `range $n`
  do
  echo -en "       \e[38;5;${border}m|\e[0m"
  done
  echo
}
function shft {
  for j in `range $n` 
    do
      k=0
      b=( )
      c=( )
      for i in `range $n`
	do
	  c[$i]=${a[$(( (i*n+j)*$1+(j*n+i)*$2 ))]}
	done
      u ${c[@]}
      if [[ $k -gt 1 ]]; then
      add; fi
      c=( )
      c=${b[@]}
      b=( )
      k=0
      u ${c[@]}
      for i in `range $k`
	do
	  a[$(( ($3*n+$4)*(n-1)+n*(-1)**$3*(i*$1+j*$2)+(-1)**$4*(j*$1+i*$2) ))]=${b[$(( ($3+$4)*(k-1)+(-1)**$3*(-1)**$4*i ))]} # :3
	done
      for i in `seq $k $(( n-1 ))`
	do
	  a[$(( ($3*n+$4)*(n-1)+n*(-1)**$3*(i*$1+j*$2)+(-1)**$4*(j*$1+i*$2) ))]=0	 
	done
echo
    done
}
function gameOver {
  if [[ $1 -eq 1 ]]
    then
      echo "You win!"
    else
      echo "Game Over!"
  fi
  exit    
}
function u {
  for i in $*
    do
      if [[ $i -ne 0 ]]
	then
	  b[$k]=$i
	  let k++
	fi
    done
}
function add {
  for i in `seq 1 $(( k-1 ))`
    do
      if [[ ${b[$i]} -eq ${b[$(( i-1 ))]} ]]
	then
	  let b[i-1]*=2
	  b[$i]=0
	fi
    done
}
function count {
  t=0
  blank=( )
  for i in `range $(( n*n ))`
  do
    if [[ ${a[$i]} -eq 0 ]]
      then
	blank[$t]=$i
	let t++
      fi
done
}
 
  ## init ##

a=( 0 0 0 0
    0 0 0 0
    0 0 0 0
    0 0 0 0 )

n=4
t=0
blank=( )
win=0
count
newTile $t
count
newTile $t

    ## game ##
    
while ([ "$w" != "q" ])
do
  printf "\033c"
  line
  for j in `range $n` 
    do
      pipes
      for i in `range $n` 
	do
	  x=${a[$(( j*n+i ))]}
	  if [[ $x -eq 2048 ]]
	    then
	      win=1
	    fi
	  if [[ $x -lt 100 ]]
	    then
	      wh1="   "
	      if [[ $x -lt 10 ]]
		then
		  wh2="   "
		else
		  wh2="  "
	      fi
	    else
	      wh1="  "
	      if [[ $x -lt 1000 ]]
		then
		  wh2="  "
		else
		  wh2=" "
		fi
	    fi
	  echo -en "\e[38;5;${border}m|\e[0m$wh1\e[1m\e[38;5;${tile[$x]}m$x\e[0m\e[21m$wh2"
	done
      echo -e "\e[38;5;${border}m|\e[0m"
      pipes
      line 
    done   
  if [[ $win -eq 1 ]]
    then
      gameOver 1
    fi
  
  read -n 1 -s w
  

  count
  c1=( )
  c1=${blank[@]}
  
  case "$w" in
    [wW] )  shft 1 0 0 0 ;;
    [aA] )  shft 0 1 0 0 ;;
    [sS] )  shft 1 0 1 0 ;;
    [dD] )  shft 0 1 0 1 ;;
    [qQ] )  w="q";;   
  esac
  
  count
  c2=( )
  c2=${blank[@]}
  if [[ ${c1[@]} = ${c2[@]} ]] 
    then
      continue
    fi
    
  newTile $t 

done
