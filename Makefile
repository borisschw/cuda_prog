MKDIR_P = mkdir -p
CC = nvcc
CFLAG =
LDFLAGS =
TARGET = add
TARGET_DIR = ./build

all: $(TARGET_DIR)/$(TARGET)

$(TARGET_DIR)/$(TARGET): $(TARGET).cu
	$(CC) $(LDFLAGS) $^ -o $@

clean:
	rm -f *.o $(TARGET_DIR)/$(TARGET)
