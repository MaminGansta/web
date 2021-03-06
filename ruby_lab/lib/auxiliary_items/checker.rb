# frozen_string_literal: true

# check some information from fields
module Checker
  def self.check_ticket_search_validaty(from, to, date_from, date_to, price_from, price_unto)
    errors = []
    errors << 'неправильно указан город' if (from =~ /[а-я]+/i).nil? || (to =~ /[а-я]+/i).nil?
    errors << 'неправильно указана дата в графе от' if !date_checker(date_from)
    unless date_to.empty?
      errors << 'неправильно указана дата  в графе до' if !date_checker(date_to)
    end
    unless price_from.empty?
      errors << 'неправильно указана цена в графе От' if (price_from =~ /^[\d]+$/).nil?
    end
    unless price_unto.empty?
      errors << 'неправильно указана цена в графе До' if (price_unto =~ /^[\d]+$/).nil?
    end
    return nil if @errors.empty?

    errors
  end

  def self.date_checker(date)
    return false if (date =~ /^[\d]+.[\d]+$/).nil?

    day_month = date.split('.')
    day = day_month[0].to_i
    month = day_month[1].to_i
    return false if day.negative? && month.negative? && month > 12 && day > 31

    true
  end

  # 1 if fist greater then second, 0 if equls
  def self.date_compare(date1, date2)
    day_mont1 = date1.split('.')
    day_mont2 = date2.split('.')

    return 1 if day_mont1[1].to_i > day_mont2[1].to_i
    return -1 if day_mont1[1].to_i < day_mont2[1].to_i
    return 1 if day_mont1[0].to_i > day_mont2[0].to_i
    return -1 if day_mont1[0].to_i < day_mont2[0].to_i
    return 0 if day_mont1[0].to_i == day_mont2[0].to_i
  end

  def self.check_new_train_fields(number, depart, arrived, d_date, a_date, d_time, _a_time, _price)
    errors = []

    errors << 'неправильно указан номер' if (number =~ /[\d]+/).nil?
    errors << 'неправильно указан город' if (depart =~ /[а-я]+/i).nil? || (arrived =~ /[а-я]+/i).nil?
    errors << 'неправильно указана дата отпраления' if !date_checker(d_date)
    errors << 'неправильно указана дата прибытия' if !date_checker(a_date)
    if date_checker(a_date) && date_checker(d_date)
      errors << 'неправильно указан порядок дат' if !date_compare(d_date, a_date) == 1
    end
    errors << 'неправильно указана цена' if (number =~ /[\d]+/).nil?

    errors << 'неправильно указано время' if (d_time =~ /^[\d]+:[\d]+$/).nil? || (d_time =~ /^[\d][\d]?:[\d][\d]?$/).nil?

    return nil if errors.empty?

    errors
  end

  def self.ckeck_option_fields(city, date)
    errors = []
    errors << 'неправильно указан город' if (city =~ /[а-я]+/i).nil?

    errors << 'неправильно указана дата' if !date_checker(date)

    return nil if errors.empty?

    errors
  end
end
