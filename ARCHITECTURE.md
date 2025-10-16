# Henry's OS Automator - Architecture

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         HENRY'S OS AUTOMATOR                                │
│                    Modular OS Configuration Framework                       │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              USER INTERFACE                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│   │   setup.sh   │  │   --list     │  │ --profile    │  │  --verify    │  │
│   │ Interactive  │  │   Profiles   │  │   Direct     │  │    State     │  │
│   └──────┬───────┘  └──────────────┘  └──────┬───────┘  └──────────────┘  │
│          │                                    │                             │
└──────────┼────────────────────────────────────┼─────────────────────────────┘
           │                                    │
           ▼                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           CORE ORCHESTRATOR                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │                    core/orchestrator.sh                            │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  • Module Discovery         • YAML Parsing                         │   │
│  │  • Dependency Resolution    • Execution Engine                     │   │
│  │  • State Management         • Verification Framework               │   │
│  │  • Backup/Rollback         • Progress Tracking                     │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │                      core/utils.sh                                 │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │  • Logging (log_info, log_error, log_success)                     │   │
│  │  • OS Detection (get_os_info, get_os_version)                     │   │
│  │  • Package Management (install_package, install_packages)          │   │
│  │  • File Operations (safe_copy, safe_symlink, backup_path)         │   │
│  │  • User Interaction (confirm, show_progress, show_banner)         │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
           │                                    │
           ▼                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          PROFILE SYSTEM                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐         │
