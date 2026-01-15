# Makefile — deck PDF generator helpers
OUT_DIR   := out
HTML_DIR  := html
DOCS_DIR  := DOC
CARDS_DIR := cards
TOOLS_DIR := tools

# xml defoult cards directory
XSD       := $(CARDS_DIR)/types.xsd

.PHONY: help $(HTML_DIR) $(OUT_DIR)
all: $(HTML_DIR) $(OUT_DIR)

$(HTML_DIR):
	mkdir -p $(HTML_DIR)

$(OUT_DIR):
	mkdir -p $(OUT_DIR)

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  help           - show this help"
	@echo "  validate       - validate source XML files against XSD"
	@echo "  html           - generate all HTML files"
	@echo "  pdf            - generate all PDFs from HTML files"
	@echo "  clean          - remove generated PDFs and HTML files"

validate:
	@echo "Validating source files..."
	./$(TOOLS_DIR)/validate_cards.sh "$(CARDS_DIR)" "$(XSD)"

# Generate HTML files
html-table:
	@echo "Generating HTML table..."
	# Add commands to generate HTML table here

html-cards:
	@echo "Generating HTML cards..."
	# Add commands to generate HTML cards here

# Generate all HTML files
html: html-table html-cards
	@echo "Generating all HTML files..."

# Generate PDFs from HTML files
pdf-front: html
	@echo "  Front: $(PDF_FRONT)"
	./$(TOOLS_DIR)/html_to_pdf.sh $(HTML_FRONT) $(PDF_FRONT)

pdf-back: html
	@echo "  Back:  $(PDF_BACK)"
	./$(TOOLS_DIR)/html_to_pdf.sh $(HTML_BACK) $(PDF_BACK)

pdf-both: html
	@echo "  Both:  $(PDF_BOTH)"
	./$(TOOLS_DIR)/html_to_pdf.sh $(HTML_BOTH) $(PDF_BOTH)
pdf: pdf-both pdf-front pdf-back $(OUT_DIR)
	@echo "Generated PDFs in $(OUT_DIR)."

# Remove generated PDFs and HTML files
clean:
	rm -f "$(OUT_DIR)"/*.pdf
	rm -f "$(HTML_DIR)"/*.html
	rm -f "$(HTML_DIR)"/*.xml