# Henry's OS Automator

An extensible, modular system for end-to-end operating system setup and configuration automation. Built to support multiple operating systems, use cases, and deployment scenarios with a focus on security, privacy, and developer productivity.

## Philosophy

This automation framework is designed to:
- **Be Modular**: Each OS/use-case is a self-contained profile
- **Be Extensible**: Easy to add new profiles and configurations
- **Be Repeatable**: Same setup every time, anywhere
- **Be Secure**: Security and privacy built-in from the ground up
- **Be User-Specific**: Tailored configurations for Henry's workflows

## Supported Profiles

### Current Profiles

1. **Hyprland Security Desktop** (Debian/Ubuntu/Arch)
   - Minimal, immersive Wayland desktop
   - Security-hardened (UFW, Fail2ban, AppArmor)
   - Privacy-focused configurations
   - Status: ✅ Complete

### Planned Profiles

2. **Parrot Security Workstation**
   - Penetration testing and security research
   - Pre-configured tools and workflows
   - Defensive security focus
   - Status: 🚧 Planned

3. **Ubuntu Development Environment**
   - Full-stack development setup
   - Docker, Kubernetes, cloud tools
   - IDE and editor configurations
   - Status: 🚧 Planned

4. **Minimal Server**
   - Headless server configuration
   - Docker-based services
   - Automated updates and monitoring
   - Status: 🚧 Planned

## Quick Start

### Interactive Setup (Recommended)

```bash
git clone https://github.com/YOUR_USERNAME/henry-os-automator.git
cd henry-os-automator
./setup.sh
```

Follow the interactive prompts to select your profile and options.

### Direct Profile Installation

```bash
./setup.sh --profile hyprland-security
./setup.sh --profile parrot-security
./setup.sh --profile ubuntu-dev
```

### Non-Interactive (CI/CD)

```bash
./setup.sh --profile hyprland-security --non-interactive --config ./my-config.yaml
```

## Architecture

```
henry-os-automator/
├── setup.sh                    # Main orchestrator
├── core/                       # Core utilities and functions
│   ├── detect.sh              # OS/environment detection
│   ├── utils.sh               # Common utilities
│   ├── logging.sh             # Logging framework
│   └── validate.sh            # Configuration validation
├── profiles/                   # Profile definitions
│   ├── hyprland-security/     # Hyprland secure desktop
│   ├── parrot-security/       # Parrot security workstation
│   ├── ubuntu-dev/            # Ubuntu development
│   └── minimal-server/        # Minimal server setup
├── modules/                    # Reusable modules
│   ├── security/              # Security configurations
│   ├── privacy/               # Privacy tools
│   ├── desktop/               # Desktop environments
│   ├── development/           # Dev tools
│   └── containers/            # Docker/K8s
├── config/                     # Configuration files
│   ├── profiles.yaml          # Profile definitions
│   ├── modules.yaml           # Module registry
│   └── defaults.yaml          # Default settings
└── state/                      # State management
    ├── installed.json         # What's installed
    └── config-backup/         # Config backups
```

## Profile Structure

Each profile is self-contained:

```
profiles/hyprland-security/
├── profile.yaml               # Profile metadata
├── install.sh                 # Installation script
├── configs/                   # Configuration files
│   ├── hypr/
│   ├── waybar/
│   └── kitty/
├── scripts/                   # Profile-specific scripts
│   ├── security-setup.sh
│   └── privacy-setup.sh
└── README.md                  # Profile documentation
```

## Module System

Modules are reusable components that can be shared across profiles:

```yaml
# Example: Security hardening module
name: security-hardening
version: 1.0.0
dependencies:
  - ufw
  - fail2ban
  - apparmor
compatible_os:
  - ubuntu
  - debian
  - arch
scripts:
  pre_install: scripts/pre-security.sh
  install: scripts/install-security.sh
  configure: scripts/configure-security.sh
  verify: scripts/verify-security.sh
```

## Configuration Management

### State Tracking

The system tracks what's installed and configured:

