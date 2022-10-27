

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

for i in range(1, 2*len(player_positions), 2):
    print("player_positions[{}] = {};".format(i-1, convert_to_fixed_point(player_positions[int(i/2)][0])))
    print("player_positions[{}] = {};".format(i, convert_to_fixed_point(player_positions[int(i/2)][1])))

print()
# print("if(counter < 60) begin")
# print("     player_pos[0] <= player_position[0];")
# print("     player_pos[1] <= player_position[1];")
for i in range(0, 2*len(player_positions), 2):
    print("end else if(counter >= {} && counter <= {}) begin".format(30*i, 30*i + 60))
    print("     player_pos[0] <= player_positions[{}];".format(i))
    print("     player_pos[1] <= player_positions[{}];".format(i+1))
print("     counter <= 0;")
print("     end")
# for i in range(len(board)):
#     print("bit_map[{}] = 8'b{};".format(i,board[i]))

# Magic constant: 1.327


