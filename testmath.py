from mpmath import mp
import math

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
            a = mp.mpf(_as[i-4]) / 2 ** 14
            b = mp.mpf( bs[i-4]) / 2 ** 14
            c = mp.mpf( cs[i]) / 2 ** 14
            cpy = a / b
            e = cpy-c
            errors.append(e)
            percerrors.append(e / cpy)
            if (e/cpy) > 0.4:
                print(f"e%: {e/cpy}, e:{e}, a:{a}, b:{b}, c:{c}, cpy:{cpy}")
        print(max(percerrors), sum(errors), sum(percerrors) / len(percerrors), sum(errors) / len(errors))


# noround   732.355224609375 0.000007543577790232777332720409291189368556142 0.0003662109375
# yesround  732.355224609375 0.000007543577790232777332720409291189368556142 0.0003662109375


def reciprocal(x):
    shiftamnt = math.ceil(math.log2(x))
    xp = x / 2**shiftamnt
    rp = 2.82352941 - 1.88235294 * xp
    err = 1/xp - rp
    print(err)
    while abs(err) > 1/2**31:
        rp = rp + rp*(1 - xp * rp)
        err = 1/xp - rp
        print(err)
    return rp / 2**shiftamnt

def intreciprocal(x):
    xp1 = x*2**14
    shiftamnt = 29-math.ceil(math.log2(xp1))
    shifted = xp1*2**shiftamnt
    c_1d88235284 = 1010580486
    c_2d82352941 = 1515870809
    c_1d0 = 1<<29
    firstmultres = c_1d88235284*shifted
    firstguess = c_2d82352941 - int(firstmultres*2**-29)
    second_shiftedyguess = int(shifted * firstguess)
    second_product = int(firstguess * (c_1d0 - int(second_shiftedyguess*2**-29)))
    secondguess = firstguess + int(second_product*2**-29)
    print(secondguess)


x = 0.5078125
# print(intreciprocal(x), 1/x)
test_file()