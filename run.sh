#!/bin/bash

compilerPath=./declarative-smart-contracts
algoPath=./gasOpt-setGeneration
# testPath=./testRepo/gasOpt-test
testPath=./smart_contracts_evaluation

cd $compilerPath
chmod 777 ./generateMin.sh
chmod 777 ./generateNoOptimization.sh
sbt "run dependency-graph"
sbt "run judgement-check"
cd ..
cp -r $compilerPath/view-materialization/relation-dependencies $algoPath/view-materialization/relation-dependencies
cp -r $compilerPath/view-materialization/contain-judgement $algoPath/view-materialization/contain-judgement


cd $algoPath
chmod 777 ./full-set.py
chmod 777 ./min-set.py
python3 ./full-set.py
python3 ./min-set.py
cd ..
cp -r $algoPath/view-materialization/full-set $compilerPath/view-materialization/full-set
cp -r $algoPath/view-materialization/min-set $compilerPath/view-materialization/min-set


cd $compilerPath
. ./generateNoOptimization.sh
. ./generateMin.sh
cd ..
# cp -r $compilerPath/solidity/min $testPath/contracts/min
# cp -r $compilerPath/solidity/noOptimization $testPath/contracts/noOptimization
. ./moveContract.sh


cd $testPath
. ./all_experiments.sh