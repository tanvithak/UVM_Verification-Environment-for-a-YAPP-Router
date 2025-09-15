class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  router_tb rt1;

  function new(string name="base_test", uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(),$sformatf("base_test build phase executed"),UVM_HIGH)
    uvm_config_int::set( this, "*", "recording_detail", 1);
    rt1 = router_tb::type_id::create("rt1",this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  virtual function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction
endclass


class short_packet_test extends base_test;
  `uvm_component_utils(short_packet_test)
  function new(string new"short_packet_test",uvm_component parent);
    super.new(name);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    super.build_phase(phase)
  endfunction
endclass




class set_config_test extends base_test;
  `uvm_component_utils(set_config_test)

  function new(string name="set_config_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    `uvm_config_int::set(this,"rt1.env.agt","is_active",UVM_PASSIVE)
    super.build_phase(phase);
  endfunction
endclass
