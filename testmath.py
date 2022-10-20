
from mpmath import mp
mp.dps = 40

# import numpy as np
# import sympy as sp
# p = np.matrix([[0.99528354, 0, 0, 0],[0,1.3270448,0,0],[0,0,-1.0002,0],[0,0,-1.,0.]])
# y = sp.var("y")
# x = sp.var("x")
# z = sp.var("z")
# v = sp.Matrix([[x,y,z,1.]]).T
# vw = p*v
# print(vw/vw[3])


#   ┌                                             ┐
#   │ 0.99528354          0          0          0 │
#   │          0  1.3270448          0          0 │
#   │          0          0    -1.0002          0 │
#   │          0          0         -1          0 │
#   └                                             ┘


with open("mult.txt") as file:
    percerrors = []
    errors = []
    for line in file:
        a, b, c = line.split()
        a = mp.mpf(a) / 2**14
        b = mp.mpf(b) / 2**14
        c = mp.mpf(c) / 2**14
        errors.append(a*b-c)
        percerrors.append((a*b-c)/(a*b))
        if (a*b-c)/(a*b) > 0.005:
            print(a,b,c)
    print(max(percerrors), sum(errors), sum(percerrors)/len(percerrors), sum(errors)/len(errors))

# noround   732.355224609375 0.000007543577790232777332720409291189368556142 0.0003662109375
# yesround  732.355224609375 0.000007543577790232777332720409291189368556142 0.0003662109375
