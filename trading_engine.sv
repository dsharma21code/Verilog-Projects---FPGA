`timescale 1ns/1ps

module trading_engine #(
  parameter int THRESHOLD_BP = 200  
)(
  input  logic        clk,
  input  logic        rst_n,
  input  int unsigned price,
  output logic        buy,
  output logic        sell,
  output logic        hold,
  output int          change_bp
);

  int unsigned prev_price;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      prev_price <= 0;
      change_bp  <= 0;
      buy <= 0; sell <= 0; hold <= 1;
    end else begin
      int delta_bp;
      if (prev_price == 0) begin
        delta_bp = 0;
      end else begin
        delta_bp = int'(((int'(price) - int'(prev_price)) * 10000) / int'(prev_price));
      end


      change_bp <= delta_bp;
      buy  <= (delta_bp >=  THRESHOLD_BP);
      sell <= (delta_bp <= -THRESHOLD_BP);
      hold <= !((delta_bp >= THRESHOLD_BP) || (delta_bp <= -THRESHOLD_BP));


      prev_price <= price;
    end
  end

endmodule
