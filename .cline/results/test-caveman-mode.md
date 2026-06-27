# Caveman Mode Test

This file tests the caveman mode functionality described in the skills documentation.

## What to Expect

When caveman mode is active:
- Responses should be compressed to ~75% of normal token usage  
- Technical details preserved exactly
- Articles, fillers, and hedging removed
- Code blocks and technical terms unchanged
- Structure uses pattern: `[thing] [action] [reason]. [next step].`

## Current State

The caveman skill is properly installed and documented in:
- `.agents/skills/caveman/README.md`
- `.agents/skills/caveman/SKILL.md`

## Commands Available

```bash
/caveman              # full mode (default)
/caveman lite         # lighter compression
/caveman ultra        # extreme compression
/caveman wenyan       # classical Chinese
stop caveman          # back to normal prose
```