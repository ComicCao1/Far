#define to_chat(target, message)                            target << (message)
#define PUBLIC_GAME_MODE (ticker ? (ticker.hide_mode == 0 ? master_mode : "Secret") : "Unknown")