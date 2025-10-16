# Parrot Security - Maximum Optimized Profile

Complete system configuration for Parrot Security 6.4 with maximum performance, security hardening, and AI/ML capabilities.

## Target System

- **OS**: Parrot Security 6.4 (Debian-based)
- **CPU**: AMD Ryzen 9 7945HX (16 cores, 32 threads, up to 5.461GHz)
- **RAM**: 62GB
- **Storage**: Crucial T700 NVMe SSDs (Btrfs filesystem)
- **Desktop**: MATE 1.26.0 (minimal configuration)

## What Gets Installed

### System Foundation
- **Monitoring Tools**: btop, nvtop, iotop, ncdu, nvme-cli, smartmontools
- **Modern CLI**: bat, exa, fd-find, ripgrep, fzf, tldr
- **Build Tools**: Essential development packages

### System Optimizations
- **Memory**: Swappiness 10, optimized cache pressure
- **Network**: BBR congestion control, increased buffers
- **CPU**: Performance governor, 32-thread parallel builds
- **NVMe**: Optimized I/O schedulers
- **Btrfs**: Compression, noatime, automated scrubbing

### Shell Environment
- **ZSH**: With Oh-My-Zsh, autosuggestions, syntax highlighting
- **Bash**: Enhanced with modern aliases (fallback)
- **Features**: Git-aware prompt, modern CLI aliases, MAKEFLAGS=-j32

### Development Tools
- **Git**: 50+ productivity aliases, global gitignore
- **Tmux**: Mouse support, plugin manager, custom key bindings
- **Neovim**: LSP support, modern plugins, language servers
- **Docker**: Containerization with Docker Compose
- **Kubernetes**: kubectl, k9s, helm

### Programming Languages
- **Python**: pyenv, pip, pipenv, poetry, pyright LSP
- **Node.js**: nvm, npm, yarn, pnpm, typescript-server
- **Rust**: rustc, cargo, rust-analyzer
- **Go**: go, gopls

### Security Hardening
- **Firewall**: UFW with rate limiting
- **IDS**: Fail2ban intrusion detection
- **MAC**: AppArmor mandatory access control
- **Audit**: lynis, rkhunter, clamav
- **SSH**: Hardened configuration
- **Updates**: Automatic security patches

### AI/ML Stack
- **LLM Inference**: Ollama, llama.cpp (32-thread optimized)
- **RAG Frameworks**: LangChain, LlamaIndex
- **Vector Databases**: ChromaDB, Qdrant support
- **Embeddings**: Sentence Transformers
- **AI CLI Tools**: Claude CLI, GitHub Copilot, Aider, Starship

## Installation

### Quick Start

```bash
cd ~/Github/henry-os-automator
./setup.sh --profile parrot-optimized
```

### Or directly:

```bash
cd profiles/parrot-optimized
./install-complete.sh
```

## Installation Phases

The installation is broken into cumulative phases:

1. **System Foundation** (10 min)
   - Package installation
   - Monitoring tools

2. **System Optimizations** (5 min)
   - Kernel tuning
   - Performance optimizations

3. **Shell Environment** (5 min)
   - ZSH/Bash configuration
   - Modern CLI setup

4. **Development Tools** (10 min)
   - Git, Tmux, Neovim
   - Docker, Kubernetes

5. **Programming Languages** (15 min)
   - Python, Node.js, Rust, Go
   - Language servers

6. **Security Hardening** (10 min)
   - Firewall, Fail2ban, AppArmor
   - Security audit tools

7. **AI/ML Stack** (20-40 min)
   - Ollama, llama.cpp
   - RAG frameworks
   - AI CLI tools

8. **Performance Tuning** (5 min)
   - Final optimizations
   - Automation setup

9. **Post-Install** (5 min)
   - Verification
   - Report generation

**Total Time**: 85-105 minutes (depending on AI/ML stack)

## Verification

After installation, verify your setup:

```bash
# System info
neofetch

# Monitoring
btop          # System resources
nvtop         # GPU usage
sudo iotop    # I/O usage

# Optimizations
sysctl vm.swappiness                    # Should be: 10
sysctl net.ipv4.tcp_congestion_control  # Should be: bbr
echo $MAKEFLAGS                         # Should be: -j32

# Development
git --version
nvim --version
docker --version

# Security
sudo ufw status verbose
systemctl status fail2ban
sudo aa-status

# AI/ML (if installed)
ollama --version
python3 -c "import langchain; print('LangChain OK')"
```

## Quick Reference

### System Monitoring
```bash
btop                                    # Resource monitor
nvtop                                   # GPU monitor
sudo iotop                              # I/O monitor
ncdu /                                  # Disk usage
sudo nvme smart-log /dev/nvme0n1        # NVMe health
```

