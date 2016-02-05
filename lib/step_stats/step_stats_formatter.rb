require 'erb'
require 'cucumber/formatter/pretty'
require 'step_stats/args_stats'

module StepStats
  class Formatter < Cucumber::Formatter::Pretty
    def initialize(step_mother, io, options)
      @sss = Stats.new
      @sas = StepStats::ArgsStats.new
      super
    end

    def before_step(step)
      @start_time = `date +%s.%N`.to_f
      super
    end

    def before_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)
      @duration = `date +%s.%N`.to_f - @start_time
      @sss.add_stat(step_match.step_definition,@duration,status,file_colon_line) if @duration > 0 && !step_match.step_definition.nil?
      @sas.add_stat(step_match,@duration,status,file_colon_line) if @duration > 0 && !step_match.step_definition.nil?
      super
    end

    def after_features(*args)
      plot_graph(@sss,@sas)
      super
    end

    def plot_graph(data1,data2)
      @path = File.dirname(__FILE__)
      template = File.read(@path+"/template.erb")
      @data1 = data1.stats
      @data2 = data2.stats
      result = ERB.new(template, 0, "", "@html").result(binding)
      stats_html_file = File.new('tmp/step_stats.html','w')
      stats_html_file.write(result)
      stats_html_file.close
    end
  end
end
