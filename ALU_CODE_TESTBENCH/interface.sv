`include "defines.sv"

interface alu_intf(input bit clk,RST,CE);
  logic [`W-1 : 0] OPA;
  logic [`W-1 :0] OPB;
  logic Cin;
  //logic CE;
  logic mode;
  logic [1:0] inp_valid;
  logic [`N-1 : 0] CMD;
  logic [`W:0] RES;
  logic OFLOW;
  logic COUT;
  logic G;
  logic L;
  logic E;
  logic ERR;

  clocking drv_cb @(posedge clk); //clocking block for driver
    default input #0 output #0;
    output OPA,OPB,Cin,mode,inp_valid,CMD;
  endclocking

  clocking mon_cb@(posedge clk); // clocking block for the monitor
    default input #0 output #0;
    input RES,OFLOW,COUT,G,L,E,ERR;
    input OPA,OPB,Cin,mode,inp_valid,CMD;
  endclocking

  clocking ref_cb @(posedge clk);
    default input #0 output #0;
    input CE,RST,clk;
  endclocking

  modport drv (clocking drv_cb);
  modport monitor(clocking mon_cb);
  modport ref_mod(clocking ref_cb);

//endinterface

// reset output assertions.
/*
property rst_out;
  @(posedge clk) RST |-> ##[0:5] (RES == 9'bzzzzzzzz && ERR == 1'bz && E == 1'bz && G == 1'bz && L == 1'bz && COUT == 1'bz && OFLOW == 1'bz);
endproperty

assert property(rst_out)
  $info("RESET PASSED");
  else
    $info(" RESET FAILED");

// CLOCK EN check


property clk_en_ppt;
  @(posedge clk) disable iff (RST) !(CE) |=> (CE);
endproperty

assert property(clk_en_ppt)
  $info("CLK_EN PASSEED");
  else
    $info("CLK_EN FAILED");
// property for 16 cycle err
property timeout_ppt;
  @(posedge clk) disable iff(RST) (CE && (inp_valid == 2'b10 || inp_valid == 2'b01)) |-> ##16 ERR;
endproperty

assert property (timeout_ppt)
  $info("Err set");
  else
    $info("Err not set");
// validity

property check_valid_ppt;
  @(posedge clk) disable iff(RST) CE |-> $isunknown({OPA,OPB,inp_valid,Cin,mode,CMD});
endproperty

assert property(check_valid_ppt)
$info("inputs valid");
  else
    $info("inputs not valid");
*/

endinterface
