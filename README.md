<div align="center">
  <img src="https://img.shields.io/badge/VPS_superScript-blue?style=for-the-badge&logo=shield" alt="VPS_superScript" />
  <h1>🦅 VPS_superScript | Premium Edition V1.0.0</h1>
  <p><b>The ultimate, lightning-fast, and beautiful terminal UI manager for VPN tunneling, protocol deployments, and advanced user administration on Linux servers.</b></p>
  
  <img src="https://img.shields.io/badge/platform-linux-lightgrey?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/bash-%3E%3D4.0-yellow?style=flat-square&logo=gnu-bash" alt="Bash">
  <img src="https://img.shields.io/badge/version-Premium%20V1.0.0-success?style=flat-square" alt="Version">
</div>

---

## ✨ Why VPS_superScript?

VPS_superScript is built with an **obsessive focus on speed, fluidity, and aesthetics**. We took the traditional chunky script and refined it into a gorgeous, highly responsive, and relentlessly efficient terminal experience.

Whether you're managing 5 users or 500, deploying complex protocols, or locking down your server traffic—you can do it all in seconds, with zero frustration.

---

## 🚀 Installation

It takes less than a minute to deploy the complete VPS_superScript Manager on your fresh VPS.

### Primary Method (Recommended)
```bash
bash <(curl -Ls https://github.com/SONICE-ENCHIL/VPS_superScript-Revamp/raw/main/install.sh)
```

> **🔄 Upgrading from an existing FirewallFalcon or skylartech-manager installation?**  
> The installer automatically detects your old setup and safely migrates all data — users & passwords, bandwidth logs, SSL certificates, banners, trial accounts, HWID/ZiVPN locks, DNSTT keys, state flags, and backups — to the new VPS_superScript paths. Nothing is lost. For skylartech the import runs once on the first install and never overwrites existing VPS_superScript accounts, and your old `/etc/skylartech` data is left intact as a fallback.

*(Once installed, simply type `menu` in your terminal to launch the interface!)*

---

## 🌟 Elite Features

### 👤 Hyper-Optimized User Management
* **Batch Operations Engine:** Delete, Lock, Unlock, or Renew multiple users simultaneously. You can type `1 3 5` or ranges like `1-4` to execute massive operations in the blink of an eye.
* **Smart UI Selection:** Automatically detects your user count. If you have fewer than 15 active users, it dynamically skips the search prompt to save you keystrokes.
* **Agile Creation:** Bulk string generation with instant preset defaults (`Enter` for 30 Days, unlimited Bandwidth, 1 Device Connection).
* **Temporary Trial Accounts:** Instantly spin up self-destructing trial accounts spanning 1, 2, 6, 12, or 24 hours (powered autonomously by the `at` daemon).

### 🛠️ One-Click VPN & Protocol Deployers
Easily spin up entire tunneling infrastructures onto your server without touching a single complex config file.
* **BadVPN (UDP Gateway):** Optimize gaming and tunneling packets.
* **UDP Custom:** Manage customizable UDP bypasses.
* **SSL Tunnels:** HAProxy payload routing on port 443/80.
* **Nginx Reverse Proxy:** Full HTTP/HTTPS webserver installer, featuring **Auto-Certbot integration** for free SSL certificates.
* **DNSTT (SlowDNS):** Bypass heavy firewalls through port 53 DNS records.
* **Falcon Proxy:** Setup and customize version-controlled Websocket/Socks proxies.
* **ZiVPN (UDP):** Accelerated custom UDP handling.
* **3X-UI / X-UI Web Panel:** One-click installer with a chooser menu — 3X-UI (recommended) or legacy X-UI.

### 📊 Advanced Quotas & Network Safety
* **Strict Bandwidth Limiting:** Assign gigabyte allowances (e.g., 50GB) upon creation. Background services will safely and automatically lock users who exceed their usage.
* **Active Connection Limits:** Curb account sharing by enforcing per-account concurrent session limits — the most reliable way to stop one account being used on many devices at once. *(Session counting is strongest on SSH; pair it with one account per device for dependable control.)*
* **Device Locking (HWID):** Optionally pin an account to specific device IDs. Enforcement is **best-effort and reactive** — it reads the VPN service logs and can only verify a device when the protocol actually reports one, so it **cannot** stop a decrypted or shared config on protocols that don't. The secure default drops strict connections it can't verify; see the in-menu notes. For dependable device control, rely on connection limits + per-device accounts rather than HWID alone.
* **Live Traffic Monitor:** Check high-speed Bash network tracking (or install `vnstat` for persistent metrics).
* **Content Filtering:** Block torrent traffic and adult content with iptables string matching — no extra dependencies.
* **Custom Blocklists:** Add your own domains and keywords to the content filter with a simple config file.

### 🎨 Beautiful SSH Customization
* **Dynamic Login Banners:** Overrides the default SSH `sshd_config` to inject an intelligent script. 
* When your users connect via an HTTP injector or SSH tunnel app, they are greeted by a beautiful customized text box detailing their exact:
  * Expiry Date
  * Quota Remaining
  * Real-Time Active Connections

### 💾 Backup & Restore Stability
* Automatically collect your payload records, user databases, TLS certificates, and bandwidth usage statistics into single portable `.tar.gz` archives. Restore entire businesses onto a new server with one menu click.

---

## 🖥️ Preview

```
          VPS_superScript | Premium Edition V1.0.0
   ─────────────────────────────────────────────────────
   ◦ Base   Ubuntu 22.04           ◦ Load   0.21
   ◦ CPU'S  2                      ◦ Domain vpn.example.com
   ◦ Users  30 Managed             ◦ UpTime 10 days, 2h
   ◦ IP     203.0.113.42           ◦ OS     Ubuntu 22.04
   ·····················································
   ·              🔧 ACTIVE SERVICES               ·
   ·····················································
   ·  ◦ SSH:           22         ◦ SSL (HAProxy): 80, 443  ·
   ·  ◦ ZiVPN:         5667       ◦ UDP-Custom:   36712    ·
   ·  ◦ BadVPN:        7300       ◦ DNSTT:        53      ·
   ·····················································
```

---

## 💬 Community & Support

* Maintained by **VPS_superScript (SONICE-ENCHIL)**
* For issues, suggestions, or contributions — open an issue on GitHub.

---

<div align="center">
  <b>Built by VPS_superScript</b><br>
  <i>"Fast configuration, Secure tunneling, Beautiful interfaces."</i>
</div>
