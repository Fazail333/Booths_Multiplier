module final_product #(
    parameter WIDTH_FP = 32     // Final Product
) (
    input logic [WIDTH_FP-1:0]  in,
    input logic                 en_fp,

    output logic [WIDTH_FP-1:0] product
);

assign product = (en_fp) ? in : '0;
    
endmodule