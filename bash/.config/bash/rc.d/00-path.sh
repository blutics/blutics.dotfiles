
# pnpm
export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

