class yapp_env extends uvm_env;
  `uvm_component_utils(yapp_env)
  function new(string name="yapp_env",uvm_component parent);
    super.new(name,parent);
  endfunction

  yapp_tx_agent agt;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = yapp_tx_agent::type_id::create("agt",this);
  endfunction
endclass
