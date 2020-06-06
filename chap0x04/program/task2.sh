function age_1 {
	Age20=0
	Age20_30=0
	Age30=0
	i=0
	for i in "${age[@]}";do
		if [[ $i -lt 20 ]]
		then
			((Age20++))
		elif [[ $i -le 30 ]]
		then
			((Age20_30++))
		elif [[ $i -gt 30 ]]
		then
			((Age30++))
		fi
	done
	printf "under 20:%-3d,persent:%-5.2f%% \n" $Age20 $(echo "scale=10;$Age20/$count*100" |bc -l)
	printf "20 to 30:%-3d,present:%-5.2f%% \n" $Age20_30 $(echo "scale=10;$Age20_30/$count*100" |bc -l)
	printf "older than 30:%-3d,persent:%-5.2%% \n" $Age30 $(echo "scale=10;$Age30/$count*100" |bc -l)
}

function age_2{
	age_old=0
	age_yang=100
	i=0
	while [[ i -lt $count ]]
	do
		agenum=age[$i]
		if [[agenum -lt $age_yang ]];then
			age_yang=$agenum
			ynum=$i
		elif [[ agenum -gt $age_old ]];then
			age_old=$agenum
			onum=$i
		fi
		((i++))
	done
	echo "Oldest ${player[onum]//\*/} ${age[ynum]}"
	echo "youngest ${player[ynum]//\*/ } ${age[ynum]}"
}

function name{
	i=0
	name_Long=0
	name_short=100
	while [[ i -lt $count ]]
	do
		name=${player[$i]//\*/}
		str=${#name}
		if [[ str -gt $name_Long ]];then
			name_Long=$str
			lnum=$i
		elif [[ str -lt $name_short ]];then
			name_short=$str
			snum=$i
		fi
		((i++))
	done
	echo "Longest name ${player[lnum]//\*/ }"
	echo "shortest name ${player[snum]//\*/}"

}
function position {
	array=($(awk -vRS=' ' '!a[$1]' <<< "${position[@]}"))
	declare -A member
	i=0
	for((i=0;i<${#array[@]};i++)){
		num=${array[$i]}
		member["num"]=0
	}
	for a in "${position[@]}";do
	case $a in
		${array[0]})
			((member["${array[0]}"]++));;
		${array[1]})
			((member["${array[1]}"]++));;
		${array[2]})
			((member["${array[2]}"]++));;
		${array[3]})
			((member["${array[3]}"]++));;
		${array[4]})
			((member["${array[4]}"]++));;
		esac
	done
	for((i=0;i<${#array[$i]};i++))
	{
		a=${member[${array[$i]}]}
		printf "%-10s :%10d %10.2f %% \n" ${array[$i]} $a $(echo "scale=10;$a/$count*100" | bc -l )
	}
}
count=0
while read line
do
	((count++))
	if [[ $count -gt 1 ]];then
		str=(${line// /*})
		position[$(($count-2))]=${str[4]}
		age[$(($count-2))]=${str[5]}
		player[$(($count-2))]=${str[8]}
	fi
done < worldcupplayerinfo.tsv
count=$(($count-1))
age_1
echo "**************************************"
position
echo "**************************************"
name
echo "**************************************"
age_2