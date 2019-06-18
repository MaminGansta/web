# frozen_string_literal: true

require_relative 'train'

# conteiner for train
class Trains
  def initialize
    @trains = {}
  end

  def add(train)
    @trains[train.id] = train
  end

  def del(id)
    @trains.delete(id)
  end

  def each(&block)
    @trains.values.each(&block)
  end

  def get(id)
    @trains[id]
  end

  def has?(id)
    @trains.key?(id)
  end
end
