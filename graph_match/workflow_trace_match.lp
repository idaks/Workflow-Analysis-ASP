% workflow
%workflow("UnusefulActor", "Reader").
workflow("Reader", "frontSplit").
workflow("frontSplit", "FlowerTimeValidator").
workflow("frontSplit", "SciNameValidator").
workflow("FlowerTimeValidator", "frontMerger").
workflow("SciNameValidator", "frontMerger").
workflow("frontMerger", "Writer").
%workflow("Reader", "UnusefulActor").

% trace
trace("ReaderInvoc", "frontSplitInvoc").
trace("frontSplitInvoc", "SciNameValidatorInvoc").
trace("SciNameValidatorInvoc", "frontMergerInvoc").
trace("frontMergerInvoc", "WriterInvoc").

% mapping
mapping("ReaderInvoc", "Reader").
mapping("frontSplitInvoc", "frontSplit").
mapping("SciNameValidatorInvoc", "SciNameValidator").
mapping("FlowerTimeValidatorInvoc", "FlowerTimeValidator").
mapping("frontMergerInvoc", "frontMerger").
mapping("WriterInvoc", "Writer").
%mapping("UnusefulActorInvoc", "UnusefulActor").


% 1. trace is connected and has exactly one head and one tail
traceStart(Process) :- trace(Process, _).
traceEnd(Process) :- trace(_, Process).
traceHead(Process) :- trace(Process, _), not traceEnd(Process).
traceTail(Process) :- not traceStart(Process), trace(_, Process).
:- not 1 <= #count {Process : traceHead(Process)} <= 1.
:- not 1 <= #count {Process : traceTail(Process)} <= 1.


% 2. trace is homomorphic to worklfow
:- trace(ProcessInvocA, ProcessInvocB), not workflow(ProcessA, ProcessB), mapping(ProcessInvocA, ProcessA), mapping(ProcessInvocB, ProcessB).


% for each break point, find all the edges are executed
branchEdge(BreakPoint, ProcessA) :- workflow(BreakPoint, ProcessA), workflow(BreakPoint, ProcessB), ProcessA != ProcessB.
executedBranch(ProcessA, ProcessB) :- branchEdge(ProcessA, ProcessB), trace(ProcessInvocA, ProcessInvocB), mapping(ProcessInvocA, ProcessA), mapping(ProcessInvocB, ProcessB).

% 3. each break point has exact one executed edge (since BreakPoint is deduplicated)
numExecuted(Num) :- Num = #count {Process : executedBranch(Process, _)}.
numBranches(Num) :- Num = #count {Process : branchEdge(Process, _)}.
:- numExecuted(NumE), numBranches(NumB), NumE != NumB.


% for each break point, find the pair of BreakPoint and MergePoint
workflowTc(ProcessA, ProcessB) :- workflow(ProcessA, ProcessB).
workflowTc(ProcessA, ProcessB) :- workflowTc(ProcessA, ProcessI), workflow(ProcessI, ProcessB).

commonAncestors(BreakPoint, CommonAncestor) :- workflowTc(EndProcessA, CommonAncestor), workflowTc(EndProcessB, CommonAncestor), branchEdge(BreakPoint, EndProcessA), branchEdge(BreakPoint, EndProcessB), EndProcessA != EndProcessB.

notLCA(BreakPoint, WrongAncestor) :- workflowTc(Ancestor, WrongAncestor), commonAncestors(BreakPoint, Ancestor), commonAncestors(BreakPoint, WrongAncestor).

branchPair(BreakPoint, Ancestor) :- commonAncestors(BreakPoint, Ancestor), not notLCA(BreakPoint, Ancestor).

% 4. for each executed branch, it's complete
traceTc(ProcessA, ProcessB) :- trace(ProcessA, ProcessB).
traceTc(ProcessA, ProcessB) :- traceTc(ProcessA, ProcessI), trace(ProcessI, ProcessB).

executedBranchValid :- executedBranch(ProcessA, ProcessI), branchPair(ProcessA, ProcessB), traceTc(ProcessInvocI, ProcessInvocB), traceTc(ProcessInvocA, ProcessInvocI), mapping(ProcessInvocA, ProcessA), mapping(ProcessInvocI, ProcessI), mapping(ProcessInvocB, ProcessB).
:- not executedBranchValid.


% find all the edges that are not suppose to be in the trace
notExecutedBranch(ProcessA, ProcessB) :- branchEdge(ProcessA, ProcessB), not executedBranch(ProcessA, ProcessB).

needToRemoveEdge(ProcessA, ProcessB) :- notExecutedBranch(ProcessA, ProcessB).
needToRemoveEdge(ProcessA, ProcessB) :- notExecutedBranch(BreakPoint, ProcessA), workflow(ProcessA, ProcessB).
needToRemoveEdge(ProcessA, ProcessB) :- notExecutedBranch(BreakPoint, ProcessHead), branchPair(BreakPoint, MergePoint), workflowTc(ProcessHead, ProcessA), workflowTc(ProcessA, MergePoint), workflow(ProcessA, ProcessB).

% 5. worklfow is homomorphic to trace (no unused edges)
executedWorkflowEdges(ProcessA, ProcessB) :- workflow(ProcessA, ProcessB), not needToRemoveEdge(ProcessA, ProcessB).
:- executedWorkflowEdges(ProcessA, ProcessB), not trace(ProcessInvocA, ProcessInvocB), mapping(ProcessInvocA, ProcessA), mapping(ProcessInvocB, ProcessB).