│  │  hyprland-       │  │  parrot-         │  │  ubuntu-dev      │         │
│  │  security        │  │  security-       │  │                  │         │
│  │                  │  │  enhanced        │  │                  │         │
│  ├──────────────────┤  ├──────────────────┤  ├──────────────────┤         │
│  │ • Minimal        │  │ • Preserves      │  │ • Full Stack     │         │
│  │   Wayland        │  │   Parrot OS      │  │ • Containers     │         │
│  │ • Security       │  │ • MATE Desktop   │  │ • Languages      │         │
│  │   Hardened       │  │ • Security       │  │ • AI Tools       │         │
│  │ • Privacy        │  │   Enhanced       │  │                  │         │
│  │   Focused        │  │ • Bash Only      │  │                  │         │
│  └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘         │
│           │                     │                      │                   │
│           └─────────────────────┼──────────────────────┘                   │
│                                 │                                          │
│                                 ▼                                          │
│                        ┌─────────────────┐                                 │
│                        │  profile.yaml   │                                 │
│                        ├─────────────────┤                                 │
│                        │ • Metadata      │                                 │
│                        │ • Modules       │                                 │
│                        │ • Phases        │                                 │
│                        │ • Options       │                                 │
│                        │ • Verification  │                                 │
│                        └────────┬────────┘                                 │
└─────────────────────────────────┼──────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          MODULE SYSTEM                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐  ┌────────────┐  │
│  │    shell/     │  │   editors/    │  │ development/  │  │  system/   │  │
│  ├───────────────┤  ├───────────────┤  ├───────────────┤  ├────────────┤  │
│  │ • bash        │  │ • vim         │  │ • git         │  │ • monitoring│ │
│  │ • zsh         │  │ • neovim      │  │ • tmux        │  │ • optimization││
│  │ • modern-cli  │  │ • vscode      │  │ • docker      │  │ • performance││
│  └───────────────┘  └───────────────┘  └───────────────┘  └────────────┘  │
│                                                                             │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐  ┌────────────┐  │
│  │  security/    │  │    ai-ml/     │  │  languages/   │  │   fonts/   │  │
│  ├───────────────┤  ├───────────────┤  ├───────────────┤  ├────────────┤  │
│  │ • firewall    │  │ • llm         │  │ • python      │  │ • nerd-fonts│ │
│  │ • ids         │  │ • rag         │  │ • nodejs      │  │ • icons    │  │
│  │ • apparmor    │  │ • vector-db   │  │ • rust        │  │ • emoji    │  │
│  └───────────────┘  └───────────────┘  └───────────────┘  └────────────┘  │
│                                                                             │
│                        Each Module Contains:                                │
│                  ┌──────────────────────────────┐                          │
│                  │ module.yaml   - Definition   │                          │
│                  │ install.sh    - Installation │                          │
│                  │ configure.sh  - Configuration│                          │
│                  │ verify.sh     - Verification │                          │
│                  │ files/        - Config files │                          │
│                  └──────────────────────────────┘                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                      DEPENDENCY RESOLUTION                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│              Module A (requires B, C) ──┐                                   │
│                                         │                                   │
│              Module B (requires C) ─────┼──► Resolution Graph              │
│                                         │                                   │
│              Module C (standalone) ─────┘                                   │
│                                                                             │
│              Execution Order: C → B → A                                     │
│                                                                             │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │  Algorithm: Topological Sort with Circular Dependency Detection    │   │
│  │  • Build dependency graph                                          │   │
│  │  • Detect circular dependencies                                    │   │
│  │  • Resolve in correct order                                        │   │
│  │  • Skip already installed (idempotent)                             │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        STATE MANAGEMENT                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ~/.henry-automator/                                                        │
│  ├── state/                                                                 │
│  │   ├── installed.json          ◄─── Global installation state            │
│  │   └── modules/                                                          │
│  │       ├── shell-bash.json     ◄─── Per-module state                    │
│  │       ├── editor-neovim.json                                            │
│  │       └── ...                                                           │
│  │                                                                          │
│  ├── logs/                                                                  │
│  │   └── install.log             ◄─── Installation logs                   │
│  │                                                                          │
│  └── backups/                                                               │
│      └── YYYYMMDD-HHMMSS/        ◄─── Timestamped config backups          │
│          ├── .bashrc                                                        │
│          ├── .gitconfig                                                    │
│          └── ...                                                           │
│                                                                             │
│  State Format (JSON):                                                       │
│  {                                                                          │
│    "profile": "parrot-security-enhanced",                                   │
│    "installed_at": "2025-10-15T10:30:00Z",                                  │
│    "modules": {                                                             │
│      "shell-bash": {"version": "1.0.0", "installed": true}                  │
│    }                                                                        │
│  }                                                                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    DOT-FILES INTEGRATION                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  /home/henry/Github/dot-files  ──────┐                                     │
│  ├── shell/                           │                                     │
│  │   ├── bash/                        │                                     │
│  │   │   ├── .bashrc             ────┼──► Mapped to module: shell-bash    │
│  │   │   ├── .bash_aliases       ────┤                                     │
│  │   │   └── security-aliases.sh ────┤                                     │
│  │   └── zsh/                         │                                     │
│  │       └── .zshrc               ────┼──► Mapped to module: shell-zsh     │
│  │                                     │                                     │
│  ├── editors/                          │                                     │
│  │   ├── vim/.vimrc              ────┼──► Mapped to module: editor-vim     │
│  │   └── nvim/init.vim           ────┼──► Mapped to module: editor-neovim  │
│  │                                     │                                     │
│  ├── git/                              │                                     │
│  │   ├── .gitconfig              ────┼──► Mapped to module: dev-git        │
│  │   └── .gitignore_global       ────┤                                     │
│  │                                     │                                     │
│  ├── configs/                          │                                     │
│  │   ├── sysctl-optimizations    ────┼──► Mapped to: sys-optimizations    │
│  │   └── LLM_RAG_SETUP.md        ────┼──► Mapped to: ai-rag-stack         │
│  │                                     │                                     │
│  └── DOTFILES_MODULE_INDEX.md    ────┴──► Complete mapping documentation   │
│                                                                             │
│  All 20+ markdown files indexed and mapped to modules                      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    EXECUTION FLOW                                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. User Invocation                                                         │
│     └─► ./setup.sh --profile parrot-security-enhanced                      │
│                                                                             │
│  2. Profile Loading                                                         │
│     └─► Parse profiles/parrot-security-enhanced/profile.yaml               │
│         ├─► Extract module list                                            │
│         ├─► Extract configuration options                                  │
│         └─► Extract installation phases                                    │
│                                                                             │
│  3. Dependency Resolution                                                   │
│     └─► For each module:                                                    │
│         ├─► Load module.yaml                                               │
│         ├─► Extract dependencies                                           │
│         ├─► Build dependency graph                                         │
│         └─► Create installation order (topological sort)                   │
│                                                                             │
│  4. Pre-Installation                                                        │
│     └─► Check OS compatibility                                             │
│         ├─► Verify system requirements                                     │
│         ├─► Create state directory                                         │
│         └─► Backup existing configurations                                 │
│                                                                             │
│  5. Module Installation (in dependency order)                               │
│     └─► For each module:                                                    │
│         ├─► Check if already installed (skip if yes)                       │
│         ├─► Execute pre_install script                                     │
│         ├─► Execute install script                                         │
│         ├─► Deploy configuration files                                     │
│         ├─► Execute configure script                                       │
│         ├─► Execute post_install script                                    │
│         ├─► Execute verify script                                          │
│         └─► Update state (mark as installed)                               │
│                                                                             │
│  6. Profile Configuration                                                   │
│     └─► Execute profile-specific phases:                                   │
│         ├─► Phase 1: System foundation                                     │
│         ├─► Phase 2: System optimizations                                  │
│         ├─► Phase 3: Shell environment                                     │
│         ├─► Phase 4: Development tools                                     │
│         └─► ... (profile-defined phases)                                   │
│                                                                             │
│  7. Verification                                                            │
│     └─► Run verification checks:                                           │
│         ├─► Module-level checks                                            │
│         ├─► Profile-level checks                                           │
│         └─► Generate installation report                                   │
│                                                                             │
│  8. Finalization                                                            │
│     └─► Update global state                                                │
│         ├─► Generate summary report                                        │
│         ├─► Display next steps                                             │
│         └─► Save installation log                                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    TARGET SYSTEM CONFIGURATION                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    Hardware Specifications                          │   │
│  ├─────────────────────────────────────────────────────────────────────┤   │
│  │  CPU:     AMD Ryzen 9 7945HX (16 cores, 32 threads, 5.461GHz)      │   │
│  │  RAM:     62GB                                                      │   │
│  │  Storage: Crucial T700 NVMe SSDs (1.8TB + 931GB)                   │   │
│  │  FS:      Btrfs (with compression, CoW, snapshots)                 │   │
│  │  GPU:     AMD Radeon (integrated)                                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                  Operating System (Primary)                         │   │
│  ├─────────────────────────────────────────────────────────────────────┤   │
│  │  OS:      Parrot Security 6.4 (lorikeet)                           │   │
│  │  Base:    Debian 12 (Bookworm)                                     │   │
│  │  Kernel:  6.12.12-amd64                                            │   │
│  │  Desktop: MATE 1.26.0                                              │   │
│  │  Shell:   bash 5.2.15 (default)                                    │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    Optimizations Applied                            │   │
│  ├─────────────────────────────────────────────────────────────────────┤   │
│  │  CPU:     Performance governor, MAKEFLAGS=-j32                     │   │
│  │  Memory:  Swappiness=10, BBR congestion control                    │   │
│  │  I/O:     NVMe scheduler=none, Btrfs noatime+zstd                 │   │
│  │  Network: BBR, 128MB buffers, TCP Fast Open                       │   │
│  │  Fonts:   JetBrainsMono Nerd Font, Papirus Dark icons             │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

