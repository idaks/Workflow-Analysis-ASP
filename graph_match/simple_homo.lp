% workflow
workflow("Reader", "frontSplit").
workflow("frontSplit", "FlowerTimeValidator").
workflow("frontSplit", "SciNameValidator").
workflow("FlowerTimeValidator", "frontMerger").
workflow("SciNameValidator", "frontMerger").
workflow("frontMerger", "Writer").

% trace
trace("ReaderInvoc", "frontSplitInvoc").
trace("frontSplitInvoc", "SciNameValidatorInvoc").
trace("SciNameValidatorInvoc", "frontMergerInvoc").
trace("frontSplitInvoc", "FlowerTimeValidatorInvoc").
trace("FlowerTimeValidatorInvoc", "frontMergerInvoc").
trace("frontMergerInvoc", "WriterInvoc").

% mapping
mapping("ReaderInvoc", "Reader").
mapping("frontSplitInvoc", "frontSplit").
mapping("SciNameValidatorInvoc", "SciNameValidator").
mapping("FlowerTimeValidatorInvoc", "FlowerTimeValidator").
mapping("frontMergerInvoc", "frontMerger").
mapping("WriterInvoc", "Writer").
mapping("UnusefulActorInvoc", "UnusefulActor").

% trace is homomorphic to worklfow
:- trace(ProcessInvocA, ProcessInvocB), not workflow(ProcessA, ProcessB), mapping(ProcessInvocA, ProcessA), mapping(ProcessInvocB, ProcessB).



