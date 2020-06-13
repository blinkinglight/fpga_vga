`timescale 1ns/1ps

module top (
    // 16MHz clock
    input CLK,

    // USB pull-up resistor
    output USBPU,

    // GPIO Outputs.
    output PIN_8,
    output PIN_9,
    output PIN_10,
    // output PIN_11,  Pin looks to be dead.
    output PIN_12,
    output PIN_13,

    // GPIO Inputs.
    input PIN_1,
    input PIN_2,
    input PIN_3,
    input PIN_4,
    input PIN_5,
    input PIN_6,
    input PIN_7,
    input PIN_14,
    input PIN_15,
    input PIN_16,
    input PIN_17,
    input PIN_18,
    input PIN_19,
    input PIN_20,
    input PIN_21,
    input PIN_22,
    input PIN_23,
    input PIN_24,
    input PIN_31
);

    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    // VGA output signals.
    wire clk_10mhz;
    assign PIN_8 = red;
    assign PIN_9 = green;
    assign PIN_10 = blue;
    assign PIN_12 = h_sync;
    assign PIN_13 = v_sync;

    reg [8:0] h_counter;
    reg [0:0] h_sync;

    reg [9:0] v_counter;
    reg [0:0] v_sync;

    reg [0:0] red;
    reg [0:0] green;
    reg [0:0] blue;

    // Interrupt input.
    wire interrupt;
    assign interrupt = PIN_31;

    // Address inputs.
    wire a0;
    wire a1;
    wire a2;
    wire a3;
    wire a4;
    wire a5;
    wire a6;
    wire a7;
    wire a8;
    wire a9;
    wire a10;
    wire a11;
    wire a12;
    wire a13;
    wire a14;

    assign a0 = PIN_1;
    assign a1 = PIN_2;
    assign a2 = PIN_3;
    assign a3 = PIN_4;
    assign a4 = PIN_5;
    assign a5 = PIN_6;
    assign a6 = PIN_7;
    assign a7 = PIN_14;
    assign a8 = PIN_15;
    assign a9 = PIN_16;
    assign a10 = PIN_17;
    assign a11 = PIN_18;
    assign a12 = PIN_19;
    assign a13 = PIN_20;
    assign a14 = PIN_21;

    // RGB data inputs.
    wire r_in;
    wire g_in;
    wire b_in;

    assign r_in = PIN_22;
    assign g_in = PIN_23;
    assign b_in = PIN_24;

    // BRAM
    reg [15:0] memory_data_in;  // bits: 13, 9, 5, 1
    reg [14:0] w_absolute_addr;
    reg [10:0] waddr;

    reg [14:0] absolute_addr;
    reg [10:0] raddr;

    reg write_en1;
    reg write_en2;
    reg write_en3;
    reg write_en4;
    reg write_en5;
    reg write_en6;
    reg write_en7;
    reg write_en8;
    reg write_en9;
    reg write_en10;
    reg write_en11;
    reg write_en12;
    reg write_en13;
    reg write_en14;
    reg write_en15;
    reg write_en16;
    reg write_en17;
    reg write_en18;
    reg write_en19;
    reg write_en20;
    reg write_en21;
    reg write_en22;
    reg write_en23;
    reg write_en24;
    reg write_en25;
    reg write_en26;
    reg write_en27;
    reg write_en28;
    reg write_en29;
    reg write_en30;

    wire [15:0] memory_data_out_1;
    wire [15:0] memory_data_out_2;
    wire [15:0] memory_data_out_3;
    wire [15:0] memory_data_out_4;
    wire [15:0] memory_data_out_5;
    wire [15:0] memory_data_out_6;
    wire [15:0] memory_data_out_7;
    wire [15:0] memory_data_out_8;
    wire [15:0] memory_data_out_9;
    wire [15:0] memory_data_out_10;
    wire [15:0] memory_data_out_11;
    wire [15:0] memory_data_out_12;
    wire [15:0] memory_data_out_13;
    wire [15:0] memory_data_out_14;
    wire [15:0] memory_data_out_15;
    wire [15:0] memory_data_out_16;
    wire [15:0] memory_data_out_17;
    wire [15:0] memory_data_out_18;
    wire [15:0] memory_data_out_19;
    wire [15:0] memory_data_out_20;
    wire [15:0] memory_data_out_21;
    wire [15:0] memory_data_out_22;
    wire [15:0] memory_data_out_23;
    wire [15:0] memory_data_out_24;
    wire [15:0] memory_data_out_25;
    wire [15:0] memory_data_out_26;
    wire [15:0] memory_data_out_27;
    wire [15:0] memory_data_out_28;
    wire [15:0] memory_data_out_29;
    wire [15:0] memory_data_out_30;

    // Create a 10MHz clock.
    // http://martin.hinner.info/vga/timing.html
    // 40 MHz = 800x600@60Hz
    // 10 MHz = 200x150
    SB_PLL40_CORE #(
      .DIVR(0),
      .DIVF(9),
      .DIVQ(4),
      .FILTER_RANGE(3'b001),
      .FEEDBACK_PATH("SIMPLE"),
      .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
      .FDA_FEEDBACK(4'b0000),
      .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
      .FDA_RELATIVE(4'b0000),
      .SHIFTREG_DIV_MODE(2'b00),
      .PLLOUT_SELECT("GENCLK"),
      .ENABLE_ICEGATE(1'b0)
    ) pll (
      .REFERENCECLK(CLK),
      .PLLOUTCORE(clk_10mhz),
      .RESETB(1'b1),
      .BYPASS(1'b0)
    );

    initial begin
      h_counter <= 0;
      v_counter <= 0;
      h_sync <= 0;
      v_sync <= 0;

      write_en1 <= 0;
      write_en2 <= 0;
      write_en3 <= 0;
      write_en4 <= 0;
      write_en5 <= 0;
      write_en6 <= 0;
      write_en7 <= 0;
      write_en8 <= 0;
      write_en9 <= 0;
      write_en10 <= 0;
      write_en11 <= 0;
      write_en12 <= 0;
      write_en13 <= 0;
      write_en14 <= 0;
      write_en15 <= 0;
      write_en16 <= 0;
      write_en17 <= 0;
      write_en18 <= 0;
      write_en19 <= 0;
      write_en20 <= 0;
      write_en21 <= 0;
      write_en22 <= 0;
      write_en23 <= 0;
      write_en24 <= 0;
      write_en25 <= 0;
      write_en26 <= 0;
      write_en27 <= 0;
      write_en28 <= 0;
      write_en29 <= 0;
      write_en30 <= 0;
    end

    // <= : every line executed in parallel in always block
    always @(posedge clk_10mhz) begin
        absolute_addr = h_counter + ((v_counter / 4) * 200);
        raddr = absolute_addr[9:0];

        // Display pixel.
        if (h_counter > 199)  // Horizontal blanking.
      	begin
      	  red <= 0;
          green <= 0;
          blue <= 0;
      	end else if (v_counter > 599)  // Vertical blanking.
      	begin
      	  red <= 0;
          green <= 0;
          blue <= 0;
      	end else // Active video.
        begin
          if (absolute_addr > 29695) begin
            red <= memory_data_out_30[1];
            green <= memory_data_out_30[5];
            blue <= memory_data_out_30[9];
          end else if (absolute_addr > 28671) begin
            red <= memory_data_out_29[1];
            green <= memory_data_out_29[5];
            blue <= memory_data_out_29[9];
          end else if (absolute_addr > 27647) begin
            red <= memory_data_out_28[1];
            green <= memory_data_out_28[5];
            blue <= memory_data_out_28[9];
          end else if (absolute_addr > 26623) begin
            red <= memory_data_out_27[1];
            green <= memory_data_out_27[5];
            blue <= memory_data_out_27[9];
          end else if (absolute_addr > 25599) begin
            red <= memory_data_out_26[1];
            green <= memory_data_out_26[5];
            blue <= memory_data_out_26[9];
          end else if (absolute_addr > 24575) begin
            red <= memory_data_out_25[1];
            green <= memory_data_out_25[5];
            blue <= memory_data_out_25[9];
          end else if (absolute_addr > 23551) begin
            red <= memory_data_out_24[1];
            green <= memory_data_out_24[5];
            blue <= memory_data_out_24[9];
          end else if (absolute_addr > 22527) begin
            red <= memory_data_out_23[1];
            green <= memory_data_out_23[5];
            blue <= memory_data_out_23[9];
          end else if (absolute_addr > 21503) begin
            red <= memory_data_out_22[1];
            green <= memory_data_out_22[5];
            blue <= memory_data_out_22[9];
          end else if (absolute_addr > 20479) begin
            red <= memory_data_out_21[1];
            green <= memory_data_out_21[5];
            blue <= memory_data_out_21[9];
          end else if (absolute_addr > 19455) begin
            red <= memory_data_out_20[1];
            green <= memory_data_out_20[5];
            blue <= memory_data_out_20[9];
          end else if (absolute_addr > 18431) begin
            red <= memory_data_out_19[1];
            green <= memory_data_out_19[5];
            blue <= memory_data_out_19[9];
          end else if (absolute_addr > 17407) begin
            red <= memory_data_out_18[1];
            green <= memory_data_out_18[5];
            blue <= memory_data_out_18[9];
          end else if (absolute_addr > 16383) begin
            red <= memory_data_out_17[1];
            green <= memory_data_out_17[5];
            blue <= memory_data_out_17[9];
          end else if (absolute_addr > 15359) begin
            red <= memory_data_out_16[1];
            green <= memory_data_out_16[5];
            blue <= memory_data_out_16[9];
          end else if (absolute_addr > 14335) begin
            red <= memory_data_out_15[1];
            green <= memory_data_out_15[5];
            blue <= memory_data_out_15[9];
          end else if (absolute_addr > 13311) begin
            red <= memory_data_out_14[1];
            green <= memory_data_out_14[5];
            blue <= memory_data_out_14[9];
          end else if (absolute_addr > 12287) begin
            red <= memory_data_out_13[1];
            green <= memory_data_out_13[5];
            blue <= memory_data_out_13[9];
          end else if (absolute_addr > 11263) begin
            red <= memory_data_out_12[1];
            green <= memory_data_out_12[5];
            blue <= memory_data_out_12[9];
          end else if (absolute_addr > 10239) begin
            red <= memory_data_out_11[1];
            green <= memory_data_out_11[5];
            blue <= memory_data_out_11[9];
          end else if (absolute_addr > 9215) begin
            red <= memory_data_out_10[1];
            green <= memory_data_out_10[5];
            blue <= memory_data_out_10[9];
          end else if (absolute_addr > 8191) begin
            red <= memory_data_out_9[1];
            green <= memory_data_out_9[5];
            blue <= memory_data_out_9[9];
          end else if (absolute_addr > 7167) begin
            red <= memory_data_out_8[1];
            green <= memory_data_out_8[5];
            blue <= memory_data_out_8[9];
          end else if (absolute_addr > 6143) begin
            red <= memory_data_out_7[1];
            green <= memory_data_out_7[5];
            blue <= memory_data_out_7[9];
          end else if (absolute_addr > 5119) begin
            red <= memory_data_out_6[1];
            green <= memory_data_out_6[5];
            blue <= memory_data_out_6[9];
          end else if (absolute_addr > 4095) begin
            red <= memory_data_out_5[1];
            green <= memory_data_out_5[5];
            blue <= memory_data_out_5[9];
          end else if (absolute_addr > 3071) begin
            red <= memory_data_out_4[1];
            green <= memory_data_out_4[5];
            blue <= memory_data_out_4[9];
          end else if (absolute_addr > 2046) begin
            red <= memory_data_out_3[1];
            green <= memory_data_out_3[5];
            blue <= memory_data_out_3[9];
          end else if (absolute_addr > 1023) begin
            red <= memory_data_out_2[1];
            green <= memory_data_out_2[5];
            blue <= memory_data_out_2[9];
          end else begin
            red <= memory_data_out_1[1];
            green <= memory_data_out_1[5];
            blue <= memory_data_out_1[9];
          end
        end

        // Horitonal sync.
        if (h_counter > 209 && h_counter < 242)
        begin
          h_sync <= 1;
        end else
        begin
          h_sync <= 0;
        end

        // Vertical sync.
        if (v_counter > 600 && v_counter < 605)
        begin
          v_sync <= 1;
        end else
        begin
          v_sync <= 0;
        end

        // Increment / reset counters.
        h_counter <= h_counter + 1'b1;

        if (h_counter == 264)
        begin
          h_counter <= 0;
          v_counter <= v_counter + 1'b1;
        end

        if (v_counter == 628)
        begin
          v_counter <= 0;
        end
    end

    // Load pixel data into memory.
    always @(posedge interrupt) begin
      w_absolute_addr <= (a14 * 2**14) + (a13 * 2**13) + (a12 * 2**12) + (a11 * 2**11) + (a10 * 2**10) + (a9 * 2**9) + (a8 * 2**8) + (a7 * 2**7) + (a6 * 2**6) + (a5 * 2**5) + (a4 * 2**4) + (a3 * 2**3) + (a2 * 2**2) + (a1 * 2**1) + (a0 * 2**0);
      waddr = w_absolute_addr[9:0];
      memory_data_in <= (b_in * 2**2) + (g_in * 2**1) + (r_in * 2**0);

      // if (w_absolute_addr > 29695) begin
      //   write_en30 = 1;
      //   write_en30 = 0;
      // end else if (w_absolute_addr > 28671) begin
      //   write_en29 = 1;
      //   write_en29 = 0;
      // end else if (w_absolute_addr > 27647) begin
      //   write_en28 = 1;
      //   write_en28 = 0;
      // end else if (w_absolute_addr > 26623) begin
      //   write_en27 = 1;
      //   write_en27 = 0;
      // end else if (w_absolute_addr > 25599) begin
      //   write_en26 = 1;
      //   write_en26 = 0;
      // end else if (w_absolute_addr > 24575) begin
      //   write_en25 = 1;
      //   write_en25 = 0;
      // end else if (w_absolute_addr > 23551) begin
      //   write_en24 = 1;
      //   write_en24 = 0;
      // end else if (w_absolute_addr > 22527) begin
      //   write_en23 = 1;
      //   write_en23 = 0;
      // end else if (w_absolute_addr > 21503) begin
      //   write_en22 = 1;
      //   write_en22 = 0;
      // end else if (w_absolute_addr > 20479) begin
      //   write_en21 = 1;
      //   write_en21 = 0;
      // end else if (w_absolute_addr > 19455) begin
      //   write_en20 = 1;
      //   write_en20 = 0;
      // end else if (w_absolute_addr > 18431) begin
      //   write_en19 = 1;
      //   write_en19 = 0;
      // end else if (w_absolute_addr > 17407) begin
      //   write_en18 = 1;
      //   write_en18 = 0;
      // end else if (w_absolute_addr > 16383) begin
      //   write_en17 = 1;
      //   write_en17 = 0;
      // end else if (w_absolute_addr > 15359) begin
      //   write_en16 = 1;
      //   write_en16 = 0;
      // end else if (w_absolute_addr > 14335) begin
      //   write_en15 = 1;
      //   write_en15 = 0;
      // end else if (w_absolute_addr > 13311) begin
      //   write_en14 = 1;
      //   write_en14 = 0;
      // end else if (w_absolute_addr > 12287) begin
      //   write_en13 = 1;
      //   write_en13 = 0;
      // end else if (w_absolute_addr > 11263) begin
      //   write_en12 = 1;
      //   write_en12 = 0;
      // end else if (w_absolute_addr > 10239) begin
      //   write_en11 = 1;
      //   write_en11 = 0;
      // end else if (w_absolute_addr > 9215) begin
      //   write_en10 = 1;
      //   write_en10 = 0;
      // end else if (w_absolute_addr > 8191) begin
      //   write_en9 = 1;
      //   write_en9 = 0;
      // end else if (w_absolute_addr > 7167) begin
      //   write_en8 = 1;
      //   write_en8 = 0;
      // end else if (w_absolute_addr > 6143) begin
      //   write_en7 = 1;
      //   write_en7 = 0;
      // end else if (w_absolute_addr > 5119) begin
      //   write_en6 = 1;
      //   write_en6 = 0;
      // end else if (w_absolute_addr > 4095) begin
      //   write_en5 = 1;
      //   write_en5 = 0;
      // end else if (w_absolute_addr > 3071) begin
      //   write_en4 = 1;
      //   write_en4 = 0;
      // end else if (w_absolute_addr > 2046) begin
      //   write_en3 = 1;
      //   write_en3 = 0;
      // end else if (w_absolute_addr > 1023) begin
      //   write_en2 = 1;
      //   write_en2 = 0;
      // end else begin
      //   write_en1 = 1;
      //   write_en1 = 0;
      // end
    end

    ////
    // BRAM
    ////

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2),    // 1024x4
      .INIT_0(256'b0000000000000010000000000010000000000010000000000000000000000010000000000010000000000010000000000000000000000010000000000010000000000010000000000000000000000010000000000010000000000010000000000000000000000010000000000010000000000010000000000000000000000010)
    ) ram1 (
      .RDATA(memory_data_out_1),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en1)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram2 (
      .RDATA(memory_data_out_2),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en2)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram3 (
      .RDATA(memory_data_out_3),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en3)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram4 (
      .RDATA(memory_data_out_4),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en4)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram5 (
      .RDATA(memory_data_out_5),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en5)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram6 (
      .RDATA(memory_data_out_6),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en6)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram7 (
      .RDATA(memory_data_out_7),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en7)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram8 (
      .RDATA(memory_data_out_8),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en8)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram9 (
      .RDATA(memory_data_out_9),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en9)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram10 (
      .RDATA(memory_data_out_10),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en10)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram11 (
      .RDATA(memory_data_out_11),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en11)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram12 (
      .RDATA(memory_data_out_12),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en12)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram13 (
      .RDATA(memory_data_out_13),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en13)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram14 (
      .RDATA(memory_data_out_14),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en14)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram15 (
      .RDATA(memory_data_out_15),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en15)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram16 (
      .RDATA(memory_data_out_16),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en16)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram17 (
      .RDATA(memory_data_out_17),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en17)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram18 (
      .RDATA(memory_data_out_18),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en18)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram19 (
      .RDATA(memory_data_out_19),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en19)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram20 (
      .RDATA(memory_data_out_20),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en20)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram21 (
      .RDATA(memory_data_out_21),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en21)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram22 (
      .RDATA(memory_data_out_22),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en22)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram23 (
      .RDATA(memory_data_out_23),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en23)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram24 (
      .RDATA(memory_data_out_24),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en24)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram25 (
      .RDATA(memory_data_out_25),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en25)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram26 (
      .RDATA(memory_data_out_26),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en26)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram27 (
      .RDATA(memory_data_out_27),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en27)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram28 (
      .RDATA(memory_data_out_28),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en28)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram29 (
      .RDATA(memory_data_out_29),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en29)
    );

    SB_RAM40_4K #(
      .READ_MODE(2),     // 1024x4
      .WRITE_MODE(2)     // 1024x4
    ) ram30 (
      .RDATA(memory_data_out_30),
      .RADDR(raddr),
      .WADDR(waddr),
      .WDATA(memory_data_in),
      .RCLKE(1'b1),
      .RCLK(clk_10mhz),
      .RE(1'b1),
      .WCLKE(1'b1),
      .WCLK(clk_10mhz),
      .WE(write_en30)
    );

endmodule