```json
{
  "profile": "hyprland-security",
  "installed_at": "2025-10-15T10:30:00Z",
  "modules": {
    "security-hardening": {
      "version": "1.0.0",
      "installed": true,
      "configured": true
    }
  },
  "os": {
    "distro": "ubuntu",
    "version": "24.04"
  }
}
```

### Idempotency

All scripts are idempotent - safe to run multiple times:
- Check before install
- Skip if already configured
- Update if configuration changed

### Rollback Support

```bash
./setup.sh --rollback
./setup.sh --restore-backup 2025-10-15-backup
```

## Advanced Usage

### Custom Profiles

Create your own profile:

```bash
./setup.sh --create-profile my-custom-setup
```

Edit the generated profile and install:

```bash
./setup.sh --profile my-custom-setup
```

### Selective Module Installation

```bash
./setup.sh --profile hyprland-security --modules security,privacy --skip desktop
```

### Dry Run

See what would be installed without making changes:

```bash
./setup.sh --profile hyprland-security --dry-run
```

### Update Existing Installation

```bash
./setup.sh --update
```

## Security Features

- **Firewall Configuration**: UFW with strict rules
- **Intrusion Detection**: Fail2ban monitoring
- **Mandatory Access Control**: AppArmor profiles
- **Application Sandboxing**: Firejail integration
- **System Hardening**: Kernel parameter tuning
- **Privacy Tools**: DNS-over-TLS, tracker blocking
- **Secure Defaults**: Everything locked down by default

## Development Workflow

### Adding a New Profile

1. Create profile directory: `profiles/new-profile/`
2. Define `profile.yaml`
3. Write `install.sh`
4. Add configurations in `configs/`
5. Test thoroughly
6. Document in profile `README.md`
7. Update main README

### Testing

```bash
# Run in Docker container
./test-profile.sh hyprland-security ubuntu:24.04

# Run in VM
./test-profile.sh --vm hyprland-security
```

### Contributing

This is a personal automation system, but principles can be shared:
1. Keep profiles self-contained
2. Make scripts idempotent
3. Document everything
4. Test on fresh installs
5. Security first

## Roadmap

### Phase 1: Core Infrastructure (Current)
- [x] Basic profile system
- [x] Hyprland security profile
- [ ] Module system
- [ ] State management
- [ ] Rollback support

### Phase 2: Additional Profiles
- [ ] Parrot Security setup
- [ ] Ubuntu development environment
- [ ] Minimal server configuration
- [ ] MacOS development setup

### Phase 3: Advanced Features
- [ ] Web UI for configuration
- [ ] Remote deployment
- [ ] Ansible integration
- [ ] Cloud provisioning
- [ ] Multi-machine orchestration

### Phase 4: Intelligence
- [ ] Auto-detection of needed tools
- [ ] Recommendation engine
- [ ] Performance optimization
- [ ] Security scanning integration

## Philosophy & Design Decisions

### Why Not Ansible/Chef/Puppet?

- **Simplicity**: Bash scripts are universal and transparent
- **Learning**: Understanding exactly what's configured
- **Customization**: Easy to modify for personal needs
- **Portability**: No dependencies beyond bash and git

### Why State Management?

- Know what's installed
- Enable updates and rollbacks
- Prevent configuration drift
- Support partial installations

### Why Modular?

- Reuse across profiles
- Test components independently
- Share common configurations
- Easier maintenance

## Maintenance

### Updating the System

```bash
cd henry-os-automator
git pull
./setup.sh --update --profile current
```

### Backing Up Configurations

```bash
./setup.sh --backup
```

### Cleaning Up

```bash
./setup.sh --clean
```

## Troubleshooting

### Installation Failed

Check logs:
```bash
cat ~/.henry-automator/logs/install.log
```

### Configuration Issues

Verify state:
```bash
./setup.sh --verify
```

### Rollback

```bash
./setup.sh --rollback
```

## Requirements

- Bash 4.0+
- Git
- sudo access
- Internet connection
- 10GB free disk space (varies by profile)

## License

Personal use. Principles and ideas are free to share.

## Support

This is a personal project. No official support, but issues and improvements are welcome.

---

**Built with ❤️ by Henry for Henry**

*Last updated: 2025-10-15*
