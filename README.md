# litecoin-example
[![Build Status](https://app.travis-ci.com/daniel-butler-irl/litecoin-example.svg?branch=main)](https://app.travis-ci.com/daniel-butler-irl/litecoin-example)

Example of Packaging Litecoin For Kubernetes

## Structure

- **Repository root**
    - *Makefile*  
      Abstract the build processes away from the CI pipeline to make the transition to different
      build systems easier.
    - **image**  
      Contains the OCI compliant image containing Litecoin
        - *Dockerfile*
    - **k8s**  
      Contains Kubernetes manifests for deployments
    - **pipelines**  
      Contains pipeline as code for this project

## Notes
Typically, I would set up [pre-commit](https://pre-commit.com/) hooks with [detect-secrets](https://github.com/Yelp/detect-secrets) and other relevent tools to catch
secrets being committed to source and catch as much before the code gets pushed. But in the interest of time I will be omitting this.
Other tools I would run in a pre-commit include. `Hadolint` to lint docker files, `Shellcheck` to analyze shell scripts for errors. `commitlint` to enforce commit message style.
This is also a requirement if using [Semantic-release](https://github.com/semantic-release/semantic-release) as it will bump the version number based on the conventional commit style, commit messages.
Linting tools for any other languages that may be in the repository. And various other small tools to clean up code format and keep
everyone's code clean. 