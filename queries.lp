% workflow is connected (only one head)
workflowTc(X, Y) :- workflow(X, Y).
workflowTc(X, Y) :- workflowTc(X, Z), workflow(Z, Y).

segmentHead(X) :- workflowTc(X, _), not workflowTc(_, X).

% duplicate validations. Construct bypass* by adding "bypass" to edgeLabels
starEdgeLabels("bypass").

duplicateValidation(ContainerS, LabelS, ContainerE, LabelE) :- 
	edge(ContainerS, LabelS, "update", ContainerIS, LabeIS), 
	edge(ContainerIS, LabeIS, c("bypass", "*"), ContainerIE, LabelIE), 
	edge(ContainerIE, LabelIE, "update", ContainerE, LabelE).
	
% invalid validation
reverseEdgeLabels("read").
starEdgeLabels("bypass").

invalidValidation(ContainerS, DataLabelS, ContainerE, DataLabelE) :- 
	edge(ContainerS, DataLabelS, c("read", "-1"), ContainerIS, DataLabelE), 
	edge(ContainerIS, DataLabelE, c("bypass", "*"), ContainerIE, DataLabelE), 
	edge(ContainerIE, DataLabelE, "update", ContainerE, DataLabelE).

% unused inputs
starEdgeLabels("bypass").
usedInput(DataLabel) :- edge(ContainerS, DataLabel, c("bypass", "*"), ContainerE, DataLabel), edge(ContainerE, DataLabel, "update", _, _), node(ContainerS, DataLabel, "original").
usedInput(DataLabel) :- edge(ContainerS, DataLabel, c("bypass", "*"), ContainerE, DataLabel), edge(ContainerE, DataLabel, "read", _, _), node(ContainerS, DataLabel, "original").

unusedInput(DataLabel) :- inputData(DataLabel), not usedInput(DataLabel).

:- {t(X) : unusedInput(X)} 0.
