% ---- Compute optimized workflow with maximal parallelism ----

% Compute dependecies between processes that must be satisfied
actorDependency(ActorA, ActorB) :- dcgEdge(ContainerS, ActorA, _, _), dcgEdge(_, ActorB, _, ContainerE), adgEdge(ContainerS, DataLabelS, "update", ContainerSI, DataLabelSI), adgEdge(ContainerSI, DataLabelSI, c("bypass", "*"), ContainerEI, DataLabelEI), adgEdge(ContainerEI, DataLabelEI, "read", ContainerE, DataLabelE).

% No partial order between parallel processes
parallelProcess(ProcessA, ProcessB) :- not actorDependency(ProcessA, ProcessB), not actorDependency(ProcessB, ProcessA), process(ProcessA, "actor"), process(ProcessB, "actor"), not sourceProcess(ProcessA), not sourceProcess(ProcessB), not sinkProcess(ProcessA), not sinkProcess(ProcessB), ProcessA != ProcessB.

% Construct possible edges as the start point (protential answers)
optimizedWorkflowOrder(ProcessA, ProcessB) | notOptimizedWorkflow(ProcessA, ProcessB) :- process(ProcessA, "actor"), process(ProcessB, "actor"), not parallelProcess(ProcessA, ProcessB), ProcessA != ProcessB.

% Eliminate invalid answers: 1) all actors are in
optimizedWorkflowProcess(Process) :- optimizedWorkflowOrder(Process, _).
optimizedWorkflowProcess(Process) :- optimizedWorkflowOrder(_, Process).
:- not optimizedWorkflowProcess(Process), process(Process, "actor").

% 2) Souce and sink are fixed
:- optimizedWorkflowOrder(Process, _), sinkProcess(Process).
:- optimizedWorkflowOrder(_, Process), sourceProcess(Process).

% 3) Only one head and one tail
optimizedWorkflowStart(Process) :- optimizedWorkflowOrder(Process, _).
optimizedWorkflowEnd(Process) :- optimizedWorkflowOrder(_, Process).
optimizedWorkflowHead(Process) :- optimizedWorkflowOrder(Process, _), not optimizedWorkflowEnd(Process).
optimizedWorkflowTail(Process) :- not optimizedWorkflowStart(Process), optimizedWorkflowOrder(_, Process).
:- 2 <= #count {Process : optimizedWorkflowHead(Process)}.
:- 2 <= #count {Process : optimizedWorkflowTail(Process)}.

% 4) Anti-symmetric
:- optimizedWorkflowOrder(ProcessA, ProcessB), optimizedWorkflowOrder(ProcessB, ProcessA), ProcessA != ProcessB.

% 5) dependency is satisfied
:- not optimizedWorkflowOrder(ProcessA, ProcessB), actorDependency(ProcessA, ProcessB).

% Finally, compute successor relation as the result
optimizedWorkflow(ProcessA, ProcessB) :- optimizedWorkflowOrder(ProcessA, ProcessB), not notOptimizedWorkflow(ProcessA, ProcessB).
notOptimizedWorkflow(ProcessA, ProcessB) :- optimizedWorkflowOrder(ProcessA, ProcessI), optimizedWorkflowOrder(ProcessI, ProcessB), ProcessA != ProcessB.

