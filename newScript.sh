#!/bin/bash
# written by martin barker, 2019
# www.martinbarker.me
# https://github.com/MartinBarker/bashAlbumExporter
shopt -s nullglob

echo "Welcome to Martin's audio exporter."
echo "format = $./script.sh filePath audioFileFormat imageFilename fullAlbumOption"
filePath=$1
audioFileFormat=$2
imageFilename=$3
fullAlbumOption=$4
# ~ functions ~ #
# ~ main ~ #
if (( fullAlbumOption == 0 )); then
  #export individual songs
  #individualRender
  echo "Welcome to Martin's audio exporter."

elif (( fullAlbumOption == 1 )); then
  #export individual songs
  #individualRender
  echo "Welcome to Martin's audio exporter."

  #export full album
  #fullAlbum

elif (( fullAlbumOption == 2 )); then
  #export only full album
  #fullAlbum
  echo "Welcome to Martin's audio exporter."
fi
