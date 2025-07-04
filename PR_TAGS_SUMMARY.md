# Tag-Based Test Filtering Implementation

This PR implements tag-based filtering for bats tests in CI workflows as requested in PR #911. The changes enable more flexible test execution and better organization of test batches in the CI pipeline.

## Changes

### 1. Added Tags to Existing Tests

Added tags to all tests in `test/test-k8s.bats` using the following tag categories:

- `core`: Essential functionality tests
- `init`: Tests for the `init` command
- `index`: Tests for the `index` command 
- `delete`: Tests for deletion operations
- `gc`: Tests for garbage collection
- `metrics`: Tests for metrics collection
- `indexing`: Tests for indexing functionality
- `latency`: Tests for latency measurements
- `alerting`: Tests for the alerting system
- `monitoring`: Tests for monitoring functionality
- `kubevirt`: KubeVirt-specific tests
- `cdi`: CDI-specific tests
- `crd`: CRD-related tests

Tags are added as comments immediately after the test declaration:

```bash
@test "test name" {
  # Tags: core init
  # Test implementation
}
```

### 2. Updated Makefile

Modified the `test-k8s` target in the Makefile to support tag-based filtering:

```makefile
test-k8s:
	cd test && KUBE_BURNER=$(TEST_BINARY) bats $(if $(TEST_FILTER),--filter "$(TEST_FILTER)",) $(if $(TEST_TAGS),--filter-tags "$(TEST_TAGS)",) -F pretty -T --print-output-on-failure test-k8s.bats
```

This allows running tests with specific tags:
```
make test-k8s TEST_TAGS="core"
```

### 3. Updated CI Workflow

- Enhanced `test-k8s.yml` workflow to use a matrix approach with tags:
  - Added a matrix of test groups defined by tags
  - Each test group runs with its specific tag filter
  - Current test groups include "Core Tests" and "KubeVirt Tests"
  - Added build job to prepare the kube-burner binary for tests

### 4. Added Documentation

- Created `docs/contributing/test-tags.md` with detailed information on the tag system
- Updated `docs/contributing/tests.md` to include information about tag-based filtering
- Updated `mkdocs.yml` to include the new documentation in the navigation

## Usage

### For Developers

Run specific test groups during development:

```bash
# Run only core tests
make test-k8s TEST_TAGS="core"

# Run tests with multiple tags (logical OR)
make test-k8s TEST_TAGS="core indexing"

# Combine with name filtering
make test-k8s TEST_TAGS="core" TEST_FILTER="init"
```

### In CI

The parallel CI workflow automatically distributes tests across jobs based on tags, making the CI pipeline more efficient and allowing tests to be run in appropriate environments.

## Next Steps

1. Consider adding more specific tags as the test suite grows
2. Further optimize the CI pipeline by creating more targeted test batches
3. Consider adding tag-based filtering to other test suites in the project
