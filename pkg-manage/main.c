#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 256
#define LAYER_FILE "pkg"
#define DIFF_FILE ".pkg-last-diff"

void load_file(const char* filename, char packages[][MAX_LINE], int *count) {
  FILE *f = fopen(filename, "r");
  if (!f) return;
  char line[MAX_LINE];
  while (fgets(line, sizeof(line), f)) {
    if (line[0] == '#' || line[0] == '\n') continue;
    line[strcspn(line, "\n")] = 0;
    if (strlen(line) > 0) strcpy(packages[(*count)++], line);
  }
  fclose(f);
}

int exists_in(char packages[][MAX_LINE], int count, const char* pkg){
  for (int i = 0; i < count; i++) {
    if (strcmp(packages[i], pkg) == 0) return 1;
  }
  return 0;
}

void save_file(const char* filename, char packages[][MAX_LINE], int count) {
  FILE* f = fopen(filename, "w");
  if (!f) return;
  for (int i = 0; i < count; i++) {
    fprintf(f, "%s\n", packages[i]);
  }
  fclose(f);
}


int main(void) {
  char old[1024][MAX_LINE];
  int o = 0;
  char desired[1024][MAX_LINE];
  int d = 0;
  char new[1024][MAX_LINE];
  int n = 0;
  char finstalls[1024][MAX_LINE];
  int fi = 0;
  char fremovals[1024][MAX_LINE];
  int fr = 0;

  load_file(DIFF_FILE, old, &o);
  load_file(LAYER_FILE, desired, &d);

  for (int i = 0; i < d; i++) {
    char cmd[512];
    snprintf(cmd, sizeof(cmd), "dpkg -s %s > /dev/null 2>&1", desired[i]);
    if (system(cmd) != 0) {
      printf("Installing %s ...\n", desired[i]);
      snprintf(cmd, sizeof(cmd), "sudo apt install -y %s > /dev/null 2>&1", desired[i]);
      if (system(cmd) == 0) {
        strcpy(new[n++], desired[i]);
      } else {
        printf(" ! Failed to install %s\n", desired[i]);
        strcpy(finstalls[fi++], desired[i]);
      }
    } else { /* package exists */
      printf("  (%s exists)\n", desired[i]);
      strcpy(new[n++], desired[i]);
    }
  }

  /* now remove from old diff but not in desired */
  for (int i = 0; i < o; i++) {
    if (!exists_in(desired, d, old[i])){
      char cmd[512];
      printf("Removing %s ... \n", old[i]);
      snprintf(cmd, sizeof(cmd), "sudo apt remove -y %s > /dev/null 2>&1", old[i]);
      if (system(cmd) != 0) {
        printf(" ! Failed to remove %s\n", old[i]);
        strcpy(new[n++], old[i]);
        strcpy(fremovals[fr++], old[i]);
      }
    }
  }

  /* now gen new diff and readd failed removals */
  save_file(DIFF_FILE, new, n);

  if (fr > 0) {
    for (int i = 0; i < fr; i++) {
      if (!exists_in(desired, d, fremovals[i])) {
        strcpy(desired[d++], fremovals[i]);
      }
    }
    save_file(LAYER_FILE, desired, d);
  }

  /* end summary */
  if (fi > 0 || fr > 0) {
    printf("\n\n Fail-Summary:\n");
    for (int i = 0; i < fi; i++) {
      printf("  - Install: %s\n", finstalls[i]);
    }
    for (int i = 0; i < fr; i++) {
      printf("  - Removal: %s\n", fremovals[i]);
    }
  }

  return 0;
}
