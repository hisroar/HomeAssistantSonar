# Sonar for your Home Assistant

The report can be found [here][DocLink].

This project was done by Seraphine Goh and Dennis Shim in Spring 2019 for EE209AS: Security and Privacy for Cyber-Physical Systems, and Internet-of-Things at UCLA. 

## Data

Data can be found at [this link][DataLink].

Below is a table describing the data.

| Data Directory  | Frequency of sound | Description |
| ---------------- | ----------- | - |
| `trials_no_subject_1` | 1 kHz | No subject present, 50 trials in 1 furniture configuration |
| `trials_no_subject_2` | 1 kHz | No subject present, 100 trials in 4 furniture configurations |
| `trials_no_subject_3` | 1 kHz | No subject present, 105 trials in 47 furniture configurations |
| `trials_no_subject_4` | 1 kHz | No subject present, 100 trials in 1 furniture configuration |
| `trials_no_subject_5` | 1 kHz | No subject present, 100 trials in 1 furniture configuration |
| `trials_front_1` | 1 kHz | Subject in front, 100 trials sitting and standing in 1 furniture configuration |
| `trials_front_2` | 1 kHz | Subject in front, 100 trials sitting in multiple configurations in 1 furniture configuration |
| `trials_front_3` | 1 kHz | Subject in front, 200 trials in front, sitting on couch (1-60) and standing (61-200) (moving around as well). 4 different furniture configurations |
| `trials_behind` | 1 kHz | Subject behind, 100 trials of standing, 2 different furniture configurations (50 each) |
| `trials_right` | 1 kHz | Subject right, 200 trials of sitting (15 * (2 furniture configurations) * (3 seating arrangements) and standing (5 furniture configurations) |
| `trials_left` | 1 kHz | Subject left, 200 trials of sitting (15 * (2 furniture configurations) * (3 seating arrangements) and standing (5 furniture configurations) |
| `20kHz_trials_no_subject` | 20 kHz | No subject, 210 trials of 14 furniture configurations |
| `20kHz_trials_front` | 20 kHz | Subject in front, 200 trials of sitting/standing and multiple furniture configurations |
| `100Hz_trials_no_subject` | 100 Hz | No subject, 200 trials of >10 furniture configurations |
| `100Hz_trials_front` | 100 Hz | Subject in front, 200 trials of sitting/standing and multiple furniture configurations |
| `trials_moving_ccw` | 1 kHz | Subject walking around microphone/speaker setup counterclockwise at different speeds, different paths, and different start/stop points |
| `trials_moving_cw` | 1 kHz | Subject walking around microphone/speaker setup clockwise at different speeds, different paths, and different start/stop points |

## Usage

### Data Recording

Edit `play_record.sh` to change the number of consecutive trials to record, and which directory to save them in.

Edit `play_sound.sh` to change which audio file to play before recording.

```bash
$ git clone https://github.com/hisroar/HomeAssistantSonar.git
$ cd HomeAssistantSonar
$ ./play_record.sh
```

### Feature extraction and classfication

Below is a list of Matlab files and what they do. It is recommended to run them in the order provided below. Data (trial folders) need to be in the same directory as all the Matlab files.

Code is commented for ease of re-use.

| Matlab file      | Description |
| ---------------- | ----------- |
| `FolderSetupCleanup.m`	| Cleans up previous `FeatureExtract/` directory and creates new one. Only needs to be run once unless data is changed. |
| `GenerateMLData.m`	| Reads `.wav` files and outputs all feature data to `.csv` files. Only needs to be run once unless data is changed. |
| `GenerateFeatureMatrix.m` | Reads data from `.csv` files and creates data matrix for Matlab to read. Only needs to be run once unless data is changed or different pruned data is desired. |
| `MLEval.m`	| Reads in feature matrix and labels and runs various ML classifiers on the data. Outputs accuracies to `ML_Accuracy.txt`. |
| `MLCostTest.m` | Test impact of cost matrix on various classifiers. |
| `PCA.m` | Test principle component analysis on various classifiers. |
| `FeatureExtract.m` | Function used by `GenerateMLData.m` to process `.wav` files. |
| `FeatureSelect.m` | Function used to run Relief-F algorithm for feature matrix. |

License
----

MIT

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [DocLink]: <https://docs.google.com/document/d/1ql-SRxD6op0Ms6GhebDBstio8vFzg7y52C76V5Cwb6s/edit?usp=sharing>
   [DataLink]: <https://drive.google.com/open?id=13PZlo9e6vIQKrinCk0Tvx3Ue88nbVBSW>