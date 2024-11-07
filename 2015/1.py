"""
--- Day 1: Not Quite Lisp ---
https://adventofcode.com/2015/day/1
"""
from aocd import data
from aocd import submit

direction = {"(": +1, ")": -1}
basement = None
floor = 0
for i, c in enumerate(data, 1):
    floor += direction[c]
    if basement is None and floor == -1:
        basement = i

answers = [floor, basement]

for answer in answers:
    print(answer)


#submit(floor, part="a", day=1, year=2015)
#submit(basement, part="b", day=1, year=2015)