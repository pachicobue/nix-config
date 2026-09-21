import json
import subprocess
import sys

RTK = "@rtk@"

data = json.load(sys.stdin)
command = data.get("tool_input", {}).get("command")
if not isinstance(command, str):
    sys.exit(0)

result = subprocess.run(
    [RTK, "rewrite", "--", command], capture_output=True, text=True
)
rewritten = result.stdout.strip()
if result.returncode != 0 or not rewritten or rewritten == command:
    sys.exit(0)

output = {
    "hookEventName": "PreToolUse",
    "updatedInput": {"command": rewritten},
}
# Codex requires allow for updatedInput; Claude Code does not, and adding it
# there would override the normal permission decision.
if "--codex" in sys.argv[1:]:
    output["permissionDecision"] = "allow"

json.dump(
    {
        "hookSpecificOutput": output
    },
    sys.stdout,
)
