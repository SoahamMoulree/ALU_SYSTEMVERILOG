`include "defines.sv"

class alu_test;
  virtual alu_intf drv_vif;
  virtual alu_intf mon_vif;
  virtual alu_intf ref_vif;

  alu_environment env;

  function new(
    virtual alu_intf drv_vif,
    virtual alu_intf mon_vif,
    virtual alu_intf ref_vif
  );

    this.drv_vif = drv_vif;
    this.mon_vif = mon_vif;
    this.ref_vif = ref_vif;

  endfunction

  task run();
    env = new(drv_vif, mon_vif, ref_vif);
    env.build();
    env.start();
  endtask

endclass

class test_single_op_arith extends alu_test;

  arithmetic_transaction_single_op trans1;

  function new(virtual alu_intf drv_vif,virtual alu_intf mon_vif, virtual alu_intf ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    env = new(drv_vif,mon_vif,ref_vif);
    env.build;
    begin
      trans1 = new();
      env.gen.blueprint = trans1;
    end
    env.start();
  endtask
endclass

class test_two_op_arith extends alu_test;
  arithmetic_transaction_two_op trans2;

  function new(virtual alu_intf drv_vif,virtual alu_intf mon_vif, virtual alu_intf ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
     env = new(drv_vif,mon_vif,ref_vif);
     env.build;
     begin
      trans2 = new();
      env.gen.blueprint = trans2;
     end
     env.start();
  endtask
endclass

class test_single_op_logic extends alu_test;
  logical_transaction_single_op trans3;

  function new(virtual alu_intf drv_vif,virtual alu_intf mon_vif, virtual alu_intf ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
     env = new(drv_vif,mon_vif,ref_vif);
     env.build;
     begin
      trans3 = new();
      env.gen.blueprint = trans3;
     end
     env.start();
  endtask
endclass

class test_two_op_logic extends alu_test;
  logical_transaction_two_op trans4;

  function new(virtual alu_intf drv_vif,virtual alu_intf mon_vif, virtual alu_intf ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
     env = new(drv_vif,mon_vif,ref_vif);
     env.build;
     begin
      trans4 = new();
      env.gen.blueprint = trans4;
     end
     env.start();
  endtask
endclass



class regression_test extends alu_test;

  alu_transaction trans0;
  arithmetic_transaction_single_op trans1;
  arithmetic_transaction_two_op trans2;
  logical_transaction_single_op trans3;
  logical_transaction_two_op trans4;

  function new(virtual alu_intf drv_vif,virtual alu_intf mon_vif, virtual alu_intf ref_vif);
     super.new(drv_vif,mon_vif,ref_vif);
  endfunction

  task run();
    env = new(drv_vif,mon_vif,ref_vif);
    env.build;

    trans0 = new();
    env.gen.blueprint = trans0;
    env.start;

    trans1 = new();
    env.gen.blueprint = trans1;
    env.start;

    trans2 = new();
    env.gen.blueprint = trans2;
    env.start;

    trans3 = new();
    env.gen.blueprint = trans3;
    env.start;

    trans4 = new();
    env.gen.blueprint = trans4;
    env.start;

  endtask

endclass
