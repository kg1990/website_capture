require 'bundler/setup'
require 'padrino-core/cli/rake'

PadrinoTasks.use(:database)
PadrinoTasks.use(:sequel)
PadrinoTasks.init

namespace :workers do
  task :start do
    if system("bundle exec sidekiq -C config/sidekiq.yml -r ./config/boot.rb -d -e production")
      puts 'done!'
    else
      puts 'error!'
    end
  end

  task :stop do
    if system("sidekiqctl quiet pids/sidekiq.pid") &&
    system("sidekiqctl stop pids/sidekiq.pid")
      puts 'done!'
    else
      puts 'error!'
    end
  end

end

# Rakefile
namespace :unicorn do

  def app_root
    File.expand_path("../", __FILE__)
  end

  def app_name
    'youhaosuda_bbs'
  end

  def unicorn_pid
    File.join(app_root,'pids',"#{app_name}.pid")
  end

  desc "Start unicorn"
  task :start do
    pid_file = unicorn_pid
    if File.exists? pid_file
      abort 'Unicorn is already runing'
    else
      puts "Started and runing with pid: #{File.read pid_file}" if system("bundle exec unicorn --daemonize -c #{app_root}/unicorn.rb -E production")
    end
  end

  desc "Stop unicorn"
  task :stop do
    pid_file = unicorn_pid
    if File.exists? pid_file
      pid = File.read(pid_file).to_i
      Process.kill 0, pid
      puts "Successfully asked unicorn to stop"
    else
      puts "Unicorn is not runing. What's wrong with you?"
    end
  end

  desc "Restart unicorn"
  task :restart do
    pid_file = unicorn_pid
    old_pid_file = unicorn_pid + '.oldbin'
    abort 'unicorn is either restarting or encountered a serious crash in the previous restart attempt' if File.exists? old_pid_file
    if File.exists? pid_file
      begin
        pid = File.read(pid_file).to_i
        Process.kill 0, pid
        Process.kill "USR2", pid
        puts "Successfully asked unicorn to reload gracefully"
      rescue Errno::EPERM
        abort 'Lacking the rights to communicate with unicorn process'
      rescue Errno::ESRCH
        puts 'Something bad happened in the past. Unicorn PID is here, unicorn is not. Starting a new instance.'
        File.delete pid_file
        Rake::Task["unicorn:start"].invoke
      end
    else
      puts "Unicorn is not runing. Starting a new instance"
      Rake::Task["unicorn:start"].invoke
    end
  end

end