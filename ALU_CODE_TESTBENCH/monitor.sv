`include "defines.sv"

class alu_monitor;
  //declaring transaction class for monitor
  alu_transaction mon_trans;
  //declaring virtual interface for communication between duv and monitor
  virtual alu_intf.monitor mon_vif;
  // mailbox for monitor to scoreboard
  mailbox #(alu_transaction) mb_ms;
   covergroup mon_cg;
      RES_CP : coverpoint mon_trans.RES {
        bins b1 = {[0:9'b111111111]};
      }
      ERR_CP : coverpoint mon_trans.ERR;
      E_CP : coverpoint mon_trans.E { bins one_e = {1};
      }
      G_CP : coverpoint mon_trans.G { bins one_g = {1};
      }
      L_CP : coverpoint mon_trans.L { bins one_l = {1};
      }
      OV_CP: coverpoint mon_trans.OFLOW;
      COUT_CP: coverpoint mon_trans.COUT;
  endgroup


  function new(virtual alu_intf.monitor mon_vif, mailbox #(alu_transaction) mb_ms);
    this.mb_ms = mb_ms;
    this.mon_vif = mon_vif;
    mon_cg = new();
  endfunction
  task monitor_op();
    mon_trans.RES = mon_vif.mon_cb.RES;
    mon_trans.COUT = mon_vif.mon_cb.COUT;
    mon_trans.OFLOW = mon_vif.mon_cb.OFLOW;
    mon_trans.G = mon_vif.mon_cb.G;
    mon_trans.L = mon_vif.mon_cb.L;
    mon_trans.E = mon_vif.mon_cb.E;
    mon_trans.ERR = mon_vif.mon_cb.ERR;
    //inputs
    mon_trans.OPA = mon_vif.mon_cb.OPA;
    mon_trans.OPB = mon_vif.mon_cb.OPB;
    mon_trans.Cin = mon_vif.mon_cb.Cin;
    mon_trans.CMD = mon_vif.mon_cb.CMD;
    mon_trans.mode = mon_vif.mon_cb.mode;
    mon_trans.inp_valid = mon_vif.mon_cb.inp_valid;
    mon_cg.sample();
  endtask

  task start();
    int single_op_arithmetic [] = {4,5,6,7};
    int single_op_logical [] = {6,7,8,9,10,11};
    int count;

    repeat(4)@(mon_vif.mon_cb);
    for(int i = 0; i < `no_of_testcases; i++) begin : forloop
      //@(mon_vif.mon_cb);
      mon_trans = new();
      monitor_op();

      if((mon_trans.inp_valid == 2'b11) || mon_trans.inp_valid == 2'b00) begin : mainif
        monitor_op();
        if((mon_trans.mode == 1)&& ((mon_trans.CMD == 4'b1010) || (mon_trans.CMD == 4'b1001))) begin : if1
          repeat(2)@(mon_vif.mon_cb);
          monitor_op();
          $display("");
          $display("if nested1");
          $display("[%0t] MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.mode,mon_trans.inp_valid,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.Cin);
          $display("DUT OUTPUT RECIEVED : RES == %0d | ERR = %0d",mon_trans.RES,mon_trans.ERR);
          $display("");
        end : if1
        else begin : e1
          repeat(1)@(mon_vif.mon_cb);
          monitor_op();
          $display("");
          $display("else nested2");
          $display("[%0t] MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.mode,mon_trans.inp_valid,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.Cin);
          $display("DUT OUTPUT RECIEVED : RES == %0d | ERR = %0d",mon_trans.RES,mon_trans.ERR);
          $display("");
        end : e1
      end : mainif

      else begin : mainelse
        if((mon_trans.mode == 0) && (mon_trans.CMD inside {single_op_logical})) begin : if1
          repeat(1)@(mon_vif.mon_cb);
          monitor_op();
          $display("mode0");
          $display("[%0t] MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.mode,mon_trans.inp_valid,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.Cin);
        end : if1
        else if ((mon_trans.mode == 1) && mon_trans.CMD inside {single_op_arithmetic}) begin : ei1
          repeat(1)@(mon_vif.mon_cb);
          monitor_op();
          $display("mode1");
          $display("[%0t] MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.mode,mon_trans.inp_valid,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.Cin);
        end : ei1
        else begin : e1
          //if(mon_trans.mode == 0) begin : mode0
          for(count = 0; count < 16; count ++) begin : f1
            repeat(1) @(mon_vif.mon_cb);
            monitor_op();
            //$display("for");
            //$display("[%0t] MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.mode,mon_trans.inp_valid,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.Cin);
            if(mon_trans.inp_valid == 2'b11) begin : i1
              if((mon_trans.mode == 1)&& ((mon_trans.CMD == 9) || (mon_trans.CMD == 10))) begin
                monitor_op();
                $display("[%0t] MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.mode,mon_trans.inp_valid,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.Cin);
                $display("[%0t] | DUT OUTPUT RECEIVED : RES == %0d | ERR = %0d",$time,mon_trans.RES,mon_trans.ERR);
              end
                else begin
                  monitor_op();
                  $display("got 11");
                  $display("[%0t] MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.mode,mon_trans.inp_valid,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.Cin);
                  $display("[%0t] | DUT OUTPUT RECEIVED : RES == %0d | ERR = %0d",$time,mon_trans.RES,mon_trans.ERR);
                end
              break;
            end : i1
          end : f1
          if(count == 16) begin : if_error
            monitor_op();
            $display("error");
            $display("[%0t] MONITOR | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,mon_trans.mode,mon_trans.inp_valid,mon_trans.CMD, mon_trans.OPA,mon_trans.OPB,mon_trans.Cin);
            $display("DUT OUTPUT : RES =  %0d | ERR = %0d", mon_trans.RES,mon_trans.ERR);
          end : if_error
          //end : mode0
        end : e1
      end : mainelse
      if((mon_trans.mode == 1) && ((mon_trans.CMD == 4'b1001) || (mon_trans.CMD == 4'b1010))) begin
        $display("entering last repeat");
        repeat(1)@(mon_vif.mon_cb);
      end
      repeat(1) @(mon_vif.mon_cb);
      monitor_op();
      mb_ms.put(mon_trans);
    end : forloop
  endtask

endclass
