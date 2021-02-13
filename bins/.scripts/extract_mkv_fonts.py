# Extract fonts from an MKV file with ffmpeg
import os, sys

for i in range(100):
    dumper = f'mkdir -p ./Fonts && cd ./Fonts && ffmpeg -y -dump_attachment:t:{i} "" -i "a"'
    os.system(dumper)
