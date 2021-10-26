% JCL (maybe)

function [keypresses pressRTs] = flipkeys(flipchangetime,totalduration,par,dev,on)

endflip = on + totalduration;
changeflip = on + flipchangetime;

keypressed = 0;
changeflipped = 0;

while KbCheck(dev)
    if (GetSecs - on) > totalduration, break, end
end

while (GetSecs < endflip) && (GetSecs > on)

    [keyIsDown secs keyCode] = KbCheck(dev);
    
    if keyIsDown && ~keypressed
        keypresses = KbName(keyCode);
        pressRTs = GetSecs - on;
        keypressed = 1;
    end
    
    if (GetSecs > changeflip) && ~changeflipped
        Screen(par.window,'Flip');
        changeflipped = 1;
    end
    
end

if ~keypressed
    [keypresses pressRTs]=deal(NaN);
end