require "thor"

module Charlotte
  class CLI < Thor
    desc "hello NAME", "This will greet you"
    long_desc <<-EOF

    `hello NAME` will print out a message to the person of your choosing.

    EOF
    option :upcase
    def hello( name )
      greeting = "Hello, #{name}"
      greeting.upcase! if options[:upcase]
      puts greeting
    end

    desc "version", "Print Charlotte's version information"
    def version
      puts "Charlotte version #{Charlotte::Version}"
    end
    map %w[-v --version] => :version
  end

end
