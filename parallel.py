from concurrent.futures import ProcessPoolExecutor
from multiprocessing import get_context
from math import sqrt
from time import perf_counter

def f(n):
    s = 0.0
    for i in range(n):
        s += sqrt(i)
    return s

if __name__ == "__main__":
    inputs = [5_000_000] * 8

    start = perf_counter()
    a = list(map(f, inputs))
    t1 = perf_counter() - start

    start = perf_counter()
    with ProcessPoolExecutor(
        max_workers=8, mp_context=get_context("spawn")
    ) as pool:
        b = list(pool.map(f, inputs))
    tp = perf_counter() - start

    print(f"Sequential: {t1:.3f} s; parallel: {tp:.3f} s")
    print(f"Speedup: {t1 / tp:.2f}; same results: {a == b}")