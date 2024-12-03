"""
--- Day 1: Historian Hysteria ---
https://adventofcode.com/
"""
from aocd import data, submit

#########################
# START SOLUTION PART 1 #
#########################

cleanData = data.strip().split("\n")

matrix = [list(map(int, line.split("   "))) for line in cleanData]

rotated = [list(row) for row in zip(*matrix[::-1])]

sorted_matrix = [sorted(row) for row in rotated]

first_row, second_row = sorted_matrix[0], sorted_matrix[1]
difference_sum = sum(abs(first_row[i] - second_row[i]) for i in range(len(first_row)))
print(difference_sum) # Part 1

similarity = sum(second_row.count(value) * value for value in first_row)
print(similarity) # Part 2

#submit(similarity)
##################
#  END SOLUTION  #
##################