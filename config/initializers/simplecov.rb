
if Rails.env.test?
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter do |src_file|
      src_file.lines.count < 8 # ignore short files like unused ApplicationJob, ApplicationMailer etc
    end
  end
end
