# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

LOREM = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
ORG = 'teamtracker'

Member.create(name: 'José', organization: ORG)
Member.create(name: 'João', organization: ORG)
Member.create(name: 'Maria', organization: ORG)

Repository.create(name: 'projeto-x', organization: ORG)
Repository.create(name: 'projeto-y', organization: ORG)
Repository.create(name: 'projeto-z', organization: ORG)

Issue.create(number: 1, repo: 'projeto-x', state: 'closed', closed_at: DateTime.current - 2.days, title: 'Issue 1', body: LOREM, author: 'José', organization: ORG)
Issue.create(number: 2, repo: 'projeto-x', state: 'open', closed_at: nil, title: 'Issue 2', body: LOREM, author: 'José', organization: ORG)
Issue.create(number: 1, repo: 'projeto-y', state: 'closed', closed_at: DateTime.current - 2.days, title: 'Issue 1', body: LOREM, author: 'José', organization: ORG)
Issue.create(number: 2, repo: 'projeto-y', state: 'open', closed_at: nil, title: 'Issue 2', body: LOREM, author: 'José', organization: ORG)
Issue.create(number: 1, repo: 'projeto-z', state: 'closed', closed_at: DateTime.current - 2.days, title: 'Issue 1', body: LOREM, author: 'José', organization: ORG)
Issue.create(number: 2, repo: 'projeto-z', state: 'open', closed_at: nil, title: 'Issue 2', body: LOREM, author: 'José', organization: ORG)

Commit.create(message: 'Commit 1', author: 'José', sha: '123', files_modified: 4, additions: 150, deletions: 119, date: DateTime.current, repo: 'project-x', organization: ORG)
Commit.create(message: 'Commit 2', author: 'José', sha: '1234', files_modified: 4, additions: 150, deletions: 119, date: DateTime.current, repo: 'project-x', organization: ORG)
Commit.create(message: 'Commit 3', author: 'José', sha: '12345', files_modified: 4, additions: 150, deletions: 119, date: DateTime.current, repo: 'project-x', organization: ORG)
