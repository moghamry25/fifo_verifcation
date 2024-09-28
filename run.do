vlib work
vlog +define+ASSERTIONS_ON fif0_monitor.sv FIFO.sv FIFO_scoreboard_pkg.sv fifo_tb.sv interface.sv package.sv pkg.sv top.sv share_pkg.sv +cover -covercells
vsim -voptargs=+acc work.top -cover -sv_seed wlftikv888
add wave *
add wave -position insertpoint sim:/top/tb/vif/*
coverage save top.ucdb -onexit
run -all