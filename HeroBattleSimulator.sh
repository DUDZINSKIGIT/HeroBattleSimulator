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
echo "High	HP,Block,Defence"
echo "Low	Attack,Crit,Speed"
echo " "
echo "Action Guide"
echo "Power Attack:High Possible DMG and CRIT, EASY to block and Slow"
echo "Normal Attack:No modificators, Just normal attack"
echo "Fast Attack:Low Possible DMG and CRIT, HARD to block and Fast"
echo "RUN: Chance to flee from a fight; if fails, an enemy has an extra attack roll on you"
echo " "
echo "Score guide"
echo "BOSS encounter:+3"
echo "Result: Win:3, Lost:-3, Escape:-1"
echo "Treasure: Big:3 Medium:2 Small:1"
echo ""
sleep 2
;;
"no")
	echo ""
esac
}
function summary ()
{
	if [[ "$hp" -le 0 ]]
	then
		echo -e "\033[1;5;41m$name loose a battle!!!Game Over!!!\033[1;0m"
		let "loose+=1"
		let "score-=3"
		ending
	elif [[ "$ehp" -le  0 ]]
	then
		echo -e "\033[1;5;32m$name win a battle!!! Congratulations!!!\033[1;0m"
		let "win+=1"
		let "score+=3"
		if [[ $boss -gt 0 ]]
		then	
			echo " "
			reward
			echo " "
			reward
			echo " "
			reward
			echo " "
			boss=0
		fi
		
		luck=$(( $RANDOM % 10 + 1))		
		poi=0
		echo " "
		reward
		echo " "
		if [[ $luck -gt 5 ]]
                then
                        echo -e "\033[1;32m$name has an extra luck and founds an additional item\033[1;0m"
			echo " "
                reward
			echo " "
                fi
		if [[ $class == "Ranger" ]]
		then
			dist=2
		fi
		exps
		hstats
		echo "SCORE:	$score"
		
		cont
	fi
}

function dmgcalc ()

{	
	sleep 1s
	if [[ $hdmg1 -gt 0 ]]
	then
		echo "$name deals $hdmg1 dmg and $hdmg2 dmg"
		echo "Total $hdmg dmg"
		sleep 1s
	else	
		if [[ $hdmg -le 0 ]]
		then
			if [[ $eb -le 0 ]]
			then
			hdmg=$(( $RANDOM % 5 + 1 ))
			fi
		fi
		poison
		echo "$name deals $hdmg dmg"
		sleep 1s
	fi
	if [[ $edmg1 -gt 0 ]]
	then
		echo "$enemy deals $edmg1 dmg and $edmg2 dmg"
		echo "Total $edmg dmg"
		sleep 1s
	else
		if [[ $edmg -le 0 ]]
		then
			if [[ $hb -le 0 ]] && [[ $dist -lt 1 ]]
			then
			edmg=$(( $RANDOM % 5 + 1 ))
			fi
		fi
		epoison
		echo "$enemy deals $edmg dmg"
		sleep 1s
	fi
	function regen ()
	{
	if [[ $regen -gt 0 ]]
	then
		sleep 1s
		reg=$(expr $(expr $regen * $bhp ) / 100 )
		hp=$(expr $hp + $reg ) 
		 echo -e "\033[1;32m$name regen $reg hp\033[1;0m"
		 sleep 1s
		 if [[ $hp -ge $bhp ]]

			then 
				hp=$bhp
		 fi
	fi
	
	if [[ $eregen -gt 0 ]]
        then
		sleep 1s
                ereg=$(expr $(expr $eregen * $behp ) / 100 )
                hp=$(expr $ehp + $ereg )
                 echo -e "\033[1;31m$enemy regen $ereg hp\033[1;0m"
		 sleep 1s
                 if [[ $ehp -ge $behp ]]

                        then
                                ehp=$behp
         	 fi
        fi
	}	
	
		
function poisondmg ()
	{	
	if [[ $poi -gt 0 ]]
	then
	ehp=$(expr $ehp - $poi )
	
	echo -e "\033[1;32m$enemy receives $poi poison dmg\033[1;0m"
	let "poi-=1"
	sleep 1s
	fi
	if [[ $epoi -gt 0 ]]
		then
        hp=$(expr $hp - $epoi )

        echo -e "\033[1;31m$name receives $epoi poison dmg\033[1;0m"
	let "epoi-=1"
	sleep 1s

        fi

	}
	regen
	poisondmg
	
function barb ()

{
	if [[ $frenzy -gt 0 ]]
	then
		fredmg=$(expr $(expr $frenzy * $hdmg ) / 100 )
		if [[ $fredmg -gt 0 ]]	
		then
		hp=$(expr $hp - $fredmg )
		echo "$name deals $fredmg to yourself in frenzy"
		fi
	fi
	if [[ $lfsteel -gt 0 ]]
        then
                lfback=$(expr $(expr $lfsteel * $hdmg ) / 100 )
                if [[ $lfsteel -gt 0 ]]
		then
                hp=$(expr $hp + $lfback )
                echo "$name steals $lfback hp"
		if [[ $hp -ge $bhp ]]

                        then
                                hp=$bhp
                fi

		sleep 1s
                fi
        fi
	if [[ $defl -gt 0 ]]
	then
	defldmg=$(expr $(expr $defl * $edmg ) / 100 )
	ehp=$(expr $ehp - $defldmg )
	echo "$name deflects $defldmg to $enemy"
	fi
}
	barb
	hp=$(expr $hp - $edmg )
  	ehp=$(expr $ehp - $hdmg )
	echo "$name has $hp hp left"
	echo "$enemy has $ehp hp left"
	echo ""
	sleep 1s
	let "round+=1"
}

