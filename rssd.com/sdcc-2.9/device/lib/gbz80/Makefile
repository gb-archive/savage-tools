# libc/gbz80 Makefile

srcdir = .
top_builddir = ../../..

LIB_TYPE = RANLIB

TOPDIR = ../../..

SCC = $(TOPDIR)/bin/sdcc -mgbz80
SAS = $(TOPDIR)/bin/as-gbz80

PORTDIR = ../build/gbz80

COMMON_FLOAT = \
  _atof.c \
  _schar2fs.c \
  _sint2fs.c \
  _slong2fs.c \
  _uchar2fs.c \
  _uint2fs.c \
  _ulong2fs.c \
  _fs2schar.c \
  _fs2sint.c \
  _fs2slong.c \
  _fs2uchar.c \
  _fs2uint.c \
  _fs2ulong.c \
  frexpf.c \
  ldexpf.c \
  expf.c \
  powf.c \
  sincosf.c \
  sinf.c \
  cosf.c \
  logf.c \
  log10f.c \
  sqrtf.c \
  tancotf.c \
  tanf.c \
  cotf.c \
  asinf.c \
  acosf.c \
  atan2f.c \
  sincoshf.c \
  sinhf.c \
  coshf.c \
  tanhf.c \
  floorf.c \
  ceilf.c \
  modff.c \
  errno.c \

COMMON_SDCC = \
  _atoi.c \
  _atol.c \
  abs.c \
  labs.c \
  rand.c \
  _iscntrl.c \
  _isdigit.c \
  _isgraph.c \
  _isprint.c \
  _ispunct.c \
  _isspace.c \
  _islower.c \
  _isupper.c \
  _isxdigit.c \
  _strcat.c \
  _strchr.c \
  _strcspn.c \
  _strncat.c \
  _strncmp.c \
  _strncpy.c \
  _strpbrk.c \
  _strrchr.c \
  _strspn.c \
  _strstr.c \
  _strtok.c \
  _calloc.c \
  _malloc.c \
  _realloc.c \
  _free.c \
  puts.c \
  gets.c \
  assert.c \
  time.c \
  _setjmp.c \
  _itoa.c \
  _ltoa.c \
  _strlen.c \
  _memmove.c \
  sprintf.c \
  vprintf.c \

GBZ80_MISC = \
  _memcpy.s \
  _memcmp.s \
  _memset.s \
  _strcmp.s \
  _strcpy.s \

GBZ80_SDCC = \
  crt0_rle.s \
  heap.s \
  printf_large.c \

GBZ80_FLOAT = \
  float.s \
  fstubs.s \
  _fsadd.c \
  _fssub.c \
  _fsmul.c \
  _fsdiv.c \
  _fseq.c \
  _fsneq.c \
  _fsgt.c \
  _fslt.c \
  asincosf.c \
  atanf.c \
  fabsf.c \
  exponentf.c \
  scalef.c \
  
GBZ80_INT = \
  add_n.s \
  cmp_n.s \
  div.s \
  div_n.s \
  inc_n.s \
  mul.s \
  mul_n.s \
  neg_n.s \
  set_n.s \
  shift.s \
  sla_n.s \
  sra_n.s \
  stubs.s \
  sub_n.s \
  zero_n.s \

GBZ80_LONG = \
  _modslong.s \
  _modulong.s \
  _mullong.s \
  _divslong.s \
  _divulong.s \

OBJS = \
  $(patsubst %.c,%.o,\
    $(COMMON_FLOAT) \
    $(COMMON_SDCC) \
  ) \
  $(patsubst %.s,%.o,\
    $(GBZ80_INT) \
    $(GBZ80_LONG) \
    $(GBZ80_MISC) \
    $(patsubst %.c,%.o, \
      $(GBZ80_SDCC) \
      $(GBZ80_FLOAT) \
    ) \
  ) \

LIB = gbz80.lib
CC = $(SCC)
AS = $(SAS)
CFLAGS = -I$(srcdir)/../../include -I. --std-c99

all: $(PORTDIR)/$(LIB)

$(PORTDIR)/$(LIB): $(OBJS) Makefile
ifeq ($(LIB_TYPE), SDCCLIB)
	rm -f $@; \
	../../../bin/sdcclib -a $@ $(OBJS)
else ifeq ($(LIB_TYPE), AR)
	ar -Scq $@ $(OBJ)
else ifeq ($(LIB_TYPE), RANLIB )
	ar -Scq $@ $(OBJS)
	$(top_builddir)/bin/asranlib $@
else
	rm -f $@
	for i in $(basename $(OBJS) ); do echo $$i >>$@; done
	cp $(OBJS) $(PORTDIR)
endif

%.o: %.s
	$(AS) -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%.o: ../%.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f *.o *.sym *.lst *~ $(CLEANSPEC) *.dump* *.asm *.lib

distclean: clean
	rm -f Makefile
