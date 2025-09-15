typedef enum bit {GOOD_PARITY,BAD_PARITY}parity_t;
class yapp_packet extends uvm_sequence_item;
  rand bit [1:0] addr;
  rand bit [7:0]  payload [];
  rand bit [5:0] length;
  bit [7:0] parity;
  rand parity_t parity_type;
  rand int packet_delay;//This will be used to insert clock cycle delays when transmitting a packet

  // UVM macros for built-in automation - These declarations enable automation of the data_item fields 
  `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int(length,       UVM_ALL_ON)
    `uvm_field_int(addr,         UVM_ALL_ON)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_int(parity,      UVM_ALL_ON)
    `uvm_field_enum(parity_t, parity_type, UVM_ALL_ON)
    `uvm_field_int(packet_delay, UVM_ALL_ON | UVM_DEC | UVM_NOCOMPARE)
  `uvm_object_utils_end

  //A constraint for valid address.
  constraint valid_addr{addr!=3;}
  
  //A constraint for packet length and constrain payload size to be equal to length.
  constraint pkt_len{payload.size==length;}
  constraint length_c{length inside {[0:64]};}

  //A constraint for parity_type with a distribution of 5:1 in favor of good parity
  constraint parity_type_c{parity_type dist {GOOD_PARITY:=5, BAD_PARITY:=1};}

  //A Constraint packet_delay to be inside the range 1 to 20
  constraint pkt_delay{packet_delay inside {[1:20]};}
  
  function new(string name="yapp_packet");
    super.new(name);
  endfunction

  function bit [7:0] calc_parity();
    //to calculate and return correct packet parity:
    calc_parity = {length,addr};
    for(int i=0;i<payload.size();i=i+1)
      begin
        calc_parity = calc_parity ^ payload[i];
      end
    return calc_parity;
  endfunction

  function void set_parity();
    //to assign the parity property:
    //If parity_type has the value GOOD_PARITY, assign parity using the calc_parity() method. Otherwise assign an incorrect parity value.
    if(parity_type == GOOD_PARITY)
      parity = calc_parity();
    else
      parity++;
  endfunction

  function void post_randomize();
    set_parity();
  endfunction

endclass

class short_yapp_packet extends yapp_packet;
  `uvm_object_utils(short_yapp_packet)

  function new(string name="short_yapp_packet");
    super.new(name);
  endfunction
  //Add a constraint in short_yapp_packet to limit packet length to less than 15.
  constraint pl{length < 15;}
  //Add a constraint in short_yapp_packet to exclude an address value of 2.
  constraint c2{addr!=2'b10;}
endclass
