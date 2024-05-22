//referance model class for alu

class reference;
transaction res;
function new();
    reset();
    this.res = new();
endfunction

function void reset();

endfunction

function transaction step(transaction trans);
   this.res = new();
   this.res.in0 = trans.in0;
   this.res.in1 = trans.in1;
    this.res.in2 = trans.in2;
    this.res.in3 = trans.in3;   
    this.res.select = trans.select;

    if(this.res.select == 2'b00 )  //mux0 
        this.res.out = this.res.in0;
    if(this.res.select == 2'b01 )  //mux1
        this.res.out = this.res.in1;
    else if(this.res.select == 2'b10 )  //mux2
        this.res.out = this.res.in2;
    if(this.res.select == 2'b11 )  //mux3
        this.res.out = this.res.in3;  
         return this.res;

endfunction

 endclass

