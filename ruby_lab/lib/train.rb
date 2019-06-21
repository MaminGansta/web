# frozen_string_literal: true

require 'securerandom'

# disdcribe train
class Train
  attr_reader :number, :depart, :arrived, :d_time, :a_time, :d_date, :a_date, :id, :price

  def initialize(number, depart, arrived, d_date, a_date, d_time, a_time, price)
    @number = number
    @depart = depart
    @arrived = arrived
    @d_date = d_date
    @a_date = a_date
    @d_time = d_time
    @a_time = a_time
    @price = price
    @id = SecureRandom.uuid
  end
end
