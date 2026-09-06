function f(n)
    s = 0.0
    for i in 0:n-1
        s += sqrt(Float64(i))
    end
    s
end

function parallel_map(f, inputs)
    results = zeros(length(inputs))
    Threads.@threads for i in eachindex(inputs)
        results[i] = f(inputs[i])
    end
    results
end

inputs = fill(5_000_000, 8)

# Warm up both paths before timing compilation-free calls.
map(f, [1000])
parallel_map(f, [1000])

t1 = @elapsed a = map(f, inputs)
tp = @elapsed b = parallel_map(f, inputs)

println("Threads: ", Threads.nthreads())
println("Sequential: $t1 s; parallel: $tp s")
println("Speedup: ", t1 / tp, "; same results: ", a == b)
