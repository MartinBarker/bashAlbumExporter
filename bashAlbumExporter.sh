#!/bin/bash

# written by martin barker, 2019
# www.martinbarker.me
# https://github.com/MartinBarker/bashAlbumExporter

shopt -s nullglob

echo "welcome to martin's audio exporter"
echo "format = $./bashAlbumExporter.sh inputFormat imageFilename fullAlbum removeUpTo_char removeUpTo_offset"
echo "fullAlbum: 0=No, 1=Yes, 2=OnlyFullAlbum"
echo "$ ./bashAlbumExporter.sh mp3 pic.jpg 1 - 1"
#initalze vars
inputFormat=$1
imagePath=$2
fullAlbum=$3
removeUpTo_char=$4
removeUpTo_offset=$5

#initialize empty array
declare -a filenames=()

# ~~ individual songs render logic ~~ #

individualRender () {
	# $1 = $inputFormat
	# $2 = $filename
	# for the given filename, use the optimal ffmpeg command to render it as an mp4 video
	if [[ "$1" = *mp3 ]]; then
		echo "inputFormat ends with mp3"
		outputFilename=$2
		if [[ "$removeUpTo_char" != "." ]]; then
			#remove all text after and including period from filename
			outputFilename="${2%.*}"
			outputFilename="${outputFilename#*$removeUpTo_char}"
		fi
		outputFilename="${outputFilename:$removeUpTo_offset}"
		ffmpeg -loop 1 -y -i "$imagePath" -i "$2" -shortest -acodec copy -vcodec mjpeg -s 1920x1080 "$outputFilename.mp4"

	elif [[ "$1" == *flac ]]; then
		echo "inputFormat ends with flac"

	else
		echo "inputFormat ends with something unrecognized"
	fi

}

#for each file inside inputFolderPath
pwd ls
for filename in *.$inputFormat
do
	#render the audio file as a video

	echo "exporting audio file = $filename"
	#get index of last period in filename

	#remove inputFolderPath from filename
	individualRender "$inputFormat" "$filename"
	#add filename to array
	filenames+=("$filename")
done

# ~~ full album render logic ~~ #

renderFullAlbum_old () {
	#construct long concatenated audio file using list

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

renderFullAlbum () {
	#create concat.txt file with each filename
	for filename in "${filenames[@]}"
	do
		touch concat.txt
		echo "file '$filename'" >> concat.txt
	done

	#concatenate all audio files into one long audio file
	ffmpeg -safe 0 -f concat -i concat.txt -c copy concat.mp3

	#use concatAudio.mp3 to render full album video
  individualRender "mp3" "concat.mp3"

	#delete concat.txt
	#rm concat.txt
	#delete concatAudio.mp3
}

if (( fullAlbum == 1)) ; then
	echo "exporting full album as one video"
	#renderFullAlbum_old "$inputFormat" "$imagePath"
	renderFullAlbum "$inputFormat" "$imagePath"
fi
