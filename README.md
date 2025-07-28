# sz-sdk-r

## Synopsis

This is a demonstration of using Senzing within the [R] programming language.

## Overview

Senzing does not provide a dedicated SDK (Software Development Kit) for the R programming language.
However by using the technique of having R call Python, the Senzing Python SDK can do the "heavy lifting"
of calling Senzing. The following demonstrates how to do that.

## Prerequisites

- [R] - Version 4.5.0 or greater
- [Docker]

## Run Senzing gRPC server

For convenience, use the `senzing/serve-grpc` Docker container.

```console
docker run -it --rm -p 8261:8261 --rm senzing/serve-grpc
```

## Prepare Python environment

Install the Python [senzing-grpc] package into a virtual environment.
**Note:** The example R scripts use the virtual environment located in the `~/.venv` directory.

```console
python3 -m venv ~/.venv
source ~/.venv/bin/activate
python3 -m pip install --upgrade senzing-grpc
```

Bring up the Python interpreter.

```console
python3
```

Run the following in the Python interpreter to verify that Senzing is reachable.

```python
import grpc
from senzing_grpc import SzAbstractFactoryGrpc
sz_abstract_factory = SzAbstractFactoryGrpc(grpc_channel=grpc.insecure_channel("localhost:8261"))
sz_product = sz_abstract_factory.create_product()
print(sz_product.get_version())
quit()
```

## Prepare R environment

```console
sudo Rscript -e 'install.packages("bit64", repos="https://cloud.r-project.org")'
sudo Rscript -e 'install.packages("dplyr", repos="https://cloud.r-project.org")'
sudo Rscript -e 'install.packages("httr", repos="https://cloud.r-project.org")'
sudo Rscript -e 'install.packages("reticulate", repos="https://cloud.r-project.org")'
```

## Run example R scripts

- [senzing-hello-world-grpc.R] - Prints the Senzing version
- [senzing-load-truthsets-grpc.R] - Downloads Senzing TruthSets, registers data sources, and load records.

Additional examples can be found in the testcases.

- [tests/testthat]

## References

1. [Development]
1. [Errors]
1. [Examples]

[Development]: docs/development.md
[Docker]:  https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/docker.md
[Errors]: docs/errors.md
[Examples]: docs/examples.md
[R]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/r.md
[senzing-grpc]: https://github.com/senzing-garage/sz-sdk-python-grpc
[senzing-hello-world-grpc.R]: ./examples/grpc/senzing-hello-world-grpc.R
[senzing-load-truthsets-grpc.R]: ./examples/grpc/senzing-load-truthsets-grpc.R
[tests/testthat]: ./tests/testthat
