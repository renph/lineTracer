function fisSetup(fisname)
a=newfis(fisname,'sugeno');
% 当前误差
a=addvar(a,'input','e',[-20,20]);            %Parameter e
a=addmf(a,'input',1,'NB','zmf',[-20,-8]);
a=addmf(a,'input',1,'NS','trimf',[-10,-5,0]);
a=addmf(a,'input',1,'Z','trapmf',[-3,-1,1,3]);
a=addmf(a,'input',1,'PS','trimf',[0,5,10]);
a=addmf(a,'input',1,'PB','smf',[8,20]);
% 前一次误差
a=addvar(a,'input','e1',[-20,20]);            %Parameter e1
a=addmf(a,'input',2,'NB','zmf',[-20,-8]);
a=addmf(a,'input',2,'NS','trimf',[-10,-5,0]);
a=addmf(a,'input',2,'Z','trimf',[-5,0,5]);
a=addmf(a,'input',2,'PS','trimf',[0,5,10]);
a=addmf(a,'input',2,'PB','smf',[8,20]);
% 输出两轮差速
a=addvar(a,'output','u',[-25,25]);          %Parameter u
a=addmf(a,'output',1,'NB','linear',[0.85 -0.2 0]);
a=addmf(a,'output',1,'NS','linear',[0.6 0.375 0]);
a=addmf(a,'output',1,'Z','linear',[0.85 0.375 0]);
a=addmf(a,'output',1,'PS','linear',[0.6 0.375 0]);
a=addmf(a,'output',1,'PB','linear',[0.85 -0.2 0]);
a=addmf(a,'output',1,'PPB','linear',[0.2 0.8 0]);

%Edit rule base
rulelist = [
    1 0 1 1 1;         
    2 0 2 1 1;
    3 0 3 1 1;
    4 0 4 1 1;
    5 0 5 1 1;

    -5 1 6 1 1;         
    -5 2 6 1 1;


];

a=addrule(a,rulelist);
% showrule(a)                        % Show fuzzy rule base

writefis(a,fisname);             % save  fuzzy file

% a2=readfis('agv');
% disp('-------------------------------------------------------');
% disp('           fuzzy controller            ');
% disp('-------------------------------------------------------');
% 
% Ulist=zeros(1,7);
% e=zeros(1,7);
% for i=1:9
%     e(i)=-25+i*5;
%     Ulist(i)=evalfis([e(i); e(i)],a2);
% end
% 
% e
% Ulist

% figure(1);
% plotmf(a2,'input',1);
% figure(2);
% plotmf(a2,'input',2);
% figure(3);
% plotmf(a2,'output',1);