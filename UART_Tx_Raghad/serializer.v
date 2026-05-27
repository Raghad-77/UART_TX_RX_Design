module serializer#(parameter WIDTH = 8)(
    input clk,rst,
    input [WIDTH-1:0]P_DATA,
    input ser_en,Busy,Data_Valid,
    output wire ser_done,
    output wire ser_data
);

reg  [WIDTH-1:0] DATA;
reg  [2:0] counter ;
              
always @ (posedge clk or negedge rst)
 begin
  if(!rst)
    DATA <=0 ;
  else if(Data_Valid && !Busy)
    DATA <= P_DATA ;
  else if(ser_en)
    DATA <= DATA >> 1 ;  // shift register
 end

 always @ (posedge clk or negedge rst)
 begin
  if(!rst)
        counter <=0 ;
  else
    begin
        if (ser_en)
            counter <=counter +1 ;		 
        else 
            counter <=0 ;		 	
    end
 end 

assign ser_done = (counter == 3'b111)?1:0;
assign ser_data = DATA[0];

endmodule


//////////////this module was not working i failed to know why :( //////////////////////////////
/*module serializer#(parameter WIDTH = 8)(
input clk,rst, 
input [WIDTH-1:0]P_DATA, 
input ser_en, Busy,Data_Valid,
output reg ser_done,
output reg ser_data ); 

reg [2:0]counter; 
reg [WIDTH-1:0] shift_reg; 

always @ (posedge clk or negedge rst)
begin
  if(!rst)
    shift_reg <=0 ;
  else if(Data_Valid && !Busy)
    shift_reg <= P_DATA ;
  else if(ser_en)
    shift_reg <= shift_reg >> 1 ;  // shift register
end

always @(posedge clk or negedge rst) begin 
    if (!rst) 
    begin 
        shift_reg <= 0; 
        counter <= 0; 
        ser_data <= 0; 
        ser_done <= 0; 
    end 
    else if (ser_en) 
    begin 
        ser_data <= shift_reg[0]; // output LSB 
        if (counter == WIDTH-1) 
        begin 
            ser_done <= 1; 
            counter <= 0; 
        end 
        else 
            counter <= counter + 1; 
    end 
    else 
    begin 
        ser_done <= 0; 
        counter <= 0;
    end
end
endmodule*/