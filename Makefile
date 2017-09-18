# Makefile
#
# This file is part of Ritimba
# http://programandala.net/es.programa.ritimba.html

# Last modified 201709180056
# See change log at the end of the file

# ==============================================================

MAKEFLAGS = --no-print-directory

.ONESHELL:

.PHONY: all
all: target/boot target/ritimba_bas

.PHONY: clean
clean:
	rm -f target/*_bas target/boot

target/boot: src/boot.bas src/device.bas
	sbim $< $@

target/ritimba_bas: src/ritimba.bas src/device.bas src/zx_beep.bas
	sbim $< $@

# ==============================================================
# Change log

# 2017-09-17: Start.
#
# 2017-09-18: Add <src/zx_beep.bas>.
