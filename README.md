# Exploring parallel computation

Small, deliberately direct examples of running the same CPU-bound calculation sequentially and in parallel. The implementations use C++, Swift, Node.js, Julia, Python, and Wolfram Language.

Each program applies a square-root summation function to eight independent inputs, reports the sequential and parallel elapsed times and speedup, and checks that both paths return the same results.

These examples explore parallel execution; they are not a language benchmark. The current source files do not all use the same input size, and the runtimes include different amounts of worker startup and scheduling overhead.

## Implementations

| File | Parallel mechanism | Current work per job |
| --- | --- | ---: |
| `parallel.cpp` | `std::async` | 500,000,000 iterations |
| `parallel.swift` | `DispatchQueue.concurrentPerform` | 5,000,000 iterations |
| `parallel.mjs` | Node.js worker threads | 500,000,000 iterations |
| `parallel.jl` | `Threads.@threads` | 500,000,000 iterations |
| `parallel.py` | `ProcessPoolExecutor` | 5,000,000 iterations |
| `parallel.wls` | `ParallelMap` | 5,000,000 iterations |
| `parallel-fast.wls` | `FunctionCompile` and `ParallelMap` | 500,000,000 iterations |
| `parallel.nb` | Wolfram notebook | Interactive exploration |

The accompanying article is [`2026-09-06--explorations-parallel-computing.html`](2026-09-06--explorations-parallel-computing.html).

## Requirements

The Makefile is intended for macOS. Install only the runtimes needed for the examples you want to run:

- Apple Command Line Tools with a C++17 compiler
- Swift 6 on macOS 15 or newer
- Node.js with `node:worker_threads`
- Julia
- Wolfram Engine or Wolfram Language with local parallel kernels
- Python 3 for the experimental Python version

The examples use only standard runtime libraries and have no package dependencies.

## Run the demonstrations

Run the C++, Julia, JavaScript, and two Wolfram demonstrations:

```sh
make demo
```

Run them individually:

```sh
make demo-cpp
make demo-julia
make demo-js
make demo-wls
make demo-wls-fast
```

The Julia target starts Julia with eight threads. The Wolfram scripts request eight local subkernels and print the number actually available.

Build and run the Swift version separately:

```sh
make swift
./parallelswift
```

Run the Python version directly:

```sh
python3 parallel.py
```

The Python version is retained as an experimental implementation and was not part of the recorded comparison in the article.

## Interpreting the results

The programs compare sequential and parallel execution within each implementation. Before comparing languages, make the input sizes identical, decide whether worker startup and compilation belong inside the timed region, and repeat each measurement under comparable system load.

The workload is intentionally CPU-intensive. Running `make demo` performs billions of square-root operations and may keep several CPU cores busy for a while.

## License

The source code is available under the [MIT License](LICENSE).

The accompanying blog article retains the CC BY-NC-SA 4.0 notice stated in its footer.
