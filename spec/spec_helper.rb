require_relative '../init'

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order     = "random"

  # Show color for test run status
  config.color     = true

  # Showing each test in each line instead of using dot representation
  config.formatter = :documentation
end
