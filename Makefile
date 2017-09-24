# Makefile
#
# This file is part of Ritimba
# http://programandala.net/es.programa.ritimba.html

# Last modified 201709241435
# See change log at the end of the file

# ==============================================================

MAKEFLAGS = --no-print-directory

.ONESHELL:

.PHONY: all
all: target/boot target/ritimba_bas

.PHONY: clean
clean:
	rm -f target/*_bas target/boot

target/boot: src/boot.bas src/lib/device.bas
	sbim $< $@

lib_files=$(wildcard src/lib/*.bas)

target/ritimba_bas: src/ritimba.bas $(lib_files)
	sbim $< $@

# ==============================================================
# Change log

# 2017-09-17: Start.
#
# 2017-09-18: Add <src/zx_beep.bas>.
#
# 2017-09-24: Update library files directory.
