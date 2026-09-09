if [file exists work] {
    vdel -all work
}
vlib work

# Compile interface, modules, package, and top-level explicitly
vlog -sv apb_if.sv
vlog -sv apb_slave.sv
vlog -sv apb_package.sv
vlog -sv tb_top.sv

# Start simulation with UVM test name argument
vsim -voptargs="+acc" tb_top +UVM_TESTNAME=apb_test

# Add wave windows (matching the instance name 'apb_vif' in tb_top)
add wave -position insertpoint sim:/tb_top/apb_vif/*
add wave -position insertpoint sim:/tb_top/dut/*

# Run simulation
run -all
