# Hndle Option values.
#
# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options.html

module Ebfly
  module Options
    NAMESPACES = {
      "asg" => "aws:autoscaling:asg",
      "launchconfiguration" => "aws:autoscaling:launchconfiguration",
      "trigger" => "aws:autoscaling:trigger",
      "rollingupdate" => "aws:autoscaling:updatepolicy:rollingupdate",
      "vpc" => "aws:ec2:vpc",
      "application" => "aws:elasticbeanstalk:application",
      "command" => "aws:elasticbeanstalk:command",
      "environment" => "aws:elasticbeanstalk:application:environment",
      "monitoring" => "aws:elasticbeanstalk:monitoring",
      "topics" => "aws:elasticbeanstalk:sns:topics",
      "sqsd" => "aws:elasticbeanstalk:sqsd",
      "healthcheck" => "aws:elb:healthcheck",
      "loadbalancer" => "aws:elb:loadbalancer",
      "policies" => "aws:elb:policies",
      "dbinstance" => "aws:rds:dbinstance",
      "hostmanager" => "aws:elasticbeanstalk:hostmanager"
    }

    def parse_option_values(option_values)
      ret = []
      option_values.each do |ov|
        k, value = ov.split('=')
        next if value.nil?
      
        ns, key = k.split('-')
        namespace = NAMESPACES[ns.strip]
        namespace = ns unless namespace
      
        ret << {
          namespace: namespace,
          option_name: key.strip,
          value: value.strip
        }
      end
      ret
    end
  end
end
