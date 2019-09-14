/* ���̃t�@�C���ō�����֐�������܂���C�R���p�C���ɋ����� */

void io_hlt(void);

/* �֐��錾�Ȃ̂ɁA{}���Ȃ��Ă����Ȃ�;�������ƁA
	���̃t�@�C���ɂ��邩���낵���ˁA�Ƃ����Ӗ��ɂȂ�̂ł��B */

void HariMain(void)
{
	int i;
	char *p;

	for (i = 0xa0000; i <= 0xaffff; i++) {
		p = (char *) i;
		*p = i & 0x0f;
	}

	for (;;) {
		io_hlt();
	}
}
