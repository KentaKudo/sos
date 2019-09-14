TOOLS := z_tools
INCPATH := $(TOOLS)/haribote/
NASK := $(TOOLS)/nask
EDIMG := $(TOOLS)/edimg
CC1 := $(TOOLS)/gocc1 -I$(INCPATH) -Os -Wall -quiet
GAS2NASK := $(TOOLS)/gas2nask -a
OBJ2BIM := $(TOOLS)/obj2bim
RULEFILE := $(TOOLS)/haribote/haribote.rul
BIM2HRB := $(TOOLS)/bim2hrb
MAKEFONT := $(TOOLS)/makefont
BIN2OBJ := $(TOOLS)/bin2obj

ASM := ipl.bin
OS := sos.sys
IMAGE := sos.img

.DEFAULT_GOAL := img

$(ASM): ipl.nas
	$(NASK) $< $@ ipl.lst

asmhead.bin: asmhead.nas
	$(NASK) $< asmhead.bin asmhead.lst

bootpack.gas: bootpack.c
	$(CC1) -o $@ $<

bootpack.nas: bootpack.gas
	$(GAS2NASK) $< $@

bootpack.obj: bootpack.nas
	$(NASK) $< $@ bootpack.lst

naskfunc.obj: naskfunc.nas
	$(NASK) $< $@ naskfunc.lst

hankaku.bin: hankaku.txt
	$(MAKEFONT) $< $@

hankaku.obj: hankaku.bin
	$(BIN2OBJ) $< $@ _hankaku

bootpack.bim: bootpack.obj naskfunc.obj hankaku.obj
	$(OBJ2BIM) @$(RULEFILE) \
		out:$@ \
		stack:3136k \
		map:bootpack.map \
		$^

bootpack.hrb: bootpack.bim
	$(BIM2HRB) $< $@ 0

$(OS): asmhead.bin bootpack.hrb
	cat $^ > $@

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
	@rm -f *.bin *.lst *.gas *.obj \
		bootpack.nas bootpack.map bootpack.bim bootpack.hrb \
		$(IMAGE)
