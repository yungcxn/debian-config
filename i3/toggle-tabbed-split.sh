read workspace_name focused_output <<<$(i3-msg -t get_workspaces \
  | jq -r '.[] | select(.focused==true) | "\(.name) \(.output)"')

[ -z "$workspace_name" ] && exit 1

layout=$(i3-msg -t get_tree \
  | jq -r --arg ws "$workspace_name" --arg out "$focused_output" '
    .nodes[] 
    | select(.type=="output" and .name==$out)
    | .nodes[]
    | select(.name==$ws)
    | .layout
  ')

if [ "$layout" = "tabbed" ]; then
  i3-msg "[workspace=\"$workspace_name\"] layout toggle split"
else
  i3-msg "[workspace=\"$workspace_name\"] layout tabbed"
fi
