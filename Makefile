# Makefile
#
# This file is part of Ritimba
# http://programandala.net/es.programa.ritimba.html

# Last modified 201710181700
# See change log at the end of the file

# ==============================================================

MAKEFLAGS = --no-print-directory

.ONESHELL:

.PHONY: all
all: target/boot target/ritimba_bas target/SMSQmulator.ini

.PHONY: new
new: clean all

.PHONY: clean
clean:
	rm -f target/*_bas target/boot target/SMSQmulator.ini

target/SMSQmulator.ini: src/SMSQmulator.ini src/boot.bas src/ritimba.bas
	cp -f $< $@

target/boot: src/boot.bas
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
#
# 2017-09-25: Remove `device.bas`.
#
# 2017-10-18: Create a new SMSQmulator.ini every time.
