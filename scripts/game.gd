extends Node2D

const CELL_EMPTY = "   "
const CELL_X = " X "
const CELL_O = " O "

@onready var win_label = $"Win Screen/WinLabel"

# Variables for the board state
var board = [
	[CELL_EMPTY, CELL_EMPTY, CELL_EMPTY],
	[CELL_EMPTY, CELL_EMPTY, CELL_EMPTY],
	[CELL_EMPTY, CELL_EMPTY, CELL_EMPTY],
]

# Keeps track of the current player ('X' or 'O')
var current_player = CELL_X

# Called when the node enters the scene tree for the first time.
func _ready():
	win_label.text = ""
	for button in $GridContainer.get_children():
		button.connect("pressed", _on_button_pressed.bind(button))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_button_pressed(button):
	var index = get_index_from_button(button)
	if board[index.x][index.y] == CELL_EMPTY:
		board[index.x][index.y] = current_player
		button.text = current_player
		button.disabled = true
		if check_win_condition():
			win_label.text = ("Player 1 (X)" if current_player == CELL_X else "Player 2 (O)") + " wins!"
			reset_game()
		elif is_board_full():
			win_label.text = "It's a draw!"
			reset_game()
		else:
			current_player = CELL_O if (current_player == CELL_X) else CELL_X

func get_index_from_button(button):
	var idx = $GridContainer.get_children().find(button)
	return Vector2(idx % 3, idx / 3)

# Check for a win
func check_win_condition():
	for i in range(3):
		# Check rows and columns
		if board[i][0] == board[i][1] and board[i][1] == board[i][2] and board[i][1] != CELL_EMPTY:
			return true
		if board[0][i] == board[1][i] and board[1][i] == board[2][i] and board[1][i] != CELL_EMPTY:
			return true

	# Check diagonals
	if board[0][0] == board[1][1] and board[1][1] == board[2][2] and board[1][1] != CELL_EMPTY:
		return true
	if board[0][2] == board[1][1] and board[1][1] == board[2][0] and board[1][1] != CELL_EMPTY:
		return true

	return false

# Check if all the cells are filled
func is_board_full():
	for row in board:
		for cell in row:
			if cell == CELL_EMPTY:
				return false
	return true

# Reset the game
func reset_game():
	board = [
		[CELL_EMPTY, CELL_EMPTY, CELL_EMPTY],
		[CELL_EMPTY, CELL_EMPTY, CELL_EMPTY],
		[CELL_EMPTY, CELL_EMPTY, CELL_EMPTY],
	]
	for button in $GridContainer.get_children():
		button.text = CELL_EMPTY
		button.disabled = false
	current_player = CELL_X
	$"Win Screen".show()

func _on_play_button_pressed():
	$"Win Screen".hide()
	win_label.text = ""
