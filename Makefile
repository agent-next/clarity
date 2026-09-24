.PHONY: setup check

setup:
	@for c in bash git python3 rg rsync; do \
		command -v $$c >/dev/null 2>&1 || { echo "missing required command: $$c" >&2; exit 1; }; \
	done
	@echo "toolchain ok (zero-dependency repo, nothing to install)"

check:
	bash tests/smoke.sh
