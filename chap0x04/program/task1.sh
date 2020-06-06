function compress {
	quality=$1
	for img in `ls $dir`
	do
		extension=${img##*.}
		if [ $extension == "jpg" ];then
			echo $img;
			out=$dir/compress_$file
			convert -quality $quality"%" $img $out
		fi
	done
}

function ADDmark{
	text=$1
	for img in `ls $dir`
	do
		extension=${img##*.}
		if [$extension == "jpg" ];then
			echo $img
			out=$dir/draw_${img%.*}.${img##*.}
			convert -draw "text 25,40 '$text'" $img $out
		fi
	done

}

function resolution{
	size=$1
	for img in `ls $dir`
	do
		extension=${img##*.}
		if [ $extension == "jpg" ] || [ $extension == "png" ];then
			out=$dir/resize_$img
			echo $img
			convert -sample $size"%x"$size"%" $img $out
		fi
	done
}

function rename {
	new_name=$1
	for file in `ls $dir`
	do
		extension=${file##*.}
		if [ $extension == "jpg" ] || [$extension == "png"];then
			echo $file
			out=$dir/new_name.${file##*.}
			echo $out;
			convert $file $out
		fi
	done
}

function transform {
	for file in `ls $dir`
	do
		extension=${file##*.}
		if [ $extension == "png" ];then
			out=$dir/type_${file%.*}.jpeg
			echo $out;
			convert $file $out
		fi
	done
}

function help {
	echo "-c	compress"
	echo "-h	help"
	echo "-t	transform to jpeg"
	echo "-a	add watermark"
	echo "-n	rename"
	echo "-r	resolution compress"
}

while [[ "$#" -ne 0 ]]; do
	case $1 in
		"-c") compress $2
			shift 2;;
		"-r") resolution $2
			shift 2;;
		"-h") help
			shift;;
		"-a") ADDmark $2 $3 $4
			shift 4;;
		"-t") transform
			shift;;
		"-n") rename $2
			shift 2;;
	esac
done