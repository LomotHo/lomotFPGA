`include "header/nettype.h.v"
module lomot(led,clk);// ģ�������˿ڲ���
output[3:0]led;				// ����˿ڶ���
input clk; // ����˿ڶ��壬50M ʱ��
reg[3:0] led;//����led_out ����Ϊ�Ĵ�����
//reg[4:0] led1;//����led_out ����Ϊ�Ĵ�����
reg[24:0] counter;//����led_out ����Ϊ�Ĵ�����

always@(posedge clk)
begin
    counter<=counter+1;
	if(counter==25'd25000000)
	begin
		led<=led<<1;// led ������λ������λ�Զ���0 ��λ
		counter<=0;//��������0
		if(led==8'b0000)//ÿ��ʱ���ٽ���,����һλ,һֱ��8λȫ������Ϊ0
		led<=8'b1111;//���¸�ֵΪȫ1,
	end
	
end
endmodule