#!/bin/bash
# Security Configuration - Hardening & Privacy Tools

echo "Creating security configurations..."

# Create security config directory
mkdir -p "$HOME/.config/security"

# UFW security rules
cat > "$HOME/.config/security/ufw-setup.sh" << 'EOF'
#!/bin/bash
# UFW Firewall Configuration

echo "Configuring UFW firewall..."

# Reset to defaults
sudo ufw --force reset

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw default deny routed

# Rate limiting for SSH (prevent brute force)
sudo ufw limit 22/tcp comment 'SSH rate limit'

# Allow mDNS (for local network discovery if needed)
# sudo ufw allow 5353/udp comment 'mDNS'

# Deny all other incoming
sudo ufw deny in from any

# Enable logging
sudo ufw logging medium

# Enable firewall
sudo ufw --force enable

echo "UFW configuration complete. Status:"
sudo ufw status verbose
EOF

chmod +x "$HOME/.config/security/ufw-setup.sh"

# Fail2ban configuration
cat > "$HOME/.config/security/fail2ban-jail.local" << 'EOF'
[DEFAULT]
# Ban settings
bantime  = 1h
findtime = 10m
maxretry = 5
banaction = ufw

# Email alerts (configure if needed)
# destemail = your-email@example.com
# sendername = Fail2Ban
# action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
bantime = 24h

[sshd-ddos]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 10
findtime = 60
bantime = 1h
EOF

cat > "$HOME/.config/security/install-fail2ban.sh" << 'EOF'
#!/bin/bash
echo "Installing fail2ban configuration..."
sudo cp "$HOME/.config/security/fail2ban-jail.local" /etc/fail2ban/jail.local
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban
echo "Fail2ban configured and started"
EOF

chmod +x "$HOME/.config/security/install-fail2ban.sh"

# AppArmor profiles
cat > "$HOME/.config/security/apparmor-setup.sh" << 'EOF'
#!/bin/bash
# AppArmor Configuration

echo "Configuring AppArmor..."

# Enable AppArmor
sudo systemctl enable apparmor
sudo systemctl start apparmor

