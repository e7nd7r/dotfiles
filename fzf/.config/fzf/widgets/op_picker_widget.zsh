# ---- Config (change if you like) -------------------------------------------
: "${OPV_VAULT:-Personal}" # default vault
# ---- Helper: auto-sized item table with hidden id --------------------------

set OP_VALUE

export OP_VALUE

_op_picker_items_table() {
    local VAULT="${1:-$OPV_VAULT}"

    op_res=$(op item list --vault "$VAULT" --format json)

    paste -d $'\t' \
        <(
            printf '%s\n' ''
            printf '%s\n' "${op_res}" | jq -r '.[].id'
        ) \
        <(
            {
                printf 'TITLE\tCATEGORY\tVAULT\tUPDATED\n'
                printf '%s\n' "${op_res}" |
                    jq -r '
                        .[] | [
                            (.title // ""),
                            (.category // ""),
                            (.vault.name // ""),
                            (.updated_at // .created_at // "")
                        ] | @tsv
                    '
            } | column -t -s $'\t'
        )
}

_op_picker_fields_query() {
    local json

    json=$(cat)

    printf '%s' "$json" | jq -r '
        def safe(x): (x // "") | tostring;
        def hidden($type; $val): if $type == "CONCEALED" then "*****" else $val end;
        def row($val; $label; $kind): [$val, $label, hidden($kind; $val), $kind];

        [
            ( . | select(.href != null) | row( safe(.href); "URL"; "urls/href" )),
            (
                (.fields // [])[] 
                    | select(.value != null)
                    | row(
                        safe(.value);
                        ("fields/" + safe(.label));
                        safe(.type)
                    )
            ),
            (
                (.sections // [] )[] as $s | ( $s.fields // [] )[]
                    | select(.value != null)
                    | row( 
                        safe(.value);
                        ("sections/" + safe($s.label) + "/fields/" + safe(.label));
                        ("sections/" + safe($s.id // $s.label // "section") + "/" + safe(.type))
                    )
            )
        ] | to_entries
    '
}

_op_picker_flatten_fields() {
    local rows

    rows=$(cat)

    paste -d $'\t' \
        <(
            printf '%s\n' ''
            printf '%s\n' "$rows" | jq -r '.[].key'
        ) \
        <(
            {
                printf '\tLABEL\tVALUE\tTYPE\n'
                printf '%s\n' "$rows" | jq -r '.[].value[1:] | @tsv'
            } | column -t -s $'\t'
        )
}

_op_picker_value_setter() {
    local VAULT="${1:-$OPV_VAULT}"
    local id rows json field_idx value

    fzf_res=$(
        _op_picker_items_table "$VAULT" |
            fzf --ansi --with-nth=2.. --delimiter=$'\t' --header-lines=1 \
                --height=80% --reverse --border rounded \
                --prompt='item ❯ ' \
                --header="Select 1Password item ($VAULT)"
    )

    id=$(
        echo $fzf_res |
            awk -F'\t' 'NF { print $1 }'
    ) || return 1

    [[ -z "$id" ]] && return 1

    json="$(op item get "$id" --format "json")" || return 1

    rows=$(printf '%s\n' "$json" | _op_picker_fields_query)

    field_idx=$(
        printf '%s\n' "$rows" |
            _op_picker_flatten_fields |
            fzf --with-nth=2.. --delimiter=$'\t' --header-lines=1 \
                --height=80% --reverse --border rounded \
                --prompt='field ❯ ' \
                --header="Pick a field (secrets are hidden)" |
            awk -F'\t' 'NF { print $1 }'
    ) || return 1

    [[ -z "$field_idx" ]] && return 1

    value=$(
        printf '%s\n' "$rows" |
            jq -r ".[${field_idx}].value[0]"
    )

    [[ -z "$value" ]] && return 1

    secret_file=$(mktemp "op_XXXXXXX")

    echo "${value}" >>$secret_file

    printf '$(cat %s)\n' "${secret_file}"
}

op_picker_widget() {
    zle -I

    local secret

    secret="$(_op_picker_value_setter "$OPV_VAULT")"

    # Insert a literal $VARNAME so the secret never prints, only expands on run:
    LBUFFER+="$secret"

    zle redisplay
}

zle -N op_picker_widget

bindkey '^O' op_picker_widget
