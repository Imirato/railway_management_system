class Station
  attr_reader :trains_list

  def initialize(name)
    @name = name
    @trains_list = []
  end

  def take_train(train)
    @trains_list << train unless @trains_list.include?(train)
  end

  def send_train(train)
    @trains_list.delete(train)
  end

  def count_trains
    trains_quantity = {}
    @trains_list.group_by { |train| train.type }.each { |type, trains| trains_quantity[type] = trains.size }

    trains_quantity
  end
end
