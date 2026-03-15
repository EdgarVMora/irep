# Feature Workflow

You are orchestrating the full feature development workflow for the **irep** watchOS app. Follow these phases strictly and in order.

---

## PHASE 1 — Product Alignment (YOU ask, user answers)

Before any code is written, you must ask the user these questions. Ask all of them in one message. Do not skip this phase.

```
I need to understand the feature before planning. Please answer:

**Product**
1. What is the user's job-to-be-done? (What are they trying to accomplish?)
2. What triggers this feature? (A button tap, a sensor event, app launch, a complication tap?)
3. What is the success state the user sees?
4. Are there failure or edge cases the user should see explicitly?

**watchOS UX**
5. How many taps to complete the core action? (Target: ≤ 2)
6. Does this need to work when the user's wrist is down / screen off? (Background session?)
7. Should this appear as a complication on the watchface?
8. Does this interact with HealthKit data?

**Scope**
9. Is this replacing something existing, or purely additive?
10. Any explicit things this feature should NOT do?
```

Wait for the user's answers before proceeding.

---

## PHASE 2 — Planning

Use the **planner** agent with the feature description + user's answers from Phase 1.

The planner will produce:
- Task breakdown with parallel batches
- File list (create / modify)
- Acceptance criteria

Present the plan to the user and ask for approval before proceeding. If the user wants changes, update the plan.

---

## PHASE 3 — Parallel Implementation

Once the plan is approved, launch agents in parallel:

**Parallel Group A** (launch simultaneously):
- One or more **developer** agents — each scoped to a specific task from Batch 1 of the plan
  - If the plan has multiple independent files (e.g., a new Manager + a new View), launch separate developer agents for each
  - Pass them: the specific task, the full plan, and a reference to read `quality-constraints.md` and `watchos-patterns.md`
- One **tester** agent — scoped to write tests for the model/manager being built in Batch 1

**Sequential Group B** (after Group A completes):
- Developer agent(s) for Batch 2 tasks (views that depend on the model)

Keep the user updated: "Working on [X] and [Y] in parallel..."

---

## PHASE 4 — Build Verification

After all implementation is done, run the build:

```bash
xcodebuild -project irep.xcodeproj -scheme "irep Watch App" -configuration Debug \
  -destination 'platform=watchOS Simulator,name=Apple Watch Series 10 (46mm)' \
  build 2>&1 | tail -20
```

If build fails: read the errors, fix them, rebuild. Do not proceed to Phase 5 with a broken build.

Then run tests:

```bash
xcodebuild test -project irep.xcodeproj -scheme "irep Watch App" \
  -destination 'platform=watchOS Simulator,name=Apple Watch Series 10 (46mm)' \
  2>&1 | grep -E "Test (passed|failed|Suite)"
```

Fix any test failures before proceeding.

---

## PHASE 5 — Code Review

Use the **reviewer** agent on all changed files. The reviewer will:
1. Read the full diff (`git diff main...HEAD`)
2. Apply fixes directly
3. Report what was changed

After the reviewer finishes, run the build and tests once more to confirm nothing was broken by review fixes.

---

## PHASE 6 — PR

Use the `/pr` skill to create the pull request.

The PR must include:
- A clear description of what the feature does (user-facing language)
- Screenshots or descriptions of what changed visually (ask the user if they have simulator screenshots)
- The acceptance criteria from Phase 2 as a checklist
- Test plan

---

## Orchestration Notes

- You (the orchestrator) manage the workflow. You use the Agent tool to delegate to specialists.
- Never implement code yourself — always delegate to the developer agent.
- Never write tests yourself — always delegate to the tester agent.
- Never do the final review yourself — always delegate to the reviewer agent.
- If any agent reports a blocker, surface it to the user immediately rather than guessing a solution.
- Keep the user informed at each phase transition.
