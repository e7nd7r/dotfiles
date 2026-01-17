# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/repos/linbos-back-rust"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "biojoints"; then
    # Create a new window inline within session layout definition.
    new_window "neovim"
    run_cmd "nvim ."

    new_window "terminal"

    new_window "servers"
    run_cmd "cargo run api"

    split_h 50
    run_cmd "cargo run graphql"

    select_window 0
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session

