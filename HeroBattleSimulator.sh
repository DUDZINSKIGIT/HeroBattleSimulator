#!/bin/bash
set -f
logo()
{
echo ""
echo -e  "\e[5;91m$(cat logo.txt)\e[;0m"
sleep 2s
echo ""
}
validator()
{

	
	while [ "$text" != "yes" ] && [ "$text" != "no" ]
do
        echo "Not the correct choice: type (yes/no)"
        echo ""
        read -e text
        echo ""
done

}

function menu ()
{
echo "Welcome to the Hero Battle Simulator!"
echo "Provide your hero's name: (White characters will be removed.)"
name=0
read -e name
echo "Do you want to check the guide? type yes/no"
read -e text

echo ""
validator
case $text in 
	"yes")
echo " "		
echo "Class guide"
echo "Warior:"
echo "High	Attack"
echo "Low 	Speed"
echo "Shadow:"
echo "High	Crit,Speed"
echo "low	Attack,HP"
echo "Defender:"
echo "High	HP,Block"
echo "Low	Crit,Speed"
echo " "
echo "Score guide"
echo "Dificulty: Hard:1, Medium:0, Easy:-1"
echo "Result: Win:3, Lost:-3, Escape:-1"
echo ""
sleep 2
;;
"no")
	echo ""
esac

h=0
m=0
e=0
score=0
attack=0
response=0
def=0
atk=0
block=0
ns=0
nsh=0
enemy=1
win=0
loose=0
run=0
}
cvalidator()
{
	while [ "$text" != "1" ] && [ "$text" != "2" ] && [ "$text" != "3" ] && [ "$text" != "4" ]
	do 
		echo "Not the correct choice: type 1, 2, 3 or 4"
		read -e text
	done
}
function hero ()
{
	echo "Choose your class: (1:Warior, 2:Shadow, 3:Defender, 4:No class)"
	read -e text
cvalidator
case "$text" in
"1")
	class="Warior"
	atk=$(expr $(( RANDOM % 5 + 1 )) + 10 )
	def=$(( $RANDOM % 5 + 1 ))
        hp=$(expr $(( $RANDOM % 25 + 1 )) + 100 )
        block=$(( $RANDOM % 5 + 1))
        crit=$(( $RANDOM % 5 + 1 ))
        speed=$(( $RANDOM % 5 + 1))

	;;

"2")
	class="Shadow"
	atk=$(( RANDOM % 5 + 1 ))
	def=$(( $RANDOM % 5 + 1 ))
        hp=$(expr $(( $RANDOM % 25 + 1 )) + 75 )
        block=$(( $RANDOM % 5 + 1 ))
        crit=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
        speed=$(expr $(( $RANDOM % 5 + 1 )) + 10 )

	;;
"3")
	class="Defender"
	atk=$(( RANDOM % 5 + 1 ))
	def=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
        hp=$(expr $(( $RANDOM % 25 + 1 )) + 125 )
	block=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
        crit=0
        speed=$(( $RANDOM % 5 + 1))

	;;
"4")
	class="none"
	atk=$(expr $(( RANDOM % 5 )) + 5 )
	def=$(( $RANDOM % 5 ))
	hp=$(expr $(( $RANDOM % 25 )) + 100 )
	block=$(( $RANDOM % 5 ))
	crit=$(( $RANDOM % 5 ))
	speed=$(expr $(( $RANDOM % 5 )) + 5 ) 
	;;

esac

echo ""
echo "Your hero stats"
critch=$(expr 5 * $crit )
blockch=$(expr 5 * $block  )
echo "hp:	$hp"
echo "atk:	$atk"
echo "def:	$def"
echo "crit:	+$critch%"
echo "block:	+$blockch%"
echo "speed:	$speed"
echo ""
bhp=$hp
batk=$atk
bdef=$def
bcrit=$critch
bblockch=$blockch
bspeed=$speed
}
function mod()
{

	echo "Choose difficulty level (hard/medium/easy)"
level=0
read -e level
echo ""
while [ "$level" != "hard" ] && [ "$level" != "medium" ] && [ "$level" != "easy" ]
do 
	echo "Not the correct choice: type hard, medium, or easy"
	read -e level
done

case "$level" in

       
	"hard")
