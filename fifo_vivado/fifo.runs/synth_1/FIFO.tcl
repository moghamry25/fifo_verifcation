# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param synth.incrementalSynthesisCache C:/Users/mo3nt/AppData/Roaming/Xilinx/Vivado/.Xil/Vivado-100036-Ghamry/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a35ticpg236-1L

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/courses/Digital/Verification/Projects/FIFO/fifo/fifo.cache/wt [current_project]
set_property parent.project_path D:/courses/Digital/Verification/Projects/FIFO/fifo/fifo.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/courses/Digital/Verification/Projects/FIFO/fifo/fifo.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv {
  D:/courses/Digital/Verification/Projects/FIFO/interface.sv
  D:/courses/Digital/Verification/Projects/FIFO/FIFO.sv
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/courses/Digital/Verification/Projects/FIFO/fifo/Constraints_basys3.xdc
set_property used_in_implementation false [get_files D:/courses/Digital/Verification/Projects/FIFO/fifo/Constraints_basys3.xdc]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top FIFO -part xc7a35ticpg236-1L


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef FIFO.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file FIFO_utilization_synth.rpt -pb FIFO_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
