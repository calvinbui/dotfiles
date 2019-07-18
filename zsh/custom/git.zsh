function git_delete_merged_branches {
  echo "Doing dry run"
  git remote prune origin --dry-run

  # POSIX compatible read
  printf "%s" "Continue? [y/n]: "
  read doit

  case "$doit" in
    y)
      git remote prune origin
      git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D
      ;;
    *) echo "no worries m8 cya" ;;
  esac
}