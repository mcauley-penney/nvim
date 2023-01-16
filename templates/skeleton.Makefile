# Make manual: hhttps://www.gnu.org/software/make/manual/make.html
# GCC Options: https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html
# Makefile Tutorial: https://www.youtube.com/watch?v=FfG-QqRK4cY

# -------------------------------------------------------------------
# files and directories
# -------------------------------------------------------------------
bin_name =
man_name = $(bin_name).1.gz

prefix = /usr/local
bindir = $(prefix)/bin
mandir = $(prefix)/man/man1

src_dir = src
inc_dir = inc
test_dir = test
debug_dir = debug
build_dir = build

src_files := $(wildcard $(src_dir)/*)
test_src_files := $(wildcard $(test_dir)/*)


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

CFLAGS = $(warn) $(optim)


# -------------------------------------------------------------------
#  targets
# -------------------------------------------------------------------
.PHONY: all test debug clean test_clean install uninstall


all:
	$(CC) $(CFLAGS) main.c $(src_files) -o $(bin_name)


test:
	$(CC) $(CFLAGS) $(test_src_files) $(src_files) -o test_$(bin_name)


debug:
	$(CC) $(CFLAGS) -D DEBUG=1 main.c $(src_files) -o debug_$(bin_name)


# clean target: remove all object files and binary
clean:
	rm -rf $(build_dir)
	rm $(bin_name)


test_clean:
	rm -rf $(build_dir)
	rm test_$(bin_name)


debug_clean:
	rm -rf $(build_dir)
	rm debug_$(bin_name)


install:
	$(NORMAL_INSTALL)
	install -m 007 $(bin_name) $(bindir)
	cp ./man/$(man_name) $(mandir)/$(man_name)


uninstall:
	$(NORMAL_UNINSTALL)
	rm $(bindir)/$(bin_name)
	rm $(mandir)/$(man_name)
