require 'csv'

module Parser

  def self.get_names(filename)
    file = CSV.open(filename, headers: true, header_converters: :symbol)
    names = file.map do |line|
      line[:location]
    end
    names.uniq
  end

  def self.parse(info)
    lines = CSV.open(info[1], headers: true, header_converters: :symbol).map do |row|
      {:name => row[:location], info[0] => {row[:timeframe].to_i => row[:data].to_f.round(3)} }
    end

    new_array = []
    name = lines.group_by { |hash| hash[:name]}
    list_names = lines.map {|name| name[:name] }.uniq


    name.each do |s, thing|
      array = []
      thing.each do |data|
        array << data[info[0]]
      end
      new_array << array.reduce(:merge)
    end
    new_array.rotate(new_array.count - 1 )
    hey = list_names.map do |name|
      new_array.rotate
      {:name => name, info[0] => new_array[0]}
      # new_array.pop if !new_array.empty?
    end
    hey
  end
end
