.SILENT:


srcdir       = .
top_srcdir   = ../..
top_builddir = ../..

TESTS_DIR = $(srcdir)/tests
RESULTS_DIR = results
PORTS_DIR = $(srcdir)/ports
BUILD_DIR = gen
ALL_PORTS = host mcs51 mcs51-large mcs51-stack-auto ds390 z80 hc08

ALL_TESTS = $(shell find $(TESTS_DIR) -name "*.c")

PORT_RESULTS_DIR = $(RESULTS_DIR)/$(PORT)
PORT_RESULTS = $(ALL_TESTS:$(TESTS_DIR)/%.c=$(PORT_RESULTS_DIR)/%.out)
PORT_BUILD_DIR = $(BUILD_DIR)/$(PORT)

all: test-ports

test-ports:
	for i in $(ALL_PORTS); do $(MAKE) test-port PORT=$$i; done

test-mcs51:
	$(MAKE) test-port PORT=mcs51
        
test-port: port-results

clean: clean-gen
	rm -rf $(RESULTS_DIR) *.pyc
	rm -rf $(BUILD_DIR)

distclean: clean
	rm -r Makefile

clean-gen:	
	for i in $(ALL_PORTS); do $(MAKE) clean-port PORT=$$i; done

clean-port:
	rm -rf $(PORT_BUILD_DIR)

$(PORT_RESULTS_DIR)/%.out: $(TESTS_DIR)/%.c
	echo Processing $<
	python $(srcdir)/valdiag.py $(PORT) $< $(PORT_BUILD_DIR)/$* > $@

port-results: port-dirs $(PORT_RESULTS)
	echo Summary for \'$(PORT)\': `cat $(PORT_RESULTS) | \
	python $(srcdir)/../regression/collate-results.py`

port-dirs:
	mkdir -p $(PORT_RESULTS_DIR)
	mkdir -p $(PORT_BUILD_DIR)
