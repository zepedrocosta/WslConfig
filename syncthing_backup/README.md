# Syncthing Auto-Export on WSL Startup

This setup creates automatic backups of the Syncthing configuration used inside WSL.  
Every time WSL starts, a compressed export is generated and old backups are cleaned up.

## What gets backed up

- `config.xml`
- Syncthing device keys
- Folder definitions
- Ignore rules
- State database (optional to restore, but included)

Everything Syncthing needs to be fully restored or migrated.

## Where Syncthing stores its data on WSL

```txt
/home/josec/.local/state/syncthing
```

If Syncthing is installed differently, adjust the path.

## Installation

### 1. Save the script

Make it executable:

```sh
chmod +x /home/josec/bin/script.sh
```

### 2. Run automatically when WSL starts

Append this line to the end of `~/.bashrc`:

```txt
/home/josec/bin/syncthing-export.sh >/dev/null 2>&1 &
```

Reload:

```sh
source ~/.bashrc
```

## Backup directory

Backups are stored here:

```txt
/home/josec/syncthing-backups
```

Example filename:

```txt
syncthing-backup-20250105-174210.tar.gz
```

## Restore

Stop Syncthing, extract the backup into the same config path:

```sh
tar -xzf syncthing-backup-*.tar.gz -C /home/josec/.local/state/
```

Start Syncthing again.
If folder paths changed, edit `config.xml` manually.
