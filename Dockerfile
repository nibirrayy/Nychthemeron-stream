FROM ubuntu
LABEL maintainer="nibirrayy@gmail.com"

#Getting the required packages
RUN apt-get update
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install tzdata
RUN apt-get install -y python3 python3-pip ffmpeg git

#Getting Youtube-dl
RUN pip3 install youtube_dl

#Getting Pylivestream
RUN pip3 install PyLivestream

#Configuring Pylivestream
COPY pylivestream.ini /home/pylivestream.ini
COPY $PWD/platform.key /home/platform.key

#Playlist-sync service
RUN cd /home ; mkdir music
RUN git clone https://github.com/nibirrayy/youtube-playlist-sync.git /home/youtube-playlist-sync
RUN python3 /home/youtube-playlist-sync/yps.py --init https://www.youtube.com/playlist?list=PL-C53MG1DMX0XLbgXJBC7rJu957aV4BAx --dir /home/music

#Configuring cron jobs
RUN apt-get install -y cron
COPY musicSync-cron /etc/cron.d/musicSync-cron
RUN chmod 0744 /etc/cron.d/musicSync-cron
RUN crontab /etc/cron.d/musicSync-cron
