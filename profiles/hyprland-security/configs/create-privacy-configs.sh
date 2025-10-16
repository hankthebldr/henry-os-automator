#!/bin/bash
# Privacy-Focused Application Configurations

echo "Creating privacy-focused application configs..."

# Firefox user.js for enhanced privacy
mkdir -p "$HOME/.config/privacy"

cat > "$HOME/.config/privacy/firefox-user.js" << 'EOF'
// Firefox Privacy Configuration
// Copy to: ~/.mozilla/firefox/YOUR_PROFILE/user.js

// Disable telemetry
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);

// Disable studies and experiments
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

// Disable Pocket
user_pref("extensions.pocket.enabled", false);

// Disable sponsored content
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Enhanced tracking protection
user_pref("browser.contentblocking.category", "strict");
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);

// Cookies
user_pref("network.cookie.cookieBehavior", 5);
user_pref("network.cookie.lifetimePolicy", 2);

// DNS over HTTPS
user_pref("network.trr.mode", 3);
user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");

// WebRTC privacy
user_pref("media.peerconnection.enabled", false);
user_pref("media.peerconnection.ice.no_host", true);
user_pref("media.peerconnection.ice.default_address_only", true);

// Referer control
user_pref("network.http.referer.XOriginPolicy", 2);
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

// Disable beacon API
user_pref("beacon.enabled", false);

// Geolocation
user_pref("geo.enabled", false);

// Camera and microphone
user_pref("media.navigator.enabled", false);

// WebGL
user_pref("webgl.disabled", true);

// Font fingerprinting
user_pref("browser.display.use_document_fonts", 0);

// Clear on shutdown
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.cookies", true);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.sessions", true);

// Disable prefetch
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.predictor.enabled", false);

// HTTPS only mode
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);

// Resist fingerprinting
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.resistFingerprinting.letterboxing", true);
EOF

cat > "$HOME/.config/privacy/firefox-setup.sh" << 'EOF'
#!/bin/bash
# Firefox Privacy Setup

echo "Setting up Firefox privacy configuration..."

# Find Firefox profile directory
FIREFOX_PROFILE=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.default*" | head -n 1)

if [ -z "$FIREFOX_PROFILE" ]; then
    echo "Firefox profile not found. Please run Firefox once to create a profile."
    echo "Then copy ~/.config/privacy/firefox-user.js to your profile directory."
else
    echo "Found Firefox profile: $FIREFOX_PROFILE"
    cp "$HOME/.config/privacy/firefox-user.js" "$FIREFOX_PROFILE/user.js"
    echo "Privacy configuration applied to Firefox profile"
fi

echo ""
echo "Recommended Firefox extensions:"
echo "  - uBlock Origin (ad/tracker blocker)"
echo "  - Privacy Badger (tracker blocker)"
echo "  - HTTPS Everywhere (force HTTPS)"
echo "  - Multi-Account Containers (isolate browsing)"
echo "  - ClearURLs (remove tracking parameters)"
EOF

chmod +x "$HOME/.config/privacy/firefox-setup.sh"

# Git privacy configuration
cat > "$HOME/.config/privacy/git-setup.sh" << 'EOF'
#!/bin/bash
# Git Privacy Configuration

echo "Configuring Git for privacy..."

# Use SSH instead of HTTPS
git config --global url."git@github.com:".insteadOf "https://github.com/"

# Sign commits (if GPG key exists)
if gpg --list-secret-keys --keyid-format LONG | grep -q "sec"; then
    GPG_KEY=$(gpg --list-secret-keys --keyid-format LONG | grep sec | head -n1 | awk '{print $2}' | cut -d'/' -f2)
    git config --global user.signingkey "$GPG_KEY"
    git config --global commit.gpgsign true
    echo "GPG commit signing enabled"
else
    echo "No GPG key found. Create one with: gpg --full-generate-key"
fi

# Privacy-focused settings
git config --global core.autocrlf input
git config --global init.defaultBranch main

echo "Git privacy configuration complete"
EOF

chmod +x "$HOME/.config/privacy/git-setup.sh"

# SSH hardening
cat > "$HOME/.config/privacy/ssh-hardening.sh" << 'EOF'
#!/bin/bash
# SSH Client Hardening

