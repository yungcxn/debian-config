gcc -I/usr/local/cuda-13.0/targets/x86_64-linux/include gpuinfo.c -lnvidia-ml -o gpuinfo
mv gpuinfo ~/Apps