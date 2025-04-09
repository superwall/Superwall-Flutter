# Superwall Test App

This is a Testing app for automated UI tests of Superwall Flutter plugin

## Running Maestro Tests

Maestro is a UI testing framework that allows writing and running UI automation tests in YAML format. This README explains how to run the Maestro tests in this directory.

## Prerequisites

1. Install Maestro CLI
   ```bash
   # macOS
    brew tap mobile-dev-inc/tap
    brew install maestro
   ```

2. Ensure you have a running simulator/emulator or connected physical device

## Running Tests

### Run a single test

```bash
maestro test test_app/maestro/flow.yaml
```

### Run all tests

```bash
maestro test test_app/maestro/
```

### Run tests with specific tags

```bash
maestro test -t tagname test_app/maestro/
```

## Test Structure

This directory contains the following types of tests:
- Main flow tests (.yaml files)
- Helper flows that can be reused
- Specialized directories for specific testing scenarios:
  - `handler/`: Handler-related tests
  - `delegate/`: Delegate-related tests
  - `purchasecontroller/`: Purchase controller tests


For more detailed information, refer to the full Maestro documentation. 