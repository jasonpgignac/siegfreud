set :application, "siegfreud"
default_run_options[:pty] = true
set :deploy_to, "/Volumes/Untitled/siegfreud0.2"
set :deploy_via, :remote_cache

# SCM Data
set :scm, 'git'
set :scm_passphrase, "lamia6713"
set :repository, "git@github.com:jasonpgignac/siegfreud.git"
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false

set :user, "ptadmin"
role :app, "ussatx-xsod-001"
role :web, "ussatx-xsod-001"
role :db,  "ussatx-xsod-001", :primary => true

