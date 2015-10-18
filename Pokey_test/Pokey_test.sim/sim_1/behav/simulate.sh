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
ExecStep $xv_path/bin/xsim distortChn_testbench_behav -key {Behavioral:sim_1:Functional:distortChn_testbench} -tclbatch distortChn_testbench.tcl -log simulate.log
