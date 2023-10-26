OL=ol
TARGET=chai

CFLAGS=
OLFLAGS=#-O2

.SUFFIXES: .scm .c

all: $(TARGET).c
	mkdir -p bin
	$(CC) $(CFLAGS) $(LDFLAGS) -o bin/$(TARGET) $(TARGET).c
.scm.c:
	$(OL) $(OLFLAGS) -x c -o $@ $<
clean:
	rm -fr *.c bin/$(TARGET)
install:
	cp $(TARGET) /usr/local/bin/$(TARGET)
	cp chai.1 /usr/local/man/man1/chai.1
uninstall:
	rm -f $(PREFIX)/bin/$(TARGET)
	rm -f $(PREFIX)/man/man1/chai.1
