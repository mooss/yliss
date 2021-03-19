################
# PDF creation #
################
ORG_SOURCES := octasierp plate_tectonics window geometric_primitives
.PHONY: pdf
pdf: $(ORG_SOURCES:%=%.pdf)

%.pdf: %.org
	./litlib/export-to-pdf.sh "$^" "$@"

###############################
# Dependencies initialization #
###############################
.PHONY: glm_retrieval submodules_retrieval dependencies

dependencies: glm_retrieval submodules_retrieval

glm_retrieval:
	./script/get-glm.sh

submodules_retrieval:
	git submodule init
	git submodule update

#####################
# Various utilities #
#####################
clean:
	rm -fr glm litlib *.pdf 
