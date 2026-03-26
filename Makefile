OL=ol
TARGET=chai

maybe_sqlite != $(OL) -e '(if (has? *features* (quote sqlite)) "`pkg-config --cflags --libs sqlite3`" "")'

CFLAGS=
OLFLAGS=--include lib/robusta #-O2
LDFLAGS=$(maybe_sqlite)

.SUFFIXES: .scm .c

all: $(TARGET).c
	mkdir -p bin
	$(CC) $(CFLAGS) -o bin/$(TARGET) $(TARGET).c $(LDFLAGS)
.scm.c:
	$(OL) $(OLFLAGS) -x c -o $@ $<
clean:
	rm -fr *.c bin/$(TARGET)
install: all
	cp bin/$(TARGET) /usr/local/bin/$(TARGET)
	cp chai.1 /usr/local/man/man1/chai.1
uninstall:
	rm -f $(PREFIX)/bin/$(TARGET)
	rm -f $(PREFIX)/man/man1/chai.1
