% 11/27/2012: fixation during reference lines added by MLS
%             press 5 before starting scanner to move from "Detection Task"
%             to fixation cross (have sub fixate during ref lines)
%             scanner should trigger experiment as normal!!!
           

function data = volt_rep_supp(runNr)

clear;
par = struct;
expName = 'volt'; % virtual object learning task 

%% Setup
header.path.exp = pwd; %the path is the current folder
header.path.data = [header.path.exp '/data/']; % for output
header.path.stim = [header.path.exp '/stimuli/'];

%% Load the subject's header (from day 1)
disp(sprintf('This script loads header file from day 1 for %s experiment.',expName));
disp('---------------');
header.subNr = input('Subject Number:  ');
header.subInit = input('Subject Initials:  ', 's');

disp('');
disp('---------------');
disp(''); disp('');
disp('Please make sure this information is correct.');
disp('---------------');
disp(['Subject Nr = ', num2str(header.subNr) ]);
disp([ 'Subject Initials = ',header.subInit]);

disp('---------------');
disp(''); disp('');
yn = input('Is this correct?  (y,n):  ', 's'); % possibly put in loop
if(~isequal(upper(yn(1)), 'Y'))
    return;
end

clear yn

header.path.subNr = [header.path.data sprintf('%d_%s', header.subNr, header.subInit)]; 
header.subInfo = sprintf('%s/%s_header_%d_%s',header.path.subNr,expName,header.subNr,header.subInit);

load(header.subInfo);

%% Setup

par = header.parameters;
data = struct('subNr', header.subNr);
data.Environs = header.Environs;
%data.dispStim = header.disp{runNr};
data.actualOnsets = nan(par.disp.nStimPerRun,1);
data.RT = nan(par.disp.nStimPerRun,1);
data.resp = nan(par.disp.nStimPerRun,1);
%data.correctResp = data.dispStim(:,3);

%% Check for button box
intake=PsychHID('Devices');
extKeys=0;
for n=1:length(intake)
    if (intake(n).productID == 8 && strcmp(intake(n).usageName,'Keyboard')) % UT
        extKeys=n;
    elseif strcmp(intake(n).usageName,'Keyboard')
        intKeys=n;
    end
end
if extKeys==0, disp('No Buttonbox Detected.'); end
% dev = extKeys; % change this line to intKeys for running in the lab
dev = intKeys; % change this line to extKeys for running in the scanner

%% Preload all stimuli
namepattern = [header.path.stim 'object_%03d.jpg'];
obj_stim = cell(par.nEnvTraining, 4);
for t=1:par.nEnvTraining % for each environment
    env = data.Environs(t,:);
    stimType = env(2:5);
    stimNr = env(6:9);
    for obj = 1:4
        stimfname = sprintf(namepattern,stimNr(obj));
        obj_stim{t,obj} = imread(stimfname);    
    end
end
data.stimNamePattern = namepattern;

%% %% Create output text file
outfname = sprintf('%s/%s_rep_supp_%d_%s',header.path.subNr,header.exp,header.subNr,header.subInit);
%outfname = sprintf('%s%s_rep_supp_run%d_%d_%s',header.path.data,header.exp,runNr,header.subNr,header.subInit);
if exist([outfname '.txt'],'file') == 2
    error('The data file for this scan already exists.  Please check your input parameters.');
end

formatString = '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%0.3f\n';
fid=fopen([outfname '.txt'], 'w'); % open the file
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',...
    'onset (s)','relFixFlip (ms)','fixColor','envNr','sTypeA','sTypeB','sTypeC','sTypeD',...
    'env1','env2','env3','env4','stimType','Resp','RT'); %Create header

%% open up the screen
%Screen('Preference', 'SkipSyncTests', 1);
[par.window, par.screenRect] = Screen(1, 'OpenWindow', par.backColor); % change me
[monitorFlipInterval] = Screen(par.window,'GetFlipInterval'); % gets the refresh time / monitor flip interval, to be used in calculating onsets below
par.xc = par.screenRect(3)/2;
par.yc = par.screenRect(4)/2;
par.xct = par.xc - par.txtSize/3; % center of screen for text
par.yct = par.yc - par.txtSize/3; % center of screen for text
Screen(par.window, 'TextSize', par.txtSize);
Screen(par.window, 'TextFont', 'Arial');
HideCursor;

% display run number -- PRESS 5 MANUALLY TO GET FIXATION FOR REFERENCE LINES 
repText = sprintf('Detection Task 1: Run %d',runNr);
Screen('TextSize',par.window,par.txtSize);
[normBoundsRect_repText,offsetBoundsRects_repText] = Screen('TextBounds',par.window,repText);
xcreptext = par.xc - normBoundsRect_repText(3)/2;
  
Screen(par.window, 'DrawText', repText, xcreptext, par.yc, par.txtColor);
Screen(par.window, 'Flip');

clear keyCode;
clear keyIsDown;

