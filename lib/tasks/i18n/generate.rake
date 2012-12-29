namespace :i18n do

  desc "Generate i18n YMLs basing on template. "
  task :generate => :environment do

    require 'yaml'
    require 'fileutils'

    # Process a single file of a particular locale
    def process_file(filename, locale, output_locale)

      def assemble(templ, local)
        # If already assembling the string
        return local unless templ.is_a?(Hash)

        # If templ is a hash but local is nil, it means that the entire current 
        # branch is not yet translated. Therefore create an empty hash to act as
        # placeholder
        local = {} if local.nil?

        # Recursing to traverse hash
        pairs = templ.collect { |k, v| [k, assemble(v, local[k])] }
        Hash[pairs]
      end

      def validate(node, path)
        if node.nil?
          puts "Warning: path #{path} is nil. "
          return
        end

        return unless node.is_a?(Hash)

        node.each { |k, v| validate(v, "#{path}.#{k}") }
      end

      puts "Processing file #{filename} of locale #{locale}. "

      # Directories
      locales_dir = Rails.root.join('config/locales')
      templ_dir = locales_dir.join('template')
      local_dir = locales_dir.join(locale)
      output_dir = locales_dir.join(output_locale)

      # Loading template
      templ_file = templ_dir.join(filename)
      templ = YAML::load_file(templ_file)['template']

      # If the topmost level of the template is not 'template'
      if !templ
        puts "Warning: Template is nil for #{filename}. Aborting for this file. "
        return
      end

      # Loading localized YAML
      local_file = local_dir.join(filename)
      local = File.exists?(local_file) ? YAML::load_file(local_file)[locale] : {}

      # Alert for new file creation
      puts "Warning: Creating new file #{filename} of locale #{locale}. " unless File.exists?(local_file)

      # Assemble localized strings into template file
      assembled = assemble(templ, local)

      # Validate to find missed translations
      validate(assembled, locale)

      # Output to file
      output_file = output_dir.join(filename)
      FileUtils.mkdir_p output_file.dirname
      content = {locale => assembled}.to_yaml
      File.open(output_file, 'w') { |f| f.write(content) }

    end

    # Process all files of a single locale
    def process_locale(locale)
      # Directories
      locales_dir = Rails.root.join('config/locales')
      templ_dir = locales_dir.join('template')
      local_dir = locales_dir.join(locale)
      output_dir = locales_dir.join("#{locale}_tmp")

      # Remove temporary directory if it exists
      FileUtils.rm_rf output_dir

      # Output results to temporary directory
      Dir[templ_dir.join('**/*.yml')].each do |f|
        process_file(
          Pathname.new(f).relative_path_from(templ_dir), # Filename
          locale, # Locale
          "#{locale}_tmp" # Output locale    
        )
      end

      # Override the locales folder
      FileUtils.rm_rf local_dir
      FileUtils.mv output_dir, local_dir
    end

    # process_file('views/departments.yml', 'zh', 'zh_tmp')
    ['en', 'zh'].each do |l|
      process_locale(l)
    end

  end

end