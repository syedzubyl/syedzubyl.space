+++
title = "Building a Secure Personal NAS with Ubuntu and Cloudflare Tunnel"
date = 2026-07-20
description = "A technical case study on converting an old laptop into a secure, remotely accessible NAS without opening router ports."

[taxonomies]
tags = ["Self-hosting", "Linux", "Networking"]
+++

### The Problem

I wanted a personal Network Attached Storage (NAS) to back up files and access my data remotely from anywhere. The traditional approach involves buying an expensive Synology unit, opening ports on the home router (Port Forwarding), and setting up Dynamic DNS. Opening ports on a home network exposes it to relentless automated scanning and potential attacks.

### Context

I had an older laptop with decent storage and a reliable power supply (built-in battery acts as a UPS!). My goal was to install Ubuntu Server, attach high-capacity SSDs, and securely access the files over the internet using `FileBrowser`, but with absolutely zero open inbound ports on my router.

### What I Tried

I initially looked into setting up OpenVPN or WireGuard on a Raspberry Pi to VPN into my home network.

### What Failed

While VPNs are secure, they add friction. I wanted the ability to access my files seamlessly from any web browser on any device without installing a VPN client first.

### What Worked & Technical Explanation

I implemented an outbound-only tunnel architecture using Cloudflare Zero Trust.

**Architecture Flow:**
```text
Browser → HTTPS → Cloudflare Edge → Cloudflare Tunnel (Outbound) → cloudflared daemon → Local File Browser → SSD
```

**1. Hardware & OS Setup**
I installed Ubuntu Server on the old laptop. To ensure storage reliability, I formatted the external SSDs to `ext4` and mounted them via `/etc/fstab` using their UUIDs, ensuring they always mount to the exact same directory even if USB ports are swapped.

**2. Application Layer**
I installed `FileBrowser`, a lightweight web-based file manager. I configured it to run as a background service managed by `systemd`.

**3. The Network Layer (Cloudflare Tunnel)**
Instead of opening Port 443 on my router, I installed the `cloudflared` daemon on the Ubuntu server. This daemon establishes a secure, outbound connection to Cloudflare's edge network. 

I configured my domain (`nas.mydomain.com`) in Cloudflare to route traffic through this tunnel to the local `localhost:8080` (where FileBrowser was running).

**4. Security**
Because the connection is outbound-only, my home IP address is never exposed to the public internet, and no ports are open. Furthermore, I placed the URL behind Cloudflare Access, requiring a One-Time PIN sent to my email before the tunnel even allows traffic to reach the local server.

### Lessons Learned

Old hardware is incredibly capable if running a lightweight Linux distribution. Furthermore, modern zero-trust networking tools like Cloudflare Tunnels completely change the paradigm of self-hosting. You no longer need to compromise local network security for remote accessibility.

### What I Would Do Differently

I would implement a secondary local backup strategy using `rsync` or `Restic` to occasionally mirror the SSD to a separate drive. While the networking is secure, SSDs can still fail, and RAID 1 over USB is generally not recommended.
