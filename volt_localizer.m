% 12/21/2015: press 5 before starting scanner to move from title screen
%             to fixation cross (have participant fixate during ref lines)
%             scanner should trigger experiment as normal!!!


function data = volt_localizer(header,runNr)

%% Setup

par = header.parameters;
data = struct('subNr', header.subNr,'runNr',runNr);
data.header = header;
data.stim = header.loc.locstim{runNr};
data.onset = header.loc.loconset;
nTrials = size(data.onset,1);
data.resp = nan(nTrials,1);
data.rt = nan(nTrials,1);
data.baseIsCorrect = nan(nTrials,1);

% Set response options
oneKey = KbName('1!'); % button to output 1
twoKey = KbName('2@'); % button to output 2
threeKey = KbName('3#'); % button to output 3
fourKey = KbName('4$'); % button to output 4

posskeys = [oneKey twoKey threeKey fourKey];

% repKey = KbName(par.repKey);
% leftKey = KbName(par.leftKey);
% midKey = KbName(par.midKey);
% rightKey = KbName(par.rightKey);

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
dev = extKeys; % change this line to intKeys for running in the lab
%dev = intKeys; % change this line to extKeys for running in the scanner

%% Load base stim
% Uncommnent these if you need baseline (only use the baseline in the
% localizer if it's the same baseline as used in your task)
% baseStim = cell(1,3);
% baseNamepattern = strcat({header.path.localizer},{'baseline_%d.jpg'}); % change to scene for real thing
% 
% for b = 1:3
% 
%     basestimfname = sprintf(baseNamepattern{1},b);
%     [tmp, ~, ~] = imread(basestimfname);
%     baseStim{1,b} = imresize(tmp,[NaN 500]);
%     
% end
%% Create output text file
outfname = sprintf('%s/%s_localizer_%d_%s_run_%d',header.path.subNr,header.exp,header.subNr,header.subInit,runNr);
if exist([outfname '.txt'],'file') == 2
    error('The data file for this scan already exists.  Please check your input parameters.');
end

formatString = '%d\t%d\t%d\t%d\t%d\t%d\t%0.3f\t%d\n';
fid=fopen([outfname '.txt'], 'w'); % open the file
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',...
    'blockNmbr','stimType','stimNmbr','isTarget','RespKey','Resp','RT','Accuracy'); %Create header

%% open up the screen
oldEnableFlag = Screen('Preference','SuppressAllWarnings');
Screen('Preference', 'VisualDebugLevel', 1);
Screen('Preference', 'SkipSyncTests', 2); % will not show warning screen
[par.window, par.screenRect] = Screen(1, 'OpenWindow', par.backColor); % change depending on screen output (either 0 or 1)
[monitorFlipInterval] = Screen(par.window,'GetFlipInterval'); % gets the refresh time / monitor flip interval, to be used in calculating onsets below
par.xc = par.screenRect(3)/2;
par.yc = par.screenRect(4)/2;
par.xct = par.xc - par.txtSize/3; % center of screen for text
par.yct = par.yc - par.txtSize/3; % center of screen for text
Screen(par.window, 'TextSize', par.txtSize);
Screen(par.window, 'TextFont', 'Arial');
HideCursor;

% Display run number -- PRESS 5 MANUALLY TO GET FIXATION FOR REFERENCE LINES 
repText = sprintf('Scene repeat task: Run %d',runNr);
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

% Flip fixation on screen
Screen(par.window, 'TextSize', par.numSize);
Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);
Screen(par.window, 'Flip');

%% Loop through all trials

for t=1:nTrials
    
    ontime = data.onset(t,1);
    
    % if it's a baseline trial
    if data.stim(t,2)==5
        
        % Add the following commented lines back in for baseline images
        % img = baseStim{1,data.stim(t,3)};
        
        % Make texture for current trial presentation
        % stim = Screen(par.window,'MakeTexture',img);
        
        % Draw current trial image to buffer with fixation superimposed
        % Screen(par.window, 'DrawTexture',stim);
        Screen(par.window, 'TextSize', par.numSize);
        Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);
        
        % Calculate presentation onset
        stimtime = startTime + ontime; 
        
        % Flip presentation of image to screen at correct onset
        Screen(par.window,'Flip',stimtime);
        %data.onset(t) = on - startTime;
        
