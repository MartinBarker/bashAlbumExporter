#!/bin/bash

# written by martin barker, 2019
# www.martinbarker.me
# https://github.com/MartinBarker/bashAlbumExporter

shopt -s nullglob

echo "Welcome to martin's audio exporter."
echo "format = $./bashAlbumExporter.sh inputFormat imageFilename fullAlbum removeUpTo_char removeUpTo_offset"
echo "fullAlbum: 0=No, 1=Yes, 2=OnlyFullAlbum"
echo "$ ./bashAlbumExporter.sh mp3 pic.jpg 1 - 1"

#initalze vars
inputFormat=$1
imagePath=$2
fullAlbum=$3
removeUpTo_char=$4
removeUpTo_offset=$5
declare -a filenames=()

render () {
  if [[ "$1" = *mp3 ]]; then
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

# ~ functions ~ #
individualRender () {
  for filename in *.$inputFormat
  do
  	echo "exporting audio file = $filename"
  	render "$inputFormat" "$filename"
  	#add filename to array
  	filenames+=("$filename")
  done
}

fullAlbum () {
  rm concat.txt
  rm concatAudio.mp3
  declare -a filenames=()
  for filename in *.$inputFormat
  do
  	filenames+=("$filename")
  done

  #create concat.txt file with each filename
  for filename in "${filenames[@]}"
	do
		touch concat.txt
		echo "file '$filename'" >> concat.txt
	done

	#concatenate all audio files into one long audio file
	ffmpeg -safe 0 -f concat -i concat.txt -c copy concatAudio.mp3

	#use concatAudio.mp3 to render full album video
  ffmpeg -loop 1 -y -i "$imagePath" -i "concatAudio.mp3" -shortest -acodec copy -vcodec mjpeg -s 1920x1080 "fullAlbum.mp4"

	#delete concat.txt
	#rm concat.txt
	#delete concatAudio.mp3
  #rm concatAudio.mp3
}

# ~ main ~ #

if (( fullAlbum == 0 )); then
  #export individual songs
  echo "Exporting individual songs."
  individualRender

elif (( fullAlbum == 1 )); then
  #export individual songs
  echo "Exporting individual songs."
  individualRender

  #export full album
  echo "Exporting full album."
  fullAlbum

elif (( fullAlbum == 2 )); then
  #export full album
  echo "Exporting full album."
  fullAlbum
fi
