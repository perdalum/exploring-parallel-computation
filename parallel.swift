import Dispatch
import Synchronization

func f(_ n: Int) -> Double {
    var s = 0.0
    for i in 0..<n { s += Double(i).squareRoot() }
    return s
}

func demo() {
    let inputs = Array(repeating: 5_000_000, count: 8)
    let results = Mutex(Array(repeating: 0.0, count: inputs.count))

    var start = DispatchTime.now().uptimeNanoseconds
    let a = inputs.map(f)
    let t1 = Double(DispatchTime.now().uptimeNanoseconds - start) / 1e9

    start = DispatchTime.now().uptimeNanoseconds
    DispatchQueue.concurrentPerform(iterations: inputs.count) { i in
        let value = f(inputs[i])
        results.withLock { $0[i] = value }
    }
    let tp = Double(DispatchTime.now().uptimeNanoseconds - start) / 1e9
    let b = results.withLock { $0 }

    print("Sequential: \(t1) s");
    print("Parallel: \(tp) s");
    print("Speedup: \(t1 / tp)");
    print("Same results: \(a == b)");
}

demo()