/*
	Copyright 2023 Efabless Corp.

	Author: Mohamed Shalan (mshalan@efabless.com)

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	    http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

*/

/* THIS FILE IS GENERATED, DO NOT EDIT */

`timescale			1ns/1ps
`default_nettype	none

module EF_I2S_AHBL (
	input wire          HCLK,
                                        input wire          HRESETn,
                                        input wire          HWRITE,
                                        input wire [31:0]   HWDATA,
                                        input wire [31:0]   HADDR,
                                        input wire [1:0]    HTRANS,
                                        input wire          HSEL,
                                        input wire          HREADY,
                                        output wire         HREADYOUT,
                                        output wire [31:0]  HRDATA,
                                        output wire         IRQ
,
	output	[0:0]	ws,
	output	[0:0]	sck,
	input	[0:0]	sdi,
	output	[0:0]	sdo
);

	localparam	RXDATA_REG_OFFSET = 16'd0;
	localparam	PR_REG_OFFSET = 16'd4;
	localparam	FIFOLEVEL_REG_OFFSET = 16'd8;
	localparam	RXFIFOT_REG_OFFSET = 16'd12;
	localparam	CTRL_REG_OFFSET = 16'd16;
	localparam	CFG_REG_OFFSET = 16'd20;
	localparam	IM_REG_OFFSET = 16'd3840;
	localparam	MIS_REG_OFFSET = 16'd3844;
	localparam	RIS_REG_OFFSET = 16'd3848;
	localparam	IC_REG_OFFSET = 16'd3852;

	wire		clk = HCLK;
	wire		rst_n = HRESETn;


	reg  last_HSEL, last_HWRITE; reg [31:0] last_HADDR; reg [1:0] last_HTRANS;
                                        always@ (posedge HCLK) begin
                                            if(HREADY) begin
                                                last_HSEL       <= HSEL;
                                                last_HADDR      <= HADDR;
                                                last_HWRITE     <= HWRITE;
                                                last_HTRANS     <= HTRANS;
                                            end
                                        end
                                        wire    ahbl_valid	= last_HSEL & last_HTRANS[1];
	                                    wire	ahbl_we	= last_HWRITE & ahbl_valid;
	                                    wire	ahbl_re	= ~last_HWRITE & ahbl_valid;

	wire [1-1:0]	fifo_rd;
	wire [5-1:0]	fifo_level_threshold;
	wire [1-1:0]	fifo_full;
	wire [1-1:0]	fifo_empty;
	wire [5-1:0]	fifo_level;
	wire [1-1:0]	fifo_level_above;
	wire [32-1:0]	fifo_rdata;
	wire [1-1:0]	sign_extend;
	wire [1-1:0]	left_justified;
	wire [5-1:0]	sample_size;
	wire [8-1:0]	sck_prescaler;
	wire [2-1:0]	channels;
	wire [1-1:0]	en;


	wire	[32-1:0]	RXDATA_WIRE;

	reg [8-1:0]	PR_REG;
	assign	sck_prescaler = PR_REG;
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) PR_REG <= 0;
                                        else if(ahbl_we & (last_HADDR[16-1:0]==PR_REG_OFFSET))
                                            PR_REG <= HWDATA[8-1:0];

	wire [5-1:0]	FIFOLEVEL_WIRE;
	assign	FIFOLEVEL_WIRE = fifo_level;

	reg [5-1:0]	RXFIFOT_REG;
	assign	fifo_level_threshold = RXFIFOT_REG;
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) RXFIFOT_REG <= 0;
                                        else if(ahbl_we & (last_HADDR[16-1:0]==RXFIFOT_REG_OFFSET))
                                            RXFIFOT_REG <= HWDATA[5-1:0];

	reg [1-1:0]	CTRL_REG;
	assign	en = CTRL_REG;
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) CTRL_REG <= 0;
                                        else if(ahbl_we & (last_HADDR[16-1:0]==CTRL_REG_OFFSET))
                                            CTRL_REG <= HWDATA[1-1:0];

	reg [9-1:0]	CFG_REG;
	assign	channels	=	CFG_REG[1 : 0];
	assign	sign_extend	=	CFG_REG[2 : 2];
	assign	left_justified	=	CFG_REG[3 : 3];
	assign	sample_size	=	CFG_REG[8 : 4];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) CFG_REG <= 'h3F08;
                                        else if(ahbl_we & (last_HADDR[16-1:0]==CFG_REG_OFFSET))
                                            CFG_REG <= HWDATA[9-1:0];

	reg [2:0] IM_REG;
	reg [2:0] IC_REG;
	reg [2:0] RIS_REG;

	wire[3-1:0]      MIS_REG	= RIS_REG & IM_REG;
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) IM_REG <= 0;
                                        else if(ahbl_we & (last_HADDR[16-1:0]==IM_REG_OFFSET))
                                            IM_REG <= HWDATA[3-1:0];
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) IC_REG <= 3'b0;
                                        else if(ahbl_we & (last_HADDR[16-1:0]==IC_REG_OFFSET))
                                            IC_REG <= HWDATA[3-1:0];
                                        else IC_REG <= 3'd0;

	wire [0:0] FIFOE = fifo_empty;
	wire [0:0] FIFOA = fifo_level_above;
	wire [0:0] FIFOF = fifo_full;


	integer _i_;
	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) RIS_REG <= 0; else begin
		for(_i_ = 0; _i_ < 1; _i_ = _i_ + 1) begin
			if(IC_REG[_i_]) RIS_REG[_i_] <= 1'b0; else if(FIFOE[_i_ - 0] == 1'b1) RIS_REG[_i_] <= 1'b1;
		end
		for(_i_ = 1; _i_ < 2; _i_ = _i_ + 1) begin
			if(IC_REG[_i_]) RIS_REG[_i_] <= 1'b0; else if(FIFOA[_i_ - 1] == 1'b1) RIS_REG[_i_] <= 1'b1;
		end
		for(_i_ = 2; _i_ < 3; _i_ = _i_ + 1) begin
			if(IC_REG[_i_]) RIS_REG[_i_] <= 1'b0; else if(FIFOF[_i_ - 2] == 1'b1) RIS_REG[_i_] <= 1'b1;
		end
	end

	assign IRQ = |MIS_REG;

	EF_I2S instance_to_wrap (
		.clk(clk),
		.rst_n(rst_n),
		.fifo_rd(fifo_rd),
		.fifo_level_threshold(fifo_level_threshold),
		.fifo_full(fifo_full),
		.fifo_empty(fifo_empty),
		.fifo_level(fifo_level),
		.fifo_level_above(fifo_level_above),
		.fifo_rdata(fifo_rdata),
		.sign_extend(sign_extend),
		.left_justified(left_justified),
		.sample_size(sample_size),
		.sck_prescaler(sck_prescaler),
		.channels(channels),
		.en(en),
		.ws(ws),
		.sck(sck),
		.sdi(sdi),
		.sdo(sdo)
	);

	assign	HRDATA = 
			(last_HADDR[16-1:0] == RXDATA_REG_OFFSET)	? RXDATA_WIRE :
			(last_HADDR[16-1:0] == PR_REG_OFFSET)	? PR_REG :
			(last_HADDR[16-1:0] == FIFOLEVEL_REG_OFFSET)	? FIFOLEVEL_WIRE :
			(last_HADDR[16-1:0] == RXFIFOT_REG_OFFSET)	? RXFIFOT_REG :
			(last_HADDR[16-1:0] == CTRL_REG_OFFSET)	? CTRL_REG :
			(last_HADDR[16-1:0] == CFG_REG_OFFSET)	? CFG_REG :
			(last_HADDR[16-1:0] == IM_REG_OFFSET)	? IM_REG :
			(last_HADDR[16-1:0] == MIS_REG_OFFSET)	? MIS_REG :
			(last_HADDR[16-1:0] == RIS_REG_OFFSET)	? RIS_REG :
			(last_HADDR[16-1:0] == IC_REG_OFFSET)	? IC_REG :
			32'hDEADBEEF;

	assign	HREADYOUT = 1'b1;

	assign	RXDATA_WIRE = fifo_rdata;
	assign	fifo_rd = (ahbl_re & (last_HADDR[16-1:0] == RXDATA_REG_OFFSET));
endmodule
