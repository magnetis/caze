# Change log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased

## [0.2.1] - 2017-12-19

- Fixed how the exceptions constants are created when `raise_use_case_exception`
  is on. The exceptions will inherit from `StandardError`, live under the
  use case constant and won't throw any already initialized constant warnings.

## [0.2.1] - 2016-02-29

### Change

- Change the way we raise the errors with the `raise_use_case_exception` option:
it does not instantiate the error again, but changes the parent class reference.

## [0.2.0] - 2016-01-07

### Change

- Raise errors from inside the use case context, so we can have names easier to identify.
- Add the complete backtrace to the raised error

## [0.1.1] - 2015-10-30

### Added

- Add support to raise errors with the use case name.

## [0.1.0] - 2015-10-20

### Added

- Add support to define use cases as string.
- Add CHANGELOG.md following the [Keep a changelog](http://keepachangelog.com/).

## [0.0.4] - 2015-04-10

### Fixed

- Fix the transactional method dispatch.

## [0.0.3] - 2015-02-05

### Changed

- Change main methods to define use cases and export them.
- Add more details about the API and how to use the lib at README.

[unreleased]: https://github.com/magnetis/caze/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/magnetis/caze/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/magnetis/caze/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/magnetis/caze/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/magnetis/caze/compare/v0.0.4...v0.1.0
[0.0.4]: https://github.com/magnetis/caze/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/magnetis/caze/compare/v0.0.2...v0.0.3
