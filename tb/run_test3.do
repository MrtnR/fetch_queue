if [file exists work] {vdel -all}
vlib work
vlog -f files.f -timescale "1 ns / 1 ps" +define+DEBUG+TEST_3
onbreak {resume}
vsim -voptargs=+acc work.tb_top
log -r tb_top.*
do wave.do
run 600 ns