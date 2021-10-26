# Volt
[Short description] Volt is a virtual world paradigm built in Unity to help test spatial perception and navigation ability in human participants.

- [Volt](#volt)
  - [Getting Started - Prebuilt](#getting-started---prebuilt)
    - [Prerequisites](#prerequisites)
    - [Running the Experiment](#running-the-experiment)
      - [Setting up the Header](#setting-up-the-header)
      - [Part 1 - Free Roam](#part-1---free-roam)
      - [Part 2 - Practice Study](#part-2---practice-study)
      - [Part 3 - Practice Test](#part-3---practice-test)
      - [Part 4 - Practice Detection Task](#part-4---practice-detection-task)
      - [Part 5 - Detection Task Part 1](#part-5---detection-task-part-1)
      - [Part 6 - Learning](#part-6---learning)
      - [Part 7 - Learning Test](#part-7---learning-test)
      - [Part 8 - Test](#part-8---test)
      - [Part 9 - Detection Task Part 2](#part-9---detection-task-part-2)
  - [Getting Started - Custom Build](#getting-started---custom-build)
    - [Prerequisites](#prerequisites-1)
    - [Getting set up](#getting-set-up)
    - [Configuration File Overview](#configuration-file-overview)
    - [Environment Numbers:](#environment-numbers)
    - [Building](#building)
  - [Authors](#authors)
  - [Notes and Funding](#notes-and-funding)
  - [Acknowledgments](#acknowledgments)

## Getting Started - Prebuilt

These instructions will give you a copy of the project up and running on your local machine using the most up-to-date version of Volt running on a pre-compiled Unity build. If you are interested in making changes to the project before running it, please refer to the [Getting Started - Custom Build](#getting-started---custom-build) instructions below.

### Prerequisites

Requirements for the experiment:
- [MATLAB v2018a](https://www.mathworks.com/products/matlab.html) - Header creation and experiment configuration are all done through MatLab.
- [Python 2.7](https://www.python.org/downloads/release/python-2718/) - Python 2 is used to label data from Unity trials. Python isn't strictly necessary to run the experiment.
- [Psych Toolbox](http://psychtoolbox.org/) - Used to run some of the experiment tasks. 

Though the software is largely built in Unity, to interact with this repository you will only need to use MATLAB, Python, and Psych Toolbox. The Unity build that is in this repository was tested on 13'' Macbook Airs using **MacOS Sierra** (10.12.6) and **El Capitan** (v10.11.6) with a display resolution of 1440x900. 

### Running the Experiment

First off, clone this repository to your local machine and open `MATLAB` to create the header for your experiment. Next, make sure to unzip `Build.zip`. You can leave it in the same directory as the zip file. This contains the Unity build needed to run this experiemnt. 

There is also a copy of the below instructions in this repository as a word document in `documents/volt_experimenter_instructions`. You will also find some other helpful documents such as questionnaires and participant instructions. 

#### Setting up the Header
In `MATLAB`, make sure to change to the directory of where you cloned this repo. For example, 

```
cd ~/Experiments/volt
```

Next, create the subject header with this command: 

```
volt_header
```

You will be prompted to enter in the `Subject #`, `Subject Initials`, and `Subject Gender`. 

Once entered and confirmed, you will have built your subject header. 

#### Part 1 - Free Roam

In the terminal, navigate to the `free_roam` directory. 
```
cd ~/Experiments/volt/free_roam
```

From here, run the following bash script in your terminal: 

```
./free_roam.bash
```

You'll see a popup from Unity asking for the run settings. Ensure that the screen resolution is set to `1024x768` and that the graphics quality is set to `Fantastic`. Next, click `Play!` and the experiment will begin. 

Once the participant is done roaming, hit `Command Q` to close Unity and be sure to hit `Enter` in your terminal. 

> **Note**: If you do not hit `Enter` after closing out of the Unity environment then your participant's data will not be saved!

#### Part 2 - Practice Study

Go to your terminal and move up one step back to the `volt` directory with 
```
cd ..
```
Next, return to MATLAB, ensure that you are in the `volt` folder and create the configuration file for the practice study. 
```
volt_config(header, 1)
```
This will make a prac_study.txt file in your folder, which can then be read by Unity.

Here, `header` is referencing the header you created in the first step, and `1` is the type of trial. In this case - a practice trial.

Once that's done running, run the following command to launch the Unity build: 

```
./volt.bash
```

Validate that your resolution and graphics settings are the same as above and press "Play!" and the free roam will run. After completion, hit `Enter` in the terminal.

#### Part 3 - Practice Test

In `MATLAB`, type: 

```
volt_config(header, 2)
```

Next, run the experiment as before: 

```
./volt.bash
```

After completion, hit `Enter` in the terminal. 

#### Part 4 - Practice Detection Task

In `MATLAB`, type: 

```
volt_practice_disp(header)
```

Once the intro is done, click `5` to begin.

#### Part 5 - Detection Task Part 1

Staying in `MATLAB`, load the first detection task as follows: 

```
volt_disp(header, 1, 1)
```

In this command, the second parameter is either a `1` or a `2` depending on if this is the `pre` or `post` portion of the experiment and the third parameter can be `1` through `4`. For this portion you will start with `1` as the third argument and then once it's done, enter `2` as the third argument. Repeat until you've finished with `4` as the third parameter and then move on to the next session. 

#### Part 6 - Learning

In `MATLAB`, type: 

```
volt_config(header, 3)
```

Next, run the experiment as before: 

```
./volt.bash
```

> **Note**: The participant can pause and restart the learning phase by hitting the “Esc” key.

After completion, hit `Enter` in the terminal. 

#### Part 7 - Learning Test

In `MATLAB`, type: 

```
volt_config(header, 4)
```

Next, run the experiment as before: 

```
./volt.bash
```

After completion, hit `Enter` in the terminal. 

#### Part 8 - Test

In `MATLAB`, type: 

```
volt_config(header, 5)
```

Next, run the experiment as before: 

```
./volt.bash
```

After completion, hit `Enter` in the terminal. 

#### Part 9 - Detection Task Part 2

As in part 5, this detection task will be run four times over. Staying in `MATLAB`, load the first detection task as follows: 

```
volt_disp(header, 2, 1)
```
Press 7 to begin the trial. Once over, run again as `volt_disp(header, 2, 2)` and `3` and `4` as in part 5. 

That is all that's needed to run the experiment!


## Getting Started - Custom Build 

These instructions will give you a copy of the project up and running on your local machine and allow you to make any modifications to the codebase, or environments, that you like. This will allow you to create builds for newer Mac OS versions or Windows versions if you like. If you are only interested in running the experiment with the most recent build, please refer to the [Getting Started - Prebuilt](#getting-started---prebuilt) instructions above.

The original version of volt was built with Unity 5.0.0f4 but this build was updated to allow for improved movement and the version was bumped to 2018.4.36f1 for long-term support and the ability to continue development on Mac computers running Catalina or higher. 

The Unity project itself reads from a configuration file that is generated by MATLAB and runs accordingly. The guide below will describe how to edit the code or environments as well as what the configuration file contains. 

### Prerequisites

Requirements for the software and other tools to build:
- [Unity 3D v2018.4.36f1 LTS](https://unity3d.com/get-unity/download/archive) - This version can be downloaded using the archive or [Unity Hub](https://unity3d.com/get-unity/download). If you have multiple versions of unity installed on your machine, we recommend that you install [Unity Hub](https://unity3d.com/get-unity/download) as well to manage the versions you use.
 <!-- **Note**: If you are using Mac OS Catalina or later (>10.15.x), you should install this version of Unity with the "Unity Editor" not the "Unity Installer" due to the differences in how storage is managed in newer versions of Mac OS. -->

### Getting set up

First, open up the current folder in Unity 2018.4.36f1 either directly from the Unity Editor or through Unity Hub. Next, inside of the `Assets` folder you will find all of the Scenes used in the project. The scene used in the Unity Build is `FinalScene`. 

The scripts can be found in `Assets/Scripts` where `ConfigReader.cs` in `Assets/Scripts/Logic` handles parsing of the configuration file. The scripts themselves are documented and you can modify them as needed. 

### Configuration File Overview
The configuration file is automatically produced by the MATLAB header script and is read by the Unity build to inform the order of trial presentation along with other important characteristics. You can find a review of each line and its purpose below, but the repository also contains a `general.txt` which offers a similar explanation. 

>**Note**: Lines CANNOT have extra whitespace before or after them, so don't put any spaces after a line!

**config.txt**

| Line | Example Value | Type | Description 
|---|---|---|---|
| 1  | 999  | int  | Participant Number  |
| 2  | JA  | string  | Participant Initials  |
| 3  | 10.0  | float  | Collision sphere's radius (meters)|
| 4  | 10.0  | float  | Player's movement speed (virtual meters per second)  |
| 5  | 0  | int  | Defines the Mode. Sets the phase to Learning if it is 0. Sets the phase to Free Roam if it is 1. Sets the phase to Testing if it is 2. | 
| 6  | 60.0  |  float | Phase's time limit (seconds)  |
| 7  | 1.0  | float  | Time in seconds that the initial image is shown |
| 8  | 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 | int | Parsed by 4s. Position 1-4 corresponds to the snow environment; 5-8 to desert; 9-12 to arena; 13-16 to forest; 17-20 to castle; 21-24 to factory; 25-28 to volano. First four and final 8 are static and 5-20 are randomized across participants.  |
| 9  | 4 0 0 0 2 3 4 5 6 0 | int | The order of environments that the participant moves through |
| 10  | 1 1 2 3 0 0 0 0 0 0 | int | Spawn locations corresponding to cardinal values. 0 is North; 1 is East; 2 is South; 3 is West |
| 11  | 1 2 1 3 0 0 0 0 0 0 | int | Object spawn corners. 1 is North West; 2 is North East; 3 is South East; 4 is South West. If the trial is Free Roam, put 0 so that no object is shown. |

>**Note**: The directions on lines 10 and 11 are not relative to the task itself, but merely for clarification in labelling. Here, we'll specify the landmark along the side of the environment which was labelled as 'North'. 

| Northern Landmark | Environment |
|---|---|
| 0 | Snow |
| Rocks | Desert |
| 2 | Arena |
| Flowers | Meadow |
| Trees | Castle |
| 5 | Factory |
| 6 | Volcano |

### Environment Numbers: 

As noted on the `config.txt` Line 9, environments are assigned an integer. The assignment is broken down below.

| Number | Environment |
|---|---|
| 0 | Snow |
| 1 | Desert |
| 2 | Arena |
| 3 | Meadow |
| 4 | Castle |
| 5 | Factory |
| 6 | Volcano |

> **Note**: Free roam always occurred within the practice environment (env 6) but others can be used. Free roam also used 1000 seconds for time instead of 60. Please also note that, in lines 9-11 for free roam, there have to be a minimum of 2 columns.
Also, in Sherrill et al., Desert, Arena, Meadow, and Castle were used in the task while Volcano was used for free roam and practice. 


### Building

After you've completed the modification to the code and/or environments that you wanted, you can now open Build Settings in the Unity Editor by going to `File > Build Settings`. From the menu that opens, make sure that `FinalScene` or the Scene that you want in your build is selected. If nothing is selected in `Scenes in Build`, double click on the Scene you want in the Unity Editor and make sure that it is open in your `Hierarchy`. Now click back to the `Build Settings` window and click `Add Open Scenes`. From here, ensure that you have selected your preferred target platform and hit `Build`. You will be prompted to choose a directory at which point you can choose the current directory. You can either replace the `Build.app` in the current directory with your new `Build.app` or archive the old one. 

> **Note**: Naming your new build `Build.app` is important as the `volt.bash` script uses this name to run the experiment. You are welcome to change the script if you prefer to use a different name. 

From here you should be all set to run your new experiment! From here, revisit the [Running the Experiment](#running-the-experiment) instructions above, if applicable.  

<!-- ## Versions

There are currently two versions of Volt available for use. The first is located on the master branch and is the original version used for participant testing. This is where the main build and additional scripts are located. The second version is on a branch called `simple-movement` and it contains an updated version of the movement ability, giving participants smoother movement controls making it easier to navigate through the environment. -->

<!-- ## Related Projects
Volt contains the boilerplate code used in a number of experiments and this repository acts as the main codebase for altering and contributing to Unity code. This section provides a short overview of the other related repositories, should you be interested in checking them out. 

  - **Glutton** - [GitHub]() - This experiment test generalization ability in human participants. 
  - **Voltage** - [GitHub]() -->

## Authors
Roles and affiliations of authors at the time of data collection.
  - **Katherine R. Sherrill<sup>1,4</sup>** - *Post Doctoral Research Fellow* - [GitHub](https://github.com/orgs/prestonlab/people/ksherrill)
  - **Robert J. Molitor<sup>1</sup>** - *PhD Candidate* - [CV](https://minio.la.utexas.edu/colaweb-prod/person_files/0/6323/robert_molitor_curriculum_vitae.pdf)
  - **Ata B. Karagoz<sup>1</sup>** - *Undergraduate Research Assistant* - [GitHub](https://github.com/orgs/prestonlab/people/atakaragoz)
  - **Manasa Atyam<sup>1</sup>** - *Undergraduate Research Assistant* - [GitHub](https://github.com/orgs/prestonlab/people/manasa-atyam)
  - **Michael L. Mack<sup>3</sup>** - *Post Doctoral Research Fellow* - [Mack Lab](http://macklab.utoronto.ca/)
  - **Alison R. Preston<sup>1,2,4</sup>** - *Principle Investigator* - [Preston Lab](https://clm.utexas.edu/preston/)

1. Center for Learning and Memory, University of Texas at Austin, Austin, TX 78712, USA
2. Department of Psychology, University of Texas at Austin, Austin, TX 78712, USA
3. Department of Psychology, University of Toronto, Toronto, ON M5G 1E6, Canada
4. Department of Neuroscience, University of Texas at Austin, Austin, TX 78712, USA

## Notes and Funding

This research was supported by the National Institute of Mental Health (R01 MH100121-01 to A.R.P.) and the National Institute of Neurological Disorders and Stroke (National Research Service Award F32 NS098808 to K.R.S.) of the National Institutes of Health.

This software is not sponsored by or affiliated with Unity Technologies or its affiliates. Unity Trademarks are trademarks or registered trademarks of Unity Technologies or its affiliates in the U.S. and elsewhere.

## Acknowledgments

Thanks to Neal Morton, Hannah Roome, Athula Pudhiyidath, Christine Coughlin, and Nicole Varga for valuable discussions.
