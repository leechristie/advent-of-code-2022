ins = set()
outs = set()
with open('input19a.txt') as file:
    for line in file:
        inp, outp = line.strip().split(',')
        ins.add(inp)
        outs.add(outp)
target = 'CRnSiRnCaPTiMgYCaPTiRnFArSiThFArCaSiThSiThPBCaCaSiRnSiRnTiTiMgArPBCaPMgYPTiRnFArFArCaSiRnBPMgArPRnCaPTiRnFArCaSiThCaCaFArPBCaCaPTiTiRnFArCaSiRnSiAlYSiThRnFArArCaSiRnBFArCaCaSiRnSiThCaCaCaFYCaPTiBCaSiThCaSiThPMgArSiRnCaPBFYCaCaFArCaCaCaCaSiThCaSiRnPRnFArPBSiThPRnFArSiRnMgArCaFYFArCaSiRnSiAlArTiTiTiTiTiTiTiRnPMgArPTiTiTiBSiRnSiAlArTiTiRnPMgArCaFYBPBPTiRnSiRnMgArSiThCaFArCaSiThFArPRnFArCaSiRnTiBSiThSiRnSiAlYCaFArPRnFArSiThCaFArCaCaSiThCaCaCaSiRnPRnCaFArFYPMgArCaPBCaPBSiRnFYPBCaFArCaSiAl'

def split(item):
    buffer = ''
    while item:
        first, item = item[0], item[1:]
        if first.isupper() and buffer:
            yield buffer
        if first.isupper():
            buffer = first
        else:
            buffer += first
    if buffer:
        yield buffer

outs_split = set()

for item in outs:
    outs_split.update(set(split(item)))

target_split = set(split(target))

print(outs_split)
print()
print(target_split)

for i in outs_split:
    if not i in ins:
        print(f'not found: {i} from outs')

for i in target_split:
    if not i in ins:
        print(f'not found: {i} from target')
#%%

# the four items which cannot change to anything
unconvertable = {'Rn', 'C', 'Y', 'Ar'}

print('sequence of unconvertables in target:')
print('numbers indicate how many convertables in between, skipped if 0')
counter = 0
how_many_unc = 0
for i in split(target):
    if i in unconvertable:
        if counter:
            print(counter, end=' ')
        print(f'({i})', end=' ')
        how_many_unc += 1
        counter = 0
    else:
        counter += 1
if counter:
    print(counter, end=' ')
print()
print(f'{how_many_unc} unconvertables in target')

print('target len -1 =', len(list(split(target)))-1)
print('min rate -1 =', min([len(list(split(o))) for o in outs])-1)
print('max rate -1 =', max([len(list(split(o))) for o in outs])-1)

print(284/7)

# since the length increases by 1, 2, 3, 4, 5, 6, or 7 elements each time
# and never goes down
# fastest possible optimum: 41 steps
# slowest possible optimum: 284 steps
# so the answer is in [41, 284]


#%%

# there are 75 unconvertables in the target
# number of unconvertables
# at start h = 0
# at end h = 75
#   we know this number can never go down as the search proceeds from e -> target
#   if we reach a state where h = 75 and it's not exactly the goal
#   then it's wrong

# not really a heuristic though... can we make something from this?

for o in outs:
    print(o, end='\t')
    o = list(split(o))
    c = 0
    for e in o:
        if e in unconvertable:
            c += 1
    print(c)

# most edits introduce 0 unconvertables
# max is +5
# does not narrow down the range, still [41, 284]

# possible starts (manually worked out, no code):

# 0 steps
# e

# 1 step
# HF
# NAl
# OMg

# 2 steps
# OBF (by two possible routes)
# HCaF (by two possible routes)
# NThF (by two possible routes)
# HPMg (by two possible routes)
# OTiMg (by two possible routes)
# HSiAl (by two possible routes)
# ORnFArF
# NRnMgArF
# CRnFArAl
# CRnAlArF
# NThRnFAr
# NRnFArMg
# NRnFYFArF
# CRnMgArMg
# CRnFYMgArF
# CRnMgYFArF
# CRnFYFArMg
# CRnFYFYFArF

# so 18 possible at step 2
# can parallel search but
# each returns a results from [39, 282]
# there will be cases when one start leads somewhere faster than another
# need to take `min( ALL STARTS ) + 2` [41, 284]
# so all need to complete
