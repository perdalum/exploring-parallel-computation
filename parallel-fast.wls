compiledF = FunctionCompile[
       Function[Typed[n, "Integer64"],
          Module[{sum = 0.},
             Do[sum += Sqrt[Cast[i, "Real64"]], {i, 0, n - 1}];
             sum
          ]
       ]
];

noOfKernels = 8;
inputs = ConstantArray[500000000, noOfKernels];

Echo["start "<>ToString[noOfKernels]<>" kernels."];
LaunchKernels[noOfKernels];
DistributeDefinitions[compiledF];

Echo["Warm up the kernels"];
compiledF[1000];
ParallelEvaluate[compiledF[1000], DistributedContexts->None];

Echo["Compute using one kernel"];
{t1, serial} = AbsoluteTiming[Map[compiledF, inputs]];

Echo["Compute using "<>ToString[noOfKernels]<>" kernels"];
{tp, parallel} =
    AbsoluteTiming[
       ParallelMap[compiledF, inputs,
          DistributedContexts -> None,
          Method -> "FinestGrained"
       ]];

Print["Workers: ",$KernelCount]
Print["Sequential seconds: ",t1]
Print["Parallel seconds: ",tp]
Print["Speedup: ",t1/tp]
Print["Same result: ",(serial===parallel)]

