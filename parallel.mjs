import { Worker, isMainThread, parentPort, workerData }
  from 'node:worker_threads';

function f(n) {
  let s = 0;
  for (let i = 0; i < n; i++) s += Math.sqrt(i);
  return s;
}

function inWorker(n) {
  return new Promise((resolve, reject) => {
    const worker = new Worker(new URL(import.meta.url), {
      workerData: n
    });
    worker.once('message', resolve);
    worker.once('error', reject);
    worker.once('exit', code => {
      if (code !== 0) reject(new Error(`Worker exit: ${code}`));
    });
  });
}

if (!isMainThread) {
  parentPort.postMessage(f(workerData));
} else {
  const inputs = Array(8).fill(500_000_000);

  let start = performance.now();
  const a = inputs.map(f);
  const t1 = performance.now() - start;

  start = performance.now();
  const b = await Promise.all(inputs.map(inWorker));
  const tp = performance.now() - start;

  console.log(`Sequential: ${t1.toFixed(1)/1000} s`);
  console.log(`Parallel: ${tp.toFixed(1)/1000} s`);
  console.log('Speedup:', t1 / tp);
  console.log('Same results:', a.every((x, i) => x === b[i]));
}