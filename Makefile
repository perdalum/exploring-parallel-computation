# macOS: Apple Command Line Tools, Swift 6, macOS 15 or newer.
# Sources use eight inputs: C++ launches eight asynchronous tasks;
# Swift GCD chooses how many threads execute the eight iterations.
# CPU affinity is controlled by macOS, not by this Makefile.

CXX = clang++
CXXFLAGS = -O2 -std=c++17
SWIFTC = swiftc
SWIFTFLAGS = -O -swift-version 6

.PHONY: all cpp swift clean

all: cpp swift

cpp: parallelcpp
swift: parallelswift

parallelcpp: parallel.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

parallelswift: parallel.swift
	$(SWIFTC) $(SWIFTFLAGS) $< -o $@


clean:
	rm -f demo-cpp demo-swift
