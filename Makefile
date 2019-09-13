TOOLS := z_tools
NASK := $(TOOLS)/nask
EDIMG := $(TOOLS)/edimg

ASM := ipl.bin
OS := sos.sys
IMAGE := sos.img

.DEFAULT_GOAL := img

$(ASM): ipl.nas
	$(NASK) $< $@ ipl.lst

$(OS): sos.nas
	$(NASK) $< $@ sos.lst

$(IMAGE): $(ASM) $(OS)
	$(EDIMG) \
		imgin:$(TOOLS)/fdimg0at.tek \
		wbinimg \
		src:$(ASM) len:512 from:0 to:0 \
		copy from:$(OS) to:@: \
		imgout:$@

.PHONY: asm
asm: $(ASM)

.PHONY: img
img: $(IMAGE)

.PHONY: run
run: $(IMAGE)
	cp $< $(TOOLS)/qemu/fdimage0.bin
	make -C $(TOOLS)/qemu

.PHONY: clean
clean:
	@rm -f $(ASM) ipl.lst $(OS) sos.lst $(IMAGE)
