# 🕵️ Build Info Detective


💻🔍 Get ready to geek out with this ultimate repo diagnostic tool! 🔬

Introducing the Build Info Detective 💥
It's like a super-sleuth for your GitHub repos, providing you with crystal clear information on the state of your repo, runner, GitHub variables, and more! 🔎

With this handy tool, you'll be able to keep a close eye on the pulse of your repos, easily checking on tags and versions, and making sure everything is running smoothly. 💻

And the best part? It's super easy to use! Simply run it at the start of your workflow, right after you've checked out your code. 🚀

Perfect for those using self-hosted runners, the Repo State Dumper is the ultimate way to keep your repos healthy, efficient, and always running like clockwork. 🕰️💥

## Inputs

## `inspect-system` 
**[Optional]** prints system info. Defaults to true.

## `inspect-git` 
**[Optional]** prints git info. Defaults to true.

## `inspect-github-environment` 
**[Optional]** prints the value of the github environment variables.

## `inspect-environment` 
**[Optional]** prints the value of the environment variable names separated by a comma.

## `inspect-package-json` 
**[Optional]** prints name and version from package.json and compares version with tag version.
Defaults to false unless package.json present at root of repository.

## `package-json-path`
**[Optional]** set the full path to package.json
Defaults to root of repository.

## Example usage

Inspect system & git info
```
uses: michakfromparis/build-info-detective
```

Inspect git info
```
uses: michakfromparis/build-info-detective
with:
  inspect-system: false
  inspect-git: true
```

Inspect system info, git info and the ENVIRONMENT, APP_ENV & CONFIGURATION variables
```
uses: michakfromparis/build-info-detective
with:
  inspect-environment: 'ENVIRONMENT, APP_ENV, CONFIGURATION'
```

Inspect system info, git info & package. name, version from package.json.
If on a version tagged branch, compare the version with the tag version
```
uses: michakfromparis/build-info-detective
with:
  inspect-package-json: true
```

If on a monorepo, specify the full path to package.json
```
uses: michakfromparis/build-info-detective
with:
  inspect-package-json: true
  package-json-path: workspace/front/package.json
```
