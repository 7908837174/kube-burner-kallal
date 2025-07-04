# Test Tags

kube-burner uses tags to categorize tests in the bats test suite. This allows for selective test execution in CI and during development.

## Tag Categories

Tests are categorized using the following tags:

- `core`: Essential functionality tests for kube-burner
- `init`: Tests that exercise the `init` command
- `index`: Tests that exercise the `index` command
- `delete`: Tests that focus on deletion operations
- `gc`: Tests related to garbage collection
- `metrics`: Tests for metrics collection and processing
- `indexing`: Tests related to the indexing functionality
- `latency`: Tests measuring and validating latency metrics
- `alerting`: Tests for the alerting subsystem
- `monitoring`: Tests related to monitoring functionality
- `kubevirt`: Tests specific to KubeVirt integration
- `cdi`: Tests specific to the Containerized Data Importer
- `crd`: Tests involving Custom Resource Definitions

## Adding Tags to Tests

Tags are added as comments immediately after the test declaration:

```bash
@test "my test name" {
  # Tags: core init metrics
  # Test implementation
}
```

## Running Tests with Tags

### Local Development

To run only tests with specific tags:

```bash
# Run only core tests
make test-k8s TEST_TAGS="core"

# Run tests with multiple tags (logical OR)
make test-k8s TEST_TAGS="core indexing"

# Combine with name filtering
make test-k8s TEST_TAGS="core" TEST_FILTER="init"
```

### CI Configuration

The CI system uses tags to distribute tests across different jobs:

1. The `ci-parallel.yml` workflow runs tests in parallel based on tags:
   - `test-k8s-core` job runs all tests tagged with "core"
   - `test-k8s-kubevirt` job runs all tests tagged with "kubevirt"

2. The standard `test-k8s.yml` workflow runs all tests without tag filtering.

## Best Practices

1. Each test should have at least one tag
2. Use specific tags that categorize the test's focus area
3. The `core` tag should be used for essential functionality tests
4. Add special tags for tests requiring specific environments
5. When adding a new test area, consider creating a new tag
