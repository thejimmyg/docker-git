# Docker Git

A simple docker container for Git over SSH.

```
npm install
mkdir keys
mkdir hostkeys
mkdir repo
npm run docker:run:local
```

Create a key if you don't already have one:

```
ssh-keygen -t rsa
```

Copy public keys to `keys/authorized_keys`:

```
cat ~/.ssh/id_rsa.pub >> keys/authorized_keys
```

Run the container:

```
npm run docker:run
```

Create a repo:

```
cd repo/
git init --bare test
# Give the git user from within the container permission to write to the new repo:
chmod -R 777 test
ls test/
cd ..
```

Clone it somewhere:

```
git clone ssh://git@localhost:8022/git/repo/test
cd test/
```

Make changes and push back:

```
vim README.md
git add -p
git add README.md
git commit -m "Initial commit"
git push  origin master
```

Note that you didn't need to do anything in the container. Internally, the
container saves its SSH keys in the `hostkeys` directory you mounted into it
and it reads the `git` user's SSH key from `keys/authorized_keys`. It shares
the `repo` directory where repos are stored.

There is a sample `docker-compose.yml` in the repo that you can use in your
setup. Replace the `build` line with the particular version of the image you
want to use:

```
    image: thejimmyg/docker-git:xxx
```

## Changelog

### 0.1.1 2019-01-02

* Shortened the sleep time in the `while` loop to 0.5 seconds so that the signal handler can respond more quickly to restarts.
* Removed printing of the `.` character during while loop.

### 0.1.0 2018-12-11

* Added `docker-compose.yml` file
* Added signal handlers for `SIGTERM` and `SIGINT`
