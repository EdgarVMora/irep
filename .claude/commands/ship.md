# Ship — Final Review + PR

Run a final polish pass and create the PR.

## Step 1: Final Review
Use the **reviewer** agent for a complete final review of all changes since main. The reviewer will fix any remaining issues.

## Step 2: Build + Test
```bash
xcodebuild test -project irep.xcodeproj -scheme "irep Watch App" \
  -destination 'platform=watchOS Simulator,name=Apple Watch Series 10 (46mm)' \
  2>&1 | grep -E "(Test Suite|passed|failed|error:)"
```

All tests must pass before creating the PR. Fix failures if found.

## Step 3: Create PR
Use the `/pr` skill to create the pull request with:
- User-facing description of what changed
- Acceptance criteria as a checklist
- Test plan describing what was tested