```

## Component Relationships

```
┌────────────────┐
│   setup.sh     │
│  (Entry Point) │
└───────┬────────┘
        │
        ├─► Loads: core/utils.sh
        ├─► Loads: core/orchestrator.sh
        │
        ▼
┌────────────────┐
│   Profile      │◄───────── config/profiles.yaml (Registry)
│   Selection    │
└───────┬────────┘
        │
        ▼
┌────────────────┐
│   Profile      │
│   YAML Parser  │
└───────┬────────┘
        │
        ├─► Extracts: modules[]
        ├─► Extracts: phases[]
        ├─► Extracts: options{}
        │
        ▼
┌────────────────┐
│   Dependency   │
│   Resolver     │
└───────┬────────┘
        │
        ├─► Builds: Dependency Graph
        ├─► Detects: Circular Dependencies
        ├─► Creates: Execution Order
        │
        ▼
┌────────────────┐
│   Module       │
│   Executor     │
└───────┬────────┘
        │
        ├─► Runs: pre_install
        ├─► Runs: install
        ├─► Deploys: files
        ├─► Runs: configure
        ├─► Runs: post_install
        ├─► Runs: verify
        │
        ▼
┌────────────────┐
│   State        │
│   Manager      │
└───────┬────────┘
        │
        ├─► Updates: installed.json
        ├─► Creates: Backups
        ├─► Tracks: Module state
        │
        ▼
┌────────────────┐
│  Verification  │
│  Framework     │
└───────┬────────┘
        │
        └─► Reports: Installation status
```

## Data Flow

```
User Input ──► Profile Selection ──► YAML Parsing ──► Module List

                                          │
                                          ▼
                                   Dependency Graph
                                          │
                                          ▼
                            ┌─────────────┴─────────────┐
                            │                           │
                            ▼                           ▼
                    Module Installation         State Updates
                            │                           │
                            │                           ▼
                            │                   JSON State Files
                            │                           │
                            ▼                           │
                    File Deployment ◄───────────────────┘
                            │
                            ▼
                    Configuration
                            │
                            ▼
                    Verification
                            │
                            ▼
                    Completion Report
```

## Key Design Patterns

### 1. Module Pattern
- Self-contained, reusable components
- Clear interface (install, configure, verify)
- YAML-based metadata

### 2. Dependency Injection
- Modules declare dependencies
- Orchestrator resolves and injects

### 3. State Management
- JSON-based state tracking
- Idempotent operations
- Rollback capability

### 4. Strategy Pattern
- Different profiles for different use cases
- Profile-specific execution strategies

### 5. Template Method
- Common installation workflow
- Profile-specific implementations

## Technology Stack

```
┌─────────────────────────────────────┐
│ Language: Bash Shell Script         │
│ Version:  5.2+                      │
└─────────────────────────────────────┘
         │
         ├─► YAML: Python3 PyYAML
         ├─► JSON: Python3 json
         ├─► Utils: coreutils, findutils
         └─► VCS: Git

┌─────────────────────────────────────┐
│ Dependencies:                        │
├─────────────────────────────────────┤
│ • bash      (>= 5.0)                │
│ • python3   (>= 3.9)                │
│ • git       (any recent)            │
│ • curl/wget (for downloads)         │
│ • sudo      (for system changes)    │
└─────────────────────────────────────┘
```

---

**Architecture Version**: 2.0
**Last Updated**: 2025-10-15
**Author**: Henry
**Repository**: https://github.com/hankthebldr/henry-os-automator
