# Commit
Bash script to use git.

Usage:
------

``` sh
bash commit.sh
```

Description:
------------

This script use git, in this way:
<ol>
	<li> git commit </li>
	<li> If you do not create branch, git stash </li>
	<li> Merge your branch to master </li>
	<li> If exist upstream remote repository, fetch upstream </li>
	<li> Merge upstream into master branch </li>
	<li> If your branch has diference with master, git merge </li>
	<li> Push to orgin </li>
	<li> Make tag </li>
</ol>