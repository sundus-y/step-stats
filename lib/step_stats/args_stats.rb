module StepStats
  class ArgsStats < StepStats::Stats

    def add_stat(step_match, duration, status, location)
      step_number = get_step_number step_match.format_args
      if @stats[step_number].nil?
        @stats[step_number] = Step.new(step_match.format_args, step_match.file_colon_line)
      end
      step_entry = {duration: duration, status: status, location: location}
      @stats[step_number].add step_entry
    end

    def get_step_number(format_args)
      @steps[format_args] = @step_counter.next!.dup if @steps[format_args].nil?
      @steps[format_args]
    end

  end
end
