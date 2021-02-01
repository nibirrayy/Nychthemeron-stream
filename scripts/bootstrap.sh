 #! /bin/bash
    
VBR="1500k"
FPS="30"
QUAL="ultrafast"
YOUTUBE_URL=" rtmp://a.rtmp.youtube.com/live2"
YOUTUBE_KEY="k9uf-kpr7-6ezu-p439-2ydh"
VIDEO_SOURCE="output.mp4"
AUDIO_ENCODER="aac"
AUDIO_FS="44100"
AUDIO_BPS="128k"

#while true
#do
        ffmpeg \
         -stream_loop -1 \
         -re \
	 -filter_complex movie=/root/LiveStreamRadio/media/$VIDEO_SOURCE:loop=0,setpts=N/FRAME_RATE/TB \
         -i "$VIDEO_SOURCE" \
         -thread_queue_size 512 \
         -stream_loop -1 \
         -re \
         -f concat -safe 0 -i audio.txt \
         -c:v libx264 -preset $QUAL -r $FPS -g $(($FPS *2)) -b:v $VBR -bufsize 3000k -maxrate $VBR \
         -c:a $AUDIO_ENCODER -ar $AUDIO_FS -b:a $AUDIO_BPS -pix_fmt yuv420p \
         -f flv -flvflags no_duration_filesize $YOUTUBE_URL/$YOUTUBE_KEY

#done



