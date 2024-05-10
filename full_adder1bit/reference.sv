//referance model class for full_adder_1bit

class reference;
    //declare the transaction fields
    bit i_a;
    bit i_b;
    bit i_cin;
    bit o_carry;
    bit o_sum;
    transaction res;
function new();
    reset();
    this.res = new();
endfunction

function void reset();
    i_a = 0;
    i_b = 0;
    i_cin = 0;
    o_carry = 0;
    o_sum = 0;
endfunction

function transaction step(transaction trans);
    this.res = new();
    res.i_a = trans.i_a;
    res.i_b = trans.i_b;
    res.i_cin = trans.i_cin;

    //calculate the output
    res.o_sum = res.i_a + res.i_b + res.i_cin;
    // if($unsigned(res.i_a) + $unsigned(res.i_b) + $unsigned(res.i_cin))
    if(res.i_a && res.i_b ||  res.i_cin && res.i_a || res.i_cin && res.i_b)
        res.o_carry = 1;
    else
        res.o_carry = 0;
    return res;
endfunction


    function void display(string name);
        $display("-------------------------");
        $display("- %s ",name);
        $display("-------------------------");
        display_in("port in");
        display_out("port out");
        $display("-------------------------");
    endfunction

    function void display_in(string name);
        $display(name);
        $display("i_a = %b",i_a);
        $display("i_b = %b",i_b);
        $display("i_cin = %b",i_cin);
        endfunction

    function void display_out(string name);
        $display(name);
        $display("o_carry = %b",o_carry);
        $display("o_sum = %b",o_sum);  
    endfunction

 endclass

