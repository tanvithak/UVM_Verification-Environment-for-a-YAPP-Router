class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  router_tb rt1;

  function nee(string name="base_test", uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rt1 = router_tb::type_id::create("rt1",this);
    `uvm_info("MSG","base_test build phase executed",UVM_HIGH)
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass
