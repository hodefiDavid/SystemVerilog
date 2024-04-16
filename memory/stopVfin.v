
task check (input [7:0] resp, exp);

    if (resp !== exp) begin

        $display("want %b - got %b", exp, resp);
        $display("TEST FAILED");

        $stop;

    end

    endtask

    initial begin

        wait (empty);

        $display("Data buffer empty");
        $display("TEST COMPLETE");

        $finish;

end