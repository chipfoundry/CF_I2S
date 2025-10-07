
/*
	Copyright 2024-2025 ChipFoundry, a DBA of Umbralogic Technologies LLC.

	Original Copyright 2024 Efabless Corp.
	Author: Efabless Corp. (ip_admin@efabless.com)

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


`timescale			1ns/1ns
`default_nettype	none

/*
        A simple i2s microphone VIP
*/

module i2s_mic (
    input sck,
    input ws,
    output reg sdo
);

    localparam LEFT = 18'h1_0A0B, RIGHT = 18'h2_0D0F;
    reg [17:0] rdata = RIGHT;
    reg [17:0] ldata = LEFT;

    always @(posedge ws)
        rdata = RIGHT;

    always @(negedge ws)
        ldata = LEFT;

    always @(posedge sck)
        if(ws) begin
            sdo <= rdata[17];
            rdata <= (rdata << 1);
        end else begin
            sdo <= ldata[17];
            ldata <= (ldata << 1);
        end

endmodule