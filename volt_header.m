% This script generates the header file 'header' in the  workspace;
% the 'header' variable is used when calling each run.
%
% Subexperiments are functions that take the header (and optionally, run
% number) as inputs and return data structures
%
% Each subexperiment can run independently and generates its own output
%
% The plan is to run the following:
% 
% Day 1 
% volt_header 
% volt_free_roam
% volt_practice_learning
% volt_practice_test
% volt_practice_disp
% volt_disp1, runs 1-4 -- SCANNED
% volt_learning, runs 1-3
% volt_test
% volt_disp2, runs 1-4 -- SCANNED

% Day 2 
% load header from day1
% volt_practice_rep_supp
% volt_rep_supp, runs 1-3 -- SCANNED 
% volt_disp3, runs 1-4 -- SCANNED
% volt_localizer, runs 1-3 -- SCANNED
%
% Must be called from sim experiment folder to work
%
% Version 7, April 14, 2016, includes disp, config (learning 6 reps),
% rep_supp (control included), localizer 

% Version 9, August 22, 2016, # env reduced to 4 to increase RSA power, pre/post # reps per run increased from 2 to 4, 
% pre/post stim time increased from 0.3 secs to 1 sec and ISI decreased from 3.7 secs to 3 secs, 
% # env reps per run increased from 3 to 4, *** final version?

% there are 4, 5 minute 20 sec runs for the pre/post displays
% there are 3, 9 minute 24 sec runs for the repetition suppression task
% there are 3, 8 minute runs for the localizer task

% August 2012: Written by Meg Schlichting and Whitney Woodington as alice_header
% September 2012: Modified by Meg Schlichting
% October 2012: Modified by Meg Schlichting
%     - combines every 2 scanned runs to make fewer, longer runs
% April 2015: Modified by Kate Sherrill

% Dependencies:
%   PsychToolbox

clear;
par = struct;
expName = 'volt'; % virtual object learning task 

%% parameters (general) to adjust

% parameters for initial extra time and initial baseline, set to match
% total scanning time
par.initTime = 0; % extra time for scanner equlibrium
par.bookendFixTime = 4; % init & final baseline time


%% set-up

header = struct('exp',expName,'version','v9, August 22, 2016','parameters',struct);
header.path.exp = pwd; %the path is the current folder
header.path.data = [header.path.exp '/data/']; % for output
header.path.stim = [header.path.exp '/stimuli/'];

header.path.practicedata = [header.path.exp '/prac_data/']; % for practice
%header.path.practicestim = [header.path.exp '/prac_repsupp_stimuli/']; % for rep_supp practice stimuli
header.path.localizer = [header.path.exp '/localizer_stimuli/']; % for localizer

% check to see if the data path exists. if not make a directory
if ~exist(header.path.data, 'dir')
    mkdir(header.path.data);
end
    
disp(sprintf('This script generates header file for the %s experiment.',expName));
disp('---------------');
header.subNr = input('Participant Number:  ');
header.subInit = input('Participant Initials:  ', 's');
header.gender = input('Is this participant male (1) or female (2)?  ');

disp('');
disp('---------------');
disp(''); disp('');
disp('Please make sure this information is correct.');
disp('---------------');
disp(['Participant Number = ', num2str(header.subNr) ]);
disp([ 'Participant Initials = ',header.subInit]);
if header.gender == 1
    disp('This participant is male.');
else
    disp('This participant is female.');
end
disp('---------------');
disp(''); disp('');
yn = input('Is this correct?  (y,n):  ', 's'); % possibly put in loop
if(~isequal(upper(yn(1)), 'Y'))
    return;
end

clear yn

% make participant folder
header.path.subNr = [header.path.data sprintf('%d_%s', header.subNr, header.subInit)]; 
header.path.practicedata_subNr = [header.path.practicedata sprintf('/%d_%s', header.subNr, header.subInit)];

% for header and displays
if exist(header.path.subNr)~=0; % check whether a directory with that name exists already
    disp('Warning!!! File for this participant already exists! Aborting...');
    clear all; return;  % abort experiment, rather than overwrite existing data
end

mkdir(sprintf('%s/%d_%s',header.path.data, header.subNr, header.subInit));

% for practice display
if exist(header.path.practicedata_subNr)~=0; % check whether a directory with that name exists already
    disp('Warning!!! File for this participant already exists! Aborting...');
    clear all; return;  % abort experiment, rather than overwrite existing data
end

mkdir(sprintf('%s/%d_%s',header.path.practicedata, header.subNr, header.subInit));

%% parameters for each experiment component

header.setupTime = fix(clock);

% general parameters
par.nEnvTraining = 4; % for the 4 environments
par.nObjPerEnv = 4; % 4 objects in each environment
par.ngroups = 2; % number of groups for rep_supp (either starts with a random or env triplet)

% select counterbalancing group
header.group = mod(header.subNr,par.ngroups);
if header.group == 0, header.group = par.ngroups; end

%%%%%%%%%%

% display
% par.disp.nRepsPerRun = 2;
par.disp.nRepsPerRun = 4;
par.disp.nRuns = 4;
par.disp.nTotalReps = (par.disp.nRepsPerRun * par.disp.nRuns);
par.disp.stimTime = 1;
par.disp.fixTime = 3;
par.disp.trialTime = (par.disp.stimTime + par.disp.fixTime);
par.disp.nStimPerRun = (par.nEnvTraining * par.nObjPerEnv * par.disp.nRepsPerRun);
par.disp.nNullTrials = (par.disp.nStimPerRun / 4); % null trials are the same length as regular trials, randomly intermixed; quarter of total trials
par.disp.nTotalTrials = (par.disp.nStimPerRun + par.disp.nNullTrials);

% train - for config.txt
par.train.subNr = header.subNr;
par.train.subInit = header.subInit;
par.train.successRadius = 8.0;
par.train.movementSpeed = 10.0;
par.train.studyTime = 60.0;
par.train.testTime = 20.0;
par.train.objDisplayTimePrac = 2.0;
par.train.objDisplayTime = 1.0;
par.train.nRuns = 3;
par.train.nObjRepsPerRun = 2;

% free roam - for config.txt
par.freeroam.successRadius = 0.0;
par.freeroam.successRadius = 0.0;
par.freeroam.movementSpeed = 10.0;
par.freeroam.freeTime = 1000.0;
par.freeroam.objDisplayTime = 0.0;

%%%%%%%%%%%%

% practice disp is a "mini-run", 1 rep of each real stimulus
% expose participants to stimuli before they enter scanner

% practice display parameters
par.practice.disp.nStim = (par.nEnvTraining * par.nObjPerEnv); % 24 objects included
par.practice.disp.nNullTrials = par.nEnvTraining;
par.practice.disp.nTotalTrials = (par.practice.disp.nStim + par.practice.disp.nNullTrials);

%%%%%%%%%%%%

% repetition suppression
par.rep_supp.nRuns = 3;
par.rep_supp.nTripletTypes = 3; % environment (repetition condition), random or control triplets
par.rep_supp.nEnvRepsPerRun = 4; % each env has 4 triplet reps per run
par.rep_supp.nEnvReps = (par.rep_supp.nRuns * par.rep_supp.nEnvRepsPerRun); % total env reps; here 12
par.rep_supp.nEnvTriplets = (par.nEnvTraining * par.rep_supp.nEnvReps); % 48 env triplets 
par.rep_supp.nEnvTripletsPerRun = par.rep_supp.nEnvTriplets/par.rep_supp.nRuns; % 16 env triplets per run
par.rep_supp.nRandTriplets = (par.nEnvTraining * par.rep_supp.nEnvReps); % 48 rand triplets total
par.rep_supp.nControlTripletsPerRun = 8;
par.rep_supp.nControlTriplets = (par.rep_supp.nControlTripletsPerRun * par.rep_supp.nRuns); % 24 control triplets total
par.rep_supp.nEnvControlTripletsPerRun = par.rep_supp.nEnvTripletsPerRun + par.rep_supp.nControlTripletsPerRun; % 16 env + 8 control triplets per run
par.rep_supp.nTotalTriplets = (par.rep_supp.nEnvTriplets + par.rep_supp.nRandTriplets + par.rep_supp.nControlTriplets); % 120 total triplets
par.rep_supp.nTripletsPerRun = (par.rep_supp.nTotalTriplets / par.rep_supp.nRuns); % 40 triplets per run; 16 env, 16 rand, 8 control
par.rep_supp.nStimPerTriplet = 3;
par.rep_supp.nStimPerRun = (par.rep_supp.nStimPerTriplet * par.rep_supp.nTripletsPerRun); % 120 stimuli per run
par.rep_supp.nTotalTrials = (par.rep_supp.nStimPerRun * par.rep_supp.nRuns); % 360 stimuli total

