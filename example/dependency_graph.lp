% ---- Compute ADG from workflow specification and input data ----

% Construct container graph first
workflowEnd(Actor) :- workflow(_, Actor).  workflowStart(Actor) :- workflow(Actor, _). %for safety

dcgEdge("sourceContainer", ProcessA, ProcessLabel, c(ProcessA, ProcessB)) :- workflow(ProcessA, ProcessB), not workflowEnd(ProcessA), process(ProcessA, Type), processLabel(Type, ProcessLabel). 
dcgEdge(c(ProcessA, ProcessB), ProcessB, ProcessLabel, c(ProcessB, ProcessC)) :- workflow(ProcessA, ProcessB), workflow(ProcessB, ProcessC), process(ProcessB, Type), processLabel(Type, ProcessLabel). 
dcgEdge(c(ProcessA, ProcessB), ProcessB, ProcessLabel, "sinkContainer") :- workflow(ProcessA, ProcessB), not workflowStart(ProcessB), process(ProcessB, Type), processLabel(Type, ProcessLabel). 

% Construct the source node and edge of ADG
adgNode("sourceContainer", "source", "null").
adgEdge("sourceContainer", "source", "input", Container, Label) :- dcgEdge("sourceContainer", _, _, Container), inputData(Label).
adgNode(Container, Label, "original") :- dcgEdge("sourceContainer", _, _, Container), inputData(Label).

% Construct ADG edges other than source and sink
adgEdge(ContainerS, LabelS, "update", ContainerE, LabelE) :- dcgEdge(ContainerS, Actor, _, ContainerE), actorValidation(LabelS, Actor, LabelE).
adgEdge(ContainerS, LabelS, "read", ContainerE, LabelE) :- dcgEdge(ContainerS, Actor, _, ContainerE), actorReference(LabelS, Actor, LabelE).
actorRead(Label, Actor) :- actorValidation(Label, Actor, _).  % for safety
adgEdge(ContainerS, LabelS, "bypass", ContainerE, LabelS) :- adgNode(ContainerS, LabelS, _), dcgEdge(ContainerS, Actor, _, ContainerE), not actorRead(LabelS, Actor), ContainerS != "sourceContainer", ContainerE != "sinkContainer".

% construct ADG nodes
adgNode(Container, Label, "validated") :- adgEdge(_, _, "update", Container, Label).
adgNode(ContainerB, LabelB, Status) :- adgEdge(ContainerA, LabelA, "bypass", ContainerB, LabelB), adgNode(ContainerA, LabelA, Status).

% Construct the source node and edge of ADG
adgNode("sinkContainer", "sink", "null").
adgEdge(Container, Label, "output", "sinkContainer", "sink") :- dcgEdge(Container, _, _, "sinkContainer"), adgNode(Container, Label, _).

