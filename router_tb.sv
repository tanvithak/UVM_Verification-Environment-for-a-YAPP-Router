class router_tb extends uvm_env;
  `uvm_component_utils(router_tb)
  function new(string name="router_tb", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  yapp_env env;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Testbench build phase executed"),UVM_HIGH)
    env = yapp_env::type_id::create("env",this);
  endfunction
endclass
