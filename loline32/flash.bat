esptool –-chip esp32 –-port COM4 erase_flash
esptool –-chip esp32 –-port COM4 –-baud 460800 write_flash -z 0x1000 esp32-idf3-20210202-v1.14.bin