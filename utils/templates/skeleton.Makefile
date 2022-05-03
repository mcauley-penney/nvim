bin =
src_dir = src
src_files = $(notdir $(wildcard $(src_dir)/*.c)) # src files without dir prefix
VPATH = $(src_dir) # where to look for src files

optim = -O2
warn = -Wall -Wextra -Wfloat-equal -Wformat=2 -pedantic-errors # warning switches
CFLAGS = $(warn) -c $(optim) # compile flags
LFLAGS = $(warn) # linking flags


# object file names
obj_files = $(patsubst %.c, %.o, $(src_files))


# general rule: construct all .o files from
# the source files with the same file name
%.o : %.c
	$(CC) $(CFLAGS) $<


# binary rule: construct binary with given
# name from object files provided
$(bin): $(obj_files)
	$(CC) $(LFLAGS) $^ -o $@


# clean target: remove all object files and binary
clean:
	rm *.o $(bin)
