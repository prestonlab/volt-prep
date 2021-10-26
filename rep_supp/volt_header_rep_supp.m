%function header = volt_header()
%
% This script generates the header file 'header' in the  workspace
% the 'header' variable is used when calling each run.
%
% Subexperiments are functions that take the header (and optionally, run
% number) as inputs and return data structures
%
% Each subexperiment can run independently and generates its own output
%
% The plan is to run the following:
%
% volt_header
% volt_free_roam
% volt_nav_training
% volt_practice_disp
% volt_disp1, runs 1-4 -- SCANNED
% volt_learning
% volt_test
% volt_disp2, runs 1-4 -- SCANNED
% volt_localizer (day 2) - not included in this header (NOTE needs to pull
% environmental info from this header
% volt_rep_supp_header (day 2) - not included in this header
% volt_rep_supp (day 2) -- SCANNED - not included in this header
%
% Must be called from sim experiment folder to work
%
% Version 1, April 2015 (4/15/2015)

% there are 4, ~6 minute runs for the pre/post displays

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

par.bookendFixTime = 4;

par.ngroups = 2; % number of groups for rep_supp (either starts with a random or env triplet)

%% set-up

header = struct('exp',expName,'version','v1, April 15, 2015','parameters',struct);
header.path.exp = pwd; %the path is the current folder
header.path.data = [header.path.exp '/data/']; % for output
header.path.stim = [header.path.exp '/stimuli/'];

header.path.practicedata = [header.path.exp '/prac_data/']; % for practice
%header.path.practicestim = [header.path.exp '/prac_stimuli/'];

% check to see if the data path exists. if not make a directory
if ~exist(header.path.data, 'dir')
    mkdir(header.path.data);
end
    
disp(sprintf('This script generates header file for %s experiment.',expName));
disp('---------------');
header.subNr = input('Subject Number:  ');
header.subInit = input('Subject Initials:  ', 's');
header.gender = input('Is this male (1) or female (2)?  ');

% select counterbalancing group
header.group = mod(header.subNr,par.ngroups);
if header.group == 0, header.group = par.ngroups; end
disp('');
disp('---------------');
disp(''); disp('');
disp('Please make sure this information is correct.');
disp('---------------');
disp(['Subject Nr = ', num2str(header.subNr) ]);
disp([ 'Subject Initials = ',header.subInit]);
if header.gender == 1
    disp('This subject is male');
else
    disp('This subject is female');
end
disp('---------------');
disp(''); disp('');
yn = input('Is this correct?  (y,n):  ', 's'); % possibly put in loop
if(~isequal(upper(yn(1)), 'Y'))
    return;
end

clear yn

% make subject folder
header.path.subNr = [header.path.data sprintf('%d_%s', header.subNr, header.subInit)]; 
header.path.practicedata_subNr = [header.path.practicedata sprintf('/%d_%s', header.subNr, header.subInit)];

% for header and displays
% if exist(header.path.subNr)~=0; % check whether a directory with that name exists already
%     disp('Warning!!! File for this subject already exists! Aborting...');
%     clear all; return;  % abort experiment, rather than overwrite existing data
% end

% mkdir(sprintf('%s/%d_%s',header.path.data, header.subNr, header.subInit));

% % for practice display
% if exist(header.path.practicedata_subNr)~=0; % check whether a directory with that name exists already
%     disp('Warning!!! File for this subject already exists! Aborting...');
%     clear all; return;  % abort experiment, rather than overwrite existing data
% end
% 
% mkdir(sprintf('%s/%d_%s',header.path.practicedata, header.subNr, header.subInit));

%% parameters for each experiment component

header.setupTime = fix(clock);

% general parameters
par.nEnvType = 6; % for the 6 environments
par.nEnvPerType = 1; % number of types of environments - this could be 2 if you need to make the practice env into another type
par.nEnvTraining = (par.nEnvPerType * par.nEnvType); % you could just hard code this to 6 if you end up not using gpType - these value seem backwards in what they define too

%%%%%%%%%%

% display
par.disp.nRepsPerRun = 2;
par.disp.nRuns = 4;
par.disp.nTotalReps = (par.disp.nRepsPerRun * par.disp.nRuns);
par.disp.stimTime = 0.3;
par.disp.fixTime = 3.7;
par.disp.trialTime = (par.disp.stimTime + par.disp.fixTime);
par.disp.nStimPerRun = (par.nEnvTraining * 4 * par.disp.nRepsPerRun);
par.disp.nNullTrials = (par.disp.nStimPerRun / 4); % null trials are the same length as regular trials, randomly intermixed.
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
par.train.nStudyBlocks = par.nEnvTraining;
par.train.nStudyInterleavedStim = (par.nEnvTraining * 4); % 4 objects for each environment
par.train.nStudyEnv = (par.nEnvTraining * 16); % 4 presentations for each of the four objects within each environment
par.train.nTestEnv = (par.nEnvTraining * 8); % 2 presentations for each of the four objects within each environment
par.train.nSpawns = 4;

%%%%%%%%%%%%

% repetition suppression
par.rep_supp.nRuns = 2;
par.rep_supp.nTripletTypes = 2; % environment (repetition condition) or random triplet
par.rep_supp.nEnvTripletTypes = 4; % ABC, ABD, ACD, BCD
par.rep_supp.nEnvTriplets = (par.nEnvTraining * 8); % 48 triplets in env and rand conditions each - should this just be # of triplets since they'll be equal and group number will play into this
par.rep_supp.nEnvTripletsPerType = (par.rep_supp.nEnvTriplets / par.rep_supp.nEnvTripletTypes); % each type will be seen 12x
par.rep_supp.nRandTriplets = (par.nEnvTraining * 8);
par.rep_supp.nTotalTriplets = (par.rep_supp.nEnvTriplets + par.rep_supp.nRandTriplets); % 96 total triplets
par.rep_supp.nTripletsPerRun = (par.rep_supp.nTotalTriplets / par.rep_supp.nRuns); % 48 triplets equal between env and rand between runs
par.rep_supp.nStim = 24;
par.rep_supp.nStimPerTriplet = 3;
par.rep_supp.nStimPerRun = (par.rep_supp.nStimPerTriplet * par.rep_supp.nTripletsPerRun); %144 stimuli per run
par.rep_supp.nStimTotal = (par.rep_supp.nStimPerRun * par.rep_supp.nRuns); % 288 stimuli total
par.rep_supp.nTotalTrials = par.rep_supp.nStimPerRun; 

% repetition suppression timing - this needs to be fixed
par.rep_supp.stimTime = 0.5; % stimulus display 500ms
par.rep_supp.respTime = 1.5; % response time 1500ms
par.rep_supp.nfixTime = 3; % 3 asynchronous groups for fixation
par.rep_supp.fixTime = 3.7;
par.rep_supp.fixTimeA = 3;
par.rep_supp.fixTimeB = 4.5;
par.rep_supp.fixTimeC = 6;
par.rep_supp.trialTime = (par.rep_supp.stimTime + par.rep_supp.fixTime);

%%%%%%%%%%%%

% practice disp is a "mini-run", 1 rep of each real stimulus
% expose subjects to stimuli before they enter scanner

% practice display parameters
par.practice.disp.nStim = (par.nEnvTraining * 4); % 24 objects included
par.practice.disp.nNullTrials = par.nEnvTraining;
par.practice.disp.nTotalTrials = (par.practice.disp.nStim + par.practice.disp.nNullTrials);

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

rand('twister',header.subNr); %use subject number
stimNr = nan(par.nEnvTraining,4); % 6 rows for the 6 environments - nEnvTraining; 4 columns for the four objects
% gpType = [ones(par.nEnvPerType,1); ones(par.nEnvPerType,1)*2; ones(par.nEnvPerType,1)*3; ones(par.nEnvPerType,1)*4; ones(par.nEnvPerType,1)*5; ones(par.nEnvPerType,1)*6;];
stimType = repmat([1 1 1 1], par.nEnvTraining,1); % 1 = novel objects. this experiment has all novel objects

%% make header.Environs

stimOrderObjects{1} = Shuffle(1:par.nEnvTraining*4); % shuffling our 6x4 matrix of images

stimNr(stimType==1) = stimOrderObjects{1};

tmp = [stimType stimNr];
header.Environs = [(1:par.nEnvTraining)' tmp];

clear tmp stimOrderObjects stimNr stimType;

%% make repetition suppression display parameters (par.rep_supp.disp)
% Sets of env and random triplets

for r = 1:par.rep_supp.nRuns
    % create of triplet alternation list (all_trls)
    % sample from one env triplet then a random triplet then another
    % env triplet, etc.
    
    % how many times a triplet from each environment is seen (half of all trials divided by the number of environments, divided by 2 to account for the repetitions/runs)
    % par.rep_supp.env_reps = (par.rep_supp.nTotalTriplets/2)/par.nEnvTraining;
    par.rep_supp.env_reps = (par.rep_supp.nTripletsPerRun/2)/par.nEnvTraining;
    
    % will hold the info for all of the repetitions
    par.rep_supp.all_reps = [];
    
    % figure out the order that the environment triads will be seen in
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
    
    clear n r repcheck;
    
    %% Create triplet order
    
    % will hold all of the trials
    % par.rep_supp.all_trls = nan(par.rep_supp.nTotalTriplets,1);
    par.rep_supp.all_trls = nan(par.rep_supp.nTripletsPerRun,1);
    
    % choose whether a random trial or same environment trial is first
    % set to alternate the order based on sub #
    %% odd subject numbers start with a random triplet
    %% even subject numbers start with an environment triplet
    if mod(header.group,2)==0 % start with an environment triplet
        par.rep_supp.all_trls(1) = par.rep_supp.all_reps(1); % set the first trial
        par.rep_supp.all_reps(1) = []; % remove that item since we just used it
        par.rep_supp.trl_index = 3; % starting position since we set the first few items
    else
        par.rep_supp.trl_index = 2; % start with the second trial since the first is from random environments
    end
    
    % now go through and assign all of the other trials
    while isempty(par.rep_supp.all_reps) == 0
        par.rep_supp.all_trls(par.rep_supp.trl_index) = par.rep_supp.all_reps(1); % set the current trial
        par.rep_supp.all_reps(1) = []; % remove the trial from the possible items
        par.rep_supp.trl_index = par.rep_supp.trl_index + 2; % skip ahead to when the next same environment trials would be
    end
    
    % now we've created a list alternating between nans and env# (all_trls)
    
    par.rep_supp.this_env = nan((par.rep_supp.nEnvTriplets/par.rep_supp.nRuns),1);
    
    % odd subject numbers start with a random triplet
    % even subject numbers start with an environment triplet
    if mod(header.group,2)==0 % start with an environment triplet (even subject #)
        par.rep_supp.this_env = par.rep_supp.all_trls(1,1); % set the first trial
        this_tripletType = randomized_envTriplets{par.rep_supp.this_env}(1);
        show_these_triplets = env_triplets{par.rep_supp.this_env}(this_tripletType,:);
        randomized_envTriplets{par.rep_supp.this_env}(1) = [];
    else
        par.rep_supp.this_env = par.rep_supp.all_trls(2,1); % start with the second trial since the first is from random environments (odd subject #)
    end

%%%%%%
% create triplet types - ABC, ABD, ACD, BCD, Random
% each row represents stimuli for that triplet type for each of the 6 envs (row 1 is the
% stimuli # for the objects in env 1)

    par.rep_supp.currABCTriplets = repmat(header.Environs(header.Environs(:,2)==1,6:8),1); % puts the stimuli numbers in from header.Environs
    par.rep_supp.currABDTriplets = repmat(header.Environs(header.Environs(:,2)==1,[6:7,9]),1); 
    par.rep_supp.currACDTriplets = repmat(header.Environs(header.Environs(:,2)==1,[6,8:9]),1);
    par.rep_supp.currBCDTriplets = repmat(header.Environs(header.Environs(:,2)==1,[7:9]),1);

    % create Random triplets

    stimTriplets = repmat([1:par.rep_supp.nStim]',2,1);

    triplets = repmat(stimTriplets,1,3); % numbers for the triplets

    bigCheck = 0;
    while bigCheck == 0

        % shuffles the triplet list of numbers
        envTripletsShuffled = Shuffle(triplets);

        % check for repetitions
        repcheck = 0;
        for row = 1:length(envTripletsShuffled)

            if size(unique(envTripletsShuffled(row,:)),2) == 3
                repcheck = repcheck + 1;
            end

        end

        if repcheck == length(envTripletsShuffled)
            bigCheck = 1;
        end

    end

    clear n r repcheck bigCheck row;

    par.rep_supp.currRandTriplets = envTripletsShuffled;

    clear f triplet_list stimTriplets triplets shuffle_idx envTripletsShuffled
    
% these commented sections created triplet types that were also randomized.
% but since each type will only be seen 6 times (6 env x 4 triplet types =
% 24 env triplets per run) there's no need to randomize them. 
%     % create ABC triplets
%     par.rep_supp.currABCTriplets = cell(1,1);
%     
%     for f = 1:length(par.rep_supp.currABCTriplets)
%         
%         stimTriplets = repmat(header.Environs(header.Environs(:,2)==1,6:8),1); % puts the stimuli numbers in from header.Environs
%         
%         triplets = repmat(stimTriplets,2,1); % numbers for the triplets
%                 
%         repcheck = 1;
%         while repcheck > 0
%             
%             % randomize the order
%             shuffle_idx = randperm(length(triplets))';
%             envTripletsShuffled = triplets(shuffle_idx,:); % shuffles the triplet list of numbers
%             
%             % check for repetitions
%             repcheck = 0;
%             for n = 2:length(envTripletsShuffled)
%                 if envTripletsShuffled(n) == envTripletsShuffled(n-1)
%                     repcheck = repcheck + 1;
%                 end
%             end %end for
%         end %end while
%         
%         clear n r repcheck;
% 
%       par.rep_supp.currABCTriplets{f} = envTripletsShuffled;
%                 
%     end
%     
%     clear f triplet_list stimTriplets triplets shuffle_idx envTripletsShuffled
%     
%     % create ABD triplets
%     par.rep_supp.currABDTriplets = cell(1,1);
%     
%     for f = 1:length(par.rep_supp.currABDTriplets)
%         
%         stimTriplets = repmat(header.Environs(header.Environs(:,2)==1,[6:7,9]),1); % puts the stimuli numbers in from header.Environs
%         
%         triplets = repmat(stimTriplets,2,1); % numbers for the triplets
%         
%         repcheck = 1;
%         while repcheck > 0
%         
%             % randomize the order
%             shuffle_idx = randperm(length(triplets))';
%             envTripletsShuffled = triplets(shuffle_idx,:); % shuffles the triplet list of numbers 
%         
%             % check for repetitions
%             repcheck = 0;
%             for n = 2:length(envTripletsShuffled)
%                 if envTripletsShuffled(n) == envTripletsShuffled(n-1)
%                     repcheck = repcheck + 1;
%                 end
%             end %end for
%         end %end while
%         
%         clear n r repcheck;
%         
%     par.rep_supp.currABDTriplets{f} = envTripletsShuffled;
%     
%     end
%     
%     clear f triplet_list stimTriplets triplets shuffle_idx envTripletsShuffled
%     
%     % create ACD triplets
%     par.rep_supp.currACDTriplets = cell(1,1);
%     
%     for f = 1:length(par.rep_supp.currACDTriplets)
%         
%         stimTriplets = repmat(header.Environs(header.Environs(:,2)==1,[6,8:9]),1);
%         
%         triplets = repmat(stimTriplets,2,1); % numbers for the triplets
%         
%         repcheck = 1;
%         while repcheck > 0
%         
%             % randomize the order
%             shuffle_idx = randperm(length(triplets))';
%             envTripletsShuffled = triplets(shuffle_idx,:); % shuffles the triplet list of numbers 
%         
%             % check for repetitions
%             repcheck = 0;
%             for n = 2:length(envTripletsShuffled)
%                 if envTripletsShuffled(n) == envTripletsShuffled(n-1)
%                     repcheck = repcheck + 1;
%                 end
%             end %end for
%         end %end while
%         
%         clear n r repcheck;
%         
%     par.rep_supp.currACDTriplets{f} = envTripletsShuffled;
%     
%     end
%     
%     clear f triplet_list stimTriplets triplets shuffle_idx envTripletsShuffled
%     
%     % create BCD triplets
%     par.rep_supp.currBCDTriplets = cell(1,1);
%     
%     for f = 1:length(par.rep_supp.currBCDTriplets)
%         
%         stimTriplets = repmat(header.Environs(header.Environs(:,2)==1,[7:9]),1);
%         
%         triplets = repmat(stimTriplets,2,1); % numbers for the triplets
%         
%         repcheck = 1;
%         while repcheck > 0
%         
%             % randomize the order
%             shuffle_idx = randperm(length(triplets))';
%             envTripletsShuffled = triplets(shuffle_idx,:); % shuffles the triplet list of numbers 
%         
%             % check for repetitions
%             repcheck = 0;
%             for n = 2:length(envTripletsShuffled)
%                 if envTripletsShuffled(n) == envTripletsShuffled(n-1)
%                     repcheck = repcheck + 1;
%                 end
%             end %end for
%         end %end while
%         
%         clear n r repcheck;
%         
%     par.rep_supp.currBCDTriplets{f} = envTripletsShuffled;
%     
%     end
%     
%     clear f triplet_list stimTriplets triplets shuffle_idx envTripletsShuffled  
    
%     % create Random triplets
%     par.rep_supp.currRandTriplets = cell(1,1);
%     
%     for f = 1:length(par.rep_supp.currRandTriplets)
%       
%         stimTriplets = repmat([1:par.rep_supp.nStim]',2,1);
%         
%         triplets = repmat(stimTriplets,1,3); % numbers for the triplets
% 
%         bigCheck = 0;
%         while bigCheck == 0
%             
%             % shuffles the triplet list of numbers
%             envTripletsShuffled = Shuffle(triplets);
%             
%             % check for repetitions
%             repcheck = 0;
%             for row = 1:length(envTripletsShuffled)
%                 
%                 if size(unique(envTripletsShuffled(row,:)),2) == 3
%                     repcheck = repcheck + 1;
%                 end
%                 
%             end
%             
%             if repcheck == length(envTripletsShuffled)
%                 bigCheck = 1;
%             end
%             
%         end
%         
%         clear n r repcheck bigCheck row;
%         
%     par.rep_supp.currRandTriplets{f} = envTripletsShuffled;
%     
%     end
%     
%     clear f triplet_list stimTriplets triplets shuffle_idx envTripletsShuffled
%     
    %%% YOU STOPPED HERE! 
    % the triplets for each type are made.  all_trls is a list that
    % alternates between random or env triplets based on subj #.  all_trls
    % can be used as a key for which env triplet to insert.
    % now put the triplets and all_trls into a list -
    % cell(par.rep_supp.nTripletsPerRun,4) - tripletsStim and all_trls
    % because you commented out above all of the triplet stim types are
    % listed by env (rows = env 1-6), so you could put all the env 1
    % triplet types together (row 1 of the four types) and then pull from
    % that any time there's a 1 in all_trls.  just pull from random when
    % there's a nan (isnan). 
    % you want to ensure that for each time an environment is called in
    % all_trls, you're pulling from a different triplet type.  
    
    
    % onset (time trial shows up)
    ons = (((1:par.rep_supp.nTripletsPerRun/3)-1) * par.rep_supp.trialTime)'; % need help with this need to put fix time in there - like a trial time addition based on assigned fixTime
    
    par.rep_supp.disp{r} = [ons [par.rep_supp.currABCTriplets; par.rep_supp.currABDTriplets; par.rep_supp.currACDTriplets; par.rep_supp.currBCDTriplets; par.rep_supp.currRandTriplets] par.rep_supp.all_trls];
    % par.rep_supp.triplets{r} = [ons [shuffABC; shuffABD; shuffACD; shuffBCD; shuffRand] tripletType];

end

clear ons tmp pairOrder studyPairType currPairs check* maxIntermixedNr minIntermixedNr i r;

par.rep_supp.dispCols = {'onset', 'triadNr', 'trainType', 'stimTypeA', 'stimTypeB', 'stimTypeC', 'stimTypeD', 'stimNumberA', 'stimNumberB',...
    'stimNumberC', 'stimNumberC', 'tripletType'};

%% make par.rep_supp.fixTime - this may need to go above
% Sets of pseudorandom fixation times for the rep suppression display

for rep = 1:par.rep_supp.nRuns
    %fixTmp{rep} = [par.rep_supp.disp; par.rep_supp.disp; par.rep_supp.disp];

    fixNr{rep} = [ones(par.rep_supp.nStimPerRun * .4,1); ones(par.rep_supp.nStimPerRun * .4,1)*2; ones((par.rep_supp.nStimPerRun * .2)+1,1)*3]; % numbers didn't work out evenly so I added one more 6s trial

    fixation = Shuffle(fixNr{rep});

    % matches stimuli with correct fixation
    fixOrder(fixation==1,1) = par.rep_supp.fixTimeA;
    fixOrder(fixation==2,1) = par.rep_supp.fixTimeB;
    fixOrder(fixation==3,1) = par.rep_supp.fixTimeC;
    
    par.rep_supp.fixTime = fixOrder;

end


clear rep fixNr fixation fixOrder;

%% make config.txt parameters

% stimuli assignments
par.config.stimOrderObjects = [header.Environs(1,6:9), header.Environs(2,6:9), header.Environs(3,6:9), header.Environs(4,6:9), header.Environs(5,6:9), header.Environs(6,6:9), repmat([25 26 27 28],1,1)];


%%%%%%%
% practice phase
% practice environment - always 6 (volcano world)

% blocked - 16 trials (one exposure) + one test with 4 trials
par.config.env_prac_study = cell(1,1);

par.config.env_prac_study{1} = repmat(6,1,16);

par.config.env_prac_test = cell(1,1);

par.config.env_prac_test{1} = repmat(6,1,4);

% object spawns - which object is tested
par.config.obj_prac_quads = cell(1,4);

par.config.obj_prac_quads{1} = repmat(zeros,1,4);
par.config.obj_prac_quads{2} = repmat(ones,1,4);
par.config.obj_prac_quads{3} = repmat(2,1,4);
par.config.obj_prac_quads{4} = repmat(3,1,4);

par.config.obj_prac_shuffle = Shuffle(par.config.obj_prac_quads);
par.config.obj_prac_study = par.config.obj_prac_shuffle;

par.config.obj_prac_test = cell(1,1);

par.config.obj_prac_test{1} = Shuffle(0:3);
   
% player spawns - three times for each
% blocked and interleaved - 16 blocked trials + 4 interleaved = 20 trials
par.config.player_prac_study_quads = cell(1,4);

for r = 1:length(par.config.player_prac_study_quads);
    
    par.config.player_prac_study_quads{r} = Shuffle(0:3);
    
end

par.config.player_prac_test_quads = cell(1,1);

for q = 1:length(par.config.player_prac_test_quads);
    
    par.config.player_prac_test_quads{q} = Shuffle(0:3);
    
end

%player output
par.config.player_prac_study = par.config.player_prac_study_quads;
par.config.player_prac_test = par.config.player_prac_test_quads;

clear r q


%%%%%%%
% study phase
% study environments

% blocked - 96 trials
par.config.env_study_blocked = cell(1,6);

par.config.env_study_blocked{1} = repmat(zeros,1,16);
par.config.env_study_blocked{2} = repmat(ones,1,16);
par.config.env_study_blocked{3} = repmat(2,1,16);
par.config.env_study_blocked{4} = repmat(3,1,16);
par.config.env_study_blocked{5} = repmat(4,1,16);
par.config.env_study_blocked{6} = repmat(5,1,16);

par.config.study_blockedEnv = Shuffle(par.config.env_study_blocked);

% interleaved - 24 trials
par.config.env_study_interleavedTest = cell(1,6);

par.config.env_study_interleavedTest{1} = repmat(zeros,1,4);
par.config.env_study_interleavedTest{2} = repmat(ones,1,4);
par.config.env_study_interleavedTest{3} = repmat(2,1,4);
par.config.env_study_interleavedTest{4} = repmat(3,1,4);
par.config.env_study_interleavedTest{5} = repmat(4,1,4);
par.config.env_study_interleavedTest{6} = repmat(5,1,4);

% put all the env values into one cell
par.config.env_study_list = cat(2,par.config.env_study_interleavedTest{:});

% repcheck = 1;
%     while repcheck > 0
%
%         % randomize the order
%         env_study_list = Shuffle(env_study_list);
%
%         % check for repetitions
%         repcheck = 0;
%         for n = 2:length(env_study_list)
%             if env_study_list(n) == env_study_list(n-1)
%                 repcheck = repcheck + 1;
%             end
%         end %end for
%     end %end while
%
%     clear n r repcheck;
%
% study_interleavedEnv{1} = env_study_list;
%

% object spawns - which object is tested
% blocked and interleaved - 96 blocked trials + 24 interleaved = 120 trials
par.config.obj_study_quads = cell(1,4);

par.config.obj_study_quads{1} = repmat(zeros,1,4);
par.config.obj_study_quads{2} = repmat(ones,1,4);
par.config.obj_study_quads{3} = repmat(2,1,4);
par.config.obj_study_quads{4} = repmat(3,1,4);

par.config.obj_study_shuffle = Shuffle(par.config.obj_study_quads);
par.config.study_blockedObj = repmat(par.config.obj_study_shuffle,1,6);

par.config.obj_study_interleavedQuads = cell(1,6);

for q = 1:length(par.config.obj_study_interleavedQuads)
    par.config.obj_studyQuads{q} = (0:3);
end

% put all the obj values into one cell
par.config.obj_study_list = cat(2,par.config.obj_studyQuads{:});

% pair object with environment
par.config.env_obj_pairs_study = [par.config.env_study_list; par.config.obj_study_list];
shuffle_idx = randperm(length(par.config.env_obj_pairs_study));
shuffled_obj = par.config.env_obj_pairs_study(:,shuffle_idx);
par.config.study_interleavedEnv = shuffled_obj(1,:);
par.config.study_interleavedObj = shuffled_obj(2,:);

% environment output
%par.config.study_Env = {par.config.study_blockedEnv {par.config.study_interleavedEnv}};
par.config.study_Env = par.config.study_blockedEnv;
par.config.study_test_Env = {par.config.study_interleavedEnv};

% player spawns - three times for each
% blocked and interleaved - 96 blocked trials + 24 interleaved = 120 trials
% for learning
par.config.player_study_quads = cell(1,24);

for r = 1:length(par.config.player_study_quads);
    
    par.config.player_study_quads{r} = Shuffle(0:3);
    
end

%for learning test (interleaved portion)
par.config.player_study_test_quads = cell(1,6);

for r = 1:length(par.config.player_study_test_quads);
    
    par.config.player_study_test_quads{r} = Shuffle(0:3);
    
end

%player output
par.config.player_study = par.config.player_study_quads;
par.config.player_study_test = par.config.player_study_test_quads;

%object output
%par.config.obj_study = {par.config.study_blockedObj {par.config.study_interleavedObj}};
par.config.obj_study = par.config.study_blockedObj;
par.config.obj_study_test = {par.config.study_interleavedObj};

clear q n r shuffle_idx shuffled_obj


%%%%%%%
% test phase
% interleaved - 24 trials
par.config.env_test_interleaved = cell(1,6);

par.config.env_test_interleaved{1} = repmat(zeros,1,4);
par.config.env_test_interleaved{2} = repmat(ones,1,4);
par.config.env_test_interleaved{3} = repmat(2,1,4);
par.config.env_test_interleaved{4} = repmat(3,1,4);
par.config.env_test_interleaved{5} = repmat(4,1,4);
par.config.env_test_interleaved{6} = repmat(5,1,4);

par.config.test_Env_list = cat(2,par.config.env_test_interleaved{:});

% repcheck = 1;
%     while repcheck > 0
% 
%         % randomize the order
%         par.config.test_Env_list = Shuffle(par.config.test_Env_list);
% 
%         % check for repetitions
%         repcheck = 0;
%         for n = 2:length(par.config.test_Env_list)
%             if par.config.test_Env_list(n) == par.config.test_Env_list(n-1)
%                 repcheck = repcheck + 1;
%             end
%         end %end for
%     end %end while
% 
%     clear n r repcheck;

% player spawns
par.config.player_test_quads = cell(1,6);

for r = 1:length(par.config.player_test_quads)
    
    par.config.player_test_quads{r} = Shuffle(0:3);
    
end

par.config.player_test = par.config.player_test_quads;

% object spawns
par.config.obj_test_quads = cell(1,6);

for u = 1:length(par.config.obj_test_quads)
    
    par.config.obj_test_quads{u} = Shuffle(0:3);
    
end

par.config.obj_test_list = cat(2,par.config.obj_test_quads{:});

% pair object with environment during the test phase
par.config.env_obj_pairs_test = [par.config.test_Env_list; par.config.obj_test_list];
shuffle_idx = randperm(length(par.config.env_obj_pairs_test));
shuffled_obj = par.config.env_obj_pairs_test(:,shuffle_idx);
par.config.test_interleavedEnv = shuffled_obj(1,:);
par.config.test_interleavedObj = shuffled_obj(2,:);

par.config.env_test = par.config.test_interleavedEnv;

par.config.obj_test = par.config.test_interleavedObj;

clear n q r u x shuffle_idx shuffled_obj;

%% Display (Pre- and Post-Scan)

for rep = 1:par.disp.nRepsPerRun
    dispTmp{rep} = [header.Environs; header.Environs; header.Environs; header.Environs];
    
    dispType{rep} = [ones(par.nEnvTraining,1); ones(par.nEnvTraining,1)*2; ones(par.nEnvTraining,1)*3; ones(par.nEnvTraining,1)*4];
    
    dispStimuli{rep} = [dispTmp{rep} dispType{rep}];
end

clear rep
% add NaNs back in randomly :;
% nan(par.disp.nNullTrials,size(header.Environs,2));
% nan(par.nEnvTraining,1);

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

stimPrNr = nan(par.nEnvTraining,4); % 6 rows for the practice environments, with 4 objects

stimPrType = repmat([1 1 1 1], par.nEnvTraining,1);

stimOrderPrObjects = Shuffle(1:(par.nEnvTraining*4));

% mataches stimuili with correct environment quad, novel objects
stimPrNr(stimPrType==1) = stimOrderPrObjects;

tmp = [stimPrType stimPrNr];
header.practice.Environs = [(1:par.nEnvTraining)' tmp];

clear tmp stim* ;

%% make practice.disp 

dispPrTmp = [repmat(header.Environs,4,1); nan(par.practice.disp.nNullTrials,size(header.Environs,2))]; %not quite sure about the 2

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


%% Save header

header.parameters = par;

savefname = sprintf('%s/%s_header_%d_%s',header.path.subNr,expName,header.subNr,header.subInit);
save(savefname,'header');

disp('---------------');
disp('Header is ready for use.')
disp(sprintf('Please continue to free roam followed by calling %s_config(header,taskNr)',expName))

clear par expName ans savefname;