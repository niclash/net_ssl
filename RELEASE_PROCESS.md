# How to cut a net-ssl release

This document is aimed at members of the Pony team who might be cutting a release of Pony. It serves as a checklist that can take you through doing a release step-by-step.

## Prerequisites

You must have commit access to the net-ssl repository

## Releasing

Please note that this document was written with the assumption that you are using a clone of the `net-ssl` repo. You have to be using a clone rather than a fork. It is advised to your do this by making a fresh clone of the `net-ssl` repo from which you will release.

```bash
git clone git@github.com:ponylang/net-ssl.git net-ssl-release-clean
cd net-ssl-release-clean
```

Before getting started, you will need a number for the version that you will be releasing as well as an agreed upon "golden commit" that will form the basis of the release.

The "golden commit" must be `HEAD` on the `master` branch of this repository. At this time, releasing from any other location is not supported.

For the duration of this document, that we are releasing version is `0.3.1`. Any place you see those values, please substitute your own version.

```bash
git tag release-0.3.1
git push origin release-0.3.1
```