`include "defines.sv"

class alu_generator;
  //declaring transaction class
  alu_transaction blueprint;
  //mailbox to send data from generator to driver
  mailbox #(alu_transaction) mb_gd;
  function new(mailbox #(alu_transaction) mb_gd);
    this.mb_gd = mb_gd;
    blueprint = new();
  endfunction
  task start();
    for(int i = 0; i < `no_of_testcases; i++) begin
      void'(blueprint.randomize());
      mb_gd.put(blueprint.copy());
      $display(" GENERATOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",blueprint.mode,blueprint.inp_valid,blueprint.CMD, blueprint.OPA,blueprint.OPB,blueprint.Cin);
      $display("");
    end
  endtask
endclass
