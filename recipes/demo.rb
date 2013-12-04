namespace :demo do
  task :hello do
    puts "Hello World"
    puts "Hello " + hiera("hiera_message")
  end

  task :hostname do
     run("hostname", {:hosts => hiera("servers") })
  end
end
