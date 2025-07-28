`include "defines.sv"

class alu_scoreboard;
  //declaring transaction class | one for actual result from monitor | one for expected result from ref model

  alu_transaction exp_trans;
  alu_transaction act_trans;

  // mailbox for monitor and scoreboard
  mailbox #(alu_transaction) mb_ms;
  // mailbox for ref model and scoreboard
  mailbox #(alu_transaction) mb_rs;

  int MATCH = 0;
  int MISMATCH = 0;

  function new(mailbox #(alu_transaction) mb_rs,mailbox #(alu_transaction) mb_ms);
    this.mb_ms = mb_ms;
    this.mb_rs = mb_rs;
  endfunction

  task start();
    for(int i = 0; i < `no_of_testcases; i++) begin : forloop
      exp_trans = new();
      act_trans = new();
      //fork
        begin
          $display(" ============================== reference_model ============================== ");
          $display("");
          mb_ms.get(act_trans); // getting actual output from monitor
          mb_rs.get(exp_trans); // getting expected result from the monitor

          $display("[%0t] |INPUT PACKET RECEIVED TO REFERENCE MODEL | OPA = %0d | OPB = %0d | Cin = %0d |INP_VALID == %2b ",$time,exp_trans.OPA,exp_trans.OPB,exp_trans.Cin,exp_trans.inp_valid);
          $display("");
          $display("[%0t] | MONITOR | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b |",$time,act_trans.RES,act_trans.OFLOW,act_trans.COUT,act_trans.G,act_trans.L,act_trans.E,act_trans.ERR);
          $display("");
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b |",$time,exp_trans.RES,exp_trans.OFLOW,exp_trans.COUT,exp_trans.G,exp_trans.L,exp_trans.E,exp_trans.ERR);
          $display("");
          compare_report();
          $display("");
        end

      //join
    //if(i != (`no_of_testcases - 1))
      //compare_report();
    end : forloop
    $display(" ============================== reference_model ============================== ");
    $display("TOTAL MATCH : %0d | TOTAL MISMATCH : %0d",MATCH,MISMATCH);
  endtask

  task compare_report();
    if(
      act_trans.RES === exp_trans.RES &&
      act_trans.OFLOW === exp_trans.OFLOW &&
      act_trans.COUT === exp_trans.COUT &&
      act_trans.G === exp_trans.G &&
      act_trans.L === exp_trans.L &&
      act_trans.E === exp_trans.E &&
      act_trans.ERR === exp_trans.ERR
    ) begin : if_match
        MATCH = MATCH + 1;
        $display(" MATCH SUCCESSFUL | MATCH COUNT = %0d ",MATCH);
    end : if_match

    else begin : mismatch
      MISMATCH = MISMATCH + 1;
      $display("MATCH FAILED | MISMATCH COUNT = %0d",MISMATCH);
    end : mismatch
  endtask

endclass
