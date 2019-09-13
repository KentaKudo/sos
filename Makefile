run:
	z_tools/nask sos.nas sos.img
	cp sos.img z_tools/qemu/fdimage0.bin
	make -C z_tools/qemu
