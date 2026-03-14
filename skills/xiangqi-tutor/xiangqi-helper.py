#!/usr/bin/env python3
"""
Xiangqi (Chinese Chess) Helper Script
Provides move validation and board visualization for the teaching bot
"""

import sys
import json

class XiangqiBoard:
    """Simple Xiangqi board representation and move validator"""

    def __init__(self):
        # Board is 9x10 (columns a-i, rows 1-10)
        self.board = self.setup_initial_board()

    def setup_initial_board(self):
        """Setup standard Xiangqi starting position"""
        board = {}

        # Red pieces (capital letters) - bottom
        board['a1'] = 'R'; board['i1'] = 'R'  # Rooks
        board['b1'] = 'H'; board['h1'] = 'H'  # Horses
        board['c1'] = 'E'; board['g1'] = 'E'  # Elephants
        board['d1'] = 'A'; board['f1'] = 'A'  # Advisors
        board['e1'] = 'G'                      # General
        board['b3'] = 'C'; board['h3'] = 'C'  # Cannons
        board['a4'] = 'S'; board['c4'] = 'S'; board['e4'] = 'S'
        board['g4'] = 'S'; board['i4'] = 'S'  # Soldiers

        # Black pieces (lowercase) - top
        board['a10'] = 'r'; board['i10'] = 'r'  # Rooks
        board['b10'] = 'h'; board['h10'] = 'h'  # Horses
        board['c10'] = 'e'; board['g10'] = 'e'  # Elephants
        board['d10'] = 'a'; board['f10'] = 'a'  # Advisors
        board['e10'] = 'g'                       # General
        board['b8'] = 'c'; board['h8'] = 'c'    # Cannons
        board['a7'] = 's'; board['c7'] = 's'; board['e7'] = 's'
        board['g7'] = 's'; board['i7'] = 's'    # Soldiers

        return board

    def display_board(self):
        """Display the current board state"""
        print("   a b c d e f g h i")
        for row in range(10, 0, -1):
            print(f"{row:2} ", end="")
            for col in 'abcdefghi':
                pos = f"{col}{row}"
                piece = self.board.get(pos, '.')
                print(f"{piece} ", end="")
            side = "← Black" if row == 10 else ("← Red" if row == 1 else "")
            print(side)
        print()

    def col_to_index(self, col):
        """Convert column letter to index"""
        return ord(col) - ord('a')

    def index_to_col(self, idx):
        """Convert index to column letter"""
        return chr(ord('a') + idx)

    def is_valid_position(self, pos):
        """Check if position is on the board"""
        if len(pos) < 2:
            return False
        col, row = pos[0], pos[1:]
        try:
            row = int(row)
            return col in 'abcdefghi' and 1 <= row <= 10
        except ValueError:
            return False

    def is_red_piece(self, piece):
        """Check if piece belongs to Red"""
        return piece and piece.isupper()

    def is_black_piece(self, piece):
        """Check if piece belongs to Black"""
        return piece and piece.islower()

    def same_color(self, piece1, piece2):
        """Check if two pieces are the same color"""
        if not piece1 or not piece2:
            return False
        return (self.is_red_piece(piece1) and self.is_red_piece(piece2)) or \
               (self.is_black_piece(piece1) and self.is_black_piece(piece2))

    def in_palace(self, pos):
        """Check if position is inside a palace"""
        col, row = pos[0], int(pos[1:])
        col_idx = self.col_to_index(col)
        return (3 <= col_idx <= 5) and (row in [1,2,3] or row in [8,9,10])

    def crossed_river(self, pos, is_red):
        """Check if position is across the river"""
        row = int(pos[1:])
        if is_red:
            return row > 5
        else:
            return row <= 5

    def validate_soldier_move(self, from_pos, to_pos):
        """Validate soldier movement"""
        piece = self.board.get(from_pos)
        if not piece or piece.upper() != 'S':
            return False, "Not a soldier"

        is_red = self.is_red_piece(piece)
        from_col, from_row = from_pos[0], int(from_pos[1:])
        to_col, to_row = to_pos[0], int(to_pos[1:])

        # Check if target is occupied by same color
        target = self.board.get(to_pos)
        if target and self.same_color(piece, target):
            return False, "Cannot capture your own piece"

        # Before crossing river: only forward
        if not self.crossed_river(from_pos, is_red):
            if is_red:
                if to_row == from_row + 1 and to_col == from_col:
                    return True, "Valid forward move"
            else:
                if to_row == from_row - 1 and to_col == from_col:
                    return True, "Valid forward move"
            return False, "Soldier can only move forward before crossing river"

        # After crossing river: forward or sideways
        row_diff = abs(to_row - from_row)
        col_diff = abs(self.col_to_index(to_col) - self.col_to_index(from_col))

        # One step forward or sideways
        if (row_diff == 1 and col_diff == 0) or (row_diff == 0 and col_diff == 1):
            # Check direction for forward
            if row_diff == 1:
                if is_red and to_row > from_row:
                    return True, "Valid forward move"
                elif not is_red and to_row < from_row:
                    return True, "Valid forward move"
                else:
                    return False, "Soldier cannot move backward"
            return True, "Valid sideways move"

        return False, "Soldier moves one point at a time"

    def validate_rook_move(self, from_pos, to_pos):
        """Validate rook movement"""
        piece = self.board.get(from_pos)
        if not piece or piece.upper() != 'R':
            return False, "Not a rook"

        from_col, from_row = from_pos[0], int(from_pos[1:])
        to_col, to_row = to_pos[0], int(to_pos[1:])

        # Must move horizontally or vertically
        if from_col != to_col and from_row != to_row:
            return False, "Rook must move horizontally or vertically"

        # Check for obstacles
        if from_col == to_col:  # Vertical movement
            start_row = min(from_row, to_row) + 1
            end_row = max(from_row, to_row)
            for row in range(start_row, end_row):
                if f"{from_col}{row}" in self.board:
                    return False, f"Path blocked at {from_col}{row}"
        else:  # Horizontal movement
            start_col = min(self.col_to_index(from_col), self.col_to_index(to_col)) + 1
            end_col = max(self.col_to_index(from_col), self.col_to_index(to_col))
            for col_idx in range(start_col, end_col):
                col = self.index_to_col(col_idx)
                if f"{col}{from_row}" in self.board:
                    return False, f"Path blocked at {col}{from_row}"

        # Check if target is same color
        target = self.board.get(to_pos)
        if target and self.same_color(piece, target):
            return False, "Cannot capture your own piece"

        return True, "Valid rook move"

    def validate_move(self, from_pos, to_pos, piece_type=None):
        """Validate any move"""
        if not self.is_valid_position(from_pos):
            return False, f"Invalid starting position: {from_pos}"
        if not self.is_valid_position(to_pos):
            return False, f"Invalid target position: {to_pos}"

        piece = self.board.get(from_pos)
        if not piece:
            return False, f"No piece at {from_pos}"

        piece_upper = piece.upper()

        # Route to specific piece validator
        if piece_upper == 'S':
            return self.validate_soldier_move(from_pos, to_pos)
        elif piece_upper == 'R':
            return self.validate_rook_move(from_pos, to_pos)
        # Add other pieces as needed
        else:
            return False, f"Move validation not yet implemented for {piece_upper}"

    def make_move(self, from_pos, to_pos):
        """Execute a move on the board"""
        valid, message = self.validate_move(from_pos, to_pos)
        if not valid:
            return False, message

        # Move the piece
        piece = self.board[from_pos]
        if to_pos in self.board:
            captured = self.board[to_pos]
            del self.board[from_pos]
            self.board[to_pos] = piece
            return True, f"Moved {piece} from {from_pos} to {to_pos}, captured {captured}"
        else:
            del self.board[from_pos]
            self.board[to_pos] = piece
            return True, f"Moved {piece} from {from_pos} to {to_pos}"


def main():
    """Command-line interface for the helper"""
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 xiangqi-helper.py display")
        print("  python3 xiangqi-helper.py validate <from> <to>")
        print("  python3 xiangqi-helper.py move <from> <to>")
        return

    board = XiangqiBoard()
    command = sys.argv[1]

    if command == "display":
        board.display_board()

    elif command == "validate" and len(sys.argv) >= 4:
        from_pos = sys.argv[2]
        to_pos = sys.argv[3]
        valid, message = board.validate_move(from_pos, to_pos)
        print(f"Valid: {valid}")
        print(f"Message: {message}")
        sys.exit(0 if valid else 1)

    elif command == "move" and len(sys.argv) >= 4:
        from_pos = sys.argv[2]
        to_pos = sys.argv[3]
        success, message = board.make_move(from_pos, to_pos)
        print(message)
        if success:
            print("\nBoard after move:")
            board.display_board()
        sys.exit(0 if success else 1)

    else:
        print("Unknown command or missing arguments")
        sys.exit(1)


if __name__ == "__main__":
    main()