echo "Hardening SSH configuration..."

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Create secure SSH config
cat > "$HOME/.ssh/config" << 'SSHCONFIG'
# SSH Client Configuration - Security Hardened

# Global settings
Host *
    # Use only strong key exchange algorithms
    KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512

    # Use only strong ciphers
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

    # Use only strong MACs
    MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256

    # Use only strong host key algorithms
    HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256

    # Disable roaming (security vulnerability)
    UseRoaming no

    # Hash known hosts for privacy
    HashKnownHosts yes

    # Verify host keys
    StrictHostKeyChecking ask

    # Disable forwarding by default
    ForwardAgent no
    ForwardX11 no

    # Connection settings
    ServerAliveInterval 60
    ServerAliveCountMax 3

    # Compression
    Compression yes

    # Control master for performance
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
SSHCONFIG

chmod 600 "$HOME/.ssh/config"

# Create sockets directory for ControlMaster
mkdir -p "$HOME/.ssh/sockets"
chmod 700 "$HOME/.ssh/sockets"

echo "SSH client hardened"
echo "Generate ED25519 key with: ssh-keygen -t ed25519 -C 'your_email@example.com'"
EOF

chmod +x "$HOME/.config/privacy/ssh-hardening.sh"

# Environment variables for privacy
cat > "$HOME/.config/privacy/env-setup.sh" << 'EOF'
#!/bin/bash
# Privacy-focused environment variables

# Add to ~/.bashrc or ~/.zshrc:
cat >> "$HOME/.bashrc" << 'BASHRC'

# Privacy-focused environment variables
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# Less history
export LESSHISTFILE=/dev/null

# Python don't write bytecode
export PYTHONDONTWRITEBYTECODE=1

# Node.js disable telemetry
export NEXT_TELEMETRY_DISABLED=1
export GATSBY_TELEMETRY_DISABLED=1

# Dotnet disable telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Powershell disable telemetry
export POWERSHELL_TELEMETRY_OPTOUT=1
BASHRC

source "$HOME/.bashrc"

echo "Privacy environment variables configured"
echo "Restart your shell or run: source ~/.bashrc"
EOF

chmod +x "$HOME/.config/privacy/env-setup.sh"

# DNS privacy (systemd-resolved)
cat > "$HOME/.config/privacy/dns-privacy.sh" << 'EOF'
#!/bin/bash
# DNS Privacy Configuration

echo "Configuring DNS privacy..."

# Configure systemd-resolved for DNS over TLS
sudo mkdir -p /etc/systemd/resolved.conf.d

sudo tee /etc/systemd/resolved.conf.d/dns-privacy.conf > /dev/null << 'RESOLVED'
[Resolve]
DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001
FallbackDNS=9.9.9.9 149.112.112.112 2620:fe::fe 2620:fe::9
DNSOverTLS=yes
DNSSEC=yes
Cache=yes
RESOLVED

sudo systemctl restart systemd-resolved

echo "DNS privacy configured (Cloudflare with DNS-over-TLS)"
echo "Verify with: resolvectl status"
EOF

chmod +x "$HOME/.config/privacy/dns-privacy.sh"

# Master privacy setup
cat > "$HOME/.config/privacy/setup-all.sh" << 'EOF'
#!/bin/bash
# Master Privacy Setup

echo "Running all privacy configurations..."

"$HOME/.config/privacy/firefox-setup.sh"
"$HOME/.config/privacy/git-setup.sh"
"$HOME/.config/privacy/ssh-hardening.sh"
"$HOME/.config/privacy/env-setup.sh"

echo ""
echo "Privacy configuration complete!"
echo ""
echo "Additional recommendations:"
echo "  1. Use a password manager (KeePassXC, Bitwarden)"
echo "  2. Enable full disk encryption (LUKS)"
echo "  3. Use VPN or Tor for sensitive browsing"
echo "  4. Regular backups with encryption"
echo "  5. Review application permissions regularly"
echo ""
echo "Optional: Run DNS privacy setup (requires sudo):"
echo "  $HOME/.config/privacy/dns-privacy.sh"
EOF

chmod +x "$HOME/.config/privacy/setup-all.sh"

echo -e "${GREEN}✓ Privacy configurations created${NC}"
