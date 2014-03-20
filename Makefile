HEX=fw.hex
OUT=fw.obj

MMCU=atmega32u4
F_CPU = 8000000

CFLAGS=-mmcu=$(MMCU) -Wall -Os -DF_CPU=$(F_CPU) -std=c99

$(HEX): $(OUT)
	avr-objcopy -O ihex $(OUT) $(HEX)
	avr-size --mcu=$(MMCU) --format=avr $(OUT)

$(OUT): $(OBJECTS) *.c *.h sd-reader/*.c sd-reader/*.h
	avr-gcc $(CFLAGS) -o $(OUT) *.c sd-reader/*.c

clean:
	rm $(OUT) $(HEX)
################################################################################

program: programmed
	touch programmed
	avrdude -p $(MMCU) -c usbtiny -U flash:w:$(HEX)

fuse:
	avrdude -p $(MMCU) -c usbtiny -U lfuse:w:0xde:m -U hfuse:w:0xd9:m -U efuse:w:0xfb:m

dfu: programmed
	touch programmed
	dfu-programmer $(MMCU) erase
	dfu-programmer $(MMCU) flash $(HEX)

programmed: $(HEX)
