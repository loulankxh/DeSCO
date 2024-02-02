# Artifact for Verifying DeSCO

## Experiment Setup

### Download the repos:
Git clone this repo, and download (git clone) the following repos into the main folder:
1. Compiler repo: [declarative-smart-contracts](https://github.com/loulankxh/declarative-smart-contracts)
2. Materialization Algorithm repo: [gasOpt-setGeneration](https://github.com/loulankxh/gasOpt-setGeneration)
3. Test repo: [gasOpt-test](https://github.com/loulankxh/gasOpt-test), and unzip the [compressed tracefiles](https://github.com/loulankxh/gasOpt-test/blob/47dea5f59f2e1e79a97c2c0171a96ddca3ba3d6c/tracefiles_long.tar.xz) into a folder

### Install dependencies
1. Install [SBT](https://www.scala-sbt.org/1.x/docs/Setup.html), more information provided in [declarative-smart-contracts](https://github.com/loulankxh/declarative-smart-contracts)
2. Install [Python](https://www.python.org)
3. Install [NPM](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
4. Install [Ganache](https://trufflesuite.com/ganache/): npm install -g ganache
5. Install [Truffle](https://trufflesuite.com/docs/truffle/how-to/install/): npm install -g truffle

## Reproduce experiment results

### Run all at once
Open one terminal to run Ganache:
```
ganache -a 10 -p 8545 --logging.debug
```
Open another terminal to run the bash file [run.sh](https://github.com/loulankxh/DeSCO/blob/main/run.sh).


### Run step by step

#### A. Generate materialization plans:
1. Generate Datalog metadata:
```
cd declarative-smart-contracts
sbt "run dependency-graph"
sbt "run judgement-check"
```
2. Move the [generated metadata(contain-judgement, relation-dependencies)](https://github.com/loulankxh/declarative-smart-contracts/tree/29b0cebc5b3df05d920e1555efda6e4884cd7184/view-materialization) into [alogrithm folder](https://github.com/loulankxh/gasOpt-setGeneration/tree/79d73b6dec12a727035e96ba978c50549462021b/view-materialization).
3. Generate materialization plans:
```
cd gasOpt-setGeneration
python3 ./full-set.py
python3 ./min-set.py
```

#### B. Compile Datalog into Solidity
1. Move the [full materialization plan](https://github.com/loulankxh/gasOpt-setGeneration/tree/79d73b6dec12a727035e96ba978c50549462021b/view-materialization/full-set) and [minimal materialization plan](https://github.com/loulankxh/gasOpt-setGeneration/tree/79d73b6dec12a727035e96ba978c50549462021b/view-materialization/min-set) into [compiler foler](https://github.com/loulankxh/declarative-smart-contracts/tree/29b0cebc5b3df05d920e1555efda6e4884cd7184/view-materialization).
2. Generate Solidity of Incremential Datalog and minimal versions
```
cd declarative-smart-contracts
./generateNoOptimization.sh
./generateMin.sh
```
More details on how to use the compiler to generate Solidity for a single contract, or using different optimization technique combiniations(e.g., with arithmetic optimization turn on or off, selective view materialization turn on or off, read projection turn on or off) are provided at [declarative-smart-contracts](https://github.com/loulankxh/declarative-smart-contracts).

### C. Run experiments and get results
1. Move the [generated Solidity](https://github.com/loulankxh/declarative-smart-contracts/tree/29b0cebc5b3df05d920e1555efda6e4884cd7184/solidity) into [test folder](https://github.com/loulankxh/gasOpt-test/tree/47dea5f59f2e1e79a97c2c0171a96ddca3ba3d6c/contracts)
2. Open Ganache: ```ganache -a 10 -p 8545 --logging.debug```
3. Compile and run test for a single contract:
```
cd gasOpt-test
truffle compile contracts/[benchmark_folder]/[contractNameVersion].sol
truffle test ./test_longTrace/[contractName]_test_gas.js --compile-none
```
Here, the "benchmark_folder" can be [min](https://github.com/loulankxh/gasOpt-test/tree/47dea5f59f2e1e79a97c2c0171a96ddca3ba3d6c/contracts/min), [noOptimization](https://github.com/loulankxh/gasOpt-test/tree/47dea5f59f2e1e79a97c2c0171a96ddca3ba3d6c/contracts/noOptimization) and [reference](https://github.com/loulankxh/gasOpt-test/tree/47dea5f59f2e1e79a97c2c0171a96ddca3ba3d6c/contracts/reference), storing the Solidity programs of DeSCO, Incremental Datalog, and Reference respectively. The "contarctName" can be "auction", or any other existing contracts in the [benchmark](https://github.com/loulankxh/declarative-smart-contracts/tree/29b0cebc5b3df05d920e1555efda6e4884cd7184/benchmarks). The corresponding "contractNameVersion" can be "auction1", "auction2", ..., which represent Solidity programms under different materialization plans of the same contract.

## Supplementary materials
Appendix for [detailed proof](https://github.com/loulankxh/DeSCO/blob/main/README.md) for some lemma and theorem used in the paper.
Evaluation results: see in "evaluation_results.xlsx".