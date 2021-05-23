# $Id: Makefile.SH,v 1.1 2004-05-03 05:17:48 behdad Exp $
#
# UNIX makefile for manual page generator
# Note: any changes made here will be lost next time Configure is run!.

CC=gcc -O
YACC=yacc 
LEX=lex 
SED=/bin/sed
CAT=/bin/cat
RM=/bin/rm
MV=/bin/mv
CP=/bin/cp
ECHO=/bin/echo
MKDEP=/var/tmp/portage/app-text/c2man-9999/work/c2man-9999/mkdep

# where we get installed
bin=/usr/bin
privlib=/usr/lib/c2man

mansrc= 
manext=0
CFLAGS=
WARNFLAGS=-Wall -Wno-comment
LDFLAGS= -L/usr/local/lib
LIBS=   

# As Larry said, "Grrrr"
SHELL=/bin/sh

OSOURCES =	config.h c2man.h semantic.h symbol.h strconcat.h \
		strappend.h manpage.h enum.h output.h lex.l grammar.y
DCSOURCES =	c2man.c semantic.c string.c symbol.c strconcat.c \
		strappend.c manpage.c enum.c nroff.c texinfo.c latex.c html.c \
		autodoc.c
SOURCES =	$(OSOURCES) $(DCSOURCES)
CSOURCES =	$(DCSOURCES) y.tab.c
OBJECTS =	c2man.o semantic.o string.o symbol.o y.tab.o strconcat.o \
		strappend.o manpage.o enum.o nroff.o texinfo.o latex.o html.o \
		autodoc.o
GENERATED =	c2man example.inc ctype_ex.inc y.tab.c lex.yy.c y.output \
		fixexamp.sed flatten.sed


all: c2man c2man.1

