# Load the mise module from the Nushell runtime directory.
use ($nu.default-config-dir | path join mise.nu)

# Put user executables before system executables.
let local_bin = ($env.HOME | path join ".local" "bin")
let user_bin = ($env.HOME | path join "bin")
$env.PATH = ([$local_bin $user_bin ...$env.PATH] | uniq)

# Use the Herdr configuration from this repository.
$env.HERDR_CONFIG_PATH = ($env.HOME | path join "Workspace" "dotfiles" ".config" "herdr" "config.toml")

# Load optional machine-local secrets. This file must use Nushell syntax.
const secrets_file = "/home/amphetamarina/Workspace/dotfiles/secrets"
source-env (if ($secrets_file | path exists) { $secrets_file } else { null })
