[![Gem Version](https://badge.fury.io/rb/step-stats.svg)](https://badge.fury.io/rb/step-stats)

# Cucumber Step Stats
Cucumber formatter that generates stats on all steps that are used during testing.

## Installation

1. Add `gem 'step-stats'` to your `Gemfile`

2. Do `bundle install`

## Configuration

1. By adding `--format StepStats::Formatter` to your `cucumber.yml` file.

2. Or, use it directly when running cucumber with the option `--format StepStats::Formatter`.

## Output

The result is an HTML file which is saved in tmp/step_stats.html
#### Sample:> http://sundus-y.github.io/step_stats.html
