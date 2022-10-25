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


def test_file():
    with open("mult.txt") as file:
        percerrors = []
        errors = []
        _as = []
        bs = []
        cs = []
        for line in file:
            try:
                a, b, c = line.split()
                _as.append(a)
                bs.append(b)
                cs.append(c)

            except ValueError as e:
                print(e, line)
        for i in range(4, len(_as)):
            a = mp.mpf(_as[i]) / 2 ** 14
            b = mp.mpf(bs[i]) / 2 ** 14
            c = mp.mpf(cs[i-4]) / 2 ** 14
            cp = 1 / a
            e = cp-c
            errors.append(e)
            percerrors.append(e / cp)
            if (e/cp) > 0.5:
                print(e/cp, e, a, b, c, cp)
        print(max(percerrors), sum(errors), sum(percerrors) / len(percerrors), sum(errors) / len(errors))


# noround   732.355224609375 0.000007543577790232777332720409291189368556142 0.0003662109375
# yesround  732.355224609375 0.000007543577790232777332720409291189368556142 0.0003662109375


def reciprocal(x):
    xp = x / 2 ** 7
    rp = 2.82352941 - 1.88235294 * xp
    err = 1/xp - rp
    print(err)
    while abs(err) > 1/2**31:
        rp = rp + rp*(1 - xp * rp)
        err = 1/xp - rp
        print(err)
    return rp / 2**7

# print(reciprocal(83.3), 1/83.3)
test_file()