# Set all profiles to enforce mode
sudo aa-enforce /etc/apparmor.d/*

# Check status
sudo aa-status

echo "AppArmor configuration complete"
EOF

chmod +x "$HOME/.config/security/apparmor-setup.sh"

# Firejail profiles for common applications
cat > "$HOME/.config/security/firejail-apps.sh" << 'EOF'
#!/bin/bash
# Firejail Sandboxing Setup

echo "Setting up Firejail sandboxing..."

# Create firejail local profiles directory
mkdir -p "$HOME/.config/firejail"

# Firefox profile (enhanced privacy)
cat > "$HOME/.config/firejail/firefox.local" << 'FIREFOX'
# Firefox local profile
private-dev
private-tmp
whitelist ${DOWNLOADS}
whitelist ~/.mozilla
read-only ${HOME}
noexec ${HOME}
FIREFOX

# Generic browser profile
cat > "$HOME/.config/firejail/browser.profile" << 'BROWSER'
# Generic browser security profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp
BROWSER

echo "Firejail profiles created"
echo "Usage: firejail --apparmor firefox"
EOF

chmod +x "$HOME/.config/security/firejail-apps.sh"

# System hardening script
cat > "$HOME/.config/security/system-hardening.sh" << 'EOF'
#!/bin/bash
# System Security Hardening

echo "Applying system hardening..."

# Kernel hardening via sysctl
sudo tee /etc/sysctl.d/99-security.conf > /dev/null << 'SYSCTL'
# IP Forwarding (disable unless needed for routing)
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0

# Syn flood protection
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_max_syn_backlog = 4096

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Disable redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Enable reverse path filtering
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Log suspicious packets
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# Ignore ICMP ping requests (optional, may break some tools)
# net.ipv4.icmp_echo_ignore_all = 1

# Ignore ICMP broadcast
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Protect against TCP time-wait assassination
net.ipv4.tcp_rfc1337 = 1

# Kernel hardening
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.yama.ptrace_scope = 2
kernel.unprivileged_bpf_disabled = 1
net.core.bpf_jit_harden = 2

# File system hardening
fs.protected_symlinks = 1
fs.protected_hardlinks = 1
fs.protected_fifos = 2
fs.protected_regular = 2
fs.suid_dumpable = 0
SYSCTL

sudo sysctl -p /etc/sysctl.d/99-security.conf

echo "System hardening applied"
EOF

chmod +x "$HOME/.config/security/system-hardening.sh"

# Privacy cleanup script
cat > "$HOME/.config/security/privacy-cleanup.sh" << 'EOF'
#!/bin/bash
# Privacy Cleanup Script

echo "Running privacy cleanup..."

# Clear bash history (optional)
# history -c
# cat /dev/null > ~/.bash_history

# Clear systemd journal (keep last 3 days)
sudo journalctl --vacuum-time=3d

# Clear old temporary files
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Clear thumbnail cache
rm -rf ~/.cache/thumbnails/*

# Clear clipboard
wl-copy -c

# Clear recent files (GNOME)
rm -f ~/.local/share/recently-used.xbel

# Clear trash
rm -rf ~/.local/share/Trash/*

echo "Privacy cleanup complete"
EOF

chmod +x "$HOME/.config/security/privacy-cleanup.sh"

# Security monitoring script
cat > "$HOME/.config/security/security-check.sh" << 'EOF'
#!/bin/bash
# Security Status Check

echo "═══════════════════════════════════════"
echo "  Security Status Check"
echo "═══════════════════════════════════════"

echo -e "\n[1] Firewall Status:"
sudo ufw status verbose

echo -e "\n[2] Fail2ban Status:"
sudo fail2ban-client status

echo -e "\n[3] AppArmor Status:"
sudo aa-status --summary

echo -e "\n[4] Active Network Connections:"
ss -tunap | grep ESTABLISHED | head -n 10

echo -e "\n[5] Failed Login Attempts (last 10):"
sudo grep "Failed password" /var/log/auth.log | tail -n 10

echo -e "\n[6] Last Logins:"
last -n 10

echo -e "\n[7] Listening Services:"
sudo ss -tulpn | grep LISTEN

echo -e "\n[8] Check for Rootkits (quick):"
echo "Run: sudo rkhunter --check --skip-keypress"

echo -e "\n[9] System Audit:"
echo "Run: sudo lynis audit system"

echo -e "\n═══════════════════════════════════════"
EOF

chmod +x "$HOME/.config/security/security-check.sh"

# Master security setup script
cat > "$HOME/.config/security/setup-all.sh" << 'EOF'
#!/bin/bash
# Master Security Setup

echo "Running all security configurations..."

"$HOME/.config/security/ufw-setup.sh"
"$HOME/.config/security/install-fail2ban.sh"
"$HOME/.config/security/apparmor-setup.sh"
"$HOME/.config/security/firejail-apps.sh"
"$HOME/.config/security/system-hardening.sh"

echo ""
echo "Security configuration complete!"
echo "Run '$HOME/.config/security/security-check.sh' to verify"
EOF

chmod +x "$HOME/.config/security/setup-all.sh"

# Create cron job for regular security checks
cat > "$HOME/.config/security/install-cron.sh" << 'EOF'
#!/bin/bash
# Install security monitoring cron jobs

echo "Installing security cron jobs..."

# Add to user crontab
(crontab -l 2>/dev/null; echo "# Security checks") | crontab -
(crontab -l 2>/dev/null; echo "0 2 * * * $HOME/.config/security/privacy-cleanup.sh >> $HOME/.config/security/cleanup.log 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "0 3 * * 0 $HOME/.config/security/security-check.sh >> $HOME/.config/security/security-check.log 2>&1") | crontab -

echo "Cron jobs installed"
echo "Daily privacy cleanup at 2 AM"
echo "Weekly security check on Sunday at 3 AM"
EOF

chmod +x "$HOME/.config/security/install-cron.sh"

echo -e "${GREEN}✓ Security configurations created${NC}"
echo -e "${YELLOW}Run: ~/.config/security/setup-all.sh to apply all security settings${NC}"
