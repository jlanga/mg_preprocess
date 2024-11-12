# Changelog

## [1.3.0](https://github.com/jlanga/mg_preprocess/compare/v1.2.0...v1.3.0) (2024-11-12)


### Features

* bracken ([3265c15](https://github.com/jlanga/mg_preprocess/commit/3265c15ebe5f6ce71d26dc606bb0166bc561bbca))
* group preprocessing of hosts and samples ([6146cb7](https://github.com/jlanga/mg_preprocess/commit/6146cb71990246ab4e030f343837bc6f1ca11263))
* make nonpareil handle empty or near-empty files ([27ccc7d](https://github.com/jlanga/mg_preprocess/commit/27ccc7d9645238fd90632941c9894a69b021affc))
* remove unused samtools files ([889e363](https://github.com/jlanga/mg_preprocess/commit/889e3636c0810c8f8448ea69bbd2c03d5ef0d110))
* **singlem:** handle empty files ([d8f38f5](https://github.com/jlanga/mg_preprocess/commit/d8f38f5e90b9c77f438d6e9a9517f2dad48ce9c6))


### Bug Fixes

* add resources for kraken2 ([5f88e9e](https://github.com/jlanga/mg_preprocess/commit/5f88e9e5bb4bdf1a148a4dd3963d411d2368bb6b))
* correct test file names ([fb98517](https://github.com/jlanga/mg_preprocess/commit/fb985179937f951250352e52876f2865d8f63b44))
* use local functions, not the ones from snakehelpers ([f4efecb](https://github.com/jlanga/mg_preprocess/commit/f4efecb5055f6ef3c5625777499ba81070ac5405))

## [1.2.0](https://github.com/jlanga/mg_preprocess/compare/v1.1.1...v1.2.0) (2024-10-29)


### Features

* update singlem ([7eaa6d9](https://github.com/jlanga/mg_preprocess/commit/7eaa6d9c933f27f3aa3cdb7b921defb747d46ca0))


### Bug Fixes

* add the fastp json, not the html ([3963847](https://github.com/jlanga/mg_preprocess/commit/396384770f2103130a17313e95968c911593e61b))

## [1.1.1](https://github.com/jlanga/mg_preprocess/compare/v1.1.0...v1.1.1) (2024-10-21)


### Bug Fixes

* remove the all rule to avoid collisions and make preprocess__all the default one ([a6bed9e](https://github.com/jlanga/mg_preprocess/commit/a6bed9eee6ccd918bfdd6215bb1cae9e7c3d7ced))
* typo in rule name ([4e1590f](https://github.com/jlanga/mg_preprocess/commit/4e1590fc1263df35a755ac96bd8049367b68faf7))

## [1.1.0](https://github.com/jlanga/mg_preprocess/compare/v1.0.0...v1.1.0) (2024-10-18)


### Features

* add snakehelpers and remove redundant code ([e038d08](https://github.com/jlanga/mg_preprocess/commit/e038d08d3577ec35fcf8c1a27d6711acf76e6960))
* add unnamed rule as a surrogate of all ([f1281af](https://github.com/jlanga/mg_preprocess/commit/f1281af54c763e7a20765e105366a0c82c44c06a))
* append preprocessing__ for easier portability ([1ce6924](https://github.com/jlanga/mg_preprocess/commit/1ce69244e2f602f5a260db57d4faaebb43f7f585))


### Bug Fixes

* ask for multiqc folder ([c45294e](https://github.com/jlanga/mg_preprocess/commit/c45294e7ca71fb83124d2ca78f76991212afd557))
* put config although we don't use it ([3b4211f](https://github.com/jlanga/mg_preprocess/commit/3b4211fbb131f437006885d197afe93ea3bb60a0))
* put everything in results/preprocess ([98b3b7c](https://github.com/jlanga/mg_preprocess/commit/98b3b7cae9caeb4d5f9a1e297e1627e9299b24d2))
* remove anonymous rule ([0b4e524](https://github.com/jlanga/mg_preprocess/commit/0b4e524234b35be873d75a01d37b01af5ce0a399))

## 1.0.0 (2024-10-17)


### Features

* bowtie2 ([2d1b15b](https://github.com/jlanga/mg_preprocess/commit/2d1b15bc31592cb9502465ef6fc0306600331a17))
* initial commit ([c51c9ed](https://github.com/jlanga/mg_preprocess/commit/c51c9ed9b533849e1912de1c1323e314d956abcd))
* kraken2 + multiqc ([d4b9a20](https://github.com/jlanga/mg_preprocess/commit/d4b9a20d387d45d32d3c653e2a756c5b13e5ee41))
* nonpareil ([171ade8](https://github.com/jlanga/mg_preprocess/commit/171ade86274ebf8ec9edf3f62169b0a5caf61654))
* profile ([11beadf](https://github.com/jlanga/mg_preprocess/commit/11beadf29439d6d7573b7ae39e59b1fa427c3111))
* reads and fastp ([09fe479](https://github.com/jlanga/mg_preprocess/commit/09fe4793806054b59997068b9da2e07b3669ace6))
* singlem ([4e34a30](https://github.com/jlanga/mg_preprocess/commit/4e34a30c4de52b44e85f265d89f2186e20e3da53))
* store all bams and fastqs in the same folder ([a69df9b](https://github.com/jlanga/mg_preprocess/commit/a69df9b28665adab2e131ec2bedeeda98eec2faa))
* update yaml versions ([b557ff5](https://github.com/jlanga/mg_preprocess/commit/b557ff55b1e6685151f0ece51f40821fd187b7aa))
