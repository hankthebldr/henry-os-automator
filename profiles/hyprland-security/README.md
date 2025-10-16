# Secure Minimal Desktop Environment

A comprehensive setup script for an immersive, minimal, and security-focused desktop environment using Hyprland, Waybar, and hardened system configurations.

## Features

### Desktop Environment
- **Hyprland**: Modern Wayland compositor with smooth animations
- **Waybar**: Minimal status bar with system monitoring
- **Kitty**: GPU-accelerated terminal with security features
- **Wofi**: Application launcher
- **Swaylock**: Secure screen locker with visual effects
- **Dunst**: Lightweight notification daemon

### Security Features
- **UFW Firewall**: Properly configured with rate limiting
- **Fail2ban**: Intrusion prevention system
- **AppArmor**: Mandatory access control
- **Firejail**: Application sandboxing
- **System Hardening**: Kernel parameters optimized for security
- **Privacy Tools**: Clipboard clearing, history management

### Privacy Enhancements
- Firefox with privacy-hardened configuration
- SSH client hardening
- DNS over TLS
- Environment variables to disable telemetry
- Automatic privacy cleanup scripts

## Installation

### Prerequisites
- Debian/Ubuntu, Arch/Manjaro, or Fedora-based system
- sudo privileges
- Active internet connection

### Quick Start

```bash
cd ~/Github
chmod +x secure-desktop-setup.sh
./secure-desktop-setup.sh
```

### Manual Step-by-Step

1. **Run the main installer**:
   ```bash
   ./secure-desktop-setup.sh
   ```

2. **Apply security configurations**:
   ```bash
   ~/.config/security/setup-all.sh
   ```

3. **Apply privacy configurations**:
   ```bash
   ~/.config/privacy/setup-all.sh
   ```

4. **Set up themes**:
   ```bash
   ~/.config/wallpapers/generate-minimal-wallpaper.sh
   ~/.config/theme/gtk-setup.sh
   ~/.config/theme/cursor-setup.sh
   ```

5. **Reboot and select Hyprland** from your display manager

## Configuration Structure

```
~/
├── .config/
│   ├── hypr/              # Hyprland configuration
│   ├── waybar/            # Status bar config and styles
│   ├── kitty/             # Terminal configuration
│   ├── wofi/              # Application launcher
│   ├── dunst/             # Notifications
│   ├── swaylock/          # Screen locker
│   ├── security/          # Security scripts and configs
│   ├── privacy/           # Privacy-focused configs
│   ├── wallpapers/        # Wallpaper generation
│   └── theme/             # GTK and cursor themes
```

## Key Bindings

### Window Management
- `Super + Enter`: Launch terminal
- `Super + Q`: Close window
- `Super + D`: Application launcher
- `Super + F`: Fullscreen
- `Super + V`: Toggle floating
- `Super + Arrow Keys`: Move focus
- `Super + Shift + Arrow Keys`: Move window
- `Super + 1-0`: Switch workspace
- `Super + Shift + 1-0`: Move window to workspace

### Security & Privacy
- `Super + L`: Lock screen
- `Super + Shift + L`: Lock and suspend
- `Super + Shift + Delete`: Clear clipboard
- `Print`: Screenshot to clipboard
- `Shift + Print`: Screenshot to file

### System
- `XF86AudioRaiseVolume/LowerVolume`: Volume control
- `XF86MonBrightnessUp/Down`: Brightness control

## Security Scripts

### Check Security Status
```bash
~/.config/security/security-check.sh
```

### Run System Audit
```bash
sudo lynis audit system
```

### Check for Rootkits
```bash
sudo rkhunter --check
```

### Privacy Cleanup
```bash
~/.config/security/privacy-cleanup.sh
```

## Customization

### Colors
Edit color schemes in:
- Hyprland: `~/.config/hypr/hyprland.conf`
- Waybar: `~/.config/waybar/style.css`
- Kitty: `~/.config/kitty/kitty.conf`

### Security Levels
Adjust security settings in:
- Firewall: `~/.config/security/ufw-setup.sh`
- System hardening: `~/.config/security/system-hardening.sh`
- SSH: `~/.config/privacy/ssh-hardening.sh`

## Maintenance

### Daily Tasks
- Automatic privacy cleanup (2 AM via cron)
- Monitor firewall logs: `sudo ufw status verbose`

### Weekly Tasks
- Security status check (Sunday 3 AM via cron)
- Review fail2ban logs: `sudo fail2ban-client status`

### Monthly Tasks
- Update system: `sudo apt update && sudo apt upgrade`
- Run full security audit: `sudo lynis audit system`
- Check for rootkits: `sudo rkhunter --check`

## Recommended Additional Software

### Password Management
- KeePassXC (local password manager)
- Bitwarden (cloud-based option)

### Privacy Tools
- Tor Browser (anonymous browsing)
- ProtonVPN or Mullvad (VPN services)
- Signal (encrypted messaging)

### Security Tools
- ClamAV (antivirus)
- rkhunter (rootkit scanner)
- lynis (security auditing)

## Troubleshooting

### Hyprland won't start
- Check logs: `journalctl -xe`
- Verify graphics drivers are installed
- Ensure Wayland is supported

### Waybar not showing
- Check if waybar is running: `pgrep waybar`
- Restart: `killall waybar && waybar &`

### Screen lock issues
- Test swaylock: `swaylock -f`
- Check swayidle: `pgrep swayidle`

### Firewall blocking legitimate traffic
- Check rules: `sudo ufw status numbered`
- Allow specific port: `sudo ufw allow PORT/tcp`

## Security Considerations

### What This Setup Does
- Hardens network stack against common attacks
- Implements least-privilege principles
- Sandboxes applications with Firejail
- Monitors for intrusion attempts
- Clears sensitive data automatically
- Encrypts DNS queries
- Minimizes telemetry and tracking

### What You Should Do
1. Enable full disk encryption (LUKS)
2. Set strong passwords
3. Keep system updated
4. Review logs regularly
5. Use 2FA where possible
6. Backup important data (encrypted)
7. Use VPN on untrusted networks

### What This Setup Does NOT Do
- Protect against physical access (use FDE)
- Protect against zero-day exploits
- Guarantee anonymity (use Tor for that)
- Replace good security practices

## Resources

- [Hyprland Documentation](https://wiki.hyprland.org/)
- [ArchWiki - Security](https://wiki.archlinux.org/title/Security)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Privacy Guides](https://www.privacyguides.org/)

## License

This configuration is provided as-is for educational and personal use. Modify as needed for your security requirements.

## Contributing

Feel free to submit issues or improvements. Security is a continuous process, and community input is valuable.

## Disclaimer

This setup provides a strong security baseline but is not a complete security solution. No system is 100% secure. Always follow security best practices and keep your system updated.
