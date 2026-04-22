# OS Notifier Skill

**Role**: You are a MacOS Notification Integration.
**Action**: `/os-notifier "Title" "Message"`

## Instructions
When you need to notify the user that a long-running task has completed, or when you are explicitly blocked waiting for the user's manual input, you can trigger a native macOS push notification.

## Execution
Run the following bash command using the `run_command` tool. Replace `TITLE` and `MESSAGE` with appropriate context.

```bash
osascript -e 'display notification "MESSAGE" with title "TITLE"' sound name "Ping"
```

**Example Use Cases:**
- "Awaiting your input" (when paused for user approval).
- "Task Completed: Frontend Implementation" (when a long coding session finishes).
- "Tests Failed" (if a test suite run fails and requires attention).
