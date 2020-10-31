#!/usr/bin/env sh

DATE=$(date +%d_%m_%Y-t%H-%M-%S)
PROJECT=@PROJECT@
SCRATCH=@SCRATCH@
HOST=$(hostname)

OUT=$SCRATCH/out/@EXP_NAME@.$HOST.$DATE

echo "Creating directory: $OUT"
mkdir -p "$OUT"

PROG=$PROJECT/run/@PROG@

PARALLEL=@PARALLEL@
N_JOBS=@N_JOBS@

BENCHMARK_LIST=@BENCHMARK_LIST@

echo "Running benchmarks in: $BENCHMARK_LIST"
time $PARALLEL -j $N_JOBS --ungroup --results "$OUT"/{/} "$PROG" :::: "$BENCHMARK_LIST"
