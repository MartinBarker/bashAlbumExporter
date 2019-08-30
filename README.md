# bashAlbumExporter
This bash script uses ffmpeg to turn audio files (mp3 / flac) and an image into mp4 videos you can upload to YouTube. 
```
 ./bashAlbumExporter.sh media/ mp3 front.jpg 1 . 1   
```

# How to use:
1. Download the bashAlbumExporter.sh file
2. Run this command to give the script permissions
```
$ chmod 0755 bashAlbumExporter.sh
```
3. Run the script with this command
```
$ ./bashAlbumExporter.sh media/ mp3 front.jpg 1 . 1
```

# script command line format:
```
$./bashAlbumExporter.sh inputFolderPath audioInputFormat imageFilename fullAlbumOptionInt removeUpTo_char removeUpTo_offset
```
# required command line arguments:
- inputFolderPath = filepath to inputFolder from where your script is placed.
- audioInputFormat = File type of the audio files you want to export (mp3, flac).
- imageFilename = Name of the image file located in the inputFolderPath to use as background for the video.
- fullAlbumOptionInt = Choice on rendering full album video, 0 = No, 1 = Yes, 2 = Only render full album.

# optional command line arguments for setting video output filename:
- removeUpTo_char = Remove text up to the first instance of this char.
- removeUpTo_offset = Remove this number of chars from the start of the filename.

Example: 
If song filenames are formatted like = '01 - Song name.mp3', '02 - Martin Song.mp3',use the last two command line parameters to remove the leading '## - ' from the start of each filename for the output video filename:
```
Input files in media/ folder:
01 - Song name.mp3
02 - Martin's Song.mp3
front.jpg

$ ./bashAlbumExporter.sh media/ mp3 front.jpg 1 - 1
```
inputFolderPath = media/

audioInputFormat = mp3

imageFilename = front.jpg

fullAlbumOptionInt = 1

removeUpTo_char = -

removeUpTo_offset = 1

```
Output video files:
Song name.mp4
Martin's Song.mp4
fullAlbum.mp4
```
