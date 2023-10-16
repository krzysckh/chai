OL=ol
TARGET=chai

CFLAGS=#-O3
OLFLAGS=#-O2

.SUFFIXES: .scm .c

all: $(TARGET).c
	mkdir -p bin
	$(CC) $(CFLAGS) $(LDFLAGS) -o bin/$(TARGET) $(TARGET).c
.scm.c:
	$(OL) $(OLFLAGS) -x c -o $@ $<
clean:
	rm -fr *.c bin/$(TARGET)