function ranged ()
{
if [[ dist -ge 1 ]]
then
echo "$name atacks from distance"
edmg=0

dmgcalc

fi
}

function lvup ()
{
	let "lv+=1"
	echo "$name levels up!"
	case $class in
		Warrior|Barbarian|Vampire)
			let "bhp+=10"
			let "batk+=2"
			let "bcrit+=1"
			;;
		Shadow|Ranger|Assasin)
			let "bhp+=5"
			let "bcrit+=1"
			let "bspeed+=2"
			;;
		Defendef|Regenerator|Deflecter)
			let "bhp+=15"
			let "bdef+=2"
			let "bblock+=1"
			;;
		"None")
			let "bhp+=10"
			let "bdef+=1"
			let "batk+=1"
	;;
	esac
}
	

function exps ()
{	
	gain=$(expr $behp + $beatk )
	echo "$name gains $gain exp"
	let "pkt+=$gain"
	lvcap=$(expr $lv * 100 )
	while [ $pkt -ge $lvcap ]
	do 
		lvup
		lvcap=$(expr $lv * 100 )
	done


}
defl=0
pkt=0
lv=1
dist=0 
regen=0
key=0
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
fight=1
win=0
loose=0
run=0
#poison mechanic
bpoi=0
ebpoi=0
poi=0
epoi=0
function poison ()
{
if [[ bpoi -gt 0 ]]
then
	let "poi+=$bpoi"
fi
}
function epoison ()
{
if [[ ebpoi -gt 0 ]]
then
        let "epoi+=$ebpoi"
fi

}
function svalidator () 
{		
                        while [ "$text" != "1" ] && [ "$text" != "2" ]
			do
			echo "Not the correct choice: type 1 or 2"
                	read -e text
			done
}
function cvalidator ()
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
	def=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
    hp=$(expr $(( $RANDOM % 25 + 1 )) + 100 )
	block=$(( $RANDOM % 5 + 1))
    crit=$(( $RANDOM % 5 + 1 ))
    speed=$(( $RANDOM % 5 + 1 ))
	regen=$(( $RANDOM % 2  + 1 ))	
	echo "Do you want to choose sub-class? Type: yes/no"
	read -e text
	validator
				case $text in
						
						"yes")
							echo "Which sub-class you want to choose: 1.Barbarian, 2.Vampire? Type 1 or 2"
							read -e text
							svalidator
								case $text in
								"1")
								class="Barbarian"
								atk=$(expr $(( RANDOM % 5 + 1 )) + 15 )
								def=$(( $RANDOM % 5 + 1 ))
    								hp=$(expr $(( $RANDOM % 25 + 1 )) + 125 )
								block=0
    								crit=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
    								speed=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
								regen=$(( $RANDOM % 2  + 1 ))
								frenzy=20
								;;
								"2") 
								class="Vampire"
								atk=$(expr $(( RANDOM % 5 + 1 )) + 10 )
								def=$(( $RANDOM % 5 + 1 ))
    							hp=$(expr $(( $RANDOM % 25 + 1 )) + 75 )
								block=$(( $RANDOM % 5 + 1))
    							crit=0
    							speed=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
								regen=$(( $RANDOM % 2  + 1 ))
								lfsteel=20
								;;
								esac
						;;			
				
				esac
