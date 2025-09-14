class yapp_tx_driver extends uvm_driver #(yapp_packet);
  `uvm_component_utils(yapp_tx_driver)

  function new(string name="yapp_tx_driver", uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever
     begin
      seq_item_port.get_next_item();
      send_to_dut(req);
      seq_item_port.item_done();
     end
  endtask

  task send_to_dut(yapp_packet yp);
    `uvm_info(get_type_name(),$sformatf("Packet is \n %s",send_to_dut.sprint()),UVM_LOW)
    #10ns;
  endtask
endclass
