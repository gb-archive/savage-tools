
srcdir       = .
top_builddir = ../..

include $(top_builddir)/Makefile.common

CFLAGS          += -Wall

OBJECTS 	= sdcclib.o

SOURCES		= $(patsubst %.o,%.c,$(OBJECTS))

TARGET		= $(top_builddir)/bin/sdcclib$(EXEEXT)

all: $(TARGET)

install: all installdirs
	$(INSTALL) $(TARGET) `echo $(DESTDIR)$(bindir)/sdcclib$(EXEEXT)|sed '$(transform)'`
	$(STRIP) `echo $(DESTDIR)$(bindir)/sdcclib$(EXEEXT)|sed '$(transform)'`

# Deleting all the installed files
# --------------------------------
uninstall:
	rm -f $(DESTDIR)$(bindir)/sdcclib$(EXEEXT)

# Performing self-test
# --------------------
check:


# Performing installation test
# ----------------------------
installcheck:


# Creating installation directories
# ---------------------------------
installdirs:
	$(INSTALL) -d $(DESTDIR)$(bindir)


# Creating dependencies
# ---------------------
dep:

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $(OBJECTS)

.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@


checkconf:

include $(srcdir)/clean.mk