### Shell & CLI
```bash
ls          # aliased to exa (colorful, icons)
cat         # aliased to bat (syntax highlighting)
find        # use fd instead (faster)
grep        # use rg (ripgrep) instead
fzf         # fuzzy finder
```

### Development
```bash
# Git
git st                  # status
git co <branch>         # checkout
git aliases             # list all aliases

# Tmux
tmux                    # start session
Ctrl+a                  # prefix key
Ctrl+a d                # detach
Ctrl+a Shift+I          # install plugins

# Neovim
nvim                    # start editor
:PlugInstall            # install plugins
```

### AI/ML
```bash
# Ollama
ollama pull llama3.1:8b
ollama run llama3.1:8b
ollama serve            # API server on :11434

# LangChain RAG
python3 ~/.config/ai-tools/rag_example.py

# Claude CLI
claude "your prompt"

# GitHub Copilot
?? "how to find large files"
git? "undo last commit"
```

## Configuration Files

### Shell
- `~/.zshrc` - ZSH configuration
- `~/.bashrc` - Bash configuration
- `~/.bash_aliases` - Bash aliases

### Development
- `~/.gitconfig` - Git configuration
- `~/.tmux.conf` - Tmux configuration
- `~/.config/nvim/init.vim` - Neovim configuration

### System
- `/etc/sysctl.d/99-custom.conf` - Kernel parameters
- `/etc/default/cpufrequtils` - CPU governor
- `/etc/udev/rules.d/60-ioschedulers.rules` - I/O schedulers

### AI/ML
- `~/.config/ai-tools/` - AI tool configurations
- `~/.config/ai-tools/api-keys.sh` - API keys (gitignored)

## Performance Benchmarks

Expected performance on AMD Ryzen 9 7945HX with 62GB RAM:

### CPU
- Max frequency: 5.461GHz
- Parallel jobs: 32 threads
- Context switches: <1000/sec

### Memory
- Swappiness: 10 (minimal swapping with 62GB)
- Cache pressure: 50 (optimized for filesystem operations)
- Available: >10GB free during normal operations

### Storage (NVMe)
- I/O scheduler: none (optimal for NVMe)
- Read/Write: ~12GB/s (Crucial T700)
- Latency: <100μs

### Network
- Congestion control: BBR
- Buffer sizes: 128MB
- TCP Fast Open: Enabled

## Maintenance

### Daily
```bash
# Update packages
sudo apt update && sudo apt upgrade

# Check security logs
sudo journalctl -u fail2ban --since today

# Monitor resources
btop
```

### Weekly
```bash
# Security scan
sudo lynis audit system

# Check for rootkits
sudo rkhunter --check

# Review failed logins
sudo lastb | head -20
```

### Monthly
```bash
# Btrfs scrub (automated via systemd timer)
sudo btrfs scrub status /

# Full backup
~/.henry-automator/scripts/backup-config.sh

# Update AI models
ollama pull llama3.1:8b
```

## Customization

### Local Overrides

Create local override files that won't be tracked:

```bash
# Shell
touch ~/.zshrc.local
touch ~/.bashrc.local

# Git
touch ~/.gitconfig.local

# Neovim
touch ~/.config/nvim/local.vim
```

### API Keys

Configure AI tool API keys:

```bash
# Create API keys file
cat > ~/.config/ai-tools/api-keys.sh << 'EOF'
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export GOOGLE_API_KEY="..."
EOF

chmod 600 ~/.config/ai-tools/api-keys.sh

# Add to shell rc
echo '[ -f ~/.config/ai-tools/api-keys.sh ] && source ~/.config/ai-tools/api-keys.sh' >> ~/.zshrc
```

## Troubleshooting

### Installation Failed

Check logs:
```bash
cat ~/.henry-automator/logs/install.log
```

### System Not Optimized

Verify sysctl:
```bash
sudo sysctl --system
sysctl -a | grep -E "vm.swappiness|net.ipv4.tcp_congestion"
```

### AI/ML Not Working

Check Ollama:
```bash
systemctl status ollama
journalctl -u ollama -f
```

Test LangChain:
```bash
python3 -c "import langchain; print('OK')"
```

## Resources

### Documentation
- [System Optimizations](~/Github/dot-files/configs/SYSTEM_OPTIMIZATIONS.md)
- [LLM/RAG Setup](~/Github/dot-files/configs/LLM_RAG_SETUP.md)
- [Module Index](../../DOTFILES_MODULE_INDEX.md)

### External Resources
- [Parrot Security Docs](https://www.parrotsec.org/docs/)
- [Ollama](https://ollama.com)
- [LangChain](https://python.langchain.com)
- [Neovim](https://neovim.io)

## Support

This is a personal automation system derived from:
- `/home/henry/Github/dot-files` - Original configurations
- `/home/henry/Github/henry-os-automator` - Automation framework

Issues and improvements welcome!

---

**Built for Henry by Henry** 🛠️

*Last updated: 2025-10-15*