;;
				

"2")

	class="Shadow"
	atk=$(( RANDOM % 5 + 1 ))
	def=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
    hp=$(expr $(( $RANDOM % 25 + 1 )) + 75 )
    block=$(( $RANDOM % 5 + 1 ))
    crit=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
    speed=$(expr $(( $RANDOM % 5 + 1 )) + 10 )
	regen=$(( $RANDOM % 2 + 1 ))
	bpoi=1
echo "Do you want to choose sub-class? Type: yes/no"
	read -e text
	validator
				case $text in
						
						"yes")
							echo "Which sub-class you want to choose: 1.Assasin, 2.Ranger? Type 1 or 2"
							read -e text
							svalidator
								case $text in
								"1")
								class="Assasin"
								atk=$(expr $(( RANDOM % 5 + 1 )) + 5 )
								def=$(( $RANDOM % 5 + 1 ))
    							hp=$(expr $(( $RANDOM % 25 + 1 )) + 75 )
								block=0
    							crit=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
    							speed=$(expr $(( $RANDOM % 5 + 1 )) + 10 )
								regen=$(( $RANDOM % 2  + 1 ))
								bpoi=3
								;;
								"2") 
								class="Ranger"
								atk=$(expr $(( RANDOM % 5 + 1 )) + 5 )
								def=0
    							hp=$(expr $(( $RANDOM % 25 + 1 )) + 75 )
								block=0
    							crit=$(( $RANDOM % 5 ))
    							speed=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
								regen=$(( $RANDOM % 2  + 1 ))
								dist=2
								;;
								esac
						;;			
				
				esac
;;	

"3")
	class="Defender"
	atk=$(( RANDOM % 5 + 1 ))
	def=$(expr $(( $RANDOM % 5 + 1 )) + 10 )
    hp=$(expr $(( $RANDOM % 25 + 1 )) + 125 )
	block=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
    crit=0
    speed=$(( $RANDOM % 5 + 1 ))
	regen=$(expr $(( $RANDOM % 3 + 1 )) + 2 )
	echo "Do you want to choose sub-class? Type: yes/no"
	read -e text
	validator
				case $text in
						
						"yes")
							echo "Which sub-class you want to choose: 1.Regenerator, 2.Deflecter? Type 1 or 2"
							read -e text
							svalidator
								case $text in
								"1")
								class="Deflecter"
								atk=0
								def=$(expr $(( $RANDOM % 5 + 1 )) + 15 )
    								hp=$(expr $(( $RANDOM % 25 + 1 )) + 150 )
								block=$(( $RANDOM % 5 + 1 ))
    								crit=0
    								speed=$(( $RANDOM % 5 + 1 ))
								regen=$(( $RANDOM % 2  + 1 ))
								defl=20
								;;
								"2") 
								class="Regenerator"
								atk=$(( RANDOM % 5 + 1 ))
								def=$(expr $(( $RANDOM % 5 + 1 )) + 10 )
    							hp=$(expr $(( $RANDOM % 25 + 1 )) + 100 )
								block=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
    							crit=0
    							speed=$(( $RANDOM % 5 + 1 ))
								regen=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
								;;
								esac
						;;			
				
				esac
	;;
