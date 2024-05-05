// Example of SystemVerilog calling a C task, which calls SV tasks
// For Mastering Questa course, DPI chapter, Lab 2

module test();

  export "DPI-C" function sv_mem_allocate;  // No type or args
  export "DPI-C" task sv_mem_write;
  export "DPI-C" task sv_mem_read;
  export "DPI-C" function sv_time;

  import "DPI-C" context task c_testbench(input string fname);

  initial c_testbench("mem.dat");

  int mem[];

  function void sv_mem_allocate(input int size);
    $display("SV @%0d: In %m(%0d)", $time, size);
    mem = new[size];
  endfunction


  task sv_mem_write(input int addr, data);
    $display("SV @%0d: In %m(%0d, %0d)", $time, addr, data);
    #10 mem[addr] = data;
  endtask

  //LAB: Add a third argument, expect
  task sv_mem_read(input int addr, output int data, input int exp);
    #20 data = mem[addr];
    $display("SV @%0d: In %m(%0d, %0d)", $time, addr, data);

    //LAB: Move the read-check from the C code here in the testbench
    if (data != exp)
      $display("SV @%0d: Error: Data=%0d, expected=%0d\n", sv_time(), data, exp);
  endtask


  function int sv_time();
    return $time;
  endfunction

endmodule : test
