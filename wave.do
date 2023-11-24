onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/DUT/clk
add wave -noupdate /cpu_tb/DUT/reset
add wave -noupdate /cpu_tb/DUT/s
add wave -noupdate /cpu_tb/DUT/load
add wave -noupdate /cpu_tb/DUT/in
add wave -noupdate /cpu_tb/DUT/out
add wave -noupdate /cpu_tb/DUT/N
add wave -noupdate /cpu_tb/DUT/V
add wave -noupdate /cpu_tb/DUT/Z
add wave -noupdate /cpu_tb/DUT/w
add wave -noupdate /cpu_tb/DUT/instruction
add wave -noupdate /cpu_tb/DUT/sximm5
add wave -noupdate /cpu_tb/DUT/sximm8
add wave -noupdate /cpu_tb/DUT/mdata
add wave -noupdate /cpu_tb/DUT/PC
add wave -noupdate /cpu_tb/DUT/opcode
add wave -noupdate /cpu_tb/DUT/writenum
add wave -noupdate /cpu_tb/DUT/readnum
add wave -noupdate /cpu_tb/DUT/nsel
add wave -noupdate /cpu_tb/DUT/op
add wave -noupdate /cpu_tb/DUT/vsel
add wave -noupdate /cpu_tb/DUT/shift
add wave -noupdate /cpu_tb/DUT/ALUop
add wave -noupdate /cpu_tb/DUT/loada
add wave -noupdate /cpu_tb/DUT/loadb
add wave -noupdate /cpu_tb/DUT/loadc
add wave -noupdate /cpu_tb/DUT/loads
add wave -noupdate /cpu_tb/DUT/asel
add wave -noupdate /cpu_tb/DUT/bsel
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/data_in
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/writenum
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/readnum
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/write
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/clk
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/data_out
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/onehotWrite
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/onehotRead
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R0
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R1
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R2
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R3
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R4
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R5
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R6
add wave -noupdate /cpu_tb/DUT/DP/REGFILE/R7
add wave -noupdate /cpu_tb/DUT/write
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3735 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 250
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
configure wave -timelineunits ps
update
WaveRestoreZoom {3597 ps} {4427 ps}
