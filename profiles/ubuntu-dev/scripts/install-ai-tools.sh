#!/bin/bash
# Install AI-powered CLI tools for development

set -euo pipefail

source "$(dirname "$0")/../../../../core/utils.sh"

log_step "Installing AI-powered development tools"

# Warp Terminal (AI-powered terminal)
install_warp() {
    log_info "Installing Warp Terminal..."

    if command_exists warp-terminal; then
        log_success "Warp already installed"
        return 0
    fi

    case $(get_os_info) in
        ubuntu|debian)
            # Download and install Warp .deb
            WARP_URL="https://releases.warp.dev/stable/v0.2024.10.29.08.02.stable_00/warp-terminal_0.2024.10.29.08.02.stable.00_amd64.deb"
            TMP_FILE="/tmp/warp-terminal.deb"

            if download_file "$WARP_URL" "$TMP_FILE"; then
                sudo dpkg -i "$TMP_FILE" || sudo apt install -f -y
                rm "$TMP_FILE"
                log_success "Warp Terminal installed"
            else
                log_warn "Failed to install Warp Terminal"
            fi
            ;;
        *)
            log_warn "Warp Terminal not available for this OS"
            ;;
    esac
}

# Claude CLI (Anthropic Claude)
install_claude_cli() {
    log_info "Installing Claude CLI..."

    if command_exists claude; then
        log_success "Claude CLI already installed"
        return 0
    fi

    # Install via npm
    if command_exists npm; then
        npm install -g @anthropic-ai/claude-cli || log_warn "Claude CLI installation failed"
        log_success "Claude CLI installed"
    else
        log_warn "npm not found, skipping Claude CLI"
    fi
}

# GitHub Copilot CLI
install_copilot_cli() {
    log_info "Installing GitHub Copilot CLI..."

    if command_exists github-copilot-cli; then
        log_success "GitHub Copilot CLI already installed"
        return 0
    fi

    # Install via npm
    if command_exists npm; then
        npm install -g @githubnext/github-copilot-cli
        log_success "GitHub Copilot CLI installed"
        log_info "Run 'github-copilot-cli auth' to authenticate"
    else
        log_warn "npm not found, skipping Copilot CLI"
    fi
}

# Aider (AI pair programming)
install_aider() {
    log_info "Installing Aider..."

    if command_exists aider; then
        log_success "Aider already installed"
        return 0
    fi

    # Install via pip
    if command_exists pip3; then
        pip3 install --user aider-chat
        log_success "Aider installed"
        log_info "Set ANTHROPIC_API_KEY or OPENAI_API_KEY to use Aider"
    else
        log_warn "pip3 not found, skipping Aider"
    fi
}

# Google Gemini CLI (via Google Cloud SDK)
install_gemini_cli() {
    log_info "Installing Google Gemini CLI support..."

    if command_exists gcloud; then
        log_success "Google Cloud SDK already installed (includes Gemini API support)"
        return 0
    fi

    case $(get_os_info) in
        ubuntu|debian)
            # Add Google Cloud SDK repo
            echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
                sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

            curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
                sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

            sudo apt update
            sudo apt install -y google-cloud-cli

            # Install Python client for Gemini
            pip3 install --user google-generativeai

            log_success "Google Cloud SDK installed (Gemini API available)"
            log_info "Run 'gcloud init' to configure"
            ;;
        *)
            log_warn "Automated installation not available for this OS"
            log_info "Install from: https://cloud.google.com/sdk/docs/install"
            ;;
    esac
}

# Cursor AI Editor
install_cursor() {
    log_info "Installing Cursor AI Editor..."

    if command_exists cursor; then
        log_success "Cursor already installed"
        return 0
    fi

    case $(get_os_info) in
        ubuntu|debian)
            # Download Cursor AppImage
            CURSOR_URL="https://downloader.cursor.sh/linux/appImage/x64"
            mkdir -p "$HOME/.local/bin"
            CURSOR_PATH="$HOME/.local/bin/cursor"

            if download_file "$CURSOR_URL" "$CURSOR_PATH"; then
                chmod +x "$CURSOR_PATH"
                log_success "Cursor installed to $CURSOR_PATH"
            else
                log_warn "Failed to install Cursor"
            fi
            ;;
        *)
            log_warn "Cursor automated installation not available for this OS"
            log_info "Download from: https://cursor.sh"
            ;;
    esac
}

