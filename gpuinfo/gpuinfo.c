#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <nvml.h>

static void fmt_mem(char *buf, size_t sz, unsigned long long used,
                    unsigned long long total) {

        unsigned long long u = used / (1024 * 1024);
        unsigned long long t = total / (1024 * 1024);
        double perc = (double)used / (double)total * 100.0;
        snprintf(buf, sz, "%llu/%llu MB (%.0f%%)", u, t, perc);
}

static void fmt_bar(char *buf, size_t sz, double perc) {
        const char *full = "█";
        const char *empty = "░";
        int len = 10; // total bar cells
        int filled = (int)(perc * len / 100.0 + 0.5);
        if (filled > len) filled = len;
        if (filled < 0) filled = 0;
        int emptyc = len - filled;
        buf[0] = 0;
        for (int i = 0; i < filled; i++) {
                if (strlen(buf) + 4 < sz) {
                        strncat(buf, full, sz - strlen(buf) - 1);
                }
        }
        for (int i = 0; i < emptyc; i++) {
                if (strlen(buf) + 4 < sz) {
                        strncat(buf, empty, sz - strlen(buf) - 1);
                }
        }
}


int main(int argc, char **argv) {
        nvmlReturn_t result;
        nvmlDevice_t device;
        result = nvmlInit();
        if (result != NVML_SUCCESS) { 
                fprintf(stderr, "%s\n", nvmlErrorString(result)); 
                return 1;
        }
        result = nvmlDeviceGetHandleByIndex(0, &device);
        if (result != NVML_SUCCESS) {
                fprintf(stderr, "%s\n", nvmlErrorString(result));
                nvmlShutdown();
                return 1;
        }

        nvmlUtilization_t util;
        nvmlMemory_t mem;
        unsigned int temp, power, powerLimit, gfxClock, smClock, memClock;
        char name[64], memstr[64], bar[128];

        nvmlDeviceGetName(device, name, sizeof(name));
        nvmlDeviceGetUtilizationRates(device, &util);
        nvmlDeviceGetMemoryInfo(device, &mem);
        nvmlDeviceGetTemperature(device, NVML_TEMPERATURE_GPU, &temp);
        nvmlDeviceGetPowerUsage(device, &power);
        nvmlDeviceGetPowerManagementLimit(device, &powerLimit);
        nvmlDeviceGetClockInfo(device, NVML_CLOCK_GRAPHICS, &gfxClock);
        nvmlDeviceGetClockInfo(device, NVML_CLOCK_SM, &smClock);
        nvmlDeviceGetClockInfo(device, NVML_CLOCK_MEM, &memClock);

        fmt_mem(memstr, sizeof(memstr), mem.used, mem.total);

        if (argc > 1) {
                int first = 1;
                for (int i = 1; i < argc; i++) {
                        int isbar = 0;
                        if (strlen(argv[i]) > 2 && argv[i][2] == 'b') isbar = 1;
                        if (!strncmp(argv[i], "-u", 2)) {
                                if (!first) { printf("   "); }
                                if (isbar) { 
                                        fmt_bar(bar, sizeof(bar), util.gpu);
                                        printf("%s %u%%", bar, util.gpu); 
                                } else {
                                        printf("%u", util.gpu);
                                } 
                                first = 0;
                        } else if (!strncmp(argv[i], "-m", 2)) {
                                if (!first) { printf("   "); }
                                if (isbar) {
                                        double perc = (double)mem.used 
                                                      / (double)mem.total 
                                                      * 100.0;
                                        fmt_bar(bar, sizeof(bar), perc);
                                        printf("%s %s", bar, memstr);
                                } else {
                                        printf("%s", memstr);
                                }
                                first = 0;
                        } else if (!strncmp(argv[i], "-t", 2)) {
                                if (!first) printf("   ");
                                if (isbar) {
                                        double perc = (double)temp / 100.0 
                                                                   * 100.0;
                                        fmt_bar(bar, sizeof(bar), perc);
                                        printf("%s %uC", bar, temp);
                                } else {
                                        printf("%u", temp);
                                }
                                first = 0;
                        } else if (!strncmp(argv[i], "-p", 2)) {
                                if (!first) printf("   ");
                                if (isbar) {
                                        double perc = (double)power 
                                                      / (double)powerLimit 
                                                      * 100.0;
                                        fmt_bar(bar, sizeof(bar), perc);
                                        printf("%s %u/%uW", bar, power/1000, 
                                               powerLimit/1000);
                                } else {
                                        printf("%u/%u", power/1000, 
                                               powerLimit/1000);
                                }
                                first = 0;
                        }
                }
                printf("\n");
                nvmlShutdown();
                return 0;
        }

        printf("GPU=\"%s\" util=%u%% mem=%s temp=%uC power=%u/%uW\n",
               name,
               util.gpu,
               memstr,
               temp,
               power/1000,
               powerLimit/1000);

        nvmlShutdown();
        return 0;
}