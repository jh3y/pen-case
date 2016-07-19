PHONY: help

MODULES = ./node_modules/.bin
STYLUS = $(MODULES)/stylus
BABEL = $(MODULES)/babel
POSTCSS = $(MODULES)/postcss
PUG = $(MODULES)/pug
BS = $(MODULES)/browser-sync

OUTPUT_DIR = public
DIST_DIR = dist
SCRIPT_SRC = src/**/*.js
SCRIPT_DEST = $(OUTPUT_DIR)
STYLE_SRC = src/**/*.styl
STYLE_DEST = $(OUTPUT_DIR)
MARKUP_SRC = src/**/*.pug
MARKUP_DEST = $(OUTPUT_DIR)

# Work on one pen at a time.
# If no pen defined then throw error.
# make pen check function that is used in anything but just make...

POSTCSS_OPTS = --use autoprefixer -d $(STYLE_DEST)/ $(STYLE_DEST)/*.css

help:
	@grep -E '^[a-zA-Z\._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Compile javascript using babel and copy to respective pen folder in public.

compile-scripts: ## compiles scripts
	$(BABEL) $(SCRIPT_SRC) -d $(SCRIPT_DEST)

watch-scripts: compile-scripts ## watch for script changes and compile
	$(BABEL) $(SCRIPT_SRC) --watch -d $(SCRIPT_DEST)


compile-styles: ## compiles styles
	$(STYLUS) $(STYLE_SRC) -o $(STYLE_DEST) && $(POSTCSS) $(POSTCSS_OPTS)

watch-styles: ## watches and compiles styles
	$(STYLUS) -w $(STYLE_SRC) -o $(STYLE_DEST)

compile-markup: ## compiles markup
	$(PUG) -P $(MARKUP_SRC) -o $(MARKUP_DEST)
	# $(PUG) -P $(MARKUP_SRC) -O $(FILE_NAME).config.json -o $(MARKUP_DEST)

watch-markup: ## watch and compile markup
	$(PUG) -wP $(MARKUP_SRC) -O $(FILE_NAME).config.json -o $(MARKUP_DEST)

setup: ## set up project for development
	npm install && mkdir -pv $(SCRIPT_DEST) && mkdir -pv $(STYLE_DEST)

watch: ## run development watch
	make watch-scripts & make watch-styles & make watch-markup

build: ## build sources
	make compile-scripts && make compile-styles && make compile-markup

serve: build ## sets up browser-sync local static server with livereload
	$(BS) start --port 1987 --files $(OUTPUT_DIR)/ --server $(OUTPUT_DIR)

develop: ## run development task
	make serve & make watch

NAME = 'JHEY'

apple: ## test out doing somethings
	echo $(NAME) $(PEN)
