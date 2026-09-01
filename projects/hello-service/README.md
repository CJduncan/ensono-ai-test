# Hello Service

Owner: @CJduncan
Slug: `hello-service`

## What this is

_One or two lines: what does this project do?_

## How CI runs it

On every PR that touches `projects/hello-service/`, GitHub runs this project's
`ci.sh`. Keep that script as the single entry point — whatever it needs to
install and test lives inside it. The default here installs `requirements.txt`
and runs `pytest`.

## Layout

```
hello-service/
  ci.sh             what CI runs — edit this to change how the project is tested
  pyproject.toml    pytest config (adds the project root to the import path)
  requirements.txt  test/runtime deps
  src/              your code
  tests/            your tests
```
