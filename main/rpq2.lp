% Dot
edge(ContainerS, DataLabelS, c(EdgeLabelA, ".", EdgeLabelB), ContainerE, DataLabelE) :- 
	edge(ContainerS, DataLabelS, EdgeLabelA, ContainerI, DataLabelI), 
	edge(ContainerI, DataLabelI, EdgeLabelB, ContainerE, DataLabelE),
	dotEdgeLabels(EdgeLabelA, EdgeLabelB).

% Reverse
edge(ContainerS, DataLabelS, c(EdgeLabel, "-1"), ContainerE, DataLabelE) :- 
	edge(ContainerE, DataLabelE, EdgeLabel, ContainerS, DataLabelS), 
	reverseEdgeLabels(EdgeLabel).

% Plus
plusEdgeLabels(EdgeLabel) :- starEdgeLabels(EdgeLabel).
edge(ContainerS, DataLabelS, c(EdgeLabel, "+"), ContainerE, DataLabelE) :- 
	edge(ContainerS, DataLabelS, EdgeLabel, ContainerE, DataLabelE), 
	plusEdgeLabels(EdgeLabel).
edge(ContainerS, DataLabelS, EdgeLabel, ContainerE, DataLabelE) :- 
	edge(ContainerS, DataLabelS, EdgeLabel, ContainerI, DataLabelI), 
	edge(ContainerI, DataLabelI, c(EdgeLabel, "+"), ContainerE, DataLabelE),
	plusEdgeLabels(EdgeLabel).

% Star
edge(SourceAndContainer, DataLabel, c(EdgeLabel, "*"), SourceAndContainer, DataLabel) :- 
	edge(SourceAndContainer, DataLabel, _, _, _),
	starEdgeLabels(EdgeLabel).
edge(ContainerS, DataLabelS, c(EdgeLabel, "*"), ContainerE, DataLabelE) :- 
	edge(ContainerS, DataLabelS, c(EdgeLabel, "+"), ContainerE, DataLabelE),
	starEdgeLabels(EdgeLabel).

% a.b+
%dotEdgeLabels("a", c("b","+")).
%plusEdgeLabels("b").
%answer(ContainerS, DataLabelS, ContainerE, DataLabelE) :- edge(ContainerS, DataLabelS, c("a", ".", c("b", "+")), ContainerE, DataLabelE).

