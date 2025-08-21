vlib work
vlog p1.v p1_tb.v
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all
#quit -simS
