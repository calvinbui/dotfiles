module.exports = {
  defaultBrowser: "Browserosaurus",
  options: {
    hideIcon: true,
    checkForUpdate: false
  },
  handlers: [
    {
      match: ({opener}) => ["Slack", "Microsoft Outlook"].includes(opener.name),
      browser: "Google Chrome"
    },
    {
      match: ({ url }) => url.host === "slack.com",
      browser: "Google Chrome"
    },
    {
      match: ({ url }) => url.host.endsWith("amazonaws.com"),
      browser: "Google Chrome"
    },
    {
      match: "github.com/autopilot3/*",
      browser: "Google Chrome"
    },
    {
      match: ({ url }) => url.host === "meet.google.com",
      browser: "Google Chrome"
    },
    {
      match: ({opener}) => ["Mattermost", "Signal"].includes(opener.name),
      browser: "Chromium"
    }
  ]
}