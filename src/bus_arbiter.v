/*BY LOMOT*/
`include "header/nettype.h.v"
`include "header/stddef.h.v"
	`define 	HIGH					1'b1
	`define		LOW						1'b0
	`define 	DISABLE					1'b0
	`define 	ENABLE					1'b1
	`define 	DISABLE_				1'b1
	`define 	ENABLE_					1'b0
	`define 	READ					1'b1
	`define 	WRITE					1'b0
	`define 	LSB						0
	`define 	BYTE_DATA_W				8
	`define 	BYTE_MSB				7
	`define 	ByteDataBus				7:0
	`define 	WORD_DATA_W				32
	`define 	WORD_MSB 				31
	`define 	WordDataBus				31:0
	`define 	WORD_ADDR_W 			30
	`define 	WORD_ADDR_MSB 			29
	`define 	WordAddrBus 			29:0
	`define 	BYTE_OFFSET_W 			2
	`define 	ByteOffsetBus 			1:0
	`define 	WordAddrLoc 			31:2
	`define 	ByteOffsetLoc 			1:0
	`define 	BYTE_OFFSET_WORD 		2'b00
`include "header/bus.h.v"
	`define		BUS_MASTER_CH					4
	`define		BUS_MASTER_INDEX_W				2
	`define		BUS_OWNER_MASTER_0				2'h0
	`define		BUS_OWNER_MASTER_1				2'h1
	`define		BUS_OWNER_MASTER_2				2'h2
	`define		BUS_OWNER_MASTER_3				2'h3
	`define		BUS_SLAVE_CH					8
	`define		BUS_SLAVE_INDEX_W				3

	`define		BUS_SLAVE_0						0
	`define		BUS_SLAVE_1						1
	`define		BUS_SLAVE_2						2
	`define		BUS_SLAVE_3						3
	`define		BUS_SLAVE_4						4
	`define		BUS_SLAVE_5						5
	`define		BUS_SLAVE_6						6
	`define		BUS_SLAVE_7						7

	`define		BusOwnerBus						1:0
	`define		BusSlaveIndexBus				2:0
	`define		BusSlaveIndexLoc				29:27
`include "header/global_config.h.v"
	/*BY LOMOT*/
		`ifdef POSITIVE_RESET
			`define		RESET_EDGE				posedge	
			`define		RESET_ENABLE			1'b1	
			`define		RESET_DISABLE			1'b0
		`endif

		`ifdef NEGEATIVE_RESET
			`define		RESET_EDGE				negedge	
			`define		RESET_ENABLE			1'b0	
			`define		RESET_DISABLE			1'b1
		`endif

		`ifdef POSITIVE_MEMORY
			`define		MEM_ENABLE				1'b1
			`define		MEM_DISABLE				1'b0
		`endif

		`ifdef NEGEATIVE_MEMORY
			`define		MEM_ENABLE				1'b0
			`define		MEM_DISABLE				1'b1
		`endif

		`ifdef IMPLEMENT_TIMER
			//
		`endif

		`ifdef IMPLEMENT_UART
			//
		`endif

		`ifdef IMPLEMENT_GPIO
			//
		`endif
`define  NEGEATIVE_RESET
module bus_arbiter(clk,reset,m0_req_,m1_req_,m2_req_,m3_req_,m0_grnt_,m1_grnt_,m2_grnt_,m3_grnt_);
	input wire clk;
	input wire reset;

	input wire m0_req_;
	input wire m1_req_;
	input wire m2_req_;
	input wire m3_req_;

	output reg m0_grnt_;
	output reg m1_grnt_;
	output reg m2_grnt_;
	output reg m3_grnt_;
	
	reg [1:0] owner;//内部信号

	always @(*) begin
		m0_grnt_  = `DISABLE;
		m1_grnt_  = `DISABLE;
		m2_grnt_  = `DISABLE;
		m3_grnt_  = `DISABLE;

		case (owner)
			`BUS_OWNER_MASTER_0 : begin
				m0_grnt_ = `ENABLE_;
			end

			`BUS_OWNER_MASTER_1 : begin
				m1_grnt_ = `ENABLE_;
			end

			`BUS_OWNER_MASTER_2 : begin
				m2_grnt_ = `ENABLE_;
			end

			`BUS_OWNER_MASTER_3 : begin
				m3_grnt_ = `ENABLE_;
			end
		endcase
	end

	
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset==`RESET_ENABLE) begin
			owner <= #1 `BUS_OWNER_MASTER_0;
		end

		else begin
			//arbite
			case(owner)
				`BUS_OWNER_MASTER_0:begin
					if (m0_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_0;
					end
					else if (m1_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_1;
					end
					else if (m2_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_2;
					end
					else if (m3_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_3;
					end
				end

				`BUS_OWNER_MASTER_1:begin	
					if (m1_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_1;
					end
					else if (m2_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_2;
					end
					else if (m3_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_3;
					end
					else if (m0_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_0;
					end
				end

				`BUS_OWNER_MASTER_2:begin				
					if (m2_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_2;
					end
					else if (m3_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_3;
					end
					else if (m0_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_0;
					end
					else if (m1_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_1;
					end
				end

				`BUS_OWNER_MASTER_3:begin
					if (m3_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_3;
					end
					else if (m0_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_0;
					end
					else if (m1_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_1;
					end
					else if (m2_grnt_==`ENABLE_) begin
						owner<= #1 `BUS_OWNER_MASTER_2;
					end
				end
			endcase
		end
	end
	
	
	
endmodule


