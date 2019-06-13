require_relative 'date'

module Checker

    def check_ticket_search_validasity(from, to, date_from, date_to, prise_from, prise_unto)
        @errors = []

        if (from =~ /[а-я]+/i) == nil || (to =~ /[а-я]+/i) == nil
            @errors << 'неправильно указан'
        end

        if date_from
            if (date_from =~ /^[\d][\d].[\d][\d]$/) != nil
                @errors << 'неправильно указана дата в графе от'
            end
        else
            @errors << 'укажите хотябы дату начала'
        end

        if date_to
            (date_to =~ /^[\d][\d].[\d][\d]$/) != nil
            @errors << 'неправильно указана дата  в графе до'
        end

    end
end