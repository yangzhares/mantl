
features-master - release branch
	1 only merges from qa-features-master-integration
	2 manual merging by PR after code review by approvers
	3 git tag
	4 ci using git tag should build new test
	4a should include multi data-center deployment
	5 security check, security check list

qa-features-master-integration - features not in production yet
	1 daily merge/rebase, rebase as priority
	1a ci to start integrity testing - rebase from master, PR from features or personal triggered
	2 manual merging by PR after code review by approvers

master (core services)
	1 only PRs from features or personal devs
	2 manual merging by PR after code review by approvers
	3 git tag when milestone has been reached
	4 ci using should build new test
	4a should include multi data-center deployment
	5 security check, security check list

feature/*
	1 must be branched only from master or features-master
	2 manual testing
	3 open PR to master or qa-features-master-integration
	4 get approve from maintainer
	5 merge to master or features-master with --no-ff option - no fast forward
	6 approved features/* branches must be deleted after successfull merge

fix/*
	1 branched from master or features-master
	2 manual testing
	3 open PR to master and features-master (ci testing)
	4 get approve from maintainer
	5 features-master - merge with hot fix have to be tagged
	6 master - merge with hot fix have to be tagged