eatk=$(expr $(( $RANDOM % 5 + 1 )) + 10 )
edef=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
ehp=$(expr $(( RANDOM % 25 + 1 )) + 125 )
enblock=$(( RANDOM % 5 + 1 ))
encrit=$(( RANDOM % 5 + 1 ))
enspeed=$(( $RANDOM % 10 + 5 ))
let "h+=1"
let "score+=1"
;;
"medium")
eatk=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
edef=$(( $RANDOM % 5 + 1 ))
ehp=$(expr $(( RANDOM % 25 + 1 )) + 100 )
enblock=$(( RANDOM % 3 + 1 ))
encrit=$(( RANDOM % 5 + 1 ))
enspeed=$(expr $(( $RANDOM % 5 )) + 5 )
let "m+=1"
;;
"easy")
eatk=$(( $RANDOM % 5 + 1 ))
edef=$(( $RANDOM % 3 ))
ehp=$(expr $(( RANDOM % 25 + 1)) + 75 )
enblock=$(( $RANDOM % 2 + 1 ))
encrit=$(( $RANDOM % 2 + 1))
enspeed=$(( $RANDOM % 3 + 1))
let "e+=1"
let "score-=1"
esac
echo ""
echo "Enemy stats"
echo "hp:	$ehp"
echo "atk:	$eatk"
echo "def:	$edef"
echo "crit:	+$(expr $encrit * 5 )%"
echo "block:	+$(expr $enblock * 5 )%"
echo "speed:	$enspeed"
echo ""
behp=$ehp
beatk=$eatk
bedef=$edef
bencrit=$encrit
benblock=$enblock
benspeed=$enspeed
}

function run ()
{
        echo "Do you really want to run?"
        read -e text
	case "$text" in
		"yes")

                hspeed=$(expr $(( $RANDOM % 15 + 1 )) + $speed )
                espeed=$(expr $(( $RANDOM % 15 + 1)) + $enspeed )
                echo "Checking if you are able to escape"
                sleep 2s
                if [[ $hspeed -lt $espeed ]]

                        then echo "You aren't able to runaway!!!"
                        echo -e "\033Enemy has an extra opurtinity to attack you\033[1;0m"
                        sleep 1s
                        edmg=$(expr $(( $RANDOM % 15 + 1 )) + $eatk )
                        echo "Enemy deals $edmg dmg"
                        hp=$(expr $hp - $edmg )
                        echo "Your hero has $hp hp left"

                                if [[ "$hp" -lt 0 ]]
                                then
                                echo -e "\033[1;5;41mYou loose a battle!!!\033[1;0m"
                                let "loose+=1"
                                let "score-=3"
                                return 1
                                fi
                         echo ""

                else
                        echo -e "\033[1;5;33mYou runaway fast!!!\033[1;0m"
                        let "run+=1"
                        let "score-=1"
			cont
                fi
		;;
          "no")

	battle

	esac
        
}

function Efightoption ()

        {


                eoption=$(( $RANDOM % 3 + 1 ))
                while [[ $eoption > 3 ]]
                do
                        eoption=$(( $RANDOM % 3 + 1 ))
                done

   	     case "$eoption" in
                "1")
                echo "Enemy tries to Power Attack your hero!"
		emod="pow"
sleep 1s
                        ;;
                "2")
                        echo "Enemy tries to Normal Attack your hero!"
			sleep 1s
                        ;;
                "3")
                        echo "Enemy tries to Fast Attack your hero!"
                      emod="fast"
		      sleep 1s
                        ;;
        esac
        }

function Fightoption ()
        {
        echo "Choose your action"
        echo "1.Power Attack, 2 Normal Attack, 3.Fast Attack,4.Run. Type 1,2,3 or 4."
	read -e text
        cvalidator
        case "$text" in
                "1")
			mod="pow"
                        echo "Your hero tries to Power Attack an enemy!"
                        sleep 1s
                        ;;
                "2")
                        echo "Your hero tries to Normal Attack an enemy!"
                        sleep 1s
                        ;;

                "3")
			mod="fast"
                        echo "Your hero tries to Fast Attack an enemy!"
                        sleep 1s
                        ;;
                "4")
                run
                        ;;
                esac
        }



function walka ()

