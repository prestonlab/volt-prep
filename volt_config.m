% 6/23/2015: this script creates the config.txt file to be read by the
% build for all phases (except free roam) of the navigation task.

% 4/13/2016 v2 three learning runs, no learning test

% 9/7/2016 v3 free roam added to the config file, now only 4 env

% taskNr  
% 1 = free roam
% 2 = practice - volcano env 
% 3 = practice test - volcano env 
% 4 = learning run1 
% 5 = learning run2
% 6 = learning run3
% 7 = test
           

function data = volt_config(header,taskNr)

%% Setup

par = header.parameters;
data = struct('subNr', header.subNr);
data.Environs = header.Environs;

%header.fid = fopen('config.txt','w');

%% uncomment before running to keep from overwriting file
% if exist('config.txt','file') == 2
%     error('The data file for this scan already exists.  Please check your input parameters. Do not overwrite.');
% end

if taskNr == 1 % free roam
    
    header.fid = fopen('volt_free_roam.txt','w');
    
    % print out the subject number
    fprintf(header.fid, '%d\n', par.train.subNr);
    
    % print out subject initials
    fprintf(header.fid, '%s\n', par.train.subInit);
    
    % print out success radius
    fprintf(header.fid, '%d\n', par.freeroam.successRadius);
    
    % print out movement speed
    fprintf(header.fid, '%d\n', par.freeroam.movementSpeed);
    
    %print out whether learning or testing phase (0 = learning; 1 = free roam; 2 =
    %testing); same for practice and task
    fprintf(header.fid, '%d\n', 1);
    
    % print out default (max) time in study period - will cut to next "trial" after x
    % seconds
    fprintf(header.fid, '%d\n', par.freeroam.freeTime);
    
    % print out default object display time
    fprintf(header.fid, '%d\n', par.freeroam.objDisplayTime);
    
    % print out object assignments
    nObjects = length(par.config.stimOrderObjects);
    format = '%d ';
    stringformat = repmat(format, 1, nObjects);
    stringformat(end:end+1) = '\n';
    
    fprintf(header.fid, stringformat, par.config.stimOrderObjects);
    
    clear nObjects stringformat format
    
    % print the environment parameters
    nEnvs = length(par.config.freeEnv);
    format = '%d ';
    stringformat = repmat(format, 1, nEnvs);
    stringformat(end:end+1) = '\n';
    
    fprintf(header.fid, stringformat, par.config.freeEnv);
    
    clear stringformat format nEnvs
    
    % print the player spawns
    nPlayer = length(par.config.freePlayer);
    format = '%d ';
    stringformat = repmat(format, 1, nPlayer);
    stringformat(end:end+1) = '\n';
    
    fprintf(header.fid, stringformat, par.config.freePlayer);
    
    clear stringformat format nObjs
    
    % print the object spawns
    nObjs = length(par.config.freeObj);
    format = '%d ';
    stringformat = repmat(format, 1, nObjs);
    stringformat(end) = [];
    
    fprintf(header.fid, stringformat, par.config.freeObj);
    
    clear stringformat format nObjs
    
elseif taskNr == 2 % practice study   
    header.fid = fopen('volt_prac_study.txt','w');
    
    % print out the subject number
    fprintf(header.fid, '%d\n', par.train.subNr);
    
    % print out subject initials
    fprintf(header.fid, '%s\n', par.train.subInit);
    
    % print out success radius
    fprintf(header.fid, '%d\n', par.train.successRadius);
    
    % print out movement speed
    fprintf(header.fid, '%d\n', par.train.movementSpeed);
    
    %print out whether learning or testing phase (0 = learning; 2 =
    %testing); same for practice and task
    fprintf(header.fid, '%d\n', 0);
    
    % print out default (max) time in study period - will cut to next "trial" after x
    % seconds
    fprintf(header.fid, '%d\n', par.train.studyTime);
    
    % print out default object display time 
    fprintf(header.fid, '%d\n', par.train.objDisplayTimePrac);
    
    % print out object assignments
    nObjects = length(par.config.stimOrderObjects);
    format = '%d ';
    stringformat = repmat(format, 1, nObjects);
    stringformat(end:end+1) = '\n';
    
    fprintf(header.fid, stringformat, par.config.stimOrderObjects);
    
    clear nObjects stringformat format
    
    % print the practice environment parameters
    for a = 1:length(par.config.env_prac_study)
        
        first_layer = par.config.env_prac_study{a};
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.env_prac_study)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    fprintf(header.fid, '\n');
    
    clear a c d first_layer;
    
    % print the practice player spawns
    for a = 1:length(par.config.player_prac_study)
        
        first_layer = par.config.player_prac_study{a};
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.player_prac_study)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    fprintf(header.fid, '\n');
    
    clear a c d first_layer;
    
    % print the practice object spawns
    for a = 1:length(par.config.obj_prac_study)
        
        first_layer = par.config.obj_prac_study{a};
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.obj_prac_study)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    clear a c d first_layer;
    
