"""Check profiles and startup without touching the real home directory."""

import configparser
import json
import os
from pathlib import Path
import platform
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


class ConfigTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-test-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.env = {
            **os.environ,
            "HOME": str(self.home),
            "XDG_CONFIG_HOME": str(self.home / ".config"),
            "XDG_CACHE_HOME": str(self.home / ".cache"),
            "XDG_DATA_HOME": str(self.home / ".local/share"),
            "DOTFILES_ROOT": str(ROOT),
            # Never let Git's ambient config overrides affect these checks.
            "GIT_CONFIG_NOSYSTEM": "1",
            "GIT_CONFIG_GLOBAL": str(self.home / ".gitconfig"),
            "GIT_CONFIG_COUNT": "0",
        }

    def run_command(self, *args, check=True, **kwargs):
        result = subprocess.run(
            args, env=self.env, text=True, capture_output=True, **kwargs
        )
        if check:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def test_shell_syntax(self):
        for script in (ROOT / "scripts").glob("*.sh"):
            self.run_command("sh", "-n", str(script))
        for script in (ROOT / "symlinks").rglob("*"):
            if script.is_file() and (
                script.suffix == ".zsh" or script.name == ".zshrc"
            ):
                self.run_command("zsh", "-n", str(script))

    def test_profiles_have_no_conflicting_targets(self):
        for profile in (ROOT / "profiles").iterdir():
            owners = {}
            packages = [
                line for line in profile.read_text().splitlines()
                if line and not line.startswith("#")
            ]
            self.assertTrue(packages, profile.name)
            self.assertEqual(len(packages), len(set(packages)), profile.name)
            self.assertFalse({"macos", "linux"} <= set(packages), profile.name)
            for name in packages:
                package = ROOT / "symlinks" / name
                self.assertTrue(package.is_dir(), name)
                for path in package.rglob("*"):
                    if path.is_dir():
                        continue
                    target = str(path.relative_to(package))
                    self.assertNotIn(target, owners, (profile.name, target))
                    owners[target] = name
            # Stow also cannot link a file over another package's directory.
            for target in owners:
                for parent in Path(target).parents:
                    self.assertNotIn(str(parent), owners, (profile.name, target))

    def test_profile_runner_defaults_to_dry_run(self):
        bin_dir = self.home / "bin"
        bin_dir.mkdir()
        stow = bin_dir / "stow"
        stow.write_text('#!/bin/sh\nprintf "%s\\n" "$@" > "$HOME/stow-args"\n')
        stow.chmod(0o755)
        self.env["PATH"] = str(bin_dir) + os.pathsep + os.environ["PATH"]
        profile = "macbook" if platform.system() == "Darwin" else "wsl-desktop"
        runner = str(ROOT / "scripts/stow-profile.sh")
        self.run_command("sh", runner, profile, cwd=self.home)
        args = (self.home / "stow-args").read_text().splitlines()
        self.assertIn("--simulate", args)
        self.assertIn(f"--target={self.home}", args)
        self.assertIn("--no-folding", args)
        self.run_command("sh", runner, profile, "--apply")
        self.assertNotIn("--simulate", (self.home / "stow-args").read_text())
        for invalid in ("../macbook", "no-such-profile"):
            result = self.run_command("sh", runner, invalid, check=False)
            self.assertNotEqual(result.returncode, 0)
        wrong_os = "wsl-desktop" if platform.system() == "Darwin" else "macbook"
        result = self.run_command("sh", runner, wrong_os, check=False)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("does not match this OS", result.stderr)

    def test_zsh_startup_without_optional_tools(self):
        # Minimal OMZ stand-in, loading the real custom files, not installed plugins.
        omz = self.home / ".oh-my-zsh"
        omz.mkdir()
        (omz / "oh-my-zsh.sh").write_text(
            'ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"\n'
            'for config in "$DOTFILES_ROOT"/symlinks/zsh/.oh-my-zsh/custom/*.zsh; do\n'
            '  source "$config"\n'
            'done\n'
        )
        (self.home / ".zshrc.local").write_text(
            'export DOTFILES_LOCAL_LOADED=yes\nexport EDITOR=local-editor\n'
        )
        hook = self.home / ".config/dotfiles/platform.zsh"
        hook.parent.mkdir(parents=True)
        hook.symlink_to(ROOT / "symlinks" / (
            "macos" if platform.system() == "Darwin" else "linux"
        ) / ".config/dotfiles/platform.zsh")
        # Omit Homebrew, fnm, kubectl, helm, and the real user's tool directories.
        zsh = shutil.which("zsh")
        empty_path = self.home / "empty-path"
        empty_path.mkdir()
        self.env["PATH"] = str(empty_path)
        result = self.run_command(
            zsh, "-dfc",
            'source "$DOTFILES_ROOT/symlinks/zsh/.zshrc"\n'
            '[[ "$DOTFILES_LOCAL_LOADED" == yes && "$EDITOR" == local-editor ]] || exit 1\n'
            '[[ " ${path[*]} " == *" $HOME/.local/bin "* ]] || exit 1\n'
            'if [[ "$OSTYPE" != darwin* ]]; then\n'
            '  [[ " ${plugins[*]} " != *" iterm2 "* ]] || exit 1\n'
            'fi\n'
            'print -r -- startup-ok\n',
        )
        self.assertEqual(result.stdout, "startup-ok\n")
        self.assertEqual(result.stderr, "")

    def test_git_include_order(self):
        config_dir = self.home / ".config/git"
        config_dir.mkdir(parents=True)
        (self.home / ".gitconfig").symlink_to(ROOT / "symlinks/git/.gitconfig")
        (config_dir / "platform.gitconfig").write_text("[test]\n value = platform\n")
        (self.home / ".gitlocal").write_text(
            "[test]\n value = local\n[core]\n ignorecase = true\n"
        )
        result = self.run_command("git", "config", "--global", "--includes", "--get", "test.value")
        self.assertEqual(result.stdout.strip(), "local")
        result = self.run_command("git", "config", "--global", "--includes", "--get", "core.ignorecase")
        self.assertEqual(result.stdout.strip(), "true")
        (self.home / ".gitlocal").unlink()
        result = self.run_command("git", "config", "--global", "--includes", "--get", "test.value")
        self.assertEqual(result.stdout.strip(), "platform")

    def test_python_config_syntax(self):
        for relative, section in (
            ("python/.pylintrc", "MAIN"),
            ("python/.config/pycodestyle", "pycodestyle"),
        ):
            parser = configparser.ConfigParser(interpolation=None)
            with (ROOT / "symlinks" / relative).open() as source:
                parser.read_file(source)
            self.assertIn(section, parser)

    def test_opencode_platform_separation(self):
        self.assertFalse(
            (ROOT / "symlinks/opencode/.config/opencode/opencode.jsonc").exists()
        )
        self.assertTrue(
            (ROOT / "symlinks/opencode/.config/opencode/AGENTS.md").is_file()
        )
        linux = json.loads(
            (ROOT / "symlinks/linux/.config/opencode/opencode.jsonc").read_text()
        )
        self.assertEqual(linux, {"$schema": "https://opencode.ai/config.json"})
        mac = json.loads(
            (ROOT / "symlinks/macos/.config/opencode/opencode.jsonc").read_text()
        )
        playwright = mac["mcp"]["servers"]["playwright"]
        self.assertTrue(playwright["command"][0].startswith("{env:HOME}/"))
        self.assertNotIn("/Users/", json.dumps(mac))
        self.assertIn("home_assistant_mcp", mac["mcp"]["servers"])

    @unittest.skipUnless(shutil.which("ssh"), "OpenSSH is not installed")
    def test_ssh_defaults_and_local_overrides(self):
        source = (ROOT / "symlinks/ssh/.ssh/config").read_text()
        include = "Include ~/.ssh/config.local"
        self.assertEqual(source.count(include), 1)
        local = self.home / "ssh-config.local"
        config = self.home / "ssh-config"
        # OpenSSH expands ~ using the passwd database, not $HOME. Substitute only
        # the Include path in this fixture so tests never read the live config.
        config.write_text(source.replace(include, f'Include "{local}"'))

        def effective_config():
            result = self.run_command(
                "ssh", "-G", "-T", "-F", str(config), "github.com"
            )
            return dict(line.split(None, 1) for line in result.stdout.splitlines())

        defaults = effective_config()
        self.assertEqual(defaults["hostname"], "ssh.github.com")
        self.assertEqual(defaults["port"], "443")
        self.assertEqual(defaults["user"], "git")
        local.write_text("Host github.com\n  User local-user\n  Port 2222\n")
        overrides = effective_config()
        self.assertEqual(overrides["user"], "local-user")
        self.assertEqual(overrides["port"], "2222")
        self.assertEqual(overrides["hostname"], "ssh.github.com")

    @unittest.skipUnless(shutil.which("stow"), "GNU Stow is not installed")
    def test_real_stow_moves_opencode_config_between_packages(self):
        packages = self.home / "packages"
        shared = packages / "opencode/.config/opencode"
        mac = packages / "macos/.config/opencode"
        target = self.home / "target"
        for path in (shared, mac, target):
            path.mkdir(parents=True)
        (shared / "AGENTS.md").write_text("# Shared instructions\n")
        (shared / "opencode.jsonc").write_text("{}\n")
        args = (
            "stow", f"--dir={packages}", f"--target={target}", "--no-folding",
        )
        self.run_command(*args, "opencode", "macos", cwd=self.home)
        (shared / "opencode.jsonc").rename(mac / "opencode.jsonc")
        self.run_command(*args, "--simulate", "--restow", "opencode", "macos")
        self.run_command(*args, "--restow", "opencode", "macos")
        self.assertEqual(
            (target / ".config/opencode/opencode.jsonc").resolve(),
            mac / "opencode.jsonc",
        )
        self.assertEqual(
            (target / ".config/opencode/AGENTS.md").resolve(),
            shared / "AGENTS.md",
        )

    @unittest.skipUnless(shutil.which("stow"), "GNU Stow is not installed")
    def test_real_stow_profile(self):
        profile = "macbook" if platform.system() == "Darwin" else "wsl-desktop"
        runner = str(ROOT / "scripts/stow-profile.sh")
        self.run_command("sh", runner, profile)
        self.assertFalse((self.home / ".zshrc").exists())
        self.run_command("sh", runner, profile, "--apply")
        self.assertEqual(
            (self.home / ".zshrc").resolve(), ROOT / "symlinks/zsh/.zshrc"
        )
        for name in (ROOT / "profiles" / profile).read_text().splitlines():
            if not name or name.startswith("#"):
                continue
            package = ROOT / "symlinks" / name
            for source in package.rglob("*"):
                if source.is_file():
                    target = self.home / source.relative_to(package)
                    self.assertTrue(target.is_symlink(), str(target))
                    self.assertEqual(target.resolve(), source)
        self.assertFalse((self.home / ".config").is_symlink())
        self.assertFalse((self.home / ".oh-my-zsh/custom").is_symlink())
        self.assertFalse((self.home / ".gitlocal").exists())
        self.run_command("sh", runner, profile, "--apply")  # idempotent restow

    @unittest.skipUnless(shutil.which("stow"), "GNU Stow is not installed")
    def test_real_stow_preserves_conflicts(self):
        profile = "macbook" if platform.system() == "Darwin" else "wsl-desktop"
        rc = self.home / ".zshrc"
        rc.write_text("# existing local config\n")
        result = self.run_command(
            "sh", str(ROOT / "scripts/stow-profile.sh"), profile, "--apply", check=False
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(rc.is_symlink())
        self.assertEqual(rc.read_text(), "# existing local config\n")

    @unittest.skipUnless(shutil.which("stow"), "GNU Stow is not installed")
    def test_real_stow_preserves_legacy_symlinks(self):
        profile = "macbook" if platform.system() == "Darwin" else "wsl-desktop"
        rc = self.home / ".zshrc"
        legacy_target = self.home / "dotfiles/zsh/zshrc"
        rc.symlink_to(legacy_target)
        result = self.run_command(
            "sh", str(ROOT / "scripts/stow-profile.sh"), profile, "--apply", check=False
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(rc.readlink(), legacy_target)
        self.assertFalse((self.home / ".config/dotfiles/platform.zsh").exists())


if __name__ == "__main__":
    unittest.main(verbosity=2)
