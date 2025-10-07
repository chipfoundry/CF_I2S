SIM-I2S:
	iverilog  -g2012 -s CF_I2S_tb i2s_mic.v ../../hdl/rtl/CF_I2S.v CF_I2S_tb.v
	./a.out

SIM-RTL:
	iverilog  -g2012 -s CF_I2S_apb_tb ../../hdl/rtl/CF_I2S.v ../../hdl/rtl/bus_wrappers/CF_I2S_apb.v CF_I2S_apb_tb.v
	./a.out

SIM-GL:
	iverilog  -g2012 -s CF_I2S_apb_tb ../../hdl/rtl/CF_I2S.v ../../hdl/gl/sky130/CF_I2S_apb.v CF_I2S_apb_tb.v ../../util/tech/sky130/sky130_hd.v
	./a.out
