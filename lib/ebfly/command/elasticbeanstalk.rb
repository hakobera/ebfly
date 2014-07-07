module Ebfly
  class ElasticBeanstalk < Thor
    include Command

    desc "list-solution-stacks", "List available solution stacks"
    def list_solution_stacks
      ret = run { eb.list_available_solution_stacks() }
      debug ret

      SUPPORTED_SOLUTION_STACKS.each do |sss|
        puts ""
        puts "=== #{sss} ==="
        stacks = ret[:solution_stacks].select do |ss|
          supported = false
          supported = true if ss.include? sss
          supported
        end
        puts stacks.sort
      end
    end
  end
end