"4")
	class="None"
	atk=$(expr $(( RANDOM % 5 )) + 5 )
	def=$(expr $(( $RANDOM % 5 + 1 )) + 5 )
	hp=$(expr $(( $RANDOM % 25 )) + 100 )
	block=$(( $RANDOM % 5 ))
	crit=$(( $RANDOM % 5 ))
	speed=$(expr $(( $RANDOM % 5 )) + 5 ) 
	;;

esac


echo ""
critch=$(expr 5 * $crit )
blockch=$(expr 5 * $block  )
function hstats ()
{
echo "Your hero stats"
echo "lv:		$lv"
echo "hp:		$hp"
echo "atk:		$batk"
echo "def:		$bdef"
echo "crit:		$(expr $(expr $bcrit * 5 ) + 5 )%"
echo "block:		$(expr $(expr $bblock * 5 ) + 5 )%"
echo "speed:		$bspeed"
echo "regen:		$regen%"
echo "poison:		$bpoi"
echo "exp:		$pkt"
case $class in 
	"Barbarian")
echo "frezny:	$frenzy%"
;;
	"Vampire")
echo "lifesteal	$lfsteel%"
;;
	"Ranger")
echo "distance:	$dist"
esac

}
bhp=$hp
batk=$atk
bdef=$def
bcrit=$crit
bblock=$block
bspeed=$speed
hstats
echo " "
}

function mod()
{
boss=0

if [[ $key -gt 0 ]]
then
echo "$name has a golden key"
echo "Do you want to fight with a BOSS enemy?"
read -e text
validator
case "$text" in
	"yes")
		sleep 1s
		let "key-=1"
		boss=1
		echo "Brace yourself BOSS is comming"
		sleep 1s
		;;
	"no")
		echo "Maybe next time..."
	;;
esac
fi
echo "$name searches for an enemy"
sleep 2s
case "$boss" in

	"1")
echo -e "The BOSS Appears"
sleep 1s
enemy=$(shuf -n 1 boss.txt )
eatk=$(expr $(( $RANDOM % 5 + 1 )) + 15 )
edef=$(expr $(( $RANDOM % 5 + 1 )) + 15 )
#ehp=1
ehp=$(expr $(( RANDOM % 25 + 1 )) + 150 )
enblock=$(expr $(( RANDOM % 5 + 1 )) + 5 )
encrit=$(expr $(( RANDOM % 5 + 1 )) + 5 )
enspeed=$(( RANDOM % 10 + 1 ))
mod=$(expr $fight / 10 )
eregen=$mod
ebpoi=$(( RANDOM % 3 + 1 ))
let "score+=5"
sleep 1s
;;

	"0")
echo "An enemy appears"
sleep 1s
mod=$(expr $fight / 5 )
enemy=$(shuf -n 1 enemy.txt )
eatk=$(expr $(( $RANDOM % 10 + 1 )) + $mod )
edef=$(expr $(( $RANDOM % 10 + 1 )) + $mod )
ehp=$(expr $(( RANDOM % 50 + 1 )) + $fight )
mod=$(expr $fight / 10 )
enblock=$(expr $(( RANDOM % 5 + 1 )) + $mod )
encrit=$(expr $(( RANDOM % 5 + 1 )) + $mod )
enspeed=$(expr $(( $RANDOM % 15 + 1 )) + $mod )
eregen=$mod
ebpoi=0
if [[ mod -gt 10 ]]
then
ebpoi=$(expr $(( RANDOM % 3 + 1 )) - 2 )
elif [[ mod -gt 20 ]]
then
      ebpoi=$(expr $(( RANDOM % 5 + 1 )) - 2 )
fi
if [[ bepoi -lt 0 ]]
then 
	ebpoi=0
fi

