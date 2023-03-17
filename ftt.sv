// do D:/ADM_START_2/_MODE/do_tb_mode.do

// add memory addressradix -h dataradix hex D:ADM_START_2/_MODE/calibration.mif
// add memory -dataradix unsigned -addradix h -wordsperline 1 D:ADM_START_2/_MODE/calibration.hex

// проверки
// SW_PROC - тем гуд переводит все в стоп мод
// плюс я могу переключать
// после софт резета перехожу в нормал
// что-то делаем со стопом

`timescale 1ns/1ns

module tb_mode;

  logic        clk_i = 0;
  logic        rst_i;
  logic        temp_good_i;
  logic        vcsel_o_n;
  logic        run_stb_o;
  logic [13:0]  dac;
  logic [9:0]  const_addr;
  tri [64:0] const_data;
  reg [64:0] const_data_dop = 'bz;
  reg [10:0] test_vector;

  parameter string S1 = "sw_mode_sft_res";

  parameter logic[7:0] DAC_MANUAL     = 8'd10;
  parameter logic[7:0] OPERATING_MODE = 8'd11;
  parameter logic[7:0] MODE_CTRL      = 8'd12;
  parameter logic[7:0] MAX_CNT_VAL    = 8'd13;
  parameter logic[7:0] MIN_CNT_VAL    = 8'd14;
  parameter logic[7:0] SWITCH_MODE    = 8'd15;

  mode dut (
         .clk_i       (clk_i),
         .rst_i       (rst_i),
         .temp_good_i (temp_good_i),
         .vcsel_o_n   (vcsel_o_n),
         .run_stb_o   (run_stb_o),
         .dac         (dac),
         .const_addr  (const_addr),
         .const_data  (const_data)
       );



  int test_good;
  int test_bad;



  ////////////////////////////////////////
  // sequence of actions
  ////////////////////////////////////////
  
  initial
  begin
    ##10;
    task_rst();
    test_rst();

    
    // // $monitor  ("Addr %b, time %d", const_addr, $time);
    // // $display  ("Start, time %d", $time);
    // // cc_set_data (1'b1, SWITCH_MODE);
    // // $display  ("Stop, time %d", $time);
    // // $display  ("Start, time %d", $time);
    // // rst_i <= 1;
    // // ##10;
    // // rst_i <= 0;
    // // ##10;
    // // task_rst();
    // // switch2pure();
    // // switch to pure mode
    // // $display  ("SW to pure mode, time %d", $time);
    // // const_data_dop <= 1'b1;
    // // const_addr <= {2'b11,  SWITCH_MODE};
    // // ##1;
    // // const_addr <= '0;
    // // ##1;

    // // const_data_dop = 3'b011;
    // // const_addr <= {2'b11,  OPERATING_MODE};
    // // ##1;
    // // const_addr[9:0] <= 'b0;
    // // ##1;

    // // const_data_dop <= 1'b0;
    // // const_addr <= {2'b11,  SWITCH_MODE};
    // // ##1;
    // // const_addr[9:0] <= 'b0;
    // // ##1;

    // switch2pure(const_data_dop, const_addr);

    // // проверка температуры
    // $display  ("Start SW temp test, time %d", $time);
    // ##25;
    // temp_good_i <= '0;
    // ##1;
    // test_temp_good(vcsel_o_n);
    // ##10;
    // temp_good_i <= '1;
    // // проверка перехода в режим
    // ##2;
    // if (dut.sw_mode == 3'b100)
    //   good();
    // else
    //   bad();
    // // проверка перехода в следующий режим
    // ##20000;
    // if (dut.sw_mode == 3'b001)
    //   good();
    // else
    //   bad();
    // // переводим в другой режим
    // $display  ("SW to pure mode, time %d", $time);
    // const_data_dop <= 1'b1;
    // const_addr <= {2'b11,  SWITCH_MODE};
    // ##1;
    // const_addr <= '0;
    // ##1;

    // const_data_dop = 3'b011;
    // const_addr <= {2'b11,  OPERATING_MODE};
    // ##1;
    // const_addr[9:0] <= 'b0;
    // ##1;

    // const_data_dop <= 1'b0;
    // const_addr <= {2'b11,  SWITCH_MODE};
    // ##1;
    // const_addr[9:0] <= 'b0;
    // ##1;

    





    // // if (vcsel_o_n == 1'b1)
    // //   test_good <= test_good + 1;
    // // else
    // //   test_bad <= test_bad + 1;

    // // ##100;
    // // temp_good_i <= '1;
    // // $display  ("Stop SW temp test, time %d", $time);
    ##100;
    $display                ("End, time %d", $time);
    $stop;
  end

  assign const_data = const_data_dop;

  ////////////////////////////////////////
  // clk_gen
  ////////////////////////////////////////
  initial
    forever
      #10 clk_i = !clk_i;
  default
    clocking cb
      @ (posedge clk_i);
    endclocking;

  ////////////////////////////////////////
  // task
  ////////////////////////////////////////

  task automatic task_rst();
    $display  ("task_rst, time %d", $time);
    ##1;
    rst_i = '1;
    ##10;
    rst_i = '0;
    $display  ("stop_task_rst, time %d", $time);
  endtask

  task automatic test_rst();
    $display  ("test_rst, time %d", $time);
    ##10;
    rst_i = '1;
    ##1;
    if (vcsel_o_n == '0 || run_stb_o == '1 || dac != '0 ) begin
      good();
    end
    else begin
      bad();
    end
    ##100;
    rst_i = '0;
    $display  ("stop_test_rst, time %d", $time);
  endtask

  task switch2pure();
    $display  ("SW to pure mode, time %d", $time);
    const_data_dop <= 1'b1;
    const_addr <= {2'b11,  SWITCH_MODE};
    ##1;
    const_addr <= '0;
    ##1;

    const_data_dop = 3'b011;
    const_addr <= {2'b11,  OPERATING_MODE};
    ##1;
    const_addr[9:0] <= 'b0;
    ##1;

    const_data_dop <= 1'b0;
    const_addr <= {2'b11,  SWITCH_MODE};
    ##1;
    const_addr[9:0] <= 'b0;
    ##1;
  endtask

  task automatic test_temp_good (input logic test_vcsel_signal);
    begin
      $display  ("Test_temp_good, time %d", $time);
      if (test_vcsel_signal == 1'b1)
        good();
      else
        bad();
    end
  endtask

  task automatic good();
    test_good = test_good + 1;
    $display  ("Test_temp_good = %d, time %d", test_good, $time);
  endtask

  task automatic bad();
    test_bad = test_bad + 1;
    $display  ("Test_test_bad = %d, time %d", test_bad, $time);
  endtask

  task cc_set_data (input logic [64:0] cc_data, logic [7:0] cc_addr);
    const_data_dop = cc_data;
    const_addr <= {2'b11,  cc_addr};
    ##1;
    const_addr[9:0] <= 'b0;
    ##1;
  endtask



endmodule


// for (int                i                                                       = 0; i <= data_array_length; i = i + 1) begin
//     @               (posedge clk_i                                                      );
//                     data_0_i                                                            <= test_data[i];
//                     data_1_i                                                            <= test_data[i];
//                     data_2_i                                                            <= test_data[i];
//                     data_3_i                                                            <= test_data[i];
// end
// ////////////////////////////////////////
// // read data from file
// ////////////////////////////////////////
//     parameter                                               data_array_length   = 8192;
//     logic           [data_i_width:0]                    test_data   [data_array_length:0];
//     initial begin
//         $readmemb               ("D:/ADM_START_2/_PROCESSING/test_data_fbg.txt", test_data                                                      );
//     end



// ////////////////////////////////////////
// // verify
// ////////////////////////////////////////
//     logic           [data_o_width:0]                    value_out_0 [$];
//     logic           [data_o_width:0]                    value_out_1 [$];
//     logic           [data_o_width:0]                    value_out_2 [$];
//     logic           [data_o_width:0]                    value_out_3 [$];
//     logic                                               rdy_stb_o_prev  ;

//     always @                (posedge clk_i                                                          )
//     begin
//                         rdy_stb_o_prev                                                          <= rdy_stb_o;
//         if              (rdy_stb_o                                                      = = 1)         begin
//             value_out_0.push_back               (data_0_o                                                       );
//             value_out_1.push_back               (data_1_o                                                       );
//             value_out_2.push_back               (data_2_o                                                       );
//             value_out_3.push_back               (data_3_o                                                       );
//         end
//     end

//     initial begin
//         wait (              (rdy_stb_o_prev                                                     =    = 1) & (rdy_stb_o == 0) );
//         $display("LINE              [0]                                                         = %p", value_out_0);
//         $display("LINE              [1]                                                         = %p", value_out_1);
//         $display("LINE              [2]                                                         = %p", value_out_2);
//         $display("LINE              [3]                                                         = %p", value_out_3);
//     end