% repetition suppression timing 
par.rep_supp.stimTime = 0.5; % stimulus display 500ms
par.rep_supp.respTime = 1.5; % response time 1500ms
par.rep_supp.nfixTime = 3; % 3 asynchronous groups for fixation
par.rep_supp.fixTimeA = 3;
par.rep_supp.fixTimeB = 4.5;
par.rep_supp.fixTimeC = 6;

% practice repetition suppression display parameters
par.practice.rep_supp.disp.nTotalTrials = 5;

%%%%%%%%%%%%

% localizer
par.loc.nRuns = 3;
par.loc.stimTime = 1.5;
par.loc.fixTime = 0.5;
par.loc.unitTime = par.loc.stimTime + par.loc.fixTime; % how long is each trial, 2s (iti = unitTime-stimTime)
par.loc.nType = 5; % five stimulus types - one for each env + fixation
par.loc.nBlockPerType = 6; % should be even number to equate number of targets
par.loc.nBlock = par.loc.nBlockPerType*par.loc.nType+1; % extra block at end
par.loc.nStimPerBlock = 8; % this may need to be changed but each image could be viewed twice per block (8 stim per block)
par.loc.nGoalLoc = 4; % number of goal locations in each environment
par.loc.blockTime = par.loc.unitTime*par.loc.nStimPerBlock; % 16
par.loc.nStimPerType = par.loc.nStimPerBlock*par.loc.nBlockPerType*par.loc.nRuns;
par.loc.runTime = par.bookendFixTime*2+par.loc.blockTime*par.loc.nBlock;
par.loc.pracRunTime = par.bookendFixTime*2+36*par.loc.unitTime;
par.loc.sectionTime = (par.loc.nType)*par.loc.blockTime;

par.loc.nStimPerRunPerType = par.loc.nStimPerBlock*par.loc.nBlockPerType;
par.loc.timePerRunWInit = par.loc.runTime+par.initTime;

% practice localizer parameters
par.practice.loc.nType = 7; % seven stimulus types 

% other important-type stuff
par.fixColor = 0;
par.backColor = 255;
par.txtColor = 0;
par.txtSize = 50;
par.numSize = 100;
par.labelSize = 40;
par.stimSep = 100;

header.parameters = par;

%% load stimulus files and prepare stimuli to use
% set stimulus fields for every run

rand('twister',header.subNr); % use participant number
stimNr = nan(par.nEnvTraining,4); % 4 rows for the 4 environments - nEnvTraining; 4 columns for the four objects
stimType = repmat([1 1 1 1], par.nEnvTraining,1); % 1 = novel objects. this experiment has all novel objects

%% make header.Environs

stimOrderObjects{1} = Shuffle(1:par.nEnvTraining*4); % shuffling our 4x4 matrix of images

stimNr(stimType==1) = stimOrderObjects{1};

