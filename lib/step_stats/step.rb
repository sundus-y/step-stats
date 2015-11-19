module StepStats
  class Step
    attr_accessor :name,:definition,:location

    def initialize(step_def_name, step_def_location)
      @name = step_def_name
      @location = step_def_location
      # An Array of hashs with duration, status and location
      # step_info = {duration: 5.21692, status: :pass, location: 'feature/...feature:219'}
      @step_entries = []
    end

    def durations
      @durations || @step_entries.map{|step| step[:duration]}
    end

    def add step_entry
      @step_entries << step_entry
    end

    def min
      durations.min.to_f.round(3)
    end

    def max
      durations.max.to_f.round(3)
    end

    def avg
      (total / count.to_f).round(3)
    end

    def total
      durations.sum
    end

    def count
      durations.count
    end

    def stddev
      return 0.to_f if count == 1
      total = durations.inject(0){|accum, i| accum +(i-avg)**2 }
      variance = total/(count - 1).to_f
      Math.sqrt(variance).round(3)
    end

    def to_chart_data
      @step_entries.map(&:values).each_with_index.map do |s, index|
        step_entry = [(index + 1).to_s,s[0]]
        if s[1] == :passed
          step_entry << "green"
        else
          step_entry << "red"
        end
        step_entry << "Location: #{s[2]} \n Time: #{s[0]} seconds"
        step_entry
      end.to_s
    end
  end
end
