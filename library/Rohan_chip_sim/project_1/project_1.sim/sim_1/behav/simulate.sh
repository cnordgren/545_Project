#!/bin/sh -f
xv_path="/afs/ece/support/xilinx/xilinx.release/Vivado"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim testbench_LS244_behav -key {Behavioral:sim_1:Functional:testbench_LS244} -tclbatch testbench_LS244.tcl -log simulate.log
