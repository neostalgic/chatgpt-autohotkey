# ChatGPT AutoHotkey w/t Image Context

This script provides hotkey-based automation for interacting with ChatGPT and the Windows Terminal. It uses the snipping tool and `ImageMagick` to take screenshots and pipe the output to `chatgpt-cli`.

[![Demonstration](https://omni-strapi-assets.nyc3.digitaloceanspaces.com/1744474173_2810aec55a.png)](https://omni-strapi-assets.nyc3.digitaloceanspaces.com/2025_04_12_11_58_28_05b412e458.mp4)

## Features 
- Hotkey: Open a terminal window
- Hotkey: Open an interactive LLM prompt
- Hotkey: Take a screenshot with the snipping tool and pipe the output to an interactive LLM prompt 

## Prerequisites

1. **Install AutoHotkey**
   - Download AutoHotkey and install AutoHotkey from its [official website](https://www.autohotkey.com/).

2. **Install `chatgpt-cli`**
   - Follow the installation instructions for `chatgpt-cli` from its [official repository](https://github.com/kardolus/chatgpt-cli). 
   - Ensure that the binary file for `chatgpt-cli` is named `chatgpt` and is available in your APTH environment variable.
   - Ensure you setup `OPEN_API_KEY` as an environment variable. 

3. **Install `ImageMagick`**
   - Download and install ImageMagick from [https://imagemagick.org](https://imagemagick.org).
   - Ensure that the `magick` command is available in your system's PATH.

4. **Configure a `prompt.md` File**
   - Create a `prompt.md` file in the `.chatgpt-cli` directory under your user profile (e.g., `C:\Users\<YourUsername>\.chatgpt-cli\prompt.md`).
   - See the `sample_prompt.md` in this repo.

5. **(Optional) Add Windows Terminal profiles for ChatGPT**
   - For the best looking result, add two new profiles to Windows Terminal: `ChatGPT` and `ChatGPTImage`. You can configure the appearance of these any way you'd like.

## Usage
*Note: Ensure that you do not run this script from a sandboxed folder. Backup folders like OneDrive seem to cause issues with the ability for executables to be read off the PATH.*

1. Ensure that all prerequisites are installed and configured.
2. Run the script using AutoHotkey v2 (usually just double-click in explorer)
3. Use the hotkeys to interact with ChatGPT or manage screenshots.

Images will be created under `C:\Users\<YourUsername>\.chatgpt-cli\images\`. You may want to clean these out from-time-to-time.

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
