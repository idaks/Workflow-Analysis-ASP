% ---- Find whether a trace matches a workflow ----

% 1) Trace are SP graphs
traceStart(Process) :- trace(Process, _).  traceTail(Process) :- not traceStart(Process), trace(_, Process).
traceEnd(Process) :- trace(_, Process).  traceHead(Process) :- trace(Process, _), not traceEnd(Process).
:- not 1 <= #count {Process : traceHead(Process)} <= 1.
:- not 1 <= #count {Process : traceTail(Process)} <= 1.

% 2) Trace is homomorphic to worklfow
:- trace(ProcessInvocA, ProcessInvocB), not workflow(ProcessA, ProcessB), mapping(ProcessInvocA, ProcessA), mapping(ProcessInvocB, ProcessB).

% 3) Each break point has exact one executed edge (since BreakPoint is deduplicated)
branchEdge(BreakPoint, ProcessA) :- workflow(BreakPoint, ProcessA), workflow(BreakPoint, ProcessB), ProcessA != ProcessB.
executedBranch(ProcessA, ProcessB) :- branchEdge(ProcessA, ProcessB), trace(ProcessInvocA, ProcessInvocB), mapping(ProcessInvocA, ProcessA), mapping(ProcessInvocB, ProcessB).

numExecuted(Num) :- Num = #count {Process : executedBranch(Process, _)}.
numBranches(Num) :- Num = #count {Process : branchEdge(Process, _)}.
:- numExecuted(NumE), numBranches(NumB), NumE != NumB.

% 4) For each executed branch, it's complete
% Find each pair of BreakPoint and MergePoint
workflowTc(ProcessA, ProcessB) :- workflow(ProcessA, ProcessB).
workflowTc(ProcessA, ProcessB) :- workflowTc(ProcessA, ProcessI), workflow(ProcessI, ProcessB).
commonAncestors(BreakPoint, CommonAncestor) :- workflowTc(EndProcessA, CommonAncestor), workflowTc(EndProcessB, CommonAncestor), branchEdge(BreakPoint, EndProcessA), branchEdge(BreakPoint, EndProcessB), EndProcessA != EndProcessB.
notLCA(BreakPoint, WrongAncestor) :- workflowTc(Ancestor, WrongAncestor), commonAncestors(BreakPoint, Ancestor), commonAncestors(BreakPoint, WrongAncestor).
branchPair(BreakPoint, Ancestor) :- commonAncestors(BreakPoint, Ancestor), not notLCA(BreakPoint, Ancestor).

traceTc(ProcessA, ProcessB) :- trace(ProcessA, ProcessB).
traceTc(ProcessA, ProcessB) :- traceTc(ProcessA, ProcessI), trace(ProcessI, ProcessB).
executedBranchValid :- executedBranch(ProcessA, ProcessI), branchPair(ProcessA, ProcessB), traceTc(ProcessInvocI, ProcessInvocB), traceTc(ProcessInvocA, ProcessInvocI), mapping(ProcessInvocA, ProcessA), mapping(ProcessInvocI, ProcessI), mapping(ProcessInvocB, ProcessB).
:- not executedBranchValid.

% 5) Worklfow without unused branches is homomorphic to trace
notExecutedBranch(ProcessA, ProcessB) :- branchEdge(ProcessA, ProcessB), not executedBranch(ProcessA, ProcessB).
needToRemoveEdge(ProcessA, ProcessB) :- notExecutedBranch(ProcessA, ProcessB).
needToRemoveEdge(ProcessA, ProcessB) :- notExecutedBranch(BreakPoint, ProcessA), workflow(ProcessA, ProcessB).
needToRemoveEdge(ProcessA, ProcessB) :- notExecutedBranch(BreakPoint, ProcessHead), branchPair(BreakPoint, MergePoint), workflowTc(ProcessHead, ProcessA), workflowTc(ProcessA, MergePoint), workflow(ProcessA, ProcessB).
executedWorkflowEdges(ProcessA, ProcessB) :- workflow(ProcessA, ProcessB), not needToRemoveEdge(ProcessA, ProcessB).
:- executedWorkflowEdges(ProcessA, ProcessB), not trace(ProcessInvocA, ProcessInvocB), mapping(ProcessInvocA, ProcessA), mapping(ProcessInvocB, ProcessB).

