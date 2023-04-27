clear;
%%

nStim = 0; % number of stimulations
stimInterval = 15; % seconds
stimStartDelay = 0;

nBolus = 2; % number of boli
bolusInterval = 30; % seconds
bolusStartDelay = 0;


%%

sTimerTag = 'repeatStimTmr';
delete(timerfind('Name',sTimerTag));

bTimerTag = 'repeatBolTmr';
delete(timerfind('Name',bTimerTag));

fh = findall(0,'Type','figure','-and','Name','Stimulation Control');
assert(isscalar(fh),'Failed to find app figure');

app = fh.RunningAppInstance;
assert(app.bolusTrgDuration+app.bolusPrepDelay<bolusInterval, ...
    'Bolus interval must be greater than bolus trigger duration (=%g+%gs)! Otherwise injector cannot be triggered or timer cannot start.',...
    app.bolusPrepDelay,app.bolusTrgDuration);
P = app.getProtocolParam();
S = app.stimParameter;
sDur = S.(S.mode).StimDuration;
assert(nStim==0 || ~P.StimBolus || nBolus==0, ...
    'Either activate StimBolus in GUI  OR  schedule boli with timer!');
protoDur = P.StimulationDelay + P.ProtocolRepeats*sDur + (P.ProtocolRepeats-1)*P.ProtocolInterval;
assert(protoDur<stimInterval, 'StimTimer Interval must be longer than overall protocoll duration (%gs)!',protoDur);


stimFnc = @(~,~)app.runStimProtocol();
if nStim>0
    sth = timer('Name',           sTimerTag, ...
               'TimerFcn',      stimFnc, ...
               'StartFcn',      @(~,~)fprintf('StimTimer started\n'), ...
               'StopFcn',       @(~,~)fprintf('StimTimer stopped\n'), ...
               'BusyMode',      'queue', ...
               'ExecutionMode', 'fixedRate', ...
               'TasksToExecute',nStim, ...
               'Period',        stimInterval, ...
               'StartDelay',    stimStartDelay);
else, sth.start = @()beep;
end

bolusFnc = @(~,~)app.sendBolusAndPhysioTrg(0);
if nBolus>0
    bth = timer('Name',           bTimerTag, ...
               'TimerFcn',      bolusFnc, ...
               'StartFcn',      @(~,~)fprintf('BolusTimer started\n'), ...
               'StopFcn',       @(~,~)fprintf('BolusTimer stopped\n'), ...
               'BusyMode',      'queue', ...
               'ExecutionMode', 'fixedRate', ...
               'TasksToExecute',nBolus, ...
               'Period',        bolusInterval, ...
               'StartDelay',    bolusStartDelay);
else, bth.start = @()beep;
end

sth.start();
bth.start();
