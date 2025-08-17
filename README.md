# 📦 _File Janitor_

A lightweight Bash utility to automatically compress and archive large files.
Designed for log rotation, cleanup tasks, or saving disk space in a simple and configurable way.

---

## ⭐ Features
+ Compresses files larger than 20MB with gzip.

+ Moves compressed files into an archive folder.

+ Optional dry-run mode for safe testing.

+ Cleans up old archives after a configurable number of days.

+ Fully customizable via command-line arguments.

## ⚖️ Version Comparison 

| Feature            | **v1.0**                                        | **v2.0 (latest)**                                               |
|--------------------|-------------------------------------------------|-----------------------------------------------------------------|
| **Configuration**  | Hardcoded values (`BASE`, `DAYS`, `DEPTH`, `RUN`) inside script | Accepts arguments in sequential order: `BASE DAYS DEPTH RUN` |
| **Usage Help**     | None                                            | Added `-h / --help` flag with usage instructions                |
| **Dry Run Mode**   | Controlled by `RUN` variable inside loop        | Clear separation of **Run Mode** and **Dry Run Mode**           |
| **Archiving**      | Compress + move files >20MB                     | Same, but cleaner structure with better logging                 |
| **Cleanup**        | Not implemented                                 | Deletes archives older than `$DAYS` days                        |
| **Logging**        | Basic echo messages                             | Improved logs: `[RUN MODE]` / `[DRY RUN]` with timestamps       |
| **Error Handling** | Minimal                                         | More robust error checks for missing directories and args       |
| **Flexibility**    | Fixed script path                               | Flexible — can run on any path with a single command            |

## 🛠️ Usage
 **Default Run (with arguments)**

```
./auto-archive.sh /your/path/to/dir 10 1 1
```
 `./auto-archive.sh [BASE] [DAYS] [DEPTH] [RUN]`
- `BASE` → directory to scan

- `DAYS` → days to keep archives

- `DEPTH` → max directory depth

- `RUN` → `0` = dry run, `1` = real run 
**Dry Run Example**
  ```
  ./auto-archive.sh /var/log 7 1 0
  ```
➕ Lists files larger than 20MB in /var/log that would be archived.

## ⬇️ Download and Use

Clone the repo:
```bash
git clone https://github.com/praveensingh-git/file-janitor.git
cd file-janitor
```

Make the script executable:
```
chmod +x auto-archive.sh
```
Run with default value
```
./auto-archive.sh /home/nedstark/myscripts 10 1 1
```
*⚠️ Note:*
+ Replace `nedstark` with your own Linux username wherever applicable.
+ For the default run to work, you must have a directory named
`/home/<your-username>/myscripts` with at least one file larger than 20MB.
Otherwise, no files will be archived.

**Run in dry-run mode (safe test)**
```
./auto-archive.sh /home/<your-username>/myscripts 10 1 0
```
*This will just list the files that would be archived without actually compressing them.*

## ⓘ Help
```
./auto-archive.sh --help
```

---

## ⚡ Quick Start

### 1. Run with a custom directory
 
If you want to archive files in `/var/log` that are larger than 50MB, keep archives for 30 days, and run in real mode:
```bash
./auto-archive.sh /var/log 30 2 1
```
`/var/log` → directory to scan

`30` → delete archives older than 30 days

`2` → check inside subdirectories up to depth 2

`1` → run mode (set to 0 for dry-run in `v2.0`)

### 2. Automate with cron
You can schedule the script to run automatically, for example every day at 1:00 AM:
+ Open your crontab:
  ```
  crontab -e
  ```
+ Add this line (replace `<your-username>` with your Linux username):
  ```
  0 1 * * * /home/<your-username>/file-janitor/auto-archive.sh /home/<your-username>/myscripts 10 1 1 >> /home/<your-username>/file-janitor/auto-archive.log 2>&1
  ```
This will:
  + Run the archiver daily at 1:00 AM

  + Archive files >20MB in /home/<your-username>/myscripts

  + Delete archives older than 10 days

  + Log output to auto-archive.log for review

---

## 🔄 Workflow

The process followed by **bash-archiver** is straightforward:
```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐       ┌──────────────┐  
│   Scan      │  ---> │  Compress   │  ---> │    Move     │  ---> │   Cleanup    │  
│  (find)     │       │  (gzip)     │       │ to archive  │       │ old archives │  
└─────────────┘       └─────────────┘       └─────────────┘       └──────────────┘  
```
1. **Scan** → Finds files larger than 20MB inside the target directory.  
2. **Compress** → Uses `gzip` to shrink the files.  
3. **Move** → Places compressed files inside the `archive/` directory.  
4. **Cleanup** → Deletes archived files older than `$DAYS`.  
