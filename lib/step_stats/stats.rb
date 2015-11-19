module StepStats
  class Stats
    attr_accessor :stats

    def initialize(*args)
      @stats = {}
      @step_counter = "STEP-000"
      @steps = {}
    end

    def add_stat step_definition, duration, status, location
      step_number = get_step_number step_definition.regexp_source
      if @stats[step_number].nil?
        @stats[step_number] = Step.new(step_definition.regexp_source, step_definition.file_colon_line)
      end
      step_entry = {duration: duration, status: status, location: location}
      @stats[step_number].add step_entry
    end

    def get_step_number step_regx
      @steps[step_regx] = @step_counter.next!.dup if @steps[step_regx].nil?
      @steps[step_regx]
    end

    def percent step,rounding='ceil'
      ((step.total/total_time)*100).send(rounding)
    end

    def stats
      @stats.values.sort_by{|step| step.avg * step.count}.reverse
    end

    def top30count
      @stats.values.sort_by{|step| step.count}.reverse[0..top30]
    end

    def top30time
      @stats.values.sort_by{|step| step.avg}.reverse[0..top30]
    end

    def top30
      (@stats.values.count*0.3).ceil
    end

    def total_time
      @stats.values.inject(0){|accum,step| accum+step.total}.to_f
    end

    def to_chart_data
      @stats.values.each.map{|s|[s.name,s.total,s.location]}.to_s
    end

  end
end