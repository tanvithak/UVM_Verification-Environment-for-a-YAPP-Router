class yapp_tx_monitor extends uvm_monitor;
  `uvm_component_utils(yapp_tx_monitor)

  function new(string name="yapp_tx_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(),$sformatf("In monitor's run_phase"),UVM_LOW)
  endtask
endclass
