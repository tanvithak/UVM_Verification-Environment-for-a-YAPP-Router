class yapp_tx_driver extends uvm_driver #(yapp_packet);
  int num_sent;
  virtual interface yapp_if vif;

  `uvm_component_utils_begin(yapp_tx_driver)
    `uvm_field_int(num_sent, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name="yapp_tx_driver", uvm_component parent);
    super.new(name,parent);
  endfunction

    
  function void connect_phase(uvm_phase phase);
    if (!yapp_vif_config::get(this,"","vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH) 
  endfunction


  task run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask


task get_and_drive();
    @(posedge vif.reset);
    @(negedge vif.reset);
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
    forever begin
      // Get new item from the sequencer
      seq_item_port.get_next_item(req);

      `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_HIGH)
       
      fork
        // send packet
        begin
        foreach (req.payload[i])
          vif.payload_mem[i] = req.payload[i];
        vif.send_to_dut(req.length, req.addr, req.parity, req.packet_delay);
        end
        // trigger transaction at start of packet (trigger signal from interface)
        @(posedge vif.drvstart) void'(begin_tr(req, "Driver_YAPP_Packet"));
      join

      // End transaction recording
      end_tr(req);
      num_sent++;
      // Communicate item done to the sequencer
      seq_item_port.item_done();
    end
  endtask


  task reset_signals();
    forever 
     vif.yapp_reset();
  endtask    


  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP TX driver sent %0d packets", num_sent), UVM_LOW)
  endfunction
endclass
