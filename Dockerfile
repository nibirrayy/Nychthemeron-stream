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
COPY $PWD/pylivestream.ini $HOME/pylivestream.ini
COPY $PWD/platfrom.key $HOME/platfrom.key

#Playlist-sync service
RUN mkdir $HOME/music
RUN git clone https://github.com/nibirrayy/youtube-playlist-sync.git
RUN python3 $HOME/youtube-playlist-sync/yps.py --init $PLAYLIST --dir music

#Configuring cron jobs
RUN apt get install -y cron
COPY musicSync-cron /etc/cron.d/musicSync-cron
RUN chmod 0744 /etc/cron.d/musicSync-cron
RUN crontab /etc/cron.d/hmusicSync-cron
