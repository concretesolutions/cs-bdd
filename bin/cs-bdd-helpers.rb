require_relative '../lib/cs/bdd/zip'

def create_feature_file(name, platform = nil)
  # options used to generate the file in the template function
  opts = { name: camelize(name) }

  # If platform is not nil than the feature is OS dependent
  file_path = ''
  if platform.nil?
    file_path = File.join(FileUtils.pwd, 'features', "#{name.downcase}.feature")
    opts[:platform] = ''
  else
    file_path = File.join(
      FileUtils.pwd, 'features', platform.downcase, 'features',
      "#{name.downcase}.feature"
    )
    opts[:platform] = platform
  end

  # Thor creates a file based on the templates/feature.tt template
  template('feature', file_path, opts)
end

def create_steps_file(name, platform = nil)
  # options used to generate the file in the template function
  opts = { name: camelize(name) }

  # If platform is not nil than the step is OS dependent
  file_path = nil
  if platform.nil?
    file_path = File.join(
      FileUtils.pwd, 'features', 'step_definitions',
      "#{name.downcase}_steps.rb"
    )
    opts[:platform] = ''
  else
    file_path = File.join(
      FileUtils.pwd, 'features', platform.downcase, 'step_definitions',
      "#{name.downcase}_steps.rb"
    )
    opts[:platform] = platform
  end

  # Thor creates a file based on the templates/steps.tt template
  template('steps', file_path, opts)
end

def create_screen_file(name, platform)
  # options used to generate the file in the template function
  opts = { name: camelize(name), platform: platform }

  # Thor creates a file based on the templates/screen.tt template
  template('screen',
           File.join(
             FileUtils.pwd, 'features', platform.downcase, 'screens',
             "#{name.downcase}_screen.rb"
           ), opts)
end

def camelize(string)
  camelized = ''

  string.split('_').each do |s|
    camelized += s.capitalize
  end

  camelized
end

def in_root_project_folder?
  # Looks if the user is in the root folder of the project
  if !Dir.exist?(File.join(FileUtils.pwd, 'features', 'android', 'features')) ||
     !Dir.exist?(File.join(FileUtils.pwd, 'features', 'ios', 'features'))
    puts 'Please run this command on the root folder of the project'
    exit 1
  end

  true
end

def zip_folder(dir)
  file_name = "#{Time.now.strftime('%Y%m%d%H%M%S')}_specs.zip"
  zf = ZipFileGenerator.new(dir, file_name)
  zf.write
  file_name
end

def deprecated_warnings
  puts "
========================================= WARNING:[DEPRECATION] ===================================================================\n
 This gem has been renamed to sunomono and will no longer be supported. Please switch to sunomono as soon as possible.\n
 See:  See: https://rubygems.org/gems/sunomono \n And: https://github.com/concretesolutions/sunomono\n
====================================================================================================================================
"
end