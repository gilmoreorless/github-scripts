#!/usr/bin/env python

import os
import json
import subprocess
from git import *
from sys import argv

def get_repo_info(path):
	repo_data = {
		'name': os.path.basename(path),
		'path': root
	}
	repo = Repo(path)
	# CHECKS:
	# v Uncommitted changes
	# / Branch list [origin/gh-pages only]
	# / GitHub master [needs fetch]
	#    v y/n
	#    v new local commits
	#    / new remote commits [needs fetch]
	# / GitHub gh-pages [needs fetch]
	#    v y/n
	#    v new local commits
	#    / new remote commits [needs fetch]
	# / GitHub upstream [indicates a fork]
	#    v y/n
	#    - new remote commits [needs fetch]
	# - Last commit date
	if repo.is_dirty:
		repo_data['dirty'] = True
	
	remotes = repo.remotes
	repo_data['origin'] = repo_data['upstream'] = False
	for remote in remotes:
		if remote.name in ('origin', 'upstream'):
			repo_data[remote.name] = True
			# remote.fetch() - MAKE THIS AN OPTION LATER

	repo_data['master'] = get_branch_info(repo, repo_data, 'master')
	repo_data['gh-pages'] = get_branch_info(repo, repo_data, 'gh-pages')
	return repo_data

def get_branch_info(repo, repo_data, branch_name):
	if not branch_name in repo.branches:
		return False
	branch_data = {
		'in_origin': False,
	}

	origin_branch_name = 'origin/' + branch_name
	print origin_branch_name
	if repo_data['origin']:
		try:
			head_remote = repo.rev_parse(origin_branch_name).hexsha
		except BadObject:
			head_remote = None
		print 'head_remote', head_remote
		if head_remote:
			branch_data['in_origin'] = True

			head_local = repo.rev_parse(branch_name).hexsha
			print 'head_local', head_local
			if head_local == head_remote:
				print 'Same refs, no difference'
				return branch_data
			
			# merge_base = repo.git.execute(['merge-base'])#, head_local, head_remote])
			# Hmm, repo.git.execute() above doesn't seem to work
			proc = subprocess.Popen(['git', 'merge-base', head_local, head_remote],
									cwd=repo.git.working_dir,
									stdout=subprocess.PIPE,
									stderr=subprocess.PIPE,
									)
			merge_base = proc.communicate()[0][:-1]  # Account for newline character at end of line
			print 'merge_base', merge_base

			if head_local != merge_base:
				commits_ahead = sum(1 for com in repo.iter_commits(merge_base + '..' + head_local))
				print 'commits_ahead', commits_ahead
				branch_data['commits_ahead'] = commits_ahead
			
			if head_remote != merge_base:
				commits_behind = sum(1 for com in repo.iter_commits(merge_base + '..' + head_remote))
				print 'commits_behind', commits_behind
				branch_data['commits_behind'] = commits_behind

	return branch_data

repos = []
userdir = os.getcwd()
if len(argv) > 1:
	userdir = argv[1]

print 'CWD:', userdir
for root, dirs, files in os.walk(userdir):
	if root != userdir:
		del dirs[:]
	if os.path.isdir(os.path.join(root, '.git')):
	# if root == userdir + '/css3-raphael-logo' and os.path.isdir(os.path.join(root, '.git')):
	# if root == userdir + '/jquery-dom-line' and os.path.isdir(os.path.join(root, '.git')):
		print '---', root, '---'
		repos.append(get_repo_info(root))

#print 'REPOS:', repos
for repo in repos:
#	os.chdir(repo['path'])
 	print 'REPO:', repo

