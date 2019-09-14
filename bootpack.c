/* ���̃t�@�C���ō�����֐�������܂���C�R���p�C���ɋ����� */

void io_hlt(void);
void write_mem8(int addr, int data);

/* �֐��錾�Ȃ̂ɁA{}���Ȃ��Ă����Ȃ�;�������ƁA
	���̃t�@�C���ɂ��邩���낵���ˁA�Ƃ����Ӗ��ɂȂ�̂ł��B */

void HariMain(void)
{
	int i;

	for (i = 0xa0000; i <= 0xaffff; i++) {
		write_mem8(i, 15);
	}

	for (;;) {
		io_hlt();
	}
}
