# 🕵️ Build Info Detective


💻🔍 Get ready to geek out with this ultimate repo diagnostic tool! 🔬

Introducing the Build Info Detective 💥
It's like a super-sleuth for your GitHub repos, providing you with crystal clear information on the state of your repo, runner, GitHub variables, and more! 🔎

With this handy tool, you'll be able to keep a close eye on the pulse of your repos, easily checking on tags and versions, and making sure everything is running smoothly. 💻

And the best part? It's super easy to use! Simply run it at the start of your workflow, right after you've checked out your code. 🚀

Perfect for those using self-hosted runners, the Repo State Dumper is the ultimate way to keep your repos healthy, efficient, and always running like clockwork. 🕰️💥

## Inputs

## `read-package.json`

**Optional** dump standard attributes of package.json

## Example usage

Print generic info for any kind of project
```
uses: michakfromparis/build-info-detective

Print name, version from package.json in a sub directory
```
uses: michakfromparis/build-info-detective
with:
  read-package-json: true
  package-json-path: /workspace/front/package.json
```