install: all
	$(CP) c2man $(bin)
	$(CP) c2man.1 $(mansrc)/c2man.$(manext)
	-mkdir $(privlib)
	chmod 755 $(privlib)
	-mkdir $(privlib)/eg
	chmod 755 $(privlib)/eg
	$(CP) eg/*.[chly] $(privlib)/eg
	chmod 755 $(privlib)/eg/*

uninstall:
	$(RM) -f $(bin)/c2man $(mansrc)/c2man.$(manext)
	$(RM) -f $(privlib)/eg/*
	rmdir $(privlib)/eg
	rmdir $(privlib)

c2man: $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJECTS) $(LIBS)

c2man.1: c2man.man c2man example.inc ctype_ex.inc flatten.sed
	$(SED) -f flatten.sed < c2man.man > c2man.1

.c.o:
	$(CC) $(CFLAGS) $(WARNFLAGS) -c $<

y.tab.c: grammar.y
	@$(ECHO) Expect 61 shift/reduce conflicts.
	$(YACC) grammar.y

# don't compile y.tab.c with all warnings; yacc/bison are not up to it.
y.tab.o: y.tab.c lex.yy.c
	$(CC) $(CFLAGS) -c y.tab.c

lex.yy.c: lex.l
	$(LEX) -n lex.l

example.inc: c2man example.h fixexamp.sed
	./c2man -o- example.h | $(SED) -f fixexamp.sed >example.inc

ctype_ex.inc: c2man ctype_ex.h fixexamp.sed
	./c2man -o- -g ctype_ex.h | $(SED) -f fixexamp.sed >ctype_ex.inc

fixexamp.sed: fixexamp.in
	$(SED) -e '/^#/d' fixexamp.in > fixexamp.sed

flatten.sed: flatten.SH config.sh
	sh flatten.SH

Makefile: Makefile.SH config.sh
	sh Makefile.SH

config.h: config_h.SH config.sh
	sh config_h.SH

TAGS: $(SOURCES)
	etags -t $(SOURCES)

clean:
	$(RM) -f *.o *.s *.bak *~ *.log $(GENERATED) core

distclean realclean: clean
	$(RM) -f Makefile config.sh mkdep c2man.kit?

lint:
	lint -b $(CFLAGS) $(CSOURCES)

print:
	cpr $(SOURCES) | lpr -J'c2man'

test: c2man
	@echo "Running c2man over the examples..." 1>&2
	@for file in eg/*.[chly]; do ./c2man -v -o- $$file; done
	@echo "Running c2man over its own source code..." 1>&2
	@for file in $(DCSOURCES); do ./c2man -v -o- $$file; done
	@echo "Hmmm, test seemed to go OK." 1>&2

depend:
	$(SED) -e '1,/^# DO NOT/!d' < Makefile > Makefile.new
	$(MKDEP) $(DCSOURCES) >> Makefile.new
	- test ! -f y.tab.c -o ! -f lex.yy.c || $(MKDEP) y.tab.c >> Makefile.new
	$(MV) -f Makefile.new Makefile

# y.tab.c dependancies updated manually since it won't exist yet when make
# depend is first run.
y.tab.o: c2man.h
y.tab.o: config.h
y.tab.o: confmagic.h
y.tab.o: enum.h
y.tab.o: manpage.h
y.tab.o: semantic.h
y.tab.o: strappend.h
y.tab.o: strconcat.h
y.tab.o: symbol.h

# DO NOT DELETE THIS LINE! make depend DEPENDS ON IT!
c2man.o: c2man.c /usr/include/stdc-predef.h /usr/include/ctype.h \
 /usr/include/features.h /usr/include/sys/cdefs.h \
 /usr/include/bits/wordsize.h /usr/include/bits/long-double.h \
 /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h \
 /usr/include/bits/types.h /usr/include/bits/timesize.h \
 /usr/include/bits/typesizes.h /usr/include/bits/time64.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/errno.h /usr/include/bits/errno.h \
 /usr/include/linux/errno.h /usr/include/asm/errno.h \
 /usr/include/asm-generic/errno.h /usr/include/asm-generic/errno-base.h \
 c2man.h config.h symbol.h /usr/include/sys/types.h \
 /usr/include/bits/types/clock_t.h /usr/include/bits/types/clockid_t.h \
 /usr/include/bits/types/time_t.h /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h enum.h strconcat.h strappend.h manpage.h output.h \
 patchlevel.h /usr/include/sys/file.h /usr/include/fcntl.h \
 /usr/include/bits/fcntl.h /usr/include/bits/fcntl-linux.h \
 /usr/include/bits/stat.h /usr/include/bits/struct_stat.h \
 /usr/include/sys/stat.h /usr/include/signal.h \
 /usr/include/bits/signum-generic.h /usr/include/bits/signum-arch.h \
 /usr/include/bits/types/sig_atomic_t.h \
 /usr/include/bits/types/siginfo_t.h /usr/include/bits/types/__sigval_t.h \
 /usr/include/bits/siginfo-arch.h /usr/include/bits/siginfo-consts.h \
 /usr/include/bits/types/sigval_t.h /usr/include/bits/types/sigevent_t.h \
 /usr/include/bits/sigevent-consts.h /usr/include/bits/sigaction.h \
 /usr/include/bits/sigcontext.h /usr/include/bits/types/stack_t.h \
 /usr/include/sys/ucontext.h /usr/include/bits/sigstack.h \
 /usr/include/bits/ss_flags.h /usr/include/bits/types/struct_sigstack.h \
 /usr/include/bits/sigthread.h /usr/include/bits/signal_ext.h
semantic.o: semantic.c /usr/include/stdc-predef.h c2man.h config.h \
 symbol.h /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h /usr/include/ctype.h /usr/include/errno.h \
 /usr/include/bits/errno.h /usr/include/linux/errno.h \
 /usr/include/asm/errno.h /usr/include/asm-generic/errno.h \
 /usr/include/asm-generic/errno-base.h semantic.h enum.h manpage.h \
 strconcat.h output.h
string.o: string.c /usr/include/stdc-predef.h c2man.h config.h symbol.h \
 /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h /usr/include/ctype.h
symbol.o: symbol.c /usr/include/stdc-predef.h c2man.h config.h symbol.h \
 /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h
strconcat.o: strconcat.c /usr/include/stdc-predef.h c2man.h config.h \
 symbol.h /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h strconcat.h
strappend.o: strappend.c /usr/include/stdc-predef.h c2man.h config.h \
 symbol.h /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h strappend.h
manpage.o: manpage.c /usr/include/stdc-predef.h c2man.h config.h symbol.h \
 /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h /usr/include/errno.h /usr/include/bits/errno.h \
 /usr/include/linux/errno.h /usr/include/asm/errno.h \
 /usr/include/asm-generic/errno.h /usr/include/asm-generic/errno-base.h \
 /usr/include/ctype.h manpage.h strconcat.h strappend.h semantic.h \
 output.h /usr/include/sys/file.h /usr/include/fcntl.h \
 /usr/include/bits/fcntl.h /usr/include/bits/fcntl-linux.h \
 /usr/include/bits/stat.h /usr/include/bits/struct_stat.h
enum.o: enum.c /usr/include/stdc-predef.h c2man.h config.h symbol.h \
 /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h strconcat.h enum.h manpage.h
nroff.o: nroff.c /usr/include/stdc-predef.h c2man.h config.h symbol.h \
 /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h manpage.h output.h semantic.h /usr/include/ctype.h
texinfo.o: texinfo.c /usr/include/stdc-predef.h c2man.h config.h symbol.h \
 /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h manpage.h output.h /usr/include/ctype.h
latex.o: latex.c /usr/include/stdc-predef.h c2man.h config.h symbol.h \
 /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h manpage.h output.h /usr/include/ctype.h
html.o: html.c /usr/include/stdc-predef.h c2man.h config.h symbol.h \
 /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h manpage.h output.h /usr/include/ctype.h
autodoc.o: autodoc.c /usr/include/stdc-predef.h c2man.h config.h symbol.h \
 /usr/include/sys/types.h /usr/include/features.h \
 /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
 /usr/include/bits/long-double.h /usr/include/gnu/stubs.h \
 /usr/include/gnu/stubs-64.h /usr/include/bits/types.h \
 /usr/include/bits/timesize.h /usr/include/bits/typesizes.h \
 /usr/include/bits/time64.h /usr/include/bits/types/clock_t.h \
 /usr/include/bits/types/clockid_t.h /usr/include/bits/types/time_t.h \
 /usr/include/bits/types/timer_t.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stddef.h \
 /usr/include/bits/stdint-intn.h /usr/include/endian.h \
 /usr/include/bits/endian.h /usr/include/bits/endianness.h \
 /usr/include/bits/byteswap.h /usr/include/bits/uintn-identity.h \
 /usr/include/sys/select.h /usr/include/bits/select.h \
 /usr/include/bits/types/sigset_t.h /usr/include/bits/types/__sigset_t.h \
 /usr/include/bits/types/struct_timeval.h \
 /usr/include/bits/types/struct_timespec.h \
 /usr/include/bits/pthreadtypes.h /usr/include/bits/thread-shared-types.h \
 /usr/include/bits/pthreadtypes-arch.h /usr/include/bits/struct_mutex.h \
 /usr/include/bits/struct_rwlock.h /usr/include/stdlib.h \
 /usr/include/bits/libc-header-start.h /usr/include/bits/waitflags.h \
 /usr/include/bits/waitstatus.h /usr/include/bits/floatn.h \
 /usr/include/bits/floatn-common.h /usr/include/alloca.h \
 /usr/include/bits/stdlib-float.h /usr/include/string.h \
 /usr/include/bits/types/locale_t.h /usr/include/bits/types/__locale_t.h \
 /usr/include/strings.h /usr/include/stdio.h \
 /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdarg.h \
 /usr/include/bits/types/__fpos_t.h /usr/include/bits/types/__mbstate_t.h \
 /usr/include/bits/types/__fpos64_t.h /usr/include/bits/types/__FILE.h \
 /usr/include/bits/types/FILE.h /usr/include/bits/types/struct_FILE.h \
 /usr/include/bits/stdio_lim.h /usr/include/unistd.h \
 /usr/include/bits/posix_opt.h /usr/include/bits/environments.h \
 /usr/include/bits/confname.h /usr/include/bits/getopt_posix.h \
 /usr/include/bits/getopt_core.h /usr/include/bits/unistd_ext.h \
 /usr/include/time.h /usr/include/bits/time.h \
 /usr/include/bits/types/struct_tm.h \
 /usr/include/bits/types/struct_itimerspec.h /usr/include/sys/time.h \
 confmagic.h manpage.h output.h /usr/include/ctype.h
