`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:45:30 06/02/2023 
// Design Name: 
// Module Name:    selectionStage 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module selectionStage(
	input clk,
	input clr,
   	input left, 
   	input right,
   	input up,
   	input down,
	input [7:0] sw,
   	input [34:0] rowValuesFlat,
   	output [2:0] columnOut,
   	output submitted,
	output [6:0] value
	);


	wire [6:0] rowValues [0:4];
	assign rowValues[0] = rowValuesFlat[6:0];
	assign rowValues[1] = rowValuesFlat[13:7];
	assign rowValues[2] = rowValuesFlat[20:14];
	assign rowValues[3] = rowValuesFlat[27:21];
	assign rowValues[4] = rowValuesFlat[34:28];

    reg submit = 0;
	 
	localparam NORMAL = 2'b00;
	localparam LEFT_TRANSITION = 2'b01;
	localparam RIGHT_TRANSITION = 2'b10;
	localparam ROW_TRANSITION = 2'b11;
	localparam WAIT = 3'b100;
	 
	reg [2:0] state = NORMAL;

    reg [2:0] column;
    reg [6:0] currentValue; 
	 
    assign submitted=submit;
    assign columnOut=column;  
    
	 
    wire [4:0] currentLetter;
    assign currentLetter = sw[4:0];  
    wire [6:0] last_time_letter;  
    assign last_time_letter = rowValues[column];  
    
 /*     
always @(posedge clr)  
begin  
  state <= WAIT;
  column <= 0;
	submit <= 0; 
  currentValue <= 7'b1111010;  
end  
*/  
   
	 
always @(posedge clk or posedge clr) //always gonna be grey here
begin   
  
	if (clr) 
	begin
		state <= WAIT;
		column <= 0;
		submit <= 0; 
        currentValue <= 7'b1111010;   
        //doneGame <= 0;
        //value <= 0;
	 end   
   
	 else 
	 begin  
   if(column == 0 && last_time_letter[4:0] == 5'b00001)  
   begin  
    currentValue <= 7'b1111010;  
   end  
   else  
   begin  
   currentValue <= last_time_letter;  
   end  
   
		if (state == NORMAL) 
		begin
		/*
			if(currentLetter >= 5'd25)
			begin
				currentValue[4:0] <= 0;
			end
			else
			begin
				currentValue[4:0] <= currentLetter;
			end
		
    		else */
    		currentValue <= currentValue | 7'b1100000;
    		if(right) 
    		begin
            	if(column!=4) 
            	begin
					currentValue <= last_time_letter & 7'b0011111;
					state <= RIGHT_TRANSITION;
				end  
        	end
		  	else if(left) 
			begin
        		if(column!=0) 
            	begin
					currentValue <= last_time_letter & 7'b0011111;
					state <= LEFT_TRANSITION;
        		end
    		end
    		else if(up)
    		begin
				//currentValue[4:0] <= sw[4:0];
				submit <= 1;
				currentValue <= {2'b00, sw[4:0]};
				//assign rowValues[column] = currentValue;
    			state <= WAIT;
    		end
		end 
		else if (state == LEFT_TRANSITION) 
		begin
			currentValue <= rowValues[column-1] | 7'b1100000;
			column <= column-1;
			state <= NORMAL;
		end 
		else if (state == RIGHT_TRANSITION) 
		begin
			currentValue<=rowValues[column+1] | 7'b1100000;
			column <= column+1;
			state <= NORMAL;
		end  
        else if (state == WAIT) begin 
			if (down) 
            begin 			
            	submit <= 0; // Problem here !! Not sure if should put this inside the if statement
                state <= NORMAL; 
            end

		end  
    //currentValue <= currentValue & 7'b0011111;
    end  
    
end 

assign columnOut=column;
assign value=currentValue;
assign submitted=submit;

endmodule