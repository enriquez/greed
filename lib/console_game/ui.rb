module ConsoleGame
  class UI
    class << self
      def in_stream=(in_stream)
        @in = in_stream
      end
  
      def out_stream=(stream)
        @out = stream
      end
  
      def puts(msg)
        @out.puts(msg) if @out
      end
      
      def print(msg)
        @out.print(msg) if @out
      end
      
      def gets
        @in ? @in.gets : ''
      end
      
      def request(msg)
        print(msg)
        gets.chomp
      end
      
      def ask(msg)
        request(msg + " [yn] ") == "y"
      end
      
      def choose(msg, options)
        prompt = msg + "\n"
        options.each_with_index do |option, i|
          prompt << "[#{i+1}] #{option}\n"
        end
        
        options[request(prompt).to_i - 1]
      end
    end
  end
end