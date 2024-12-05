"""
--- Day 5: Print Queue ---
https://adventofcode.com/
"""
from aocd import data, submit
import re

##################
# START SOLUTION #
##################

def parse_numbers(line, delimiter):
    """Convert a delimited string into a list of integers."""
    return [int(num) for num in line.strip().split(delimiter)]

def is_rule_violated(sequence, x, y):
    """Check if a sequence violates a rule where x must come before y."""
    return x in sequence and y in sequence and sequence.index(x) > sequence.index(y)

def apply_rules(sequence, rules):
    """Rearrange a sequence to fix rule violations."""
    fixed_sequence = sequence[:]
    while True:
        for x, y in rules:
            if is_rule_violated(fixed_sequence, x, y):
                # Swap elements to fix the violation
                ix, iy = fixed_sequence.index(x), fixed_sequence.index(y)
                fixed_sequence[ix], fixed_sequence[iy] = fixed_sequence[iy], fixed_sequence[ix]
                break
        else:
            # Exit loop if no rule violations remain
            return fixed_sequence

def get_middle_elements(pages):
    """Get the middle element of each page."""
    return [page[len(page) // 2] for page in pages]

# Parse the input data
lines = [line.strip() for line in data.splitlines()]
rules = [parse_numbers(line, "|") for line in lines if "|" in line]
pages = [parse_numbers(line, ",") for line in lines if "," in line]

# Categorize pages based on rule violations
correct_pages = [page for page in pages if not any(is_rule_violated(page, x, y) for x, y in rules)]
fixed_pages = [apply_rules(page, rules) for page in pages if page not in correct_pages]

# Calculate results
part1_result = sum(get_middle_elements(correct_pages))
part2_result = sum(get_middle_elements(fixed_pages))

print("part1:", part1_result)
print("part2:", part2_result)

submit(part2_result)

##################
#  END SOLUTION  #
##################