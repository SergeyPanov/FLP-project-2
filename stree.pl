% Main function, create single spanning tree
stree(Graph, Tree) :- 
    member(Edge, Graph),
    spread([Edge], Tree, Graph).

% Spread Tree1 to spanning Tree of Graph
spread(Tree1, Tree, Graph) :- 
    addedge(Tree1, Tree2, Graph),
    spread(Tree2, Tree, Graph).
spread(Tree, Tree, Graph) :-
    \+ addedge(Tree, _, Graph).

% Add edge to Graph
addedge(Tree, [A-B|Tree], Graph) :-
    adjacent(A, B, Graph), % Only if exist edge A-B/B-A
    node(A, Tree),  % Only if node A is part of Graph
    \+ node(B, Tree).   % And node B is note part of Graph

% Check if edge exists between nodes Node1 and Node2
adjacent(Node1, Node2, Graph) :-
    member(Node1-Node2, Graph);
    member(Node2-Node1, Graph).

% Node is in graph only if it has at least one connection with any other node
node(Node, Graph) :-
    adjacent(Node, _, Graph).


append([], Y, Y).
append([H|X], Y, [H|Z]) :- append(X, Y, Z).


% Check if 2 graphs are the same
are_same([], _).
are_same([A-B|T], G) :- 
    are_same(T, G),
    (member(A-B, G); member(B-A, G)).

% Check if graph G is a member of List
is_member(G, [H|T]) :- 
    (are_same(G, H), are_same(H, G));
         is_member(G, T).

% Cast list to set
set([],[]).
set([H|T],[H|Out]) :-
    \+ is_member(H,T),
    set(T,Out),
    !.
set([H|T],Out) :-
    is_member(H,T),
    set(T,Out),
    !.


% Find all unique spanning trees
find_all_trees([], []).
find_all_trees(Graph, Trees) :- 
    findall(Tree, stree(Graph, Tree), DupTrees),
    set(DupTrees, Trees).


% [ [[a], [b]], [[b], [c]], [[c], [d]] ]
% Make flat list
flatten2([], []) :- !.
flatten2([L|Ls], FlatL) :-
    !,
    flatten2(L, NewL),
    flatten2(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten2(L, [L]).

% Get all unique nodes
get_nodes([], []).
get_nodes(List, Res) :-
    flatten2(List, R),
    list_to_set(R, Res).

% Find path between 2 nodes
path(A, B, G, Path) :-
       travel(A, [B], G, Path).
travel(A, [A|P1], _, [A|P1]):-!.
travel(A, [Y | P1], G, Path) :- 
    adjacent(X, Y, G),
    \+ member(X, P1),
    travel(A, [X, Y | P1], G, Path), !.

% Create bijection between nodes
pair(Nodes1, Nodes2, Pairs):-
  findall([A,B], (member(A, Nodes1), member(B, Nodes2)), Pairs).

% Check if graph is connected
is_connected(Nodes, Edges) :-
    pair(Nodes, Nodes, Pairs),  % Construct all pairs of nodes
    check_path(Pairs, Edges).   % Try to find path between pair of nodes
check_path([], _).
check_path([[A, B]|T], G) :-
    path(A, B, G, _),
    check_path(T, G).
    

% Create adge from list of nodes. [[A], [B]] -> [A-B]
make_edge([], []).
make_edge([ [[A], [B]] | T], Res) :- 
    make_edge(T, R),
    append(R, [A-B], Res).

% Print all agdes of tree
display_tree([]).
display_tree([H|T]) :-
    display_tree(T),
    format('~w ', H).
    
% Print all trees
show_trees([]).
show_trees([H|T]) :-
    show_trees(T),
    display_tree(H),
    format("\n").



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reads line from stdin, terminates on LF or EOF.
read_line(L,C) :-
    get_char(C),
    (isEOFEOL(C), L = [], !;
        read_line(LL,_),% atom_codes(C,[Cd]),
        [C|LL] = L).

%Tests if character is EOF or LF.
isEOFEOL(C) :-
    C == end_of_file;
    (char_code(C,Code), Code==10).

read_lines(Ls) :-
    read_line(L,C),
    ( C == end_of_file, Ls = [] ;
      read_lines(LLs), Ls = [L|LLs]
    ).


split_line([],[[]]) :- !.
split_line([' '|T], [[]|S1]) :- !, split_line(T,S1).
split_line([32|T], [[]|S1]) :- !, split_line(T,S1).    % aby to fungovalo i s retezcem na miste seznamu
split_line([H|T], [[H|G]|S1]) :- split_line(T,[G|S1]). % G je prvni seznam ze seznamu seznamu G|S1

% vstupem je seznam radku (kazdy radek je seznam znaku)
split_lines([],[]).
split_lines([L|Ls],[H|T]) :- split_lines(Ls,T), split_line(L,H).



start :-
        prompt(_, ''),
        read_lines(LL),
        split_lines(LL,S),
        make_edge(S, Graph),
        get_nodes(S, Nodes),
        !,is_connected(Nodes, Graph),   % Check if graph is connected
        find_all_trees(Graph, Trees),   % Find all trees
        show_trees(Trees),  % Display found trees
        halt.