# Workflows

## add-labels-standardized.yaml

When issues are opened,
this action adds appropriate labels to the issue.
(e.g. "triage", "customer-submission")

- [Add Labels Standardized GitHub Action]
  - Uses: [senzing-factory/build-resources/.../add-labels-to-issue.yaml]

## add-to-project-garage-dependabot.yaml

When a Dependabot Pull Request (PR) is made against `main` branch,
this action adds the PR to the "Garage" project board as "In Progress".

- [Add to Project Garage Dependabot GitHub Action]
  - Uses: [senzing-factory/build-resources/.../add-to-project-dependabot.yaml]

## add-to-project-garage.yaml

When an issue is created,
this action adds the issue to the "Garage" board as "Backlog".

- [Add to Project Garage GitHub Action]
  - Uses: [senzing-factory/build-resources/.../add-to-project.yaml]

## dependabot-approve-and-merge.yaml

When a Dependabot Pull Request (PR) is made against the `main` branch,
this action determines if it should be automatically approved and merged into the `main` branch.
Once this action occurs [move-pr-to-done-dependabot.yaml] moves the PR on the "Garage" project board to "Done".

- [Dependabot Approve and Merge GitHub Action]
  - Uses: [senzing-factory/build-resources/.../dependabot-approve-and-merge.yaml]

## lint-workflows.yaml

When a change is committed to GitHub or a Pull Request is made against the `main` branch,
this action runs [super-linter] to run multiple linters against the code.

- [Lint Workflows GitHub Action]
  - Configuration:
    - [.checkov.yaml]
    - [.jscpd.json]
    - [.yaml-lint.yml]
  - Uses: [senzing-factory/build-resources/.../lint-workflows.yaml]

## move-pr-to-done-dependabot.yaml

When a Pull Request is merged into the `main` branch,
this action moves the PR on the "Garage" project board to "Done".

- [Move PR to Done Dependabot GitHub Action]
  - Uses: [senzing-factory/build-resources/.../move-pr-to-done-dependabot.yaml]

## claude-pr-review.yaml

When a Pull Request is opened or updated,
this action runs an automated Claude code review.

## dependency-scan.yaml

When a Pull Request is made against the `main` branch,
this action runs [pip-audit] against the Python dependencies declared in
`pyproject.toml` (the `senzing-core` / `senzing-grpc` packages imported via reticulate).

## link-issues-to-pr-post-merge.yaml

When a Pull Request is merged,
this action links the referenced issues to the Pull Request.

## lintr.yaml

When a Pull Request is made against the `main` branch,
this action runs [lintr] against the R sources (honoring the repository `.lintr`).

## spellcheck.yaml

When a change is committed to GitHub or a Pull Request is made against the `main` branch,
this action runs [cspell] to spell-check the repository.

## styler.yaml

When a Pull Request is made against the `main` branch,
this action runs [styler] and fails if any R file is not already formatted.

## testthat.yaml

When a change is committed to GitHub or a Pull Request is made against the `main` branch,
this action installs the Senzing SDK and runs the testthat core suite
(`tests/test-core.R`). The gRPC suite (`tests/test-grpc.R`) requires a running
Senzing gRPC server on `localhost:8261` and is not yet wired into CI.

[.checkov.yaml]: ../linters/README.md#checkovyaml
[.jscpd.json]: ../linters/README.md#jscpdjson
[.yaml-lint.yml]: ../linters/README.md#yaml-lintyml
[Add Labels Standardized GitHub Action]: add-labels-standardized.yaml
[Add to Project Garage Dependabot GitHub Action]: add-to-project-garage-dependabot.yaml
[Add to Project Garage GitHub Action]: add-to-project-garage.yaml
[Dependabot Approve and Merge GitHub Action]: dependabot-approve-and-merge.yaml
[Lint Workflows GitHub Action]: lint-workflows.yaml
[Move PR to Done Dependabot GitHub Action]: move-pr-to-done-dependabot.yaml
[move-pr-to-done-dependabot.yaml]: move-pr-to-done-dependabotyaml
[senzing-factory/build-resources/.../add-labels-to-issue.yaml]: https://github.com/senzing-factory/build-resources/blob/main/.github/workflows/add-labels-to-issue.yaml
[senzing-factory/build-resources/.../add-to-project-dependabot.yaml]: https://github.com/senzing-factory/build-resources/blob/main/.github/workflows/add-to-project-dependabot.yaml
[senzing-factory/build-resources/.../add-to-project.yaml]: https://github.com/senzing-factory/build-resources/blob/main/.github/workflows/add-to-project.yaml
[senzing-factory/build-resources/.../dependabot-approve-and-merge.yaml]: https://github.com/senzing-factory/build-resources/blob/main/.github/workflows/dependabot-approve-and-merge.yaml
[senzing-factory/build-resources/.../lint-workflows.yaml]: https://github.com/senzing-factory/build-resources/blob/main/.github/workflows/lint-workflows.yaml
[senzing-factory/build-resources/.../move-pr-to-done-dependabot.yaml]: https://github.com/senzing-factory/build-resources/blob/main/.github/workflows/move-pr-to-done-dependabot.yaml
[super-linter]: https://github.com/super-linter/super-linter
[pip-audit]: https://github.com/pypa/pip-audit
[lintr]: https://lintr.r-lib.org/
[styler]: https://styler.r-lib.org/
[cspell]: https://cspell.org/
