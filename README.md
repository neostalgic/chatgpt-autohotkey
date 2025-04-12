# ChatGPT AutoHotkey and Image Context

This script provides hotkey-based automation for interacting with ChatGPT and the Windows Terminal. It uses the snipping tool and `ImageMagick` to take screenshots and pipe the output to `chatgpt-cli`.

*Note:* Ensure that you do not run this script from a sandboxed folder. Backup folders like OneDrive seem to cause issues with this.

## Features 
- Hotkey: Open a terminal window
- Hotkey: Open an interactive LLM prompt
- Hotkey: Take a screenshot with the snipping tool and pipe the output to an interactive LLM prompt 

## Prerequisites

1. **Install `chatgpt-cli`**
   - Follow the installation instructions for `chatgpt-cli` from its official repository.

2. **Install `ImageMagick`**
   - Download and install ImageMagick from [https://imagemagick.org](https://imagemagick.org).
   - Ensure that the `magick` command is available in your system's PATH.

3. **Configure a `prompt.md` File**
   - Create a `prompt.md` file in the `.chatgpt-cli` directory under your user profile (e.g., `C:\Users\<YourUsername>\.chatgpt-cli\prompt.md`).
   - Use the following example as a template:

```markdown
A(ChatGPT-4o)

You are Cal, a large language model trained by OpenAI and my (Regan) personal assistant.

Image input capabilities: Enabled Personality: v2 Over the course of the conversation, you adapt to the user’s tone and preference. Try to match the user’s vibe, tone, and generally how they are speaking. You want the conversation to feel natural. You engage in authentic conversation by responding to the information provided, asking relevant questions, and showing genuine curiosity. If natural, continue the conversation with casual conversation.
---

## 🔧 Environment Overview

### Hotkeys
You know the following aliases I use in my terminal:
- `Alt + Mouse 4` → Open a terminal
- `Alt + Middle Click` → Take a screenshot with the snipping tool and feed the output to Cal, starting a new conversation.
- `Alt + Mouse 5` → Open Cal and start a new conversation.
```

## Default Hotkeys

- **`Alt + Mouse 4`**: Opens a terminal with the default profile.
- **`Alt + Middle Click`**: Takes a screenshot using the snipping tool and sends it to ChatGPT for a new conversation.
- **`Alt + Mouse 5`**: Opens ChatGPT and starts a new conversation.

## Configuration

The script uses environment variables for customization. You can set the following variables to override defaults:

- `CHATGPT_PROFILE`: The terminal profile to use for ChatGPT commands (default: `Windows PowerShell`).
- `CHATGPT_PROMPT_PATH`: Path to the `prompt.md` file (default: `C:\Users\<YourUsername>\.chatgpt-cli\prompt.md`).
- `CHATGPT_IMAGE_PROFILE`: The terminal profile to use for ChatGPT image commands (default: `ChatGptImage`).
- `CHATGPT_IMAGE_DIR`: Directory to save screenshots (default: `C:\Users\<YourUsername>\.chatgpt-cli\images`).
- `DEFAULT_TERMINAL_PROFILE`: The default terminal profile (default: `Windows PowerShell`).

## Usage

1. Ensure that all prerequisites are installed and configured.
2. Run the script using AutoHotkey v2.
3. Use the hotkeys to interact with ChatGPT or manage screenshots.

## Notes

- The script dynamically resolves user profile paths using the `A_UserProfile` variable, making it adaptable to any Windows user.
- Ensure that the `chatgpt-cli` and `magick` commands are accessible from the terminal.