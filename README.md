# aws-ec2-fresh-install

Automated, idempotent bootstrap scripts for provisioning secure, production-ready AWS EC2 instances. Includes package installation, firewall hardening (UFW + fail2ban), automatic security updates, and modern CLI tooling. Designed for rapid, repeatable instance setup with full audit logging.

## Features

- **Idempotent package installation** — Safe to re-run; skips already-installed packages
- **Security hardening** — UFW firewall (deny incoming, allow outgoing + SSH), fail2ban, unattended-upgrades
- **Modern CLI tools** — Helix, micro, ripgrep, fd, bat, fzf, tmux, btop, and more
- **Full audit logging** — Timestamped logs written to `/var/log/fresh_install_*.log`
- **S3 distribution** — `pull_from_s3.sh` fetches the latest tree from S3 for new instances

## Repository Structure

```
aws-ec2-fresh-install/
├── software.sh          # Core package installs + security hardening
├── bashrc.sh            # .bashrc customizations (placeholder)
├── aliases.sh           # .bash_aliases (placeholder)
├── pull_from_s3.sh      # Bootstrap helper — syncs tree from S3
└── README.md
```

## Quick Start (on a fresh EC2 instance)

```bash
# 1. Pull the latest tree from S3 (replace with your bucket)
./pull_from_s3.sh my-bootstrap-bucket aws-ec2-fresh-install

# 2. Make scripts executable and run
cd aws-ec2-fresh-install
chmod +x *.sh
./software.sh
```

## Prerequisites

- Ubuntu/Debian-based AMI (tested on recent LTS releases)
- `admin` user with passwordless sudo (standard on AWS EC2)
- AWS CLI configured with permissions to read from the target S3 bucket

## Logging

Every run writes a detailed, timestamped log to:

```
/var/log/fresh_install_YYYYMMDD_HHMMSS.log
```

## Customization

- Add new packages or configuration steps in `software.sh` following the existing pattern (idempotency check + logging)
- Extend shell environment via `bashrc.sh` and `aliases.sh`
- Update `pull_from_s3.sh` if your bucket/prefix changes

## Security Notes

- UFW is configured to deny all incoming traffic except SSH
- fail2ban protects against brute-force SSH attacks
- unattended-upgrades keeps the system patched automatically
- All privileged operations use `sudo` (assumes passwordless sudo via cloud-init)

## License

MIT — free to use, modify, and share.

## Author

[Your Name] — AWS infrastructure automation and Linux server hardening.
