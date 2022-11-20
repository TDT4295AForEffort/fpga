

from cmath import sin
from math import cos, floor, pi, sin, sqrt

def vec_from_angle(angle_rad):
    return [cos(angle_rad), sin(angle_rad)]

def convert_to_fixed_point(number, int_bit_size=18, fractional_bit_size=14):
    num = hex(floor(number*2**fractional_bit_size))
    sign = ''
    if(num[0] == '-'): 
        sign = '-'
        num = num[1:]
    return "{}{}'h".format(sign, int_bit_size+fractional_bit_size) + num[2:]

def fixed_to_decimal(val, base=16):
    s = int(val, base=base)
    return s*2**(-14)


board = [
    "11111111",
    "10101011",
    "10000001",
    "11010101",
    "10000001",
    "10001011",
    "10000001",
    "11111111"
         ]

player_pos_init = [2.5, 5.5]
player_direction = vec_from_angle(pi/4)
hfov = 90

# for i in range(len(player_direction)):
#     print("player_direction[{}] = {};".format(i, convert_to_fixed_point(player_direction[i])))

player_positions = [
    [2.0, 6.0], 
    [2.1, 5.9], 
    [2.2, 5.8], 
    [2.3, 5.7], 
    [2.4, 5.6],
    [2.5, 5.5], 
    [2.6, 5.4], 
    [2.7, 5.3], 
    [2.8, 5.2], 
    [2.9, 5.1], 
    ]

# for i in range(1, 2*len(player_positions), 2):
#     print("player_positions[{}] = {};".format(i-1, convert_to_fixed_point(player_positions[int(i/2)][0])))
#     print("player_positions[{}] = {};".format(i, convert_to_fixed_point(player_positions[int(i/2)][1])))

# print()
# print("if(counter < 60) begin")
# print("     player_pos[0] <= player_position[0];")
# print("     player_pos[1] <= player_position[1];")
# for i in range(0, 2*len(player_positions), 2):
#     print("end else if(counter >= {} && counter <= {}) begin".format(30*i, 30*i + 60))
#     print("     player_pos[0] <= player_positions[{}];".format(i))
#     print("     player_pos[1] <= player_positions[{}];".format(i+1))
# print("     counter <= 0;")
# print("     end")
# for i in range(len(board)):
#     print("bit_map[{}] = 8'b{};".format(i,board[i]))


# print(convert_to_fixed_point(1))
# print(convert_to_fixed_point(0))
factor = 1
angle = (5/180)*pi
# print("A")
# print(convert_to_fixed_point(cos(angle)*factor))
# print(convert_to_fixed_point(sin(angle)*factor))
# print(convert_to_fixed_point(-sin(angle)*factor))
# print(convert_to_fixed_point(cos(angle)*factor))

# print("B")
# print(convert_to_fixed_point(cos(-angle)*factor))
# print(convert_to_fixed_point(sin(-angle)*factor))
# print(convert_to_fixed_point(-sin(-angle)*factor))
# print(convert_to_fixed_point(cos(-angle)*factor))

#print(convert_to_fixed_point(0.1))
# print(fixed_to_decimal('0xd0b6'))
# print(fixed_to_decimal('0xef51'))

# Magic constant: 1.327

# for i in range(16):
#     print("[{} : {}]".format(4095 - 16*i, 4096 - 16*(i+1)))

# def print_bit_map(bitmap):
#     e = 0
#     for i in bitmap[2:]:
#         print("{:>4}".format(bin(int("0x" + i, base=16))[2:]), end="")
#         if(e == 3):
#             print("\n", end="")
#             e = 0
#         else:
#             e += 1

# map_top = "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
# map_bot = "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
# numbr2 = "0xfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfc" # High end of world_map

# number = "0xffff80018001800180018001800180018001800180018001800180018001ffff"
# # 1111111111111111
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1000000000000001
# # 1111111111111111
# emmas_map0 = "0xfefe00020002000200020002000200020002000200020002000200020002fefe"
# emmas_map1 = "0xfefee0001800060000c00030000c0002800060001800060000c00030000c000280007efe"
# emmas_map2 = "0xffff80018001800180018001800180018001800180018001800180018001ffff"
# active = emmas_map2
# print(len(active))
# print_bit_map(active)


# a = fixed_to_decimal("0x000032ce")
# b = fixed_to_decimal("0x000026ec")
# print(a) 
# print(b)
# print(sqrt(a**2+b**2))

af = "0x0035147a"
ad = fixed_to_decimal(af)
bd = ad*3
bf = convert_to_fixed_point(bd)
print(af)
print(ad)
print(bd)
print(bf)

# print(fixed_to_decimal("0x00004000"))
# print(fixed_to_decimal("0x00002d41"))
# print(fixed_to_decimal("0x00002d41"))
# print(fixed_to_decimal("0x00002d41"))
# print(fixed_to_decimal("0xffffd2bf"))
# print(fixed_to_decimal("0x00000000"))
# print(fixed_to_decimal("0xffffc000"))






















