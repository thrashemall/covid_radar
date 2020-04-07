# frozen_string_literal: true

desc 'Execute a Make file command'
task :make, %i[command] do |_t, argv|
  system "make #{argv.command}", exception: true
end
