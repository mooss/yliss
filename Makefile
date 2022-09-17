################
# PDF creation #
################
ORG_SOURCES := window graphics octasierp planet plate_tectonics imgen

.PHONY: pdf
pdf: $(ORG_SOURCES:%=%.pdf)

%.pdf: %.org
	./litlib/export-to-pdf.sh "$<" "$@"

###############################
# Dependencies initialization #
###############################
.PHONY: glm_retrieval submodules_retrieval init LitLib

init: glm_retrieval miniz_retrieval submodules_retrieval LitLib

glm_retrieval:
	./script/retrieve-dependency.sh https://github.com/g-truc/glm/releases/download/0.9.9.8 glm-0.9.9.8 7z include/glm ':to_include glm/glm'

miniz_retrieval:
	./script/retrieve-dependency.sh https://github.com/richgel999/miniz/releases/download/2.1.0 miniz-2.1.0 zip include/miniz.c ':to_include miniz.h miniz.c'

submodules_retrieval:
	./script/init-submodule.bash litlib
	./script/init-submodule.bash include/stb

litlib: submodules_retrieval

LitLib: litlib
	cd litlib && make LitLib

#####################
# Various utilities #
#####################
.PHONY: clean purge

clean:
	rm -fr include/{miniz.{c,h},glm} *.pdf

purge: clean
	rm -fr litlib include/stb

#########
# Imgen #
#########
.PHONY: tangle

tangle: $(ORG_SOURCES:%=tangle/%.tangled)

tangle/%.tangled: %.org
	@mkdir -p tangle
	@./litlib/include.pl "$< $$(sed -rn 's/^#\+tangle-deps:\s+(.*)/\1/p' $<)" ':tangle :exit-with-error'
	@touch "$@"
