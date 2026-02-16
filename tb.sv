`timescale 1ns/1ps

module tb;
  logic clk = 0;
  logic rst_n = 0; 

  localparam int N = 12;

  int unsigned prices [0:N-1];

  int unsigned price;
  logic buy, sell, hold;
  int change_bp;

  localparam int THRESH_BP = 200;

  trading_engine #(.THRESHOLD_BP(THRESH_BP)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .price(price),
    .buy(buy),
    .sell(sell),
    .hold(hold),
    .change_bp(change_bp)
  );

  always #5 clk = ~clk;

  integer i;
  string decision;

  initial begin
    prices[0]  = 77;
    prices[1]  = 76;
    prices[2]  = 74;
    prices[3]  = 72;
    prices[4]  = 70;
    prices[5]  = 69;
    prices[6]  = 70;
    prices[7]  = 71;
    prices[8]  = 73;
    prices[9]  = 76;
    prices[10] = 79;
    prices[11] = 82;

    $dumpfile("waves.vcd");
    $dumpvars(0, tb);

    $display("\n  time   price   change(bp)  decision");
    $display("  -----------------------------------");

    price = 0;
    rst_n = 0;
    repeat (3) @(posedge clk);
    rst_n = 1;

    for (i = 0; i < N; i++) begin
      price = prices[i];
      @(posedge clk);
      decision = buy ? "BUY" : (sell ? "SELL" : "HOLD");
      $display(" %5t   %4d      %6d     %s",
               $time, price, change_bp, decision);
    end

    repeat (5) @(posedge clk);
    $finish;
  end
endmodule
