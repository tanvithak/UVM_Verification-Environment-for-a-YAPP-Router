class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets




class yapp_1_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_1_seq)
  function new(string name="yapp_1_seq");
    super.new(name);
  endfunction

  constraint addr1{addr==1;}

  virtual task body();
    `uvm_info(get_type_name(),$sformatf("This is "yapp_1_seq" sequence"),UVM_LOW)
    `uvm_do(req)
  endtask
endclass



class yapp_012_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_012_seq)
  function new(string name="yapp_012_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(),$sformatf("This is "yapp_012_seq" sequence"),UVM_LOW)
    `uvm_do_with(req,{reg.addr==2'b00;})
    `uvm_do_with(req,{reg.addr==2'b01;})
    `uvm_do_with(req,{reg.addr==2'b10;})
  endtask
endclass



class yapp_111_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_111_seq)
  function new(string name="yapp_111_seq");
    super.new(name);
  endfunction

  yapp_1_seq seqq1;
  virtual task body();
    `uvm_info(get_type_name(),$sformatf("This is "yapp_111_seq" sequence"),UVM_LOW)
    repeat(3)
      `uvm_do(seqq1)
  endtask
endclass



class yapp_repeat_addr_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_repeat_addr_seq)
  function new(string name="yapp_repeat_addr_seq");
    super.new(name);
  endfunction

  rand bit [1:0] seq_addr;
  constraint tan{seq_addr!=2'b11;}
  
  virtual task body();
    `uvm_info(get_type_name(),$sformatf("This is "yapp_repeat_addr_seq" sequence"),UVM_LOW)
    repeat(2)
      `uvm_do_with(req,{req.addr==seq.addr;})
  endtask
endclass





class yapp_incr_payload_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_incr_payload_seq)
  function new(string name="yapp_incr_payload_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(),$sformatf("This is "yapp_incr_payload_seq" sequence"),UVM_LOW)
    `uvm_create(req)
    req.randomize();
    foreach(req.payload[i])
      req.payload[i]=i;
    req.set_parity();
    `uvm_send(req)
  endtask
endclass




    

class yapp_rnd_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_rnd_seq)
  rand int count;

  constraint c_count{count inside {[1:10]};}
  function new(string name="yapp_rnd_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(),$sformatf("This is "yapp_rnd_seq" sequence of count = %d",count),UVM_LOW)
    repeat(count)
      `uvm_do(req)
  endtask

endclass



    


class six_yapp_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_rnd_seq)
  function new(string name="six_yapp_seq");
    super.new(name);
  endfunction

  yapp_rnd_seq yrs1;

  virtual task body();
    `uvm_info(get_type_name(),$sformatf("This is "six_yapp_seq" sequence"),UVM_LOW)
    `uvm_do_with(ysr1,{ysr1.count==6;})
  endtask

endclass




    

class yapp_exhaustive_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_exhaustive_seq)
  function new(string name="yapp_exhaustive_seq");
    super.new(name);
  endfunction

  yapp_1_seq y1;
  yapp_012_seq y_012;
  yapp_111_seq y_111;
  yapp_repeat_addr_seq y_repeat_addr;
  yapp_incr_payload_seq y_incr_payload;
  yapp_rnd_seq y_yapp_rnd;
  six_yapp_seq y_six_yapp;
  virtual task body();
    `uvm_info(get_type_name(),$sformatf("This is "yapp_exhaustive_seq" sequence"),UVM_LOW)
    `uvm_do(y1)
    `uvm_do(y_012)
    `uvm_do(y_111)
    `uvm_do(y_repeat_addr)
    `uvm_do(y_incr_payload)
    `uvm_do(y_yapp_rnd)
    `uvm_do(y_six_yapp)
  endtask
endclass
