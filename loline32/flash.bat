esptool –-chip esp32 –-port COM4 erase_flash
esptool –-chip esp32 –-port COM4 –-baud 460800 write_flash -z 0x1000 esp32-20210404-unstable-v1.14-132-gd87f42b0e.bin