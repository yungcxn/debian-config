# debian-config

After i switched from arch+hyprland to debian due to pacman... and hyprland being bloat, i installed extremely fast and (somehow) minimal debian.

My config builds upon debian 13 (trixie) and its minimal netinst install (ext4 file-sys + non-free software).

i3 is better than hyprland.

## pkg-manage

I did not want to use nix since everything within apt works right out of the box, e.g. cuda and nvidia. 
Therefore I wrote a minimal c-based package layer on top of apt where one can write his packages to declaratively collect everything installed on top of the base install.

usage:
- build with `gcc main.c -o exec_or_whatever_you_like`
- create a `pkg` file in the same folder as the executable
- write your line-separated apt packages into it
- run your executable
- those packages removed in the `pkg` file get removed when the executable runs (state save like in Terraform)
