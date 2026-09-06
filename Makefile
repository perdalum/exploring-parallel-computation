# macOS: Apple Command Line Tools, Swift 6, macOS 15 or newer.
# Sources use eight inputs: C++ launches eight asynchronous tasks;
# Swift GCD chooses how many threads execute the eight iterations.
# CPU affinity is controlled by macOS, not by this Makefile.

CXX = clang++
CXXFLAGS = -O2 -std=c++17
SWIFTC = swiftc
SWIFTFLAGS = -O -swift-version 6
WOLFRAMKERNEL = wolframscript
JULIA = julia
NODE = node

.PHONY: all cpp swift demo demo-wls demo-wls-fast demo-cpp demo-julia demo-js clean

all: cpp swift

cpp: parallelcpp
swift: parallelswift

parallelcpp: parallel.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

parallelswift: parallel.swift
	$(SWIFTC) $(SWIFTFLAGS) $< -o $@

demo: demo-wls demo-wls-fast demo-cpp demo-julia demo-js

demo-wls: parallel.wls
	$(WOLFRAMKERNEL) -file $<

demo-wls-fast: parallel-fast.wls
	$(WOLFRAMKERNEL) -file $<

demo-cpp: parallelcpp
	./$<

demo-julia: parallel.jl
	$(JULIA) --threads=8 $<

demo-js: parallel.mjs
	$(NODE) $<

clean:
	rm -f demo-cpp demo-swift
