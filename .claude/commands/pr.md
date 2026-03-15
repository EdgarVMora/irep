Create a pull request for the current branch against main. Follow these steps strictly:

1. **Gather context**: Run `git log main..HEAD`, `git diff main...HEAD`, and `git status` to understand all changes.

2. **Local PR review**: Review the diff carefully. Write a short, professional review (3-5 sentences) covering:
   - Code quality and adherence to CLAUDE.md conventions
   - Any issues or recommendations
   - End with "Approved" or list what should be changed

3. **If approved**, push the branch and create the PR using `gh pr create` with this body format:
   ```
   ## Description
   <What was done and why, in simple language>

   ## Changes
   <Short, simplified bullet list of changes>

   ## Notes
   <What to have in mind or tl;dr>
   ```

4. **After PR is created**, add a new line under "## PR Recommendations" in CLAUDE.md with a lesson learned from this PR review (if any).

5. Return the PR URL to the user.

Follow CLAUDE.md conventions strictly. Keep language simple and professional.
