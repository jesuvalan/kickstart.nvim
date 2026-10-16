# Terminal IDE: customizations and cheat sheet

Stack: Debian 13 · zsh (lean, no Oh My Zsh) · tmux · Alacritty · Neovim (kickstart.nvim, `vim.pack`) · everything deployed by the Ansible `dev` role.

**How to read the status column.** *Baseline* means it was in the configs we wrote together. *Optional* means I suggested it and it is only active if you added it. Key names marked *(verify)* are plugin defaults I am going from memory on, so confirm them with the plugin's own help (`?` or `g?`) or which-key.

---

## 0. Where everything lives

| Piece | Source of truth (Ansible role) | Deployed to | Apply change |
|---|---|---|---|
| zsh | `templates/zshrc.j2` | `~/.zshrc` | run play, then `exec zsh` |
| tmux | `files/tmux.conf` | `~/.tmux.conf` | run play, then `Ctrl-Space r` |
| Alacritty | `templates/alacritty.toml.j2` | `~/.config/alacritty/alacritty.toml` | run play, open a new window |
| Neovim config | your kickstart fork (git) | `~/.config/nvim` | edit, commit, push |
| Neovim binary | `nvim_version` variable | `/opt/nvim-<version>`, linked at `/usr/local/bin/nvim` | change variable, run play |
| Nerd font | `nerd_font_name`, `nerd_font_version` | `~/.local/share/fonts/` | run play |

Neovim config files we added: `lua/custom/comforts.lua` (plugins and keymaps) and `lua/custom/autosave.lua`. Both are loaded by `require('custom.<name>')` near the bottom of `init.lua`.

---

## 1. Keys and what they do

### 1.1 tmux (prefix = `Ctrl-Space`)

Press and release `Ctrl-Space`, then the key. Do not type the `:` or the key inside the command prompt.

| Keys | Function | Status |
|---|---|---|
| `Ctrl-Space c` | new window, in current directory | Baseline |
| `Ctrl-Space \|` | split side by side (tmux calls this horizontal) | Baseline |
| `Ctrl-Space -` | split stacked, top and bottom | Baseline |
| `Ctrl-Space 1`..`9` | jump to window by number (numbering starts at 1) | Baseline |
| `Ctrl-Space r` | reload `~/.tmux.conf` | Baseline |
| `Ctrl-Space [` | enter copy / scroll mode | Baseline |
| `Ctrl-Space ]` | paste tmux's own buffer | Built-in |
| `Ctrl-Space d` | detach (everything keeps running) | Built-in |
| `Ctrl-Space z` | zoom or unzoom current pane | Built-in |
| `Ctrl-Space :` | tmux command prompt | Built-in |
| `Ctrl-Space Space` | cycle pane layouts | Built-in |
| `Ctrl-Space { / }` | swap pane with previous / next | Built-in |
| `Ctrl-h / j / k / l` | move between panes; inside Neovim, between nvim splits first (needs vim-tmux-navigator) | Baseline |
| `Ctrl-Space Ctrl-l` | clear screen (plain `Ctrl-l` is used for navigation) | Baseline |

Copy mode keys (vi style, after `Ctrl-Space [`):

| Keys | Function |
|---|---|
| `h j k l`, `Ctrl-u`, `Ctrl-d`, `g`, `G` | move, half-page, top, bottom |
| `/text`, `?text`, `n`, `N` | search forward, backward, next, previous |
| `v` | start selection |
| `y` | copy to system clipboard (`wl-copy`) and leave copy mode |
| `q` or `Esc` | leave copy mode |

Mouse is on: the wheel scrolls history, clicking a pane focuses it. Hold **Shift** while dragging to use Alacritty's own selection instead of tmux's.

Optional additions (not in the `tmux.conf` currently deployed):

| Keys | Function |
|---|---|
| `Ctrl-Space H/J/K/L` | resize pane (repeatable) |
| `Ctrl-Space t` | scratch terminal popup |
| `PageUp` | enter scroll mode and page up without the prefix |
| mouse drag | copy straight to the clipboard when you release |

