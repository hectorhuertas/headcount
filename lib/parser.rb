require 'csv'

module Parser

  def self.get_names(filename)
    file = CSV.open(filename, headers: true, header_converters: :symbol)
    names = file.map do |line|
      line[:location]
    end
    names.uniq
  end

  def self.parse2(info)
    @name = {}
    CSV.open(info[1], headers: true, header_converters: :symbol).reduce([]) do |array, row|
      # binding.pry
      if @name[:name] == row[:location]
       @name[:data][row[:timeframe].to_i]= row[:data].to_f.round(3)
       array << @name
      else
        # puts info[0]
        @name = {:name => row[:location], :data => {row[:timeframe].to_i => row[:data].to_f.round(3)}}
        array << @name
      end.uniq
    end
  end

  def self.parse(info)
    lines = CSV.open(info[1], headers: true, header_converters: :symbol).map do |row|
      {:name => row[:location], info[0] => {row[:timeframe].to_i => row[:data].to_i.round(3)} }
    end
    # binding.pry
    @new_hash = {}
    @diff = []
    lines.reduce([]) do |array, row|
      if @new_hash[:name] == row[:name]
      plz = @new_hash[info[0]].merge(row[info[0]])
      @new_hash = {:name => @new_hash[:name], info[0] => plz }
       array << @new_hash
      else
        @diff << @new_hash if ! @new_hash.empty?
        puts @diff
        @new_hash = row
        array << @new_hash
      end
    end
  end



end
