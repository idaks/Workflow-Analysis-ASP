% workflow
workflow("Reader", "SciNameValidator").
workflow("SciNameValidator", "FlowerTimeValidator").
workflow("FlowerTimeValidator", "EventDateValidator").
workflow("EventDateValidator", "Writer").

% actor configuration
actorValidation("sciName", "SciNameValidator", "sciName").
actorValidation("repCon", "FlowerTimeValidator", "repCon").
actorValidation("eventDate", "EventDateValidator", "eventDate").
actorReference("sciName", "FlowerTimeValidator", "repCon").

% input schema
inputData("eventDate").
inputData("sciName").
inputData("repCon").
%inputData("latitude").
%inputData("longitude").
%inputData("identifier").

% process
process("Reader", "actor").
process("SciNameValidator", "actor").
process("FlowerTimeValidator", "actor").
process("EventDateValidator", "actor").
process("Writer", "actor").
process("frontSplit", "spliter").
process("frontMerger", "merger").

% process label
processLabel("actor", "next").
processLabel("spliter", "split").
processLabel("merger", "merge").


% branch
%workflow("Reader", "frontSplit").
%workflow("frontSplit", "FlowerTimeValidator").
%workflow("frontSplit", "SciNameValidator").
%workflow("FlowerTimeValidator", "frontMerger").
%workflow("SciNameValidator", "frontMerger").
%workflow("frontMerger", "Writer").

% invalid validation
%workflow("Reader", "FlowerTimeValidator").
%workflow("FlowerTimeValidator", "SciNameValidator").
%workflow("SciNameValidator", "Writer").