elseif taskNr == 3 % practice test
    header.fid = fopen('volt_prac_test.txt','w');
    
    % print out the subject number
    fprintf(header.fid, '%d\n', par.train.subNr);
    
    % print out subject initials
    fprintf(header.fid, '%s\n', par.train.subInit);
    
    % print out success radius
    fprintf(header.fid, '%d\n', par.train.successRadius);
    
    % print out movement speed
    fprintf(header.fid, '%d\n', par.train.movementSpeed);
    
    %print out whether learning or testing phase (0 = learning; 2 =
    %testing); same for practice and task
    fprintf(header.fid, '%d\n', 2);
    
    % print out default time (max) in test period - will cut to next "trial" after x
    % seconds
    fprintf(header.fid, '%d\n', par.train.testTime);
    
    % print out default object display time 
    fprintf(header.fid, '%d\n', par.train.objDisplayTimePrac);
    
    % print out object assignments
    nObjects = length(par.config.stimOrderObjects);
    format = '%d ';
    stringformat = repmat(format, 1, nObjects);
    stringformat(end:end+1) = '\n';
    
    fprintf(header.fid, stringformat, par.config.stimOrderObjects);
    
    clear nObjects stringformat format
    
    % print the practice test environment parameters
    for a = 1:length(par.config.env_prac_test)
        
        first_layer = par.config.env_prac_test{a};
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.env_prac_test)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    fprintf(header.fid, '\n');
    
    clear a c d first_layer;
    
    % print the practice test player spawns
    for a = 1:length(par.config.player_prac_test)
        
        first_layer = par.config.player_prac_test{a};
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.player_prac_test)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    fprintf(header.fid, '\n');
    
    clear a c d first_layer;
    
    % print the practice test object spawns
    for a = 1:length(par.config.obj_prac_test)
        
        first_layer = par.config.obj_prac_test{a};
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.obj_prac_test)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    clear a c d first_layer;
    
elseif taskNr == 4 % learning run1
    header.fid = fopen('volt_learning_run1.txt','w');
    
    % print out the subject number
    fprintf(header.fid, '%d\n', par.train.subNr);
    
    % print out subject initials
    fprintf(header.fid, '%s\n', par.train.subInit);
    
    % print out success radius
    fprintf(header.fid, '%d\n', par.train.successRadius);
    
    % print out movement speed
    fprintf(header.fid, '%d\n', par.train.movementSpeed);
    
    %print out whether learning or testing phase (0 = learning; 2 =
    %testing); same for practice and task
    fprintf(header.fid, '%d\n', 0);
    
    % print out default (max) time in study period - will cut to next "trial" after x
    % seconds
    fprintf(header.fid, '%d\n', par.train.studyTime);
    
    % print out default object display time 
    fprintf(header.fid, '%d\n', par.train.objDisplayTime);
    
    % print out object assignments
    nObjects = length(par.config.stimOrderObjects);
    format = '%d ';
    stringformat = repmat(format, 1, nObjects);
    stringformat(end:end+1) = '\n';
    
    fprintf(header.fid, stringformat, par.config.stimOrderObjects);
    
    clear nObjects stringformat format
    
    % print the study environment parameters
    for a = 1:length(par.config.study_Env)
        
        first_layer = par.config.learning{1}(1,:);
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.study_Env)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    fprintf(header.fid, '\n');
    
    clear a b c d first_layer
    
    % print the study player spawns
    for a = 1:length(par.config.player_study)
        
        first_layer = par.config.learning{1}(2,:);
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.player_study)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    fprintf(header.fid, '\n');
    
    clear a c d first_layer
    
    % print the study object spawns
    for a = 1:length(par.config.obj_study)
        
        first_layer = par.config.learning{1}(3,:);
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.obj_study)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    % fprintf(header.fid, '\n');
    
    clear a b c d first_layer second_layer;
    
 elseif taskNr == 5 % learning run2
    header.fid = fopen('volt_learning_run2.txt','w');
    
    % print out the subject number
    fprintf(header.fid, '%d\n', par.train.subNr);
    
    % print out subject initials
    fprintf(header.fid, '%s\n', par.train.subInit);
    
    % print out success radius
    fprintf(header.fid, '%d\n', par.train.successRadius);
    
    % print out movement speed
    fprintf(header.fid, '%d\n', par.train.movementSpeed);
    
    %print out whether learning or testing phase (0 = learning; 2 =
    %testing); same for practice and task
    fprintf(header.fid, '%d\n', 0);
    
    % print out default (max) time in study period - will cut to next "trial" after x
    % seconds
    fprintf(header.fid, '%d\n', par.train.studyTime);
    
    % print out default object display time 
    fprintf(header.fid, '%d\n', par.train.objDisplayTime);
    
    % print out object assignments
    nObjects = length(par.config.stimOrderObjects);
    format = '%d ';
    stringformat = repmat(format, 1, nObjects);
    stringformat(end:end+1) = '\n';
    
    fprintf(header.fid, stringformat, par.config.stimOrderObjects);
    
    clear nObjects stringformat format
    
    % print the study environment parameters
    for a = 1:length(par.config.study_Env)
        
        first_layer = par.config.learning{2}(1,:);
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.study_Env)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    fprintf(header.fid, '\n');
    
    clear a b c d first_layer
    
    % print the study player spawns
    for a = 1:length(par.config.player_study)
        
        first_layer = par.config.learning{2}(2,:);
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.player_study)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    fprintf(header.fid, '\n');
    
    clear a c d first_layer
    
    % print the study object spawns
    for a = 1:length(par.config.obj_study)
        
        first_layer = par.config.learning{2}(3,:);
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.obj_study)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    % fprintf(header.fid, '\n');
    
    clear a b c d first_layer second_layer;
    
