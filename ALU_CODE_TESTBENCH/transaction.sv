`include "defines.sv"

class alu_transaction;
  //randomizing all the inputs for randomized testcases
  rand logic [`W-1 : 0] OPA;
  rand logic [`W-1 : 0] OPB;
  rand logic Cin;
  rand logic mode;
  rand logic [1:0] inp_valid;
  rand logic [`N-1 : 0] CMD;
  //rand logic CE;
  //declaring the outputs

  logic [`W : 0] RES;
  logic OFLOW;
  logic COUT;
  logic G;
  logic L;
  logic E;
  logic ERR;
  // constraint for the command input range |
  /*constraint cmd_range {
    (mode == 1) -> (CMD inside{[0:10]});
    (mode == 0) -> (CMD inside {[0:13]});
  }*/

    //constraint c1 {inp_valid == 2'b11 ;mode == 1;CMD == 9;OPB inside {[0:7]};OPA inside {[0:7]};/*inp_valid == 2'b11;*/}
  // function created to make blueprint using deepcopy
  function alu_transaction copy ();
    copy = new();
    copy.OPA = this.OPA;
    copy.OPB = this.OPB;
    copy.Cin = this.Cin;
    copy.mode = this.mode;
    copy.inp_valid = this.inp_valid;
    copy.CMD = this.CMD;
  endfunction
endclass
  // using blueprint method to run testcases of a single operand type arithmetic operations.
  class arithmetic_transaction_single_op extends alu_transaction;
    constraint single_op_arith {CMD inside {4,5,6,7};}
    constraint arith_mode {mode == 1;}
    constraint inpvalidity {inp_valid == 2'b11;}

    virtual function alu_transaction copy();
      arithmetic_transaction_single_op copy0;
      copy0 = new();
      copy0.OPA = this.OPA;
      copy0.OPB = this.OPB;
      copy0.Cin = this.Cin;
      copy0.mode = this.mode;
      copy0.inp_valid = this.inp_valid;
      copy0.CMD = this.CMD;
      return copy0;
    endfunction
  endclass

  class arithmetic_transaction_two_op extends alu_transaction;
    constraint two_op_arith { CMD inside {[0:3], [8:10]};}
    constraint arith_mode {mode == 1;}
    constraint validity {inp_valid == 2'b11;}
    constraint dist_val {OPA dist {0 := 2, 255 := 2};}
    constraint dist_val_opb {OPB dist {0 := 2, 255 := 2};}
    //constraint excludeCMD {CMD !( inside {[9:10]});}
    function alu_transaction copy();
      arithmetic_transaction_two_op copy1;
      copy1 = new();
      copy1.OPA = this.OPA;
      copy1.OPB = this.OPB;
      copy1.Cin = this.Cin;
      copy1.mode = this.mode;
      copy1.inp_valid = this.inp_valid;
      copy1.CMD = this.CMD;
      return copy1;
    endfunction
  endclass

  class logical_transaction_single_op extends alu_transaction;
    constraint single_op_logic {CMD inside {[6:11]};}
    constraint logic_mode {mode == 0;}
    constraint inp_validity {inp_valid inside {3};}

    function alu_transaction copy();
      logical_transaction_single_op copy2;
      copy2 = new();
      copy2.OPA = this.OPA;
      copy2.OPB = this.OPB;
      copy2.Cin = this.Cin;
      copy2.mode = this.mode;
      copy2.inp_valid = this.inp_valid;
      copy2.CMD = this.CMD;
      return copy2;
    endfunction
  endclass

  class logical_transaction_two_op extends alu_transaction;
    constraint two_op_logic {CMD inside {[0:5],12,13};}
    constraint logic_mode {mode == 0;}
    constraint inpValidity {inp_valid inside {3};}
    function alu_transaction copy();
      logical_transaction_single_op copy3;
      copy3 = new();
      copy3.OPA = this.OPA;
      copy3.OPB = this.OPB;
      copy3.Cin = this.Cin;
      copy3.mode = this.mode;
      copy3.inp_valid = this.inp_valid;
      copy3.CMD = this.CMD;
      return copy3;
    endfunction
  endclass
