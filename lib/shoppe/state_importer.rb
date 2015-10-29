module Shoppe
  module StateImporter
    def self.import
      
      states = File.read(File.join(Shoppe.root, 'db', 'states.txt')).gsub(/\r/, "\n").split("\n").map { |c| c.split(/\t/) }
      states.each do |code, name|
        state = State.new(:code => code, :name => name)
        state.save
      end
      
    end
  end
end
