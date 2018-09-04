# Environment ------------------------------------------------------------------ 
PROJECT_HOME=$(shell pwd)
TMPDIR=/tmp
PATH=${TMPDIR}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PROJECT_BIN_MAIN=${PROJECT_HOME}/ore
PROJECT_BIN_TESTED=${TMPDIR}/ore-dev
# Configuration ----------------------------------------------------------------
CLITEST_REPOSITORY_URL="https://github.com/aureliojargas/clitest"
CLITEST_BIN_URL="https://raw.githubusercontent.com/aureliojargas/clitest/master/clitest"
CLITEST_BIN=${PROJECT_HOME}/clitest
# Minimum requirement programs -------------------------------------------------
CURL=$(shell which curl)
# List of test files to execute in order ---------------------------------------
TESTS=$(shell find tests -type f -name "*.md")

.PHONY: test $(TESTS)

.bin:
	@rm -f "${PROJECT_BIN_TESTED}"
	ln -s "${PROJECT_BIN_MAIN}" "${PROJECT_BIN_TESTED}"
	@echo "PATH=${PATH}"

.dependency-clitest:
	@test -f "${CLITEST_BIN}" || ${CURL} -sL -o "${CLITEST_BIN}" https://raw.githubusercontent.com/aureliojargas/clitest/master/clitest
	@chmod a+x "${CLITEST_BIN}"

$(TESTS): .dependency-clitest .bin
	export TEST_SHELL=${TEST_SHELL:-"sh"}
	${TEST_SHELL} ${CLITEST_BIN} --prefix 4 $@

test: $(TESTS)
