`timescale 1ns / 1ps
`default_nettype none

// olebra's slightly modified version of https://www.fpga4fun.com/SPI2.html
module spi_slave(
    input  wire clk,
    input  wire sclk,
    input  wire mosi,
    output wire miso,
    input  wire ss,
    output wire ss_fall,
    output wire byte_ready,
    output wire [7:0] out
);

// intermediate register for output
reg [7:0] outr = 0;

// it seems mcu is sending LSB first; reverse
assign out = {outr[0], outr[1], outr[2], outr[3], outr[4], outr[5], outr[6], outr[7]};

// 3-bit shift register for syncing sclk to FPGA clock
reg [2:0] sclkr = 0;

always @(posedge clk)
    sclkr <= {sclkr[1:0], sclk};

wire sclk_risingedge = (sclkr[2:1]==2'b01);
wire sclk_fallingedge = (sclkr[2:1]==2'b10);

// similarly for ss
reg [2:0] ssr = 1;
always @(posedge clk)
    ssr <= {ssr[1:0], ss};

wire ss_active = ~ssr[1];             // SS is active low
wire ss_falling = (ssr[2:1]==2'b10);  // message starts at falling edge
assign ss_fall = ss_falling;
wire ss_rising = (ssr[2:1]==2'b01);   // message stops at rising edge

// and for mosi
reg [1:0] mosir = 0;
always @(posedge clk)
    mosir <= {mosir[0], mosi};

wire mosi_data = mosir[1];

// 3-bit counter to count 8-bit SPI
reg [2:0] bitcnt = 0;

reg byte_received = 0; // set to high when we've got a byte
reg byte_received_last_cycle = 0;
reg [7:0] byte_data_received = 0;
assign byte_ready = byte_received_last_cycle;

always @(posedge clk)
begin
  if(~ss_active) bitcnt <= 3'd0;
  else
  if(sclk_risingedge)
  begin
    bitcnt <= bitcnt + 3'd1; // increase count
    // MSB comes first, so we use a shift-left register
    byte_data_received <= {byte_data_received[6:0], mosi_data};
  end
  if (ss_falling) bitcnt <= 3'd0; // transmission is starting, reset the count
end

// for every clock cycle, check that:
// 1. SS is active (i.e. we're receiving)
// 2. we're on the rising edge of SCLK
// 3. the bit count is 7 (i.e. the bit we're now receiving is the last of
// the byte)
always @(posedge clk) byte_received <= ss_active && sclk_risingedge && (bitcnt==3'd7);

// stick the byte into the out register
always @(posedge clk)
if(byte_received) begin
    outr <= byte_data_received;
    byte_received_last_cycle <= 1;
    end
    else byte_received_last_cycle <= 0;

reg [7:0] byte_data_sent = 0;

reg [7:0] cnt = 0;
always @(posedge clk) if(ss_falling) cnt<=cnt+8'h1;  // count the messages

always @(posedge clk)
if(ss_active)
begin
  if(ss_falling)
    byte_data_sent <= cnt;  // first byte sent in a message is the message count
  else
  if(sclk_fallingedge)
  begin
    if(bitcnt==3'b000)
      byte_data_sent <= 8'h00;  // after that, we send 0s
    else
      byte_data_sent <= {byte_data_sent[6:0],1'b0};
  end
end

assign miso = byte_data_sent[7];  // send MSB first
                                  // this assumes we're the only slave 
                                  // otherwise, this would have to be tri-state buffer 

endmodule
