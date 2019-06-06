#!/bin/bash
TRIAL="trials/"
N_TRIALS=10

mkdir -p ${TRIAL}

TRIAL_START=`exec ls ${TRIAL} | sed 's/\([0-9]\+\).*/\1/g' | sort -n | tail -1`+1

for ((j=$TRIAL_START; j<=$N_TRIALS+$TRIAL_START-1; j++))
do
    echo "TRIAL ${j}"
    ./play_sound.sh
    ~/workspace/MatrixCreatorAudioRecorder/build/microphone_array/mic_record_file
    ~/workspace/MatrixCreatorAudioRecorder/build/microphone_array/convert_raw_to_wav

    mkdir "$TRIAL${j}"

    for i in {0..8}
    do
	
        mv "mic_16000_s16le_channel_${i}.raw" "$TRIAL${j}"
        mv "output${i}.wav" "$TRIAL${j}"
    done
done

