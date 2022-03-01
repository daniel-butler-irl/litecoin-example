# litecoin-example
[![Build Status](https://app.travis-ci.com/daniel-butler-irl/litecoin-example.svg?branch=main)](https://app.travis-ci.com/daniel-butler-irl/litecoin-example)

Example of Packaging Litecoin For Kubernetes

## Answers

1. [image](image)
2. [k8s](k8s)
3. [pipeline](.travis.yml)
4. [shell script](image/scripts/readiness.sh)
5. [advance script](image/scripts/readiness.py)
6. [terraform](terraform)

## Structure

- **Repository root**
    - **[image](#image)**  
      Contains the OCI compliant image containing Litecoin
        - *Dockerfile*
        - **scripts** 
          Some convoluted scripts for use as readiness probe in k8s
    - **[k8s](#k8s)**  
      Contains Kubernetes manifests for deployments
    - **[terraform](#terraform)**  
      Contains a sample terraform module
    - *[Makefile](#makefile)*  
      Abstract the build processes away from the CI pipeline to make the transition to different
      build systems easier. Simplify the command for the developer.
    - *[.travis.yml](#travisyml)*  
      Pipeline for this project

## Notes
Some of my decisions where made to show of concepts and not necessarily always the best way of doing things. 


### image
OCI compliant image. Multistage build is used so, we do not ship any build tools or other unnecessary artifacts in the final 
image. RedHat's UBI image was chosen as it is more security focused than say an alpine image. Note at time of building since I am
not using a RedHat subscription there is at least 1 High severity vulnerability that has not yet been pushed to the free public repo.
If I had more time I also would have implemented the GPG Verification. In a production environment I would also not directly pull
from the public internet, instead use Artifactory or similar to mirror public sources in order to help against supply chain attacks.

### k8s
I did not spend too much time learning Litecoin but, I imagine I could have implemented some sort of k8s service either internal for the
pods to communicate with each other or a LoadBalancer type and/or an Ingress for external connections depending on the use case. 
Everything is hardcoded in the manifests to save time. Usually I would use Kustomize or Helm to make it more flexible for multiple environments.
The readiness probe is not a practical one I just wanted to tie in the script questions into it here. 

### terraform
To save me some time and since cloud provider was not specified I implemented in IBM Cloud as this is what I am currently 
using daily. As such for the question about creating a user, I used a Service ID which I think is closer to what you wanted. 
Users in IBM Cloud are tied to email addresses and supposed to be real people/functional ids. Service IDs are for representing
automation and applications. If I had more time I also would have wrote some basic tests for the module in `Terratest`.

### Makefile
Typically, I would set up [pre-commit](https://pre-commit.com/) hooks with [detect-secrets](https://github.com/Yelp/detect-secrets) and other relevent tools to catch
secrets being committed to source and catch as much before the code gets pushed. But in the interest of time I will be omitting this.
Other tools I would run in a pre-commit include. `Hadolint` to lint docker files, `Shellcheck` to analyze shell scripts for errors. `commitlint` to enforce commit message style.
This is also a requirement if using [Semantic-release](https://github.com/semantic-release/semantic-release) as it will bump the version number based on the conventional commit style, commit messages.
Linting tools for any other languages that may be in the repository. And various other small tools to clean up code format and keep
everyone's code clean.

I have put some of these checks in the test make command.

### .travis.yml
I used Travis here to build a quick simple pipeline. For more complex pipelines I would typically choose another CI/CD tool
such as Jenkins or Tekton. I only run the tests in the pipeline due to time constraints. I would have liked to put image security scanning
here but docker scan did not work out of the box, so I skipped it. Usually I use image scanning from our container registry, X-Ray scanning in artifactory 
or Vulnerability Advisor in IBM Cloud. I decided to only implement a push to dockerhub as the deployment step here. `kubectl apply -f k8s` as a deployment would 
not be acceptable for me. I could talk alot about deployment models and how to do it well in production, but it is out of scope for this project. 


## Developers
Use make command to build and run locally. 
- `make build` to build the container
- `make docker-scan` to scan the container for vulnerabilities
- `make push` push build to container registry. Environment variables `DOCKER_USERNAME` and `DOCKER_PASSWORD` expected to be set 
- `make test` run a set of tests against image, k8s manifests and Terraform
- `make docs` build documentation for this repository
- `make run` locally run the container of the latest build image
- `make deploy` deploys to application to k8s
- `make destory` deletes application from k8s
