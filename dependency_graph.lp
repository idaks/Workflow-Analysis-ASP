% Construct container graph 
workflowEnd(Actor) :- workflow(_, Actor). %for safety
workflowStart(Actor) :- workflow(Actor, _). %for safety
	
%containerGraph("sourceContainer", ProcessA, "next", c(ProcessA, ProcessB)) :- workflow(ProcessA, ProcessB), not workflowEnd(ProcessA).
%containerGraph(c(ProcessA, ProcessB), ProcessB, "next", c(ProcessB, ProcessC)) :- workflow(ProcessA, ProcessB),workflow(ProcessB, ProcessC). 
%containerGraph(c(ProcessA, ProcessB), ProcessB, "next", "sinkContainer") :- workflow(ProcessA, ProcessB), not workflowStart(ProcessB).

containerGraph("sourceContainer", ProcessA, ProcessLabel, c(ProcessA, ProcessB)) :- workflow(ProcessA, ProcessB), not workflowEnd(ProcessA), process(ProcessA, Type), processLabel(Type, ProcessLabel). 

containerGraph(c(ProcessA, ProcessB), ProcessB, ProcessLabel, c(ProcessB, ProcessC)) :- workflow(ProcessA, ProcessB), workflow(ProcessB, ProcessC), process(ProcessB, Type), processLabel(Type, ProcessLabel). 

containerGraph(c(ProcessA, ProcessB), ProcessB, ProcessLabel, "sinkContainer") :- workflow(ProcessA, ProcessB), not workflowStart(ProcessB), process(ProcessB, Type), processLabel(Type, ProcessLabel). 

% Construct data dependency graph
% current schema
% node(container, label, status).
% edge(container, label, edgeType, container, label).

% source
% construct, the source node, edges from source node and the nodes those edges points to
node("sourceContainer", "source", "null").
edge("sourceContainer", "source", "input", Container, Label) :- containerGraph("sourceContainer", _, _, Container), inputData(Label).
node(Container, Label, "original") :- containerGraph("sourceContainer", _, _, Container), inputData(Label).

% construct edges
edge(ContainerS, LabelS, "update", ContainerE, LabelE) :- containerGraph(ContainerS, Actor, _, ContainerE), actorValidation(LabelS, Actor, LabelE).

edge(ContainerS, LabelS, "read", ContainerE, LabelE) :- containerGraph(ContainerS, Actor, _, ContainerE), actorReference(LabelS, Actor, LabelE).

actorRead(Label, Actor) :- actorValidation(Label, Actor, _).  % for safety
edge(ContainerS, LabelS, "bypass", ContainerE, LabelS) :- node(ContainerS, LabelS, _), containerGraph(ContainerS, Actor, _, ContainerE), not actorRead(LabelS, Actor), ContainerS != "sourceContainer", ContainerE != "sinkContainer". % don't construct the source and sink node edges

% construct the node from edges
node(Container, Label, "validated") :- edge(_, _, "update", Container, Label).
node(ContainerB, LabelB, Status) :- edge(ContainerA, LabelA, "bypass", ContainerB, LabelB), node(ContainerA, LabelA, Status).

% sink
node("sinkContainer", "sink", "null").
edge(Container, Label, "output", "sinkContainer", "sink") :- containerGraph(Container, _, _, "sinkContainer"), node(Container, Label, _).

