class CargoWagon < Wagon
  attr_reader :total_volume, :taken_volume

  def initialize (number, total_volume)
    @type = 'грузовой'
    @total_volume = total_volume
    @taken_volume = 0
    super(number)
  end

  def take_volume(size)
    raise "Вагон уже заполнен!" if @taken_volume >= @total_volume
    raise "Введенный объем превышает доступный!" if size > available_volume
    raise "Занимаемый объем не может быть отрицательным числом!" if size < 0
    @taken_volume += size
  end

  def available_volume
    @total_volume - @taken_volume
  end

  protected

  def validate!
    raise "Объем вагона не может быть меньше или равен 0!" if @total_volume <= 0
    super
  end
end
