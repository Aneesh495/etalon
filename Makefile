# Makefile for the Etalon Optical Transport Network Engine
#
# Copyright (c) 2026 Aneesh Krishna. All rights reserved.
# Distributed under the MIT License.

CC ?= clang
CFLAGS ?= -O3 -Wall -Wextra -Werror -fPIC -Iinclude
PYTHON ?= python3

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	LIB_EXT := dylib
else
	LIB_EXT := so
endif

BUILD_DIR := build
LIB_TARGET := $(BUILD_DIR)/libetalon.$(LIB_EXT)
TEST_C_TARGET := $(BUILD_DIR)/test_c

C_SRCS := $(wildcard src/c/*.c)
C_TEST_SRCS := tests/c/test_c_subsystem.c

.PHONY: all test bench lines clean check-style

all: $(LIB_TARGET) $(TEST_C_TARGET)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(LIB_TARGET): $(C_SRCS) include/etalon.h | $(BUILD_DIR)
	@echo "Building shared library $(LIB_TARGET)..."
	$(CC) $(CFLAGS) -shared -o $(LIB_TARGET) $(C_SRCS)

$(TEST_C_TARGET): $(C_SRCS) $(C_TEST_SRCS) include/etalon.h | $(BUILD_DIR)
	@echo "Building C test executable $(TEST_C_TARGET)..."
	$(CC) $(CFLAGS) -o $(TEST_C_TARGET) $(C_SRCS) $(C_TEST_SRCS)

test: all
	@$(PYTHON) scripts/run_full_suite.py

check-style:
	@$(PYTHON) scripts/verify_no_em_dashes.py

bench: all
	@echo "Running sub-50ms protection failover benchmark..."
	@./bin/etalon-cli failover-bench --iterations 1000
	@echo "\nRunning Gaussian Noise physical-layer simulation..."
	@./bin/etalon-cli gn-sim --spans 16 --modulation 16qam --fec sd15

lines:
	@$(PYTHON) scripts/line_counter.py

clean:
	@rm -rf $(BUILD_DIR)
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -delete
	@echo "Clean completed."