%         % Draw fixation to buffer
%         Screen(par.window, 'TextSize', par.numSize);
%         Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);
%         
%         % Calculate fixation onset
%         fixtime = stimtime + par.loc.stimTime;
%         
%         % Flip fixation to screen
%         Screen(par.window,'Flip',fixtime);
%                 
        % set accuracy to a NaN because there is no response 
        acc(t) = NaN;
        
        % save trial info to text file - shouldn't be anything to save
        % during baseline; it's passive rest
        fprintf(fid, formatString, data.stim(t,:), data.resp(t), data.rt(t), acc(t));
           
    % show a scene block
    else
        
        type = data.stim(t,2);
        switch type
            case 1, prefix = 'desert_';
            case 2, prefix = 'basketball_';
            case 3, prefix = 'forest_';
            case 4, prefix = 'castle_';
%             case 5, prefix = 'factory_';
%             case 6, prefix = 'snow_';
%             case 7, prefix = 'baseline_';
        end
        fname = sprintf('%s%s%03d.jpg',header.path.localizer,prefix,data.stim(t,3));
        tmp = imread(fname);
        img = imresize(tmp,[400 NaN]);
        
        % Make texture for current trial presentation
        stim = Screen(par.window,'MakeTexture',img);
        
        % Draw current trial image to buffer 
        Screen(par.window, 'DrawTexture',stim);
        % To superimpose fixation, add these two lines
        % Screen(par.window, 'TextSize', par.numSize);
        % Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);
        
        % calculate presentation onset
        stimtime = startTime + ontime; 
        
        % flip presentation of image to screen at correct onset
        Screen(par.window,'Flip',stimtime);
        %data.onset(t) = on - startTime;
        
        % No fixation + if not using fixation over stimuli
        % Draw fixation to buffer
%         Screen(par.window, 'TextSize', par.numSize);
%         Screen(par.window, 'DrawText', '+', par.xct, par.yct, par.fixColor);
        
        % calculate fixation onset
        fixtime = stimtime + par.loc.stimTime;
        
        % get response and RTs
        resp = [];
        while GetSecs < fixtime
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
                end %end of keycode check
            end  %end of kbcheck
        end %end of while
        
        % flip fixation to screen
        Screen(par.window,'Flip',fixtime);
        
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
        data.rt(t) = rt(1);
        
        % calculate accuracy
        if resp == data.stim(t,5) %correct response
            acc = 1;
        else
            acc = 0;
        end
        
        acc(t) = acc;
        
        % save trial info to text file
        fprintf(fid, formatString, data.stim(t,:), data.resp(t), data.rt(t), acc(t));

    end  
end

clear t b;

WaitSecs(par.loc.unitTime) % wait for last null trial

WaitSecs(par.bookendFixTime)

% while GetSecs() < scannerStart + 472 % in seconds the timing of the task (hard coded)
% end

% Put relevant info into data structure
data.duration = GetSecs-startTime; % includes only task time
data.endTime = fix(clock);

clear startTime;

% % Pause to keep the baseline on screen for the right time
% closetime = startTime + par.runTime-par.bookendFixTime;
% WaitSecs('UntilTime',closetime);

% welcomeText = sprintf('Repeat %d finished. Great job!',runNr);
% Screen('TextSize',par.window,par.txtSize);
% center_text(par.window,welcomeText,par.txtColor);
% Screen(par.window, 'Flip');

%% End experiment

ShowCursor;
Screen('CloseAll');
Screen('Preference','SuppressAllWarnings',oldEnableFlag);
clear screen;

data.parameters = par;
save(outfname,'data');

% % save scan data to file
% data.nTarget = sum(data.stim(:,4)==1);
% data.nMissedTarget = sum(data.stim(:,4)==1 & data.resp~=1);
% data.pctBaseNan = sum(isnan(data.resp(isnan(data.stim(:,4)))))/sum(isnan(data.stim(:,4)));
% data.baseacc = nanmean(data.baseIsCorrect(data.stim(:,2)==7));

disp('---------------');
disp(sprintf('Scene repeat task: Run %d completed!', runNr));
disp('---------------');
disp(sprintf('# of Repeats: %d',sum(data.stim(:,4)==1)));
disp(sprintf('# of Missed Repeats: %d',sum(data.stim(:,4)==1 & data.resp~=1)));
% disp(sprintf('Base Accuracy: %0.2f', nanmean(data.baseIsCorrect(data.stim(:,2)==7))));
disp('---------------');
disp(' ');
