import re, sys

def load_init(problem):
    txt = open(problem).read().lower()
    init = txt[txt.index('(:init'):txt.index('(:goal')]
    goal = txt[txt.index('(:goal'):]
    facts = lambda s: set(re.findall(r'\((?!and|:)([a-z\-]+(?: [a-z0-9]+)*)\)', s))
    return facts(init), facts(goal)

def step(state, line):
    a = line.strip('()\n').split()
    name, args = a[0], a[1:]
    if name == 'move':
        r, f, t = args
        assert f'at-rover {r} {f}' in state and f'connected {f} {t}' in state
        state -= {f'at-rover {r} {f}'}; state |= {f'at-rover {r} {t}'}
    elif name == 'pick-drill':
        r, d, l = args
        assert f'at-rover {r} {l}' in state and f'at-drill {d} {l}' in state
        state -= {f'at-drill {d} {l}'}; state |= {f'has-drill {r} {d}'}
    elif name in ('collect-soft', 'collect-hard'):
        r, k, b, l = args[:4]
        assert f'at-rover {r} {l}' in state and f'at-rock {k} {l}' in state and f'bay-empty {b}' in state
        if name == 'collect-hard':
            assert f'has-drill {r} {args[4]}' in state
        state -= {f'at-rock {k} {l}', f'bay-empty {b}'}; state |= {f'bay-holds {b} {k}'}
    elif name == 'deposit':
        r, k, b, l = args
        assert f'at-rover {r} {l}' in state and f'bay-holds {b} {k}' in state
        state -= {f'bay-holds {b} {k}'}; state |= {f'at-rock {k} {l}', f'bay-empty {b}'}

problem, plan = sys.argv[1], sys.argv[2]
state, goal = load_init(problem)
steps = [l for l in open(plan) if l.strip().startswith('(')]
for i, l in enumerate(steps, 1):
    step(state, l)
print(f'{len(steps)} actions executed, all preconditions satisfied')
print('final state:')
for f in sorted(x for x in state if not x.startswith('connected')):
    print('  ', f)
missing = goal - state
print('goal satisfied' if not missing else f'goal NOT satisfied, missing: {missing}')
