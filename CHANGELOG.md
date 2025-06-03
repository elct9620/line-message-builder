# Changelog

## [0.9.0](https://github.com/elct9620/line-message-builder/compare/v0.8.0...v0.9.0) (2025-06-03)


### Features

* add flex separator matcher and tests for flex message components ([0d34bc9](https://github.com/elct9620/line-message-builder/commit/0d34bc9fcfeef9d2ca519548f4a83a3de046eb33))
* add Flex::Span message builder for LINE messaging API ([a8377e9](https://github.com/elct9620/line-message-builder/commit/a8377e93861fa286e95a69d3cb3c9897c1992044))
* add have_line_flex_span matcher and comprehensive tests for span component ([b9072cd](https://github.com/elct9620/line-message-builder/commit/b9072cd3e4c56c9346bb3d6cf98ee11374029807))
* add Separator builder for Flex messages ([accb2aa](https://github.com/elct9620/line-message-builder/commit/accb2aa41f9a016445f377f97e93f085734764c4))
* add separator method to Flex::Box for adding separator elements ([4125ae1](https://github.com/elct9620/line-message-builder/commit/4125ae15fd5666431ec864121cf40d3c4fb0f56f))
* add Span component for styled text in Flex Messages ([a458d1d](https://github.com/elct9620/line-message-builder/commit/a458d1d2473e0859bc7e1c81254888a8c8fde9a7))
* add span method to flex box builder and remove related specs ([af8dc8f](https://github.com/elct9620/line-message-builder/commit/af8dc8f9f4b8c8a7a12c15db23a50331dfc102cb))
* add support for spans within flex text components ([90ab15d](https://github.com/elct9620/line-message-builder/commit/90ab15df7044d15308d23ef864a69f84d71e28e7))


### Bug Fixes

* add Flex::Separator component and require it in flex.rb ([4152c10](https://github.com/elct9620/line-message-builder/commit/4152c1024a7634b526f94fa4e76a518a6ff0787c))
* ensure matcher finds flex separator in all nested containers ([d289ea1](https://github.com/elct9620/line-message-builder/commit/d289ea178e17d4ca00b796a9f666c527982d82f6))
* remove duplicate Separator class definition in flex separator.rb ([2c6b6d0](https://github.com/elct9620/line-message-builder/commit/2c6b6d063a2da97a0781591a697cf3034cb135f6))

## [0.8.0](https://github.com/elct9620/line-message-builder/compare/v0.7.0...v0.8.0) (2025-05-24)


### Features

* Add GitHub Action for RDoc generation and deployment ([dbb0f79](https://github.com/elct9620/line-message-builder/commit/dbb0f797ae6143bb9f463c8e6c111a5fe1f0a53f))
* Add GitHub Action for RDoc generation and deployment ([#9](https://github.com/elct9620/line-message-builder/issues/9)) ([c1a9920](https://github.com/elct9620/line-message-builder/commit/c1a99203b3abef99d149ecc7a055367268f5c2f8))
* add mode option to Line::Message::Builder for SDKv2 support ([f44f787](https://github.com/elct9620/line-message-builder/commit/f44f78758f5cac1dda6cf86f4c1945365c6c1018))


### Bug Fixes

* pass context to quick reply actions to resolve sdkv2 method error ([1bec753](https://github.com/elct9620/line-message-builder/commit/1bec7539421c0c11b10d2e906f9ee7f44a1c726f))

## [0.7.0](https://github.com/elct9620/line-message-builder/compare/v0.6.1...v0.7.0) (2025-05-21)


### Features

* add assigns feature to flex partial with context override ([76c1d34](https://github.com/elct9620/line-message-builder/commit/76c1d34569d031ce6ddf64e948d33cd26a12b231))
* add context with assigns support for flex message partials ([1c4c89f](https://github.com/elct9620/line-message-builder/commit/1c4c89f590dd251fb0def48109961469c136bd86))
* add partial support for Flex message components ([57ff183](https://github.com/elct9620/line-message-builder/commit/57ff183b173e4c62e7119862df343c9d8a1174bd))

## [0.6.1](https://github.com/elct9620/line-message-builder/compare/v0.6.0...v0.6.1) (2025-05-13)


### Bug Fixes

* change default option values from :nil to nil ([4f87919](https://github.com/elct9620/line-message-builder/commit/4f879191b129b7a1780b690c9949afe9e8f87bcc))

## [0.6.0](https://github.com/elct9620/line-message-builder/compare/v0.5.0...v0.6.0) (2025-04-07)


### Features

* Add Flex carousel support for Line message builder ([757b16d](https://github.com/elct9620/line-message-builder/commit/757b16d2f71ff14cff39aa1990773851bc78192b))
* Add height and max_height options to flex box with validation ([932c743](https://github.com/elct9620/line-message-builder/commit/932c7435ea11a3dec7903ffa19c48a5987231e39))
* Add shrink-to-fit adjust mode for flex buttons and texts ([b3ce3a2](https://github.com/elct9620/line-message-builder/commit/b3ce3a29614514b3049d5b6ad718b3dbcd283898))
* Add width and max_width options to flex box builder ([3d20c98](https://github.com/elct9620/line-message-builder/commit/3d20c98e670f49fad3f35c93d88364fb7f14afc0))

## [0.5.0](https://github.com/elct9620/line-message-builder/compare/v0.4.0...v0.5.0) (2025-04-07)


### Features

* Add Actionable module for flex components with message and postback actions ([9ac4b4a](https://github.com/elct9620/line-message-builder/commit/9ac4b4af591450e8f1925814b5a57e893ffa15db))
* Add enum validator for flex text alignment options ([540c58d](https://github.com/elct9620/line-message-builder/commit/540c58d94731adfe91d30e006bb0ee6714755006))
* Add justify_content and align_items options to Flex Box builder ([6c2015f](https://github.com/elct9620/line-message-builder/commit/6c2015f0a75a0f541cb52fef647e0bff1a245a28))
* Add layout validation for flex box with enum validator ([b1ecba1](https://github.com/elct9620/line-message-builder/commit/b1ecba160db03f94aaebc83b82158e75292c94eb))
* Add margin support for flex components in Line message builder ([36043b8](https://github.com/elct9620/line-message-builder/commit/36043b8d7390cb13d60174759fc5906a70aa2507))
* Add offset positioning support for flex message components ([1e28336](https://github.com/elct9620/line-message-builder/commit/1e2833656083aa72b0cfffccd5636e80ae41ccc9))
* Add padding support for flex box components with validation ([9dcd9d2](https://github.com/elct9620/line-message-builder/commit/9dcd9d20a48aed023440a2abe24e8b44eea8b425))
* Add padding support for Line Flex buttons with validation ([ca25a11](https://github.com/elct9620/line-message-builder/commit/ca25a1192c0d611ae064f935fc9335640d123b2d))
* Add SimpleCov Cobertura formatter for CI coverage reporting ([bb5bfc8](https://github.com/elct9620/line-message-builder/commit/bb5bfc8344c1b448e61a2857aa36e1f6b5ce0425))
* Add validator for spacing option in flex box builder ([06e7b98](https://github.com/elct9620/line-message-builder/commit/06e7b9805f8243c51faaf9c13c264ffb1f35091c))
* Add vertical positioning support for Flex message components ([f9ce97b](https://github.com/elct9620/line-message-builder/commit/f9ce97b666cabe47717cdd916722121372cb9bf0))


### Bug Fixes

* Correct indentation in GitHub Actions workflow file ([1c1cd2d](https://github.com/elct9620/line-message-builder/commit/1c1cd2dfe2e48bd937a04ac25f7b2b772e02e1a6))

## [0.4.0](https://github.com/elct9620/line-message-builder/compare/v0.3.0...v0.4.0) (2025-04-06)


### Features

* Add flex and margin options to Line Flex Button with improved error handling ([c8cd142](https://github.com/elct9620/line-message-builder/commit/c8cd1427528d5495d13bf93898da4638588065ae))
* Add flex box options and validation for LINE message builder ([133f87d](https://github.com/elct9620/line-message-builder/commit/133f87ddb3fd2a093947db0aef6363cd4c150701))
* Add flex bubble options and RSpec matcher for Line message builder ([605ad89](https://github.com/elct9620/line-message-builder/commit/605ad89870a53c55182f96db5f2738b5c347f0dc))
* Add margin option to flex text builder ([1d44522](https://github.com/elct9620/line-message-builder/commit/1d44522a44218bedab3d2009ef483ed112784248))
* Add quote token support for Line text messages ([7871999](https://github.com/elct9620/line-message-builder/commit/7871999dfc7032e75e5407c8b16bed7ef7dd28b8))
* Add support for flex, margin, and align options in Flex image builder ([693d0ab](https://github.com/elct9620/line-message-builder/commit/693d0abf5ef524b2e6d075f3c7e65eca49cf7f27))

## [0.3.0](https://github.com/elct9620/line-message-builder/compare/v0.2.0...v0.3.0) (2025-04-05)


### Miscellaneous Chores

* release 0.3.0 ([2f0b00c](https://github.com/elct9620/line-message-builder/commit/2f0b00c875a2d547c576e383aaeeae3bf777e898))

## [0.2.0](https://github.com/elct9620/line-message-builder/compare/v0.1.0...v0.2.0) (2025-04-05)


### Features

* Add Flex button component with message and postback actions ([0fe6ecb](https://github.com/elct9620/line-message-builder/commit/0fe6ecb4cdf17e180c4ca0230a810a6d62bead9b))
* Add Flex message builder support to Line message builder ([2f8e191](https://github.com/elct9620/line-message-builder/commit/2f8e191d466e94763b66829520e3f6de3bc83be7))
* Add Flex message components for Line messaging with Box, Bubble, and Text support ([92c2c14](https://github.com/elct9620/line-message-builder/commit/92c2c14be36307993452d1705110c8ffecd162da))
* Add image method to Flex::Box for creating flex images ([b111f67](https://github.com/elct9620/line-message-builder/commit/b111f67c50777855df09cf2fc7441dea21b13c5b))
* Add nested box support in Flex message builder ([b93ea98](https://github.com/elct9620/line-message-builder/commit/b93ea98130de3011bebbc9c216fbfa1de35c8270))
* Add optional parameters to Flex Bubble component methods ([5e37949](https://github.com/elct9620/line-message-builder/commit/5e379492c6235756e9c3e0ce2489da2202e59e45))
* Add quick reply support to Line message builder with RSpec matchers ([3ea78af](https://github.com/elct9620/line-message-builder/commit/3ea78af7cb0f4334e6d36b6b1567405ef6eb27f4))
* Add spec for Line flex text with various text attributes ([8501fb7](https://github.com/elct9620/line-message-builder/commit/8501fb7803bf679697034b9d113714557eaea6c3))
* Add support for alt_text in Flex message builder and RSpec matcher ([8b64ba4](https://github.com/elct9620/line-message-builder/commit/8b64ba4566245d10e95aaf88ed303c69f7eeecb2))
* Add support for button style and height in flex message matchers ([8de297d](https://github.com/elct9620/line-message-builder/commit/8de297d88a1d4276d6ceb221777b006cccb71257))
* Add support for hero images in Line Flex messages ([d776264](https://github.com/elct9620/line-message-builder/commit/d776264e6e276bd4048362ff3cdb6cc9dda91643))