{
echo "Fight nr $enemy begins!"
echo ""
round=1
	sleep 2s
function battle ()
{
while [ "$hp" > 0 ]
do 
	echo "round $round"
	#stats reset
        atk=$batk
        def=$bdef
        critch=$bcrit
        blockch=$bblockch
        speed=$bspeed
        eatk=$beatk
        edef=$bedef
        encrit=$bencrit
        enblock=$benblock
        enspeed=$benspeed



Fightoption
Efightoption

	hdmg1=0
	hdmg2=0
	edmg1=0
	edmg2=0
	hcrit=$(expr $(( $RANDOM % 20 + 1 )) + $crit )
	ecrit=$(expr $(( $RANDOM % 20 + 1 )) + $encrit )
	hblock=$(expr $(( $RANDOM % 20 + 1 )) + $block ) 
	eblock=$(expr $(( $RANDOM % 20 + 1 )) + $enblock )
	hspeed=$(expr $(( $RANDOM % 15 + 1 )) + $speed ) 
	espeed=$(expr $(( $RANDOM % 15 + 1 )) + $enspeed )	
	case $mod in
		"fast")
			let "hspeed+=5"
			let "atk-=5"
			let "hcrit-=3"
			let "eblock-=3"
	;;
		"pow")
			let "atk+=5"
			let "hcrit+=3"
			let "hspeed-=5"
			let "eblock+=3"
	;;
	esac

	case $emod in
		"fast")
			let "espeed+=5"
			let "hblock-=3"
			let "ecrit-=3"
			let "eatk-=5"
		;;
		"pow")
			let "eatk+=5"
			let "ecrit+=3"
			let "espeed-=5"
			let "hblock+=3"
		;;
 	esac

	if [[ $def -gt 0 ]]

	then
	    	def=$(( $RANDOM % $def + 1 ))
		eatk=$(expr $eatk - $def )
	fi
	if [[ $edef -gt 0 ]] 
	then	
		edef=$(( $RANDOM % $edefa + 1 ))
		atk=$(expr $atk - $edef )
	fi

	declare -i hdmg=$(expr $(( $RANDOM % 15 + 1 )) + $atk ) 
	declare -i edmg=$(expr $(( $RANDOM % 15 + 1 )) + $eatk ) 
	echo "round $round"
	echo ""