### 1.2 Neovim (leader = `Space`)

Press `Space` and wait: which-key lists everything under it. Press `g` or `z` and wait for the built-in menus.

| Keys | Function | Status |
|---|---|---|
| `\` | toggle neo-tree (file explorer) | Baseline |
| `Space s f` / `s g` | Telescope: find files / live grep | Kickstart default (verify in which-key) |
| `Space Space` | Telescope buffer list | Kickstart default (verify) |
| `gs` | Flash: jump to any visible spot | Baseline |
| `d gs`, `y gs`, `v gs` | delete / yank / select up to a Flash target | Baseline |
| `Space x x` | Trouble: all problems in workspace | Baseline |
| `Space x b` | Trouble: problems in current buffer | Baseline |
| `Space g d` | Diffview: all uncommitted changes | Baseline |
| `Space g h` | Diffview: history of current file | Baseline |
| `:DiffviewClose` | close the Diffview tab | Baseline |
| `Space g q` | same as above, as a key | Optional |
| `Ctrl-h / j / k / l` | move between nvim windows, then continue into tmux panes | Optional (needs vim-tmux-navigator) |
| `:AutosaveToggle` | switch autosave on or off | Optional |
| `Ctrl-s` | save | Optional (needs `stty -ixon` in zsh) |
| `]b` / `[b` | next / previous buffer | Built-in (verify) |
| `Space b d` | close current buffer, keep window | Optional (with bufferline) |
| `gt` / `gT` | next / previous tab page | Built-in |
| `t` in neo-tree | open file in a new tab page | neo-tree default (verify with `?`) |
| `<cr>` in neo-tree | open file in the editor window | neo-tree default |
| `]c` / `[c` | next / previous git hunk | gitsigns (verify) |
| `gcc` | toggle comment on the line | Kickstart |
| `zz`, `zM`, `zR` | center line; close all folds; open all folds | Built-in |

Key notation: `<cr>` = Enter, `<esc>` = Escape, `<C-x>` = Ctrl+x, `<A-x>` = Alt+x, `<leader>` = Space.

Saving: `:w` write, `:wa` write all, `:wqa` write all and quit, `:qa` quit everything.

### 1.3 zsh

| Keys / command | Function |
|---|---|
| `Ctrl-R` | fuzzy history search (fzf) |
| `Ctrl-T` | fuzzy file picker (uses `fd`, includes dotfiles) |
| `Alt-C` | fuzzy `cd` into a directory |
| `z <part>` / `zi` | zoxide: jump to a frequent directory / pick interactively |
| `dev [name]` | create or attach a tmux session with the VS Code style layout |
| `↑` / `↓` | history search by what you already typed |
| `→` | accept the grey autosuggestion |
| `Ctrl-w` | delete previous word (emacs-mode `backward-kill-word`) |
| `Alt+Backspace` | delete previous word |
| `exec zsh` (alias `reload`) | restart the shell with a clean config |
| `c` | clear |
| `bwlogin` | log in to Bitwarden with credentials loaded only for that command |

### 1.4 Alacritty

| Keys | Function |
|---|---|
| Shift + drag | select text while tmux has the mouse |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | copy / paste |
| Selecting text | copies automatically (`save_to_clipboard = true`) |
| Shift + right click | paste (optional binding) |
| `Ctrl+Backspace` | sends `^W` (word delete), if you added the keyboard binding |

---

## 2. How to add, change, or remove things

### 2.1 Neovim plugins (`vim.pack`)

Plugins are declared with `vim.pack.add`, and Neovim installs missing ones at startup, after a confirmation prompt on first install. There is no lazy-loading and no `:Lazy` command.

**Add a plugin** in `lua/custom/comforts.lua`:

```lua
vim.pack.add({ 'https://github.com/<owner>/<plugin>' })

local ok, plugin = pcall(require, '<module>')
if ok then
  plugin.setup({})
  vim.keymap.set('n', '<leader>xx', '<cmd>SomeCommand<cr>', { desc = 'What it does' })
end
```

`pcall(require, ...)` keeps Neovim starting normally if the plugin failed to install.

**Remove a plugin:**
1. Delete its `vim.pack.add` entry and its setup and keymap lines.
2. Remove the files from disk with `:lua vim.pack.del({ '<name>' })` (check `:h vim.pack` for the exact form in your version).
3. Commit the config and the updated lockfile.

**Update plugins:** `:lua vim.pack.update()`, then commit the lockfile so every machine gets the same versions.

**List installed plugins:**

```vim
:lua vim.print(vim.tbl_map(function(p) return p.spec.name end, vim.pack.get()))
```

### 2.2 Keymaps

```lua
vim.keymap.set('n', '<leader>xx', '<cmd>Command<cr>', { desc = 'Shown in which-key' })
```

To remove one, delete the line. To change a key, edit the first argument.

If a key does the wrong thing, find out who owns it:

```vim
:verbose nmap <C-j>
```

This prints the mapping and the file that set it. Kickstart's own mappings live in `init.lua`. If yours must win, load your file last, or delete kickstart's line.

### 2.3 tmux

1. Edit `files/tmux.conf` in the role.
2. Run the play, then press `Ctrl-Space r` (or `tmux source-file ~/.tmux.conf`, which prints parse errors).

Useful inspection commands:

```bash
tmux show -g prefix                      # is the config loaded?
tmux list-keys -T prefix                 # prefix table
tmux list-keys -T root                   # keys that work without the prefix
tmux list-keys -T copy-mode-vi           # copy-mode keys
```

tmux reads the file only when the server starts, so after a first deploy run `tmux kill-server` or source the file by hand.

### 2.4 zsh

Edit `templates/zshrc.j2`, run the play, and run `exec zsh`. The template is Jinja, so avoid `{{`, `{%` and `{#` in the file, or wrap the section in `{% raw %}...{% endraw %}`. Per-machine tweaks go in `~/.zshrc.local`, which is sourced if it exists.

### 2.5 Alacritty

Edit `templates/alacritty.toml.j2`, run the play, open a new window. A syntax error makes Alacritty ignore the whole file. Set `alacritty_tmux_autostart: false` to stop windows from attaching to tmux automatically.

### 2.6 Ansible workflow and rollback

- Run the play twice after a change. The second run should report `changed=0`.
- `.zshrc` is deployed with `backup: true`, so the previous file is kept next to the new one.
- The Neovim config is a git clone. The git module refuses to update over uncommitted local edits, so **commit and push before running the play**.
- Neovim upgrades: bump `nvim_version`. The old `/opt/nvim-<old>` stays in place for rollback.
- User-level tasks (dotfiles, fonts, nvim config) must run **without** `become`, otherwise they land in `/root`. System tasks (apt, `/opt`, `/usr/local/bin`) use `become` per task.

### 2.7 Quickly switching a feature off

| Feature | How |
|---|---|
| Autosave | `:AutosaveToggle`, or remove `require('custom.autosave')` |
| All comforts | comment out `require('custom.comforts')` |
| tmux auto-attach in Alacritty | `alacritty_tmux_autostart: false` |
| tmux mouse | `set -g mouse off` |
| nvim to tmux navigation | remove the `bind -n C-h/j/k/l` lines and the plugin |

---

## 3. Features added, explained

### 3.1 Comforts (`lua/custom/comforts.lua`)

VS Code habits, mapped to light plugins.

- **trouble.nvim** is the Problems panel. `Space x x` shows workspace diagnostics and `Space x b` shows the current buffer. It lists whatever language servers report, so it is empty for filetypes with no server attached.
- **flash.nvim** jumps anywhere on screen. Press `gs`, type one or two letters of the target, then the label letter that appears. Combined with an operator (`d gs`, `y gs`, `v gs`) it deletes, yanks or selects up to that spot. It replaces repeated `w`, `b`, `j`, `k` presses.
- **diffview.nvim** reviews changes side by side. `Space g d` opens every uncommitted change in a new tab page with a file list. Inside, `<tab>` moves between files, `s` stages or unstages, and `g?` lists the real keys. `Space g h` shows the history of the current file. Leave with `:DiffviewClose`.
- **schemastore.nvim plus `yamlls`** adds schema validation to YAML. Schemas match by **file name pattern**: GitHub Actions under `.github/workflows/`, `docker-compose.yml`, `Chart.yaml`, `kustomization.yaml` and similar. A plain `deployment.yaml` gets no Kubernetes validation unless its first line is a modeline: `# yaml-language-server: $schema=<url>`. The server itself must be installed: `:MasonInstall yaml-language-server`.

For a single file, a lighter option than Diffview is `:Gitsigns diffthis` (against the index) or `:Gitsigns diffthis HEAD` (against the last commit).

### 3.2 Buffer tabs (optional, not yet added)

Neovim has two things called tabs:

- A **tab page** is a saved layout of windows. Opening a file with `t` in neo-tree or `:tabedit` creates one, and it does not carry the explorer along, so you must open neo-tree again in it.
- A **buffer** is what a VS Code tab actually is: an open file.

For VS Code style file tabs, use `bufferline.nvim`. It draws open buffers as a tab bar, and the explorer and layout stay shared:

```lua
vim.pack.add({ 'https://github.com/akinsho/bufferline.nvim' })
local ok_bl, bufferline = pcall(require, 'bufferline')
if ok_bl then
  bufferline.setup({
    options = {
      diagnostics = 'nvim_lsp',
      offsets = { { filetype = 'neo-tree', text = 'Explorer', separator = true } },
    },
  })
  vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Close buffer' })
end
```

Use `<cr>` in neo-tree to open files as buffers. If you stay with tab pages instead, this autocmd opens a tree in each new tab:

```lua
vim.api.nvim_create_autocmd('TabNewEntered', {
  callback = function()
    vim.schedule(function()
      local ft = vim.bo.filetype
      if ft:match('^Diffview') or ft == 'neo-tree' then return end
      vim.cmd('Neotree show')
    end)
  end,
})
```

### 3.3 Autosave (optional, `lua/custom/autosave.lua`)

Saves on `FocusLost` (switching tmux panes, needs `focus-events on`), `BufLeave` and `InsertLeave`, using `update` so unchanged files are not rewritten. It skips unnamed, read-only and special buffers. It deliberately does **not** save on every text change, because kickstart formats on save, file watchers can pick up half-written files, and a timed save can overwrite an edit an agent just made. `:AutosaveToggle` turns it off. Without autosave, use `:w`, or map `Ctrl-s` (needs `stty -ixon` in zsh, otherwise `Ctrl-s` freezes the terminal).

### 3.4 neo-tree

Toggle with `\`. If `:q` leaves the tree open, set `close_if_last_window = true` in its options. `<cr>` opens a file next to the tree. `t` opens it in a new tab page. For infra repos, show dotfiles with `filtered_items = { hide_dotfiles = false, hide_gitignored = false }`. Icons need the Nerd Font set in Alacritty and `vim.g.have_nerd_font = true` in `init.lua`.

### 3.5 tmux and Neovim navigation (vim-tmux-navigator)

`Ctrl-h/j/k/l` moves between Neovim windows first and continues into tmux panes at the edge. It has two halves: the `bind -n C-h/j/k/l` lines in `tmux.conf` (they detect that Neovim is running), and the plugin in Neovim (it hands the key back at the edge).

Kickstart already maps `Ctrl-h/j/k/l` to `<C-w>` window moves, which stop at the edge, so replace them (or load yours last):

```lua
vim.g.tmux_navigator_no_mappings = 1
vim.pack.add({ 'https://github.com/christoomey/vim-tmux-navigator' })
vim.keymap.set({ 'n', 't' }, '<C-h>', '<cmd>TmuxNavigateLeft<cr>')
vim.keymap.set({ 'n', 't' }, '<C-j>', '<cmd>TmuxNavigateDown<cr>')
vim.keymap.set({ 'n', 't' }, '<C-k>', '<cmd>TmuxNavigateUp<cr>')
vim.keymap.set({ 'n', 't' }, '<C-l>', '<cmd>TmuxNavigateRight<cr>')
```

Install the plugin and confirm `:command TmuxNavigateDown` exists **before** deleting kickstart's four lines, otherwise you lose window navigation.

Trade-off: `Ctrl+Backspace` arrives as the same byte as `Ctrl-h`, so tmux hijacks it. Remap it in Alacritty to send `^W`:

```toml
[[keyboard.bindings]]
key = "Backspace"
mods = "Control"
chars = "\u0017"
```

### 3.6 VS Code style tmux layout (`dev`)

`dev [name]` creates one session per project: a `code` window with Neovim top-left (neo-tree inside it), a terminal pane under it, and an agent pane on the right, plus a spare `sh` window. If the session already exists it just attaches, so running processes and layout survive. To rebuild, `tmux kill-session -t <name>` first. Put long-running things (agent, `kubectl logs -f`, `ansible-playbook`) in tmux panes, and file editing in Neovim windows. Rule of thumb: if the other thing is a file, split in Neovim; if it is a process, split in tmux.

### 3.7 Clipboard and mouse

`set-clipboard on` plus `y` in copy mode pipes to `wl-copy` (Wayland; use `xclip -selection clipboard` on X11). Alacritty has no right-click menu. Shift+drag selects through tmux's mouse capture, and selected text is copied automatically. OSC52 is set to copy-only so programs in the terminal cannot read your clipboard.

### 3.8 zsh (lean setup)

No Oh My Zsh and no theme. The config provides: shared 50,000-line history, a small prompt showing directory, git branch and exit status (host only over SSH), cached `kubectl` and `helm` completions regenerated only when the binary changes, a daily-rebuilt `compinit` dump, fzf with `fd` as the file source, zoxide, direnv, Nix sourced first, and the apt-packaged autosuggestions and syntax highlighting loaded last. Measure startup with `time zsh -i -c exit` (run twice; the second number is the real one).

### 3.9 Alacritty, font and Neovim install

- **Alacritty** is the IDE terminal and attaches to a tmux session automatically. GNOME Terminal stays untouched as the plain shell. Use the `Mono` Nerd Font variant (`JetBrainsMono Nerd Font Mono`) so icons occupy exactly one cell.
- **Font** is installed per user by Ansible and guarded by `creates:`, so it downloads once.
- **Neovim** comes from the official release tarball, not apt (Debian 13 ships 0.10). It installs into a versioned directory under `/opt`, and a stat gate keeps the play idempotent.

---

## 4. Troubleshooting quick table

| Symptom | Likely cause and fix |
|---|---|
| tmux splits do nothing | server still running an old config: `tmux source-file ~/.tmux.conf`, or `tmux kill-server` |
| `:gd` gives `E492` | `gd` is a normal-mode key sequence, not a command. For diffs use `Space g d` |
| `Ctrl-j` stops at the bottom nvim window | kickstart's `<C-w>` mapping wins; install vim-tmux-navigator and replace it. Check with `:verbose nmap <C-j>` |
| `Ctrl+Backspace` does nothing or moves a pane | it sends `^H`, which tmux intercepts; use the Alacritty remap to `^W` |
| `:Lazy` not found | this config uses `vim.pack`, not lazy.nvim |
| neo-tree stays after `:q` | `:q` closes one window; use `:qa` or set `close_if_last_window = true` |
| new tab has no tree | tab pages do not share windows; use `<cr>` buffers, bufferline, or the `TabNewEntered` autocmd |
| plugin command missing | not installed or declined at the prompt; restart nvim, accept, then check the `vim.pack` plugin list |
| files appear in `/root` after the play | `become` set at play or role level; keep it per task only |
| scrolling jumps in `less` or logs | use tmux copy mode (`Ctrl-Space [`) or `tmux capture-pane -pS - \| nvim -` |

Debugging commands to remember: `:verbose nmap <key>`, `:checkhealth`, `tmux list-keys`, `tmux show -g prefix`, `bindkey '<key>'`, `type -a nvim`.
