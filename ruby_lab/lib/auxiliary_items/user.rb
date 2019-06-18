# frozen_string_literal: true

require 'securerandom'

class User
  attr_reader :id, :name, :password

  def initialize(name, password)
    @name = name
    @password = password
    @id = SecureRandom.uuid
  end

  def ==(other_user)
    if @name == other_user.name && @password == other_user.password
      true
    else
      false
    end
  end

  def to_s
    @name.to_s
  end
end