sleep 1s
esac
echo ""
echo "$enemy"
echo "hp:	$ehp"
echo "atk:	$eatk"
echo "def:	$edef"
echo "crit:	$(expr $(expr $encrit * 5 ) + 5 )%"
echo "block:	$(expr $(expr $enblock * 5 ) + 5 )%"
echo "speed:	$enspeed"
echo "regen:	$eregen%"
echo "poison:	$ebpoi"
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
                        echo -e "\033$enemy has an extra opurtinity to attack $name\033[1;0m"
                        sleep 1s
                        edmg=$(expr $(( $RANDOM % 15 + 1 )) + $eatk )
                        echo "$enemy deals $edmg dmg"
			regen
                        hp=$(expr $hp - $edmg )
                        echo "Your hero has $hp hp left"

                                if [[ "$hp" -lt 0 ]]
                                then
                                echo -e "\033[1;5;41m$name loose a battle!!!\033[1;0m"
                                let "loose+=1"
                                let "score-=3"
			ending
                                fi
                         echo ""

                else
                        echo -e "\033[1;5;33m$name runaway fast!!!\033[1;0m"
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
                echo "$enemy tries to Power Attack your hero!"
		emod="pow"
sleep 1s
                        ;;
                "2")
                        echo "$enemy tries to Normal Attack your hero!"
			sleep 1s
                        ;;
                "3")
                        echo "$enemy tries to Fast Attack your hero!"
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
                        echo "$name tries to Power Attack an enemy!"
                        sleep 1s
                        ;;
                "2")
                        echo "$name tries to Normal Attack an enemy!"
                        sleep 1s
                        ;;

                "3")
			mod="fast"
                        echo "$name tries to Fast Attack an enemy!"
                        sleep 1s
                        ;;
                "4")
                run
                        ;;
                esac
        }



function walka ()

{
echo "Fight nr $fight begins!"
echo ""
round=1
	sleep 2s
function battle ()
{
while [ "$hp" > 0 ]
do 
	echo "round $round"
	#stats reset
        hb=0
	eb=0
	atk=$batk
        def=$bdef
        crit=$bcrit
        block=$bblock
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
		ndef=$(expr $def / 2 )
		eatk=$(expr $eatk - $ndef )
	fi
	if [[ $edef -gt 0 ]] 
	then	
		nedef=$(expr $edef / 2 )
		atk=$(expr $atk - $nedef )
	fi

	hdmg=$(expr $(( $RANDOM % 15 + 1 )) + $atk ) 
	edmg=$(expr $(( $RANDOM % 15 + 1 )) + $eatk ) 
	echo ""
if [[ "$eblock" -lt 20 ]];
        then
		if [[ "$hspeed" -ge $(expr $espeed * 2 ) ]]
                then
                echo -e "\033[1;32m$name attacks an enemy twice\033[1;0m"
		sleep 1s
		poison
		poison
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
                        echo -e "\033[1;32m$name 1st attack is a crit\033[1;0m"
                        sleep 1s
			if [[ "hdmg1" -lt 10 ]]
			then
				hdmg1=10
			fi
			hdmg1=$(expr $hdmg1 * 2 )
                        fi
                        if [[ "$hcrit2" -ge 20 ]]
                        then
                        echo -e "\033[1;32m$name 2nd attack is a crit\033[1;0m"
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
                        echo -e "\033[1;32m$name lands the critcal attack\033[1;0m"
			sleep 1s
		fi
        else
		eb=1
             hdmg=0
                echo -e "\033[1;31m$enemy blocks your attack\033[1;0m"
		sleep 1s
        fi
ranged
	if [[ "$hblock" -lt 20 ]];
        	then
			
		if [[ "$espeed" -ge $(expr $hspeed * 2 ) ]]
			then
			echo -e "\033[1;31m$enemy attacks your hero twice\033[1;0m"
			sleep 1s
			epoison
			epoison
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
				echo -e "\033[1;31m$enemy 1st attack is a crit\033[1;0m"
				sleep 1s
					if [[ "$edmg1" -lt 10 ]]
                              		then
                              		edmg1=10
                             	 	fi

				edmg1=$(expr $edmg1 * 2 )
				fi
				if [[ "$ecrit2" -ge 20 ]]
				then
					echo  -e "\033[1;31m$enemy 2nd attack is a crit\033[1;0m"
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
			epoison		
			let edmg=$(expr $edmg * 2 )
                        echo -e "\033[1;31m$enemy lands the critcal attack\033[1;0m"
			sleep 1s
                
        else	
		hb=1
       		edmg=0
                echo -e "\033[1;32m$name blocks an enemy attack\033[1;0m"
		sleep 1s
	fi

	


if [[ $dist -ge 1 ]]
then

hspeed=$(expr $(( $RANDOM % 15 + 1 )) + $speed )
espeed=$(expr $(( $RANDOM % 15 + 1)) + $enspeed )
                sleep 2s
                if [[ $hspeed -lt $espeed ]]
			then
			let "dist-=1"
			echo "$enemy moves forward to you"
			echo "current distance $dist"
			if [[ $dist -lt 1 ]]
			then
			echo "$enemy is now able to attack you"	
			fi
		elif [[ $espeed -lt $hspeed ]]
		then
			let "dist+=1"
				if [[ $dist -ge 3 ]]
				then 
				dist=3
				echo "$name reaches MAX possible distance $dist"
				else
					echo "$name raises distance to $dist"
				fi
		
		fi
else

dmgcalc
fi
summary
done
}
battle
}

