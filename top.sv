module top;
  import yapp_pkg::*;
 `include "router_tb.sv"
 `include "router_test_lib.sv"

  initial
    begin
      run_test();
    end
endmodule