elseif taskNr == 6 % learning run3
    header.fid = fopen('volt_learning_run3.txt','w');
    
    % print out the subject number
    fprintf(header.fid, '%d\n', par.train.subNr);
    
    % print out subject initials
    fprintf(header.fid, '%s\n', par.train.subInit);
    
    % print out success radius
    fprintf(header.fid, '%d\n', par.train.successRadius);
    
    % print out movement speed
    fprintf(header.fid, '%d\n', par.train.movementSpeed);
    
    %print out whether learning or testing phase (0 = learning; 2 =
    %testing); same for practice and task
    fprintf(header.fid, '%d\n', 0);
    
    % print out default (max) time in study period - will cut to next "trial" after x
    % seconds
    fprintf(header.fid, '%d\n', par.train.studyTime);
    
    % print out default object display time 
    fprintf(header.fid, '%d\n', par.train.objDisplayTime);
    
    % print out object assignments
    nObjects = length(par.config.stimOrderObjects);
    format = '%d ';
    stringformat = repmat(format, 1, nObjects);
    stringformat(end:end+1) = '\n';
    
    fprintf(header.fid, stringformat, par.config.stimOrderObjects);
    
    clear nObjects stringformat format
    
    % print the study environment parameters
    for a = 1:length(par.config.study_Env)
        
        first_layer = par.config.learning{3}(1,:);
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.study_Env)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    fprintf(header.fid, '\n');
    
    clear a b c d first_layer
    
    % print the study player spawns
    for a = 1:length(par.config.player_study)
        
        first_layer = par.config.learning{3}(2,:);
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.player_study)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    fprintf(header.fid, '\n');
    
    clear a c d first_layer
    
    % print the study object spawns
    for a = 1:length(par.config.obj_study)
        
        first_layer = par.config.learning{3}(3,:);
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.obj_study)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    
    % fprintf(header.fid, '\n');
    
    clear a b c d first_layer second_layer;    
    
else % testing
    header.fid = fopen('volt_testing.txt','w');

    % print out the subject number
    fprintf(header.fid, '%d\n', par.train.subNr);
    
    % print out subject initials
    fprintf(header.fid, '%s\n', par.train.subInit);
    
    % print out success radius
    fprintf(header.fid, '%d\n', par.train.successRadius);
    
    % print out movement speed
    fprintf(header.fid, '%d\n', par.train.movementSpeed);
    
    %print out whether learning or testing phase (0 = learning; 2 =
    %testing); same for practice and task
    fprintf(header.fid, '%d\n', 2);
    
    % print out default time (max) in test period - will cut to next "trial" after x
    % seconds
    fprintf(header.fid, '%d\n', par.train.testTime);
    
    % print out default object display time 
    fprintf(header.fid, '%d\n', par.train.objDisplayTime);
    
    % print out object assignments
    nObjects = length(par.config.stimOrderObjects);
    format = '%d ';
    stringformat = repmat(format, 1, nObjects);
    stringformat(end:end+1) = '\n';
    
    fprintf(header.fid, stringformat, par.config.stimOrderObjects);
    
    clear nObjects stringformat format
    
    % print the test environment parameters
    nEnvs = length(par.config.env_test);
    format = '%d ';
    stringformat = repmat(format, 1, nEnvs);
    stringformat(end:end+1) = '\n';
    
    fprintf(header.fid, stringformat, par.config.env_test);
    
    clear stringformat format nEnvs
    
    % print the test player spawns
    for a = 1:length(par.config.player_test)
        
        first_layer = par.config.player_test{a};
        
        for c = 1:size(first_layer,1)
            
            for d = 1:size(first_layer,2)
                if d == size(first_layer,2) && a == length(par.config.player_test)
                    fprintf(header.fid, '%d', first_layer(c,d));
                else
                    fprintf(header.fid, '%d ', first_layer(c,d));
                end
            end
        end
    end
    fprintf(header.fid, '\n');
    
    clear a c d first_layer;
    
    % print the test object spawns
    nObjs = length(par.config.obj_test);
    format = '%d ';
    stringformat = repmat(format, 1, nObjs);
    stringformat(end) = [];
    
    fprintf(header.fid, stringformat, par.config.obj_test);
    
    clear stringformat format nObjs
end

%% End experiment

disp('---------------');
disp(sprintf('Config file type %d created!',taskNr));
disp('---------------');
disp(' ');


