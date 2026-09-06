#include <chrono>
#include <cmath>
#include <future>
#include <iostream>
#include <vector>

double f(int n) {
    double s = 0;
    for (int i = 0; i < n; ++i) s += std::sqrt(double(i));
    return s;
}

int main() {
    using Clock = std::chrono::steady_clock;
    std::vector<int> inputs(8, 500'000'000);
    std::vector<double> a, b;

    auto start = Clock::now();
    for (int n : inputs) a.push_back(f(n));
    double t1 = std::chrono::duration<double>(Clock::now() - start).count();

    start = Clock::now();
    std::vector<std::future<double>> tasks;
    for (int n : inputs)
        tasks.push_back(std::async(std::launch::async, f, n));
    for (auto& task : tasks) b.push_back(task.get());
    double tp = std::chrono::duration<double>(Clock::now() - start).count();

    std::cout << "Sequential: " << t1 << " s\n";
    std::cout << "Parallel: " << tp << " s\n";
    std::cout << "Speedup: " << t1 / tp << " s\n";
    std::cout << "Same results: " << std::boolalpha << (a == b) << '\n';
}