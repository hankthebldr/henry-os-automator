# Dot-Files Module Index

Complete index of all modules extracted from `/home/henry/Github/dot-files`

## Module Mapping

### Shell Configurations

| Module ID | Source | Description | Status |
|-----------|--------|-------------|--------|
| `shell-bash` | `/dot-files/shell/bash/` | Bash with modern CLI tools, 32-thread optimized | Ready |
| `shell-zsh` | `/dot-files/shell/zsh/` | ZSH with Oh-My-Zsh, plugins, optimizations | Ready |

**Documentation:**
- `shell/bash/BASH_CONFIG.md`
- `shell/zsh/ZSH_CONFIG.md`

**Features:**
- Modern CLI tool aliases (bat, exa, fd, ripgrep)
- Git-aware prompts
- 32-thread parallel build configuration (`MAKEFLAGS=-j32`)
- Custom aliases and functions
- Local override support

---

### Editors

| Module ID | Source | Description | Status |
|-----------|--------|-------------|--------|
| `editor-vim` | `/dot-files/editors/vim/` | Vim with plugins and configurations | Ready |
| `editor-neovim` | `/dot-files/editors/nvim/` | Neovim with LSP, modern plugins | Ready |

**Documentation:**
- `editors/vim/VIM_CONFIG.md`
- `editors/nvim/NEOVIM_CONFIG.md`

**Features:**
- Plugin management (vim-plug)
- LSP support (Neovim)
- Syntax highlighting
- Auto-completion
- Custom keybindings

---

### Development Tools

| Module ID | Source | Description | Status |
|-----------|--------|-------------|--------|
| `dev-git` | `/dot-files/git/` | Git configuration with 50+ aliases | Ready |
| `dev-tmux` | `/dot-files/tools/` | Tmux with plugins and mouse support | Ready |

**Documentation:**
- `git/GIT_CONFIG.md`
- `tools/TMUX_CONFIG.md`

**Features - Git:**
- 50+ productivity aliases
- Global gitignore
- User configuration
- Local override support

**Features - Tmux:**
- Mouse support
- Custom key bindings
- Plugin manager (TPM)
- Status bar configuration

---

### System Optimizations

| Module ID | Source | Description | Status |
|-----------|--------|-------------|--------|
| `sys-optimizations` | `/dot-files/configs/` | Sysctl tuning for Ryzen 9 7945HX | Ready |
| `sys-monitoring` | `/dot-files/` | Modern monitoring tools (btop, nvtop, etc.) | Ready |

**Documentation:**
- `configs/SYSTEM_OPTIMIZATIONS.md`
- `INSTALL_TOOLS.md`

**Features - Optimizations:**
- Memory management (swappiness, cache pressure)
- Network tuning (BBR, TCP Fast Open)
- NVMe I/O scheduler
- CPU governor configuration
- Btrfs mount options

**Features - Monitoring:**
- btop (modern htop)
- nvtop (GPU monitoring)
- iotop (I/O monitoring)
- ncdu (disk usage)
- nvme-cli (NVMe management)

---

### AI/ML Stack

| Module ID | Source | Description | Status |
|-----------|--------|-------------|--------|
| `ai-llm-setup` | `/dot-files/configs/` | Local LLM inference (Ollama, llama.cpp) | Ready |
| `ai-rag-stack` | `/dot-files/configs/` | RAG implementation (LangChain, ChromaDB) | Ready |

**Documentation:**
- `configs/LLM_RAG_SETUP.md`
- `LLM_SECURITY_RESOURCES.md`
- `LINUX_AI_TOOLS.md`

**Features - LLM:**
- Ollama installation and configuration
- llama.cpp compilation (32-thread optimized)
- Model management
- API server setup
- CPU affinity optimization

**Features - RAG:**
- Vector databases (ChromaDB, Qdrant, Milvus)
- Embedding models (Sentence Transformers)
- RAG frameworks (LangChain, LlamaIndex)
- Complete example implementations
- Performance tuning for 62GB RAM system

---

### Security & Privacy

| Module ID | Source | Description | Status |
|-----------|--------|-------------|--------|
| `sec-firewall` | Integrated | UFW firewall configuration | From automator |
| `sec-apparmor` | Integrated | AppArmor profiles | From automator |
| `sec-fail2ban` | Integrated | Intrusion prevention | From automator |

**Source:** Already implemented in `henry-os-automator/profiles/hyprland-security`

---

