tangler:
	./scripts/compile_tangler.sh

################
# Pdf creation #
################
ORG_SOURCES := octasierp plate_tectonics window
.PHONY: pdf
pdf: $(ORG_SOURCES:%=%.pdf)

%.pdf: %.org
	./litlib/export-to-pdf.sh "$^" "$@"
