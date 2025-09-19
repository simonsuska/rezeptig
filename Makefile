.PHONY: build new clean

RECIPES_FILE = .recipes
RECIPES_FILE_BUILD = .recipes_build

RECIPES_FOLDER = recipes
RECIPE_PATTERN = %RCPEND

BLUEPRINT_FILE = recipe_bp.tex
MAIN_FILE = recipebook.tex
MAIN_FILE_BUILD = recipebook_build.tex

CLEAN_FILES = *.acn *.acr *.alg *.aux *.bak *.bbl *.bcf *.blg *.brf *.bst \
			  *.dvi *.fdb_latexmk *.fls *.glg *.glo *.gls *.idx *.ilg *.ind \
			  *.ist *.lof *.log *.lol *.lot *.maf *.mtc *.mtc1 *.nav *.nlo \
			  *.nls *.out *.pdf *.pyg *.run.xml *.snm *.synctex.gz \
			  *.tex.backup *.thm *.toc *.vrb *.xdy *.xml *blx.bib *.bak *.mtc

build:
	@echo Building ...

	@if [[ ! -f "$(RECIPES_FILE)" ]]; then \
		echo "Creating file '$(RECIPES_FILE)' ..."; \
		: > "$(RECIPES_FILE)"; \
	fi

	@sort -o "$(RECIPES_FILE_BUILD)" "$(RECIPES_FILE)"
	@sed -e '/$(RECIPE_PATTERN)/r $(RECIPES_FILE_BUILD)' "$(MAIN_FILE)" > "$(MAIN_FILE_BUILD)";

	@xelatex "$(MAIN_FILE_BUILD)"
	@xelatex "$(MAIN_FILE_BUILD)"

new:
	@if [[ ! -d "$(RECIPES_FOLDER)" ]]; then \
		echo "Creating folder '$(RECIPES_FOLDER)' ..."; \
		mkdir "$(RECIPES_FOLDER)"; \
	fi 

	@if [[ "$(name)" = "" || -f "$(RECIPES_FOLDER)/$(name).tex" ]]; then \
		[[ "$(name)" = "" ]] && echo "No name specified."; \
		[[ -f "$(RECIPES_FOLDER)/$(name).tex" ]] && echo "File '$(RECIPES_FOLDER)/$(name).tex' already exists."; \
		\
		echo "Creating file '$(RECIPES_FOLDER)/$$(date +"recipe-%FT%T%z").tex' ..."; \
		cat "$(BLUEPRINT_FILE)" > "$(RECIPES_FOLDER)/$$(date +"recipe-%FT%T%z").tex"; \
		\
		[[ ! -f "$(RECIPES_FILE)" ]] && echo "Creating file '$(RECIPES_FILE)' ..."; \
		echo "\\include{$(RECIPES_FOLDER)/$$(date +"recipe-%FT%T%z")}" >> "$(RECIPES_FILE)"; \
	else \
		echo "Creating file '$(RECIPES_FOLDER)/$(name).tex' ..."; \
		cat "$(BLUEPRINT_FILE)" > "$(RECIPES_FOLDER)/$(name).tex"; \
		\
		[[ ! -f "$(RECIPES_FILE)" ]] && echo "Creating file '$(RECIPES_FILE)' ..."; \
		echo "\\include{$(RECIPES_FOLDER)/$(name)}" >> "$(RECIPES_FILE)"; \
	fi

clean:
	@echo Cleaning ...
	@rm -f $(CLEAN_FILES)
	@rm -f $(RECIPES_FOLDER)/*.aux
	@rm "$(MAIN_FILE_BUILD)"
	@rm "$(RECIPES_FILE_BUILD)"
