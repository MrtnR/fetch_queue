onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {IFQ Interface}
add wave -noupdate /tb_top/top_if/i_clk
add wave -noupdate /tb_top/top_if/rst_n
add wave -noupdate /tb_top/top_if/i_cache_pc
add wave -noupdate /tb_top/top_if/cache_rd_en
add wave -noupdate /tb_top/top_if/cache_abort
add wave -noupdate /tb_top/top_if/cache_dout
add wave -noupdate /tb_top/top_if/cache_dout_valid
add wave -noupdate /tb_top/top_if/dispatch_pc
add wave -noupdate /tb_top/top_if/inst
add wave -noupdate /tb_top/top_if/empty
add wave -noupdate /tb_top/top_if/ifq_full
add wave -noupdate /tb_top/top_if/inst_rd_en
add wave -noupdate /tb_top/top_if/jmp_br_addr
add wave -noupdate /tb_top/top_if/jmp_br_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {44575 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {630 ns}
