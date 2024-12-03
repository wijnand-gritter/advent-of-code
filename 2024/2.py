"""
--- Day 2: Red-Nosed Reports ---
https://adventofcode.com/
"""
from aocd import data, submit

#########################
# START SOLUTION PART 1 #
#########################

def is_safe(levels):
    diffs = {levels[i + 1] - levels[i] for i in range(len(levels) - 1)}
    return diffs <= {1, 2, 3} or diffs <= {-1, -2, -3}

def is_tolerated(levels):
    return any(is_safe(levels[:i] + levels[i + 1:]) for i in range(len(levels)))

reports = [list(map(int, line.split())) for line in data.splitlines()]

part1 = sum(is_safe(report) for report in reports)
part2 = sum(is_safe(report) or is_tolerated(report) for report in reports)

print(f"Part 1: {part1}")
print(f"Part 2: {part2}")

# Submit to AOC
#submit(answer)

##################
#  END SOLUTION  #
##################