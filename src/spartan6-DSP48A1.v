module DSP48A1(A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CECARRYIN,CED,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
input [17:0]A,B,D,BCIN;
input[47:0]C,PCIN;
input [7:0]OPMODE;
input CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CECARRYIN,CED,CEOPMODE;
output [17:0]BCOUT ;
output [47:0]PCOUT;
output reg [47:0] P;
output [35:0]M;
output reg CARRYOUT;
output  CARRYOUTF;
parameter RSTTYPE="SYNC";
parameter BINPUT="DIRECT";
parameter CARRYINSEL="OPMODE5";
parameter A0REG =0;
parameter A1REG =1;
parameter B0REG=0;
 parameter B1REG=1;
 parameter CREG=1;
 parameter DREG=1;
 parameter MREG=1;
 parameter PREG=1;
 parameter CARRYINREG=1;
 parameter CARRYOUTREG =1;
 parameter OPMODEREG=1;

reg [17:0]A0_reg,B0_reg,D_reg;
reg [47:0]C_reg ;
reg [17:0]A1_reg,B1_reg;
wire[17:0] pre_add_sub,B1;
wire [35:0] Mul_out;
reg [35:0] M_reg;
reg CYI;
wire [47:0] D_A_B_CONCATENATED,X, Z;
wire[48:0] post_add_sub;





generate
    if  (A0REG) begin
      if(RSTTYPE=="ASYNC") begin
       always@(posedge CLK, posedge RSTA)begin
       if (RSTA)
         A0_reg <=0; 
       else if(CEA)
         A0_reg <=A;
       end
      end
      else 
      always@(posedge CLK)begin
         if (RSTA)
         A0_reg <=0; 
       else if(CEA)
         A0_reg <=A;
      end
      end
    else begin
        always@(*)begin
        A0_reg=A;
        end
     end
     
    
endgenerate

generate
    if  (B0REG)begin
      if(RSTTYPE=="ASYNC") begin
       always@(posedge CLK, posedge RSTB)begin
       if (RSTB)
         B0_reg <=0; 
       else if(CEB)
         B0_reg <= (BINPUT=="CASCADE")? BCIN: B;
       end
      end
      else begin
      always@(posedge CLK)begin
         if (RSTB)
         B0_reg <=0; 
       else if(CEB)
         B0_reg <= (BINPUT=="CASCADE")? BCIN: B;
      end
      end
    end
    else begin
        always@(*)begin
        B0_reg = (BINPUT=="CASCADE")? BCIN: B;
        end
     end
     
endgenerate

generate
    if  (CREG)begin
      if(RSTTYPE=="ASYNC") begin
       always@(posedge CLK, posedge RSTC)begin
       if (RSTC)
        C_reg <=0; 
       else if(CEC)
         C_reg <=C;
       end
      end
      else begin
      always@(posedge CLK)begin
         if (RSTC)
        C_reg <=0; 
       else if(CEC)
         C_reg <=C;
      end
      end
    end
    
    else begin
        always@(*)begin
        C_reg=C;
        end
    end
     
    
endgenerate

generate
    if  (DREG)begin
      if(RSTTYPE=="ASYNC") begin
       always@(posedge CLK, posedge RSTD)begin
       if (RSTD)
         D_reg <=0; 
       else if(CED)
         D_reg <=D;
       end
      end
      else begin
      always@(posedge CLK)begin
         if (RSTD)
        D_reg <=0; 
       else if(CED)
         D_reg <=D;
      end 
      end
    end
    else begin
        always@(*)begin
        D_reg=D;
        end
     end
endgenerate



assign pre_add_sub = (OPMODE[6]==0)? D_reg + B0_reg : D_reg - B0_reg ;
assign B1 = (OPMODE[4]==0)? B0_reg : pre_add_sub;
assign BCOUT = B1_reg;
assign Mul_out= A1_reg * B1_reg;
assign M = M_reg;
assign D_A_B_CONCATENATED = {D[11:0],A[17:0],B[17:0]};
assign post_add_sub = (OPMODE[7]==0)? (Z+X+CYI) : (Z-(X+CYI)) ;
assign CARRYOUTF = CARRYOUT;
assign PCOUT = P;


generate
    if  (B1REG)begin
      if(RSTTYPE=="ASYNC") begin
       always@(posedge CLK, posedge RSTB)begin
       if (RSTB)
         B1_reg <=0; 
       else if(CEB)
         B1_reg <= B1;
       end
      end
      else begin
      always@(posedge CLK)begin
         if (RSTB)
         B1_reg <=0; 
       else if(CEB)
         B1_reg <= B1;
      end
      end
    end
    else begin
        always@(*)begin
        B1_reg = B1;
        end
     end
endgenerate

generate
    if  (A1REG)begin
      if(RSTTYPE=="ASYNC") begin
       always@(posedge CLK, posedge RSTA)begin
       if (RSTA)
         A1_reg <=0; 
       else if(CEA)
         A1_reg <=A0_reg;
       end
      end
      else begin
      always@(posedge CLK)begin
         if (RSTA)
         A1_reg <=0; 
       else if(CEA)
         A1_reg <=A0_reg;
      end
      end
    end
    else begin
        always@(*)begin
        A1_reg = A0_reg;
     end
    end

endgenerate


generate
    if  (MREG)begin
      if(RSTTYPE=="ASYNC") begin
       always@(posedge CLK, posedge RSTM)begin
       if (RSTM)
         M_reg <=0; 
       else if(CEM)
         M_reg <= Mul_out;
       end
      end
      else begin
      always@(posedge CLK)begin
         if (RSTM)
         M_reg <=0; 
       else if(CEM)
         M_reg <= Mul_out;
      end
      end
    end
    else begin
        always@(*)begin
        M_reg = Mul_out;
        end
     end
endgenerate


generate
    if  (CARRYINREG)begin
      if(RSTTYPE=="ASYNC") begin
       always@(posedge CLK, posedge RSTCARRYIN)begin
       if (RSTCARRYIN)
        CYI <=0; 
       else if(CECARRYIN)
         CYI <= (CARRYINSEL=="CARRYIN")? CARRYIN: OPMODE[5];
       end
      end
      else begin
      always@(posedge CLK)begin
         if (RSTCARRYIN)
         CYI <=0; 
       else if(CECARRYIN)
         CYI <= (CARRYINSEL=="CARRYIN")? CARRYIN: OPMODE[5];
      end
      end
    end
    else begin
        always@(*)begin
         CYI = (CARRYINSEL=="CARRYIN")? CARRYIN: OPMODE[5];
        end
     end
endgenerate

assign X =(OPMODE[1:0]==2'b0)? 48'b0:
          (OPMODE[1:0]==2'b01)?  M_reg:
          (OPMODE[1:0]==2'b10)?  P:
          (OPMODE[1:0]==2'b11)?  D_A_B_CONCATENATED:48'b0;

assign Z =(OPMODE[3:2]==2'b0)? 48'b0:
          (OPMODE[3:2]==2'b01)?  PCIN:
          (OPMODE[3:2]==2'b10)?  P:
          (OPMODE[3:2]==2'b11)?  C_reg:48'b0;  


generate
    if  (PREG)begin
      if(RSTTYPE=="ASYNC") begin
       always@(posedge CLK, posedge RSTP)begin
       if (RSTP)
         P<=0; 
       else if(CEP)
         P <= post_add_sub;
       end
      end
      else begin
      always@(posedge CLK)begin
         if (RSTP)
         P <=0; 
       else if(CEP)
         P <= post_add_sub;
      end
      end
    end
    else begin
        always@(*)begin
        P = post_add_sub;
        end
     end
endgenerate


generate
    if  (CARRYOUTREG)begin
      if(RSTTYPE=="ASYNC") begin
       always@(posedge CLK, posedge RSTCARRYIN)begin
       if (RSTCARRYIN)
         CARRYOUT<=0; 
       else if(CECARRYIN)
         CARRYOUT <= post_add_sub[48];
       end
      end
      else begin
      always@(posedge CLK)begin
         if (RSTCARRYIN)
         CARRYOUT <=0; 
       else if(CECARRYIN)
         CARRYOUT <= post_add_sub[48];
      end
      end
    end
    else begin
        always@(*)begin
        CARRYOUT = post_add_sub[48];
        end
     end
endgenerate
endmodule