function reward ()
{
rew=$(( $RANDOM % 10 + 1 ))
case "$rew" in
	"1")
	       	echo "$enemy dropps a healing potion"
		sleep 1s
		heal=$(( $RANDOM % $bhp + 1 ))
		if [[ $heal -lt 25 ]]
		then 
			heal=25
			echo "$name founds a small potion"
			sleep 1s
			if [[ $epoi -gt 0 ]]
			then
			let "epoi-=10"
				if [[ epoi -lt 0 ]]
				then 
					epoi=0
				fi
			fi

		elif [[ $heal -gt 50 ]]
		then
			heal=50
                        echo "$name founds a big potion"
			sleep 1s
			if [[ $epoi -gt 0 ]]
                        then
                        let "epoi-=25"
				if [[ epoi -lt 0 ]]
                                then
                                        epoi=0
                        	fi

                        fi

		else 
			echo "$name founds a normal potion"
			if [[ $epoi -gt 0 ]]
			then
                        let "epoi-=20"
				if [[ epoi -lt 0 ]]
                                then
                                        epoi=0
                                fi

			sleep 1s
			fi
		fi

		hp=$(expr $hp + $heal )
		if [[ $hp -ge $bhp ]]
		then
			hp=$bhp
			echo "$name heals to MAX hp and reduces poison to $epoi"
			sleep 1s
		else
			echo "$name heals $heal hp and reduces poison to $epoi"
			sleep 1s
		fi
		;;
	"2")
		echo "$enemy drops a weapon"
		sleep 1s
		wep=$(( $RANDOM % 5 + 1 ))

		case $wep in
			"1")
				echo "$name founds a cursed weapon"
				bonus=$(expr  $(( $RANDOM % 3 + 1 )) - 3 )
				batk=$(expr $batk + $bonus )

					echo "$name atk changes by $bonus"
					sleep 1s
					;;
			"2") 
				echo "$name founds a normal weapon"


                                        let "batk+=1"
				echo "$name atk changes to $batk"
					sleep 1s
                                        ;;
			"3")    
				echo "$name founds a good weapon"
					
					let "batk+=2"
					echo "$name atk changes to $batk"
					sleep 1s
					;;
			"4")   
				echo "$name founds a great weapon"

					let "batk+=3"
					echo "$name atk changes to $batk"
					sleep 1s
					;;
			"5")
				echo "$name founds a blessed weapon"

                                        let "batk+=5"
					echo "$name atk changes to $batk"
					sleep 1s
                                        ;;
			esac
		;;

	"3")

		echo "$enemy drops a shield"
                sleep 1s
                shd=$(( $RANDOM % 5 + 1 ))
		if [[ $class == "Ranger" ]]
		then 
			echo "$name can't use shields"
			echo "$name sells it for $shd (+$shield score)"
				let "score+=$shd"
		else
                case $shd in
                        "1")
                                echo "$name founds a cursed shield"
                                bonus=$(expr  $(( $RANDOM % 3 + 1 )) - 3 )
                                bdef=$(expr $bdef + $bonus )
                                        echo "$name def changes by $bonus"
					sleep 1s
                                        ;;
                        "2")
                                echo "$name founds a normal shield"


                                        let "bdef+=1"
                                        
					echo  "$name def changes to $bdef"
					sleep 1s
                                        ;;
                        "3")
                                echo "$name founds a good shield"

                                        let "bdef+=2"
                                        echo "$name def changes to $bdef"
					sleep 1s
                                        ;;
                        "4")
                                echo "$name founds a great shield"

                                        let "bdef+=3"
                                        
					echo "$name def changes to $bdef"
					sleep 1s
                                        ;;
                        "5")
                                echo "$name founds a blessed shield"

                                        let "bdef+=5"
                                        echo "$name def changes to $bdef"
					sleep 1s
                                        ;;
                        esac
		fi
                ;;
	

		"4")

                echo "$enemy drops a shoes"
                sleep 1s
                bonus=$(( $RANDOM % 5 + 1 ))

                case $bonus in
                        "1")
                                echo "$name founds a cursed shoes"
                                bonus=$(expr  $(( $RANDOM % 3 + 1 )) - 3 )
                                bspeed=$(expr $bspeed + $bonus )
                                        echo "$name speed changes by $bonus"
                                        ;;
                        "2")
                                echo "$name founds a normal shoes"


                                        let "bspeed+=1"

                                        echo  "$name speed changes to $bspeed"
					sleep 1s
                                        ;;
                        "3")
                                echo "$name founds a good shoes"

                                        let "bspeed+=2"
                                        echo "$name speed changes to $bspeed"
					sleep 1s
                                        ;;
                        "4")
                                echo "$name  founds a great shoes"

                                        let "bspeed+=3"

                                        echo "$name speed changes to $bspeed"
					sleep 1s
                                        ;;
                        "5")
                                echo "$name founds a blessed shoes"

                                        let "bspeed+=5"
                                        echo "$name speed changes to $bspeed"
					sleep 1s
                                        ;;
                        esac
                ;;
	"5")
		echo "$enemy drops a small treasure(Score + 1)"
		sleep 1s
		let "score+=1"
	;;


	"6")
		echo "$enemy drops a treasure(Score + 2)"
		sleep 1s
                let "score+=2"
        ;;

	"7")
		echo "$enemy drops a big treasure(Score + 3)"
		sleep 1s
                let "score+=3"
        ;;
	"8")
	 	echo "$enemy drops a golden key"
		sleep 1s
                let "key+=1"
		;;
	"9")
		echo "$enemy drops a ring"
                sleep 1s
                bonus=$(( $RANDOM % 6 + 1 ))

                case $bonus in
                        "1")
                                echo "$name founds a ring of fool"
				bonus=$(expr $(( RANDOM % 2 + 1 )) - 3  )
                                let "bcrit+=$bonus"
				bonus=$(expr $(( RANDOM % 2 + 1 )) - 3  )
                                let "bblock+=$bonus"
                                bch=$(expr $bblock * 5 )
                                cch=$(expr $bcrit * 5 )

                                        echo "$name crit chance chnges to $(expr $cch + 5 )%" 
                                        echo "$name block chance chnges to $(expr $bch + 5 )%"
					sleep 1s
                                        ;;
                        
                        "2")
                                echo "$name founds a ring of skills"
					bonus=$(( RANDOM % 2 + 1 ))
                                        let "bcrit+=$bonus"
					bonus=$(( RANDOM % 2 + 1 ))
                                        let "bblock+=$bonus"
                                        bch=$(expr $bblock * 5 )
                                        cch=$(expr $bcrit * 5 )

                                        echo "$name crit chance chnges to $(expr $cch + 5 )%" 
                                        echo "$name block chance chnges to $(expr $bch + 5 )%"
					sleep 1s
                                        ;;
			"3")
				echo "$name founds a ring of regeneration"
				if [[ $regen -le 0 ]]
				then
					let "regen+=5"
					echo "$name regenerates $regen% hp on every turn from now"
				else
					bonus=$(expr $(( RANDOM % 5 + 1 )) + 2 )
					let "regen+=$bonus"
					echo "$name raises his regeneration to $regen% hp on every turn"


				fi
				sleep 1s
				;;

			"4")	
				echo "$name founds a ring of the Giagant"

				bhp=$(expr $bhp + 25 )
				hp=$(expr $hp + 25 )
				echo "$name raises his hp pernamently by 25"
				;;

			"5")	
				
					echo "$name founds a ring of the Trickster"
					sleep 1s
					echo "$name stats has been shufled"
					sleep 1s
					bdef=$(expr $(( RANDOM % $bdef )) + 2 )
					batt=$(expr $(( RANDOM % $batk )) + 2 )
					bcrit=$(expr $(( RANDOM % $bcrit )) + 2 )
					bblock=$(expr $(( RANDOM % $bclock )) + 2 )
					bspeed=$(expr $(( RANDOM % $bspeed )) + 2 )

				;;
			"6")

                                        echo "$name founds a ring of the Venomous Viper"
					bonus=$(( RANDOM % 2 + 1 ))
					let "bpoi+=$bonus"

					echo "$name deals $bpoi poison dmg from now"
					

				esac
			;;
	"10")
		 echo "$enemy dropps a healing potion"
		sleep 1s
		heal=$(( $RANDOM % $bhp + 1 ))
		if [[ $heal -lt 25 ]]
		then 
			heal=25
			echo "$name founds a small potion"
			sleep 1s
			if [[ $epoi -gt 0 ]]
			then
			let "epoi-=10"
				if [[ epoi -lt 0 ]]
				then 
					epoi=0
				fi
			fi

		elif [[ $heal -gt 50 ]]
		then
			heal=50
                        echo "$name founds a big potion"
			sleep 1s
			if [[ $epoi -gt 0 ]]
                        then
                        let "epoi-=25"
				if [[ epoi -lt 0 ]]
                                then
                                        epoi=0
                        	fi

                        fi

		else 
			echo "$name founds a normal potion"
			if [[ $epoi -gt 0 ]]
			then
                        let "epoi-=20"
				if [[ epoi -lt 0 ]]
                                then
                                        epoi=0
                                fi

			sleep 1s
			fi
		fi

		hp=$(expr $hp + $heal )
		if [[ $hp -ge $bhp ]]
		then
			hp=$bhp
			echo "$name heals to MAX hp and reduces poison to $epoi"
			sleep 1s
		else
			echo "$name heals $heal hp and reduces poison to $epoi"
			sleep 1s
		fi
                ;;



	esac
	sleep 1s	
}
function cont ()
{
echo "Do you want to fight with a next enemy? (yes/no)"
text=0
read -e text

validator
case "$text" in
	"yes")

        let "fight+=1"
   	mod 
	walka
        echo "Current fight nr $fight"
        echo "Do you want to fight with a next enemy? (yes/no)"
        read -e text
	validator
	cont
	;;
	"no")
	ending
	esac
}
function ending ()
{
        echo "$name Thanks for playing"
        echo "Your record:"
        echo "$win Wins, $loose Losts, $run Runaways"
        echo "No Sword:$ns, No shield:$nsh"
        echo "Hard:$h, Medium:$m, Easy:$e"
        echo "score:$score"
        echo "`date +%d.%m.%y` `date +%H:%M:%S` ${name//[[:space:]]/} $class $fight $score" >> fight_score_board.log
        echo -e "\033[1;5;32mTop 10 playes!!!\033[1;0m"
        awk 'NR==1{print; next} {print | "sort -k 6nr"}' fight_score_board.log | head -n 11 | column -t

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
function gra ()

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
