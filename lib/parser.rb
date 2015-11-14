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
      done = []
      lines.each do |line|
        if done.empty?
          done << line
        elsif done.last[:name] == line [:name]
          done[-1][info[0]] = done.last[info[0]].merge(line[info[0]])
          # binding.pry
        else
          done << line
        end
      end
        done

#     new_array = []
#     name = lines.group_by {|hash| hash[:name]}
#     list_names = lines.map {|name| name[:name]}.uniq
#
#     name.each do |s, thing|
#       array = []
#         thing.each {|data| array << data[info[0]]}
#         binding.pry
#       new_array << array.reduce(:merge)
#     end
#     new_array.rotate!(new_array.count - 1 )
# binding.pry
#     list_names.map do |name|
#       new_array.rotate!
#       {:name => name, info[0] => new_array[0]}
#     end
  #   done = {}
  #   lines = CSV.open(info[1], headers: true, header_converters: :symbol).map do |row|
  #   if done.include?(:name)
  #      done[info[0]].merge!({row[:timeframe].to_i => row[:data].to_f.round(3)})
  #   else
  #
  #     done[:name] = row[:location]
  #     done[info[0]] = {row[:timeframe].to_i => row[:data].to_f.round(3)}
  #   binding.pry
  #   end
  # end
  end

end
