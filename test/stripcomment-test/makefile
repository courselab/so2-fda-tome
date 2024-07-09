
# Makefile - test case for syseg/tools/stripcomment
# 
# Said program is supposed to remove all the first consecutive comment lines
# from this file.
#
## Extra comment marks should not be a problem
#
#  as well as a #  in the middle of a line.
#
# Everything up to this line should be removed.
this : line stays
# This line should not be removed

# Neither this

variable = value		# This comment should be kept

target : prerequisite		# And this one also.
	recipe

# No other line should be removed

