# Syncthing Setup: WSL → Windows (Code Projects)

This document describes a **stable and performant setup** for synchronizing source code from **WSL (Linux)** to **Windows**, optimized for **many small files**, and prepared for future synchronization from Windows to an **Unraid NAS**.

The synchronization model is **one-way**:

```
WSL (Send Only)  ──▶  Windows (Receive Only)
```

## 1. Install Syncthing on WSL

```bash
sudo apt update
sudo apt install syncthing
```

Start once manually:

```bash
syncthing
```

Access GUI:

```
http://localhost:8384
```

---

### Enable automatic startup (systemd)

If your WSL supports systemd:

```bash
systemctl --user enable syncthing
systemctl --user start syncthing
```

Check status:

```bash
systemctl --user status syncthing
```

> [!WARNING]
> **Do NOT** start Syncthing from `.bashrc`. It must run **once per user**, not per terminal.

## 2. Install Syncthing on Windows

1. Download from the official site
2. Install and select **Run as a Service**
3. Open GUI:

```
http://localhost:8384
```

## 3. Avoid GUI Port Conflict (Recommended)

Set different GUI ports so both UIs can be open simultaneously.

### WSL

```
Settings → GUI
GUI Listen Address: 127.0.0.1:8385
Authentication: ON (recommended)
```

### Windows

```
Settings → GUI
GUI Listen Address: 127.0.0.1:8384
Authentication: ON (recommended)
```

## 4. Global Settings — WSL (Source)

### Settings → Connections

* Local Discovery: ON
* Global Discovery: OFF
* NAT Traversal: OFF
* Relays: OFF
* Enable QUIC: ON
* Listen Addresses: `default`

### Settings → General

* Device Name: `WSL`
* Default Folder Type: `Send Only`
* Default File Pull Order: `Smallest First`

### Settings → Advanced

* `fsWatcherEnabled`: `false`
* `relaysEnabled`: `false`
* `folderConcurrency`: `4`
* `maxFolderConcurrency`: `2`

## 5. Global Settings — Windows

### Settings → Connections

* Local Discovery: ON
* Global Discovery: OFF *(enable later if needed)*
* NAT Traversal: OFF *(enable later if needed)*
* Relays: OFF *(enable later if needed)*
* Enable QUIC: ON
* Listen Addresses: `default`

### Settings → General

* Device Name: `Windows`
* Default Folder Type: `Receive Only`
* Default File Pull Order: `Smallest First`
* Auto Accept Folders: OFF

### Settings → Advanced

* `fsWatcherEnabled`: `false`
* `relaysEnabled`: `false`
* `folderConcurrency`: `4`
* `maxFolderConcurrency`: `2`
* `progressUpdateIntervalS`: `5`

## 6. Connect WSL and Windows

* In either GUI: **Add Remote Device**
* Accept on the other side
* Done

## 7. Folder Configuration (Critical)

### On WSL (Source)

Add folder:

```
Path: /home/user/project
Folder Type: Send Only
Watch for Changes: OFF
Rescan Interval: 3600
Ignore Permissions: ON
File Pull Order: Smallest First
```

### On Windows (Destination)

Accept folder:

```
Path: C:\Sync\Project
Folder Type: Receive Only
Watch for Changes: OFF
Rescan Interval: 0
Ignore Permissions: ON
File Versioning:
  Type: Simple
  Keep: 5
```

Repeat per project. Each folder can map to a different Windows path.

## 8. Ignore Files (Mandatory for Code)

Create `.stignore` in each WSL project root:

```
.git
.git/**
node_modules
node_modules/**
dist
dist/**
build
build/**
target
target/**
.venv
.venv/**
.idea
```

This drastically reduces load and improves performance.

## 9. Important Rules

* ❌ Do NOT use `/mnt/c` in WSL
* ❌ Do NOT edit files on Windows
* ❌ Remove the default `~/Sync` folder
* ✔ WSL = Send Only
* ✔ Windows = Receive Only
* ✔ One folder per project
