`include "defines.sv"

class alu_environment;
  virtual alu_intf.drv drv_vif;
  virtual alu_intf mon_vif;
  virtual alu_intf ref_vif;

  mailbox #(alu_transaction) mb_gd;// mailbox for generator to driver
  mailbox #(alu_transaction) mb_dr;// mailbox for driver to reference
  mailbox #(alu_transaction) mb_rs; //mailbox for reference to to scoreboard
  mailbox #(alu_transaction) mb_ms;// mailbox for mailbox to scoreboard
  //declaring all the handles of components

  alu_generator gen;
  alu_driver drv;
  alu_monitor mon;
  alu_reference_model ref_mod;
  alu_scoreboard sb;
  function new(
    virtual alu_intf drv_vif,
    virtual alu_intf mon_vif,
    virtual alu_intf ref_vif
  );

    this.drv_vif = drv_vif;
    this.mon_vif = mon_vif;
    this.ref_vif = ref_vif;

  endfunction

  task build();
    begin
      mb_gd = new();
      mb_dr = new();
      mb_rs = new();
      mb_ms = new();

      gen = new(mb_gd);
      drv = new(mb_gd,mb_dr,drv_vif);
      mon = new(mon_vif,mb_ms);
      ref_mod = new(mb_dr,mb_rs,ref_vif);
      sb = new(mb_rs,mb_ms);
    end
  endtask

  task start();
    fork
      gen.start();
      drv.start();
      mon.start();
      ref_mod.start();
    join
    sb.start();
  endtask

endclass
