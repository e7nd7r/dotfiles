session_root "~/repos/e7nd7r-vault"

if initialize_session "obsidian"; then
    new_window "nvim[e7nd7r-vault]"
    run_cmd "nvim ."
fi

finalize_and_go_to_session
