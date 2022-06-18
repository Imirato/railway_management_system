# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_reader :total_seats_number, :taken_seats

  def initialize(number, total_seats_number)
    @type = 'пассажирский'
    @total_seats_number = total_seats_number
    @taken_seats = 0
    super(number)
  end

  def take_seat
    raise 'Все места уже заняты!' if @taken_seats >= @total_seats_number

    @taken_seats += 1
  end

  def free_seats
    @total_seats_number - @taken_seats
  end

  protected

  def validate!
    raise 'Количество посадочных мест не может быть меньше 1!' if @total_seats_number < 1

    super
  end
end
