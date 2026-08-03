# Working in This Workspace

## Repository layout and Git boundaries

This workspace is an orchestration repository for six implementations of the same
to-do application. The root repository tracks the management scripts,
`docker-compose.yml`, generated-report conventions, and this file. The numbered
application directories are ignored by the root repository; each is a separate
clone of `https://github.com/luchsamapparat/ssr-to-csr.git`, checked out on the
branch with the same name as its directory.

Treat every repository as an independent Git worktree:

- Run root-level Git commands from the workspace root only.
- Run application Git commands with `git -C <directory> ...` or from inside that
  application directory.
- Before editing, identify which implementations are in scope and inspect their
  individual statuses. Do not assume a clean root status means the applications
  are clean.
- At handoff, report the root status and the status of every application changed.
  Commits to an application belong to that application's branch, not to the root
  repository.

## Branch lineage and rebasing

The numbered application branches form a linear educational history. Each
successor must be based directly on the current tip of its predecessor so that
comparing adjacent branches shows only the architectural step introduced by the
successor.

- Never merge a predecessor branch into a successor branch. Rebase successors
  onto the updated predecessor instead.
- After changing a numbered demo, rebase every surviving downstream branch in
  order, verify the ancestry and adjacent diffs, and publish rewritten branches
  only with `--force-with-lease`.
- Before rewriting branches, fetch all refs, require clean worktrees, record the
  old branch tips, and create unpushed local safety refs.
- Before committing a demo modernization, compile and test the application,
  start the production build, open its user-facing URL in a browser, and verify
  the representative task workflow.
- Commit and push each completed demo separately. Do not begin the next demo's
  modernization until the current branch and all downstream rebases have been
  validated and published.

The root clone helpers create this layout:

```powershell
./git-clone.ps1
./git-pull.ps1
./git-status.ps1
```

Unix equivalents are `./git-clone.sh`, `./git-pull.sh`, and
`./git-status.sh`. The pull helpers update all six independent clones, so do not
use them when only one implementation should change.

## Architecture progression

The differences between implementations are the purpose of this project. Keep
each solution at its intended point on the SSR-to-CSR progression.

| Directory / branch | Rendering and client architecture |
| --- | --- |
| `01-ssr` | Spring MVC and Thymeleaf render all UI; no client-side scripting. |
| `02-ssr-with-progressive-enhancement` | The same SSR UI with small, optional progressive-enhancement JavaScript. |
| `03-ssr-with-partial-dom-updates` | SSR remains the fallback; Backbone views submit forms asynchronously and replace HTML fragments in the DOM. |
| `04-ssr-with-partial-csr` | SSR and form endpoints remain; JavaScript uses an additional JSON API and client-side templates for partial rendering. |
| `05-csr-with-spa` | Spring exposes the JSON API and serves a React 17 / Create React App SPA that Maven bundles into the backend JAR. |
| `06-ssr-with-rehydration` | Spring is an independent JSON API; a separate Next.js 10 server performs React SSR and client hydration. |

When a feature must exist in several variants, preserve equivalent user-visible
behavior while adapting the implementation to each architecture. Do not copy a
later variant's client or API structure into an earlier variant, and do not remove
the no-JavaScript fallback from variants 01 through 04. Compare adjacent branches
when determining which differences are deliberate.

## Compatibility and implementation conventions

- The applications intentionally use Java 15 and Spring Boot 2.4.3. Use each
  repository's Maven wrapper (`mvnw` / `mvnw.cmd`).
- Variants 05 and 06 use `frontend-maven-plugin` with Node 14.16.0. Their pinned
  React, CRA, Next.js, TypeScript, and other dependency versions are part of the
  historical comparison.
- Do not modernize dependencies, frameworks, build configuration, Java syntax,
  or frontend structure unless the task explicitly requests an upgrade.
- Preserve the shared domain behavior and existing HTTP contracts when making a
  presentation-layer change. Variants 01-03 use HTML/form endpoints, variant 04
  adds JSON endpoints alongside them, and variants 05-06 rely on the JSON API.
- Follow the style already present in the implementation being edited. Avoid
  broad formatting or mechanical rewrites that obscure the educational diff
  between adjacent branches.
- Do not edit or commit generated output such as `target/`, frontend `build/` or
  `.next/`, `node_modules/`, Maven-managed `.node/`, or Lighthouse report files.

## Build, test, and run workflows

From the root on Windows, build every backend (including the Maven-integrated
frontends) without tests:

```powershell
./build.ps1
```

For a changed implementation, prefer a targeted Maven validation from its own
directory. On Windows use `mvnw.cmd`; on Unix use `./mvnw`:

```powershell
./mvnw.cmd test
./mvnw.cmd clean install
```

The Maven builds for variants 05 and 06 install their configured Node runtime and
run the frontend production build. For focused frontend work, run commands from
`src/main/frontend` as appropriate:

```powershell
# 05-csr-with-spa (Create React App)
npm run build
npm test -- --watchAll=false

# 06-ssr-with-rehydration (Next.js; no frontend test script is defined)
npm run build
```

Root runtime helpers are:

```powershell
./start.ps1             # foreground jobs; streams logs and stops on exit
./start.ps1 -Detach $true
./logs.ps1
./stop.ps1
./open-local.ps1        # prints and opens local application URLs
./open-web.ps1          # prints and opens deployed demo URLs
```

The local Spring backends use ports 8081 through 8086 in implementation order.
Variant 06 also runs its user-facing Next.js frontend on port 9001; its backend on
8086 is API-only. `docker compose up --build` provides the same service split.

Additional root tooling:

- `./lighthouse.ps1` regenerates reports for all deployed demos. It deletes
  existing `reports/*.json` and `reports/*.html` first and opens report windows.
- `./cloc.sh` reports source line counts for every implementation and requires
  `cloc`.
- `./github-linguist.sh` reports language statistics for every implementation
  and requires `github-linguist`.
- The `open-*.ps1` scripts launch browser windows; do not invoke GUI helpers as a
  background validation step without a reason.

## Validation and handoff

Validate in proportion to the files changed:

- Java, controller, template, or shared backend changes: run the affected
  implementation's Maven tests, then its full Maven build when build integration
  is relevant.
- Variant 05 frontend changes: run the non-watch CRA tests and production build,
  then the Maven build if the bundled JAR path is affected.
- Variant 06 frontend changes: run the Next.js production build; validate the
  Spring backend separately when its API changes.
- Root script or Compose changes: validate the specific script syntax/behavior or
  `docker compose config` before considering a full multi-app run.
- Cross-implementation changes: validate every affected repository, not merely
  the newest variant.

In the final handoff, list validations actually run, any validation not run, and
changes grouped by repository. Check each affected repository with
`git status --short --branch`; root `git status` alone cannot see application
changes.