tmp = [stimType stimNr];
header.Environs = [(1:par.nEnvTraining)' tmp];

clear tmp stimOrderObjects stimNr stimType;

%% make config.txt parameters

% stimuli assignments
% because snow (env = 0) and factory (env = 5) were taken out to reduce
% env# to four, you have to buffer those positions in the config file.
% here, the object numbers will be assigned to stimOrderObjects positions 5
% - 19, ignoring 1-4 for env 0 (snow) and 20 -24 for env 5 (factory).
% objects 25-28 will be used for the practice (env 6 - volcano).
par.config.stimOrderObjects = [repmat([17 18 19 20],1,1), header.Environs(1,6:9), header.Environs(2,6:9), header.Environs(3,6:9), header.Environs(4,6:9), repmat([21 22 23 24 25 26 27 28],1,1)];

%%%%%%%
% free roam
 
par.config.freeEnv = repmat(6,1,2); % 6 is the volcano environment
par.config.freePlayer = repmat(zeros,1,2); % needs to have two inputs for player and object, zero selected randomly
par.config.freeObj = repmat(zeros,1,2); 

%%%%%%%
% practice phase

% practice learning
% practice environment - always 6 (volcano world)
% blocked - 16 trials (one exposure) + one test with 4 trials
par.config.env_prac_study = cell(1,1);

par.config.env_prac_study{1} = repmat(6,1,16);

% object spawns - which object is tested
% practice learning - obj
par.config.obj_prac_quads{1} = repmat(zeros,1,4);
par.config.obj_prac_quads{2} = repmat(ones,1,4);
par.config.obj_prac_quads{3} = repmat(2,1,4);
par.config.obj_prac_quads{4} = repmat(3,1,4);

par.config.obj_prac_shuffle = Shuffle(par.config.obj_prac_quads);
par.config.obj_prac_studyInt = par.config.obj_prac_shuffle;

% put all the obj values into one cell
par.config.prac_obj_study_list = cat(2,par.config.obj_prac_studyInt{:});
   
% player spawns

par.config.player_prac_study_quads = cell(1,4);

for r = 1:length(par.config.player_prac_study_quads);
    
    par.config.player_prac_study_quads{r} = Shuffle(0:3);
    
end

% put all the player values into one cell
par.config.prac_player_study_list = cat(2,par.config.player_prac_study_quads{:});

% % pair object with player spawn
par.config.obj_player_pairs_prac = [par.config.prac_obj_study_list; par.config.prac_player_study_list];
shuffle_idx = randperm(length(par.config.obj_player_pairs_prac));
shuffled_obj = par.config.obj_player_pairs_prac(:,shuffle_idx);
par.config.prac_interleavedObj = shuffled_obj(1,:);
par.config.prac_interleavedPlayer = shuffled_obj(2,:);

% practice test - environment
par.config.env_prac_test = cell(1,1);

par.config.env_prac_test{1} = repmat(6,1,4);

% practice test - player spawns
par.config.player_prac_test_quads = cell(1,1);

for q = 1:length(par.config.player_prac_test_quads);
    
    par.config.player_prac_test_quads{q} = Shuffle(0:3);
    
end

% practice test - obj
par.config.obj_prac_test = cell(1,1);

par.config.obj_prac_test{1} = Shuffle(0:3);

% output - placed in cells for config file
% player output
par.config.player_prac_study = cell(1,1);
par.config.player_prac_study{1} = par.config.prac_interleavedPlayer;
par.config.player_prac_test = par.config.player_prac_test_quads;

% object output
par.config.obj_prac_study = cell(1,1);
par.config.obj_prac_study{1} = par.config.prac_interleavedObj;

clear r q shuffle_idx shuffled_obj

%%%%%%%
% learning phase
% 144 trials total
% 3 runs with 48 trials 
% learning 'runs' separate object presentation over learning

for v = 1:par.train.nRuns
    % learning - environments
    par.config.env_study_blocked = cell(1,par.nEnvTraining);
    
    % par.config.env_study_blocked{1} = repmat(zeros,1,4); % snow
    par.config.env_study_blocked{2} = repmat(ones,1,4); % sand
    par.config.env_study_blocked{3} = repmat(2,1,4); % basketball
    par.config.env_study_blocked{4} = repmat(3,1,4); % forest
    par.config.env_study_blocked{5} = repmat(4,1,4); % castle
    % par.config.env_study_blocked{6} = repmat(5,1,4); % factory
    
    %shuffles env cell order
    par.config.study_blockedEnv = Shuffle(par.config.env_study_blocked);
    
    % put all the obj values into one cell
    par.config.env_study_list = cat(2,par.config.study_blockedEnv{:});
    
    % learning - object locations
    par.config.obj_study_quads = cell(1,par.nEnvTraining);
    
    for r = 1:length(par.config.obj_study_quads);
        
        par.config.obj_study_quads{r} = Shuffle(0:3);
        
    end
    
    % put all the obj values into one cell
    par.config.obj_study_list = cat(2,par.config.obj_study_quads{:});
    
    % learning - player spawns
    par.config.player_study_quads = cell(1,par.nEnvTraining);
    
    for q = 1:length(par.config.player_study_quads);
        
        par.config.player_study_quads{q} = Shuffle(0:3);
        
    end
    
    % put all the player spawns into one cell
    par.config.player_study_list = cat(2,par.config.player_study_quads{:});
    
    % make obj-env runs
    par.config.studyRun_list_quads = cell(1,par.train.nObjRepsPerRun);
    par.config.studyRun_env_obj_player = [par.config.env_study_list; par.config.obj_study_list; par.config.player_study_list];
    
    for x = 1:length(par.config.studyRun_list_quads)
        repcheck = 1;
        while repcheck > 0
            
            % randomize the order
            shuffle_idx = randperm(length(par.config.studyRun_env_obj_player));
            par.config.studyRun_list_quads{x} = par.config.studyRun_env_obj_player(:,shuffle_idx);
            
            % check for repetitions
            repcheck = 0;
            for n = 2:length(par.config.studyRun_list_quads{x})
                if par.config.studyRun_list_quads{x}(1,n) == par.config.studyRun_list_quads{x}(1,n-1)
                    repcheck = repcheck + 1;
                end
            end %end for
        end %end while
    end %end for
    
    clear n x repcheck;
    
    par.config.studyRun_list = cat(2,par.config.studyRun_list_quads{:});
    
    % output - placed in cells for config file
    par.config.study_interleavedEnv = par.config.studyRun_list(1,:);
    par.config.study_interleavedObj = par.config.studyRun_list(2,:);
    par.config.study_interleavedPlayer = par.config.studyRun_list(3,:);
    
    % environment output
    par.config.study_Env = cell(1,1);
    par.config.study_Env{1} = par.config.study_interleavedEnv;
    
    % object output
    par.config.obj_study = cell(1,1);
    par.config.obj_study{1} = par.config.study_interleavedObj;
    
    % player output
    par.config.player_study = cell(1,1);
    par.config.player_study{1} = par.config.study_interleavedPlayer;
    
    clear r q shuffle_idx shuffled_obj shuffle_idx1 shuffle_idx2 shuffle_idx3 shuffle_idx4
    
    par.config.learning{v} = [par.config.study_interleavedEnv; par.config.study_interleavedPlayer; par.config.study_interleavedObj]; % env obj player
    
end

clear v


%%%%%%%
% test phase
% interleaved - 24 trials
par.config.env_test_interleaved = cell(1,par.nEnvTraining);

% environments removed to reduce # of env from six to four, based on difficulty ratings from participant questionnaires
% par.config.env_test_interleaved{1} = repmat(zeros,1,4); % snow
par.config.env_test_interleaved{2} = repmat(ones,1,4); % desert
par.config.env_test_interleaved{3} = repmat(2,1,4); % basketball
par.config.env_test_interleaved{4} = repmat(3,1,4); % forest
par.config.env_test_interleaved{5} = repmat(4,1,4); % castle
% par.config.env_test_interleaved{6} = repmat(5,1,4); % factory

par.config.test_Env_list = cat(2,par.config.env_test_interleaved{:});

% player spawns
par.config.player_test_quads = cell(1,par.nEnvTraining);

for r = 1:length(par.config.player_test_quads)
    
    par.config.player_test_quads{r} = Shuffle(0:3);
    
end

par.config.player_test = par.config.player_test_quads;

% object spawns
par.config.obj_test_quads = cell(1,par.nEnvTraining);

for q = 1:length(par.config.obj_test_quads)
    
    par.config.obj_test_quads{q} = Shuffle(0:3);
    
end

par.config.obj_test_list = cat(2,par.config.obj_test_quads{:});

% pair object with environment during the test phase
par.config.env_obj_pairs_test = [par.config.test_Env_list; par.config.obj_test_list];
shuffle_idx = randperm(length(par.config.env_obj_pairs_test));
shuffled_obj = par.config.env_obj_pairs_test(:,shuffle_idx);
par.config.test_interleavedEnv = shuffled_obj(1,:);
par.config.test_interleavedObj = shuffled_obj(2,:);

% environment output
par.config.env_test = par.config.test_interleavedEnv;

% object output
par.config.obj_test = par.config.test_interleavedObj;

clear r q shuffle_idx shuffled_obj;

%% Display (Pre- and Post-Scan)

for rep = 1:par.disp.nRepsPerRun
    dispTmp{rep} = [header.Environs; header.Environs; header.Environs; header.Environs];
    
    dispType{rep} = [ones(par.nEnvTraining,1); ones(par.nEnvTraining,1)*2; ones(par.nEnvTraining,1)*3; ones(par.nEnvTraining,1)*4]; 
    
    dispStimuli{rep} = [dispTmp{rep} dispType{rep}];
end

clear rep

for r = 1:par.disp.nRuns
    
    bigCheck = 0;
    while bigCheck == 0
        
        for rep = 1:par.disp.nRepsPerRun
            % ensures objects 1, 2, 3, and 4 of same environment have at least two pairs between
            check = 0;
            while check == 0
                dispOrder = Shuffle(1:par.disp.nStimPerRun/par.disp.nRepsPerRun);
                tmp{rep} = dispStimuli{rep}(dispOrder,:);
                
                % check lag
                checkLag0 = tmp{rep}(2:end, 1) - tmp{rep}(1:(end-1),1);
                checkLag1 = tmp{rep}(3:end, 1) - tmp{rep}(1:(end-2), 1);
                if ~(any(checkLag0==0) || any(checkLag1==0))
                    check = 1;
                end
            end
        end
        
        % concatenate the reps
        allStimReps = vertcat(tmp{:});
        
        % check again for lag
        bigCheckLag0 = allStimReps(2:end, 1) - allStimReps(1:(end-1),1);
        bigCheckLag1 = allStimReps(3:end, 1) - allStimReps(1:(end-2), 1);
        if ~(any(bigCheckLag0==0) || any(bigCheckLag1==0))
            bigCheck = 1;
        end
        
    end
    
    % randomly put them in our big matrix including the nans
    allTrials = nan(par.disp.nTotalTrials,size(allStimReps,2));
    stimIdx = sort(randsample(par.disp.nTotalTrials,par.disp.nStimPerRun,'false'));
    
    allTrials(stimIdx,:) = allStimReps;
    
    % onset (time trial shows up)
    ons = (((1:par.disp.nTotalTrials)-1)*par.disp.trialTime)';
    allTrialsOns = [ons allTrials];
    nanGone = allTrialsOns(~isnan(allTrialsOns(:,2)),:);
    fixOnset = round(50 + (275-50).*rand(par.disp.nStimPerRun,1));
    fixColor = randi(2,[par.disp.nStimPerRun,1]);
    
    header.disp{r} = [nanGone(:,1) fixOnset fixColor nanGone(:,2:end)];
end


clear r rep tmp* ons check* big* all* disp* fix* nan* stimIdx;

header.dispCols = {'onset', 'fixOnset', 'fixColor', 'envNr', 'stimTypeA', 'stimTypeB', 'stimTypeC', 'stimTypeD','stimNumberA', 'stimNumberB',...
    'stimNumberC', 'stimNumberD', 'stimType'};

%% make header.practice.groups - no real groups in nav task - may not need this - but keep it for now.

stimPrNr = nan(par.nEnvTraining,4); % 4 rows for the practice environments, with 4 objects

stimPrType = repmat([1 1 1 1], par.nEnvTraining,1);

stimOrderPrObjects = Shuffle(1:(par.nEnvTraining*4));

% mataches stimuili with correct environment quad, novel objects
stimPrNr(stimPrType==1) = stimOrderPrObjects;

tmp = [stimPrType stimPrNr];
header.practice.Environs = [(1:par.nEnvTraining)' tmp];

clear tmp stim* ;

%% make practice.disp 

dispPrTmp = [repmat(header.Environs,4,1); nan(par.practice.disp.nNullTrials,size(header.Environs,2))]; 

dispPrType = [ones(par.nEnvTraining,1); ones(par.nEnvTraining,1)*2;ones(par.nEnvTraining,1)*3;ones(par.nEnvTraining,1)*4;nan(par.nEnvTraining,1)];

dispPrStimuli = [dispPrTmp dispPrType];

% ensures A, B, and C of same triad have at least two pairs between
check = 0;
while check == 0
    dispPrOrder = Shuffle(1:par.practice.disp.nTotalTrials);
    tmp = dispPrStimuli(dispPrOrder,:);
    
    % removing Nans and checking order
    nanGone = tmp(~isnan(tmp(:,1)),1);
    checkLag0 = nanGone(2:end, 1) - nanGone(1:(end-1),1);
    checkLag1 = tmp(3:end, 1) - tmp(1:(end-2), 1);
    if ~(any(checkLag0==0) || any(checkLag1==0))
        check = 1;
    end
end

% onset (time trial shows up)
ons = (((1:par.practice.disp.nTotalTrials)-1)*par.disp.trialTime)';
tmp2 = [ons tmp];
nanReGone = tmp2(~isnan(tmp2(:,2)),:);
fixOnset = round(50 + (275-50).*rand(par.practice.disp.nStim,1));
fixColor = randi(2,[par.practice.disp.nStim,1]);
header.practice.disp = [nanReGone(:,1) fixOnset fixColor nanReGone(:,2:end)];
    
clear ons check* tmp tmp2 disp* nan*Gone fix*;
 
 header.practice.dispCols = {'onset', 'fixOnset', 'fixColor', 'env', 'stimTypeA', 'stimTypeB', 'stimTypeC', 'stimTypeD', 'stimNumberA', ...
    'stimNumberB','stimNumberC','stimNumberD', 'stimType'};

%% make header.practice.rep_supp.disp 

dispRSPrStimuli = [30 31 32 33 34]';

tmp = Shuffle(dispRSPrStimuli);

% onset (time trial shows up)
ons = [0 3.5 10 15 21.5]'; % Hard coded; will need to be changed if you ever alter practice rep_supp
tmp2 = [ons tmp];
fixOnset = [par.rep_supp.fixTimeA par.rep_supp.fixTimeC par.rep_supp.fixTimeB par.rep_supp.fixTimeC par.rep_supp.fixTimeA]';
header.practice.rep_supp.disp = [tmp2(:,1) fixOnset tmp2(:,2:end)];
    
clear ons check* tmp tmp2 disp* nan*Gone fix*;
 
 header.practice.rep_supp.dispCols = {'onset', 'fixOnset', 'stimNumber'};

%% make repetition suppression display parameters (header.rep_supp.disp)
% Sets of env and random triplets

par.cake = []; 

for r = 1:par.rep_supp.nRuns
    % create of triplet alternation list (all_trls)
    % sample from one env triplet then a random triplet then another
    % env triplet, etc.
    
    % create all_trls which gives you the key for alternating env, rand,
    % and control trials
    %% odd participant numbers start with a random triplet
    %% even participant numbers start with an environment triplet
    if header.group == 1 % start with a random triplet
        par.rep_supp.trlrep = [nan 1 nan 1 0];   
    else
        par.rep_supp.trlrep = [1 nan 1 nan 0];  
    end
    
    par.rep_supp.all_trls = repmat(par.rep_supp.trlrep',[(par.rep_supp.nTripletsPerRun/length(par.rep_supp.trlrep)), 1]);
   
    % create all_reps which randomizes the env order to place in all_trls
    % how many times a triplet from each environment is seen per run
    par.rep_supp.env_reps = (par.rep_supp.nEnvTripletsPerRun)/par.nEnvTraining; % 4x per run
    
    % will hold the info for all of the repetitions
    par.rep_supp.all_reps = [];
    
    % order the environment triplets, including shuffling
    for n = 1:par.nEnvTraining
        par.rep_supp.all_reps = [par.rep_supp.all_reps ones(1,par.rep_supp.env_reps)*n]; %creates the list of all environment repetitions
    end
    
    repcheck = 1;
    while repcheck > 0
        
        % randomize the order
        par.rep_supp.all_reps = Shuffle(par.rep_supp.all_reps);
        
        % check for repetitions
        repcheck = 0;
        for n = 2:length(par.rep_supp.all_reps)
            if par.rep_supp.all_reps(n) == par.rep_supp.all_reps(n-1)
                repcheck = repcheck + 1;
            end
        end %end for
    end %end while
    
    clear n repcheck;

    %% Create triplet order
    
    for x = 1:length(par.rep_supp.all_trls)
        if par.rep_supp.all_trls(x) == 1
            par.rep_supp.all_trls(x) = par.rep_supp.all_reps(1); % set the current environment trial
            par.rep_supp.all_reps(1) = []; % remove the trial from the possible items
        end
    end
    
    % now we've created a list alternating between nans and env# (all_trls)
    
    %%%%%%
    % create triplet types - ABC, ABD, ACD, BCD, and Random (below)
    % each row represents stimuli for that triplet type for each of the 4 envs (row 1 is the
    % stimuli # for the objects in env 1)
    
    par.rep_supp.currABCTriplets = repmat(header.Environs(header.Environs(:,2)==1,6:8),1); % puts the stimuli numbers in from header.Environs
    par.rep_supp.currABDTriplets = repmat(header.Environs(header.Environs(:,2)==1,[6:7,9]),1);
    par.rep_supp.currACDTriplets = repmat(header.Environs(header.Environs(:,2)==1,[6,8:9]),1);
    par.rep_supp.currBCDTriplets = repmat(header.Environs(header.Environs(:,2)==1,7:9),1);
    
    % put all env triplets (and types) in one matrix per env
    for t = 1:par.nEnvTraining
        envTriplets{t} = [Shuffle(par.rep_supp.currABCTriplets(t,:)); Shuffle(par.rep_supp.currABDTriplets(t,:)); Shuffle(par.rep_supp.currACDTriplets(t,:)); Shuffle(par.rep_supp.currBCDTriplets(t,:))];
    end
    
    clear t
    
    % final list that holds all the triplets for each run
    par.rep_supp.all_triplets = nan(par.rep_supp.nTripletsPerRun,3);
    
    % final list that holds all the environment numbers for each run
    par.rep_supp.all_environments = nan(par.rep_supp.nTripletsPerRun,3);
    
    for v = 1:length(par.rep_supp.all_trls)
        par.rep_supp.all_environments(v,:) = par.rep_supp.all_trls(v);
    end
    
    % assign env triplets
    for n = 1:par.rep_supp.nTripletsPerRun
        if isnan(par.rep_supp.all_trls(n)) == 0 && par.rep_supp.all_trls(n) > 0
            this_Env = envTriplets{par.rep_supp.all_trls(n)};
            this_EnvTriplet = this_Env(1,:);
            par.rep_supp.all_triplets(n,:) = this_EnvTriplet; % set the triplet for the first trial
            envTriplets{par.rep_supp.all_trls(n)}(1,:) = []; % remove that item since we just used it
            
        elseif par.rep_supp.all_trls(n) == 0
            par.rep_supp.all_triplets(n,:) = zeros(1,size(par.rep_supp.all_triplets,2));
        end
    end
    
    par.rep_supp.env_Triplet_template = par.rep_supp.all_triplets;
    
    % matrix of object-environment pairings from header.Environs
    bunny = header.Environs(1:par.nEnvTraining,6:9); % get the object numbers paired with each environment
    
    for t = 1:par.nEnvTraining % shuffle the order of columns (objects in env still consistent)
        this_row = Shuffle(bunny(t,:));
        corgi(t,:) = this_row; % corgi is the shuffled key of objects in each environment (corgi = shuffled bunny)
    end
    
    % env_numbers = [1 2 3 4 5 6]; % set environment numbers
    env_numbers = [1 2 3 4]; % set environment numbers
    
    obj_numbers = cell(1,par.nEnvTraining);
    for y = 1:par.nEnvTraining
        obj_numbers{y} = corgi(y,:);
    end
    
    count = zeros(par.nEnvTraining,1);
    
    % counterbalence random triplet placement; this will fill in the nans from all_trls (no element can be in the triplet ahead or behind it or from the same environment of its triplet elements)
    while isempty(find(isnan(par.rep_supp.all_triplets),1)) ~= 1 % keep going while there are still trials with nan
        
        nan_index = find(isnan(par.rep_supp.all_triplets(:,1))); % finds rows where nans indicate that trials need to placed here
        
        env_numbers = [1 2 3 4]; % set environment numbers
        environment = Shuffle(env_numbers);
        env_triad = environment(1:3);
        triplet = [];
        
        for m = 1:length(nan_index) % for rows where there is a nan
            
            full_offset = 1;
            offset = 1;
            
            env_numbers = [1 2 3 4]; % set environment numbers
            environment = Shuffle(env_numbers);
            env_triad = environment(1:3);
            triplet = [];
            
            for q = 1:length(env_triad) % for the triplet you are trying to place ...
                
                if isempty(obj_numbers{env_triad(q)}) % if there aren't three elements in the triplet, repopulate
                    if count(env_triad(q)) < 4 % repopulate
                        
                        obj_numbers{env_triad(q)} = corgi(env_triad(q),:); % get the object numbers paired with each environment
                        count(q) = count(env_triad(q))+1; % tick off one count for the env repopulated
                        
                    else
                        if offset == 1
                            env_triad(q) = environment(4); % take the fourth element of environment to use in env_triad
                            offset = 0;
                            if isempty(obj_numbers{env_triad(q)}) % if there isn't a fourth element to take, repopulate
                                if count(env_triad(q)) < 4 % repopulate
                                    
                                    obj_numbers{env_triad(q)} = corgi(env_triad(q),:); % get the object numbers paired with each environment
                                    count(q) = count(env_triad(q))+1; % tick off one count for the env repopulated
                                    
                                else
                                    par.rep_supp.all_triplets = par.rep_supp.env_Triplet_template; % reset to the template
                                    
                                    count = zeros(par.nEnvTraining,1);
                                    
                                    env_numbers = [1 2 3 4]; % set environment numbers
                                    
                                    obj_numbers = cell(1,par.nEnvTraining); % repopulate obj_numbers
                                    
                                    for y = 1:par.nEnvTraining
                                        obj_numbers{y} = corgi(y,:);
                                    end
                                    
                                    full_offset = 0;
                                    
                                end
                            end
                            
                        else
                            par.rep_supp.all_triplets = par.rep_supp.env_Triplet_template; % reset to the template
                            
                            count = zeros(par.nEnvTraining,1);
                            
                            env_numbers = [1 2 3 4]; % set environment numbers
                            
                            obj_numbers = cell(1,par.nEnvTraining); % repopulate obj_numbers
                            for k = 1:par.nEnvTraining
                                obj_numbers{k} = corgi(k,:);
                            end
                            
                            full_offset = 0;
                            
                        end
                        
                    end
                    
                end % end isempty
                
                if length(triplet) < 3 % fill triplet; this will always be true since triplet has been empty
                    triplet = [triplet obj_numbers{env_triad(q)}(1)];
                    obj_numbers{env_triad(q)}(1) = [];
                end % end if
                
            end % end q
            
            par.rep_supp.all_environments(nan_index(m),:) = env_triad; % place environment numbers used in all_environments
            
            placement = [1 1 1]; % check to ensure that all three spots can be filled
            
            if nan_index(m) == 1 % first trial, so check only the line below
                for t = 2:par.rep_supp.nStimPerTriplet % we only need to check columns 2 and 3 to counterbalence with 2 presentations between environments
                    
                    if par.rep_supp.all_environments(nan_index(m),t) == par.rep_supp.all_environments(2,t)
                        
                        placement(t) = 0;
                        
                        %reset
                        par.rep_supp.all_environments(nan_index(m),:) = nan(1,par.rep_supp.nStimPerTriplet); % reset row back to NaNs
                        
                        full_offset = 0;
                        
                    end
                    
                end % t
                
            elseif nan_index(m) == par.rep_supp.nTripletsPerRun % last trial, so check only the line above
                for t = 1:(par.rep_supp.nStimPerTriplet-1) % we only need to check columns 1 and 2 to counterbalence with 2 presentations between environments
                    if par.rep_supp.all_environments(nan_index(m),t) == par.rep_supp.all_environments(par.rep_supp.nTripletsPerRun-1,t)
                        
                        placement(t) = 0;
                        
                        %reset
                        par.rep_supp.all_environments(nan_index(m),:) = nan(1,par.rep_supp.nStimPerTriplet); % reset row back to NaNs
                        
                        full_offset = 0;
                        
                    end
                    
                end % t
                
            else % if it isn't the first or last trial, check above and below
                if par.rep_supp.all_trls(nan_index(m)+1) == 0 % if the line below is a zero, just check above
                    for t = 1:(par.rep_supp.nStimPerTriplet-1)
                        if par.rep_supp.all_environments(nan_index(m),t) == par.rep_supp.all_environments(nan_index(m)-1,t)
                            
                            placement(t) = 0;
                            
                            %reset
                            par.rep_supp.all_environments(nan_index(m),:) = nan(1,par.rep_supp.nStimPerTriplet); % reset row back to NaNs
                            
                            full_offset = 0;
                            
                        end
                        
                    end % t
                    
                    
                    
                elseif par.rep_supp.all_trls(nan_index(m)-1) == 0 % if the line above is a zero, just check below
                    for t = 2:par.rep_supp.nStimPerTriplet
                        if par.rep_supp.all_environments(nan_index(m),t) == par.rep_supp.all_environments(nan_index(m)+1,t)
                            
                            placement(t) = 0;
                            
                            %reset
                            par.rep_supp.all_environments(nan_index(m),:) = nan(1,par.rep_supp.nStimPerTriplet); % reset row back to NaNs
                            
                            full_offset = 0;
                            
                        end
                        
                    end % t
                    
                else
                    % there can be two stim presentations between each stim
                    % from the same env; hence, this check setup
                    for t = 1:par.rep_supp.nStimPerTriplet % for each column
                        if t == 1 % if column 1, check above
                            if par.rep_supp.all_environments(nan_index(m),t) == par.rep_supp.all_environments(nan_index(m)-1,t)
                                
                                placement(t) = 0;
                                
                                %reset
                                par.rep_supp.all_environments(nan_index(m),:) = nan(1,par.rep_supp.nStimPerTriplet); % reset row back to NaNs
                                
                                full_offset = 0;
                            end
                        elseif t == 2 % if column 2, check above and below
                            if par.rep_supp.all_environments(nan_index(m),t) == par.rep_supp.all_environments(nan_index(m)-1,t)
                                
                                placement(t) = 0;
                                
                                %reset
                                par.rep_supp.all_environments(nan_index(m),:) = nan(1,par.rep_supp.nStimPerTriplet); % reset row back to NaNs
                                
                                full_offset = 0;
                                
                            elseif par.rep_supp.all_environments(nan_index(m),t) == par.rep_supp.all_environments(nan_index(m)+1,t)
                                
                                placement(t) = 0;
                                
                                %reset
                                par.rep_supp.all_environments(nan_index(m),:) = nan(1,par.rep_supp.nStimPerTriplet); % reset row back to NaNs
                                
                                full_offset = 0;
                                
                            end % if
                        else % if column 3, check below
                            if par.rep_supp.all_environments(nan_index(m),t) == par.rep_supp.all_environments(nan_index(m)+1,t)
                                
                                placement(t) = 0;
                                
                                %reset
                                par.rep_supp.all_environments(nan_index(m),:) = nan(1,par.rep_supp.nStimPerTriplet); % reset row back to NaNs
                                
                                full_offset = 0;
                                
                            end % if
                            
                        end
                        
                        if full_offset == 0
                            
                            break
                            
                        end 
                        
                    end % t
                    
                end % if
                
            end % if
            
            if sum(placement) == 3 % none of our checks were bad, so place those objects!
                
                par.rep_supp.all_triplets(nan_index(m),:) = triplet; % place triplet in all_triplets
                
            end
            
        end % end m
        
    end % end while
    
    % par.cake = cat(3,par.cake,par.rep_supp.all_triplets); % outputs list of counterbalenced stimuli (env and random, no control)
    
    clear k m n t q v x y count env_numbers environment env_triad triplet full_offset nan_index obj_numbers offset placement this_Env this_EnvTriplet this_row
 
    par.pie = [];
        
    obj_numbers = cell(1,par.nEnvTraining);
    for y = 1:par.nEnvTraining
        obj_numbers{y} = corgi(y,:);
    end
    
    count = zeros(par.nEnvTraining,1);
    
    par.rep_supp.env_Triplet_template = par.rep_supp.all_triplets;
    par.rep_supp.env_Env_template = par.rep_supp.all_environments;

 % counterbalence control triplet placement; this will fill in the zeros in all_trls (first two objects from one environment, the third from another)
 while isempty(find(par.rep_supp.all_triplets(:,1)==0)) ~= 1 % keep going while there are still trials with zero
     
     zero_index = find(par.rep_supp.all_triplets(:,1)==0); % finds rows where zeros indicate that a control trial needs to placed
     
     for m = 1:length(zero_index) % for rows where there is a zero
         
         full_offset = 1;
         
         env_numbers = [1 2 3 4]; % set environment numbers
         environment = Shuffle(env_numbers);
         triplet = [];
         
         % make the repeated env value
         if zero_index(m) == par.rep_supp.nTripletsPerRun % last trial, so check only the line above
             
             env_used = par.rep_supp.all_environments(zero_index(m)-1,[2:3]);
             
             env_repeat = environment(~ismember(environment,env_used));
             
         else % if it isn't the last trial, check above and below (for the controls, it will never be the first trial)
             % there can be two stim presentations between each stim from the same env; hence, this check setup
             for t = 1:par.rep_supp.nStimPerTriplet % for each column
                 if t == 1 % if column 1, check columns 2 and 3 of the line above
                     env_used = par.rep_supp.all_environments(zero_index(m)-1,[2:3]);
                     
                     env_repeat = environment(~ismember(environment,env_used)); % get rid of the values from the first check
                     
                 elseif t ==2 % if column 2, check column 1 below
                     env_used = par.rep_supp.all_environments(zero_index(m)+1,1);
                     
                     env_repeat = env_repeat(~ismember(env_repeat,env_used)); % get rid of the values from the second check
                     
                 else % if column 3, check below
                     env_used = par.rep_supp.all_environments(zero_index(m)+1,[1:2]);
                     
                     env_repeat = env_repeat(~ismember(env_repeat,env_used)); % and the third check, you should now only have one value
                     
                 end % if t=1
                 
             end % t=1:par.rep_supp.nStimPerTriplet
             
         end % if zero_index
         
         % place environment to repeat in env_triad (i.e. [repeat repeat single])
         env_triad = repmat(env_repeat(1),1,2);
         
         % make the random env value
         environment = Shuffle(env_numbers); % shuffle just to further randomize
         env_single = environment(~ismember(environment,env_triad)); % take env_repeat out of possible environments
         
         if zero_index(m) == par.rep_supp.nTripletsPerRun % if the last row, env_single just can't be env_repeat (which is innate in creating env_single)
             env_used = Shuffle(env_single);
             
             env_single = env_used(1);
             
         else
             for z = 1:length(env_single)
                 env_used = par.rep_supp.all_environments(zero_index(m)+1,[1:2]);
                 
                 env_single = env_single(~ismember(env_single,env_used)); % narrow down the env that can be used as the random
                 
             end % z
         end % if zero_index
         
         if isempty(env_repeat) || isempty(env_single) % complete reset
             par.rep_supp.all_triplets = par.rep_supp.env_Triplet_template; % reset to the template
             par.rep_supp.all_environments = par.rep_supp.env_Env_template;
             
             env_numbers = [1 2 3 4]; % set environment numbers
             
             obj_numbers = cell(1,par.nEnvTraining); % repopulate obj_numbers
             
             for k = 1:par.nEnvTraining
                 obj_numbers{k} = corgi(k,:);
             end
             
             full_offset = 0;
             
         end
         
         if full_offset == 0
             
             break
             
         end
         
         % add it to env_triad
         env_triad = [env_triad env_single(1)];
         
         for q = 1:length(env_triad) % for the triplet you are trying to place ...
             
             if isempty(obj_numbers{env_triad(q)}) % if there aren't three elements in the triplet, repopulate (count probably isn't necessary here)
                 if count(env_triad(q)) < 2 % repopulate
                     
                     obj_numbers{env_triad(q)} = corgi(env_triad(q),:); % get the object numbers paired with each environment
                     count(q) = count(env_triad(q))+1; % tick off one count for the env repopulated
                     
                 else
                     par.rep_supp.all_triplets = par.rep_supp.env_Triplet_template; % reset to the template
                     par.rep_supp.all_environments = par.rep_supp.env_Env_template;
                     
                     count = zeros(par.nEnvTraining,1);
                     
                     env_numbers = [1 2 3 4]; % set environment numbers
                     
                     obj_numbers = cell(1,par.nEnvTraining); % repopulate obj_numbers
                     for k = 1:par.nEnvTraining
                         obj_numbers{k} = corgi(k,:);
                     end
                     
                     full_offset = 0;
                     
                 end % end count
                 
                 if full_offset == 0
                     
                     break
                     
                 end
                 
             end % end isempty
             
             if full_offset == 0
                 
                 break
                 
             end
             
             if length(triplet) < 3 % fill triplet; this will always be true since triplet has been empty
                 triplet = [triplet obj_numbers{env_triad(q)}(1)];
                 obj_numbers{env_triad(q)}(1) = [];
             end % end if
             
         end % q
         
         if full_offset == 0
             
             break
             
         end
         
         par.rep_supp.all_environments(zero_index(m),:) = env_triad; % place environment numbers used in all_environments
         par.rep_supp.all_triplets(zero_index(m),:) = triplet; % place triplet in all_triplets
         
     end % m
     
 end % end while
    
    par.pie = cat(3,par.pie,par.rep_supp.all_triplets);
    
    clear k m q t y z bunny corgi count env_numbers env_repeat env_single env_triad env_used environment envTriplets full_offset obj_numbers triplet zero_index
    
    %% make par.rep_supp.fixTime
    % Sets of pseudorandom fixation times for the rep suppression display
    
    fixationA = repmat(par.rep_supp.fixTimeA,par.rep_supp.nEnvTriplets,1);
    fixationB = repmat(par.rep_supp.fixTimeB,par.rep_supp.nRandTriplets,1);
    fixationC = repmat(par.rep_supp.fixTimeC,par.rep_supp.nControlTriplets,1);
    
    fixation = [fixationA; fixationB; fixationC];
    
    fixation_shuffled = Shuffle(fixation);
    
    par.rep_supp.fixTime = fixation_shuffled;
    
    clear fixationA fixationB fixationC fixation fixation_shuffled;
    
    %% onsets
    % trial timing
    par.rep_supp.trialTime = (par.rep_supp.stimTime + par.rep_supp.fixTime);
    
    % onset (time trial shows up)
    ons = [];
    for x = 1:(length(par.rep_supp.trialTime))-1
        this_time(1) = 0;
        this_trial = x+1;
        this_time(this_trial) = this_time(x) + par.rep_supp.trialTime(x);
        ons = this_time';
    end
    
    clear x this_time this_trial;
    
    %% create trial lists
    % trial type
    par.rep_supp.all_trlTypes = [];
    for x = 1:length(par.rep_supp.all_trls)
        this_triplet = par.rep_supp.all_trls(x);
        par.rep_supp.all_trlTypes = vertcat(par.rep_supp.all_trlTypes,[this_triplet this_triplet this_triplet]');
    end
    
    clear x this_triplet;
    
    % triplets
    par.rep_supp.tripletList = [];
    for x = 1:length(par.rep_supp.all_triplets)
        this_triplet = par.rep_supp.all_triplets(x,1:3);
        par.rep_supp.tripletList = vertcat(par.rep_supp.tripletList, this_triplet');
    end
    
    clear x this_triplet;
    
    % environment number
    par.rep_supp.envList = [];
    for x = 1:length(par.rep_supp.all_environments)
        this_triplet = par.rep_supp.all_environments(x,1:3);
        par.rep_supp.envList = vertcat(par.rep_supp.envList, this_triplet');
    end
    
    clear x this_triplet;
    
    % object number
    environs = header.Environs(1:par.nEnvTraining,6:9);
    objNums = [1:par.nObjPerEnv];
        
    par.rep_supp.objNr = [];
    for x = 1:length(par.rep_supp.all_trlTypes) 
        par.rep_supp.objNr(x) = objNums(environs(par.rep_supp.envList(x),:) == par.rep_supp.tripletList(x));
    end
    par.rep_supp.objNr = par.rep_supp.objNr';
    
    clear x environs
    
    header.rep_supp.disp{r} = [ons par.rep_supp.fixTime par.rep_supp.all_trlTypes par.rep_supp.tripletList par.rep_supp.envList par.rep_supp.objNr]; % onsets, fixation, triplet type/env, triplet image #s, env #s
    
end % r (run#)

clear ons tmp pairOrder studyPairType currPairs check* maxIntermixedNr minIntermixedNr i r;

header.rep_supp.dispCols = {'onset', 'fixation', 'envCode', 'stimNumber', 'envNumber', 'objNumber'};

%% create localizer parameters

% this will be a list of the object image #s
objNrs = (1:((par.loc.nType-1)*par.loc.nGoalLoc))';

% yep, this is happening.  you're hard coding.
stimOrder = nan(par.loc.nStimPerBlock*par.loc.nBlockPerType,par.loc.nRuns,par.loc.nType);

% creates orders for each of the six environments
AStimOrder1 = [2,1,1,3,4,2,3,4]';
AStimOrder2 = [2,3,1,1,4,2,3,4]';
AStimOrder3 = [1,3,4,2,2,1,3,4]';
AStimOrder4 = [1,3,4,1,2,2,3,4]';
AStimOrder5 = [2,1,4,2,1,3,3,4]';
AStimOrder6 = [2,3,1,2,3,1,4,4]';

AStimCol1 = [AStimOrder4; AStimOrder1; AStimOrder6; AStimOrder2; AStimOrder3; AStimOrder5];
AStimCol2 = [AStimOrder6; AStimOrder5; AStimOrder4; AStimOrder2; AStimOrder3; AStimOrder1];
AStimCol3 = [AStimOrder4; AStimOrder2; AStimOrder6; AStimOrder3; AStimOrder1; AStimOrder5];

stimOrder(:,:,1)= [AStimCol1 AStimCol2 AStimCol3];

BStimOrder1 = [6,5,5,7,8,6,7,8]';
BStimOrder2 = [6,7,5,5,8,6,7,8]';
BStimOrder3 = [5,7,8,6,6,5,7,8]';
BStimOrder4 = [6,5,8,6,7,7,5,8]';
BStimOrder5 = [6,5,8,6,5,7,7,8]';
BStimOrder6 = [6,7,5,6,7,5,8,8]';

BStimCol1 = [BStimOrder5; BStimOrder1; BStimOrder2; BStimOrder6; BStimOrder3; BStimOrder4];
BStimCol2 = [BStimOrder3; BStimOrder1; BStimOrder4; BStimOrder2; BStimOrder5; BStimOrder6];
BStimCol3 = [BStimOrder3; BStimOrder5; BStimOrder6; BStimOrder2; BStimOrder4; BStimOrder1];

stimOrder(:,:,2)= [BStimCol1 BStimCol2 BStimCol3];

CStimOrder1 = [10,9,9,11,12,10,11,12]';
CStimOrder2 = [10,11,9,9,12,10,11,12]';
CStimOrder3 = [9,11,12,10,10,9,11,12]';
CStimOrder4 = [10,9,12,10,11,11,9,12]';
CStimOrder5 = [10,11,9,10,11,12,12,9]';
CStimOrder6 = [10,11,9,10,11,9,12,12]';

CStimCol1 = [CStimOrder5; CStimOrder1; CStimOrder2; CStimOrder3; CStimOrder6; CStimOrder4];
CStimCol2 = [CStimOrder4; CStimOrder3; CStimOrder1; CStimOrder5; CStimOrder6; CStimOrder2];
CStimCol3 = [CStimOrder3; CStimOrder5; CStimOrder4; CStimOrder6; CStimOrder1; CStimOrder2];

stimOrder(:,:,3)= [CStimCol1 CStimCol2 CStimCol3];

DStimOrder1 = [14,15,13,13,16,14,15,16]';
DStimOrder2 = [13,14,14,15,16,13,15,16]';
DStimOrder3 = [13,15,16,14,14,13,15,16]';
DStimOrder4 = [14,13,16,14,15,15,13,16]';
DStimOrder5 = [14,13,16,14,13,15,15,16]';
DStimOrder6 = [14,15,13,14,15,13,16,16]';

DStimCol1 = [DStimOrder5; DStimOrder4; DStimOrder6; DStimOrder2; DStimOrder3; DStimOrder1];
DStimCol2 = [DStimOrder6; DStimOrder5; DStimOrder4; DStimOrder1; DStimOrder2; DStimOrder3];
DStimCol3 = [DStimOrder3; DStimOrder6; DStimOrder4; DStimOrder2; DStimOrder1; DStimOrder5];

stimOrder(:,:,4)= [DStimCol1 DStimCol2 DStimCol3];

% EStimOrder1 = [18,19,17,17,20,18,19,20]';
% EStimOrder2 = [17,18,18,19,20,17,19,20]';
% EStimOrder3 = [17,19,20,18,18,17,19,20]';
% EStimOrder4 = [18,17,20,18,19,19,17,20]';
% EStimOrder5 = [18,19,17,18,19,20,20,17]';
% EStimOrder6 = [18,19,17,18,19,17,20,20]';
% 
% EStimCol1 = [EStimOrder3; EStimOrder6; EStimOrder1; EStimOrder4];
% EStimCol2 = [EStimOrder5; EStimOrder6; EStimOrder3; EStimOrder2];
% EStimCol3 = [EStimOrder3; EStimOrder4; EStimOrder5; EStimOrder1];
% 
% stimOrder(:,:,5)= [EStimCol1 EStimCol2 EStimCol3];
% 
% FStimOrder1 = [22,23,21,21,24,22,23,24]';
% FStimOrder2 = [21,22,22,23,24,21,23,24]';
% FStimOrder3 = [22,21,24,23,23,22,21,24]';
% FStimOrder4 = [22,21,24,22,23,23,21,24]';
% FStimOrder5 = [22,23,21,22,23,24,24,21]';
% FStimOrder6 = [22,23,21,22,23,21,24,24]';
% 
% FStimCol1 = [FStimOrder4; FStimOrder6; FStimOrder3; FStimOrder1];
% FStimCol2 = [FStimOrder5; FStimOrder2; FStimOrder6; FStimOrder3];
% FStimCol3 = [FStimOrder3; FStimOrder4; FStimOrder1; FStimOrder5];
% 
% stimOrder(:,:,6)= [FStimCol1 FStimCol2 FStimCol3];

%% set stimulus fields for every run

block = 1:par.loc.nBlock;
blockCol = repmat(block,par.loc.nStimPerBlock,1); blockCol=blockCol(:);

% generate baseline trials (nans) and assign block number (env#) to task trials
for r = 1:par.loc.nRuns
    
    stimType = zeros(par.loc.nBlockPerType*par.loc.nType,1);
    stimType(1:par.loc.nType:par.loc.nBlock,1) = par.loc.nType; % put baseline every four blocks
    tmp = [];
    
    for s=1:par.loc.nBlockPerType % for each section
        tmp = [tmp; randperm(par.loc.nType-1)']; % only do it for first 6 stimtypes - NOT fixation
    end
    
    stimType(stimType==0) = tmp; % if there's a zero add a number (randperm) from temp
    
    header.loc.blocktype{r}=stimType;
    numTarget = nan(size(stimType));
    typeCol = repmat(stimType,1,par.loc.nStimPerBlock)'; typeCol=typeCol(:);
    stimCol = nan(par.loc.nStimPerBlock*par.loc.nBlock,1);
    
    %creates the repeats
    for type=1:(par.loc.nType-1)
        stimCol(typeCol==type)=stimOrder(:,r,type);
        numTarget(stimType==type)=Shuffle(ones(1,par.loc.nBlockPerType));
    end
            
    % get targets for each block
    istarget = zeros(par.loc.nStimPerBlock,par.loc.nBlock);
    
    for b = 1:length(stimCol)
        
        if isnan(stimCol(b))
            istarget(b)=nan;
        elseif stimCol(b) == stimCol(b-1)
            istarget(b)=1;
        end
        
    end
    
    istarget=istarget(:);
    istarget=istarget.*~isnan(stimCol);
    target2b=[istarget(2:end);0];
    
    % insert baseline numbers
    tmpbase = Shuffle(repmat([1:3]',ceil(((par.loc.nBlockPerType+1)*par.loc.nStimPerBlock)/3),1));
    stimCol(typeCol==7) = tmpbase(1:length(stimCol(typeCol==7)));
    
    stim = [blockCol, typeCol, stimCol, istarget];
    
    % response key
    for z = 1:length(stim)
        if isnan(stim(z,4))
            stim(z,5) = NaN;
        elseif stim(z,4) == 0;
            stim(z,5) = 1;
        else
            stim(z,5) = 2;
        end
    end
    
    clear z

    %%% include stimulus repetition
    header.loc.locstim{r}= stim;
    header.loc.numTarget{r}=numTarget';
end

% onsets
header.loc.blockOnset = [0:par.loc.blockTime:par.loc.blockTime*(par.loc.nBlock)]'; % sets the time for each block
header.loc.blockDuration = par.loc.blockTime;
header.loc.stimTime = par.loc.stimTime;
header.loc.fixTime = par.loc.fixTime;
header.loc.loconset = [0:par.loc.unitTime:par.loc.blockTime*par.loc.nBlock-1]';
header.loc.locStimLabels = {'blockNr', 'stimType', 'stimNr', 'isTarget', 'respKey'}; 

header.loc.runTime = par.loc.sectionTime*par.loc.nBlockPerType+par.loc.blockTime+2*par.bookendFixTime;

%% practice trials will be the same for everyone (based on practice env)
% there will be twenty practice trials with four targets in them (one
% target per block/stimtype) - from meg
% includes baseline blocks at the beginning and end
% lamest code ever

practiceStimOrder1 = [25,26,27,27,28,25]';
practiceStimOrder2 = [26,27,28,28,26,25]';
practiceStimOrder3 = [26,25,27,28,28,27]';
practiceStimOrder4 = [26,25,25,27,28,26]';
practiceStimOrder5 = [27,25,26,26,27,28]';
practiceStimOrder6 = [25,25,26,27,28,28]';
practiceBaseOrder1 = [3,1,1,2,3,2]'; % base images (base images aren't being used so numbers here are arbitary)/ fixation cross
practiceBaseOrder2 = [1,3,1,2,2,3]'; % base images

practiceStimCol = [practiceBaseOrder1; practiceStimOrder1; ...
    practiceStimOrder2; practiceStimOrder3; ...
    practiceStimOrder4; practiceStimOrder5; ...
    practiceStimOrder6; practiceBaseOrder2];

practiceType = [ones(6,1)*7;ones(6,1);2*ones(6,1);3*ones(6,1);4*ones(6,1);5*ones(6,1);6*ones(6,1);ones(6,1)*7];
practiceBlock = sort(repmat([1:8]',6,1));
tmp = logical([false;diff(practiceStimCol(practiceType<par.practice.loc.nType))==0]);
practiceIstarget = [nan(6,1); tmp; nan(6,1)];

practiceStim = [practiceBlock,practiceType,practiceStimCol,practiceIstarget];
header.loc.practice = practiceStim;

% response key
for z = 1:length(header.loc.practice)
    if isnan(header.loc.practice(z,4))
        header.loc.practice(z,5) = NaN;
    elseif header.loc.practice(z,4) == 0
        header.loc.practice(z,5) = 1;
    else
        header.loc.practice(z,5) = 2;
    end
end

header.loc.practiceonset = (0:par.loc.unitTime:par.loc.unitTime*(size(header.loc.practice,1)-1))';

clear z b block blockCol blockstart check istarget numTarget ...
    practiceBlock practiceIstarget practiceStim practiceStimCol practiceType ...
    r s sectionoffset stim* target2b tmp* type* exitflag face* n obj* rating* scene* ...
    status allFace* allScene* ans practice*;

clear AStimCol1 AStimCol2 AStimCol3 AStimOrder1 AStimOrder2 AStimOrder3 AStimOrder4 AStimOrder5 AStimOrder6 ...
    BStimCol1 BStimCol2 BStimCol3 BStimOrder1 BStimOrder2 BStimOrder3 BStimOrder4 BStimOrder5 BStimOrder6 ...
    CStimCol1 CStimCol2 CStimCol3 CStimOrder1 CStimOrder2 CStimOrder3 CStimOrder4 CStimOrder5 CStimOrder6 ...
    DStimCol1 DStimCol2 DStimCol3 DStimOrder1 DStimOrder2 DStimOrder3 DStimOrder4 DStimOrder5 DStimOrder6 ...
    EStimCol1 EStimCol2 EStimCol3 EStimOrder1 EStimOrder2 EStimOrder3 EStimOrder4 EStimOrder5 EStimOrder6 ...
    FStimCol1 FStimCol2 FStimCol3 FStimOrder1 FStimOrder2 FStimOrder3 FStimOrder4 FStimOrder5 FStimOrder6;

%% Save header

header.parameters = par;

savefname = sprintf('%s/%s_header_%d_%s',header.path.subNr,expName,header.subNr,header.subInit);
save(savefname,'header');

disp('---------------');
disp('Header is ready for use.')
disp(sprintf('Please continue to free roam followed by calling %s_config(header,taskNr)',expName))

clear par expName ans savefname;