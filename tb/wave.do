onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/i_clk
add wave -noupdate /tb_top/rst_n
add wave -noupdate /tb_top/dut/pc_in
add wave -noupdate /tb_top/dut/cache_rd_en
add wave -noupdate /tb_top/dut/dout
add wave -noupdate /tb_top/dut/dout_valid
add wave -noupdate /tb_top/dut/inst_to_fifo
add wave -noupdate /tb_top/dut/fifo_write/a
add wave -noupdate /tb_top/dut/fifo_write/b
add wave -noupdate /tb_top/dut/fifo_write/c
add wave -noupdate /tb_top/dut/fifo_write/d
add wave -noupdate /tb_top/dut/q_ctrl/state
add wave -noupdate /tb_top/dut/q_ctrl/next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {44575 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {315 ns}
