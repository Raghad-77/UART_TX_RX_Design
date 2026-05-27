module TX_FSM (
    input clk,rst,Data_Valid,PAR_EN,Ser_done,
    output reg [1:0]sel,
    output reg busy,Ser_en
);
    
reg busy_c;

localparam [2:0]IDLE = 3'b000,
                START= 3'b001,
                DATA= 3'b011,
                PARITY= 3'b010,
                STOP=3'b110;
                
reg [2:0] CS,NS; 


always @(posedge clk or negedge rst)
 begin
  if(!rst)
     CS <= IDLE ;
  else
     CS <= NS ;
 end

 
 always @(*)
 begin
    case(CS)  //moore
        IDLE:begin           
            if(Data_Valid)
                NS=START;
            else begin
                NS=IDLE;
            end     
        end
        START: begin
            NS=DATA;
        end
        DATA: begin
           if(Ser_done)
            begin
                if(PAR_EN)
                    NS=PARITY;
                else 
                    NS=STOP;
            end
           else 
                NS=DATA;
        end 
        PARITY:begin
            NS=STOP;
        end
        STOP: begin
            NS=IDLE;
        end
    default : NS = IDLE ;		 
    endcase 
 end

 always @(*)
 begin
    Ser_en= 0;
    sel = 2'b00;	
    busy_c=0;
    case(CS)
        IDLE:begin           
            Ser_en= 0;
            sel = 2'b11;	
            busy_c=0;
        end
        START: begin
            Ser_en= 0;
            sel = 2'b00 ;	
            busy_c=1;
        end
        DATA: begin
            Ser_en= 1;
            sel = 2'b01;	
            busy_c=1;
        end 
        PARITY:begin
            Ser_en= 0;
            sel = 2'b10 ;	
            busy_c=1;
        end
        STOP: begin
            Ser_en= 0;
            sel = 2'b11;	 //stop and idle same sel 
            busy_c=1;
        end
    default :  begin
            Ser_en= 0;
            sel = 2'b00;	
            busy_c=0;
    end 
    endcase 
 end

always @ (posedge clk or negedge rst)
    begin
    if(!rst)
        busy <= 0 ;
    else
        busy <= busy_c ;
end
endmodule