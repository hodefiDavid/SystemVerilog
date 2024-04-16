localparam

    START = 2'd0,
    CREATE=2'd2, 
    PUBLISH =2'd3;
    REVIEW = 2'd1,

reg [1:0] state;
reg status, edit_mode;

always @(posedge clock)
    if(reset)
        state <= START;
    else
        case (state )
        
        START : state <= edit ? CREATE : REVIEW;
        REVIEW : begin
        {status,edit_mode } <= {1'b0,1'b0};
        if (!edit ) state <= PUBLISH;
        end
        CREATE: begin
        {status,edit_mode} <= {1'b0,1'b1};
        if (edit) state <= PUBLISH;
        end
        PUBLISH : {state,status} <= {START, 1'b1};
endcase


// similar method :

START = 2'd0,
CREATE= 2'd2,

REVIEW = 2'd1,
PUBLISH =2'd3;

localparam

reg [1:0] state, nstate;
reg status, edit_mode ;

always @*
case (state )
START : nstate = edit ? CREATE: REVIEW;
REVIEW : nstate = !edit ? PUBLISH : REVIEW;
CREATE : nstate = edit ? PUBLISH : CREATE;
PUBLISH : nstate = START;
endcase

always @(posedge clock)
if (reset)
state <= START;
else begin

state <= nstate;

case (nstate )
REVIEW :{edit_mode ,status} <= 2'b00;
CREATE :{edit_mode ,status} <= 2'b10;
PUBLISH : status <= 1'b1;
endcase

end