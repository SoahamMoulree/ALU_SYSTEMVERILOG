`include "defines.sv"

class alu_reference_model;
  //mailbox for driver and reference
  mailbox #(alu_transaction) mb_dr;
  //mailbox for reference model and scoreboard
  mailbox #(alu_transaction) mb_rs;
  alu_transaction ref_trans;
  //virtual interface to
  virtual alu_intf.ref_mod ref_vif;

  //connecting this class to environment
  function new(mailbox #(alu_transaction) mb_dr, mailbox #(alu_transaction) mb_rs, virtual alu_intf.ref_mod ref_vif);
    this.mb_dr = mb_dr;
    this.mb_rs = mb_rs;
    this.ref_vif = ref_vif;
  endfunction

  //creating a task the mimics the functionality of the ALU.
  task start();

    int single_op_logical[] = {6,7,8,9,10,11};
    int single_op_arithmetic[] = {4,5,6,7};
    int count =  0;
    int err_count = 1;

    repeat(3)@(ref_vif.ref_cb);

    for(int i = 0; i < `no_of_testcases; i++) begin : mainfor
      ref_trans = new();
      //repeat(1)@(ref_vif.ref_cb);
      mb_dr.get(ref_trans); // get transactions from the driver
     /*if(mode ==1 && cmd inside {double_op} && inp_valid ==3  || inp_valid == (1 or 2) && cmd inside {single op (logical or arithmetc))
       repeat(3)@()*/

      if(ref_trans.inp_valid == 2'b11 || ref_trans.inp_valid == 2'b00) begin : if_direct_op
        if((ref_trans.CMD == 9 || ref_trans.CMD == 10) && ref_trans.mode == 1) begin : if1
          repeat(1)@(ref_vif.ref_cb);
          alu_operation();
          $display("");
          $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.mode,ref_trans.inp_valid,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.Cin);
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          $display("");

        end : if1

        else begin :e1
          repeat(1)@(ref_vif.ref_cb);
          alu_operation();
          $display("");
          $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.mode,ref_trans.inp_valid,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.Cin);
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          $display("");
        end : e1
      end : if_direct_op

      else begin : else_single_op
        if(ref_trans.mode == 0 && ref_trans.CMD inside {single_op_logical}) begin : if1
          repeat(1)@(ref_vif.ref_cb);
          alu_operation();
          $display("");
          $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.mode,ref_trans.inp_valid,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.Cin);
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          $display("");
        end : if1
        else if(ref_trans.mode == 1 && ref_trans.CMD inside{single_op_arithmetic}) begin : ef1

          repeat(1)@(ref_vif.ref_cb);
          alu_operation();
          $display("");
          $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.mode,ref_trans.inp_valid,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.Cin);
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          $display("");
        end : ef1

        else begin : e1

          for(count = 0; count < 16; count++) begin : forloop
            repeat(1)@(ref_vif.ref_cb);
            mb_dr.get(ref_trans);
            //$display(" [%0d] |[%0t] REFERENCE | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",count,$time,ref_trans.mode,ref_trans.inp_valid,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.Cin);

            if(ref_trans.inp_valid == 2'b11) begin : ifnest
              ref_trans.ERR = 0;
              if((ref_trans.CMD == 9 || ref_trans.CMD == 10) && ref_trans.mode == 1) begin : in2
                repeat(2)@(ref_vif.ref_cb);
                alu_operation();
                $display("");
                $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.mode,ref_trans.inp_valid,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.Cin);
                $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
                $display("");
              end : in2

              alu_operation();


              break;

            end : ifnest
            //alu_operation();
          end : forloop
          $display("COUNT = %0d",count);
          repeat(1)@(ref_vif.ref_cb);
          if(count == 16) begin : err_if
            ref_trans.ERR = 1;
            ref_trans.RES = {9{1'bz}};
            ref_trans.OFLOW = 1'bz;
            ref_trans.COUT = 1'bz;
            ref_trans.G = 1'bz;
            ref_trans.L = 1'bz;
            ref_trans.E = 1'bz;

            $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          end : err_if
          $display("");
           $display(" Ref [%0t] | MODE = %0b | INP_VALID = %2b | CMD = %4b | OPA = %3d | OPB = %3d | CIN = %0d ",$time,ref_trans.mode,ref_trans.inp_valid,ref_trans.CMD, ref_trans.OPA,ref_trans.OPB,ref_trans.Cin);
          $display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
          $display("");

        end : e1
      end : else_single_op
      //$display("[%0t] | REF_MODEL | RES = %0d | OFLOW = %0b | COUT = %0b | G = %0b | L = %0b | E = %0b | ERR = %0b | ",$time,ref_trans.RES,ref_trans.OFLOW,ref_trans.COUT,ref_trans.G,ref_trans.L,ref_trans.E,ref_trans.ERR);
      mb_rs.put(ref_trans);
      //if(ref_trans.inp_valid == 2'b11)
        //repeat(1)@(ref_vif.ref_cb);
    end
endtask

  task alu_operation();
    if(ref_vif.ref_cb.RST) begin : reset

           ref_trans.RES = {9{1'bz}};
           ref_trans.OFLOW = 1'bz;
           ref_trans.COUT = 1'bz;
           ref_trans.G = 1'bz;
           ref_trans.L = 1'bz;
           ref_trans.E = 1'bz;
           ref_trans.ERR = 1'bz;
    end : reset

    else if(ref_vif.ref_cb.CE) begin

          //assigning default values
          ref_trans.RES = {9{1'bz}};
          ref_trans.OFLOW = 1'bz;
          ref_trans.COUT = 1'bz;
          ref_trans.G = 1'bz;
          ref_trans.L = 1'bz;
          ref_trans.E = 1'bz;
          ref_trans.ERR = 1'bz;

          if(ref_trans.mode == 1) begin

            //if(ref_trans.CMD inside {})
              case(ref_trans.inp_valid)
                2'b00 : begin
                  ref_trans.RES = 0;
                  ref_trans.ERR = 1;
                end
                2'b01 : begin
                  case(ref_trans.CMD)
                    4'b0100 : begin
                      ref_trans.RES = ref_trans.OPA + 1;
                      ref_trans.COUT = ref_trans.RES[`W];
                    end
                    4'b0101 : begin
                      ref_trans.RES = ref_trans.OPA - 1;
                      ref_trans.OFLOW = ref_trans.RES[`W];
                    end
                    default : begin
                      ref_trans.RES = 0;
                      ref_trans.ERR = 1;
                    end
                  endcase
                end
                2'b10 : begin
                  case(ref_trans.CMD)
                    4'b0110 : begin
                      ref_trans.RES = ref_trans.OPB + 1;
                      ref_trans.COUT = ref_trans.RES[`W];
                    end
                    4'b0111 : begin
                      ref_trans.RES = ref_trans.OPB - 1;
                      ref_trans.OFLOW = ref_trans.RES[`W];
                    end
                    default : begin
                      ref_trans.RES = 0;
                      ref_trans.ERR = 1;
                    end
                  endcase
                end
                2'b11 : begin
                  case(ref_trans.CMD)
                    4'b0000 : begin //ADD
                      ref_trans.RES = ref_trans.OPA + ref_trans.OPB;
                      ref_trans.COUT = ref_trans.RES[`W];
                    end
                    4'b0001 : begin //SUB
                      ref_trans.RES = ref_trans.OPA - ref_trans.OPB;
                      ref_trans.OFLOW = ref_trans.RES[`W];
                    end
                    4'b0010 : begin //ADD_CIN
                      ref_trans.RES = ref_trans.OPA + ref_trans.OPB + ref_trans.Cin;
                      ref_trans.COUT = ref_trans.RES[`W];
                    end
                    4'b0011 : begin //SUB_CIN
                      ref_trans.RES = ref_trans.OPA - ref_trans.OPB - ref_trans.Cin;
                      ref_trans.OFLOW = ref_trans.RES[`W];
                    end
                    4'b1000 : begin //CMP
                      if(ref_trans.OPA > ref_trans.OPB)
                        ref_trans.G = 1;
                      else if(ref_trans.OPA < ref_trans.OPB)
                        ref_trans.L = 1;
                      else
                        ref_trans.E = 1;
                    end
                    4'b1001 : begin //MULT and INCR
                      ref_trans.RES = (ref_trans.OPA + 1) * (ref_trans.OPB + 1);
                    end
                    4'b1010 : begin // OPA shift left by 1 and MULT with OPB
                      ref_trans.RES = (ref_trans.OPA << 1) * (ref_trans.OPB);
                    end

                    4'b0100 : begin
                      ref_trans.RES = ref_trans.OPA + 1;
                      ref_trans.COUT = ref_trans.RES[`W];
                    end
                    4'b0101 : begin
                      ref_trans.RES = ref_trans.OPA - 1;
                      ref_trans.OFLOW = ref_trans.RES[`W];
                    end
                   4'b0110 : begin
                      ref_trans.RES = ref_trans.OPB + 1;
                      ref_trans.COUT = ref_trans.RES[`W];
                    end
                    4'b0111 : begin
                      ref_trans.RES = ref_trans.OPB - 1;
                      ref_trans.OFLOW = ref_trans.RES[`W];
                    end


                    default : begin
                      ref_trans.RES = 0;
                      ref_trans.ERR = 1;
                    end
                  endcase
                end
                default : begin
                  ref_trans.RES = 0;
                  ref_trans.ERR = 1;
                end
              endcase
          end

          else begin : mode0 // for mode = 0
            case(ref_trans.inp_valid)
              2'b00 : begin : inv_op
                ref_trans.RES = 0;
                ref_trans.ERR = 1;
              end : inv_op
              2'b01 : begin : opa_valid
                case(ref_trans.CMD)
                  4'b0110 : begin : not_a
                    ref_trans.RES = ~(ref_trans.OPA);
                    ref_trans.RES[`W] = 0;
                  end : not_a
                  4'b1000 : begin : SHRA1
                    ref_trans.RES = (ref_trans.OPA >> 1);
                  end : SHRA1
                  4'b1001 : begin : SHLA1
                    ref_trans.RES = (ref_trans.OPA << 1);
                  end : SHLA1
                  default : begin : def_opa
                    ref_trans.RES = 0;
                    ref_trans.ERR = 1;
                  end : def_opa
                endcase
              end : opa_valid
              2'b10 : begin : opb_valid
                case(ref_trans.CMD)
                  4'b0111 : begin : not_b
                    ref_trans.RES = ~(ref_trans.OPB);
                    ref_trans.RES[`W] = 0;
                  end : not_b
                  4'b1010 : begin : SHRB1
                    ref_trans.RES = (ref_trans.OPB >> 1);
                  end : SHRB1
                  4'b1011 : begin : SHLB1
                    ref_trans.RES = (ref_trans.OPB << 1);
                  end : SHLB1
                  default : begin : def_opb
                    ref_trans.RES = 0;
                    ref_trans.ERR = 1;
                  end : def_opb
                endcase
              end : opb_valid
              2'b11 : begin : opa_opb_valid
                case(ref_trans.CMD)
                  4'b0000 : begin : and_inp
                    ref_trans.RES = ref_trans.OPA & ref_trans.OPB;
                    ref_trans.RES[`W] = 0;
                  end : and_inp
                  4'b0001 : begin : nand_inp
                    ref_trans.RES = ~(ref_trans.OPA & ref_trans.OPB);
                    ref_trans.RES[`W] = 0;
                  end : nand_inp
                  4'b0010 : begin : or_inp
                    ref_trans.RES = (ref_trans.OPA | ref_trans.OPB);
                    ref_trans.RES[`W] = 0;
                  end : or_inp
                  4'b0011 : begin : nor_inp
                    ref_trans.RES = ~(ref_trans.OPA | ref_trans.OPB);
                    ref_trans.RES[`W] = 0;
                  end : nor_inp
                  4'b0100 : begin : xor_inp
                    ref_trans.RES = (ref_trans.OPA ^ ref_trans.OPB);
                    ref_trans.RES[`W] = 0;
                  end : xor_inp
                  4'b0101 : begin : xnor_inp
                    ref_trans.RES = ~(ref_trans.OPA ^ ref_trans.OPB);
                    ref_trans.RES[`W] = 0;
                  end : xnor_inp
                  4'b1100 : begin : rol_a_b
                    if(| (ref_trans.OPB[`W-1 : `SHIFT_WIDTH + 1])) begin
                      ref_trans.ERR = 1;
                      ref_trans.RES = 0;
                    end
                    else
                      ref_trans.RES = (ref_trans.OPA << ref_trans.OPB[`SHIFT_WIDTH - 1:0]) | (ref_trans.OPA >> (`W - ref_trans.OPB[`SHIFT_WIDTH - 1: 0]));
                      // later can make res msb as 0
                  end : rol_a_b
                  4'b1101 : begin : ror_a_b
                    if(| (ref_trans.OPB[`W-1 : `SHIFT_WIDTH + 1])) begin
                      ref_trans.ERR = 1;
                      ref_trans.RES = 0;
                      end
                    else
                      ref_trans.RES = (ref_trans.OPA >> ref_trans.OPB[`SHIFT_WIDTH - 1:0]) | (ref_trans.OPA << (`W - ref_trans.OPB[`SHIFT_WIDTH - 1: 0]));
                      //later make res msb to 0;

                  end : ror_a_b

                  4'b0111 : begin : not_b
                    ref_trans.RES = ~(ref_trans.OPB);
                    ref_trans.RES[`W] = 0;
                  end : not_b
                  4'b1010 : begin : SHRB1
                    ref_trans.RES = (ref_trans.OPB >> 1);
                    ref_trans.RES[`W] = 0;
                  end : SHRB1
                  4'b1011 : begin : SHLB1
                    ref_trans.RES = (ref_trans.OPB << 1);
                    ref_trans.RES[`W] = 0;
                  end : SHLB1

                  4'b0110 : begin : not_a
                    ref_trans.RES = ~(ref_trans.OPA);
                    ref_trans.RES[`W] = 0;
                  end : not_a
                  4'b1000 : begin : SHRA1
                    ref_trans.RES = (ref_trans.OPA >> 1);
                    ref_trans.RES[`W] = 0;
                  end : SHRA1
                  4'b1001 : begin : SHLA1
                    ref_trans.RES = (ref_trans.OPA << 1);
                    ref_trans.RES[`W] = 0;
                  end : SHLA1

                  default : begin : def_op
                    ref_trans.RES = 0;
                    ref_trans.ERR = 1;
                  end : def_op
                endcase
              end : opa_opb_valid
              default : begin   : inpval_def
                ref_trans.RES = 0;
                ref_trans.ERR = 1;
              end : inpval_def
            endcase
          end : mode0

        end

    //end

  endtask

endclass
