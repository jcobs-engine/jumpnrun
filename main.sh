#!/bin/bash
tput civis
echo -en "\033[0m "
clear

b=0
while [ $b -le $COLUMNS ]; do
    eval 'pos'$b=''
    b=$(( $b + 1 ))
done

while [ true ]; do

speed=9
speedc=0
points=0
lives=3
i=0
while [ true ]; do
    clear
    
    b=10
    while [ $b -le $COLUMNS ]; do
	ran=$(( $RANDOM % 5 ))
    	if [ $ran -eq 0 ] && ( [ $block -ge 10 ] || [ $block -eq 0 ] ); then
	    tput cup $LINES $b
	    echo -en "\033[1;41mX\033[0m"
	    eval 'block'$b=1
	    block=0
	else
	    eval 'block'$b=0
	    block=$(( $block + 1 ))
	fi
	
	b=$(( $b + 1 ))
    done

    b=0
    jump=''
    jb=0
    runter=0
    wait=0
    while [ $b -le $COLUMNS ]; do
	if [ "$jumpi" != '' ] && [ "$jb" != 1 ]; then
	    jump=1
	else
	    if [ "$jb" != 1 ]; then
		jump=0
	    fi
	fi

	if [ $jump -eq 1 ] && [ $runter -eq 1 ]; then
	    jump=0
	    runter=0
	    jb=0
	elif [ $jump -eq 2 ] && [ $runter -eq 1 ]; then
	    jump=1
	    jb=1
	elif [ $jump -eq 3 ] && [ $runter -eq 1 ]; then
	    jump=2
	    jb=1
	elif [ $jump -eq 4 ] && [ $wait -eq 2 ]; then
	    jump=3
	    runter=1
	    jb=1
	    wait=0
	elif [ $jump -eq 4 ]; then
	    wait=$(( $wait + 1 ))
	    jb=1
	elif [ $jump -eq 3 ]; then
	    jump=4
	    jb=1
	elif [ $jump -eq 2 ]; then
	    jump=3
	    jb=1
	elif [ $jump -eq 1 ]; then
	    jump=2
	    jb=1
	fi

	bt='block'$b
	if [ $lives -eq 0 ] || ( [ $lives -eq 1 ] && [ ${!bt} -eq 1 ] && ( [ $jump == 0 ] || [ $jump == 1 ] ) ); then
	    echo -en "\033[42m "
	    clear
	    if [ $( cat highscore.txt ) -lt $points ]; then
		addon='\033[41m'
		echo $points > highscore.txt
		add=8
	    else
		add=0
		addon=''
	    fi
	    
	    pts="${addon}POINTS: \033[1m$points\033[0m"
	    tput cup $(( $LINES / 2 - 1 )) $(( ( $COLUMNS / 2 ) - ( ${#pts} - 14 - $add ) / 2 ))
	    echo -en $pts
	    
	    read -sn1 hallo
	    
	    echo -en "\033[0m "
	    clear
	    lives=3
	    speed=9
	    speedc=0
	    points=0
	    break
	fi

	if [ "$jump" == '0' ] || [ "$jump" == 1 ]; then
	    bt='block'$b
	    if [ ${!bt} -eq 1 ]; then
		lives=$(( $lives - 1 ))
		echo -en '\033[41m '
		clear
		sleep 0.2
		echo -en '\033[0m '
		clear
		c=0
		while [ $c -le $COLUMNS ]; do
		    nn='block'$c
		    if [ "${!nn}" == 1 ]; then
			tput cup $LINES $c
			echo -en "\033[1;41mX\033[0m"
		    fi
		    c=$(( $c + 1 ))
		done
	    fi 
	fi
	
	tput cup $(( $LINES - $jump )) $b
	echo -en "\033[1;47mI\033[0m"
	points=$(( $points + 1 ))

	pts="POINTS: \033[1m$points\033[0m"
	tput cup 0 $(( $COLUMNS - ${#pts} + 14 ))
	echo -en $pts

	lvs="LIVES: \033[1m$lives\033[0m"
	tput cup 2 $(( $COLUMNS - ${#lvs} + 14 ))
	echo -en $lvs

	if [ $speedc -eq 100 ] && [ $speed -ge 1 ]; then
	    speed=$(( $speed - 1 ))
	fi

	read -sn1 -t0.0$speed jumpi
	nn='block'$b
	if ( [ $jump -eq 0 ] || [ $jump -eq 1 ] )  && [ "${!nn}" != 1 ]; then
	    tput cup $(( $LINES - $jump )) $b
	    echo -en "\033[0m \033[0m"
	else
	    if [ $jump -eq 0 ]; then
		tput cup $(( $LINES - $jump )) $b
		echo -en "\033[1;41mX\033[0m"
	    else
		tput cup $(( $LINES - $jump )) $b
		echo -en "\033[0m \033[0m"
	    fi
	fi


	if [ $speedc -eq 500 ]; then
	    speedc=0
	fi

	speedc=$(( $speedc + 1 ))
	b=$(( $b + 1 ))
    done

    if [ $lives -eq 0 ]; then
	break;
    fi
    
    i=$(( $i + 1 ))
done
done
