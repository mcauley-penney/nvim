# GCC Options: https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html
# Standard Targets: https://www.gnu.org/software/make/manual/make.html#Standard-Targets
# Makefile Tutorial: https://www.youtube.com/watch?v=FfG-QqRK4cY


# -------------------------------------------------------------------
# files and directories
# -------------------------------------------------------------------
bin_name = mmv
install_dir = /usr/bin/

src_dir = src
# src files without dir prefix
src_fnames := $(notdir $(wildcard $(src_dir)/*.c))

build_dir = build
obj_fnames := $(src_fnames:.c=.o)
obj_fnames := $(addprefix $(build_dir)/, $(obj_fnames))


# -------------------------------------------------------------------
# flags
# -------------------------------------------------------------------
optim = -O2
w-arith = -Wdouble-promotion -Wfloat-equal
w-basic = -pedantic -Wall -Wextra
w-extra = -Wcast-align=strict -Wconversion -Wpadded -Wshadow -Wstrict-prototypes -Wvla
w-fmt = -Wformat=2 -Wformat-overflow=2 -Wformat-truncation
w-sgst = -Wsuggest-attribute=const -Wsuggest-attribute=malloc -Wsuggest-attribute=noreturn
warn = $(w-basic) $(w-extra) $(w-arith) $(w-fmt) $(w-sgst)

CFLAGS = $(warn) -c $(optim)
LFLAGS = $(warn)


# -------------------------------------------------------------------
#  targets
# -------------------------------------------------------------------
# tell make not to create files for these target names
.PHONY: all clean clearscreen fresh install

# recurse down to create all needed items
all: $(bin_name)

$(bin_name): $(obj_fnames)
	$(CC) $(LFLAGS) $^ -o $@

# general rule: construct all .o files from
# the source files with the same file name
$(obj_fnames): $(src_dir)/$(src_fnames)
	mkdir -p $(build_dir)
	$(CC) $(CFLAGS) $< -o $@

# clean target: remove all object files and binary
clean:
	rm -rf $(build_dir)
	rm $(bin_name)

clearscreen:
	clear

fresh: | clean clearscreen

# install target for "sudo make install"
install:
	install -m 007 $(bin) $(bindir)
