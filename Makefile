TEMPLATEFILE:=optex-template.tex
WRITERFILE:=optex-writer.lua
DEFAULTSFILE:=optex-default.yaml
PANDOCDATADIR:=~/.local/share/pandoc/
TEMPLATEDIR:=$(PANDOCDATADIR)templates/
WRITERDIR:=$(PANDOCDATADIR)writers/
DEFAULTSDIR:=$(PANDOCDATADIR)defaults/
PDFFILES=$(wildcard *.pdf)
TEXFILES=$(PDFFILES:%.pdf=%.tex)
REFFILES=$(PDFFILES:%.pdf=%.ref)
REPLACEMETS= OpTeX TeX


.PHONY: docs
docs: README.pdf

%.tex: %.md | $(TEMPLATEFILE) $(WRITERFILE)
	pandoc -d $(DEFAULTSFILE) -f markdown -t $(WRITERFILE) $^ --template $(TEMPLATEFILE) >$@

%.pdf: %.tex | %.md
	optex $^
	optex $^

README.md: docs.md
	sed $(foreach repl, $(REPLACEMETS), -e 's;\\$(repl)/;$(repl);g') $^ >$@ 

.PHONY: install
install: ensure_pandoc install_template install_writer install_defaults

.PHONY: ensure_pandoc
ensure_pandoc:


$(PANDOCDATADIR): ensure_pandoc
	mkdir -p $@

$(TEMPLATEDIR): $(PANDOCDATADIR)
	mkdir -p $@

$(WRITERDIR): $(PANDOCDATADIR)
	mkdir -p $@

.PHONY: install_template
install_template: $(TEMPLATEFILE) | $(TEMPLATEDIR)
	cp -v $^ $(TEMPLATEDIR)$^

.PHONY: install_writer
install_writer: $(WRITERFILE) | $(WRITERDIR)
	cp -v $^ $(WRITERDIR)optex

.PHONY: install_defaults
install_defaults: | $(DEFAULTSDIR)

.PHONY: clean
clean:
	rm -rfv $(PDFFILES) $(TEXFILES) $(REFFILES)  