pa.TRIGGERED = 0;
while ~pa.TRIGGERED
    [keyIsDown, t, keyCode] = KbCheck(-1);
    if strcmp(KbName(keyCode), '7&')
        pa.TRIGGERED = 1;
    end
end
while KbCheck; end

% fixation for reference lines, trigger happens by scanner
Screen(par.window, 'TextSize', par.numSize);  
Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);
Screen(par.window, 'Flip');

clear keyCode;
clear keyIsDown;
clear t;

pa.TRIGGERED = 0;
while ~pa.TRIGGERED
   [keyIsDown, t, keyCode] = KbCheck(-1);
    if strcmp(KbName(keyCode), '5%')
        pa.TRIGGERED = 1;
    end
end
% to here

scannerStart = GetSecs;
startTime = scannerStart+par.bookendFixTime; 

data.beginTime = fix(clock);

% flip fixation on screen
Screen(par.window, 'TextSize', par.numSize);
Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);
Screen(par.window, 'Flip');

%% you stopped here.  move over data structure from nav_header_w_rep_supp and clean it up!
    
% loop through all study trials
for t = 1:par.disp.nStimPerRun
    
    % get trial onset
    ontime = data.dispStim(t,1);
    
    envNr = data.dispStim(t,4);
    
    switch data.dispStim(t,13);
        case 1 % A
            img = obj_stim{envNr,1};
        case 2 % B
            img = obj_stim{envNr,2};
        case 3 % C
            img = obj_stim{envNr,3};
        case 4 % D
            img = obj_stim{envNr,4};
    end
    
    %% flip 1: stimulus with black fixation
    % make texture for current trial presentation
    stim = Screen(par.window,'MakeTexture',img);
    
    % draw current trial image to buffer with fixation superimposed
    Screen(par.window, 'DrawTexture',stim);
    Screen(par.window, 'TextSize', par.numSize);
    Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);

    % calculate presentation onset
    stimtime = startTime + ontime - monitorFlipInterval/2; % subtract refresh time / 2
    
    % flip presentation of image to screen at correct onset
    on = Screen(par.window,'Flip',stimtime);
    data.actualOnsets(t) = on - startTime;
    
    %% flip 2: stimulus with blue/green fixation
    % draw the colored fixation to buffer
    stim = Screen(par.window,'MakeTexture',img);
    
    Screen(par.window,'DrawTexture',stim);
    Screen(par.window, 'TextSize', par.numSize);
    if data.dispStim(t,3)==1
        Screen(par.window,'DrawText', '+', par.xct, par.yct, [0 0 255]); % make it blue
    else
        Screen(par.window,'DrawText', '+', par.xct, par.yct, [60 179 113]); % make it green 
    end
    
    fixfliptime = stimtime + data.dispStim(t,2)/1000;
  
    %% flip fixation to screen
    on = Screen(par.window,'Flip',fixfliptime);
    
    %% flip 3: blue/green fixation alone
    Screen(par.window, 'TextSize', par.numSize);
    if data.dispStim(t,3)==1
        Screen(par.window,'DrawText', '+', par.xct, par.yct, [0 0 255]); % make it blue
    else
        Screen(par.window,'DrawText', '+', par.xct, par.yct, [60 179 113]); % make it green 
    end
        
    % flips blue/green fixation alone
    [resp rt] = flipkeys(par.disp.stimTime - data.dispStim(t,2)/1000,par.disp.stimTime - data.dispStim(t,2)/1000 + par.disp.fixTime - 0.5,par,dev,on);
    
    data.resp(t) =  str2double(resp(1));
	data.RT(t) = rt(1);
    
    %% flip 4: black fixation alone
    Screen(par.window, 'TextSize', par.numSize);
    Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);

    blackfixtime = stimtime + (par.disp.trialTime-0.5);
    
    Screen(par.window,'Flip',blackfixtime);
    
    % save trial info to text file
    fprintf(fid,formatString,data.dispStim(t,:),data.resp(t),data.RT(t));
      
    % leave fixation on
    tic
    while toc<0.5
    end
    
end

clear t

while (GetSecs-startTime) <= par.disp.nTotalTrials*par.disp.trialTime
end

WaitSecs(par.bookendFixTime)

% put relevant info into data structure
data.duration = GetSecs - startTime; % includes end bookend fix time but not beginning
data.endTime = fix(clock);

clear startTime;

%% End experiment

ShowCursor;
Screen('CloseAll');
clear screen;


data.parameters = par;
save(outfname,'data');

disp('---------------');
disp(sprintf('Detection run %d completed!',runNr));
disp('---------------');
disp(sprintf('NaNs: %d',sum(isnan(data.resp))));
disp(sprintf('Acc: %0.3f',mean(data.resp==data.correctResp)));
disp(sprintf('Acc excl NaNs: %0.3f', mean(data.correctResp(~isnan(data.resp))==data.resp(~isnan(data.resp)))));
disp('---------------');
disp(' ');
