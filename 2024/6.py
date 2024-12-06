"""
--- Day 5: Print Queue ---
https://adventofcode.com/
"""
from aocd import data, submit
import re

##################
# START SOLUTION #
##################

# Direction vectors (up, right, down, left)
DIRECTIONS = [
    (-1, 0),  # Up
    (0, 1),   # Right
    (1, 0),   # Down
    (0, -1)   # Left
]

DIRECTION_SYMBOLS = "^>v<"

def find_initial_position(grid):
    #Find the starting position and direction of the guard.
    for r, row in enumerate(grid):
        for c, cell in enumerate(row):
            if cell in DIRECTION_SYMBOLS:
                return r, c, DIRECTION_SYMBOLS.index(cell)
    raise ValueError("No guard starting position found in the grid")

def simulate_movement(grid, start_row, start_col, start_dir, obstacle_row=None, obstacle_col=None):
    #Simulate the guard's movement.
    rows, cols = len(grid), len(grid[0])
    guard_row, guard_col, guard_dir = start_row, start_col, start_dir
    visited = set()
    visited.add((guard_row, guard_col, guard_dir))

    while True:
        dr, dc = DIRECTIONS[guard_dir]
        next_row, next_col = guard_row + dr, guard_col + dc

        # Check grid boundaries
        if not (0 <= next_row < rows and 0 <= next_col < cols):
            return False  # Guard leaves the grid

        # Check for obstacle
        is_obstacle = (
            (next_row == obstacle_row and next_col == obstacle_col) or
            grid[next_row][next_col] == "#"
        )

        if is_obstacle:
            # Turn right
            guard_dir = (guard_dir + 1) % 4
        else:
            # Move forward
            guard_row, guard_col = next_row, next_col

        state = (guard_row, guard_col, guard_dir)
        if state in visited:
            return True  # Loop detected
        visited.add(state)

def part_1(grid):
    #part 1: Count distinct positions visited by the guard.
    start_row, start_col, start_dir = find_initial_position(grid)
    rows, cols = len(grid), len(grid[0])
    visited = set()
    guard_row, guard_col, guard_dir = start_row, start_col, start_dir
    visited.add((guard_row, guard_col))

    while True:
        dr, dc = DIRECTIONS[guard_dir]
        next_row, next_col = guard_row + dr, guard_col + dc

        if not (0 <= next_row < rows and 0 <= next_col < cols):
            break  # Guard leaves the grid

        if grid[next_row][next_col] == "#":
            guard_dir = (guard_dir + 1) % 4
        else:
            guard_row, guard_col = next_row, next_col
            visited.add((guard_row, guard_col))

    return len(visited)

def part_2(grid):
    #Solve part 2: Count valid positions for placing a new obstruction.
    start_row, start_col, start_dir = find_initial_position(grid)
    rows, cols = len(grid), len(grid[0])
    valid_positions = 0

    for r in range(rows):
        for c in range(cols):
            # Skip walls and starting position
            if grid[r][c] == "#" or (r == start_row and c == start_col):
                continue

            # Simulate with an obstacle at (r, c)
            if simulate_movement(grid, start_row, start_col, start_dir, obstacle_row=r, obstacle_col=c):
                valid_positions += 1

    return valid_positions


input_data = [line.strip() for line in data.splitlines()]

# Solve part 1
part1_result = part_1(input_data)
print(f"Part 1: Distinct positions visited: {part1_result}")

# Solve part 2
part2_result = part_2(input_data)
print(f"Part 2: Valid positions for a new obstruction: {part2_result}")

##################
#  END SOLUTION  #
##################