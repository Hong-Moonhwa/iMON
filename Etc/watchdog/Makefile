TARGET := wd_reset

CFLAGS  := -g -w
OBJECTS := wd_reset.c

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

all: $(OBJECTS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJECTS)
	$(STRIP) -R .note -R .comment -s $(TARGET)

clean:
	rm -f $(TARGET)
