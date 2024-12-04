"""
--- Day 4: Ceres Search ---
https://adventofcode.com/
"""
from aocd import data, submit
import re

##################
# START SOLUTION #
##################

# Used ChatGPT to format and comment this code for better understandability :)

# Input processing: Prepare rows, columns, and diagonals from the input grid
rows = data.splitlines()  # Split the data into lines (rows of the grid)
columns = ["".join(column) for column in zip(*rows)]  # Get columns by transposing the rows

# Generate diagonals:
# For each row, pad with spaces to align diagonals correctly, then extract diagonals
diagonal_top_left_to_bottom_right = [
    "".join(row).strip()
    for row in zip(*[" " * i + r + " " * (len(rows) - i - 1) for i, r in enumerate(rows)])
]
diagonal_top_right_to_bottom_left = [
    "".join(row).strip()
    for row in zip(*[" " * i + r + " " * (len(rows) - i - 1) for i, r in enumerate(rows[::-1])])
]

# Part 1: Count "XMAS" and "SAMX" occurrences
# Define the pattern to search for
pattern = r"(?=(XMAS|SAMX))"

# Initialize the total count
total_matches = 0

# Search for matches in rows, columns, and both diagonals
all_lines_to_search = rows + columns + diagonal_top_left_to_bottom_right + diagonal_top_right_to_bottom_left
for line in all_lines_to_search:
    matches = re.findall(pattern, line)  # Find all matches in the current line
    total_matches += len(matches)  # Add the number of matches to the total

print(f"Part 1 Total Matches: {total_matches}")

# Part 2: Count crosses (patterns with 'A' at the center)
# Initialize the cross count
total_crosses = 0

# Loop through the grid, skipping the outermost rows and columns (no valid crosses there)
for row_index in range(1, len(rows) - 1):
    for col_index in range(1, len(rows[0]) - 1):
        # Check if the center of the cross is 'A'
        if rows[row_index][col_index] == 'A':
            # Build the two diagonal patterns passing through the center
            diagonal_1 = rows[row_index - 1][col_index - 1] + 'A' + rows[row_index + 1][col_index + 1]
            diagonal_2 = rows[row_index - 1][col_index + 1] + 'A' + rows[row_index + 1][col_index - 1]

            # Check if both diagonals match the required patterns ("MAS" or "SAM")
            if diagonal_1 in {"MAS", "SAM"} and diagonal_2 in {"MAS", "SAM"}:
                total_crosses += 1  # Increment the cross count

print(f"Part 2 Total Crosses: {total_crosses}")

submit(total_crosses)
##################
#  END SOLUTION  #
##################