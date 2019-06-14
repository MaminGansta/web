require_relative '../trains'
require_relative '../train'
require_relative 'checker'

module Search

    def self.search_tickets(trains, from, to, date_from, date_to, price_from, price_unto)
        new_trains = Trains.new
        trains.each do |train|
            next if train.depart != from && train.arrived != to
            next if Checker.date_compare(train.d_date, date_from) == -1
            p Checker.date_compare(train.d_date, date_from)
            if !date_to.empty?
                next if Checker.date_compare(train.a_date, date_to) == 1
            end

            if !price_from.empty?
                next if train.price.to_i <= price_from.to_i
            end

            p price_from

            if !price_unto.empty?
                next if train.price.to_i >= price_unto.to_i
            end

            new_trains.add(train)
        end
        new_trains
    end
end