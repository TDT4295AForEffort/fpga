

from cmath import sin
from math import cos, floor, pi, sin

def vec_from_angle(angle_rad):
    return [cos(angle_rad), sin(angle_rad)]

def convert_to_fixed_point(number, int_bit_size=18, fractional_bit_size=14):
    num = hex(floor(number*2**fractional_bit_size))
    sign = ''
    if(num[0] == '-'): 
        sign = '-'
        num = num[1:]
    return "{}'h".format(int_bit_size+fractional_bit_size) + sign + num[2:]



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

# for i in range(len(player_pos_init)):
#     print("player_pos[{}] = {};".format(i, convert_to_fixed_point(player_pos_init[i])))

# for i in range(len(board)):
#     print("bit_map[{}] = 8'b{};".format(i,board[i]))

print(convert_to_fixed_point(0.99))
