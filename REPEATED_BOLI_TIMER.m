clear;
%%

nBolus = 2; % number of boli
bolusInterval = 30; % seconds
startDelay = 0;


%%

timerTag = 'repeatBolTmr';
delete(timerfind('Tag',timerTag));

fh = findall(0,'Type','figure','-and','Name','Stimulation Control');
assert(isscalar(fh),'Failed to find app figure');

app = fh.RunningAppInstance;
assert(app.bolusTrgDuration<bolusInterval, 'Bolus interval must be greater than bolus trigger duration (=%gs)! Otherwise injector cannot be triggered.',app.bolusTrgDuration);

bolusFnc = @(~,~)app.sendBolusAndPhysioTrg(0);


th = timer('Tag',           timerTag, ...
           'TimerFcn',      bolusFnc, ...
           'BusyMode',      'queue', ...
           'ExecutionMode', 'fixedRate', ...
           'TasksToExecute',nBolus, ...
           'Period',        bolusInterval, ...
           'StartDelay',    startDelay);

th.start();
