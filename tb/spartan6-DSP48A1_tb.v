module DSP48A1_tb();

reg  [17:0]A,B,D,BCIN;
reg  [47:0]C,PCIN;
reg  [7:0]OPMODE;
reg CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CECARRYIN,CED,CEOPMODE;
wire  [17:0]BCOUT ;
wire  [47:0]PCOUT;
wire [47:0] P;
wire [35:0]M;
wire CARRYOUT;
wire  CARRYOUTF;

DSP48A1 dut(A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CECARRYIN,CED,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);

initial begin
    CLK=0;
    forever
    #1 CLK=~CLK;
end
initial begin
    //reset
    RSTA = 1;RSTB = 1;RSTC = 1;RSTCARRYIN = 1;
    RSTD = 1;RSTM = 1; RSTOPMODE = 1;RSTP = 1;

    A=$random; B=$random; D=$random;
    BCIN=$random; C=$random;PCIN=$random;CARRYIN=$random;

    CEA=$random;CEB=$random;CEM=$random; CEP=$random;CEC=$random;
    CECARRYIN=$random;CED=$random;CEOPMODE=$random;

@(negedge CLK);
  if (P!=0 || M!=0 || CARRYOUT!=0 || PCOUT!=0 || BCOUT!=0 || CARRYOUTF!=0) begin
   $display("reset test failed" );
   $stop;
  end

    RSTA =0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0;
    RSTD = 0;RSTM = 0;RSTOPMODE = 0;RSTP = 0;

    CEA=1;CEB=1;CEM=1;CEP=1;
    CEC=1; CECARRYIN=1; CED=1; CEOPMODE=1;
    
//path1
OPMODE=8'b11011101;
A=20; B=10; C=350; D=25;
BCIN=$random; PCIN=$random; CARRYIN=$random;

repeat(4)@(negedge CLK);
if ( P!='h32 || PCOUT!='h32 || BCOUT!='hf || M!='h12c || CARRYOUT!=0 || CARRYOUTF != 0 ) begin
   $display("pre/post-subtractor test failed" );
   $stop;
end

//path2
OPMODE=8'b00010000;
A=20; B=10; C=350; D=25;
BCIN=$random; PCIN=$random; CARRYIN=$random;

repeat(3)@(negedge CLK);
if(BCOUT!='h23 || M!='h2bc || P!=0 || PCOUT!=0)begin
   $display("pre/post-adition test failed" );
   $stop;
end

//path3
OPMODE=8'b00001010;

repeat(3)@(negedge CLK);
if(BCOUT!='ha || M!='hc8 || P!=0 || PCOUT!=0)begin
   $display("post-adition test failed" );
   $stop;
end

//path4
OPMODE=8'b00001010;
A=5; B=6; C=350; D=25; PCIN=3000;
BCIN=$random; CARRYIN=$random;

repeat(3)@(negedge CLK);
if(BCOUT!='h6 || M!='h1e || P!='hfe6fffec0bb1 || PCOUT!='hfe6fffec0bb1 || CARRYOUT!=1 || CARRYOUTF=1)begin
   $display("post-subtraction test failed" );
   $stop;
end

$stop;

end
endmodule