# Tests

## Dependencies

* docker
* docker-compose
* python 3

## Run tests

Execute [`test.bash`](test.bash).

## Upgrade python packages

The following will install the newest version of packages in requirements.txt.

``` bash
cat requirements.txt | sed 's/==.*//g' | xargs pip install -U
```

If updates are available --> update and create new version with:

``` bash
pip-chill > requirements.txt
```
