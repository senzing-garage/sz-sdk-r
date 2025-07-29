# sz-sdk-r development

The following instructions are useful during development.

**Note:** This has been tested on Linux and Darwin/macOS.
It has not been tested on Windows.

## Prerequisites for development

:thinking: The following tasks need to be complete before proceeding.
These are "one-time tasks" which may already have been completed.

1. The following software programs need to be installed:
    1. [git]
    1. [make]
    1. [docker]

## Install Senzing C library

Since the Senzing library is a prerequisite, it must be installed first.

1. Verify Senzing C shared objects, configuration, and SDK header files are installed.
    1. `/opt/senzing/er/lib`
    1. `/opt/senzing/er/sdk/c`
    1. `/etc/opt/senzing`

1. If not installed, see [How to Install Senzing for Go Development].

## Install Git repository

1. Identify git repository.

    ```console
    export GIT_ACCOUNT=senzing-garage
    export GIT_REPOSITORY=sz-sdk-r
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"

    ```

1. Using the environment variables values just set, follow
   steps in [clone-repository] to install the Git repository.

## Dependencies

1. A one-time command to install dependencies needed for `make` targets.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make dependencies-for-development

    ```

1. Install dependencies needed for [Go] code.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make dependencies

    ```

## Lint

1. Run linting.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make lint

    ```

## Run

1. Start Senzing gRPC server

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make clean setup
    ```

1. Run program.
   Examples:

    1. Linux

        1. gRPC

            ```console
            ${GIT_REPOSITORY_DIR}/examples/grpc/senzing-hello-world.R
            ```

            ```console
            ${GIT_REPOSITORY_DIR}/examples/grpc/senzing-load-truthsets.R
            ```

        1. core

            ```console
            ${GIT_REPOSITORY_DIR}/examples/core/senzing-hello-world.R
            ```

            ```console
            ${GIT_REPOSITORY_DIR}/examples/core/senzing-load-truthsets.R
            ```

1. Clean up.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make clean
    ```

## Test

1. Run tests.
   Example:

    ```console
    cd ${GIT_REPOSITORY_DIR}
    make clean setup test

    ```

## Debugging

### View SQLite

1. View the SQLite database.
   Example:

    ```console
    docker run \
        --env SQLITE_DATABASE=G2C.db \
        --interactive \
        --name SqliteWeb \
        --publish 9174:8080 \
        --rm \
        --tty \
        --volume /tmp/sqlite:/data \
        coleifer/sqlite-web

    ```

   Visit [localhost:9174](http://localhost:9174).

## References

[clone-repository]: https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/clone-repository.md
[docker]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/docker.md
[git]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/git.md
[go]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/go.md
[How to Install Senzing for Go Development]: https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/install-senzing-for-go-development.md
[make]: https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/make.md
