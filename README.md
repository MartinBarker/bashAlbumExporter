# bashAlbumExporter
Place this script inside a folder with audio files and an image to export video files for each song. This script uses ffmpeg to export the videos, and uses command line arguments to specify background image, file type, output filename format, and whether or not to render a full album video. Run this script on linux / MACOSX / bash terminals.

Example:
```
$./bashAlbumExporter.sh mp3 pic.jpg 1 . 1
```
# script command line format:
```
$./bashAlbumExporter.sh audioFileType imageFilename fullAlbumOptionInt outputFilenameRemoveUpTo_char outputFilenameRemove_offset
```
# command line argument meanings:
- audioFileType = File type of the audio files you want to export (mp3, flac, wav, etc).
- imageFilename = Name of the image file located in the same folder as this script to use as background for the video.
- fullAlbumOptionInt = Choice on rendering full album video, 0 = No, 1 = Yes, 2 = Only render full album.
- outputFilenameRemoveUpTo_char = Remove text up to the first instance of this char. If char is a period . this step will be skipped.
- outputFilenameRemove_offset = Remove this number of chars from the start of the filename for the output video filename.
Example: If song filename = '01 - Song name.mp3', inputting '-' as the outputFilenameRemoveUpTo_char will remove the text up that char for the output video filename: ' Song name.mp3'  
Example: If song filename = 'xSong name.mp3', inputting '1' as the outputFilenameRemove_offset will remove that number of chars from the beginning of the filename for the output filename: 'Song name.mp3'
```
# filenames formatted as '01 - firstSong.mp3', '02 - secondSong.mp3', etc
$./bashAlbumExporter.sh mp3 pic.jpg 1 - 1

# audioFileType = mp3
# imageFilename = pic.img
# outputFilenameRemoveUpTo_char = -
# outputFilenameRemove_offset = 1

# output filenames will be formatted as 'secondSong.mp4'

```

# How to use:
1. Download the bashAlbumExporter.sh file and place it in the folder with your audio files / image
2. Run this command to give the script permissions
```
$ chmod 0755 bashAlbumExporter.sh
```
3. Run the script with this command
```
$./bashAlbumExporter.sh mp3 pic.jpg 1 . 1
```
