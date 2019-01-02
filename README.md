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
git clone ssh://git@localhost/git/repo/test
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

If you want to use a different port on a remote host, for example 8022, you
need to use this version of the command:

```
git clone ssh://git@example.com:8022/git/repo/test
```

There is a sample `docker-compose.yml` in the repo that you can use in your
setup. Replace the `build` line with the particular version of the image you
want to use:

```
    image: thejimmyg/docker-git:xxx
```
