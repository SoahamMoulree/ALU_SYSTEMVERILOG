`include "interface.sv"
`include "alu_pkg.sv"
`include "alu.v"


module top;
  import alu_pkg ::*; //importing alu package to include all components of test

  bit clk;
  bit RST;
  bit CE;
  alu_intf intrf(clk,RST,CE);
  ALU_DESIGN  DUT(   .CLK(clk),
                     .RST(RST),
                     .CE(CE),
                     .INP_VALID(intrf.inp_valid),
                     .MODE(intrf.mode),
                     .CMD(intrf.CMD),
                     .CIN(intrf.Cin),
                     .ERR(intrf.ERR),
                     .RES(intrf.RES),
                     .OPA(intrf.OPA),
                     .OPB(intrf.OPB),
                     .OFLOW(intrf.OFLOW),
                     .COUT(intrf.COUT),
                     .G(intrf.G),
                     .L(intrf.L),
                     .E(intrf.E));

  alu_test tb = new(intrf.drv,intrf.monitor,intrf.ref_mod);
  test_single_op_arith tb1 = new(intrf.drv,intrf.monitor,intrf.ref_mod);
  test_two_op_arith tb2 = new(intrf.drv,intrf.monitor,intrf.ref_mod);
  test_single_op_logic tb3 = new(intrf.drv,intrf.monitor,intrf.ref_mod);
  test_two_op_logic tb4 = new(intrf.drv,intrf.monitor,intrf.ref_mod);
  regression_test tbR = new(intrf.drv,intrf.monitor,intrf.ref_mod);

  initial begin
    //tb  = new(intrf.drv,intrf.monitor,intrf.ref_mod);
    CE = 1;
    RST = 1;
    #10;
    RST = 0;
    //clk = 1;
  end

  always #5 clk = ~clk;

  initial begin
    //tb.run();
    //tb1.run();
    //tb2.run();
    //tb3.run();
    //tb4.run();
    tbR.run();

    #10;
    $finish;

  end

endmodule
