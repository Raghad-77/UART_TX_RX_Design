vlib work
vlog *.*v UART_RX_TOP_tb.sv
vsim -voptargs=+acc work.UART_RX_TOP_tb 
add wave *
run -all
#quit -sim