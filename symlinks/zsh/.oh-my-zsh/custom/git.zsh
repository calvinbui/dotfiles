function git_delete_merged_branches {
  echo "Doing dry run"
  git remote prune origin --dry-run
  git branch --merged | grep -v main | grep -v master | grep -v dev | grep -v public

  # POSIX compatible read
  printf "%s" "Continue? [y/n]: "
  read doit

  case "$doit" in
    y)
      git remote prune origin
      git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D
      git branch --merged | grep -v main | grep -v master | grep -v dev | grep -v public | xargs -n 1 git branch -D
      ;;
    *) echo "no worries m8 cya" ;;
  esac
}
