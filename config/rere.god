#RAILS_ROOT = ENV["RAILS_ROOT"] || "/app/rere/current"
RAILS_ROOT = "/app/rere/current"
port = 8080

# The list of ports which our website is running on. We want to setup God monitoring for each of these ports as each port has a separate master unicorn process. In our case we're just going to use one port
%w{8080}.each do |port|
  God.watch do |w|
    w.name = "rere"
    w.interval = 30.seconds # default
    # Go into the website root before starting unicorn
    w.start = "cd #{RAILS_ROOT} && bundle exec unicorn_rails -c config/unicorn.conf -E production -p #{port}"
    # -QUIT = graceful shutdown, waits for workers to finish their current request before finishing
    w.stop = "kill -QUIT `cat #{RAILS_ROOT}/tmp/pids/unicorn.pid`"
    # -USR2 = reexecute the running binary. A separate QUIT should be sent to the original process once the child is verified to be up and running.
    w.restart = "kill -USR2 `cat #{RAILS_ROOT}/tmp/pids/unicorn.pid`"
    w.start_grace = 10.seconds
    w.restart_grace = 10.seconds

    # User under which to run the process
    w.uid = 'rere'
    w.gid = 'rere'

    w.log = "#{RAILS_ROOT}/log/god-unicorn.log"
    
    # Cleanup the pid file (this is needed for processes running as a daemon)
    w.behavior(:clean_pid_file)

    # Conditions under which to start the process
    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end
    
    # Conditions under which to restart the process
    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.above = 150.megabytes
        c.times = [3, 5] # 3 out of 5 intervals
      end
    
      restart.condition(:cpu_usage) do |c|
        c.above = 50.percent
        c.times = 5
      end
    end
    
    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.to_state = [:start, :restart]
        c.times = 5
        c.within = 5.minute
        c.transition = :unmonitored
        c.retry_in = 10.minutes
        c.retry_times = 5
        c.retry_within = 2.hours
      end
    end
  end
end
