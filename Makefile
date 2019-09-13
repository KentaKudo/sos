ASM := ipl.bin
IMAGE := sos.img

.DEFAULT_GOAL := img

$(ASM): ipl.nas
	z_tools/nask $< $@ ipl.lst

$(IMAGE): $(ASM)
	z_tools/edimg \
		imgin:z_tools/fdimg0at.tek \
		wbinimg \
		src:$< len:512 from:0 to:0 \
		imgout:$@

.PHONY: asm
asm: $(ASM)

.PHONY: img
img: $(IMAGE)

.PHONY: run
run: $(IMAGE)
	cp $< z_tools/qemu/fdimage0.bin
	make -C z_tools/qemu

.PHONY: clean
clean:
	@rm -f $(ASM) ipl.lst $(IMAGE)
