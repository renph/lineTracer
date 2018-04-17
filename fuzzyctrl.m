function [ vL, vR, du ] = fuzzyctrl( err )
persistent base u fismatrix  err1
if nargin < 1 || nargout == 0
    fisFileName = 'agv';
    fismatrix = readfis(fisFileName);
    u = 0;
    base = 12;
    err1 = 0;
    showRuleViewer(fismatrix);
    return
end

showRuleViewer([err;err - err1]);

du = evalfis([err;err - err1],fismatrix);
u = u + du;
if u>base
    u = base;
elseif u<-base
    u=-base;
end
vL = base - u ;
vR = base + u ;
err1 = err;
end

function showRuleViewer(fismatrix)
persistent fig

if isnumeric(fismatrix)
    if ~isempty(fig)
        set(fig, 'HandleVisibi', 'on');
        ruleview('#simulink', fismatrix, fig);
        set(fig, 'HandleVisibi', 'callback');
        return;
    end
end
%     ¼ì²âÊÇ·ñ»æÖÆÍ¼ÐÎ
mapfig = findall(0,'Type','figure','Name','map');
if isempty(mapfig)
    fig = mapfig;
    return
end
fig = findall(0,'Type','figure','Name',sprintf('Rule Viewer: %s',fismatrix.name));
if isempty(fig)
    ruleview(fismatrix);
    fig = findall(0,'Type','figure','Name',sprintf('Rule Viewer: %s',fismatrix.name));
    position=get(fig, 'Position');
    set(fig, 'Position', position+[.2 -.2 0 0]);
else
    figure(fig);
end
end
