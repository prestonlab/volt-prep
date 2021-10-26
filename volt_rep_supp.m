% 12/21/2015: press 5 before starting scanner to move from "Object Preference Task"
%             to fixation cross (have participant fixate during ref lines)
%             scanner should trigger experiment as normal!!!
           

function data = volt_rep_supp(header,runNr)

%% Setup 

par = header.parameters;
expName = 'volt';
data = struct('subNr', header.subNr);
data.Environs = header.Environs;
data.dispStim = header.rep_supp.disp{runNr};
data.actualOnsets = nan(par.rep_supp.nStimPerRun,1);
data.RT = nan(par.rep_supp.nStimPerRun,1);
data.resp = nan(par.rep_supp.nStimPerRun,1);

allowedRespTime = 3; % # of seconds in which the participant can respond

% Set response options
oneKey = KbName('1!'); % button to output 1
twoKey = KbName('2@'); % button to output 2
threeKey = KbName('3#'); % button to output 3
fourKey = KbName('4$'); % button to output 4

posskeys = [oneKey twoKey threeKey fourKey];

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
%dev = extKeys; % change this line to intKeys for running in the lab
dev = intKeys; % change this line to extKeys for running in the scanner

%% Preload all stimuli
namepattern = [header.path.stim 'object_%03d.jpg'];
obj_stim = cell(par.rep_supp.nStimPerRun,1); 
for t=1:par.rep_supp.nStimPerRun % for each stimuli
    % envNumber = header.rep_supp.disp{runNr}(t,3); % environment numbers
    stimNr = header.rep_supp.disp{runNr}(t,4); % stimuli numbers
    for obj = 1:length(stimNr)
        stimfname = sprintf(namepattern,stimNr(obj));
        obj_stim{t,obj} = imread(stimfname);    
    end
end
data.stimNamePattern = namepattern;

%% %% Create output text file
outfname = sprintf('%s/%s_dispRS_%d_%s_run_%d',header.path.subNr,header.exp,header.subNr,header.subInit,runNr);
if exist([outfname '.txt'],'file') == 2
    error('The data file for this scan already exists.  Please check your input parameters.');
end

formatString = '%0.1f\t%0.1f\t%d\t%d\t%d\t%d\t%d\t%0.3f\n';
fid=fopen([outfname '.txt'], 'w'); % open the file
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',...
    'onset (s)','fixation','envCode','stimNmbr','envNmbr','ObjNmbr','Resp','RT'); %Create header

%% Open up the screen
oldEnableFlag = Screen('Preference','SuppressAllWarnings');
Screen('Preference', 'VisualDebugLevel', 1);
Screen('Preference', 'SkipSyncTests', 2); % will not show warning screen
[par.window, par.screenRect] = Screen(0, 'OpenWindow', par.backColor); % change depending on screen output (either 0 or 1)
[monitorFlipInterval] = Screen(par.window,'GetFlipInterval'); % gets the refresh time / monitor flip interval, to be used in calculating onsets below
par.xc = par.screenRect(3)/2;
par.yc = par.screenRect(4)/2;
par.xct = par.xc - par.txtSize/3; % center of screen for text
par.yct = par.yc - par.txtSize/3; % center of screen for text
Screen(par.window, 'TextSize', par.txtSize);
Screen(par.window, 'TextFont', 'Arial');
HideCursor;

% Display run number -- PRESS 5 MANUALLY TO GET FIXATION FOR REFERENCE LINES 
repText = sprintf('Object Preference Task: Run %d',runNr);
Screen('TextSize',par.window,par.txtSize);
[normBoundsRect_repText,offsetBoundsRects_repText] = Screen('TextBounds',par.window,repText);
xcreptext = par.xc - normBoundsRect_repText(3)/2;
  
Screen(par.window, 'DrawText', repText, xcreptext, par.yc, par.txtColor);
Screen(par.window, 'Flip');

clear keyCode;
clear keyIsDown;

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

% Flip fixation on screen
Screen(par.window, 'TextSize', par.numSize);
Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);
Screen(par.window, 'Flip');
    
%% Loop through all trials
 for t = 1:par.rep_supp.nStimPerRun

    % Get trial onset
    ontime = data.dispStim(t,1);
    
    fixation = data.dispStim(t,2);
    
    envNr = data.dispStim(t,3);
    
    img = obj_stim{t,1};
        
    %% Stimulus with black fixation
    % Make texture for current trial presentation
    stim = Screen(par.window,'MakeTexture',img);
    
    % Draw current trial image to buffer with fixation superimposed
    Screen(par.window, 'DrawTexture',stim);
    Screen(par.window, 'TextSize', par.numSize);
    Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);
    
    % Calculate presentation onset
    stimtime = startTime + ontime; 
    
    % Flip presentation of image to screen at correct onset
    Screen(par.window,'Flip',stimtime);
    
   % Draw fixation to buffer 
    Screen(par.window, 'TextSize', par.numSize);
    Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor); 

    % Calculate fixation onset
    fixtime = stimtime + par.rep_supp.stimTime;
         
    %% flip fixation to screen
    Screen(par.window,'Flip',fixtime);

    % Calculate allowed response time
    resptime = stimtime + allowedRespTime;
    
    % get response and RTs
    resp = [];

    while GetSecs < resptime
        [keyIsDown, ~, keyCode] = KbCheck; %check for key response
        if keyIsDown
            if keyCode(oneKey)
                resp = 1;
                respstop = GetSecs;
                break;
            elseif keyCode(twoKey)
                resp = 2;
                respstop = GetSecs;
                break;
            elseif keyCode(threeKey)
                resp = 3;
                respstop = GetSecs;
                break;
            elseif keyCode(fourKey)
                resp = 4;
                respstop = GetSecs;
                break;
            end %end of keycode check
        end  %end of kbcheck
    end %end of while
       
    % black fixation alone
    Screen(par.window, 'TextSize', par.numSize);
    Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);

    %% save responses    
    % assign RT and fixation response if participant didn't respond in time
    if isempty(resp)
        resp = nan;
        rt = nan;
    else
        rt = respstop - stimtime; % trial RT
    end
    
    % data.resp(t) =  str2double(resp(1));
    data.resp(t) =  resp(1);
	data.RT(t) = rt(1);
    
    % Save trial info to text file
    fprintf(fid, formatString, data.dispStim(t,:), data.resp(t), data.RT(t));
    
end

clear t

while (GetSecs-startTime) <= par.rep_supp.trialTime(end)-par.rep_supp.stimTime;
end

WaitSecs(par.bookendFixTime)

% while GetSecs() < scannerStart + 636 % in seconds the timing of the task (hard coded)
% end

% Put relevant info into data structure
data.duration = GetSecs - startTime; % includes end bookend fix time but not beginning
data.endTime = fix(clock);

clear startTime;

%% End experiment

ShowCursor;
Screen('CloseAll');
Screen('Preference','SuppressAllWarnings',oldEnableFlag);
clear screen;

data.parameters = par;
save(outfname,'data');

disp('---------------');
disp(sprintf('Object Preference Task: Run %d completed!',runNr));
disp('---------------');
disp(sprintf('NaNs: %d',sum(isnan(data.resp))));
disp('---------------');
disp(' ');
disp(sprintf('Please continue by calling %s_disp3',expName))
disp('---------------');
disp(' ');

