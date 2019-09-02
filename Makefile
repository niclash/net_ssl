config ?= release

PACKAGE := net_ssl
COMPILE_WITH := ponyc

BUILD_DIR ?= build/$(config)
SRC_DIR ?= $(PACKAGE)
tests_binary := $(BUILD_DIR)/$(PACKAGE)
docs_dir := build/$(PACKAGE)-docs

ifdef config
	ifeq (,$(filter $(config),debug release))
		$(error Unknown configuration "$(config)")
	endif
endif

ifeq ($(config),release)
	PONYC = ${COMPILE_WITH}
else
	PONYC = ${COMPILE_WITH} --debug
endif

ifeq (,$(filter $(MAKECMDGOALS),clean docs realclean TAGS))
  ifeq ($(ssl), 1.1.x)
	  SSL = -Dopenssl_1.1.x
  else ifeq ($(ssl), 0.9.0)
	  SSL = -Dopenssl_0.9.0
  else
    $(error Unknown SSL version "$(ssl)". Must set using 'ssl=FOO')
  endif
endif

SOURCE_FILES := $(shell find $(SRC_DIR) -name \*.pony)

test: unit-tests build-examples

unit-tests: $(tests_binary)
	$^ --exclude=integration --sequential

$(tests_binary): $(GEN_FILES) $(SOURCE_FILES) | $(BUILD_DIR)
	${PONYC} ${SSL} -o ${BUILD_DIR} $(SRC_DIR)

build-examples:
	find examples/*/* -name '*.pony' -print | xargs -n 1 dirname  | sort -u | grep -v ffi- | xargs -n 1 -I {} ${PONYC} ${SSL} -s --checktree -o ${BUILD_DIR} {}

clean:
	rm -rf $(BUILD_DIR)

realclean:
	rm -rf build

$(docs_dir): $(GEN_FILES) $(SOURCE_FILES)
	rm -rf $(docs_dir)
	${PONYC} --docs-public --pass=docs --output build $(SRC_DIR)

docs: $(docs_dir)

TAGS:
	ctags --recurse=yes $(SRC_DIR)

all: test

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: all clean realclean TAGS test
