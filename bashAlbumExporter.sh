#!/bin/bash

# written by martin barker, 2019
# www.martinbarker.me
# https://github.com/MartinBarker/bashAlbumExporter

shopt -s nullglob

echo "welcome to martin's audio exporter"
echo "format = $./bashAlbumExporter inputFolderPath/ outputFolderPath/ inputFormat imageFilename fullAlbum"
echo "fullAlbum: 0=No, 1=Yes, 2=OnlyFullAlbum"
#initalze vars
inputFolderPath=$1
outputFolderPath=$2
inputFormat=$3
imagePath=$4
fullAlbum=$5
#initialize empty array
declare -a filenames=()

# ~~ individual songs render logic ~~ #

individualRender () {
	# $1 = $inputFormat
	# $2 = $filename
	# for the given filename, use the optimal ffmpeg command to render it as an mp4 video 
	if [[ "$2" = *mp3 ]]; then
		echo "inputFormat ends with mp3"
		#sanitize filename $2, remove quotes?
		#ffmpeg -loop 1 -y -i "$imagePath" -i "$inputFolderPath/$2" -shortest -acodec copy -vcodec mjpeg -s 1920x1080 "$outputFolderPath/$x.mp4"

	elif [[ "$2" == *flac ]]; then 
		echo "inputFormat ends with flac"

	else 
		echo "inputFormat ends with something unrecognized"
	fi
	
}

#for each file inside outputFolderPath
for filename in *.$inputFormat
do	
	#render the audio file as a video
	echo "exporting audio file = $filename"
	individualRender "$inputFormat" "$filename"
	#add filename to array
	filenames+=("$filename")
done

# ~~ full album render logic ~~ #

renderFullAlbum () {
	#construct long concatenated audi file using list

	# 1) construct fullAlbumCommandFilenames
	fullAlbumCommandFilenames=""
	for filename in "${filenames[@]}"
	do
		temp=" -i "
		temp2="$temp'$filename'"
		fullAlbumCommandFilenames="$fullAlbumCommandFilenames$temp2"
	done
	echo "fullAlbumCommandFilenames = $fullAlbumCommandFilenames"

	# 2) construct fullAlbumCommandNums
	fullAlbumCommandNums=""
	count=0
	for filename in "${filenames[@]}"
	do
		fullAlbumCommandNums="$fullAlbumCommandNums[$count:0]"
		(( count++ ))	
	done
	#echo "final fullAlbumCommandNums = $fullAlbumCommandNums"	

	# 3) construct ffmpeg command to combine all audio into one audio track
	fullAlbumCommandAfterNums="concat=n=$count:v=0:a=1[out]"
	combinedAudioCommand="ffmpeg$fullAlbumCommandFilenames -filter_complex '$fullAlbumCommandNums$fullAlbumCommandAfterNums' -map '[out]' -b:a 320k fullAudio.mp3"
	echo "combinedAudioCommand = $combinedAudioCommand"
	eval "$combinedAudioCommand"

	# 4) render video using that audio track
	#individualRender "$mp3" "$fullAudio.mp3"

}

if (( fullAlbum == 1)) ; then
	echo "exporting full album as one video"
	renderFullAlbum "inputFolderPath" "outputFolderPath" "$inputFormat" "$imagePath"
fi

