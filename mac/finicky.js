export default {
  defaultBrowser: "Browserino",
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
      match: finicky.matchHostnames(["orttohq.slack.com", "meet.google.com", "buildkite.com", "trello.com", "ortto.awsapps.com", "ortto.scalr.io"]),
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
      match: ({opener}) => ["Mattermost", "Signal"].includes(opener.name),
      browser: "Chromium"
    }
  ]
}
