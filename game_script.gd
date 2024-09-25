extends Node2D

# Cell States
const CELL_EMPTY = ""
const CELL_X = "X"
const CELL_O = "O"

@onready var buttons = $GridContainer.get_children()
@onready var label = $Menu/Label
@onready var menu = $Menu

# Game States
var current_player
var board

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = ""
	var button_index = 0
	for button in buttons:
		button.connect("pressed", _on_button_click.bind(button_index, button))
		button_index += 1
	reset_game()

func _on_button_click(idx, button):
	# Translating index position to (X, Y) Position.
	var y = idx / 3
	var x = idx % 3

	button.text = current_player
	if board[x][y] == CELL_EMPTY:
		board[x][y] = current_player
		
		# Check Win Conditions
		if check_win():
			label.text = current_player + " has won!"
			reset_game()
		elif check_fullboard():
			# draw
			label.text = "It's a Draw!"
			reset_game()
		else:
			current_player = CELL_X if current_player == CELL_O else CELL_O


func check_win():
	# Check horizontally/vertically if all the cells are set to same state
	for i in range(3):
		if board[i][0] == board[i][1] and  board[i][1] == board[i][2] and board[i][2] != CELL_EMPTY:
			return true
		if board[0][i] == board[1][i] and  board[1][i] == board[2][i] and board[2][i] != CELL_EMPTY:
			return true
	
	# Check diagonally for wins
	if board[0][0] == board[1][1] and board[1][1] == board[2][2] and board[2][2] != CELL_EMPTY:
		return true
	if board[2][0] == board[1][1] and board[1][1] == board[0][2] and board[0][2] != CELL_EMPTY:
		return true
	
	return false
	

func check_fullboard():
	for row in board:
		for col in row:
			if col == CELL_EMPTY:
				return false
	return true

func reset_game():
	current_player = CELL_X
	board = [
		[CELL_EMPTY,CELL_EMPTY,CELL_EMPTY],
		[CELL_EMPTY,CELL_EMPTY,CELL_EMPTY],
		[CELL_EMPTY,CELL_EMPTY,CELL_EMPTY],
	]
	for button in buttons:
		button.text = CELL_EMPTY
	menu.show()

func _on_button_pressed():
	# Start game when clicked on play
	label.text = ""
	menu.hide()
	
	
