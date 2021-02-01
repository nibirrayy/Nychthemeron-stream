import os
import glob

workdir = "/root/LiveStreamRadio/media/music/Thoughtful_lofi/" # enter directory where the music files are. Enter full directory path

if (workdir==""):
    workdir = os.getcwd() # using the current working dirctory as workdir id no value is passed by default 

files_list = glob.glob(f"{workdir}*.mp3")

with open('audio.txt','a') as write_file:
    
    for files in files_list:
        
       write_string = files.replace("'","'\\''")
       write_string = f"file '{write_string}'\n"
       write_file.write(write_string)
