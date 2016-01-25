
namespace :benchmark do
  desc "rake benchmark:import[1000] to benchmark N leads"
  task "import", [:size] => :environment do |t,params|
    unless File.exists?("leads.csv")
      Rake::Task["gen:csv[#{size}]"].execute
    end

    require 'ruby-prof'
    result = RubyProf.profile do

      importer = LeadImport.new file: 'leads.csv'
      leads = []
      total_lines = importer.lines.size - 1
      puts "will import #{total_lines} lines"
      total_time = Benchmark.realtime { leads = importer.import! }
      puts "imported #{leads.size} in #{total_time}: avg: #{(total_time / total_lines.to_f).round(2)}"
    end

    printer = RubyProf::FlatPrinter.new(result)
    printer.print(STDOUT, :min_percent=>1)

    printer = RubyProf::GraphHtmlPrinter.new(result)
    printer.print(File.new("benchmark.html", "w+"), :min_percent=>1)

    if RUBY_PLATFORM =~ /darwin/
      `open benchmark.html`
    else
      `gnome-open benchmark.html`
    end
  end

end
