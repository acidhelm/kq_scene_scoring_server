{
    en: {
        browser_title: "%{title} - KQ Scene Scoring",
        browser_title_view: "Viewing %{title}",
        cancel_link: "Cancel",
        log_out_link: "Log out",
        errors: {
            login_required: "You must log in.",
            page_access_denied: "You cannot access that page.",
            tournament_not_found: "That tournament was not found.",
            user_not_found: "That user was not found.",
            login_failed: "The user name or password was incorrect.",
            invalid_api_key: "can contain only letters and numbers",
            invalid_slug: "can contain only letters, numbers, and underscores"
        },
        notices: {
            user_updated: "The user was updated.",
            auth_error: "Authentication error. Check that your Challonge API" \
                          " key is correct.",
            tournament_created: "The tournament was created.",
            tournament_updated: "The tournament was updated.",
            tournament_deleted: "The tournament was deleted.",
            scores_updated: "The tournament's scores were updated."
        },
        sessions: {
            new: {
                page_title: "Log in",
                account_setup_instructions_html: "Enter the user name and password" \
                  " of your KQ Scene Scoring account. If you haven't made an account" \
                  " yet, see <a href='%{url}'>the installation instructions</a>" \
                  " on how to set one up.",
                user_name_html: "<u>U</u>ser name:",
                user_name_accesskey: "u",
                password_html: "<u>P</u>assword:",
                password_accesskey: "p",
                log_in_button: "Log in"
            }
        },
        users: {
            edit: {
                page_title: "Change account settings for %{user_name}",
                page_header: "Change account settings for %{user_name}"
            },
            form: {
                errors_list_header: {
                    one: "1 error prevented the user from being saved:",
                    other: "%{count} errors prevented the user from being saved:"
                },
                api_key_html: "<u>C</u>hallonge API key: (" \
                              "<a target='_blank' href='https://challonge.com/settings/developer'>" \
                              "Find your API key</a>)",
                password_html: "<u>P</u>assword: (Leave this blank to keep your current password)",
                password_confirmation_html: "C<u>o</u>nfirm the new password:",
                api_key_accesskey: "c",
                password_accesskey: "p",
                confirm_password_accesskey: "o"
            },
            show: {
                page_title: "Account settings for %{user_name}",
                page_header: "Account settings for %{user_name}",
                user_name: "User name:",
                api_key: "API key:"
            },
            view_tournaments: "View this user's tournaments",
            edit_user: "Change this user's settings"
        },
        tournaments: {
            edit: {
                page_title: "Settings for %{tournament_name}",
                page_header: "Settings for %{tournament_name}"
            },
            form: {
                errors_list_header: {
                    one: "1 error prevented the tournament from being saved:",
                    other: "%{count} errors prevented the tournament from being saved:"
                },
                title_html: "<u>T</u>itle:",
                slug_html: "<u>C</u>hallonge ID: (The part of the URL after \"challonge.com\")",
                subdomain_html: "S<u>u</u>bdomain: (Fill this in if the brackets are owned by an organization)",
                complete_html: "C<u>o</u>mplete?",
                title_accesskey: "t",
                slug_accesskey: "c",
                subdomain_accesskey: "u",
                complete_accesskey: "o"
            },
            index: {
                page_title: "Tournament list for %{user_name}",
                page_header: "Tournament list for %{user_name}",
                title: "Title",
                slug: "Challonge ID",
                subdomain: "Subdomain",
                complete: "Complete?",
                links: "Links",
                actions: "Actions",
                new_tournament: "Calculate scores for a new tournament",
                show_link: "View scores",
                kiosk_link: "Kiosk",
                challonge_link: "Challonge bracket",
                edit_link: "Change settings",
                delete_link: "Delete"
            },
            new: {
                page_title: "Calculate scores for a tournament",
                page_header: "Calculate scores for a Challonge tournament"
            },
            show: {
                title: "Title:",
                slug: "Challonge ID:",
                subdomain: "Subdomain:",
                complete: "Complete?",
                calculate_now: "Calculate scores now"
            },
            complete_true: "Yes",
            complete_false: "No",
            view_user: "View this user's info",
            edit_tournament: "Change this tournament's settings",
            tournament_list: "Back to the tournament list"
        },
        kiosk: {
            browser_title: "Scene scores for %{title}"
        }
    }
}
