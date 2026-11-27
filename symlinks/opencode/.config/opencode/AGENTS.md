# Personal instructions

## Running commands

- Run commands yourself instead of asking me to run them (for example Stow, `vim.pack`, deploys, reloads). Only hand off what genuinely needs me, such as a login or 2FA.

## Browser

- Always use my browser through the `browse` MCP server (`tools.browse.*`) to read web pages. Do not use `webfetch`.
- When I ask you to use, drive or take over my browser, use the `browse` MCP server (`tools.browse.*`). Do not use the in-app browser (`tools.browser.*`) or load the `browser` skill unless I ask for it by name.
- If a site blocks you or needs a login, use my browser through `browse` without asking.

## Home Assistant

- Use the `home_assistant_mcp` MCP server for everything Home Assistant: reading state, history, config and dashboards, and verifying changes. Never use a logged-in browser for Home Assistant, and never ask me to log in.
- To see a dashboard, call `ha_get_dashboard_screenshot` through `ha_call_read_tool` (for example `url_path: "dashboard-main", view_path: "solar"`), or pass `include_screenshot: true` to `ha_config_get_dashboard`. It renders through the Puppet engine (`home-assistant-mcp-screenshot`) and returns the image directly.
- Home Assistant config and the YAML dashboards (`dashboard-main` and the other `ui_lovelace_minimalist` dashboards) live in `~/repos/ansible/files/home-assistant/` and deploy with `ansible-playbook home-assistant.yml --tags dashboard` from `~/repos/ansible`.
- Home Assistant only reloads a YAML dashboard when its main file changes, not an included page. After deploying a changed page, run `ssh homeserver "sudo touch /apps/home-assistant/config/ui_lovelace_minimalist/dashboard/dashboard-main.yaml"` before taking a screenshot.
