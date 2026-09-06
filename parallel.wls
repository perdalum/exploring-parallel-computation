f[n_] := Module[{s = 0.},
   Do[s += Sqrt[N[i]], {i, 0, n - 1}];
   s];

inputs = ConstantArray[5000000, 8];

noOfKernels = 8;
Echo["start "<>ToString[noOfKernels]<>" kernels."];

(*Start workers before measuring.*)
LaunchKernels[noOfKernels];
DistributeDefinitions[f];
Echo["Warm up the kernels"];
f[1000];
ParallelEvaluate[f[1000]];

(*One calculation at a time*)
Echo["Calculate using one kernel"];
{t1, a} = AbsoluteTiming[Map[f, inputs]];

(*Several calculations at a time*)
Echo["Calculate using "<>ToString[noOfKernels]<>" kernels"];
{tp, b} = AbsoluteTiming[ParallelMap[f, inputs]];

Print["Workers: ",$KernelCount]
Print["Sequential seconds: ",t1]
Print["Parallel seconds: ",tp]
Print["Speedup: ",t1/tp]
Print["Same result: ",(a===b)]

