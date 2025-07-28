`include "defines.sv"

class alu_driver;

  //mailbox for driver and generator
  mailbox #(alu_transaction) mb_gd;
  //mailbox for driver and reference model
  mailbox #(alu_transaction) mb_dr;

  //creating transaction class handle to later store packets from mb
  alu_transaction drv_trans;

  // virtual interface for interaction with DUV
  virtual alu_intf.drv drv_vif;
  covergroup alu_cgrp;
    mode_cp : coverpoint drv_trans.mode;
    inp_valid_cp : coverpoint drv_trans.inp_valid;
    opa_cp : coverpoint drv_trans.OPA {
      bins all_zeros = {0};
      bins max_val = {255};
      bins opa = {[255:0]};
    }
    opb_cp : coverpoint drv_trans.OPB {
      bins all_zeros = {0};
      bins max_val = {255};
      bins opb = {[255:0]};
    }
    cin_cp : coverpoint drv_trans.Cin;
    cmd_cp : coverpoint drv_trans.CMD;

    //cross coverage

    cmd_x_inp_v : cross cmd_cp,inp_valid_cp;
    mode_x_inp_v : cross mode_cp,inp_valid_cp;
    mode_x_cmd : cross mode_cp,cmd_cp;
    opa_x_opb : cross opa_cp,opb_cp;
  endgroup



  function new(mailbox #(alu_transaction) mb_gd , mailbox #(alu_transaction) mb_dr, virtual alu_intf drv_vif);
    this.mb_gd = mb_gd;
    this.mb_dr = mb_dr;
    this.drv_vif = drv_vif;
    alu_cgrp = new();
  endfunction

  task drive_inputs();
    drv_vif.drv_cb.OPA <= drv_trans.OPA;
    drv_vif.drv_cb.OPB <= drv_trans.OPB;
    drv_vif.drv_cb.Cin <= drv_trans.Cin;
    drv_vif.drv_cb.mode <= drv_trans.mode;
    drv_vif.drv_cb.inp_valid <=  drv_trans.inp_valid;
    drv_vif.drv_cb.CMD <= drv_trans.CMD;
    alu_cgrp.sample();
  endtask


  task start();

    int single_op_arithmetic[] = {4,5,6,7};
    int single_op_logical[] = {6,7,8,9,10,11};
    int two_op_arithmetic[] = {0,1,2,3,8,9,10};
    int two_op_logical[] = {0,1,2,3,4,5,12,13};

    repeat(3)@(drv_vif.drv_cb);
    for(int i = 0; i < `no_of_testcases; i++) begin
      //repeat(1)@(drv_vif.drv_cb);
      drv_trans = new();
      mb_gd.get(drv_trans);

      drv_trans.CMD.rand_mode(1);
      drv_trans.mode.rand_mode(1);

      if(drv_trans.inp_valid == 2'b11 || drv_trans.inp_valid == 2'b00) begin : if_start
        $display("");
        $display("[%0t] DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,drv_trans.mode,drv_trans.inp_valid,drv_trans.CMD, drv_trans.OPA,drv_trans.OPB,drv_trans.Cin);
        $display("");
        drive_inputs();
        if(((drv_trans.mode == 1)) && (drv_trans.CMD == 4'b1010 || drv_trans.CMD == 4'b1001))
          repeat(2)@(drv_vif.drv_cb);
        else
          repeat(1)@(drv_vif.drv_cb);
        mb_dr.put(drv_trans); //putting in reference model mailbox

      end : if_start

      else begin : else_start
        if(drv_trans.inp_valid == 2'b01 || drv_trans.inp_valid == 2'b10) begin : if_single_op
          if(drv_trans.mode == 0) begin : mode0
            if(drv_trans.CMD inside{single_op_logical}) begin : cmd_check1
              $display("");
              $display("[%0t] DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,drv_trans.mode,drv_trans.inp_valid,drv_trans.CMD, drv_trans.OPA,drv_trans.OPB,drv_trans.Cin);
              $display("");
              drive_inputs();
              repeat(1)@(drv_vif.drv_cb);
              mb_dr.put(drv_trans);
            end : cmd_check1
            else begin : cmd_check2
              $display("");
               $display("[%0t] DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,drv_trans.mode,drv_trans.inp_valid,drv_trans.CMD, drv_trans.OPA,drv_trans.OPB,drv_trans.Cin);
              $display("");
              drive_inputs();

              drv_trans.mode.rand_mode(0);
              drv_trans.CMD.rand_mode(0);
              //repeat(1)@(drv_vif.drv_cb);
              mb_dr.put(drv_trans);
              for(int i =0; i < 16; i++) begin : forloop
                repeat(1)@(drv_vif.drv_cb);
                void'(drv_trans.randomize());
                drive_inputs();
                $display("");
                $display(" [%0d] |[%0t] DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",i,$time,drv_trans.mode,drv_trans.inp_valid,drv_trans.CMD, drv_trans.OPA,drv_trans.OPB,drv_trans.Cin);
                $display("");
                mb_dr.put(drv_trans);
                if(drv_trans.inp_valid == 2'b11) begin : i1
                  break;
                end :i1
              end : forloop

            end : cmd_check2

          end : mode0

          else begin : mode1
            if(drv_trans.CMD inside {single_op_arithmetic}) begin : if_single_op
              $display("");
              $display("[%0t] DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,drv_trans.mode,drv_trans.inp_valid,drv_trans.CMD, drv_trans.OPA,drv_trans.OPB,drv_trans.Cin);
              $display("");
              drive_inputs();
              //repeat(1)@(drv_vif.drv_cb);
              mb_dr.put(drv_trans);
            end : if_single_op
            else begin : two_op_cmd
              $display("");
              $display("[%0t] DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,drv_trans.mode,drv_trans.inp_valid,drv_trans.CMD, drv_trans.OPA,drv_trans.OPB,drv_trans.Cin);
              $display("");
              drv_trans.mode.rand_mode(0);
              drv_trans.CMD.rand_mode(0);
              drive_inputs();
              //repeat(1)@(drv_vif.drv_cb);
              mb_dr.put(drv_trans);
              for(int i = 0; i < 16; i++) begin : forloop
                repeat(1)@(drv_vif.drv_cb);
                void'(drv_trans.randomize());
                drive_inputs();
                $display("");
                $display(" [%0d] |[%0t] DRIVER | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",i,$time,drv_trans.mode,drv_trans.inp_valid,drv_trans.CMD, drv_trans.OPA,drv_trans.OPB,drv_trans.Cin);
                $display("");
                mb_dr.put(drv_trans);
                if(drv_trans.inp_valid == 2'b11) begin :i1
                  if(drv_trans.CMD == 9 || drv_trans.CMD == 10)
                    repeat(1)@(drv_vif.drv_cb);
                  break;
                end : i1

              end : forloop
            end : two_op_cmd

          end : mode1
        end : if_single_op
      end : else_start
      if((drv_trans.CMD == 4'b1010 || drv_trans.CMD == 4'b1001)&&drv_trans.mode == 1)begin
        repeat(1)@(drv_vif.drv_cb);
      end
      repeat(1)@(drv_vif.drv_cb);
    end
  endtask
endclass
