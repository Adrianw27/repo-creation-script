# Repo Creation Script

This project contains a Bash script that:

1. Creates a GitHub repository via the GitHub REST API  
2. Initializes a local project folder as a Git repository  
3. Adds all files and commits them  
4. Sets a remote (SSH or HTTPS)  
5. Pushes the repo to `main`

## Prerequisites

Before running the script, you need:

1. Git installed
2. GitHub Personal Access Token
- Must have write permissions for Administration
3. GitHub PAT/SSH key to set remote

## Usage

1. Load your PAT
```bash
export GITHUB_TOKEN="your_pat"
```
2. Grant write permissions to script
```bash
chmod +x ./create_repo.sh
```
3. Run the script from any directory
```bash
./create_repo.sh /path/to/project <repo-name> [--https|--ssh] "<description>"
# Example: ./create_repo.sh ~/projects/cool-project cool-project --ssh "my super cool project"
```
