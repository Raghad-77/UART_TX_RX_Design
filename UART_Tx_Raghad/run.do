vlib work
vlog *.*v
vsim -voptargs=+acc work.UART_TX_TOP_tb 
add wave *
run -all
#quit -sim