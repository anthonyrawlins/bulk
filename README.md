# bulk - Parallel Copy Utility

A high-performance parallel copy utility optimized for large datasets with many files.

## Features

- **Parallel processing** - Automatically uses multiple CPU cores for faster transfers
- **Smart optimization** - Parallelizes by top-level directories for optimal performance
- **Progress monitoring** - Verbose mode shows real-time copy progress
- **Dry run support** - Preview operations before executing
- **Drop-in replacement** - Similar syntax to `cp -r` but much faster for large datasets

## Installation

### Quick Install
```bash
# Clone or download the repository
git clone https://github.com/anthonyrawlins/bulk.git
cd bulk

# Run the installer
./install.sh
```

### Manual Install
```bash
# Make executable
chmod +x bulk

# Install to system PATH
sudo cp bulk /usr/local/bin/
```

## Usage

```bash
# Basic parallel copy (uses all CPU cores)
bulk /source/directory/ /destination/directory/

# Limit parallel jobs
bulk -j 8 /source/ /dest/

# Verbose mode with progress
bulk -v /source/ /dest/

# Dry run to preview
bulk -n /source/ /dest/

# Show help
bulk --help
```

## Performance

Optimized for scenarios with many files (thousands to millions):

- **180,000 files (1MB each)**: 3-5x faster than single-threaded tools
- **USB3 transfers**: Better bandwidth utilization through parallelization
- **Network storage**: Efficient use of multiple connections

## How It Works

1. Scans source directory for top-level items
2. If sufficient items (≥3), parallelizes using multiple `rsync` processes
3. Each parallel job handles a subset of directories/files
4. Falls back to single `rsync` for small datasets

## Requirements

- `bash` 4.0+
- `rsync`
- `find`
- `xargs`

## Examples

### Large Dataset Transfer
```bash
# Transfer 180GB of small files efficiently
bulk -v /media/usb-drive/ /zfs/dataset/
```

### Network Storage
```bash
# Copy to NFS mount with limited parallel jobs
bulk -j 4 /local/data/ /nfs/backup/
```

### Preview Large Operation
```bash
# See what would be copied without actually copying
bulk -n /backup/source/ /restore/destination/
```

## License

MIT License - see project repository for details.