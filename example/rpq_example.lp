% Dot
dotEdgeLabels("ExampleA", "ExampleB").
edge(Source, c(EdgeLabelA, ".", EdgeLabelB), Sink) :- 
	edge(Source, EdgeLabelA, Intermedia), 
	edge(Intermedia, EdgeLabelB, Sink),
	dotEdgeLabels(EdgeLabelA, EdgeLabelB).

% Reverse
reverseEdgeLabels("Example").
edge(Source, c(EdgeLabel, "-1"), Sink) :- 
	edge(Sink, EdgeLabel, Source), 
	reverseEdgeLabels(EdgeLabel).

% Plus
plusEdgeLabels("Example").
plusEdgeLabels(EdgeLabel) :- starEdgeLabels(EdgeLabel).
edge(Source, c(EdgeLabel, "+"), Sink) :- 
edge(Source, EdgeLabel, Sink), 
plusEdgeLabels(EdgeLabel).
edge(Source, EdgeLabel, Sink) :- 
	edge(Source, EdgeLabel, Intermedia), 
	edge(Intermedia, c(EdgeLabel, "+"), Sink),
	plusEdgeLabels(EdgeLabel).

% Star
starEdgeLabels("Example").
edge(SourceAndSink, c(EdgeLabel, "*"), SourceAndSink) :- 
	edge(SourceAndSink, _, _),
	starEdgeLabels(EdgeLabel).
edge(Source, c(EdgeLabel, "*"), Sink) :- 
	edge(Source, c(EdgeLabel, "+"), Sink),
	starEdgeLabels(EdgeLabel).

% a.b+
%dotEdgeLabels("a", c("b","+")).
%plusEdgeLabels("b").
%answer(Source, Sink) :- edge(Source, c("a", ".", c("b", "+")), Sink).

% a.b*
dotEdgeLabels("a", c("b","*")).
starEdgeLabels("b").
answer(Source, Sink) :- edge(Source, c("a", ".", c("b", "*")), Sink).

edge("X", "a", "Y").
edge("Y", "b", "Z").
