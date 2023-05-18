extends Node


func _ready():
	var p = Parser.new() # create the parser
	p.add_argument(Arg.new({ # add an argument
		triggers = ["-F", "--fly"], # triggers
		n_args = 2, # number of arguments
		help = "Fly places", # help message
		default = ["sky", "ground"] # default args if called without arguments
	}))
	p.add_argument(Arg.new({ # arg n2
		triggers = ["--eat"],
		n_args = "*", # any number of arguments
		help = "eats all args you give it",
		dest = "restaurant" # the variable it goes into (defaults to longest trigger)
	}))
	p.add_argument(Arg.new({
		triggers = ["-H", "-?", "--help"],
		dest = "help",
		help = "show this help message and exit",
		action = "store_true"
	}))
	var args = p.parse_arguments(OS.get_cmdline_args() + OS.get_cmdline_user_args()) # Parse
	if args.get("help", false): # Check if we want help
		print(p.help()) # Show help
	else:
		print(args) # Just show args otherwise
	get_tree().quit()
