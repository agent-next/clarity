REQUIRED_TOOLS := python3 git rg rsync

.PHONY: setup check

setup: ## verify (and on apt/brew systems install) the tools tests/smoke.sh needs
	@missing=""; \
	for t in $(REQUIRED_TOOLS); do \
		command -v $$t >/dev/null 2>&1 || missing="$$missing $$t"; \
	done; \
	if [ -z "$$missing" ]; then \
		echo "setup: all required tools present ($(REQUIRED_TOOLS))"; \
		exit 0; \
	fi; \
	pkgs=""; \
	for t in $$missing; do \
		case $$t in rg) pkgs="$$pkgs ripgrep";; *) pkgs="$$pkgs $$t";; esac; \
	done; \
	if command -v apt-get >/dev/null 2>&1; then \
		echo "setup: installing$$pkgs via apt-get"; \
		if command -v sudo >/dev/null 2>&1; then SUDO=sudo; else SUDO=; fi; \
		$$SUDO apt-get update -qq && $$SUDO apt-get install -y -qq $$pkgs; \
	elif command -v brew >/dev/null 2>&1; then \
		echo "setup: installing$$pkgs via brew"; \
		brew install $$pkgs; \
	else \
		echo "setup: missing required tools:$$missing — install them manually" >&2; \
		exit 1; \
	fi

check: ## run the smoke suite (the same gate CI runs)
	bash tests/smoke.sh
