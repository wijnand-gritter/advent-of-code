"""
--- Day 3: Mull It Over ---
https://adventofcode.com/
"""
from aocd import data, submit

#########################
# START SOLUTION PART 1 #
#########################

import re

data = data.strip()

multiplication_pattern  = r"mul\((\d{1,}),(\d{1,3})\)"
command_pattern  = rf"\)\({'do'[::-1]}|\)\({'don\'t'[::-1]}"

part1_total = 0
part2_total = 0

for match in re.finditer(multiplication_pattern, data):
    x, y = map(int, match.groups())
    part1_total += x * y
    preceding_data = data[:match.start()][::-1]
    last_command = re.search(command_pattern, preceding_data)
    if last_command and last_command.group() == "don't()"[::-1]:
        continue
    part2_total += x * y

print(f"Part 1: {part1_total}")
print(f"Part 2: {part2_total}")

#submit(part2_total)

##################
#  END SOLUTION  #
##################