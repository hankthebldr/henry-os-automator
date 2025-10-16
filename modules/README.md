# Modules System

Modules are reusable, composable components that can be shared across different profiles.

## Module Structure

```
modules/
├── shell/
│   ├── bash/
│   ├── zsh/
│   └── common/
├── editors/
│   ├── vim/
│   ├── neovim/
│   └── vscode/
├── development/
│   ├── git/
│   ├── docker/
│   ├── languages/
│   └── ai-tools/
├── system/
│   ├── optimizations/
│   ├── monitoring/
│   └── performance/
├── security/
│   ├── firewall/
│   ├── apparmor/
│   └── hardening/
└── ai-ml/
    ├── llm/
    ├── rag/
    └── vector-db/
```

## Module Definition

Each module contains:
- `module.yaml` - Metadata and configuration
- `install.sh` - Installation script
- `configure.sh` - Configuration script
- `verify.sh` - Verification checks
- `files/` - Configuration files to deploy
- `templates/` - Template files

## Module YAML Format

```yaml
name: module-name
version: 1.0.0
description: Module description
author: Henry
dependencies:
  - required-module-1
  - required-module-2
compatible_os:
  - ubuntu
  - debian
  - arch
tags: [shell, productivity]
variables:
  var_name:
    type: string
    default: "value"
    description: "Variable description"
files:
  - src: files/.bashrc
    dest: ~/.bashrc
    backup: true
  - src: files/.bash_aliases
    dest: ~/.bash_aliases
tasks:
  pre_install: scripts/pre-install.sh
  install: install.sh
  configure: configure.sh
  post_install: scripts/post-install.sh
  verify: verify.sh
```

## Using Modules

Modules are referenced in profile configurations and automatically
resolved with their dependencies.

Example from profile:
```yaml
modules:
  - shell-bash
  - editor-neovim
  - git-config
  - system-optimizations
```

The orchestrator will:
1. Resolve dependencies
2. Check compatibility
3. Execute in correct order
4. Track installation state
