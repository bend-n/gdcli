extends Node


func _ready():
	var p = Parser.new()
	p.add_argument(Arg.new({triggers = ["-fly", "--fley"], n_args = 2, help = "i eat donkeys"}))
	p.add_argument(Arg.new({triggers = ["-bard", "--flgersog"], n_args = 2, help = "me 4"}))
	p.add_argument(Arg.new({triggers = ["--radiation"], n_args = "*", help = "i am radiation"}))
	p.add_argument(Arg.new({triggers=["-h", "--help", "-?"], help="show this help message and exit", action="store_true", dest="help"}))
	print(p.parse_arguments())
	print(p.help())
