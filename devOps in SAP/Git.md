# Git 

### Git and Github

Git is a tool of version control, it helps us manage each version of our codes locally. And Github is a platform where can we upload our local codes to, therefore we can share our codes with others and maybe get help from them, this is the base of co-work on one project. 

### basic knowledge about git

* git workflow

  ![git workflow](https://upload-images.jianshu.io/upload_images/3985563-ade5b67f52f8675c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

  - workspace

    workplace is the place where you work in. It just likes you open project in VSCode and make changes on some files, all these changes just happen in workspace.

  - index

    index is the temporary storage area. In the .git directory of your project, there is a index file, git relies on this file to keep record the change information of files. The changes `git add .`command made will be marked in this area.

  - repository

    local repository store all versions of files.

  - remote

    remote repository is stored on github, every time you want to push your local changes to remote, at first you should pull remote branch to local to compare if there are conflicts, if not then push it to remote repository.

### common Git commands

```shell
git config -l
#lookup the configuration of your git
git config --global (user.name|user.email) (name|email)
#config your account
```

![img](https://upload-images.jianshu.io/upload_images/3985563-c7f05348b711ebbe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

### useful Git tutorial links

[git book](https://git-scm.com/book/en/v2)