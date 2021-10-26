function varargout = getResp(varargin)

%function varargout = GetResp(varargin)
%	If no variables are supplied as input, then no variables are supplied as output.
%		The function simply returns [RT].
%	If characters are supplied as input then the output is [Response, RT]
%		E.g.  For GetResp('z', 'x', 'n'), Response is
%			1 if 'z' was pressed, 
%			2 if 'x' is pressed, or
%			3 if 'n' is pressed.

beginTime = GetSecs;
responded = 0;
while ~responded
    [keyIsDown,secs,keyCode] = KbCheck;
    lastKey = keyCode;
    while keyIsDown, [keyIsDown,secs,keyCode] = KbCheck; end;
    while ~keyIsDown
        [keyIsDown,secs,keyCode] = KbCheck;
        lastKey = keyCode;
    end
    key = KbName(lastKey);
    if isempty(varargin)
        responded = 1;
        varargout = {GetSecs-beginTime};
    else
        for i = 1:length(varargin)
            if isequal(upper(key), upper(varargin{i}))
                responded = 1;
                varargout = {i, GetSecs-beginTime};
            end
        end
    end
end
[keyIsDown,secs,keyCode] = KbCheck;
while keyIsDown, [keyIsDown,secs,keyCode] = KbCheck; end;