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
    this.res.a = trans.a;
    this.res.b = trans.b;
    this.res.select = trans.select;

    //the function of the ALU
    //  select = 0 -> a + b;
    //  select = 1 -> a - b;
    //  select = 2 -> a * b;
    //  select = 3 -> a / b;

    case ( this.res.select)
        0 : begin
            {this.res.carry,this.res.out} = this.res.a + this.res.b;
        end
        1 : begin
            {this.res.carry,this.res.out} =this.res.a - this.res.b;
        end
        2 : begin
            {this.res.carry,this.res.out} = this.res.a * this.res.b;
        end
        3 : begin
            {this.res.carry,this.res.out} = this.res.a / this.res.b;
        end
        default : begin
            this.res.out = 0;
            this.res.carry = 0;
        end
        
    endcase

        this.res.zero =  ~|this.res.out;
        this.res.sign     =  this.res.out[3];
        this.res.parity   =  ~^this.res.out;
        this.res.overflow =  (this.res.a[3] & this.res.b[3] & ~this.res.out[3]) | (~this.res.a[3] & ~this.res.b[3] & this.res.out[3]);
    return  this.res;
endfunction

 endclass

