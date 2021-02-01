FROM ubuntu
LABEL maintainer="nibirrayy@gmail.com"

#Getting the required packages
RUN apt-get update
ENV TZ=Asia/Kolkata
# Timezone is required for scheduling jobs at a specific time

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install tzdata
RUN apt-get install -y python3 python3-pip ffmpeg git

# SET THE PLAYLIST URL HERE
ENV PLAYLIST=https://open.spotify.com/playlist/0LSy1u99B4TlWV148zumiu?si=nqxHe7ptRxSiuOSGm7eBLg 

# MAYBE WE CAN MOVE ALL installation of software to one directory

#Getting Youtube-dl
RUN pip3 install youtube_dl

#Getting Pylivestream
RUN pip3 install PyLivestream

#Getting spotDL
RUN pip3 install spotdl

#getting packages for jobs and scheduling
RUN pip3 install schedule

#Configuring Pylivestream
COPY pylivestream.ini /home/pylivestream.ini
COPY $PWD/youtube.key /home/youtube.key
# rename platform key to the repective key you want to stream on


## Maybe it will be better to move it to the cloud and curl or wget it


#Initial playlist pull

RUN cd /home && mkdir music
WORKDIR /home/music
RUN spotdl $PLAYLIST

#---------------------------------------------
#Depreciated music sync service
#
#RUN git clone https://github.com/nibirrayy/youtube-playlist-sync.git /home/youtube-playlist-sync
#RUN python3 /home/youtube-playlist-sync/yps.py --init https://www.youtube.com/playlist?list=PL-C53MG1DMX0XLbgXJBC7rJu957aV4BAx --dir /home/music

#Configuring cron jobs for playlist sync service
#RUN apt-get install -y cron
#COPY musicSync-cron /etc/cron.d/musicSync-cron
#RUN chmod 0744 /etc/cron.d/musicSync-cron
#RUN crontab /etc/cron.d/musicSync-cron

#---------------------------------------------

COPY run.py /home

# Just a workaround for the time being
COPY youtube.key /root

# USE AN ENTRY POINT TO START STREAMING 
# use a python script that keeps running in the background with a scheduler
CMD  python3 /home/run.py
