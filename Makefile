# Environment ------------------------------------------------------------------ 
CARCASSONNE_HOME=$(shell pwd)
TMPDIR=/tmp
PATH=${TMPDIR}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Configuration ----------------------------------------------------------------
CLITEST_REPOSITORY_URL="https://github.com/aureliojargas/clitest"
CLITEST_BIN_URL="https://raw.githubusercontent.com/aureliojargas/clitest/master/clitest"
CLITEST_BIN=${CARCASSONNE_HOME}/clitest
CARCASSONNE_DEV=${TMPDIR}/carcassonne-dev
# Minimum requirement programs -------------------------------------------------
CURL=$(shell which curl)
# List of test files to execute in order ---------------------------------------
TESTS=$(shell find tests -type f -name "*.md")

.PHONY: test $(TESTS)

.carcassonne:
	@rm -f "${CARCASSONNE_DEV}"
	@ln -s "${CARCASSONNE_HOME}/carcassonne" "${CARCASSONNE_DEV}"

.dependency-clitest:
	@test -f "${CLITEST_BIN}" || ${CURL} -sL -o "${CLITEST_BIN}" https://raw.githubusercontent.com/aureliojargas/clitest/master/clitest
	@chmod a+x "${CLITEST_BIN}"

$(TESTS): .dependency-clitest .carcassonne
	export TEST_SHELL=${TEST_SHELL:-"sh"}
	${TEST_SHELL} ${CLITEST_BIN} --prefix 4 $@

test: $(TESTS)
