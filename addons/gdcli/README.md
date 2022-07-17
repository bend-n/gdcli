# godot cli parser

A utility for parsing command line arguments for godot.

## Features

- 0-\* Arguments
- Default values
- Help creation
- Any number of triggers

### Usage example

```gdscript
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
    triggers = ["-H", "-?"],
    dest = "help",
    help = "show this help message and exit",
    action = "store_true"
}))
var args = p.parse_arguments() # Parse
if args.get("help", false): # Check if we want help
    print(p.help()) # Show help
else:
    print(args) # Just show args otherwise
```
