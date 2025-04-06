TEST_SIZE ?= 4096 
TEST_OP   ?= add
TB_OP     ?= add_pipe
DEBUG     ?= 0

TB_LIST := fp16u_tb.v

RTL_LIST := fp16add_pipe.v \
			fp16daz_decoder.v \
			fp16ftz_encoder.v \
			sign_magnitude_add.v \
			priority_msb16_encoder.v

sim: $(TB_LIST) $(RTL_LIST)
	python3 test.py $(TEST_SIZE) $(TEST_OP) > test.txt
	iverilog -g2012 $^ -o sim -DTEST_SIZE=$(TEST_SIZE) -DTEST_OP=$(TB_OP) -DDEBUG=$(DEBUG)
	./sim

gui:
	quartus fpga &

waves: dump.vcd
	gtkwave dump.vcd &

clean:
	rm -rf sim dump.vcd test.txt

.PHONY: clean sim waves
