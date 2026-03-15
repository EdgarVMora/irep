# Review Changed Code

Run a focused code review on all files changed since the main branch.

Use the **reviewer** agent to:
1. Get the full diff: `git diff main...HEAD`
2. Apply the complete review checklist from `.claude/context/quality-constraints.md`
3. Fix all issues found directly in the files
4. Report what was changed

Then build to confirm nothing is broken:
```bash
xcodebuild -project irep.xcodeproj -scheme "irep Watch App" -configuration Debug \
  -destination 'platform=watchOS Simulator,name=Apple Watch Series 10 (46mm)' \
  build 2>&1 | tail -20
```

Report the review summary to the user.
