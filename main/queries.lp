% workflow is connected (only one head)
workflowStart(Process) :- workflow(Process, _).
workflowEnd(Process) :- workflow(_, Process).
workflowHead(Process) :- workflow(Process, _), not workflowEnd(Process).
workflowTail(Process) :- not workflowStart(Process), workflow(_, Process).
:- not 1 <= #count {Process : workflowHead(Process)} <= 1.
:- not 1 <= #count {Process : workflowTail(Process)} <= 1.


% duplicate validations. Construct bypass* by adding "bypass" to edgeLabels
starEdgeLabels("bypass").

:- edge(ContainerS, LabelS, "update", ContainerIS, LabeIS), edge(ContainerIS, LabeIS, c("bypass", "*"), ContainerIE, LabelIE), edge(ContainerIE, LabelIE, "update", ContainerE, LabelE).


% invalid validation
reverseEdgeLabels("read").
starEdgeLabels("bypass").

:- edge(ContainerS, DataLabelS, c("read", "-1"), ContainerIS, DataLabelE), edge(ContainerIS, DataLabelE, c("bypass", "*"), ContainerIE, DataLabelE), edge(ContainerIE, DataLabelE, "update", ContainerE, DataLabelE).


% unused inputs
starEdgeLabels("bypass").
usedInput(DataLabel) :- edge(ContainerS, DataLabel, c("bypass", "*"), ContainerE, DataLabel), edge(ContainerE, DataLabel, "update", _, _), node(ContainerS, DataLabel, "original").
usedInput(DataLabel) :- edge(ContainerS, DataLabel, c("bypass", "*"), ContainerE, DataLabel), edge(ContainerE, DataLabel, "read", _, _), node(ContainerS, DataLabel, "original").

:- inputData(DataLabel), not usedInput(DataLabel).