if [[ "$eblock" -lt 20 ]];
        then
		if [[ "$hspeed" -ge $(expr $espeed * 2 ) ]]
                then
                echo -e "\033[1;32mYour hero attacks an enemy twice\033[1;0m"
		sleep 1s
                hcrit1=$(expr $(( $RANDOM % 20 + 1 )) + $crit )
                hcrit2=$(expr $(( $RANDOM % 20 + 1 )) + $crit )
                declare -i hdmg1=$(expr $(( $RANDOM % 15 + 1 )) + $atk )
                declare -i hdmg2=$(expr $(( $RANDOM % 15 + 1 )) + $atk )
				if [[ $hdmg1 -le 0 ]]
                                        then
                                        hdmg1=$(( $RANDOM % 5 + 1 ))
                                fi
                                if [[ $hdmg2 -le 0 ]]
                                        then
                                        hdmg2=$(( $RANDOM % 5 + 1 ))
                                fi

                        if [[ "$hcrit1" -ge 20 ]]
                        then
                        echo -e "\033[1;32mHero 1st attack is a crit\033[1;0m"
                        sleep 1s
			if [[ "hdmg1" -lt 10 ]]
			then
				hdmg1=10
			fi
			hdmg1=$(expr $hdmg1 * 2 )
                        fi
                        if [[ "$hcrit2" -ge 20 ]]
                        then
                        echo -e "\033[1;32mHero 2nd attack is a crit\033[1;0m"
                        sleep 1s
			if [[ "hdmg2" -lt 10 ]]
                        then
                                hdmg2=10
                        fi

			hdmg2=$(expr $hdmg2 * 2 )
                        fi
                        hdmg=$(expr $hdmg1 + $hdmg2 )

                elif [[ "$hcrit" -ge 20 ]]
                then 
			if [[ "$hdmg" -lt 10 ]]
			then
				hdmg=10
			fi

			let hdmg=$(expr $hdmg * 2 )
                        echo -e "\033[1;32mYour hero lands the critcal attack\033[1;0m"
			sleep 1s
		fi
        else
             hdmg=0
                echo -e "\033[1;31mEnemy blocks your attack\033[1;0m"
		sleep 1s
        fi
	if [[ "$hblock" -lt 20 ]];
        	then
			
		if [[ "$espeed" -ge $(expr $hspeed * 2 ) ]]
			then
			echo -e "\033[1;31mEnemy attacks your hero twice\033[1;0m"
			sleep 1s
			ecrit1=$(expr $(( $RANDOM % 20 + 1 )) + $encrit )
			ecrit2=$(expr $(( $RANDOM % 20 + 1 )) + $encrit )
			declare -i edmg1=$(expr $(( $RANDOM % 15 + 1 )) + $eatk )
			declare -i edmg2=$(expr $(( $RANDOM % 15 + 1  )) + $eatk )
				if [[ $edmg1 -le 0 ]]
					then
					edmg1=$(( $RANDOM % 5 + 1 ))	
				fi
				if [[ $edmg2 -le 0 ]]
					then
                                        edmg2=$(( $RANDOM % 5 + 1 ))
				fi
			
				if [[ "$ecrit1" -ge 20 ]]

				then
				echo -e "\033[1;31mEnemy 1st attack is a crit\033[1;0m"
				sleep 1s
					if [[ "$edmg1" -lt 10 ]]
                              		then
                              		edmg1=10
                             	 	fi

				edmg1=$(expr $edmg1 * 2 )
				fi
				if [[ "$ecrit2" -ge 20 ]]
				then
					echo  -e "\033[1;31mEnemy 2nd attack is a crit\033[1;0m"
                			sleep 1s
					if [[ "$edmg2" -lt 10 ]]
                                	then
                                        	edmg2=10
                                	fi

					edmg2=$(expr $edmg2 * 2 )
				fi
			edmg=$(expr $edmg1 + $edmg2 )
			fi
		elif [[ "$ecrit" -ge 20 ]]
                	then
			if [[ "$edmg" -lt 10 ]]
			then
				edmg=10
			fi
					
			let edmg=$(expr $edmg * 2 )
                        echo -e "\033[1;31mEnemy lands the critcal attack\033[1;0m"
			sleep 1s
                
        else
       		edmg=0
                echo -e "\033[1;32mYour hero blocks an enemy attack\033[1;0m"
		sleep 1s
	fi

	
	sleep 1s
	if [[ $hdmg1 -gt 0 ]]
	then
		echo "Your hero deals $hdmg1 dmg and $hdmg2 dmg"
		echo "Total $hdmg dmg"
		sleep 1s
	else	
		if [[ $hdmg -lt 0 ]]
		then
			hdmg=$(( $RANDOM % 5 + 1 ))
		fi
		echo "Your hero deals $hdmg dmg"
		sleep 1s
	fi
	if [[ $edmg1 -gt 0 ]]
	then
		echo "Enemy deals $edmg1 dmg and $edmg2 dmg"
		echo "Total $edmg dmg"
		sleep 1s
	else
		if [[ $edmg -lt 0 ]]
		then
			edmg=$(( $RANDOM % 5 + 1 ))
		fi
		echo "Enemy deals $edmg dmg"
		sleep 1s
	fi
	hp=$(expr $hp - $edmg )
        ehp=$(expr $ehp - $hdmg )

	echo "Your hero has $hp hp left"
	echo "Enemy has $ehp hp left"
	echo ""
	sleep 1s
	let "round+=1"

	if [[ "$hp" -lt 0 ]]
	then
		echo -e "\033[1;5;41mYou loose a battle!!!\033[1;0m"
		let "loose+=1"
		let "score-=3"
		return 1
	elif [[ "$ehp" -lt  0 ]]
	then
		echo -e "\033[1;5;32mYou win a battle!!! Congratulations!!!\033[1;0m"
		let "win+=1"
		let "score+=3"
		return 0
	fi



done
}
battle
}
cont()
{
echo "Game will automatycally ends after 5 fights"
echo "Do you want to fight with a next enemy? (yes/no)"
text=0
read -e text

validator
case "$text" in
	"yes")

        let "enemy+=1"
        hero
   	mod 
	walka
        echo "The game will automatically end after five fights"
        echo "Current fight nr $enemy"
        echo "Do you want to fight with a next enemy? (yes/no)"
        read -e text
	validator
	cont
	;;
	"no")
	ending
	esac
}
ending()
{
        echo "$name Thanks for playing"
        echo "Your record:"
        echo "$win Wins, $loose Losts, $run Runaways"
        echo "No Sword:$ns, No shield:$nsh"
        echo "Hard:$h, Medium:$m, Easy:$e"
        echo "score:$score"
        echo "`date +%d.%m.%y` `date +%H:%M:%S` ${name//[[:space:]]/} $enemy $score" >> fight_score_board.log
        echo -e "\033[1;5;32mTop 10 playes!!!\033[1;0m"
        awk 'NR==1{print; next} {print | "sort -k 5nr"}' fight_score_board.log | head -n 11 | column -t

	echo ""
	echo "Do you want to play again?"
	echo ""
	read -e text

	validator

	case $text in
		"yes")
		gra
		;;

	"no")
		echo ""
		echo -e  "\e[5;91m$(cat goodbye.txt)\e[;0m"
	sleep 2s
	echo ""


	exit 0
	esac
}
gra()

{
logo
menu
hero
mod
walka
cont
ending
}

gra
