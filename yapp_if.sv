interface yapp_if(input clock, input reset);

  import uvm_pkg::*;
  `include "macros.svh"
  import yapp_pkg::*;

  
  logic [7:0] in_data;
  logic in_data_vld;
  logic in_suspend;
  
  task yapp_reset();
    @(posedge reset);
    in_data <= 'hz;
    in_data_vld <= 1'b0;
    disable send_to_dut;
  endtask



  
  task send_to_dut(input bit [5:0]  length,
                         bit [1:0]  addr,
                         bit [7:0]  parity,
                         int packet_delay);
    repeat(packet_delay)
      @(negedge clock);

    @(negedge clock iff (!in_suspend));
    drvstart = 1'b1;

    in_data_vld <= 1'b1;
    in_data <= { length, addr };

    for(int i=0;i<length;i=i+1)
      begin
        @(negedge clock iff (!in_suspend))
        in_data <= payload_mem[i];
      end

    @(negedge clock iff (!in_suspend))
    in_data_vld <= 1'b0;
    in_data <= parity;

    @(negedge clock)
    in_data <= 8'bz;

    drvstart = 1'b0;
  endtask



  

  task collect_packets(output bit [5:0]  length,
                         bit [1:0]  addr,
                         bit [7:0]  payload[],
                         bit [7:0]  parity);
    
    @(posedge clock iff (!in_suspend & in_data_vld))
    monstart = 1'b1;
    `uvm_info("YAPP_IF", "collect packets", UVM_HIGH)
    { length, addr }  = in_data;
    payload = new[length];
    foreach (payload [i]) 
      begin
        @(posedge clock iff (!in_suspend))
        payload[i] = in_data;
      end

    @(posedge clock iff !in_suspend)
    parity = in_data;
    monstart = 1'b0;
  endtask
  
endinterface
