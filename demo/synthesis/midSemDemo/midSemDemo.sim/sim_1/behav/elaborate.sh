#!/bin/sh -f
xv_path="/afs/ece.cmu.edu/support/xilinx/xilinx.release/Vivado-2015.2/Vivado/2015.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto 96d637e94c6c455fbf19c529458fcf07 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot pokeyaudio_behav xil_defaultlib.pokeyaudio xil_defaultlib.glbl -log elaborate.log
