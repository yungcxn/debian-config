xrandr | grep " connected" | while read line; do
  monitor=$(echo "$line" | cut -d" " -f1)
  bestmode=$(xrandr | grep -A20 "^$monitor" | grep -m1 -Eo "[0-9]+x[0-9]+\s+[0-9]+\.[0-9]+")
  res=$(echo $bestmode | awk '{print $1}')
  hz=$(echo $bestmode | awk '{print $2}')
  xrandr --output "$monitor" --mode "$res" --rate "$hz"
done

xrandr --output DP-0 --left-of DP-2
