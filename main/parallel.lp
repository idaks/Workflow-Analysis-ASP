
actorDependency(ActorA, ActorB) :- containerGraph(ContainerS, ActorA, _, _), containerGraph(_, ActorB, _, ContainerE), edge(ContainerS, DataLabelS, "update", ContainerSI, DataLabelSI), edge(ContainerSI, DataLabelSI, c("bypass", "*"), ContainerEI, DataLabelEI), edge(ContainerEI, DataLabelEI, "read", ContainerE, DataLabelE).

%workflowTc is in queries.lp
workflowHead(X) :- workflowTc(X, _), not workflowTc(_, X).
workflowTail(X) :- workflowTc(_, X), not workflowTc(X, _).
prallel(ActorA, ActorB) :- workflowTc(ActorA, ActorB), not actorDependency(ActorA, ActorB), not workflowHead(ActorA), not workflowTail(ActorB).

%#show prallel/2. 
