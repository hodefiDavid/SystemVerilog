module log_example;
    integer input_chan, error_chan;
    reg [7:0] signal1, signal2;

    initial begin
        input_chan=$fopen("input_log.txt");
        if (!input_chan) begin
            $display("Error: Failed to open input_log.txt");
            $finish;
        end
        $display("input_chan: %d", input_chan);

        error_chan = $fopen("error_log.txt");
        if (!error_chan) begin
            $display("Error: Failed to open error_log.txt");
            $finish;
        end
        $display("error_chan: %d", error_chan);

        $fmonitor(error_chan, "Error observed at %t: signal1 = %h, signal2 = %h", $time, signal1, signal2);
        // Simulate some operations that may log to error file ...
        $monitoroff;
        $fclose(input_chan);
        $fclose(error_chan);
    end
endmodule

// Open a file for logging input signals

// Open a different file for logging errors

// Close the file before finishing simulation