# Starship prompt (cross-shell)
install_starship() {
    log_info "Installing Starship prompt..."

    if command_exists starship; then
        log_success "Starship already installed"
        return 0
    fi

    curl -sS https://starship.rs/install.sh | sh -s -- -y
    log_success "Starship installed"

    # Add to shell configs
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "starship init" "$HOME/.bashrc"; then
            echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
        fi
    fi

    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "starship init" "$HOME/.zshrc"; then
            echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
        fi
    fi
}

# Main installation based on options
AI_TOOLS="${AI_TOOLS:-warp-terminal,claude-cli,github-copilot,aider}"

if [[ "$AI_TOOLS" == *"all"* ]]; then
    install_warp
    install_claude_cli
    install_copilot_cli
    install_aider
    install_gemini_cli
    install_cursor
    install_starship
elif [[ "$AI_TOOLS" != *"none"* ]]; then
    [[ "$AI_TOOLS" == *"warp-terminal"* ]] && install_warp
    [[ "$AI_TOOLS" == *"claude-cli"* ]] && install_claude_cli
    [[ "$AI_TOOLS" == *"github-copilot"* ]] && install_copilot_cli
    [[ "$AI_TOOLS" == *"aider"* ]] && install_aider
    [[ "$AI_TOOLS" == *"gemini"* ]] && install_gemini_cli
    [[ "$AI_TOOLS" == *"cursor"* ]] && install_cursor

    # Always install starship if any AI tools are selected
    install_starship
fi

log_success "AI tools installation complete"

# Create AI tools config directory
mkdir -p "$HOME/.config/ai-tools"

# Create quick reference guide
cat > "$HOME/.config/ai-tools/README.md" << 'EOF'
# AI Development Tools - Quick Reference

## Installed Tools

### Warp Terminal
AI-powered terminal with intelligent completions and workflows.
- Launch: `warp-terminal`
- Features: AI command search, workflow automation

### Claude CLI
Anthropic's Claude AI in your terminal.
- Usage: `claude "your prompt"`
- Set API key: `export ANTHROPIC_API_KEY=your_key`
- Config: `~/.config/claude/config.json`

### GitHub Copilot CLI
GitHub Copilot for command line.
- Auth: `github-copilot-cli auth`
- Explain: `?? "how to find large files"`
- Git: `git? "undo last commit"`
- General: `gh? "port 8080 process"`

### Aider
AI pair programming in your terminal.
- Start: `aider`
- With files: `aider file1.py file2.py`
- Models: Claude, GPT-4, GPT-3.5
- Config: Set ANTHROPIC_API_KEY or OPENAI_API_KEY

### Google Gemini
Access via Google Cloud SDK and Python client.
```python
import google.generativeai as genai
genai.configure(api_key='YOUR_API_KEY')
model = genai.GenerativeModel('gemini-pro')
response = model.generate_content("Your prompt")
```

### Cursor
AI-powered code editor (fork of VS Code).
- Launch: `cursor`
- Features: AI code completion, chat, edit

### Starship
Beautiful, fast, cross-shell prompt.
- Config: `~/.config/starship.toml`
- Presets: `starship preset bracketed-segments -o ~/.config/starship.toml`

## API Keys Setup

Create `~/.config/ai-tools/api-keys.sh`:

```bash
# Anthropic Claude
export ANTHROPIC_API_KEY="sk-ant-..."

# OpenAI
export OPENAI_API_KEY="sk-..."

# Google Gemini
export GOOGLE_API_KEY="..."
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/credentials.json"
```

Add to shell rc:
```bash
[ -f ~/.config/ai-tools/api-keys.sh ] && source ~/.config/ai-tools/api-keys.sh
```

## Best Practices

1. **Never commit API keys** - Use environment variables
2. **Use .env files** for project-specific keys
3. **Set usage limits** in API dashboards
4. **Review AI suggestions** before accepting
5. **Keep tools updated** - `npm update -g` for CLI tools

## Resources

- Claude: https://claude.ai
- Copilot: https://github.com/features/copilot
- Aider: https://aider.chat
- Gemini: https://ai.google.dev
- Cursor: https://cursor.sh
- Starship: https://starship.rs
EOF

log_info "Created AI tools reference: ~/.config/ai-tools/README.md"
log_success "All AI development tools configured!"
