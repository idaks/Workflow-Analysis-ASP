% ---- RPQ/2 engine on ADG ----

% Dot
adgEdge(ContainerS, DataLabelS, c(EdgeLabelA, ".", EdgeLabelB), ContainerE, DataLabelE) :- 
	adgEdge(ContainerS, DataLabelS, EdgeLabelA, ContainerI, DataLabelI), 
	adgEdge(ContainerI, DataLabelI, EdgeLabelB, ContainerE, DataLabelE),
	dotEdgeLabels(EdgeLabelA, EdgeLabelB).

% Reverse
adgEdge(ContainerS, DataLabelS, c(EdgeLabel, "-1"), ContainerE, DataLabelE) :- 
	adgEdge(ContainerE, DataLabelE, EdgeLabel, ContainerS, DataLabelS), 
	reverseEdgeLabels(EdgeLabel).

% Plus
adgEdge(ContainerS, DataLabelS, c(EdgeLabel, "+"), ContainerE, DataLabelE) :- 
	adgEdge(ContainerS, DataLabelS, EdgeLabel, ContainerE, DataLabelE), 
	plusEdgeLabels(EdgeLabel).
adgEdge(ContainerS, DataLabelS, EdgeLabel, ContainerE, DataLabelE) :- 
	adgEdge(ContainerS, DataLabelS, EdgeLabel, ContainerI, DataLabelI), 
	adgEdge(ContainerI, DataLabelI, c(EdgeLabel, "+"), ContainerE, DataLabelE),
	plusEdgeLabels(EdgeLabel).

% Star (plus implies star)
plusEdgeLabels(EdgeLabel) :- starEdgeLabels(EdgeLabel).
adgEdge(SourceAndContainer, DataLabel, c(EdgeLabel, "*"), SourceAndContainer, DataLabel) :- 
	adgEdge(SourceAndContainer, DataLabel, _, _, _),
	starEdgeLabels(EdgeLabel).
adgEdge(ContainerS, DataLabelS, c(EdgeLabel, "*"), ContainerE, DataLabelE) :- 
	adgEdge(ContainerS, DataLabelS, c(EdgeLabel, "+"), ContainerE, DataLabelE),
	starEdgeLabels(EdgeLabel).

