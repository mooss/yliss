################
# Pdf creation #
################
ORG_SOURCES := octasierp plate_tectonics window geometric_primitive
.PHONY: pdf
pdf: $(ORG_SOURCES:%=%.pdf)

%.pdf: %.org
	./litlib/export-to-pdf.sh "$^" "$@"