### Additional Documented Strategies

| Module ID | Source | Description | Status |
|-----------|--------|-------------|--------|
| `strat-kali-migration` | `configs/KALI_MIGRATION_STRATEGY.md` | Migration from Kali to Parrot | Reference |
| `strat-terminal-awesome` | `configs/AWESOME_TERMINAL_STRATEGY.md` | Terminal enhancement strategy | Reference |
| `strat-firefox-workspace` | `configs/FIREFOX_WORKSPACE_OPTIMIZATION.md` | Firefox workspace optimization | Reference |
| `strat-security-lab` | `configs/SECURITY_LAB_NETWORK_STRATEGY.md` | Security lab network setup | Reference |

---

## Module Dependencies

```
shell-bash
  ├─ sys-monitoring (for modern CLI tools)
  └─ (standalone)

shell-zsh
  ├─ sys-monitoring (for modern CLI tools)
  └─ (requires Oh-My-Zsh)

editor-vim
  └─ (standalone)

editor-neovim
  ├─ (requires neovim package)
  └─ dev-git (optional, for plugin management)

dev-git
  └─ (standalone)

dev-tmux
  └─ (standalone)

sys-optimizations
  └─ (requires sudo, applies system-wide)

sys-monitoring
  └─ (installs packages)

ai-llm-setup
  ├─ sys-optimizations (recommended for performance)
  └─ sys-monitoring (for resource tracking)

ai-rag-stack
  ├─ ai-llm-setup (requires LLM backend)
  └─ (requires Python 3, pip)
```

## Hardware-Specific Optimizations

All modules are optimized for:
- **CPU**: AMD Ryzen 9 7945HX (16 cores, 32 threads, up to 5.461GHz)
- **RAM**: 62GB
- **Storage**: NVMe SSDs (Crucial T700)
- **Filesystem**: Btrfs

## Installation Order (Recommended)

1. **System Foundation**
   - `sys-monitoring` (install tools first)
   - `sys-optimizations` (kernel tuning)

2. **Shell Environment**
   - Choose: `shell-bash` OR `shell-zsh`

3. **Development Tools**
   - `dev-git`
   - `dev-tmux`

4. **Editors**
   - Choose: `editor-vim` AND/OR `editor-neovim`

5. **AI/ML Stack** (Optional)
   - `ai-llm-setup`
   - `ai-rag-stack`

## Quick Setup Examples

### Minimal Developer Setup
```bash
./setup.sh --modules sys-monitoring,shell-bash,dev-git,editor-neovim
```

### Full Stack with AI
```bash
./setup.sh --modules sys-monitoring,sys-optimizations,shell-zsh,dev-git,dev-tmux,editor-neovim,ai-llm-setup,ai-rag-stack
```

### ZSH + Neovim + Git
```bash
./setup.sh --modules shell-zsh,editor-neovim,dev-git
```

## Configuration Files Inventory

### Shell
- `.bashrc`
- `.bash_aliases`
- `.bash_profile`
- `.zshrc`
- Oh-My-Zsh plugins

### Editors
- `.vimrc`
- `~/.config/nvim/init.vim`

### Development
- `.gitconfig`
- `.gitignore_global`
- `.tmux.conf`

### System
- `/etc/sysctl.d/99-custom.conf`
- `/etc/default/cpufrequtils`
- `/etc/udev/rules.d/60-ioschedulers.rules`
- Btrfs mount options in `/etc/fstab`

## State Tracking

All modules track installation state in:
```
~/.henry-automator/state/
├── installed.json
├── modules/
│   ├── shell-bash.json
│   ├── editor-neovim.json
│   └── ...
└── backups/
    └── YYYYMMDD-HHMMSS/
```

## Backup Strategy

Before any module installation:
1. Existing configs are backed up to `~/.henry-automator/backups/`
2. State is recorded in JSON
3. Rollback is available via `./setup.sh --rollback`

## Integration with Profiles

Profiles can reference these modules:

```yaml
# profiles/parrot-dev/profile.yaml
modules:
  - sys-monitoring
  - sys-optimizations
  - shell-zsh
  - dev-git
  - dev-tmux
  - editor-neovim
  - ai-llm-setup
  - ai-rag-stack
```

## Source Repository

Original dot-files: `/home/henry/Github/dot-files`
Integrated into: `/home/henry/Github/henry-os-automator`

All module configurations are derived from the dot-files repository
and adapted for the modular automation framework.
