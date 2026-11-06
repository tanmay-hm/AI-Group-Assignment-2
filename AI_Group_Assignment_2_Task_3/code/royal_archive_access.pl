% ----------------------------------------------------------------------
% Step 1: Predicate logic representation
%
% Predicates:
%   archivist(Person)
%   verifies(Person, Record)
%   trusted(Person)
%   has_access(Person, Record)
%   permitted_to_inspect(Person, Record)
%   inspects(Person, Record)
%   hidden_mark(Record)
%   stored_in_royal_archive(Record)
%   sealed(Record)
%
% Constants:
%   mira, scroll_7
%
% Variables:
%   X = person; R = record
%
% FOL:
%   1. forall X,R: (archivist(X) and verifies(X,R)) -> trusted(X)
%   2. forall X,R: (trusted(X) and has_access(X,R))
%                    -> permitted_to_inspect(X,R)
%   3. forall X,R: (inspects(X,R) and hidden_mark(R))
%                    -> verifies(X,R)
%   4. forall R: stored_in_royal_archive(R) -> sealed(R)
%   5. stored_in_royal_archive(scroll_7)
%   6. has_access(mira, scroll_7)
%   7. inspects(mira, scroll_7)
%   8. hidden_mark(scroll_7)
%   9. archivist(mira)
%
% Goal: trusted(mira)
% ----------------------------------------------------------------------

% Step 2: Negation of goal
%
% Add: not trusted(mira)
%
% Step 3: Implication removal
%
% Rule 1:
%   not archivist(X) or not verifies(X,R) or trusted(X)
%
% Rule 2:
%   not trusted(X) or not has_access(X,R)
%   or permitted_to_inspect(X,R)
%
% Rule 3:
%   not inspects(X,R) or not hidden_mark(R) or verifies(X,R)
%
% Rule 4:
%   not stored_in_royal_archive(R) or sealed(R)

% Step 4: Negation movement
%
% Negations are already applied to individual atoms in the clauses above.

% Step 5: Standardization
%
% Variables in each universally quantified rule are local to that rule.
% They are named X and R here; each clause is standardized apart when used.

% Step 6: Skolemization
%
% No existential quantifiers occur, so no Skolem constants or functions
% are required.

% Step 7: CNF clauses
%
% The general CNF clauses are documented above. The following ground
% instances and facts are the clauses used in the refutation:
%
% C1:  archivist(mira)
% C2:  not archivist(mira) or not verifies(mira,scroll_7)
%      or trusted(mira)
% C3:  not inspects(mira,scroll_7) or not hidden_mark(scroll_7)
%      or verifies(mira,scroll_7)
% C4:  inspects(mira,scroll_7)
% C5:  hidden_mark(scroll_7)
% C6:  not trusted(mira)          (negated goal)

% ----------------------------------------------------------------------
% Step 8: Resolution implementation and execution
% ----------------------------------------------------------------------

% resolve(+Clause1, +Clause2, -Resolvent)
% Using this method to find a resolvent from a pair of clauses having atleast one conflicting literal.

resolve(Clause1, Clause2, Resolvent) :-
    copy_term(Clause1-Clause2, C1-C2),
    select(Literal1, C1, Rest1),
    select(Literal2, C2, Rest2),
    complementary(Literal1, Literal2),
    append(Rest1, Rest2, RawResolvent),
    sort(RawResolvent, Resolvent).

complementary(neg(Atom), Atom).
complementary(Atom, neg(Atom)).

% Ground clauses for the proof.
c1([archivist(mira)]).
c2([neg(archivist(mira)),
    neg(verifies(mira, scroll_7)),
    trusted(mira)]).
c3([neg(inspects(mira, scroll_7)),
    neg(hidden_mark(scroll_7)),
    verifies(mira, scroll_7)]).
c4([inspects(mira, scroll_7)]).
c5([hidden_mark(scroll_7)]).
c6([neg(trusted(mira))]).

% Print and perform each resolution step.
show_step(Description, ClauseA, ClauseB, Resolvent) :-
    resolve(ClauseA, ClauseB, Resolvent),
    format('~w~n', [Description]),
    format('  Parent 1: ~q~n', [ClauseA]),
    format('  Parent 2: ~q~n', [ClauseB]),
    format('  Resolvent: ~q~n~n', [Resolvent]).

run_proof :-
    c1(C1),
    c2(C2),
    c3(C3),
    c4(C4),
    c5(C5),
    c6(C6),

    % Resolve C2 with the archivist fact C1.
    show_step('1. Resolve on archivist(mira):',
              C2, C1, R1),

    % Resolve the resulting clause with C3 on verifies(mira,scroll_7).
    show_step('2. Resolve on verifies(mira,scroll_7):',
              R1, C3, R2),

    % Use the inspection fact.
    show_step('3. Resolve on inspects(mira,scroll_7):',
              R2, C4, R3),

    % Use the hidden-mark fact to derive verifies(mira,scroll_7).
    show_step('4. Resolve on hidden_mark(scroll_7):',
              R3, C5, R4),

    % Resolve trusted(mira) with the negated goal.
    show_step('5. Resolve on trusted(mira):',
              R4, C6, Empty),

    ( Empty == [] ->
        writeln('Empty clause [] derived: contradiction found.'),
        writeln('Therefore trusted(mira) follows from the knowledge base.')
    ;
        format('Expected empty clause, but got: ~q~n', [Empty]),
        fail
    ).
:- initialization(run_proof, main).
