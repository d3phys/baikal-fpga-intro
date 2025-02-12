#!/bin/bash

TESTS=(
    "-DN=12 -DM=32"
    "-DN=20 -DM=32"
)

for TEST in "${TESTS[@]}"
do
    echo "Testing: ${TEST} (Behavioral)"
	iverilog -g 2012 signext_tb.sv signext_bh.sv ${TEST}
    ./a.out

    echo "Testing: ${TEST} (Structural)"
	iverilog -g 2012 signext_tb.sv signext_st.sv copy.sv ${TEST}
    ./a.out
done

rm ./a.out
