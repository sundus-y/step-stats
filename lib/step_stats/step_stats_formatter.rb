require 'erb'
require 'cucumber/formatter/pretty'

module StepStats
  class Formatter < Cucumber::Formatter::Pretty
    def initialize(step_mother, io, options)
      @sss = Stats.new
      super
    end

    def before_step(step)
      @start_time = Time.now
      super
    end

    def before_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background, file_colon_line)
      @duration = Time.now - @start_time
      @sss.add_stat(step_match.step_definition,@duration,status,file_colon_line) if @duration > 0
      super
    end

    def after_features(*args)
      @path = File.dirname(__FILE__)
      template = File.read(@path+"/template.erb")
      @data = @sss.stats
      result = ERB.new(template, 0, "", "@html").result(binding)
      stats_html_file = File.new('tmp/step_stats.html','w')
      stats_html_file.write(result)
      stats_html_file.close
      super
    end
  end
end